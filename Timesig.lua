--[[
  Timesig.lua
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

if( nil == luavsq.Timesig )then

    luavsq.Timesig = {};

    function luavsq.Timesig.new( ... )
        local this = {};
        local arguments = { ... };
        this.numerator = 0;
        this.denominator = 0;

        ---
        -- @param numerator [int]
        -- @param denominator [int]
        -- @return [void]
        function this:_init_2( numerator, denominator )
            self.numerator = numerator;
            self.denominator = denominator;
        end

        if( #arguments == 2 )then
            this:_init_2( arguments[1], arguments[2] );
        end

        return this;
    end

end
