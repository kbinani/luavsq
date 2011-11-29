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
-- @field Vibrato ビブラート
-- @field Crescendo クレッシェンド、またはデクレッシェンド
-- @field Dynaff ピアノ、フォルテ等の強弱記号
-- @field NoteAttack アタック
-- @field NoteTransition NoteTransition(詳細不明)
ArticulationTypeEnum = {
    ---
    -- ビブラート
    Vibrato = 0,

    ---
    -- クレッシェンド、またはデクレッシェンド
    Crescendo = 1,

    ---
    -- ピアノ、フォルテ等の強弱記号
    Dynaff = 2,

    ---
    -- アタック
    NoteAttack = 3,

    ---
    -- NoteTransition(詳細不明)
    NoteTransition = 4,
};
