--[[
  List.Iterator.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

if( nil == List )then
    List = {};
end

---
-- リストの要素を先頭から順に返す反復子の実装
-- @class table
-- @name List.Iterator
List.Iterator = {};

---
-- 初期化を行う
-- @param list (List) 反復子の元になるリスト
-- @return (List.Iterator) イテレータのオブジェクト
-- @access static ctor
function List.Iterator.new( list )
    local this = {};

    ---
    -- 反復子の元になるリスト
    -- @var List
    -- @access private
    this._list = list;

    ---
    -- 反復子の現在の位置
    -- @var int
    -- @access private
    this._pos = -1;

    ---
    -- 反復子が次の要素を持つ場合に <code>true</code> を返す
    -- @return (boolean) 反復子がさらに要素を持つ場合は <code>true</code> を、そうでなければ <code>false</code> を返す
    function this:hasNext()
        return (0 <= self._pos + 1 and self._pos + 1 < self._list:size())
    end

    ---
    -- 反復子の次の要素を返す
    -- @return (?) 次の要素
    function this:next()
        self._pos = self._pos + 1;
        return self._list[self._pos];
    end

    return this;
end
