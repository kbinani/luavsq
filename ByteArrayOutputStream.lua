--[[
  ByteArrayOutputStream.lua
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

if( nil == luavsq.ByteArrayOutputStream )then

    luavsq.ByteArrayOutputStream = {};

    function luavsq.ByteArrayOutputStream.new()
        local this = {};
        this._array = {};

        function this:write( ... )
            local arguments = { ... };
            if( #arguments == 1 )then
                self:_write_1( arguments[1] );
            elseif( #arguments == 3 )then
                self:_write_3( arguments[1], arguments[2], arguments[3] );
            end
        end

        ---
        -- 指定された配列の、指定した範囲のバイト値をストリームに書きこむ
        -- @param (table) array 書きこむバイト列が格納された配列
        -- @param (integer) startIndex 書き込み開始位置
        -- @param (integer) length 書き込むバイト値の個数
        function this:_write_3( array, startIndex, length )
            local i;
            for i = startIndex, startIndex + length - 1, 1 do
                table.insert( self._array, array[i] );
            end
        end

        ---
        -- 指定されたバイト値をストリームに書きこむ
        -- @param (number) 書きこむバイト値
        function this:_write_1( byte )
            table.insert( self._array, byte );
        end

        ---
        -- バイト列を文字列に変換する
        -- @return (string)
        function this:toString()
            local result = "";
            local i;
            for i = 1, #self._array, 1 do
                result = result .. string.char( self._array[i] );
            end
            return result;
        end

        return this;
    end

end
