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

local tonumber = tonumber;

module( "luavsq" );

---
-- VSQ で使用される発音記号のためのユーティリティ
-- @class table
-- @name PhoneticSymbol
PhoneticSymbol = {};

---
-- 日本語の母音発音記号
PhoneticSymbol._SYMBOL_VOWEL_JP = "\ta\ti\tM\te\to\t";

---
-- 日本語の子音発音記号
PhoneticSymbol._SYMBOL_CONSONANT_JP = "\tk\tk'\tg\tg'\tN\tN'\ts\tS\tz\tZ\tdz\tdZ\tt\tt'\tts\ttS\td\td'\tn\tJ\th\th\\\tC\tp\\\tp\\'\tb\tb'\tp\tp'\tm\tm'\tj\t4\t4'\tw\tN\\\t";

---
-- 英語の母音発音記号
PhoneticSymbol._SYMBOL_VOWEL_EN = "\t@\tV\te\te\tI\ti:\t{\tO:\tQ\tU\tu:\t@r\teI\taI\tOI\t@U\taU\tI@\te@\tU@\tO@\tQ@\t";

---
-- 英語の子音発音記号
PhoneticSymbol._SYMBOL_CONSONANT_EN = "\tw\tj\tb\td\tg\tbh\tdh\tgh\tdZ\tv\tD\tz\tZ\tm\tn\tN\tr\tl\tl0\tp\tt\tk\tph\tth\tkh\ttS\tf\tT\ts\tS\th\tSil\tAsp\t";

---
-- 指定した文字列が子音を表す発音記号かどうかを判定する
-- @param symbol (string) 判定対象の発音記号
-- @return (boolean) 子音であれば true を、そうでなければ false を返す
-- @name isConsonant
-- @access static
function PhoneticSymbol.isConsonant( symbol )
    local search = "\t" .. symbol .. "\t";
    local startIndex, endIndex = PhoneticSymbol._SYMBOL_CONSONANT_JP:find( search );
    if( startIndex ~= nil )then
        return true;
    else
        startIndex, endIndex = PhoneticSymbol._SYMBOL_CONSONANT_EN:find( search );
        if( startIndex ~= nil )then
            return true;
        end
    end
    return false;
end

---
-- 指定した文字列が母音を表す発音記号かどうかを判定する
-- @param symbol (string) 判定対象の発音記号
-- @return (boolean) 母音であれば true を、そうでなければ false を返す
-- @name isVowel
-- @access static
function PhoneticSymbol.isVowel( symbol )
    local search = "\t" .. symbol .. "\t";
    local startIndex, endIndex = PhoneticSymbol._SYMBOL_VOWEL_JP:find( search );
    if( startIndex ~= nil )then
        return true;
    else
        startIndex, endIndex = PhoneticSymbol._SYMBOL_VOWEL_EN:find( search );
        if( startIndex ~= nil )then
            return true;
        end
    end
    return false;
end

---
-- 指定した文字列が発音記号として有効かどうかを判定する
-- @param symbol (string) 判定対象の発音記号
-- @return (boolean) 有効であれば true を、そうでなければ false を返す
-- @name isValidSymbol
-- @access static
function PhoneticSymbol.isValidSymbol( symbol )
    local isVowel = PhoneticSymbol.isVowel( symbol );
    local isConsonant = PhoneticSymbol.isConsonant( symbol );
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
