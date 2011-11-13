--[[
  ArticulationTypeEnum.lua
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

if( nil == luavsq.ArticulationTypeEnum )then
    ---
    -- アイコン設定の種類を表します。
    luavsq.ArticulationTypeEnum = {};

    ---
    -- ビブラート
    luavsq.ArticulationTypeEnum.Vibrato = 0;

    ---
    -- クレッシェンド、またはデクレッシェンド
    luavsq.ArticulationTypeEnum.Crescendo = 1;

    ---
    -- ピアノ、フォルテ等の強弱記号
    luavsq.ArticulationTypeEnum.Dynaff = 2;

    ---
    -- アタック
    luavsq.ArticulationTypeEnum.NoteAttack = 3;

    ---
    -- NoteTransition(詳細不明)
    luavsq.ArticulationTypeEnum.NoteTransition = 4;

end
