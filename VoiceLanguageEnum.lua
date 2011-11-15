--[[
  VoiceLanguageEnum.lua
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

if( nil == luavsq.VoiceLanguageEnum )then

    ---
    -- Represents the voice language of singer.
    luavsq.VoiceLanguageEnum = {};

    ---
    -- Japanese
    luavsq.VoiceLanguageEnum.Japanese = 0;

    ---
    -- English
    luavsq.VoiceLanguageEnum.English = 1;

    ---
    -- 指定した名前の歌手の歌唱言語を取得します。
    --
    -- @param name [string] name of singer
    -- @return [VsqVoiceLanguage]
    function luavsq.VoiceLanguageEnum.valueFromSingerName( name )
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
            return luavsq.VoiceLanguageEnum.Japanese;
        elseif( search == "sweet_ann" or
            search == "prima" or
            search == "luka_eng" or
            search == "sonika" or
            search == "lola" or
            search == "leon" or
            search == "miriam" or
            search == "big_al" )then
            return luavsq.VoiceLanguageEnum.English;
        end
        return luavsq.VoiceLanguageEnum.Japanese;
    end

end