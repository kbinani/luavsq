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

local table = table;
local string = string;
local math = math;

module( "luavsq" );

---
-- 固有 ID 付きの {@link Event} のリストを取り扱うクラス
-- @class table
-- @name EventList
if( nil == EventList )then
    EventList = {};
end

---
-- 初期化を行う
-- @return (EventList)
-- @access static ctor
function EventList.new()
    local this = {};

    ---
    -- @var table<Event>
    -- @access private
    this._events = {};

    ---
    -- @var table<int>
    -- @access private
    this._ids = {};

    ---
    -- イベント ID を基にイベントを検索し、そのインデックスを返す
    -- @param internalId (int) 検索するイベント ID
    -- @return (int) 検索結果のインデックス(最初のインデックスは0)。イベントが見つからなければ負の値を返す
    function this:findIndexFromId( internalId )
        local c = #self._events;
        local i;
        for i = 1, c, 1 do
            local item = self._events[i];
            if( item.id == internalId )then
                return i - 1;
            end
        end
        return -1;
    end

    ---
    -- イベント ID を基にイベントを検索し、そのオブジェクトを返す
    -- @param internalId (int) 検索するイベント ID
    -- @return (Event) 検索結果のイベント。イベントが見つからなければ <code>nil</code> を返す
    function this:findFromId( internalId )
        local index = self:findIndexFromId( internalId );
        if( 0 <= index and index < #self._events )then
            return self._events[index + 1];
        else
            return nil;
        end
    end

    ---
    -- 指定されたイベント ID をもつイベントのオブジェクトを置き換える。イベントが見つからなければ何もしない
    -- @param internalId (int) 検索するイベント ID
    -- @param value (Event) 置換するオブジェクト
    function this:setForId( internalId, value )
        local c = #self._events;
        local i;
        for i = 1, c, 1 do
            if( self._events[i].id == internalId )then
                value.id = internalId;
                self._events[i] = value;
                break;
            end
        end
    end

    ---
    -- イベントを並べ替える
    function this:sort()
        table.sort( self._events, Event.compare );
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
    -- @return (EventList.Iterator) 反復子
    function this:iterator()
        self:updateIdList();
        return EventList.Iterator.new( self );
    end

    --
    -- イベントを追加する
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
    -- @param item (Event) 追加するオブジェクト
    -- @return (int) 追加したオブジェクトに割り振られたイベント ID
    -- @name add<!--1-->
    function this:_add_1( item )
        local id = self:_getNextId( 0 );
        self:_addCor( item, id );
        table.sort( self._events, Event.compare );
        local count = #self._events;
        local i;
        for i = 1, count, 1 do
            self._ids[i] = self._events[i].id;
        end
        return id;
    end

    ---
    -- イベントを追加する
    -- @param item (Event) 追加するオブジェクト
    -- @param internalId (int) 追加するオブジェクトに割り振るイベント ID
    -- @return (int) オブジェクトに割り振られたイベント ID
    -- @name add<!--2-->
    function this:_add_2( item, internalId )
        self:_addCor( item, internalId );
        table.sort( self._events, Event.compare );
        return internalId;
    end

    ---
    -- イベントを追加する
    -- @param item (Event) 追加するオブジェクト
    -- @param internal_id (int) 追加するオブジェクトに割り振るイベント ID
    -- @access private
    function this:_addCor( item, internalId )
        self:updateIdList();
        item.id = internalId;
        table.insert( self._events, item );
        table.insert( self._ids, internalId );
    end

    ---
    -- イベントを削除する
    -- @param index (int) 削除するイベントのインデックス(最初のインデックスは0)
    function this:removeAt( index )
        self:updateIdList();
        table.remove( self._events, index + 1 );
        table.remove( self._ids, index + 1 );
    end

    ---
    -- イベントに割り振る ID を取得する
    -- @param next (int)
    -- @return (int)
    -- @access private
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
    -- @return (int) データ点の個数
    function this:size()
        return #self._events;
    end

    ---
    -- 指定したインデックスのイベントを取得する
    -- @param index (int) インデックス(最初のインデックスは0)
    -- @return (Event) イベント
    function this:get( index )
        return self._events[index + 1];
    end

    ---
    -- 指定したインデックスのイベントを設定する
    -- @param index (int) インデックス(最初のインデックスは0)
    -- @param value (Event) 設定するイベント
    function this:set( index, value )
        value.id = self._events[index + 1].id;
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
            self._ids[i] = self._events[i].id;
        end
    end

    ---
    -- イベントリストをテキストストリームに出力する
    -- @param stream (TextStream) 出力先のストリーム
    -- @param eos (int) EOS として出力する Tick 単位の時刻
    -- @return (table<Handle>) リスト中のイベントに含まれるハンドルの一覧
    function this:write( stream, eos )
        local handles = self:_buildHandleList();
        stream:writeLine( "[EventList]" );
        local temp = {};
        local itr = self:iterator();
        while( itr:hasNext() )do
            table.insert( temp, itr:next() );
        end
        table.sort( temp, Event.compare );
        local i = 1;
        while( i <= #temp )do
            local item = temp[i];
            if( not item:isEOS() )then
                local ids = "ID#" .. string.format( "%04d", item.index );
                local clock = temp[i].clock;
                while( i + 1 <= #temp and clock == temp[i + 1].clock )do
                    i = i + 1;
                    ids = ids .. ",ID#" .. string.format( "%04d", temp[i].index );
                end
                stream:writeLine( clock .. "=" .. ids );
            end
            i = i + 1;
        end
        stream:writeLine( eos .. "=EOS" );
        return handles;
    end

    ---
    -- リスト内のイベントから、ハンドルの一覧を作成する。同時に、各イベント、ハンドルの番号を設定する
    -- @return (table<Handle>) ハンドルの一覧
    -- @access private
    function this:_buildHandleList()
        local handle = {};
        local current_id = -1;
        local current_handle = -1;
        local add_quotation_mark = true;
        local itr = self:iterator();
        while( itr:hasNext() )do
            local item = itr:next();
            current_id = current_id + 1;
            item.index = current_id;
            -- SingerHandle
            if( item.singerHandle ~= nil )then
                current_handle = current_handle + 1;
                item.singerHandle.index = current_handle;
                table.insert( handle, item.singerHandle );
                item._singerHandleIndex = current_handle;
                local lang = VoiceLanguageEnum.valueFromSingerName( item.singerHandle.ids );
                add_quotation_mark = lang == VoiceLanguageEnum.JAPANESE;
            end
            -- LyricHandle
            if( item.lyricHandle ~= nil )then
                current_handle = current_handle + 1;
                item.lyricHandle.index = current_handle;
                item.lyricHandle.addQuotationMark = add_quotation_mark;
                table.insert( handle, item.lyricHandle );
                item._lyricHandleIndex = current_handle;
            end
            -- VibratoHandle
            if( item.vibratoHandle ~= nil )then
                current_handle = current_handle + 1;
                item.vibratoHandle.index = current_handle;
                table.insert( handle, item.vibratoHandle );
                item._vibratoHandleIndex = current_handle;
            end
            -- NoteHeadHandle
            if( item.noteHeadHandle ~= nil )then
                current_handle = current_handle + 1;
                item.noteHeadHandle.index = current_handle;
                table.insert( handle, item.noteHeadHandle );
                item._noteHeadHandleIndex = current_handle;
            end
            -- IconDynamicsHandle
            if( item.iconDynamicsHandle ~= nil )then
                current_handle = current_handle + 1;
                item.iconDynamicsHandle.index = current_handle;
                item.iconDynamicsHandle:setLength( item:getLength() );
                table.insert( handle, item.iconDynamicsHandle );
                -- IconDynamicsHandleは、歌手ハンドルと同じ扱いなので
                -- _singerHandleIndexでよい
                item._singerHandleIndex = current_handle;
            end
        end
        return handle;
    end

    return this;
end
