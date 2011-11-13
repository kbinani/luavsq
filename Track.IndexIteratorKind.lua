--[[
  Track.IndexItertorKind.lua
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

if( nil == luavsq.Track )then
    luavsq.Track = {};
end

if( nil == luavsq.Track.IndexIteratorKind )then

    luavsq.Track.IndexIteratorKind = {};

    luavsq.Track.IndexIteratorKind.SINGER = 1;
    luavsq.Track.IndexIteratorKind.NOTE = 2;
    luavsq.Track.IndexIteratorKind.CRESCEND = 4;
    luavsq.Track.IndexIteratorKind.DECRESCEND = 8;
    luavsq.Track.IndexIteratorKind.DYNAFF = 16;

end
