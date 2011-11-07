--[[
  IDType.lua
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

if( nil == luavsq.IDType )then

    luavsq.IDType = {};

    luavsq.IDType.Singer = 0;
    luavsq.IDType.Anote = 1;
    luavsq.IDType.Aicon = 2;
    luavsq.IDType.Unknown = -1;

    function luavsq.IDType.toString( value )
        if( value == luavsq.IDType.Singer )then
            return "Singer";
        elseif( value == luavsq.IDType.Anote )then
            return "Anote";
        elseif( value == luavsq.IDType.Aicon )then
            return "Aicon";
        else
            return "Unknown";
        end
    end

end
