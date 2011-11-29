--[[
  Track.IndexIterator.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq.Track" );

---
-- イベントリスト中の、インデックスを順に返す反復子
-- @class table
-- @name Track.IndexIterator
Track.IndexIterator = {};

---
-- 初期化を行う
-- @param list (EventList) 反復子の元になるリスト
-- @param iterator_kind (IndexIteratorKindEnum) 反復子の種類
-- @return (IndexIterator) 反復子
function Track.IndexIterator.new( list, iteratorKind )
    local this = {};
    ---
    -- @local [VsqEventList]
    this._list = list;
    this._pos = 0;
    this._kindSinger =
        Util.band(
            iteratorKind,
            Track.IndexIteratorKindEnum.SINGER
        ) == Track.IndexIteratorKindEnum.SINGER;
    this._kindNote =
        Util.band(
            iteratorKind,
            Track.IndexIteratorKindEnum.NOTE
        ) == Track.IndexIteratorKindEnum.NOTE;
    this._kindCrescend =
        Util.band(
            iteratorKind,
            Track.IndexIteratorKindEnum.CRESCEND
        ) == Track.IndexIteratorKindEnum.CRESCEND;
    this._kindDecrescend =
        Util.band(
            iteratorKind,
            Track.IndexIteratorKindEnum.DECRESCEND
        ) == Track.IndexIteratorKindEnum.DECRESCEND;
    this._kindDynaff =
        Util.band(
            iteratorKind,
            Track.IndexIteratorKindEnum.DYNAFF
        ) == Track.IndexIteratorKindEnum.DYNAFF;

    ---
    -- 反復子の次の要素を返す
    -- @return (integer) 次の要素
    function this:next()
        local nextPosition = self:_nextPosition();
        if( nextPosition > 0 )then
            this._pos = nextPosition;
            return nextPosition - 1;
        else
            return -1;
        end
    end

    ---
    -- 反復子が次の要素を持つ場合に true を返す
    -- @return (boolean) 反復子がさらに要素を持つ場合は true を、そうでなければ false を返す
    function this:hasNext()
        return (self:_nextPosition() > 0);
    end

    ---
    -- 反復子の次の要素を探索する
    -- @access private
    -- @return (integer) 次のインデックス
    function this:_nextPosition()
        local count = self._list:size();
        local i;
        for i = self._pos + 1, count, 1 do
            local item = self._list:get( i - 1 );
            if( self._kindSinger )then
                if( item.id.type == IdTypeEnum.Singer )then
                    return i;
                end
            end
            if( self._kindNote )then
                if( item.id.type == IdTypeEnum.Anote )then
                    return i;
                end
            end
            if( self._kindDynaff or self._kindCrescend or self._kindDecrescend )then
                if( item.id.type == IdTypeEnum.Aicon and item.id.iconDynamicsHandle ~= nil and item.id.iconDynamicsHandle.iconId ~= nil )then
                    local iconid = item.id.iconDynamicsHandle.iconId;
                    if( self._kindDynaff )then
                        if( iconid:find( IconDynamicsHandle.ICONID_HEAD_DYNAFF ) == 1 )then
                            return i;
                        end
                    end
                    if( self._kindCrescend )then
                        if( iconid:find( IconDynamicsHandle.ICONID_HEAD_CRESCEND ) == 1 )then
                            return i;
                        end
                    end
                    if( self._kindDecrescend )then
                        if( iconid:find( IconDynamicsHandle.ICONID_HEAD_DECRESCEND ) == 1 )then
                            return i;
                        end
                    end
                end
            end
        end
        return 0;
    end

    ---
    -- 反復子によって最後に返された要素を削除する
    function this:remove()
        if( 0 < self._pos and self._pos <= self._list:size() )then
            self._list:removeAt( self._pos - 1 );
            self._pos = self._pos - 1;
        end
    end

    return this;
end
