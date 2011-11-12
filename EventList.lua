--[[
  EventList.lua
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

    ---
    -- 固有 ID 付きの luavsq.Event のリストを取り扱う
    function luavsq.EventList.new()
        local this = {};

        ---
        -- [Vector<VsqEvent>]
        this._events = {};

        ---
        -- [Vector<int>]
        this._ids = {};

        ---
        -- @param internalId (integer)
        -- @return (integer) 0から始まるインデックス
        function this:findIndexFromId( internalId )
            local c = #self._events;
            local i;
            for i = 1, c, 1 do
                local item = self._events[i];
                if( item.internalId == internalId )then
                    return i - 1;
                end
            end
            return -1;
        end

        ---
        -- @param internal_id [int]
        -- @return [VsqEvent]
        function this:findFromId( internal_id )
            local index = self:findIndexFromId( internal_id );
            if( 0 <= index and index < #self._events )then
                return self._events[index + 1];
            else
                return nil;
            end
        end

        ---
        -- @param internal_id [int]
        -- @param value [VsqEvent]
        -- @return [void]
        function this:setForId( internalId, value )
            local c = #self._events;
            local i;
            for i = 1, c, 1 do
                if( self._events[i].internalId == internalId )then
                    value.internalId = internalId;
                    self._events[i] = value;
                    break;
                end
            end
        end

        ---
        -- @return [void]
        function this:sort()
            table.sort( self._events, luavsq.EventList.comparator );
            self:updateIdList();
        end

        ---
        -- @return [void]
        function this:clear()
            self._events = {};
            self._ids = {};
        end

        --[[
        -- @return [ArrayIterator(VsqEven)]
        function this:iterator()
            self:updateIdList();
            return new org.kbinani.ArrayIterator( self._events );
        end]]

        ---
        -- overload1
        -- @param item [VsqEvent]
        -- @param internal_id [int]
        -- @return [int]
        --
        -- overload2
        -- @param item [VsqEvent]
        -- @return [int]
        function this:add( ... )
            local arguments = { ... };
            if( #arguments == 1 )then
                return self:_add_1( arguments[1] );
            elseif( #arguments == 2 )then
                return self:_add_2( arguments[1], arguments[2] );
            end
            return -1;
        end

        function this:_add_1( item )
            local id = self:_getNextId( 0 );
            self:_addCor( item, id );
            table.sort( self._events, luavsq.EventList.comparator );
            local count = #self._events;
            local i;
            for i = 1, count, 1 do
                self._ids[i] = self._events[i].internalId;
            end
            return id;
        end

        function this:_add_2( item, internalId )
            self:_addCor( item, internalId );
            table.sort( self._events, luavsq.EventList.comparator );
            return internalId;
        end

        ---
        -- @param item [VsqEvent]
        -- @param internal_id [int]
        -- @return [void]
        function this:_addCor( item, internalId )
            self:updateIdList();
            item.internalId = internalId;
            table.insert( self._events, item );
            table.insert( self._ids, internalId );
        end

        ---
        -- @param index [int]
        -- @return [void]
        function this:removeAt( index )
            self:updateIdList();
            table.remove( self._events, index + 1 );
            table.remove( self._ids, index + 1 );
        end

        ---
        -- @param next [int]
        -- @return [int]
        function this:_getNextId( next )
            self:updateIdList();
            local max = -1;
            local i;
            for i = 1, #self._ids, 1 do
                max = math.max( max, self._ids[i] );
            end
            return max + 1 + next;
        end

        ---
        -- @return [int]
        function this:size()
            return #self._events;
        end

        ---
        -- @param index [int]
        -- @return [VsqEvent]
        function this:getElement( index )
            return self._events[index + 1];
        end

        ---
        -- @param index [int]
        -- @param value [VsqEvent]
        -- @return [void]
        function this:setElement( index, value )
            value.internalId = self._events[index + 1].internalId;
            self._events[index + 1] = value;
        end

        ---
        -- @return [void]
        function this:updateIdList()
            if( #self._ids ~= #self._events )then
                self._ids = {};
            end
            local count = #self._events;
            local i;
            for i = 1, count, 1 do
                self._ids[i] = self._events[i].internalId;
            end
        end

        return this;
    end

    ---
    -- @param a (luavsq.Event)
    -- @param b (luavsq.Event)
    function luavsq.EventList.comparator( a, b )
        if( a:compareTo( b ) < 0 )then
            return true;
        else
            return false;
        end
    end
end
