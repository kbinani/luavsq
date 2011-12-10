--[[
  VoiceLanguageEnum.lua
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
-- 歌手の歌唱言語を表す列挙子
-- @class table
-- @name VoiceLanguageEnum
VoiceLanguageEnum = {
    ---
    -- 日本語
    -- @var int
    JAPANESE = 0,

    ---
    -- 英語
    -- @var int
    ENGLISH = 1,
};

---
-- 歌手の名前から、その歌手の歌唱言語を取得する
-- @param name (string) 歌手の名前
-- @return (VoiceLanguageEnum) 歌唱言語
-- @access static
function VoiceLanguageEnum.valueFromSingerName( name )
    local search = name:lower();
    if( search == "meiko" or
        search == "kaito" or
        search == "miku" or
        search == "rin" or
        search == "len" or
        search == "rin_act2" or
        search == "len_act2" or
        search == "gackpoid" or
        search == "luka_jpn" or
        search == "megpoid" or
        search == "sfa2_miki" or
        search == "yuki" or
        search == "kiyoteru" or
        search == "miku_sweet" or
        search == "miku_dark" or
        search == "miku_soft" or
        search == "miku_light" or
        search == "miku_vivid" or
        search == "miku_solid" )then
        return VoiceLanguageEnum.JAPANESE;
    elseif( search == "sweet_ann" or
        search == "prima" or
        search == "luka_eng" or
        search == "sonika" or
        search == "lola" or
        search == "leon" or
        search == "miriam" or
        search == "big_al" )then
        return VoiceLanguageEnum.ENGLISH;
    end
    return VoiceLanguageEnum.JAPANESE;
end
