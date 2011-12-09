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

---
-- VOCALOID で使用されるシーケンスのデータ構造を保持するクラスと、
-- それらの編集操作やファイルへの書き出し処理を行うユーティリティが含まれる。
-- @class module
-- @name luavsq
module( "luavsq" );

---
-- アイコン設定の種類を表す
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
