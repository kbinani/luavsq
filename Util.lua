--[[
  Util.lua
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

if( nil == luavsq.Util )then

    luavsq.Util = {};

    ---
    -- value で指定された文字列を、splitter で区切る
    -- @param value string
    -- @param splitter string
    -- @return table 区切られた文字列のテーブル
    function luavsq.Util.split( value, splitter )
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
    -- @param count integer
    -- @return table
    function luavsq.Util.array( count )
        local result = {};
        local i;
        for i = 1, count, 1 do
            result[i] = false
        end
        return result;
    end

    ---
    -- @param array (table)
    -- @param value (object)
    function luavsq.Util.searchArray( array, value )
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
    -- @param bytes (table<number>)
    -- @return number
    function luavsq.Util.makeUInt16BE( bytes )
        return bytes[1] * 0x100 + bytes[2];
    end

    ---
    -- @param bytes (table<number>)
    -- @return number
    function luavsq.Util.makeUInt32BE( bytes )
        return bytes[1] * 0x1000000 + bytes[2] * 0x10000 + bytes[3] * 0x100 + bytes[4];
    end

    ---
    -- @param array (table) 並び替えるテーブル
    -- @param startIndex (number) 並び替える範囲の開始位置(先頭が0)
    -- @param length (number) 並び替える範囲の長さ
    function luavsq.Util.sort( array, startIndex, length )
        local spliced = {};
        local i;
        for i = startIndex + 1, startIndex + 1 + length, 1 do
            table.insert( spliced, array[i] );
        end
        table.sort( spliced );
        for i = startIndex + 1, startIndex + 1 + length, 1 do
            array[i] = spliced[i - startIndex];
        end
    end

    ---
    -- ビット演算 AND
    -- @param a (number)
    -- @param b (number)
    -- @return (number)
    function luavsq.Util.band( ... )
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
    -- @param a (number)
    -- @param b (number)
    -- @return (number)
    function luavsq.Util.bor( ... )
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
end
