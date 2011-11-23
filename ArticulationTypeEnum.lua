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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.ArticulationTypeEnum )then
    ---
    -- アイコン設定の種類を表します。
    -- @class table
    -- @name ArticulationTypeEnum
    luavsq.ArticulationTypeEnum = {
        ---
        -- @field
        -- @name Vibrato
        -- @description ビブラート
        Vibrato = 0,

        ---
        -- クレッシェンド、またはデクレッシェンド
        -- @field
        Crescendo = 1,

        ---
        -- ピアノ、フォルテ等の強弱記号
        -- @field
        Dynaff = 2,

        ---
        -- アタック
        -- @field
        NoteAttack = 3,

        ---
        -- NoteTransition(詳細不明)
        -- @field
        NoteTransition = 4,
    };
end
