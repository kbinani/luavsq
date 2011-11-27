--[[
  Log.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.Log )then

    ---
    -- ロガー
    -- @class table
    -- @name luavsq.Log
    luavsq.Log = {};

    luavsq.Log._level = 0;
    luavsq.Log._fileHandle = nil;

    ---
    -- ログレベルを設定する
    -- @param level (integer) ログを記録しない場合 0 以下の値を、記録する場合は 0 より大きい値を設定する
    function luavsq.Log.setLevel( level )
        luavsq.Log._level = level;
    end

    ---
    -- 文字列をログに出力する。改行は付加されない
    -- @param message (string) ログ出力する文字列
    function luavsq.Log.print( message )
        if( luavsq.Log._level > 0 )then
            local fp = luavsq.Log._getFileHandle();
            fp:write( message );
            fp:flush();
        end
    end

    ---
    -- 文字列をログに出力する。文字列の末尾に改行が追加される
    -- @param message (string) ログ出力する文字列
    function luavsq.Log.println( message )
        if( luavsq.Log._level > 0 )then
            local fp = luavsq.Log._getFileHandle();
            fp:write( message .. "\n" );
            fp:flush();
        end
    end

    function luavsq.Log._getFileHandle()
        if( luavsq.Log._fileHandle == nil )then
            luavsq.Log._fileHandle = io.open( "..\\luavsq.log", "a" );
            luavsq.Log._fileHandle:write( "========================================================================\n" );
            luavsq.Log._fileHandle:write( "Log start: " .. os.date() .. "\n" );
        end
        return luavsq.Log._fileHandle;
    end

end
