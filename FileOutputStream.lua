--[[
  FileOutputStream.lua
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
-- ファイルへの出力ストリーム
-- @class table
-- @name FileOutputStream
FileOutputStream = {};

---
-- 初期化を行う
-- @param path (string) ファイルのパス
-- @return (FileOutputStream)
-- @name <i>new</i>
function FileOutputStream.new( path )
    local this = {};
    this._fileHandle = io.open( path, "wb" );

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
    -- 指定された配列の、指定した範囲のバイト値をストリームに書きこむ
    -- @param (table<integer>) array 書きこむバイト列が格納された配列
    -- @param (integer) startIndex 書き込み開始位置
    -- @param (integer) length 書き込むバイト値の個数
    -- @name write<sup>2</sup>
    function this:_write_3( array, startIndex, length )
        local i;
        for i = 1, length, 1 do
            self:_write_1( array[startIndex + i - 1] );
        end
    end

    ---
    -- 指定されたバイト値をストリームに書きこむ
    -- @param (integer) 書きこむバイト値
    -- @name write<sup>1</sup>
    function this:_write_1( byte )
        if( nil == byte )then
            byte = 0;
        end
        self._fileHandle:write( string.char( byte ) );
    end

    ---
    -- 現在のファイルポインタを取得する
    -- @return (integer) 現在のファイルポインタ
    -- @name getPointer
    function this:getPointer()
        return self._fileHandle:seek();
    end

    ---
    -- ファイルポインタを指定した位置に移動する
    -- @param position (integer) ファイルポインタ
    -- @name seek
    function this:seek( position )
        self._fileHandle:seek( "set", position );
    end

    ---
    -- ストリームを閉じる
    -- @name close
    function this:close()
        self._fileHandle:flush();
        self._fileHandle:close();
    end

    return this;
end
