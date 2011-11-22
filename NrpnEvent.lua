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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.NrpnEvent )then

    luavsq.NrpnEvent = {};

    function luavsq.NrpnEvent.new( ... )
        local this = {};
        local arguments = { ... };
        this.clock = 0;
        this.nrpn = 0;
        this.dataMSB = 0;
        this.dataLSB = 0;
        this.hasLSB = false;
        this.isMSBOmittingRequired = false;
        --private Vector<luavsq.NrpnEvent>
        this._list = nil;

        ---
        -- @param clock [int]
        -- @param nrpn [int]
        -- @param data_msb [byte]
        -- @return [void]
        function this:_init_3( clock, nrpn, data_msb )
            self.clock = clock;
            self.nrpn = nrpn;
            self.dataMSB = data_msb;
            self.dataLSB = 0x0;
            self.hasLSB = false;
            self.isMSBOmittingRequired = false;
            self._list = {};--Vector<luavsq.NrpnEvent>();
        end

        ---
        -- @param clock [int]
        -- @param nrpn [int]
        -- @param data_msb [byte]
        -- @param data_lsb [byte]
        -- @return [void]
        function this:_init_4( clock, nrpn, data_msb, data_lsb )
            self.clock = clock;
            self.nrpn = nrpn;
            self.dataMSB = data_msb;
            self.dataLSB = data_lsb;
            self.hasLSB = true;
            self.isMSBOmittingRequired = false;
            self._list = {};--new Vector<luavsq.NrpnEvent>();
        end

        ---
        -- @return (table<luavsq.NrpnEvent>)
        function this:expand()
            local ret = {};--new Vector<luavsq.NrpnEvent>();
            if( self.hasLSB )then
                local v = luavsq.NrpnEvent.new( self.clock, self.nrpn, self.dataMSB, self.dataLSB );
                v.isMSBOmittingRequired = self.isMSBOmittingRequired;
                table.insert( ret, v );
            else
                local v = luavsq.NrpnEvent.new( self.clock, self.nrpn, self.dataMSB );
                v.isMSBOmittingRequired = self.isMSBOmittingRequired;
                table.insert( ret, v );
            end
            local i;
            for i = 1, #self._list, 1 do
                local add = self._list[i]:expand();
                local j;
                for j = 1, #add, 1 do
                    table.insert( ret, add[j] );
                end --ret.addAll( Arrays.asList( m_list.get( i ).expand() ) );
            end
            return ret;
        end

        ---
        -- @param item [luavsq.NrpnEvent]
        -- @return [int]
        function this:compareTo( item )
            if( self.clock == item.clock )then
                local thisNrpnMsb = (this.nrpn - (this.nrpn % 0x100)) / 0x100;
                local itemNrpnMsb = (item.nrpn - (item.nrpn % 0x100)) / 0x100;
                return itemNrpnMsb - thisNrpnMsb;
            else
                return self.clock - item.clock;
            end
        end

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
        -- @param nrpn [int]
        -- @param data_msb [byte]
        -- @return [void]
        function this:_append_2( nrpn, data_msb )
            table.insert( self._list, luavsq.NrpnEvent.new( self.clock, nrpn, data_msb ) );
        end

        ---
        -- @param nrpn [int]
        -- @param data_msb [byte]
        -- @param data_lsb [byte]
        -- @return [void]
        function this:_append_3_int_byte_byte( nrpn, data_msb, data_lsb )
            table.insert( self._list, luavsq.NrpnEvent.new( self.clock, nrpn, data_msb, data_lsb ) );
        end

        ---
        -- @param nrpn [int]
        -- @param data_msb [byte]
        -- @param msb_omit_required [bool]
        -- @return [void]
        function this:_append_3_int_byte_bool( nrpn, data_msb, msb_omit_required )
            local v = luavsq.NrpnEvent.new( self.clock, nrpn, data_msb );
            v.isMSBOmittingRequired = msb_omit_required;
            table.insert( self._list, v );
        end

        ---
        -- @param nrpn [int]
        -- @param data_msb [int]
        -- @param data_lsb [int]
        -- @param msb_omit_required [bool]
        -- @return [void]
        function this:_append_4( nrpn, data_msb, data_lsb, msb_omit_required )
            local v = luavsq.NrpnEvent.new( self.clock, nrpn, data_msb, data_lsb );
            v.isMSBOmittingRequired = msb_omit_required;
            table.insert( self._list, v );
        end

        if( #arguments == 3 )then
            this:_init_3( arguments[1], arguments[2], arguments[3] );
        elseif( #arguments == 4 )then
            this:_init_4( arguments[1], arguments[2], arguments[3], arguments[4] );
        end

        return this;
    end

    function luavsq.NrpnEvent.compare( a, b )
        if( a:compareTo( b ) < 0 )then
            return true;
        else
            return false;
        end
    end

--[[
    ---
    -- @param src1 [luavsq.NrpnEvent[] ]
    -- @param src2 [luavsq.NrpnEvent[] ]
    -- @return [luavsq.NrpnEvent[] ]
    function luavsq.NrpnEvent.merge( src1, src2 )
        local ret = [];--new Vector<luavsq.NrpnEvent>();
        for ( local i = 0; i < src1.length; i++ ) {
            ret.push( src1[i] );
        end
        for ( local i = 0; i < src2.length; i++ ) {
            ret.push( src2[i] );
        end
        ret.sort( luavsq.NrpnEvent.compare );--Collections.sort( ret );
        return ret;
    end
]]

    ---
    -- @param source [luavsq.NrpnEvent[] ]
    -- @return (table<MidiEvent>)
    function luavsq.NrpnEvent.convert( source )
        local nrpn = source[1].nrpn;
        local msb = luavsq.Util.rshift( nrpn, 8 );
        local lsb = nrpn - luavsq.Util.lshift( msb, 8 );
        local ret = {};
        local e = nil;

        e = luavsq.MidiEvent.new();
        e.clock = source[1].clock;
        e.firstByte = 0xb0;
        e.data = { 0x63, msb };
        table.insert( ret, e );

        e = luavsq.MidiEvent.new();
        e.clock = source[1].clock;
        e.firstByte = 0xb0;
        e.data = { 0x62, lsb };
        table.insert( ret, e );

        e = luavsq.MidiEvent.new();
        e.clock = source[1].clock;
        e.firstByte = 0xb0;
        e.data = { 0x06, source[1].dataMSB };
        table.insert( ret, e );

        if( source[1].hasLSB )then
            e = luavsq.MidiEvent.new();
            e.clock = source[1].clock;
            e.firstByte = 0xb0;
            e.data = { 0x26, source[1].dataLSB };
            table.insert( ret, e );
        end

        local i;
        for i = 2, #source, 1 do
            local item = source[i];
            local tnrpn = item.nrpn;
            msb = luavsq.Util.rshift( tnrpn, 8 );
            lsb = (tnrpn - luavsq.Util.lshift( msb, 8 ));
            if( false == item.isMSBOmittingRequired )then
                e = luavsq.MidiEvent.new();
                e.clock = item.clock;
                e.firstByte = 0xb0;
                e.data = { 0x63, msb };
                table.insert( ret, e );
            end

            e = luavsq.MidiEvent.new();
            e.clock = item.clock;
            e.firstByte = 0xb0;
            e.data = { 0x62, lsb };
            table.insert( ret, e );

            e = luavsq.MidiEvent.new();
            e.clock = item.clock;
            e.firstByte = 0xb0;
            e.data = { 0x06, item.dataMSB };
            table.insert( ret, e );
            if( item.hasLSB )then
                e = luavsq.MidiEvent.new();
                e.clock = item.clock;
                e.firstByte = 0xb0;
                e.data = { 0x26, item.dataLSB };
                table.insert( ret, e );
            end
        end
        return ret;
    end

end
