--[[
  BPList.js
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local math = math;
local table = table;

module( "luavsq" );

---
-- コントロールカーブのデータ点リストを表すクラス
-- @class table
-- @name BPList
if( nil == BPList )then
    BPList = {};
end

---
-- 初期化を行う
-- @param name (string) コントロールカーブの名前
-- @param defaultValue (integer) コントロールカーブのデフォルト値
-- @param minimum (integer) コントロールカーブの最小値
-- @param maximum (integer) コントロールカーブの最大値
-- @return (BPList)
-- @name new
-- @access static ctor
-- @class function

---
-- コンストラクタ
-- @return (BPList)
-- @access static private
function BPList.new( ... )
    local this = {};
    local arguments = { ... };
    this._clocks = nil;
    this._items = nil;
    this._length = 0; -- clocks, itemsに入っているアイテムの個数
    this._defaultValue = 0;
    this._maxValue = 127;
    this._minValue = 0;
    this._maxId = 0;
    this._name = "";

    ---
    -- 初期化を行う
    -- @param name (string) コントロールカーブの名前
    -- @param defaultValue (integer) コントロールカーブのデフォルト値
    -- @param minimum (integer) コントロールカーブの最小値
    -- @param maximum (integer) コントロールカーブの最大値
    -- @return (BPList)
    -- @access private
    function this:_init_4( name, defaultValue, minimum, maximum )
        self._name = name;
        self._defaultValue = defaultValue;
        self._maxValue = maximum;
        self._minValue = minimum;
        self._maxId = 0;
    end

    ---
    -- データ点を格納するバッファを確保する
    -- @access private
    -- @param length (integer) 確保するバッファの最小長さ
    function this:_ensureBufferLength( length )
        if( self._clocks == nil )then
            self._clocks = {};
        end
        if( self._items == nil )then
            self._items = {};
        end
        if( length > #self._clocks )then
            local newLength = length;
            if( #self._clocks <= 0 )then
                newLength = math.floor( length * 1.2 );
            else
                local order = math.floor( length / #self._clocks );
                if( order <= 1 )then
                    order = 2;
                end
                newLength = #self._clocks * order;
            end
            local delta = newLength - #self._clocks;
            local i;
            for i = 1, delta, 1 do
                table.insert( self._clocks, 0 );
                table.insert( self._items, BP.new() );
            end
        end
    end

    ---
    -- コントロールカーブの名前を取得する
    -- @return (string) コントロールカーブの名前
    function this:getName()
        if( self._name == nil )then
            self._name = "";
        end
        return self._name;
    end

    ---
    -- コントロールカーブの名前を設定する
    -- @param value (string) コントロールカーブの名前
    function this:setName( value )
        if( value == nil )then
            self._name = "";
        else
            self._name = value;
        end
    end

    ---
    -- このリスト内で使用されている ID の最大値を取得する
    -- @return (integer) 使用されている ID の最大値
    function this:getMaxId()
        return self._maxId;
    end

    ---
    -- コントロールカーブのデフォルト値を取得する
    -- @return (integer) コントロールカーブのデフォルト値
    function this:getDefault()
        return self._defaultValue;
    end

    ---
    -- コントロールカーブのデフォルト値を設定する
    -- @param value (integer) コントロールカーブのデフォルト値
    function this:setDefault( value )
        self._defaultValue = value;
    end

    --[[
        -- データ点の ID を一度クリアし，新たに番号付けを行います．
        -- ID は，Redo, Undo 用コマンドが使用するため，このメソッドを呼ぶと Redo, Undo 操作が破綻する．XML からのデシリアライズ直後のみ使用するべき．
        -- @return [void]
        function this:renumberIds()
            self._maxId = 0;
            local i;
            for i = 1, self._length, 1 do
                self._maxId = self._maxId + 1;
                self._items[i].id = self._maxId;
            end
        end]]

    --[[
        -- @return [string]
        function this:getData()
            local ret = "";
            local i;
            for i = 1, self._length, 1 do
                if( i > 1 )then
                    ret = ret .. ",";
                end
                ret = ret .. self._clocks[i] .. "=" + self._items[i].value;
            end
            return ret;
        end

        --
        -- @param value [string]
        -- @return [void]
        function this:setData( value )
            self._length = 0;
            self._maxId = 0;
            var spl = value.split( ',' );
            for ( var i = 0; i < spl.length; i++ ) {
                var spl2 = spl[i].split( '=' );
                if ( spl2.length < 2 ) {
                    continue;
                }
                var clock = parseInt( spl2[0], 10 );
                if( !isNaN( clock ) ){
                    self._ensureBufferLength( self._length + 1 );
                    self._clocks[self._length] = clock;
                    self._items[self._length] = new org.kbinani.vsq.VsqBPPair( parseInt( spl2[1], 10 ), self._maxId + 1 );
                    self._maxId++;
                    self._length++;
                }
            }
        end]]

    ---
    -- コピーを作成する
    -- @return (BPList) このオブジェクトのコピー
    function this:clone()
        local res = BPList.new( self._name, self._defaultValue, self._minValue, self._maxValue );
        res:_ensureBufferLength( self._length );
        local i;
        for i = 1, self._length, 1 do
            res._clocks[i] = self._clocks[i];
            res._items[i] = self._items[i]:clone();
        end
        res._length = self._length;
        res._maxId = self._maxId;
        return res;
    end

    ---
    -- コントロールカーブの最大値を取得する
    -- @return (integer) コントロールカーブの最大値
    function this:getMaximum()
        return self._maxValue;
    end

    ---
    -- コントロールカーブの最大値を設定する
    -- @param value (integer) コントロールカーブの最大値
    function this:setMaximum( value )
        self._maxValue = value;
    end

    ---
    -- コントロールカーブの最小値を取得する
    -- @return (integer) コントロールカーブの最小値
    function this:getMinimum()
        return self._minValue;
    end

    ---
    -- コントロールカーブの最小値を設定する
    -- @param value (integer) コントロールカーブの最小値
    function this:setMinimum( value )
        self._minValue = value;
    end

    --[[
        -- @param clock (integer)
        -- @return [void]
        function this:remove( clock )
            self:_ensureBufferLength( self._length );
            local index = self:_find( clock );
            self:removeElementAt( index );
        end]]

    --[[
        -- @param index (integer)
        -- @return [void]
        function this:removeElementAt( index )
            index = index + 1;
            if( index >= 1 )then
                local i;
                for i = index + 1, self._length - 1, 1 do
                    self._clocks[i] = self._clocks[i + 1];
                    self._items[i].value = self._items[i + 1].value;
                    self._items[i].id = self._items[i + 1].id;
                end
                self._length = self._length - 1;
            end
        end]]

    ---
    -- 指定された時刻にデータ点が存在するかどうかを調べる
    -- @param clock (integer) Tick 単位の時刻
    -- @return (boolean) データ点が存在すれば <code>ture</code> を、そうでなければ <code>false</code> を返す
    function this:isContainsKey( clock )
        self:_ensureBufferLength( self._length );
        return (self:_find( clock ) >= 0);
    end

    --[[
        -- 時刻clockのデータを時刻new_clockに移動します。
        -- 時刻clockにデータがなければ何もしない。
        -- 時刻new_clockに既にデータがある場合、既存のデータは削除される。
        --
        -- @param clock (integer)
        -- @param new_clock (integer)
        -- @param new_value (integer)
        -- @return [void]
        function this:move( clock, new_clock, new_value )
            self:_ensureBufferLength( self._length );
            local index = self:_find( clock );
            if( index < 0 )then
                return;
            end
            local item = self._items[index + 1];
            local i;
            for i = index + 1, self._length - 2, 1 do
                self._clocks[i] = self._clocks[i + 1];
                self._items[i].value = self._items[i + 1].value;
                self._items[i].id = self._items[i + 1].id;
            end
            self._length = self._length - 1;
            local index_new = self:_find( new_clock );
            if( index_new >= 0 )then
                self._items[index_new + 1].value = new_value;
                self._items[index_new + 1].id = item.id;
                return;
            else
                self._length = self._length + 1;
                self:_ensureBufferLength( self._length );
                self._clocks[self._length] = new_clock;
                Util.sort( self._clocks, 0, self._length );
                index_new = self:_find( new_clock );
                --item.value = new_value;
                local i;
                for i = self._length, index_new + 2, -1 do
                    self._items[i].value = self._items[i - 1].value;
                    self._items[i].id = self._items[i - 1].id;
                end
                self._items[index_new + 1].value = new_value;
                self._items[index_new + 1].id = item.id;
            end
        end]]

    ---
    -- 全てのデータ点を削除する
    function this:clear()
        self._length = 0;
    end

    ---
    -- データ点の値を取得する
    -- @param index (integer) 取得するデータ点のインデックス(最初のインデックスは0)
    -- @return (integer) データ点の値
    function this:getValue( index )
        return self._items[index + 1].value;
    end

    ---
    -- データ点を取得する
    -- @param index (integer) 取得するデータ点のインデックス(最初のインデックスは0)
    -- @return (BP) データ点のインスタンス
    function this:get( index )
        return self._items[index + 1]:clone();
    end

    ---
    -- データ点の時刻を取得する
    -- @param index (integer) 取得するデータ点のインデックス(最初のインデックスは0)
    -- @return (integer) データ点の Tick 単位の時刻
    function this:getKeyClock( index )
        return self._clocks[index + 1];
    end

    ---
    -- ID を基にデータ点の値を取得する
    -- @param id (integer) データ点の ID
    -- @return (integer) データ点の値
    function this:findValueFromId( id )
        local i;
        for i = 1, self._length, 1 do
            local item = self._items[i];
            if( item.id == id )then
                return item.value;
            end
        end
        return self._defaultValue;
    end

    ---
    -- ID を基にデータ点を検索し、検索結果を取得する
    -- @param id (integer) データ点の ID
    -- @return (BPListSearchResult) 検索結果を格納したオブジェクト
    function this:findElement( id )
        local context = BPListSearchResult.new();
        local i;
        for i = 1, self._length, 1 do
            local item = self._items[i];
            if( item.id == id )then
                context.clock = self._clocks[i];
                context.index = i - 1;
                context.point = item:clone();
                return context;
            end
        end
        context.clock = -1;
        context.index = -1;
        context.point = BP.new( self._defaultValue, -1 );
        return context;
    end

    ---
    -- 指定した ID のデータ点の値を設定する
    -- @param id (integer) データ点の ID
    -- @param value (integer) 設定するデータ点の値
    function this:setValueForId( id, value )
        local i;
        for i = 1, self._length, 1 do
            if( self._items[i].id == id )then
                self._items[i].value = value;
                break;
            end
        end
    end

    ---
    -- コントロールカーブをテキストストリームに出力する
    -- @param stream (TextStream) 出力先のストリーム
    -- @param startClock (integer) Tick 単位の出力開始時刻
    -- @param header (string) 最初に出力するヘッダー文字列
    function this:print( stream, startClock, header )
        stream:writeLine( header );
        local lastvalue = self._defaultValue;
        local value_at_start_written = false;
        local i;
        for i = 1, self._length, 1 do
            local key = self._clocks[i];
            if( startClock == key )then
                stream:writeLine( key .. "=" .. self._items[i].value );
                value_at_start_written = true;
            elseif( startClock < key )then
                if( (not value_at_start_written) and (lastvalue ~= self._defaultValue) )then
                    stream:writeLine( startClock .. "=" .. lastvalue );
                    value_at_start_written = true;
                end
                local val = self._items[i].value;
                stream:writeLine( key .. "=" .. val );
            else
                lastvalue = self._items[i].value;
            end
        end
        if( (not value_at_start_written) and (lastvalue ~= self._defaultValue) )then
            stream:writeLine( startClock .. "=" .. lastvalue );
        end
    end

    --[[
        -- テキストファイルからデータ点を読込み、現在のリストに追加します
        -- @param reader [TextStream]
        -- @return [string]
        function this:appendFromText( reader )
            local clock = 0;
            local value = 0;
            local minus = 1;
            local mode = 0; -- 0: clockを読んでいる, 1: valueを読んでいる
            while( reader:ready() )do
                local ch = reader:get();
                if( ch == '\n' )then
                    if( mode == 1 )then
                        self:addWithoutSort( clock, value * minus );
                        mode = 0;
                        clock = 0;
                        value = 0;
                        minus = 1;
                    end
                else
                    if( ch == '[' )then
                        if( mode == 1 )then
                            self:addWithoutSort( clock, value * minus );
                            mode = 0;
                            clock = 0;
                            value = 0;
                            minus = 1;
                        end
                        reader:setPointer( reader:getPointer() - 1 );
                        break;
                    end
                    if( ch == '=' )then
                        mode = 1;
                    elseif( ch == '-' )then
                        minus = -1;
                    else
                        local num = -1;
                        if( ch == '0' )then
                            num = 0;
                        elseif( ch == '1' )then
                            num = 1;
                        elseif( ch == '2' )then
                            num = 2;
                        elseif( ch == '3' )then
                            num = 3;
                        elseif( ch == '4' )then
                            num = 4;
                        elseif( ch == '5' )then
                            num = 5;
                        elseif( ch == '6' )then
                            num = 6;
                        elseif( ch == '7' )then
                            num = 7;
                        elseif( ch == '8' )then
                            num = 8;
                        elseif( ch == '9' )then
                            num = 9;
                        end
                        if( num >= 0 )then
                            if( mode == 0 )then
                                clock = clock * 10 + num;
                            else
                                value = value * 10 + num;
                            end
                        end
                    end
                end
            end
            return reader:readLine();
        end]]

    ---
    -- データ点の個数を返す
    -- @return (integer) データ点の個数
    function this:size()
        return self._length;
    end

    ---
    -- データ点の Tick 単位の時刻を昇順に返す反復子を取得する
    -- @return (BPList.KeyClockIterator) 反復子のインスタンス
    function this:keyClockIterator()
        return BPList.KeyClockIterator.new( self );
    end

    ---
    -- 指定された時刻値を持つデータ点のインデックスを検索する
    -- @param value (integer) Tick 単位の時刻
    -- @return (integer) データ点のインデックス(最初のインデックスは0)。データ点が見つからなかった場合は負の値を返す
    -- @access private
    function this:_find( value )
        local i;
        for i = 1, self._length, 1 do
            if( self._clocks[i] == value )then
                return i - 1;
            end
        end
        return -1;
    end

    ---
    -- 並べ替え、既存の値との重複チェックを行わず、リストの末尾にデータ点を追加する
    -- @param clock (integer) Tick 単位の時刻
    -- @param value (integer) データ点の値
    function this:addWithoutSort( clock, value )
        self:_ensureBufferLength( self._length + 1 );
        self._clocks[self._length + 1] = clock;
        self._maxId = self._maxId + 1;
        self._items[self._length + 1].value = value;
        self._items[self._length + 1].id = self._maxId;
        self._length = self._length + 1;
    end

    ---
    -- データ点を追加する。指定された時刻に既にデータ点がある場合、データ点の値を上書きする
    -- @param clock (integer) データ点を追加する Tick 単位の時刻
    -- @param value (integer) データ点の値
    -- @return (integer) データ点の ID
    function this:add( clock, value )
        self:_ensureBufferLength( self._length );
        local index = self:_find( clock );
        if( index >= 0 )then
            self._items[index + 1].value = value;
            return self._items[index + 1].id;
        else
            self._length = self._length + 1;
            self:_ensureBufferLength( self._length );
            self._clocks[self._length] = clock;
            Util.sort( self._clocks, 0, self._length );
            index = self:_find( clock );
            self._maxId = self._maxId + 1;
            local i;
            for i = self._length, index + 2, -1 do
                self._items[i].value = self._items[i - 1].value;
                self._items[i].id = self._items[i - 1].id;
            end
            self._items[index + 1].value = value;
            self._items[index + 1].id = self._maxId;
            return self._maxId;
        end
    end

    ---
    -- データ点を、ID 指定したうえで追加する。指定された時刻に既にデータ点がある場合、データ点の値を上書きする
    -- @param clock (integer) データ点を追加する Tick 単位の時刻
    -- @param value (integer) データ点の値
    -- @param id (integer) データ点の ID
    -- @return (integer) データ点の ID
    function this:addWithId( clock, value, id )
        self:_ensureBufferLength( self._length );
        local index = self:_find( clock );
        if( index >= 0 )then
            self._items[index + 1].value = value;
            self._items[index + 1].id = id;
        else
            self._length = self._length + 1;
            self:_ensureBufferLength( self._length );
            self._clocks[self._length] = clock;
            Util.sort( self._clocks, 0, self._length );
            index = self:_find( clock );
            local i;
            for i = self._length, index + 2, -1 do
                self._items[i].value = self._items[i - 1].value;
                self._items[i].id = self._items[i - 1].id;
            end
            self._items[index + 1].value = value;
            self._items[index + 1].id = id;
        end
        self._maxId = math.max( self._maxId, id );
        return id;
    end

    --[[
        -- @param id [long]
        -- @return [void]
        function this:removeWithId( id )
            local i;
            for i = 1, self._length, 1 do
                if( self._items[i].id == id )then
                    local j;
                    for j = i, self._length - 1, 1 do
                        self._items[j].value = self._items[j + 1].value;
                        self._items[j].id = self._items[j + 1].id;
                        self._clocks[j] = self._clocks[j + 1];
                    end
                    self._length = self._length - 1;
                    break;
                end
            end
        end]]

    --
    -- 指定された Tick 単位の時刻における、コントロールパラメータの値を取得する
    function this:getValueAt( ... )
        local arguments = { ... };
        if( #arguments == 2 )then
            return self:_getValueAt_2( arguments[1], arguments[2] );
        elseif( #arguments == 1 )then
            return self:_getValueAt_1( arguments[1] );
        end
    end

    ---
    -- 指定された Tick 単位の時刻における，コントロールパラメータの値を取得する．
    -- @param clock (integer) 値を取得する Tick 単位の時刻
    -- @return (integer) コントロールパラメータの値
    -- @name getValueAt<!--1-->
    function this:_getValueAt_1( clock )
        self:_ensureBufferLength( self._length );
        local index = self:_find( clock );
        if( index >= 0 )then
            return self._items[index + 1].value;
        else
            if( self._length <= 0 )then
                return self._defaultValue;
            else
                local draft = 0;
                local i;
                for i = 1, self._length, 1 do
                    local c = self._clocks[i];
                    if( clock < c )then
                        break;
                    end
                    draft = i;
                end
                if( draft == 0 )then
                    return self._defaultValue;
                else
                    return self._items[draft].value;
                end
            end
        end
    end

    ---
    -- 指定された Tick 単位の時刻における、コントロールパラメータの値を取得する
    -- @param clock (integer) 値を取得する Tick 単位の時刻
    -- @param index (table) 値の取得に使用したインデックス(最初のインデックスは0)
    -- @return (integer) コントロールパラメータの値
    -- @name getValueAt<!--2-->
    function this:_getValueAt_2( clock, index )
        if( self._length == 0 )then
            return self._defaultValue;
        else
            if( index.value < 0 )then
                index.value = 0;
            end
            if( index.value > 0 and clock < self._clocks[index.value + 1] )then
                index.value = 0;
            end
            local i;
            for i = index.value + 1, self._length, 1 do
                local keyclock = self._clocks[i];
                if( clock < keyclock )then
                    if( i > 1 )then
                        index.value = i - 2;
                        return self._items[i - 1].value;
                    else
                        index.value = 0;
                        return self._defaultValue;
                    end
                end
            end
            index.value = self._length - 1;
            return self._items[self._length].value;
        end
    end

    if( #arguments == 4 )then
        this:_init_4( arguments[1], arguments[2], arguments[3], arguments[4] );
    end

    return this;
end

BPList.INIT_BUFLEN = 512;
