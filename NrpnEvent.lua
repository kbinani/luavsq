--[[
  NrpnEvent.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local table = table;
local type = type;

module( "luavsq" );

---
-- NRPN イベントを表すクラス
-- @class table
-- @name NrpnEvent
-- @access private
NrpnEvent = {};

--
-- 初期化を行う
-- @return (NrpnEvent)
function NrpnEvent.new( ... )
    local this = {};
    local arguments = { ... };

    ---
    -- Tick 単位の時刻
    -- @var integer
    this.clock = 0;

    ---
    -- NRPN の値
    -- @var integer
    this.nrpn = 0;

    ---
    -- DATA MSB
    -- @var integer
    this.dataMSB = 0;

    ---
    -- DATA LSB
    -- @var integer
    this.dataLSB = 0;

    ---
    -- DATA LSB 値を持っているかどうか
    -- @var boolean
    this.hasLSB = false;

    ---
    -- MSB の出力を省略するかどうか
    -- @var boolean
    this.isMSBOmittingRequired = false;
    this._list = nil;

    ---
    -- 時刻、NRPN、DATA MSB を指定し、初期化を行う
    -- @param clock (integer) Tick 単位の時刻
    -- @param nrpn (integer) NRPN
    -- @param dataMsb (integer) DATA MSB
    -- @return (NrpnEvent)
    -- @name new<!--1-->
    -- @access static ctor
    function this:_init_3( clock, nrpn, dataMsb )
        self.clock = clock;
        self.nrpn = nrpn;
        self.dataMSB = dataMsb;
        self.dataLSB = 0x0;
        self.hasLSB = false;
        self.isMSBOmittingRequired = false;
        self._list = {};--Vector<NrpnEvent>();
    end

    ---
    -- 時刻、NRPN、DATA MSB、DATA LSB を指定し、初期化を行う
    -- @param clock (integer) Tick 単位の時刻
    -- @param nrpn (integer) NRPN
    -- @param dataMsb (integer) DATA MSB
    -- @param dataLsb (integer) DATA LSB
    -- @return (NrpnEvent)
    -- @name new<!--2-->
    -- @access static ctor
    function this:_init_4( clock, nrpn, dataMsb, dataLsb )
        self.clock = clock;
        self.nrpn = nrpn;
        self.dataMSB = dataMsb;
        self.dataLSB = dataLsb;
        self.hasLSB = true;
        self.isMSBOmittingRequired = false;
        self._list = {};--new Vector<NrpnEvent>();
    end

    ---
    -- 親子関係によって入れ子になっている NRPN イベントを展開し、配列に変換する
    -- @return (table<NrpnEvent>) 展開後の NRPN イベントの配列
    function this:expand()
        local ret = {};
        if( self.hasLSB )then
            local v = NrpnEvent.new( self.clock, self.nrpn, self.dataMSB, self.dataLSB );
            v.isMSBOmittingRequired = self.isMSBOmittingRequired;
            table.insert( ret, v );
        else
            local v = NrpnEvent.new( self.clock, self.nrpn, self.dataMSB );
            v.isMSBOmittingRequired = self.isMSBOmittingRequired;
            table.insert( ret, v );
        end
        local i;
        if( self._list ~= nil )then
            for i = 1, #self._list, 1 do
                local add = self._list[i]:expand();
                local j;
                for j = 1, #add, 1 do
                    table.insert( ret, add[j] );
                end
            end
        end
        return ret;
    end

    ---
    -- 順序を比較する
    -- @param item (NrpnEvent) 比較対象のアイテム
    -- @return (integer) このインスタンスが比較対象よりも小さい場合は負の整数、等しい場合は 0、大きい場合は正の整数を返す
    function this:compareTo( item )
        if( self.clock == item.clock )then
            local thisNrpnMsb = (this.nrpn - (this.nrpn % 0x100)) / 0x100;
            local itemNrpnMsb = (item.nrpn - (item.nrpn % 0x100)) / 0x100;
            return itemNrpnMsb - thisNrpnMsb;
        else
            return self.clock - item.clock;
        end
    end

    --
    -- このオブジェクトの末尾に NRPN イベントを追加する
    function this:append( ... )
        local arguments = { ... };
        if( #arguments == 2 )then
            self:_append_2( arguments[1], arguments[2] );
        elseif( #arguments == 3 )then
            local t = type( arguments[3] );
            if( t == "boolean" )then
                self:_append_3_int_byte_bool( arguments[1], arguments[2], arguments[3] );
            else
                self:_append_3_int_byte_byte( arguments[1], arguments[2], arguments[3] );
            end
        elseif( #arguments == 4 )then
            self:_append_4( arguments[1], arguments[2], arguments[3], arguments[4] );
        end
    end

    ---
    -- NRPN、DATA MSB を指定し、イベントを追加する
    -- @param nrpn (integer) NRPN
    -- @param dataMsb (integer) DATA MSB
    -- @name append<!--1-->
    function this:_append_2( nrpn, dataMsb )
        table.insert( self._list, NrpnEvent.new( self.clock, nrpn, dataMsb ) );
    end

    ---
    -- NRPN、DATA MSB、DATA LSB を指定し、イベントを追加する
    -- @param nrpn (integer) NRPN
    -- @param dataMsb (integer) DATA MSB
    -- @param dataLsb (integer) DATA LSB
    -- @name append<!--2-->
    function this:_append_3_int_byte_byte( nrpn, dataMsb, dataLsb )
        table.insert( self._list, NrpnEvent.new( self.clock, nrpn, dataMsb, dataLsb ) );
    end

    ---
    -- NRPN、DATA MSB、MSB 省略フラグを指定し、イベントを追加する
    -- @param nrpn (integer) NRPN
    -- @param dataMsb (integer) DATA MSB
    -- @param isMsbOmittingRequired (boolean) NRPN MSB を省略する場合は <code>true</code> を、そうでない場合は <code>false</code> を指定する
    -- @name append<!--3-->
    function this:_append_3_int_byte_bool( nrpn, dataMsb, isMsbOmittingRequired )
        local v = NrpnEvent.new( self.clock, nrpn, dataMsb );
        v.isMSBOmittingRequired = isMsbOmittingRequired;
        table.insert( self._list, v );
    end

    ---
    -- NRPN、DATA MSB、DATA LSB、MSB 省略フラグを指定し、イベントを追加する
    -- @param nrpn (integer) NRPN
    -- @param dataMsb (integer) DATA MSB
    -- @param dataLsb (integer) DATA LSB
    -- @param isMsbOmittingRequired (boolean) NRPN MSB を省略する場合は <code>true</code> を、そうでない場合は <code>false</code> を指定する
    -- @name append<!--4-->
    function this:_append_4( nrpn, dataMsb, dataLsb, isMsbOmittingRequired )
        local v = NrpnEvent.new( self.clock, nrpn, dataMsb, dataLsb );
        v.isMSBOmittingRequired = isMsbOmittingRequired;
        table.insert( self._list, v );
    end

    if( #arguments == 3 )then
        this:_init_3( arguments[1], arguments[2], arguments[3] );
    elseif( #arguments == 4 )then
        this:_init_4( arguments[1], arguments[2], arguments[3], arguments[4] );
    end

    return this;
end

---
-- 2 つの {@link NrpnEvent} を比較する
-- @param a (NrpnEvent) 比較対象のオブジェクト
-- @param b (NrpnEvent) 比較対象のオブジェクト
-- @return (boolean) <code>a</code> が <code>b</code> よりも小さい場合は <code>true</code>、そうでない場合は <code>false</code> を返す
-- @access static
function NrpnEvent.compare( a, b )
    if( a:compareTo( b ) < 0 )then
        return true;
    else
        return false;
    end
end

--[[
    --
    -- @param src1 [NrpnEvent[] ]
    -- @param src2 [NrpnEvent[] ]
    -- @return [NrpnEvent[] ]
    function NrpnEvent.merge( src1, src2 )
        local ret = [];--new Vector<NrpnEvent>();
        for ( local i = 0; i < src1.length; i++ ) {
            ret.push( src1[i] );
        end
        for ( local i = 0; i < src2.length; i++ ) {
            ret.push( src2[i] );
        end
        ret.sort( NrpnEvent.compare );--Collections.sort( ret );
        return ret;
    end
]]

---
-- NRPN イベントの配列を、{@link MidiEvent} の配列に変換する
-- @param source (table<NrpnEvent>) NRPN イベントの配列
-- @return (table) {@link MidiEvent} の配列
-- @access static
function NrpnEvent.convert( source )
    local nrpn = source[1].nrpn;
    local msb = Util.rshift( nrpn, 8 );
    local lsb = nrpn - Util.lshift( msb, 8 );
    local ret = {};
    local e = nil;

    e = MidiEvent.new();
    e.clock = source[1].clock;
    e.firstByte = 0xb0;
    e.data = { 0x63, msb };
    table.insert( ret, e );

    e = MidiEvent.new();
    e.clock = source[1].clock;
    e.firstByte = 0xb0;
    e.data = { 0x62, lsb };
    table.insert( ret, e );

    e = MidiEvent.new();
    e.clock = source[1].clock;
    e.firstByte = 0xb0;
    e.data = { 0x06, source[1].dataMSB };
    table.insert( ret, e );

    if( source[1].hasLSB )then
        e = MidiEvent.new();
        e.clock = source[1].clock;
        e.firstByte = 0xb0;
        e.data = { 0x26, source[1].dataLSB };
        table.insert( ret, e );
    end

    local i;
    for i = 2, #source, 1 do
        local item = source[i];
        local tnrpn = item.nrpn;
        msb = Util.rshift( tnrpn, 8 );
        lsb = (tnrpn - Util.lshift( msb, 8 ));
        if( false == item.isMSBOmittingRequired )then
            e = MidiEvent.new();
            e.clock = item.clock;
            e.firstByte = 0xb0;
            e.data = { 0x63, msb };
            table.insert( ret, e );
        end

        e = MidiEvent.new();
        e.clock = item.clock;
        e.firstByte = 0xb0;
        e.data = { 0x62, lsb };
        table.insert( ret, e );

        e = MidiEvent.new();
        e.clock = item.clock;
        e.firstByte = 0xb0;
        e.data = { 0x06, item.dataMSB };
        table.insert( ret, e );
        if( item.hasLSB )then
            e = MidiEvent.new();
            e.clock = item.clock;
            e.firstByte = 0xb0;
            e.data = { 0x26, item.dataLSB };
            table.insert( ret, e );
        end
    end
    return ret;
end
