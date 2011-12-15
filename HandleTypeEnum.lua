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

module( "luavsq" );

---
-- {@link Handle} の種類を表現する列挙子
-- @class table
-- @name HandleTypeEnum
HandleTypeEnum = {
    ---
    -- 歌詞ハンドル
    -- @var int
    LYRIC = 0,

    ---
    -- ビブラートハンドル
    -- @var int
    VIBRATO = 1,

    ---
    -- 歌手ハンドル
    -- @var int
    SINGER = 2,

    ---
    -- アタックハンドル
    -- @var int
    NOTE_HEAD = 3,

    ---
    -- Dynamics ハンドル
    -- @var int
    DYNAMICS = 4

};
