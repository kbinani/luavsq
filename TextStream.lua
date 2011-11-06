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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.TextStream )then

    luavsq.TextStream = {};

    function luavsq.TextStream.new()
        local this = {};
        this.array = {};
        this.length = 0;
        this.position = -1;

        ---
        -- @return [int]
        function this:getPointer()
            return self.position;
        end

        ---
        -- @param value [int]
        -- @return [void]
        function this:setPointer( value )
            self.position = value;
        end

        ---
        -- @return [char]
        function this:get()
            self.position = self.position + 1;
            return self.array[self.position + 1];
        end

        ---
        -- @return [string]
        function this:readLine()
            local sb = "";
            -- '\n'が来るまで読み込み
            while( self.position + 1 < self.length )do
                self.position = self.position + 1;
                local c = self.array[self.position + 1];
                if( c == "\n" )then
                    break;
                end
                sb = sb .. c;
            end
            return sb;
        end

        ---
        -- @return [bool]
        function this:ready()
            if( 0 <= self.position + 1 and self.position + 1 < self.length )then
                return true;
            else
                return false;
            end
        end

        ---
        -- @param length [int]
        -- @return [void]
        function this:_ensureCapacity( _length )
            if( _length > #self.array )then
                local add = _length - #self.array;
                for i = 1, add, 1 do
                    table.insert( self.array, " " );
                end
            end
        end

        ---
        -- @param str [string]
        -- @return [void]
        function this:write( str )
            local len = str:len();
            local newSize = self.position + 1 + len;
            local offset = self.position + 1;
            self:_ensureCapacity( newSize );
            for i = 1, len, 1 do
                self.array[offset + i] = str:sub( i, i );
            end
            self.position = self.position + len;
            self.length = math.max( self.length, newSize );
        end

        ---
        -- @param str [string]
        -- @return [void]
        function this:writeLine( str )
            local len = str:len();
            local offset = self.position + 1;
            local newSize = offset + len + 1;
            self:_ensureCapacity( newSize );
            for i = 1, len, 1 do
                self.array[offset + i] = str:sub( i, i );
            end
            self.array[offset + len + 1] = "\n";
            self.position = self.position + len + 1;
            self.length = math.max( self.length, newSize );
        end

        ---
        -- @return [void]
        function this:close()
            self.array = nil;
            self.length = 0;
        end

        ---
        --
        function this:toString()
            local ret = "";
            for i = 1, self.length, 1 do
                ret = ret .. self.array[i];
            end
            return ret;
        end

        return this;
    end

end
