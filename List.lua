--[[
  List.lua
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

if( nil == luavsq.List )then

    luavsq.List = {};

    function luavsq.List.new()
        local this = {};
        this._array = {};

        ---
        -- @return [Iterator<TempoTableEntry>]
        function this:iterator()
            return luavsq.List.Iterator.new( self );
        end

        ---
        -- データ点を時刻順に並べ替えます
        -- @return [void]
        function this:sort( ... )
            local arguments = { ... };
            local wrappedComparator = nil;
            if( #arguments > 0 )then
                comparator = arguments[1];
                wrappedComparator = function( a, b )
                    local actualA = a["value"];
                    local actualB = b["value"];
                    return comparator( actualA, actualB );
                end
            else
                wrappedComparator = function( a, b )
                    local actualA = a["value"];
                    local actualB = b["value"];
                    return actualA < actualB;
                end
            end
            table.sort( self._array, wrappedComparator );
        end

        ---
        -- データ点を追加します
        -- @param value [TempoTableEntry]
        -- @return [void]
        function this:add( value )
            table.insert( self._array, { ["value"] = value } );
        end

        ---
        -- データ点を追加します
        -- @param value [TempoTableEntry]
        -- @return [void]
        function this:push( value )
            self:add( value );
        end

        ---
        -- テンポ・テーブルに登録されているデータ点の個数を調べます
        -- @return [int]
        function this:size()
            return #self._array;
        end

        ---
        -- 第index番目のデータ点を取得します
        -- @param index [int] 0 から始まるインデックス
        -- @return [TempoTableEntry]
        function this:get( index )
            return self._array[index + 1]["value"];
        end

        ---
        -- データ点を設定します
        -- @param index [int]
        -- @param value [TempoTableEntry]
        -- @return [void]
        function this:set( index, value )
            self._array[index + 1] = { ["value"] = value };
        end

        return this;
    end

    luavsq.List.Iterator = {};

    function luavsq.List.Iterator.new( list )
        local this = {};
        this._list = list;
        this._pos = -1;

        function this:hasNext()
            return (0 <= self._pos + 1 and self._pos + 1 < self._list:size())
        end

        function this:next()
            self._pos = self._pos + 1;
            return self._list:get( self._pos );
        end

        return this;
    end

end
