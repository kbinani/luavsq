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

if( luavsq == nil )then
    luavsq = {};
end

if( luavsq.Util == nil )then

    luavsq.Util = {};

    ---
    -- value で指定された文字列を、splitter で区切る
    -- @param value String
    -- @param splitter table
    -- @return table 区切られた文字列のテーブル
    luavsq.Util.split = function( value, splitter )
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
    -- 指定された個数のnil要素を含む配列を取得する
    -- @param count integer
    -- @return table
    luavsq.Util.array = function( count )
        local result = {};
        for i = 1, count, 1 do
            table.insert( result, nil );
        end
        return result;
    end

end
