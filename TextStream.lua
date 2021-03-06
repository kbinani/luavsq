--[[
  TextStream.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local table = table;
local math = math;

module( "luavsq" );

---
-- 文字列への読み書きストリーム
-- @class table
-- @name TextStream
TextStream = {};

---
-- 初期化を行う
-- @return (TextStream)
-- @access static ctor
function TextStream.new()
    local this = {};

    ---
    -- 書き込まれたデータを保持するバッファー
    -- @var table
    -- @access private
    this._array = {};

    ---
    -- データの現在の長さ
    -- @var int
    -- @access private
    this._length = 0;

    ---
    -- 現在の読み書き位置
    -- @var int
    -- @access private
    this._position = -1;

    ---
    -- 現在の読み書き位置を取得する
    -- @return (int) 現在の読み書き位置
    function this:getPointer()
        return self._position;
    end

    ---
    -- 現在の読み書き位置を設定する
    -- @param value (int) 設定する読み書き位置
    function this:setPointer( value )
        self._position = value;
    end

    ---
    -- 現在の読み込み位置から 1 文字を読み込み、読み書き位置を一つ進める
    -- @return (string) 読み込んだ文字
    function this:get()
        self._position = self._position + 1;
        return self._array[self._position + 1];
    end

    ---
    -- 現在の読み込み位置から、改行またはファイル末端まで読み込む
    -- @return (string) 読み込んだ文字列
    function this:readLine()
        local sb = "";
        -- '\n'が来るまで読み込み
        while( self._position + 1 < self._length )do
            self._position = self._position + 1;
            local c = self._array[self._position + 1];
            if( c == "\n" )then
                break;
            end
            sb = sb .. c;
        end
        return sb;
    end

    ---
    -- テキストストリームが読み込み可能な状態かどうかを返す
    -- @return (boolean) 読み込み可能であれば <code>true</code> を、そうでなければ <code>false</code> を返す
    function this:ready()
        if( 0 <= self._position + 1 and self._position + 1 < self._length )then
            return true;
        else
            return false;
        end
    end

    ---
    -- 内部のバッファー容量を確保する
    -- @param length (int) 確保したいバッファー容量
    -- @access private
    function this:_ensureCapacity( _length )
        if( _length > #self._array )then
            local add = _length - #self._array;
            for i = 1, add, 1 do
                table.insert( self._array, " " );
            end
        end
    end

    ---
    -- 文字列をストリームに書きこむ
    -- @param str (string) 書きこむ文字列
    function this:write( str )
        local len = str:len();
        local newSize = self._position + 1 + len;
        local offset = self._position + 1;
        self:_ensureCapacity( newSize );
        for i = 1, len, 1 do
            self._array[offset + i] = str:sub( i, i );
        end
        self._position = self._position + len;
        self._length = math.max( self._length, newSize );
    end

    ---
    -- 文字列をストリームに書きこむ。末尾に改行文字を追加する
    -- @param str (string) 書きこむ文字列
    function this:writeLine( str )
        local len = str:len();
        local offset = self._position + 1;
        local newSize = offset + len + 1;
        self:_ensureCapacity( newSize );
        for i = 1, len, 1 do
            self._array[offset + i] = str:sub( i, i );
        end
        self._array[offset + len + 1] = "\n";
        self._position = self._position + len + 1;
        self._length = math.max( self._length, newSize );
    end

    ---
    -- ストリームを閉じる
    function this:close()
        self._array = nil;
        self._length = 0;
    end

    ---
    -- ストリームに書きこまれた文字列を連結し、返す
    -- @return (string) 文字列
    function this:toString()
        local ret = "";
        for i = 1, self._length, 1 do
            ret = ret .. self._array[i];
        end
        return ret;
    end

    return this;
end
