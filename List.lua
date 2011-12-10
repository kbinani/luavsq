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
-- 配列の値として <code>nil</code> を入れることも出来る
--<pre>&nbsp;for i = 0, list:size() - 1, 1 do<br>
--&nbsp;&nbsp;&nbsp;&nbsp;print( list[i] );<br>
--end</pre>
-- @class table
-- @name List
if( nil == List )then
    List = {};
end

--
-- 初期化を行う
-- @return (List)
function List.new( ... )
    local this = {};
    local arguments = { ... };
    this._array = {};

    ---
    -- 初期化を行う
    -- @name new<!--1-->
    -- @access static ctor
    function this:_init_0()
    end

    ---
    -- 初期化を行う
    -- @param count (integer) 初期のリスト要素数
    -- @name new<!--2-->
    -- @access static ctor
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
    -- @name sort<!--2-->
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
    -- @name sort<!--1-->
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

    ---
    -- メタテーブルをセットアップする
    -- @access private
    -- @name _setupMetaTable
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
-- lua の <code>table</code> から、{@link List} のインスタンスを作成する
-- @param array (table) 作成元の <code>table</code>
-- @return (List) {@link List} のインスタンス
-- @name fromTable
-- @access static
function List.fromTable( array )
    local list = List.new();
    local i;
    for i = 1, #array, 1 do
        table.insert( list._array, { ["value"] = array[i] } );
    end
    return list;
end
