--[[
  Track.IndexItertorKindEnum.lua
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

if( nil == luavsq.Track )then
    luavsq.Track = {};
end

if( nil == luavsq.Track.IndexIteratorKindEnum )then

    ---
    -- IndexIterator の反復子の種類を表す列挙子
    -- @class table
    -- @name luavsq.Track.IndexIteratorKindEnum
    luavsq.Track.IndexIteratorKindEnum = {};

    luavsq.Track.IndexIteratorKindEnum.SINGER = 1;
    luavsq.Track.IndexIteratorKindEnum.NOTE = 2;
    luavsq.Track.IndexIteratorKindEnum.CRESCEND = 4;
    luavsq.Track.IndexIteratorKindEnum.DECRESCEND = 8;
    luavsq.Track.IndexIteratorKindEnum.DYNAFF = 16;

end
