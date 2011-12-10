--[[
  EventList.Iterator.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local table = table;

module( "luavsq" );

if( nil == EventList )then
    EventList = {};
end

---
-- イベントリストのアイテムを順に返す反復子
-- @class table
-- @name EventList.Iterator
EventList.Iterator = {};

---
-- 初期化を行う
-- @param list (EventList) 反復子の元になるリスト
-- @return (EventList.Iterator)
-- @name new
-- @access static ctor
function EventList.Iterator.new( list )
    local this = {};
    this._list = list;
    this._pos = -1;

    ---
    -- 反復子が次の要素を持つ場合に true を返す
    -- @return (boolean) 反復子がさらに要素を持つ場合は true を、そうでなければ false を返す
    -- @name hasNext
    function this:hasNext()
        if( 0 <= self._pos + 1 and self._pos + 1 < self._list:size() )then
            return true;
        end
        return false;
    end

    ---
    -- 反復子の次の要素を返す
    -- @return (Event) 次の要素
    -- @name next
    function this:next()
        self._pos = self._pos + 1;
        return self._list:get( self._pos );
    end

    ---
    -- 反復子によって最後に返された要素を削除する
    -- @name remove
    function this:remove()
        if( 0 <= self._pos and self._pos < self._list:size() )then
            self._list:removeAt( self._pos );
            self._pos = self._pos - 1;
        end
    end

    return this;
end
