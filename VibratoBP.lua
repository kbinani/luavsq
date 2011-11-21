--[[
  VibratoBP.lua
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

if( nil == luavsq.VibratoBP )then

    luavsq.VibratoBP = {};

    function luavsq.VibratoBP.new( ... )
        local arguments = { ... };
        local this = {};
        this.x = 0.0;
        this.y = 0;
        if( #arguments == 2 )then
            this.x = arguments[1];
            this.y = arguments[2];
        end

        ---
        -- この VibratoBP のインスタンスと、引数で指定されたインスタンスを比較する
        -- @param item (luavsq.VibratoBP)
        -- @return (integer)
        function this:compareTo( item )
            local v = self.x - item.x;
            if( v > 0.0 )then
                return 1;
            elseif( v < 0.0 )then
                return -1;
            end
            return 0;
        end

        return this;
    end

    ---
    -- 引数で与えられた 2 つのインスタンスの順序比較し、第 1 引数のものが第 2 引数のものより大きければ 1 を返す。
    -- 小さければ -1 を返す。同順であれば 0 を返す。
    -- @param a (luavsq.VibratoBP)
    -- @param b (luavsq.VibratoBP)
    -- @return (integer)
    function luavsq.VibratoBP.compare( a, b )
        return a:compareTo( b );
    end

end
