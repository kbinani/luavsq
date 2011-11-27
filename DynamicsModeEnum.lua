--[[
  DynamicsModeEnum.lua
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

if( nil == luavsq.DynamicsModeEnum )then

    ---
    -- VOCALOID1における、ダイナミクスモードを表す定数を格納するための列挙子
    -- @class table
    -- @name luavsq.DynamicsModeEnum
    -- @field Standard DYNカーブが非表示になるモード(デフォルト)
    -- @field Expert DYNカーブが表示されるモード(エキスパートモード)
    luavsq.DynamicsModeEnum = {
        ---
        -- DYNカーブが非表示になるモード(デフォルト)
        Standard = 0,

        ---
        -- DYNカーブが表示されるモード(エキスパートモード)
        Expert = 1
    };

end
