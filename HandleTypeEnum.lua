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
-- @field Lyric 歌詞ハンドル
-- @field Vibrato ビブラートハンドル
-- @field Singer 歌手ハンドル
-- @field NoteHead アタックハンドル
-- @field Dynamics Dynamics ハンドル
HandleTypeEnum = {

    Lyric = 0,
    Vibrato = 1,
    Singer = 2,
    NoteHead = 3,
    Dynamics = 4

};
