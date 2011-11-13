--[[
  HandleTypeEnum.lua
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

if( nil == luavsq.HandleTypeEnum )then

    luavsq.HandleTypeEnum = {};

    luavsq.HandleTypeEnum.Lyric = 0;
    luavsq.HandleTypeEnum.Vibrato = 1;
    luavsq.HandleTypeEnum.Singer = 2;
    luavsq.HandleTypeEnum.NoteHead = 3;
    luavsq.HandleTypeEnum.Dynamics = 4;

end
