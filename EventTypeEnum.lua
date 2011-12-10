--[[
  EventTypeEnum.lua
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
-- {@link Event} の種類を表現する列挙子
-- @class table
-- @name EventTypeEnum
EventTypeEnum = {
    ---
    -- 歌手
    -- @var int
    SINGER = 0,

    ---
    -- 歌詞
    -- @var int
    NOTE = 1,

    ---
    -- アイコン
    -- @var int
    ICON = 2,

    ---
    -- 不明
    -- @var int
    UNKNOWN = -1

};

---
-- 文字列に変換する
-- @param value (EventTypeEnum) 指定された列挙子の文字列表現
-- @return (string) 変換後の文字列
function EventTypeEnum.toString( value )
    if( value == EventTypeEnum.SINGER )then
        return "Singer";
    elseif( value == EventTypeEnum.NOTE )then
        return "Anote";
    elseif( value == EventTypeEnum.ICON )then
        return "Aicon";
    else
        return "Unknown";
    end
end
