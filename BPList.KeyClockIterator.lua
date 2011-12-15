--[[
  BPList.KeyClockIterator.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

if( nil == BPList )then
    BPList = {};
end

---
-- コントロールカーブのデータ点の Tick 単位の時刻を順に返す反復子
-- @class table
-- @name BPList.KeyClockIterator
BPList.KeyClockIterator = {};

---
-- 初期化を行う
-- @param list (BPList) 反復子の元になるリスト
-- @return (BPList.KeyClockIterator)
-- @name new
-- @access static ctor
-- @class function

function BPList.KeyClockIterator.new( ... )
    local this = {};
    local arguments = { ... };

    ---
    -- 反復子の元になるリスト
    -- @var table
    -- @access private
    this._list = nil;

    ---
    -- 反復子の現在の位置
    -- @var int
    -- @access private
    this._pos = 0;

    ---
    -- 初期化を行う
    -- @param list (BPList) 反復子の元になるリスト
    -- @return (BPList.KeyClockIterator)
    -- @access private
    function this:_init_1( list )
        self._list = list;
        self._pos = 0;
    end

    ---
    -- 反復子が次の要素を持つ場合に <code>true</code> を返す
    -- @return (boolean) 反復子がさらに要素を持つ場合は <code>true</code> を、そうでなければ <code>false</code> を返す
    function this:hasNext()
        if( self._pos + 1 <= self._list._length )then
            return true;
        else
            return false;
        end
    end

    ---
    -- 反復子の次の要素を返す
    -- @return (int) 次の要素
    function this:next()
        self._pos = self._pos + 1;
        return self._list._clocks[self._pos];
    end

    ---
    -- 反復子によって最後に返された要素を削除する
    function this:remove()
        if( 0 < self._pos and self._pos <= self._list._length )then
            local key = self._list._clocks[self._pos];
            local i;
            for i = self._pos, self._list._length - 1, 1 do
                self._list._clocks[i] = self._list._clocks[i + 1];
                self._list._items[i].value = self._list._items[i + 1].value;
                self._list._items[i].id = self._list._items[i + 1].id;
            end
            self._list._length = self._list._length - 1;
        end
    end

    if( #arguments == 1 )then
        this:_init_1( arguments[1] );
    end

    return this;
end
