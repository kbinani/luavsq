--[[
  List.lua
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

if( nil == luavsq.List )then

    luavsq.List = {};

    ---
    -- リスト機能を提供する。
    -- インデックスは0から始まる
    -- 例えば、長さ 3 のリストに順次アクセする場合次のようにすれば良い。
    -- 配列の値として nil を入れることも出来る
    -- for i = 0, list:size() - 1, 1 do
    --     print( list[i] );
    -- end
    function luavsq.List.new( ... )
        local this = {};
        local arguments = { ... };
        this._array = {};

        function this:get( index )
            return self[index];
        end

        function this:set( index, value )
            self[index] = value;
        end

        ---
        -- リスト内のデータを順番に返すイテレータを取得する
        -- @access public
        -- @return (luavsq.List.Iterator)
        function this:iterator()
            return luavsq.List.Iterator.new( self );
        end

        ---
        -- リスト内のデータを並べ替える
        -- @access public
        -- @param (function) comparator <optional> データの比較に使う比較関数
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
        -- データを追加する
        -- @access public
        -- @param value (anything)
        function this:push( value )
            table.insert( self._array, { ["value"] = value } );
        end

        ---
        -- データの個数を取得する
        -- @access public
        -- @return (number)
        function this:size()
            return #self._array;
        end

        ---
        -- メタテーブルをセットアップする
        -- @access private
        function this:_setupMetaTable()
            local metaTable = {};

            metaTable.__index = function( _table, _key )
                return _table._array[_key + 1]["value"];
            end

            metaTable.__newindex = function( _table, _key, _value )
                _table._array[_key + 1] = { ["value"] = _value };
            end

            setmetatable( self, metaTable );
        end

        this:_setupMetaTable();

        if( #arguments > 0 )then
            local count = arguments[1];
            local i;
            for i = 1, count, 1 do
                this:push( nil );
            end
        end

        return this;
    end

    ---
    -- lua の table から、luavsq.List のインスタンスを作成する
    -- @param (table) _table
    -- @return (luavsq.List)
    function luavsq.List.fromTable( _table )
        local list = luavsq.List.new();
        local i;
        for i = 1, #_table, 1 do
            table.insert( list._array, { ["value"] = _table[i] } );
        end
        return list;
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
            return self._list[self._pos];
        end

        return this;
    end

end
