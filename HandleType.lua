--[[
  HandleType.lua
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

if( nil == luavsq.HandleType )then

    luavsq.HandleType = {};

    luavsq.HandleType.Lyric = 0;
    luavsq.HandleType.Vibrato = 1;
    luavsq.HandleType.Singer = 2;
    luavsq.HandleType.NoteHead = 3;
    luavsq.HandleType.Dynamics = 4;

end
