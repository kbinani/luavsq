--[[
  EventList.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.EventList )then

    ---
    -- 固有 ID 付きの luavsq.Event のリストを取り扱うクラス
    -- @class table
    -- @name luavsq.EventList
    luavsq.EventList = {};

    ---
    -- 初期化を行う
    -- @return (luavsq.EventList)
    function luavsq.EventList.new()
        local this = {};

        ---
        -- @var (table<luavsq.Event>)
        this._events = {};

        ---
        -- @var (table<integer>)
        this._ids = {};

        ---
        -- イベント ID を基にイベントを検索し、そのインデックスを返す
        -- @param internalId (integer) 検索するイベント ID
        -- @return (integer) 検索結果のインデックス(最初のインデックスは0)。イベントが見つからなければ負の値を返す
        function this:findIndexFromId( internalId )
            local c = #self._events;
            local i;
            for i = 1, c, 1 do
                local item = self._events[i];
                if( item.internalId == internalId )then
                    return i - 1;
                end
            end
            return -1;
        end

        ---
        -- イベント ID を基にイベントを検索し、そのオブジェクトを返す
        -- @param internal_id (integer) 検索するイベント ID
        -- @return (luavsq.Event) 検索結果のイベント。イベントが見つからなければ nil を返す
        function this:findFromId( internal_id )
            local index = self:findIndexFromId( internal_id );
            if( 0 <= index and index < #self._events )then
                return self._events[index + 1];
            else
                return nil;
            end
        end

        ---
        -- 指定されたイベント ID をもつイベントのオブジェクトを置き換える。イベントが見つからなければ何もしない
        -- @param internal_id (integer) 検索するイベント ID
        -- @param value (luavsq.Event) 置換するオブジェクト
        function this:setForId( internalId, value )
            local c = #self._events;
            local i;
            for i = 1, c, 1 do
                if( self._events[i].internalId == internalId )then
                    value.internalId = internalId;
                    self._events[i] = value;
                    break;
                end
            end
        end

        ---
        -- イベントを並べ替える
        function this:sort()
            table.sort( self._events, luavsq.Event.compare );
            self:updateIdList();
        end

        ---
        -- 全てのイベントを削除する
        function this:clear()
            self._events = {};
            self._ids = {};
        end

        ---
        -- リスト内のイベントを順に返す反復子を取得する
        -- @return (luavsq.EventList.Iterator) 反復子
        function this:iterator()
            self:updateIdList();
            return luavsq.EventList.Iterator.new( self );
        end

        ---
        -- イベントを追加する
        -- @see this:_add_1
        -- @see this:_add_2
        function this:add( ... )
            local arguments = { ... };
            if( #arguments == 1 )then
                return self:_add_1( arguments[1] );
            elseif( #arguments == 2 )then
                return self:_add_2( arguments[1], arguments[2] );
            end
            return -1;
        end

        ---
        -- イベントを追加する
        -- @param item (luavsq.Event) 追加するオブジェクト
        -- @return (integer) 追加したオブジェクトに割り振られたイベント ID
        function this:_add_1( item )
            local id = self:_getNextId( 0 );
            self:_addCor( item, id );
            table.sort( self._events, luavsq.Event.compare );
            local count = #self._events;
            local i;
            for i = 1, count, 1 do
                self._ids[i] = self._events[i].internalId;
            end
            return id;
        end

        ---
        -- イベントを追加する
        -- @param item (luavsq.Event) 追加するオブジェクト
        -- @param internal_id (integer) 追加するオブジェクトに割り振るイベント ID
        -- @return (integer) オブジェクトに割り振られたイベント ID
        function this:_add_2( item, internalId )
            self:_addCor( item, internalId );
            table.sort( self._events, luavsq.Event.compare );
            return internalId;
        end

        ---
        -- イベントを追加する
        -- @access private
        -- @param item (luavsq.Event) 追加するオブジェクト
        -- @param internal_id (integer) 追加するオブジェクトに割り振るイベント ID
        function this:_addCor( item, internalId )
            self:updateIdList();
            item.internalId = internalId;
            table.insert( self._events, item );
            table.insert( self._ids, internalId );
        end

        ---
        -- イベントを削除する
        -- @param index (integer) 削除するイベントのインデックス(最初のインデックスは0)
        function this:removeAt( index )
            self:updateIdList();
            table.remove( self._events, index + 1 );
            table.remove( self._ids, index + 1 );
        end

        ---
        -- イベントに割り振る ID を取得する
        -- @access private
        -- @param next (integer)
        -- @return [int]
        function this:_getNextId( next )
            self:updateIdList();
            local max = -1;
            local i;
            for i = 1, #self._ids, 1 do
                max = math.max( max, self._ids[i] );
            end
            return max + 1 + next;
        end

        ---
        -- イベントの個数を返す
        -- @return (integer) データ点の個数
        function this:size()
            return #self._events;
        end

        ---
        -- 指定したインデックスのイベントを取得する
        -- @param index (integer) インデックス(最初のインデックスは0)
        -- @return (luavsq.Event) イベント
        function this:get( index )
            return self._events[index + 1];
        end

        ---
        -- 指定したインデックスのイベントを設定する
        -- @param index (integer) インデックス(最初のインデックスは0)
        -- @param value (luavsq.Event) 設定するイベント
        function this:set( index, value )
            value.internalId = self._events[index + 1].internalId;
            self._events[index + 1] = value;
        end

        ---
        -- リスト内部のイベント ID のデータを更新する
        function this:updateIdList()
            if( #self._ids ~= #self._events )then
                self._ids = {};
            end
            local count = #self._events;
            local i;
            for i = 1, count, 1 do
                self._ids[i] = self._events[i].internalId;
            end
        end

        ---
        -- イベントリストをテキストストリームに出力する
        -- @param writer (luavsq.TexStream) 出力先のストリーム
        -- @param eos (integer) EOS として出力する Tick 単位の時刻
        -- @return (table<luavsq.Handle>) リスト中のイベントに含まれるハンドルの一覧
        function this:write( writer, eos )
            local handles = self:_buildHandleList();
            writer:writeLine( "[EventList]" );
            local temp = {};
            local itr = self:iterator();
            while( itr:hasNext() )do
                table.insert( temp, itr:next() );
            end
            table.sort( temp, luavsq.Event.compare );
            local i = 1;
            while( i <= #temp )do
                local item = temp[i];
                if( not item.id:isEOS() )then
                    local ids = "ID#" .. string.format( "%04d", item.id.value );
                    local clock = temp[i].clock;
                    while( i + 1 <= #temp and clock == temp[i + 1].clock )do
                        i = i + 1;
                        ids = ids .. ",ID#" .. string.format( "%04d", temp[i].id.value );
                    end
                    writer:writeLine( clock .. "=" .. ids );
                end
                i = i + 1;
            end
            writer:writeLine( eos .. "=EOS" );
            return handles;
        end

        ---
        -- リスト内のイベントから、ハンドルの一覧を作成する。同時に、各イベント、ハンドルの番号を設定する
        -- @access private
        -- @return (table<luavsq.Handle>) ハンドルの一覧
        function this:_buildHandleList()
            local handle = {};
            local current_id = -1;
            local current_handle = -1;
            local add_quotation_mark = true;
            local itr = self:iterator();
            while( itr:hasNext() )do
                local item = itr:next();
                current_id = current_id + 1;
                item.id.value = current_id;
                -- SingerHandle
                if( item.id.singerHandle ~= nil )then
                    local ish = item.id.singerHandle;
                    current_handle = current_handle + 1;
                    local handle_item = ish:castToHandle();
                    handle_item.index = current_handle;
                    table.insert( handle, handle_item );
                    item.id.singerHandleIndex = current_handle;
                    local lang = luavsq.VoiceLanguageEnum.valueFromSingerName( ish.ids );
                    add_quotation_mark = lang == luavsq.VoiceLanguageEnum.Japanese;
                end
                -- LyricHandle
                if( item.id.lyricHandle ~= nil )then
                    current_handle = current_handle + 1;
                    local handle_item = item.id.lyricHandle:castToHandle();
                    handle_item.index = current_handle;
                    handle_item.addQuotationMark = add_quotation_mark;
                    table.insert( handle, handle_item );
                    item.id.lyricHandleIndex = current_handle;
                end
                -- VibratoHandle
                if( item.id.vibratoHandle ~= nil )then
                    current_handle = current_handle + 1;
                    local handle_item = item.id.vibratoHandle:castToHandle();
                    handle_item.index = current_handle;
                    table.insert( handle, handle_item );
                    item.id.vibratoHandleIndex = current_handle;
                end
                -- NoteHeadHandle
                if( item.id.noteHeadHandle ~= nil )then
                    current_handle = current_handle + 1;
                    local handle_item = item.id.noteHeadHandle:castToHandle();
                    handle_item.index = current_handle;
                    table.insert( handle, handle_item );
                    item.id.noteHeadHandleIndex = current_handle;
                end
                -- IconDynamicsHandle
                if( item.id.iconDynamicsHandle ~= nil )then
                    current_handle = current_handle + 1;
                    local handle_item = item.id.iconDynamicsHandle:castToHandle();
                    handle_item.index = current_handle;
                    handle_item:setLength( item.id:getLength() );
                    table.insert( handle, handle_item );
                    item.id.singerHandleIndex = current_handle;
                end
            end
            return handle;
        end

        return this;
    end

end
