--[[
  Log.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

---
-- ロガー
-- @class table
-- @name Log
-- @access private
Log = {};

---
-- ログレベル
-- @var int
-- @access private static
Log._level = 0;

---
-- ログファイルのファイルハンドル
-- @var userdata
-- @access private static
Log._fileHandle = nil;

---
-- ログレベルを設定する
-- @param level (int) ログを記録しない場合 0 以下の値を、記録する場合は 0 より大きい値を設定する
-- @access static
function Log.setLevel( level )
    Log._level = level;
end

---
-- 文字列をログに出力する。改行は付加されない
-- @param message (string) ログ出力する文字列
-- @access static
function Log.print( message )
    if( Log._level > 0 )then
        local fp = Log._getFileHandle();
        fp:write( message );
        fp:flush();
    end
end

---
-- 文字列をログに出力する。文字列の末尾に改行が追加される
-- @param message (string) ログ出力する文字列
-- @access private static
function Log.println( message )
    if( Log._level > 0 )then
        local fp = Log._getFileHandle();
        fp:write( message .. "\n" );
        fp:flush();
    end
end

---
-- ログファイルのファイルハンドルを取得する
-- @return (userdata) ログファイルのファイルハンドル
-- @access private static
function Log._getFileHandle()
    if( Log._fileHandle == nil )then
        Log._fileHandle = io.open( "..\\luavsq.log", "a" );
        Log._fileHandle:write( "========================================================================\n" );
        Log._fileHandle:write( "Log start: " .. os.date() .. "\n" );
    end
    return Log._fileHandle;
end
