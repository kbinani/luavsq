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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.HandleTypeEnum )then

    ---
    -- ハンドルのタイプを表現する列挙子
    -- @class table
    -- @name HandleTypeEnum
    luavsq.HandleTypeEnum = {

        Lyric = 0,
        Vibrato = 1,
        Singer = 2,
        NoteHead = 3,
        Dynamics = 4

    };

end
