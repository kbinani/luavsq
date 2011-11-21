--[[
  PhoneticSymbol.lua
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

if( nil == luavsq.PhoneticSymbol )then

    ---
    -- VSQで使用される発音記号の種類や有効性を判定するユーティリティ群です。
    luavsq.PhoneticSymbol = {};

    ---
    -- 日本語の母音発音記号
    luavsq.PhoneticSymbol._SYMBOL_VOWEL_JP = "\ta\ti\tM\te\to\t";

    ---
    -- 日本語の子音発音記号
    luavsq.PhoneticSymbol._SYMBOL_CONSONANT_JP = "\tk\tk'\tg\tg'\tN\tN'\ts\tS\tz\tZ\tdz\tdZ\tt\tt'\tts\ttS\td\td'\tn\tJ\th\th\\\tC\tp\\\tp\\'\tb\tb'\tp\tp'\tm\tm'\tj\t4\t4'\tw\tN\\\t";

    ---
    -- 英語の母音発音記号
    luavsq.PhoneticSymbol._SYMBOL_VOWEL_EN = "\t@\tV\te\te\tI\ti:\t{\tO:\tQ\tU\tu:\t@r\teI\taI\tOI\t@U\taU\tI@\te@\tU@\tO@\tQ@\t";

    ---
    -- 英語の子音発音記号
    luavsq.PhoneticSymbol._SYMBOL_CONSONANT_EN = "\tw\tj\tb\td\tg\tbh\tdh\tgh\tdZ\tv\tD\tz\tZ\tm\tn\tN\tr\tl\tl0\tp\tt\tk\tph\tth\tkh\ttS\tf\tT\ts\tS\th\tSil\tAsp\t";

    ---
    -- 指定した文字列が子音を表す発音記号かどうかを判定します。
    -- @param symbol String
    -- @return boolean
    function luavsq.PhoneticSymbol.isConsonant( symbol )
        local search = "\t" .. symbol .. "\t";
        local startIndex, endIndex = luavsq.PhoneticSymbol._SYMBOL_CONSONANT_JP:find( search );
        if( startIndex ~= nil )then
            return true;
        else
            startIndex, endIndex = luavsq.PhoneticSymbol._SYMBOL_CONSONANT_EN:find( search );
            if( startIndex ~= nil )then
                return true;
            end
        end
        return false;
    end

    ---
    -- 指定した文字列が母音を表す発音記号かどうかを判定します。
    -- @param symbol String
    -- @return boolean
    function luavsq.PhoneticSymbol.isVowel( symbol )
        local search = "\t" .. symbol .. "\t";
        local startIndex, endIndex = luavsq.PhoneticSymbol._SYMBOL_VOWEL_JP:find( search );
        if( startIndex ~= nil )then
            return true;
        else
            startIndex, endIndex = luavsq.PhoneticSymbol._SYMBOL_VOWEL_EN:find( search );
            if( startIndex ~= nil )then
                return true;
            end
        end
        return false;
    end

    ---
    -- 指定した文字列が発音記号として有効かどうかを判定します。
    -- @param symbol String
    -- @return boolean
    function luavsq.PhoneticSymbol.isValidSymbol( symbol )
        local isVowel = luavsq.PhoneticSymbol.isVowel( symbol );
        local isConsonant = luavsq.PhoneticSymbol.isConsonant( symbol );
        if( isVowel or isConsonant )then
            return true;
        end

        -- ブレスの判定
        local symbolCharacterCount = symbol:len();
        if( symbol:find( "br" ) == 1 and symbolCharacterCount > 2 )then
            local s = symbol:sub( 3, symbolCharacterCount );
            -- br001とかをfalseにするためのチェック
            if( nil == tonumber( s ) )then
                return false;
            else
                return true;
            end
        end
        return false;
    end
end
