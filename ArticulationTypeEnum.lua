--[[
  ArticulationTypeEnum.lua
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
-- アイコン設定の種類を表します。
-- @class table
-- @name ArticulationTypeEnum
ArticulationTypeEnum = {
    ---
    -- ビブラート
    -- @var integer
    Vibrato = 0,

    ---
    -- クレッシェンド、またはデクレッシェンド
    -- @var integer
    Crescendo = 1,

    ---
    -- ピアノ、フォルテ等の強弱記号
    -- @var integer
    Dynaff = 2,

    ---
    -- アタック
    -- @var integer
    NoteAttack = 3,

    ---
    -- NoteTransition(詳細不明)
    -- @var integer
    NoteTransition = 4,
};
