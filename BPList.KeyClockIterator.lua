--[[
  BPList.KeyClockIterator.lua
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

if( nil == luavsq.BPList )then
    luavsq.BPList = {};
end

if( nil == luavsq.BPList.KeyClockIterator )then

    luavsq.BPList.KeyClockIterator = {};

    function luavsq.BPList.KeyClockIterator.new( ... )
        local this = {};
        local arguments = { ... };
        this._list = nil;
        this._pos = 0;

        ---
        -- @param list [VsqBPList]
        -- @return [void]
        function this:_init_1( list )
            self._list = list;
            self._pos = 0;
        end

        ---
        -- @return [bool]
        function this:hasNext()
            if( self._pos + 1 <= self._list._length )then
                return true;
            else
                return false;
            end
        end

        ---
        -- @return [int]
        function this:next()
            self._pos = self._pos + 1;
            return self._list.clocks[self._pos];
        end

        ---
        -- @return [void]
        function this:remove()
            if( 0 < self._pos and self._pos <= self._list._length )then
                local key = self._list.clocks[self._pos];
                local i;
                for i = self._pos, self._list._length - 1, 1 do
                    self._list.clocks[i] = self._list.clocks[i + 1];
                    self._list.items[i].value = self._list.items[i + 1].value;
                    self._list.items[i].id = self._list.items[i + 1].id;
                end
                self._list._length = self._list._length - 1;
            end
        end

        if( #arguments == 1 )then
            this:_init_1( arguments[1] );
        end

        return this;
    end

end
