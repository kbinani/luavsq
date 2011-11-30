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

local setmetatable = setmetatable;
local table = table;

module( "luavsq" );

---
-- リスト機能を提供する
-- インデックスは0から始まる
-- 例えば、長さ 3 のリストに順次アクセする場合次のようにすれば良い。
-- 配列の値として nil を入れることも出来る
-- for i = 0, list:size() - 1, 1 do
--     print( list[i] );
-- end
-- @class table
-- @name List
List = {};

--
-- 初期化を行う
-- @return (List)
function List.new( ... )
    local this = {};
    local arguments = { ... };
    this._array = {};

    ---
    -- 初期化を行う
    -- @name <i>new</i><sup>1</sup>
    function this:_init_0()
    end

    ---
    -- 初期化を行う
    -- @param count (integer) 初期のリスト要素数
    -- @name <i>new</i><sup>2</sup>
    function this:_init_1( count )
    end

    ---
    -- リスト内の指定した位置にある要素を返す
    -- @param index (integer) インデックス(最初のインデックスは0)
    -- @return (?) 指定された位置にある要素
    -- @name get
    function this:get( index )
        return self[index];
    end

    ---
    -- 指定された位置にある要素を、指定の要素で置き換える
    -- @param index (integer) インデックス(最初のインデックスは0)
    -- @param value (?) 置き換える要素
    -- @name set
    function this:set( index, value )
        self[index] = value;
    end

    ---
    -- リスト内のデータを順番に返すイテレータを取得する
    -- @return (List.Iterator) イテレータ
    -- @name iterator
    function this:iterator()
        return List.Iterator.new( self );
    end

    ---
    -- リスト内のデータを並べ替える
    -- @param comparator (function) データの比較に使う比較関数
    -- @name sort<sup>2</sup>
    function this:_sort_1( comparator )
        local wrappedComparator = function( a, b )
            local actualA = a["value"];
            local actualB = b["value"];
            return comparator( actualA, actualB );
        end
        table.sort( self._array, wrappedComparator );
    end

    ---
    -- リスト内のデータを並べ替える
    -- @name sort<sup>1</sup>
    function this:_sort_0()
        local wrappedComparator = function( a, b )
            local actualA = a["value"];
            local actualB = b["value"];
            return actualA < actualB;
        end
        table.sort( self._array, wrappedComparator );
    end

    function this:sort( ... )
        local arguments = { ... };
        local wrappedComparator = nil;
        if( #arguments > 0 )then
            self:_sort_1( arguments[1] );
        else
            self:_sort_0();
        end
    end

    ---
    -- データをリストの末尾に追加する
    -- @param value (?) 追加する要素
    -- @name push
    function this:push( value )
        table.insert( self._array, { ["value"] = value } );
    end

    ---
    -- リスト内のデータの個数を取得する
    -- @return (integer) データの個数
    -- @name size
    function this:size()
        return #self._array;
    end

    --
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
-- lua の table から、List のインスタンスを作成する
-- @param _table (table) 作成元の table
-- @return (List) List のインスタンス
-- @name <i>fromTable</i>
function List.fromTable( _table )
    local list = List.new();
    local i;
    for i = 1, #_table, 1 do
        table.insert( list._array, { ["value"] = _table[i] } );
    end
    return list;
end

---
-- リストの要素を先頭から順に返す反復子の実装
List.Iterator = {};

---
-- 初期化を行う
-- @param list (List) 反復子の元になるリスト
-- @return (List.Iterator) イテレータのオブジェクト
-- @name Iterator.<i>new</i>
function List.Iterator.new( list )
    local this = {};
    this._list = list;
    this._pos = -1;

    ---
    -- 反復子が次の要素を持つ場合に true を返す
    -- @return (boolean) 反復子がさらに要素を持つ場合は true を、そうでなければ false を返す
    -- @name Iterator.hasNext
    function this:hasNext()
        return (0 <= self._pos + 1 and self._pos + 1 < self._list:size())
    end

    ---
    -- 反復子の次の要素を返す
    -- @return (?) 次の要素
    -- @name Iterator.next
    function this:next()
        self._pos = self._pos + 1;
        return self._list[self._pos];
    end

    return this;
end
