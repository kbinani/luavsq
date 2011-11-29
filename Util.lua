--[[
  Util.lua
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
-- ユーティリティクラス
-- @class table
-- @name Util
Util = {};

---
-- value で指定された文字列を、splitter で区切る
-- @param value (string) 区切られる文字列
-- @param splitter (string) 区切り文字
-- @return (table) 区切られた文字列のテーブル
function Util.split( value, splitter )
    local init = 1;
    local result = {};
    local token = "";
    while true do
        local startIndex, endIndex = value:find( splitter, init, true );
        if( startIndex == nil )then
            break;
        end
        token = value:sub( init, startIndex - 1 );
        table.insert( result, token );
        init = startIndex + splitter:len();
    end
    token = value:sub( init, value:len() );
    table.insert( result, token );
    return result;
end

---
-- 指定された個数の false 要素を含む配列を取得する
-- @param count (integer) 要素の個数
-- @return (table) 作成した配列
function Util.array( count )
    local result = {};
    local i;
    for i = 1, count, 1 do
        result[i] = false
    end
    return result;
end

---
-- 配列の中から、指定された要素を検索し、そのインデックスを取得する
-- @param array (table) 検索対象の配列
-- @param value (object) 検索するオブジェクト
-- @return (integer) 要素が見つかったインデックス。見つからなかった場合負の値を返す
function Util.searchArray( array, value )
    if( nil == array )then
        return -1;
    end
    local i;
    for i = 1, #array, 1 do
        if( value == array[i] )then
            return i;
        end
    end
    return -1;
end

---
-- バイト配列を、16 ビットの unsigned int 値を Big Endian とみなして数値に変換する
-- @param bytes (table<integer>) 変換元のバイト列
-- @return (integer) 変換後の数値
function Util.makeUInt16BE( bytes )
    return bytes[1] * 0x100 + bytes[2];
end

---
-- バイト配列を、32 ビットの unsigned int 値を Big Endian とみなして数値に変換する
-- @param bytes (table<integer>) 変換元のバイト列
-- @return (integer) 変換後の数値
function Util.makeUInt32BE( bytes )
    return bytes[1] * 0x1000000 + bytes[2] * 0x10000 + bytes[3] * 0x100 + bytes[4];
end

---
-- 16bit の unsigned int 値を Big Endian のバイト列に変換する
-- @param value (integer) 変換元の数値
-- @return (table<integer>) 変換後のバイト列
function Util.getBytesUInt16BE( value )
    local result = {};
    result[2] = Util.band( value, 0xff );
    value = Util.rshift( value, 8 );
    result[1] = Util.band( value, 0xff );
    return result;
end

---
-- 32bit の unsigned int 値を Big Endian のバイト列に変換する
-- @param value (integer) 変換元の数値
-- @return (table<integer>) 変換後のバイト列
function Util.getBytesUInt32BE( data )
    local dat = {};
    data = Util.band( 0xffffffff, data );
    dat[4] = Util.band( data, 0xff );
    data = Util.rshift( data, 8 );
    dat[3] = Util.band( data, 0xff );
    data = Util.rshift( data, 8 );
    dat[2] = Util.band( data, 0xff );
    data = Util.rshift( data, 8 );
    dat[1] = Util.band( data, 0xff );
    return dat;
end

---
-- 配列を、範囲を指定して並び替える
-- @param array (table) 並び替えるテーブル
-- @param startIndex (number) 並び替える範囲の開始位置(先頭が0)
-- @param length (number) 並び替える範囲の長さ
function Util.sort( array, startIndex, length )
    local spliced = {};
    local i;
    for i = startIndex + 1, startIndex + length, 1 do
        table.insert( spliced, array[i] );
    end
    table.sort( spliced );
    local j;
    for j = startIndex + 1, startIndex + length, 1 do
        array[j] = spliced[j - startIndex];
    end
end

---
-- ビット演算 AND
-- @param 可変長引数。AND 演算を行う数値を指定する
-- @return (number) AND 演算の結果
function Util.band( ... )
    local arguments = { ... };
    if( #arguments == 0 )then
        return nil;
    end
    local j;
    for j = 1, #arguments, 1 do
        if( type( arguments[j] ) ~= "number" )then
            return nil;
        end
        arguments[j] = math.floor( arguments[j] );
    end
    local result = 0;
    local i = 0;
    while( true )do
        local p = 2 ^ i;

        local exitHere = true;
        for j = 1, #arguments, 1 do
            if( arguments[j] >= p )then
                exitHere = false;
                break;
            end
        end
        if( exitHere )then
            break;
        end

        local p2 = p + p;
        local add = true;
        for j = 1, #arguments, 1 do
            if( arguments[j] % p2 < p )then
                add = false;
                break;
            end
        end
        if( add )then
            result = result + p;
        end
        i = i + 1;
    end
    return result;
end

---
-- ビット演算 OR
-- @param 可変長引数。OR 演算を行う数値を指定する
-- @return (number) OR 演算の結果
function Util.bor( ... )
    local arguments = { ... };
    if( #arguments == 0 )then
        return nil;
    end
    local j;
    for j = 1, #arguments, 1 do
        if( type( arguments[j] ) ~= "number" )then
            return nil;
        end
        arguments[j] = math.floor( arguments[j] );
    end
    local result = 0;
    local i = 0;
    while( true )do
        local p = 2 ^ i;

        local exitHere = true;
        for j = 1, #arguments, 1 do
            if( arguments[j] >= p )then
                exitHere = false;
                break;
            end
        end
        if( exitHere )then
            break;
        end

        local p2 = p + p;
        local add = false;
        for j = 1, #arguments, 1 do
            if( arguments[j] % p2 >= p )then
                add = true;
                break;
            end
        end
        if( add )then
            result = result + p;
        end
        i = i + 1;
    end
    return result;
end

---
-- 左シフト演算(64bitまでを考慮)
-- @param n (integer) 演算対象の数値
-- @param shift (integer) シフトするビット数
-- @return (integer) 演算結果
function Util.lshift( n, shift )
    n = math.floor( n );
    local i;
    for i = 0, shift - 1, 1 do
        if( n >= 0x8000000000000000 )then
            n = n % 0x8000000000000000;
        end
        n = n * 2;
    end
    return n;
end

---
-- 右シフト演算
-- @param n (integer) 演算対象の数値
-- @param shift (integer) シフトするビット数
-- @return (integer) 演算結果
function Util.rshift( n, shift )
    n = math.floor( n );
    local i;
    for i = 0, shift - 1, 1 do
        n = math.floor( n / 2 );
    end
    return n;
end

---
-- 文字列のバイトを取り出して配列にしたものを返す
-- @param string_ (string) 変換元の文字列
-- @return (table<integer>) 変換後のバイト列
function Util.stringToArray( string_ )
    local count = string_:len();
    local result = {};
    local i;
    for i = 1, count, 1 do
        table.insert( result, string.byte( string_:sub( i, i ) ) );
    end
    return result;
end
