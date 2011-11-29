--[[
  ByteArrayOutputStream.lua
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
-- データがバイト配列に書き込まれるストリームの実装
-- @class table
-- @name ByteArrayOutputStream
ByteArrayOutputStream = {};

---
-- 初期化を行う
-- @return (ByteArrayOutputStream)
function ByteArrayOutputStream.new()
    local this = {};
    this._pointer = -1;
    this._array = {};

    ---
    -- ストリームにデータを書き込む
    -- @see this:_write_3
    -- @see this:_write_1
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
        for i = 1, length, 1 do
            self:_write_1( array[startIndex + i - 1] );
        end
    end

    ---
    -- 指定されたバイト値をストリームに書きこむ
    -- @param (integer) 書きこむバイト値
    function this:_write_1( byte )
        if( byte == nil )then
            byte = 0;
        end
        local index = self._pointer + 2;
        local remain = index - #self._array;
        if( remain > 0 )then
            local i;
            for i = 1, remain, 1 do
                table.insert( self._array, 0 );
            end
        end
        self._array[index] = byte;
        self._pointer = self._pointer + 1;
    end

    ---
    -- バイト列を文字列に変換する
    -- @return (string) 変換された文字列
    function this:toString()
        local result = "";
        local i;
        for i = 1, #self._array, 1 do
            result = result .. string.char( self._array[i] );
        end
        return result;
    end

    ---
    -- 現在のファイルポインタを取得する
    -- @return (integer) 現在のファイルポインタ
    function this:getPointer()
        return self._pointer;
    end

    ---
    -- ファイルポインタを指定した位置に変更する
    -- @param (integer) position 新しいポインタ値
    function this:seek( position )
        self._pointer = position;
    end

    ---
    -- ストリームを閉じる
    function this:close()
        --do nothing
    end

    return this;
end
