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
BPList = {};

---
-- コンストラクタ
-- @see BPList:_init_4
-- @return (BPList)
-- @name <i>new</i>
function BPList.new( ... )
    local this = {};
    local arguments = { ... };
    this.clocks = nil;
    this.items = nil;
    this._length = 0; -- clocks, itemsに入っているアイテムの個数
    this.defaultValue = 0;
    this.maxValue = 127;
    this.minValue = 0;
    this.maxId = 0;
    this.name = "";

    ---
    -- 初期化を行う
    -- @param name (string) コントロールカーブの名前
    -- @param defaultValue (integer) コントロールカーブのデフォルト値
    -- @param minimum (integer) コントロールカーブの最小値
    -- @param maximum (integer) コントロールカーブの最大値
    -- @name _init_4
    function this:_init_4( name, defaultValue, minimum, maximum )
        self.name = name;
        self.defaultValue = defaultValue;
        self.maxValue = maximum;
        self.minValue = minimum;
        self.maxId = 0;
    end

    --
    -- データ点を格納するバッファを確保する
    -- @access private
    -- @param length (integer) 確保するバッファの最小長さ
    function this:_ensureBufferLength( length )
        if( self.clocks == nil )then
            self.clocks = {};
        end
        if( self.items == nil )then
            self.items = {};
        end
        if( length > #self.clocks )then
            local newLength = length;
            if( #self.clocks <= 0 )then
                newLength = math.floor( length * 1.2 );
            else
                local order = math.floor( length / #self.clocks );
                if( order <= 1 )then
                    order = 2;
                end
                newLength = #self.clocks * order;
            end
            local delta = newLength - #self.clocks;
            local i;
            for i = 1, delta, 1 do
                table.insert( self.clocks, 0 );
                table.insert( self.items, BP.new() );
            end
        end
    end

    ---
    -- コントロールカーブの名前を取得する
    -- @return (string) コントロールカーブの名前
    -- @name getName
    function this:getName()
        if( self.name == nil )then
            self.name = "";
        end
        return self.name;
    end

    ---
    -- コントロールカーブの名前を設定する
    -- @param value (string) コントロールカーブの名前
    -- @name setName
    function this:setName( value )
        if( value == nil )then
            self.name = "";
        else
            self.name = value;
        end
    end

    ---
    -- このリスト内で使用されている ID の最大値を取得する
    -- @return (integer) 使用されている ID の最大値
    -- @name getMaxId
    function this:getMaxId()
        return self.maxId;
    end

    ---
    -- コントロールカーブのデフォルト値を取得する
    -- @return (integer) コントロールカーブのデフォルト値
    -- @name getDefault
    function this:getDefault()
        return self.defaultValue;
    end

    ---
    -- コントロールカーブのデフォルト値を設定する
    -- @param value (integer) コントロールカーブのデフォルト値
    -- @name setDefault
    function this:setDefault( _value )
        self.defaultValue = _value;
    end

    --[[
        -- データ点の ID を一度クリアし，新たに番号付けを行います．
        -- ID は，Redo, Undo 用コマンドが使用するため，このメソッドを呼ぶと Redo, Undo 操作が破綻する．XML からのデシリアライズ直後のみ使用するべき．
        -- @return [void]
        function this:renumberIds()
            self.maxId = 0;
            local i;
            for i = 1, self._length, 1 do
                self.maxId = self.maxId + 1;
                self.items[i].id = self.maxId;
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
                ret = ret .. self.clocks[i] .. "=" + self.items[i].value;
            end
            return ret;
        end

        --
        -- @param value [string]
        -- @return [void]
        function this:setData( value )
            self._length = 0;
            self.maxId = 0;
            var spl = value.split( ',' );
            for ( var i = 0; i < spl.length; i++ ) {
                var spl2 = spl[i].split( '=' );
                if ( spl2.length < 2 ) {
                    continue;
                }
                var clock = parseInt( spl2[0], 10 );
                if( !isNaN( clock ) ){
                    self._ensureBufferLength( self._length + 1 );
                    self.clocks[self._length] = clock;
                    self.items[self._length] = new org.kbinani.vsq.VsqBPPair( parseInt( spl2[1], 10 ), self.maxId + 1 );
                    self.maxId++;
                    self._length++;
                }
            }
        end]]

    ---
    -- コピーを作成する
    -- @return (BPList) このオブジェクトのコピー
    -- @name clone
    function this:clone()
        local res = BPList.new( self.name, self.defaultValue, self.minValue, self.maxValue );
        res:_ensureBufferLength( self._length );
        local i;
        for i = 1, self._length, 1 do
            res.clocks[i] = self.clocks[i];
            res.items[i] = self.items[i]:clone();
        end
        res._length = self._length;
        res.maxId = self.maxId;
        return res;
    end

    ---
    -- コントロールカーブの最大値を取得する
    -- @return (integer) コントロールカーブの最大値
    -- @name getMaximum
    function this:getMaximum()
        return self.maxValue;
    end

    ---
    -- コントロールカーブの最大値を設定する
    -- @param value (integer) コントロールカーブの最大値
    -- @name setMaximum
    function this:setMaximum( value )
        self.maxValue = value;
    end

    ---
    -- コントロールカーブの最小値を取得する
    -- @return (integer) コントロールカーブの最小値
    -- @name getMinimum
    function this:getMinimum()
        return self.minValue;
    end

    ---
    -- コントロールカーブの最小値を設定する
    -- @param value (integer) コントロールカーブの最小値
    -- @name setMinimum
    function this:setMinimum( value )
        self.minValue = value;
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
                    self.clocks[i] = self.clocks[i + 1];
                    self.items[i].value = self.items[i + 1].value;
                    self.items[i].id = self.items[i + 1].id;
                end
                self._length = self._length - 1;
            end
        end]]

    ---
    -- 指定された時刻にデータ点が存在するかどうかを調べる
    -- @param clock (integer) Tick 単位の時刻
    -- @return (boolean) データ点が存在すれば ture を、そうでなければ false を返す
    -- @name isContainsKey
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
            local item = self.items[index + 1];
            local i;
            for i = index + 1, self._length - 2, 1 do
                self.clocks[i] = self.clocks[i + 1];
                self.items[i].value = self.items[i + 1].value;
                self.items[i].id = self.items[i + 1].id;
            end
            self._length = self._length - 1;
            local index_new = self:_find( new_clock );
            if( index_new >= 0 )then
                self.items[index_new + 1].value = new_value;
                self.items[index_new + 1].id = item.id;
                return;
            else
                self._length = self._length + 1;
                self:_ensureBufferLength( self._length );
                self.clocks[self._length] = new_clock;
                Util.sort( self.clocks, 0, self._length );
                index_new = self:_find( new_clock );
                --item.value = new_value;
                local i;
                for i = self._length, index_new + 2, -1 do
                    self.items[i].value = self.items[i - 1].value;
                    self.items[i].id = self.items[i - 1].id;
                end
                self.items[index_new + 1].value = new_value;
                self.items[index_new + 1].id = item.id;
            end
        end]]

    ---
    -- 全てのデータ点を削除する
    -- @name clear
    function this:clear()
        self._length = 0;
    end

    ---
    -- データ点の値を取得する
    -- @param index (integer) 取得するデータ点のインデックス(最初のインデックスは0)
    -- @return (integer) データ点の値
    -- @name getValue
    function this:getValue( index )
        return self.items[index + 1].value;
    end

    ---
    -- データ点を取得する
    -- @param index (integer) 取得するデータ点のインデックス(最初のインデックスは0)
    -- @return (BP) データ点のインスタンス
    -- @name get
    function this:get( index )
        return self.items[index + 1]:clone();
    end

    ---
    -- データ点の時刻を取得する
    -- @param index (integer) 取得するデータ点のインデックス(最初のインデックスは0)
    -- @return (integer) データ点の Tick 単位の時刻
    -- @name getKeyClock
    function this:getKeyClock( index )
        return self.clocks[index + 1];
    end

    ---
    -- ID を基にデータ点の値を取得する
    -- @param id (integer) データ点の ID
    -- @return (integer) データ点の値
    -- @name findValueFromId
    function this:findValueFromId( id )
        local i;
        for i = 1, self._length, 1 do
            local item = self.items[i];
            if( item.id == id )then
                return item.value;
            end
        end
        return self.defaultValue;
    end

    ---
    -- ID を基にデータ点を検索し、検索結果を取得する
    -- @param id (integer) データ点の ID
    -- @return (BPListSearchResult) 検索結果を格納したオブジェクト
    -- @name findElement
    function this:findElement( id )
        local context = BPListSearchResult.new();
        local i;
        for i = 1, self._length, 1 do
            local item = self.items[i];
            if( item.id == id )then
                context.clock = self.clocks[i];
                context.index = i - 1;
                context.point = item:clone();
                return context;
            end
        end
        context.clock = -1;
        context.index = -1;
        context.point = BP.new( self.defaultValue, -1 );
        return context;
    end

    ---
    -- 指定した ID のデータ点の値を設定する
    -- @param id (integer)
    -- @param value (integer) 設定するデータ点の値
    -- @name setValueForId
    function this:setValueForId( id, value )
        local i;
        for i = 1, self._length, 1 do
            if( self.items[i].id == id )then
                self.items[i].value = value;
                break;
            end
        end
    end

    ---
    -- コントロールカーブをテキストストリームに出力する
    -- @param writer (TextStream) 出力先のストリーム
    -- @param start_clock (integer) Tick 単位の出力開始時刻
    -- @param header (string) 最初に出力するヘッダー文字列
    -- @name print
    function this:print( writer, start_clock, header )
        writer:writeLine( header );
        local lastvalue = self.defaultValue;
        local value_at_start_written = false;
        local i;
        for i = 1, self._length, 1 do
            local key = self.clocks[i];
            if( start_clock == key )then
                writer:writeLine( key .. "=" .. self.items[i].value );
                value_at_start_written = true;
            elseif( start_clock < key )then
                if( (not value_at_start_written) and (lastvalue ~= self.defaultValue) )then
                    writer:writeLine( start_clock .. "=" .. lastvalue );
                    value_at_start_written = true;
                end
                local val = self.items[i].value;
                writer:writeLine( key .. "=" .. val );
            else
                lastvalue = self.items[i].value;
            end
        end
        if( (not value_at_start_written) and (lastvalue ~= self.defaultValue) )then
            writer:writeLine( start_clock .. "=" .. lastvalue );
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
    -- @name size
    function this:size()
        return self._length;
    end

    ---
    -- データ点の Tick 単位の時刻を昇順に返す反復子を取得する
    -- @return (BPList.KeyClockIterator) 反復子のインスタンス
    -- @name keyClockIterator
    function this:keyClockIterator()
        return BPList.KeyClockIterator.new( self );
    end

    --
    -- 指定された時刻値を持つデータ点のインデックスを検索する
    -- @access private
    -- @param value (integer) Tick 単位の時刻
    -- @return (integer) データ点のインデックス(最初のインデックスは0)。データ点が見つからなかった場合は負の値を返す
    function this:_find( value )
        local i;
        for i = 1, self._length, 1 do
            if( self.clocks[i] == value )then
                return i - 1;
            end
        end
        return -1;
    end

    ---
    -- 並べ替え、既存の値との重複チェックを行わず、リストの末尾にデータ点を追加する
    -- @param clock (integer) Tick 単位の時刻
    -- @param value (integer) データ点の値
    -- @name addWithoutSort
    function this:addWithoutSort( clock, value )
        self:_ensureBufferLength( self._length + 1 );
        self.clocks[self._length + 1] = clock;
        self.maxId = self.maxId + 1;
        self.items[self._length + 1].value = value;
        self.items[self._length + 1].id = self.maxId;
        self._length = self._length + 1;
    end

    ---
    -- データ点を追加する。指定された時刻に既にデータ点がある場合、データ点の値を上書きする
    -- @param clock (integer) データ点を追加する Tick 単位の時刻
    -- @param value (integer) データ点の値
    -- @return (integer) データ点の ID
    -- @name add
    function this:add( clock, value )
        self:_ensureBufferLength( self._length );
        local index = self:_find( clock );
        if( index >= 0 )then
            self.items[index + 1].value = value;
            return self.items[index + 1].id;
        else
            self._length = self._length + 1;
            self:_ensureBufferLength( self._length );
            self.clocks[self._length] = clock;
            Util.sort( self.clocks, 0, self._length );
            index = self:_find( clock );
            self.maxId = self.maxId + 1;
            local i;
            for i = self._length, index + 2, -1 do
                self.items[i].value = self.items[i - 1].value;
                self.items[i].id = self.items[i - 1].id;
            end
            self.items[index + 1].value = value;
            self.items[index + 1].id = self.maxId;
            return self.maxId;
        end
    end

    ---
    -- データ点を、ID 指定したうえで追加する。指定された時刻に既にデータ点がある場合、データ点の値を上書きする
    -- @param clock (integer) データ点を追加する Tick 単位の時刻
    -- @param value (integer) データ点の値
    -- @param id (integer) データ点の ID
    -- @return (integer) データ点の ID
    -- @name addWithId
    function this:addWithId( clock, value, id )
        self:_ensureBufferLength( self._length );
        local index = self:_find( clock );
        if( index >= 0 )then
            self.items[index + 1].value = value;
            self.items[index + 1].id = id;
        else
            self._length = self._length + 1;
            self:_ensureBufferLength( self._length );
            self.clocks[self._length] = clock;
            Util.sort( self.clocks, 0, self._length );
            index = self:_find( clock );
            local i;
            for i = self._length, index + 2, -1 do
                self.items[i].value = self.items[i - 1].value;
                self.items[i].id = self.items[i - 1].id;
            end
            self.items[index + 1].value = value;
            self.items[index + 1].id = id;
        end
        self.maxId = math.max( self.maxId, id );
        return id;
    end

    --[[
        -- @param id [long]
        -- @return [void]
        function this:removeWithId( id )
            local i;
            for i = 1, self._length, 1 do
                if( self.items[i].id == id )then
                    local j;
                    for j = i, self._length - 1, 1 do
                        self.items[j].value = self.items[j + 1].value;
                        self.items[j].id = self.items[j + 1].id;
                        self.clocks[j] = self.clocks[j + 1];
                    end
                    self._length = self._length - 1;
                    break;
                end
            end
        end]]

    ---
    -- 指定された Tick 単位の時刻における、コントロールパラメータの値を取得する
    -- @see _getValueAt_1
    -- @see _getValueAt_2
    -- @name getValueAt
    function this:getValueAt( ... )
        local arguments = { ... };
        if( #arguments == 2 )then
            return self:_getValueAt_2( arguments[1], arguments[2] );
        elseif( #arguments == 1 )then
            return self:_getValueAt_1( arguments[1] );
        end
    end

    ---
    -- 指定された Tick 単位の時刻における、コントロールパラメータの値を取得する
    -- @param clock (integer) 値を取得する Tick 単位の時刻
    -- @param index (table,{ value = ? }) 値の取得に使用したインデックス(最初のインデックスは0)
    -- @return (integer) コントロールパラメータの値
    -- @name _getValueAt_2
    function this:_getValueAt_2( clock, index )
        if( self._length == 0 )then
            return self.defaultValue;
        else
            if( index.value < 0 )then
                index.value = 0;
            end
            if( index.value > 0 and clock < self.clocks[index.value + 1] )then
                index.value = 0;
            end
            local i;
            for i = index.value + 1, self._length, 1 do
                local keyclock = self.clocks[i];
                if( clock < keyclock )then
                    if( i > 1 )then
                        index.value = i - 2;
                        return self.items[i - 1].value;
                    else
                        index.value = 0;
                        return self.defaultValue;
                    end
                end
            end
            index.value = self._length - 1;
            return self.items[self._length].value;
        end
    end

    ---
    -- 指定された Tick 単位の時刻における，コントロールパラメータの値を取得する．
    -- @param clock (integer) 値を取得する Tick 単位の時刻
    -- @return (integer) コントロールパラメータの値
    -- @name _getValueAt_1
    function this:_getValueAt_1( clock )
        self:_ensureBufferLength( self._length );
        local index = self:_find( clock );
        if( index >= 0 )then
            return self.items[index + 1].value;
        else
            if( self._length <= 0 )then
                return self.defaultValue;
            else
                local draft = 0;
                local i;
                for i = 1, self._length, 1 do
                    local c = self.clocks[i];
                    if( clock < c )then
                        break;
                    end
                    draft = i;
                end
                if( draft == 0 )then
                    return self.defaultValue;
                else
                    return self.items[draft].value;
                end
            end
        end
    end

    if( #arguments == 4 )then
        this:_init_4( arguments[1], arguments[2], arguments[3], arguments[4] );
    end

    return this;
end

BPList.INIT_BUFLEN = 512;
