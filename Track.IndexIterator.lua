--[[
  Track.IndexIterator.lua
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

if( nil == luavsq.Track )then
    luavsq.Track = {};
end

if( nil == luavsq.Track.IndexIterator )then

    luavsq.Track.IndexIterator = {};

    ---
    -- @param list [VsqEventList]
    -- @param iterator_kind[int]
    -- @return [IndexIterator]
    function luavsq.Track.IndexIterator.new( list, iteratorKind )
        local this = {};
        ---
        -- @local [VsqEventList]
        this._list = list;
        this._pos = 0;
        this._kindSinger =
            luavsq.Util.band(
                iteratorKind,
                luavsq.Track.IndexIteratorKindEnum.SINGER
            ) == luavsq.Track.IndexIteratorKindEnum.SINGER;
        this._kindNote =
            luavsq.Util.band(
                iteratorKind,
                luavsq.Track.IndexIteratorKindEnum.NOTE
            ) == luavsq.Track.IndexIteratorKindEnum.NOTE;
        this._kindCrescend =
            luavsq.Util.band(
                iteratorKind,
                luavsq.Track.IndexIteratorKindEnum.CRESCEND
            ) == luavsq.Track.IndexIteratorKindEnum.CRESCEND;
        this._kindDecrescend =
            luavsq.Util.band(
                iteratorKind,
                luavsq.Track.IndexIteratorKindEnum.DECRESCEND
            ) == luavsq.Track.IndexIteratorKindEnum.DECRESCEND;
        this._kindDynaff =
            luavsq.Util.band(
                iteratorKind,
                luavsq.Track.IndexIteratorKindEnum.DYNAFF
            ) == luavsq.Track.IndexIteratorKindEnum.DYNAFF;

        ---
        -- @return [int]
        function this:next()
            local nextPosition = self:_nextPosition();
            if( nextPosition > 0 )then
                this._pos = nextPosition;
                return nextPosition - 1;
            else
                return -1;
            end
        end

        ---
        -- @return [bool]
        function this:hasNext()
            return (self:_nextPosition() > 0);
        end

        ---
        -- @return [int]
        function this:_nextPosition()
            local count = self._list:size();
            local i;
            for i = self._pos + 1, count, 1 do
                local item = self._list:getElement( i - 1 );
                if( self._kindSinger )then
                    if( item.id.type == luavsq.IdTypeEnum.Singer )then
                        return i;
                    end
                end
                if( self._kindNote )then
                    if( item.id.type == luavsq.IdTypeEnum.Anote )then
                        return i;
                    end
                end
                if( self._kindDynaff or self._kindCrescend or self._kindDecrescend )then
                    if( item.id.type == luavsq.IdTypeEnum.Aicon and item.id.iconDynamicsHandle ~= nil and item.id.iconDynamicsHandle.iconId ~= nil )then
                        local iconid = item.id.iconDynamicsHandle.iconId;
                        if( self._kindDynaff )then
                            if( iconid:find( luavsq.IconDynamicsHandle.ICONID_HEAD_DYNAFF ) == 1 )then
                                return i;
                            end
                        end
                        if( self._kindCrescend )then
                            if( iconid:find( luavsq.IconDynamicsHandle.ICONID_HEAD_CRESCEND ) == 1 )then
                                return i;
                            end
                        end
                        if( self._kindDecrescend )then
                            if( iconid:find( luavsq.IconDynamicsHandle.ICONID_HEAD_DECRESCEND ) == 1 )then
                                return i;
                            end
                        end
                    end
                end
            end
            return 0;
        end

        ---
        -- @return [void]
        function this:remove()
            if( 0 < self._pos and self._pos <= self._list:size() )then
                self._list:removeAt( self._pos - 1 );
                self._pos = self._pos - 1;
            end
        end

        return this;
    end

end
