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
    -- @field SINGER 歌手イベント
    -- @field NOTE 音符イベント
    -- @field CRESCEND クレッシェンドイベント
    -- @field DECRESCEND デクレッシェンドイベント
    -- @field DYNAFF 強弱記号イベント
    luavsq.Track.IndexIteratorKindEnum = {
        SINGER = 1,
        NOTE = 2,
        CRESCEND = 4,
        DECRESCEND = 8,
        DYNAFF = 16,
    }
end
