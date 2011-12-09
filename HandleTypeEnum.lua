--[[
  HandleTypeEnum.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

---
-- ハンドルのタイプを表現する列挙子
-- @class table
-- @name HandleTypeEnum
HandleTypeEnum = {
    ---
    -- 歌詞ハンドル
    -- @var integer
    Lyric = 0,

    ---
    -- ビブラートハンドル
    -- @var integer
    Vibrato = 1,

    ---
    -- 歌手ハンドル
    -- @var integer
    Singer = 2,

    ---
    -- アタックハンドル
    -- @var integer
    NoteHead = 3,

    ---
    -- Dynamics ハンドル
    -- @var integer
    Dynamics = 4

};
