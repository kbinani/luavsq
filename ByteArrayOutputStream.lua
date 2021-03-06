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

local table = table;
local string = string;

module( "luavsq" );

---
-- データがバイト配列に書き込まれるストリームの実装
-- @class table
-- @name ByteArrayOutputStream
ByteArrayOutputStream = {};

---
-- 初期化を行う
-- @return (ByteArrayOutputStream)
-- @access static ctor
function ByteArrayOutputStream.new()
    local this = {};

    ---
    -- 現在のファイルポインタ
    -- @var int
    -- @access private
    this._pointer = -1;

    ---
    -- 書き込み先のバイト列
    -- @var table
    -- @access private
    this._array = {};

    --
    -- ストリームにデータを書き込む
    function this:write( ... )
        local arguments = { ... };
        if( #arguments == 1 )then
            self:_write_1( arguments[1] );
        elseif( #arguments == 3 )then
            self:_write_3( arguments[1], arguments[2], arguments[3] );
        end
    end

    ---
    -- 指定されたバイト値をストリームに書きこむ
    -- @param byte (int) 書きこむバイト値
    -- @name write<!--1-->
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
    -- 指定された配列の、指定した範囲のバイト値をストリームに書きこむ
    -- @param array (table) 書きこむバイト列が格納された配列
    -- @param startIndex (int) 書き込み開始位置
    -- @param length (int) 書き込むバイト値の個数
    -- @name write<!--2-->
    function this:_write_3( array, startIndex, length )
        local i;
        for i = 1, length, 1 do
            self:_write_1( array[startIndex + i - 1] );
        end
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
    -- @return (int) 現在のファイルポインタ
    function this:getPointer()
        return self._pointer;
    end

    ---
    -- ファイルポインタを指定した位置に変更する
    -- @param position (int) 新しいポインタ値
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
