--[[
  TimesigTableItem.lua
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

if( nil == luavsq.TimesigTableItem )then

    luavsq.TimesigTableItem = {};

    function luavsq.TimesigTableItem.new( ... )
        local this = {};
        local arguments = { ... };

        ---
        -- クロック数
        this.clock = 0;

        ---
        -- 拍子の分子
        this.numerator = 4;

        ---
        -- 拍子の分母
        this.denominator = 4;

        ---
        -- 何小節目か
        this.barCount = 0;

        ---
        -- @param clock [int]
        -- @param numerator [int]
        -- @param denominator [int]
        -- @param bar_count [int]
        -- @return [TimeSigTableEntry]
        function this:_init_4( clock, numerator, denominator, barCount )
            self.clock = clock;
            self.numerator = numerator;
            self.denominator = denominator;
            self.barCount = barCount;
        end

        ---
        -- @return [string]
        function this:toString()
            return "{Clock=" .. self.clock .. ", Numerator=" .. self.numerator .. ", Denominator=" .. self.denominator .. ", BarCount=" .. self.barCount .. "}";
        end

        ---
        -- @return [object]
        function this:clone()
            return luavsq.TimesigTableItem.new( self.clock, self.numerator, self.denominator, self.barCount );
        end

        ---
        -- @param item [TimeSigTableEntry]
        -- @return [int]
        function this:compareTo( item )
            return self.barCount - item.barCount;
        end

        if( #arguments == 4 )then
            this:_init_4( arguments[1], arguments[2], arguments[3], arguments[4] );
        end

        return this;
    end

    ---
    -- @param a [TimeSigTableEntry]
    -- @param b [TimeSigTableEntry]
    -- @return [int]
    function luavsq.TimesigTableItem.compare( a, b )
        return (a:compareTo( b ) < 0);
    end

end
