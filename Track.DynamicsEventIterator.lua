--[[
  Track.DynamicsEventIterator.lua
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

if( nil == luavsq.Track )then
    luavsq.Track = {};
end

if( nil == luavsq.Track.DynamicsEventIterator )then

    luavsq.Track.DynamicsEventIterator = {};

    function luavsq.Track.DynamicsEventIterator.new( list )
        local this = {};
        this._list = list;
        this._pos = 0;

        ---
        -- @return [bool]
        function this:hasNext()
            local c = self._list:size();
            local i;
            for i = self._pos + 1, c, 1 do
                if( self._list:get( i - 1 ).id.type == luavsq.IdTypeEnum.Aicon )then
                    return true;
                end
            end
            return false;
        end

        ---
        -- @return [VsqEvent]
        function this:next()
            local c = self._list:size();
            local i;
            for i = self._pos + 1, c, 1 do
                local item = self._list:get( i - 1 );
                if( item.id.type == luavsq.IdTypeEnum.Aicon )then
                    self._pos = i;
                    return item;
                end
            end
            return nil;
        end

        ---
        -- @return [void]
        function this:remove()
            if( 1 <= self._pos and self._pos <= self._list:size() )then
                self._list:removeAt( self._pos - 1 );
                self._pos = self._pos - 1;
            end
        end

        return this;
    end

end
