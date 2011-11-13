--[[
  DynamicsModeEnum.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPLv3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.DynamicsModeEnum )then

    ---
    -- VOCALOID1における、ダイナミクスモードを表す定数を格納するためのクラスです。
    luavsq.DynamicsModeEnum = {};

    ---
    -- デフォルトのダイナミクスモードです。DYNカーブが非表示になるモードです。
    luavsq.DynamicsModeEnum.Standard = 0;

    ---
    -- エキスパートモードです。DYNカーブが表示されます。
    luavsq.DynamicsModeEnum.Expert = 1;

end
