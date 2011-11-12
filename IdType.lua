--[[
  IdType.lua
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

if( nil == luavsq.IdType )then

    luavsq.IdType = {};

    luavsq.IdType.Singer = 0;
    luavsq.IdType.Anote = 1;
    luavsq.IdType.Aicon = 2;
    luavsq.IdType.Unknown = -1;

    function luavsq.IdType.toString( value )
        if( value == luavsq.IdType.Singer )then
            return "Singer";
        elseif( value == luavsq.IdType.Anote )then
            return "Anote";
        elseif( value == luavsq.IdType.Aicon )then
            return "Aicon";
        else
            return "Unknown";
        end
    end

end
