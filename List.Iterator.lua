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

---
-- リストの要素を先頭から順に返す反復子の実装
-- @class table
-- @name List.Iterator
List.Iterator = {};

---
-- 初期化を行う
-- @param list (List) 反復子の元になるリスト
-- @return (List.Iterator) イテレータのオブジェクト
-- @name new
-- @access static ctor
function List.Iterator.new( list )
    local this = {};
    this._list = list;
    this._pos = -1;

    ---
    -- 反復子が次の要素を持つ場合に true を返す
    -- @return (boolean) 反復子がさらに要素を持つ場合は true を、そうでなければ false を返す
    -- @name hasNext
    function this:hasNext()
        return (0 <= self._pos + 1 and self._pos + 1 < self._list:size())
    end

    ---
    -- 反復子の次の要素を返す
    -- @return (?) 次の要素
    -- @name next
    function this:next()
        self._pos = self._pos + 1;
        return self._list[self._pos];
    end

    return this;
end
