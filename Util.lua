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

local table = table;
local math = math;
local type = type;
local string = string;
local pairs = pairs;

module( "luavsq" );

---
-- ユーティリティクラス
-- @class table
-- @name Util
Util = {};

---
-- <code>value</code> で指定された文字列を、<code>splitter</code> で区切る
-- @param value (string) 区切られる文字列
-- @param splitter (string) 区切り文字
-- @return (table) 区切られた文字列のテーブル
-- @name split
-- @access static
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
-- 指定された個数の <code>false</code> 要素を含む配列を取得する
-- @param count (integer) 要素の個数
-- @return (table) 作成した配列
-- @name array
-- @access static
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
-- @name searchArray
-- @access static
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
-- @name makeUInt16BE
-- @access static
function Util.makeUInt16BE( bytes )
    return bytes[1] * 0x100 + bytes[2];
end

---
-- バイト配列を、32 ビットの unsigned int 値を Big Endian とみなして数値に変換する
-- @param bytes (table<integer>) 変換元のバイト列
-- @return (integer) 変換後の数値
-- @name makeUInt32BE
-- @access static
function Util.makeUInt32BE( bytes )
    return bytes[1] * 0x1000000 + bytes[2] * 0x10000 + bytes[3] * 0x100 + bytes[4];
end

---
-- 16bit の unsigned int 値を Big Endian のバイト列に変換する
-- @param value (integer) 変換元の数値
-- @return (table<integer>) 変換後のバイト列
-- @name getBytesUInt16BE
-- @access static
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
-- @name getBytesUInt32BE
-- @access static
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
-- @name sort
-- @access static
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
-- @name band
-- @access static
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
-- @name bor
-- @access static
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
-- @name lshift
-- @access static
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
-- @name rshift
-- @access static
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
-- @param s (string) 変換元の文字列
-- @return (table<integer>) 変換後のバイト列
-- @name stringToArray
-- @access static
function Util.stringToArray( s )
    local count = s:len();
    local result = {};
    local i;
    for i = 1, count, 1 do
        table.insert( result, string.byte( s:sub( i, i ) ) );
    end
    return result;
end

---
-- 変数の中身をダンプする
-- @param value (?) ダンプする変数
-- @param option (table) ダンプ時の設定値
-- <ul>
--   <li>hex: 数値を 16 進数表記にする場合 <code>true</code> を設定する
--   <li>func: 関数をダンプする場合 <code>true</code> を設定する
-- </ul>
-- @return (string) 変数のダンプ
-- @name dump
-- @access static
function Util.dump( value, option )
    if( option == nil )then
        option = {};
    end
    if( type( option.hex ) == "nil" )then
        option.hex = false;
    end
    if( type( option.func ) == "nil" )then
        option.func = false;
    end
    return Util._dump( value, 0, {}, option );
end

---
-- @param value (?) ダンプする変数
-- @param depth (integer) ダンプのネスト深さ
-- @param state (table) ダンプ済みオブジェクトのテーブル
-- @param option (table) ダンプ時の設定値
-- @access static private
function Util._dump( value, depth, state, option )
    local hex = option.hex;
    if( hex == nil )then
        hex = false;
    end
    local func = option.func
    if( func == nil )then
        func = true;
    end

    local indent = string.rep( " ", 4 * depth );
    if( value == nil )then
        return indent .. "nil,";
    elseif( type( value ) == "boolean" )then
        if( value )then
            return indent .. "true,";
        else
            return indent .. "false,";
        end
    elseif( type( value ) == "string" )then
        return indent .. "'" .. value .. "',";
    elseif( type( value ) == "function" )then
        return indent .. "function,";
    elseif( type( value ) == "userdata" )then
        return indent .. "userdata,";
    elseif( type( value ) == "number" )then
        if( hex == false or value < 0 or value ~= math.floor( value ) )then
            return indent .. value .. ",";
        else
            return indent .. string.format( "0x%X", value ) .. ",";
        end
    elseif( type( value ) ~= "table" )then
        return indent .. value .. ",";
    else
        local i, s;
        local found = false;
        for i, s in pairs( state ) do
            if( s == value )then
                found = true;
                break;
            end
        end
        if( found )then
            return indent .. "(cycromatic reference),";
        else
            table.insert( state, value );
            local nextDepth = depth + 1;
            local str = "";
            local count = 0;
            for k, v in pairs( value ) do
                if( (func and type( v ) == "function") or type( v ) ~= "function" )then
                    local dumped = Util._dump( v, nextDepth, state, option );
                    while( dumped:len() > 0 and dumped:sub( 1, 1 ) == " " )do
                        dumped = dumped:sub( 2 );
                    end
                    local key;
                    if( type( k ) == "string" )then
                        key = "'" .. k .. "'";
                    else
                        key = "" .. k;
                    end
                    str = str .. indent .. "    " .. key .. " => " .. dumped .. "\n";
                    count = count + 1;
                end
            end
            if( count > 0 )then
                local result = indent .. "table(" .. count .. "){\n";
                result = result .. str;
                return result .. indent .. "},";
            else
                return indent .. "table(0){},";
            end
        end
    end
end

---
-- UTF8 の文字列を、1 文字ずつに分解した配列に変換します
-- @param utf8 (string) UTF8 の文字列
-- @return (table) 1 要素に 1 文字分の文字コードが入った配列
--                 例えば、<code>utf8 = "0あ"</code> の場合、戻り値は <code>{ { 0x30 }, { 0xE3, 0x81, 0x82 } }</code> となる
-- @name explodeUTF8String
-- @access static
function Util.explodeUTF8String( utf8 )
    if( nil == utf8 )then
        return {};
    end

    local result = {};
    local count = utf8:len();
    local i = 1;

    while( i <= count )do
        local codeBytes = {};
        local code = string.byte( utf8:sub( i, i ) );
        table.insert( codeBytes, code );
        local remain = 1;
        if( code <= 0x7F )then
            remain = 0;
        elseif( code <= 0xDF )then
            remain = 1;
        elseif( code <= 0xEF )then
            remain = 2;
        elseif( code <= 0xF7 )then
            remain = 3;
        elseif( code <= 0xFB )then
            remain = 4;
        else
            remain = 5;
        end
        local j;
        for j = 1, remain, 1 do
            table.insert( codeBytes, string.byte( utf8:sub( i + j, i + j ) ) );
        end
        table.insert( result, codeBytes );
        i = i + remain + 1;
    end

    return result;
end