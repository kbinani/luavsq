--[[
  TempoTableItem.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.TempoTableItem )then

    luavsq.TempoTableItem = {};

    function luavsq.TempoTableItem.new( ... )
        local this = {};
        local arguments = { ... };
        this.clock = 0;
        this.tempo = 0;
        this.time = 0.0;

        ---
        -- @return [string]
        function this:toString()
            return "{Clock=" .. self.clock .. ", Tempo=" .. self.tempo .. ", Time=" .. self.time .. "}";
        end

        ---
        -- @return [object]
        function this:clone()
            return luavsq.TempoTableItem.new( self.clock, self.tempo, self.time );
        end

        ---
        -- overload1
        -- @return [TempoTableItem]
        --
        -- overload2
        -- @param clock [int]
        -- @param _tempo [int]
        -- @param _time [int]
        -- @return [TempoTableItem]
        function this:_init_3( clock, tempo, time )
            self.clock = clock;
            self.tempo = tempo;
            self.time = time;
        end

        ---
        -- @param entry [TempoTableItem]
        -- @return [int]
        function this:compareTo( entry )
            return self.clock - entry.clock;
        end

        ---
        -- @param entry [TempoTableItem]
        -- @return [bool]
        function this:equals( entry )
            if( self.clock == entry.clock )then
                return true;
            else
                return false;
            end
        end

        if( #arguments == 3 )then
            this:_init_3( arguments[1], arguments[2], arguments[3] );
        end

        return this;
    end

    ---
    -- @param a [TempoTableItem]
    -- @param b [TempoTableItem]
    -- @return [int]
    function luavsq.TempoTableItem.compare( a, b )
        if( a:compareTo( b ) < 0 )then
            return true;
        else
            return false;
        end
    end

end
