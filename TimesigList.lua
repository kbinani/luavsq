--[[
  TimesigList.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local math = math;

module( "luavsq" );

---
-- 拍子情報を格納したテーブルを表すクラス
-- @class table
-- @name TimesigList
TimesigList = {};

---
-- 初期化を行う
-- @return (TimesigList)
-- @access static ctor
function TimesigList.new()
    local this = {};

    ---
    -- 拍子変更情報のリスト
    -- @var List<Timesig>
    -- @access private
    this._list = List.new();

    ---
    -- データ点の個数を取得する
    -- @return (int) データ点の個数
    function this:size()
        return self._list:size();
    end

    ---
    -- データ点を順に返す反復子を取得する
    -- @return (List.Iterator<Timesig>) 反復子
    function this:iterator()
        return self._list:iterator();
    end

    ---
    -- データ点を追加する
    -- @param item (Timesig) 追加する拍子変更情報
    function this:push( item )
        self._list:push( item );
    end

    ---
    -- 指定したインデックスの拍子変更情報を取得する
    -- @param index (int) 取得するデータ点のインデックス(0から始まる)
    -- @return (Timesig) 拍子変更情報
    function this:get( index )
        return self._list[index];
    end

    ---
    -- 指定したインデックスの拍子変更情報を設定する
    -- @param index (int) インデックス(最初のインデックスは0)
    -- @param value (Timesig) 設定するイベント
    function this:set( index, value )
        self._list[index] = value;
    end

    ---
    -- リスト内の拍子変更情報の clock の部分を更新する
    function this:updateTimesigInfo()
        if( self:get( 0 )._clock ~= 0 )then
            return;
        end
        self:get( 0 )._clock = 0;
        self._list:sort( Timesig.compare );-- Collections.sort( this );
        local count = self:size();
        local j;
        for j = 1, count - 1, 1 do
            local item = self:get( j - 1 );
            local numerator = item.numerator;
            local denominator = item.denominator;
            local clock = item._clock;
            local bar_count = item.barCount;
            local dif = math.floor( 480 * 4 / denominator * numerator );--1小節が何クロックか？
            clock = clock + (self:get( j ).barCount - bar_count) * dif;
            self:get( j )._clock = clock;
        end
    end

    ---
    -- 指定された時刻における拍子情報を取得する
    -- @param clock (int) Tick 単位の時刻
    -- @return (Timesig) 指定された時刻での拍子情報
    function this:getTimesigAt( clock )
        local ret = Timesig.new();
        ret.numerator = 4;
        ret.denominator = 4;
        local index = 0;
        local c = self._list:size();
        local i;
        for i = c - 1, 0, -1 do
            index = i;
            if( self._list[i]._clock <= clock )then
                break;
            end
        end
        ret.numerator = self._list[index].numerator;
        ret.denominator = self._list[index].denominator;
        return ret;
    end

    ---
    -- 指定された時刻における拍子情報を取得する
    -- @param clock (int) Tick 単位の時刻
    -- @return (Timesig) 指定された時刻での拍子情報
    function this:findTimesigAt( clock )
        local index = 0;
        local c = self._list:size();
        local i;
        for i = c - 1, 0, -1 do
            index = i;
            if( self._list[i]._clock <= clock )then
                break;
            end
        end
        local item = self._list[index];
        local ret = item:clone();
        local diff = clock - item._clock;
        local clockPerBar = math.floor( 480 * 4 / ret.denominator * ret.numerator );
        ret.barCount = item.barCount + math.floor( diff / clockPerBar );
        return ret;
    end

    ---
    -- 指定した小節の開始クロックを取得する。
    -- ここで使用する小節数は、プリメジャーを考慮しない。即ち、曲頭の小節が 0 となる
    -- @param barCount (int) 小節数
    -- @return (int) Tick 単位の時刻
    function this:getClockFromBarCount( barCount )
        local index = 0;
        local c = self._list:size();
        local i;
        for i = c - 1, 0, -1 do
            index = i;
            if( self._list[i].barCount <= barCount )then
                break;
            end
        end
        local item = self._list[index];
        local numerator = item.numerator;
        local denominator = item.denominator;
        local initClock = item._clock;
        local initBarCount = item.barCount;
        local clockPerBar = numerator * 480 * 4 / denominator;
        return initClock + (barCount - initBarCount) * clockPerBar;
    end

    ---
    -- 指定したクロックが、曲頭から何小節目に属しているかを調べる
    -- ここで使用する小節数は、プリメジャーを考慮しない。即ち、曲頭の小節が 0 となる
    -- @param clock  (int) Tick 単位の時刻
    -- @return (int) 小節数
    function this:getBarCountFromClock( clock )
        local index = 0;
        local c = self._list:size();
        local i;
        for i = c - 1, 0, -1 do
            index = i;
            if( self._list[i]._clock <= clock )then
                break;
            end
        end
        local bar_count = 0;
        if( index >= 0 )then
            local item = self._list[index];
            local last_clock = item._clock;
            local t_bar_count = item.barCount;
            local numerator = item.numerator;
            local denominator = item.denominator;
            local clock_per_bar = numerator * 480 * 4 / denominator;
            bar_count = t_bar_count + math.floor( (clock - last_clock) / clock_per_bar );
        end
        return bar_count;
    end

    return this;
end
