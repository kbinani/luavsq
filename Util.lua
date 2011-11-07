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
end
