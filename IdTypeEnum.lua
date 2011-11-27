--[[
  IdTypeEnum.lua
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

if( nil == luavsq.IdTypeEnum )then

    ---
    -- Id の種類を表現する列挙子
    -- @class table
    -- @name luavsq.IdTypeEnum
    -- @field Singer 歌手
    -- @field Anote 歌詞
    -- @field Aicon アイコン
    -- @field Unknown 不明
    luavsq.IdTypeEnum = {

        Singer = 0,
        Anote = 1,
        Aicon = 2,
        Unknown = -1

    };

    ---
    -- 文字列に変換する
    -- @param value (luavsq.IdTypeEnum) 指定された列挙子の文字列表現
    function luavsq.IdTypeEnum.toString( value )
        if( value == luavsq.IdTypeEnum.Singer )then
            return "Singer";
        elseif( value == luavsq.IdTypeEnum.Anote )then
            return "Anote";
        elseif( value == luavsq.IdTypeEnum.Aicon )then
            return "Aicon";
        else
            return "Unknown";
        end
    end

end
