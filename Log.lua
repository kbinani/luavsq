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

    luavsq.Log = {};

    luavsq.Log._level = 0;
    luavsq.Log._fileHandle = nil;

    function luavsq.Log.setLevel( level )
        luavsq.Log._level = level;
    end

    function luavsq.Log.print( message )
        if( luavsq.Log._level > 0 )then
            local fp = luavsq.Log._getFilehandle();
            fp:write( message );
            fp:flush();
        end
    end

    function luavsq.Log.println( message )
        if( luavsq.Log._level > 0 )then
            local fp = luavsq.Log._getFileHandle();
            fp:write( message .. "\n" );
            fp:flush();
        end
    end

    function luavsq.Log._getFileHandle()
        if( luavsq.Log._fileHandle == nil )then
            luavsq.Log._fileHandle = io.open( "..\\luavsq.log", "w" );
        end
        return luavsq.Log._fileHandle;
    end

end
