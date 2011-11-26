--[[
  VibratoBPList.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

-- requires( Util.lua )
-- requires( VibratoBP.lua )

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.VibratoBPList )then

    luavsq.VibratoBPList = {};

    function luavsq.VibratoBPList.new( ... )
        local arguments = { ... };
        local this = {};
        this._list = {};

        ---
        -- @param strNum (string)
        -- @param strBPX (string)
        -- @param strBPY (string)
        function this:_init_3( strNum, strBPX, strBPY )
            local num = tonumber( strNum );
            if( nil == num )then
                num = 0;
            end
            local bpx = luavsq.Util.split( strBPX, ',' );
            local bpy = luavsq.Util.split( strBPY, ',' );
            local actNum = math.min( num, math.min( #bpx, #bpy ) );
            if( actNum > 0 )then
                local x = luavsq.Util.array( actNum );
                local y = luavsq.Util.array( actNum );
                for i = 1, actNum, 1 do
                    x[i] = tonumber( bpx[i] );
                    y[i] = tonumber( bpy[i] );
                end

                local len = math.min( #x, #y );
                for i = 1, len, 1 do
                    self._list[i] = luavsq.VibratoBP.new( x[i], y[i] );
                end
                table.sort( self._list, luavsq.VibratoBPList._comparator );
            end
        end

        ---
        -- @param x (table<float>)
        -- @param y (table<integer>)
        function this:_init_2( x, y )
            local len = math.min( #x, #y );
            for i = 1, len, 1 do
                self._list[i] = luavsq.VibratoBP.new( x[i], y[i] );
            end
            local comparator = function( a, b )
                if( a:compareTo( b ) < 0 )then
                    return true;
                else
                    return false;
                end
            end
            table.sort( self._list, luavsq.VibratoBPList._comparator );
        end

        ---
        -- @param x [float]
        -- @param defaultValue [int]
        -- @return [int]
        function this:getValueAt( x, defaultValue )
            if( #self._list <= 0 )then
                return defaultValue;
            end
            local index = -1;
            for i = 1, #self._list, 1 do
                if( x < self._list[i].x )then
                    break;
                end
                index = i;
            end
            if( index == -1 )then
                return defaultValue;
            else
                return self._list[index].y;
            end
        end

        ---
        -- @return [object]
        function this:clone()
            local ret = luavsq.VibratoBPList.new();
            for i = 1, #self._list, 1 do
                ret._list[i] = luavsq.VibratoBP.new( self._list[i].x, self._list[i].y );
            end
            return ret;
        end

        ---
        -- @return (integer)
        function this:size()
            return #self._list;
        end

        ---
        -- @param index (integer) 0から始まるインデックス
        -- @return (luavsq.VibratoBP)
        function this:get( index )
            return self._list[index + 1];
        end

        ---
        -- @param index (integer) 0から始まるインデックス
        -- @param value (luavsq.VibratoBP)
        function this:set( index, value )
            self._list[index + 1] = value;
        end

        ---
        -- @return (string)
        function this:getData()
            local ret = "";
            for i = 1, #self._list, 1 do
                if( i > 1 )then
                    ret = ret .. ",";
                end
                ret = ret .. self._list[i].x .. "=" .. self._list[i].y;
            end
            return ret;
        end

        ---
        -- @param value [String]
        -- @return [void]
        function this:setData( value )
            self._list = {};
            local spl = luavsq.Util.split( value, ',' );
            local j = 1
            for i = 1, #spl, 1 do
                local spl2 = luavsq.Util.split( spl[i], '=' );
                if( #spl2 >= 2 )then
                    self._list[j] = luavsq.VibratoBP.new( tonumber( spl2[1] ), tonumber( spl2[2] ) );
                    j = j + 1
                end
            end
            table.sort( self._list, luavsq.VibratoBPList._comparator );
        end

        if( #arguments == 3 )then
            this:_init_3( arguments[1], arguments[2], arguments[3] );
        elseif( #arguments == 2 )then
            this:_init_2( arguments[1], arguments[2] );
        end

        return this;
    end

    ---
    -- @param a (luavsq.VibratoBP)
    -- @param b (luavsq.VibratoBP)
    function luavsq.VibratoBPList._comparator( a, b )
        if( a:compareTo( b ) < 0 )then
            return true;
        else
            return false;
        end
    end
end
