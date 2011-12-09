--[[
  EventList.IndexItertorKindEnum.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

if( nil == EventList )then
    EventList = {};
end

---
-- IndexIterator の反復子の種類を表す列挙子
-- @class table
-- @name EventList.IndexIteratorKindEnum
EventList.IndexIteratorKindEnum = {
    ---
    -- 全てのイベント
    -- @var integer
    ALL = 0xffff,

    ---
    -- 歌手イベント
    -- @var integer
    SINGER = 1,

    ---
    -- 音符イベント
    -- @var integer
    NOTE = 2,

    ---
    -- クレッシェンドイベント
    -- @var integer
    CRESCEND = 4,

    ---
    -- デクレッシェンドイベント
    -- @var integer
    DECRESCEND = 8,

    ---
    -- 強弱記号イベント
    -- @var integer
    DYNAFF = 16,
}
