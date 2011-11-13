--[[
  EventList.Iterator.lua
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

if( nil == luavsq.EventList )then
    luavsq.EventList = {};
end

if( nil == luavsq.EventList.Iterator )then

    luavsq.EventList.Iterator = {};

    function luavsq.EventList.Iterator.new( list )
        local this = {};
        this._list = list;
        this._pos = -1;

        ---
        -- @return [bool]
        function this:hasNext()
            if( 0 <= self._pos + 1 and self._pos + 1 < self._list:size() )then
                return true;
            end
            return false;
        end

        ---
        -- @return [VsqEvent]
        function this:next()
            self._pos = self._pos + 1;
            return self._list:getElement( self._pos );
        end

        ---
        -- @return [void]
        function this:remove()
            if( 0 <= self._pos and self._pos < self._list:size() )then
                self._list:removeAt( self._pos );
                self._pos = self._pos - 1;
            end
        end

        return this;
    end

end
