--[[
  TimesigTable.lua
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

if( nil == luavsq.TimesigTable )then
    luavsq.TimesigTable = {};

    function luavsq.TimesigTable.new()
        local this = {};
        this._list = luavsq.List.new();

        ---
        -- データ点の個数を取得する
        -- @return (integer)
        function this:size()
            return self._list:size();
        end

        ---
        -- データ点を順に返す反復子を取得する
        -- @return (luavsq.List.Iterator<luavsq.TimesigTableItem>)
        function this:iterator()
            return self._list:iterator();
        end

        ---
        -- データ点を追加する
        -- @param (luavsq.TimesigTableItem)
        function this:push( item )
            self._list:push( item );
        end

        ---
        -- データ点を取得する
        -- @param (number) index 取得するデータ点のインデックス(0から始まる)
        -- @return (luavsq.TimesigTableItem)
        function this:get( index )
            return self._list[index];
        end

        ---
        -- データ点を設定する
        -- @param (number) index 設定するデータ点のインデックス(0から始まる)
        -- @param (luavsq.TimesigTableItem)
        function this:set( index, value )
            self._list[index] = value;
        end

        ---
        -- TimeSigTableの[*].Clockの部分を更新します
        function this:updateTimesigInfo()
            if( self._list[0].clock ~= 0 )then
                return;
            end
            self._list[0].Clock = 0;
            self._list:sort( luavsq.TimesigTableItem.compare );-- Collections.sort( this );
            local count = self._list:size();
            local j;
            for j = 1, count - 1, 1 do
                local item = self._list[j - 1];
                local numerator = item.numerator;
                local denominator = item.denominator;
                local clock = item.clock;
                local bar_count = item.barCount;
                local dif = math.floor( 480 * 4 / denominator * numerator );--1小節が何クロックか？
                clock = clock + (self._list[j].barCount - bar_count) * dif;
                self._list[j].clock = clock;
            end
        end

        ---
        -- 指定されたゲートタイムにおける拍子情報を取得する
        -- @param (number) clock ゲートタイム
        -- @return (luavsq.Timesig) 指定されたゲートタイムでの拍子情報
        function this:getTimesigAt( clock )
            local ret = luavsq.TimesigTableItem.new();
            ret.numerator = 4;
            ret.denominator = 4;
            local index = 0;
            local c = self._list:size();
            local i;
            for i = c - 1, 0, -1 do
                index = i;
                if( self._list[i].clock <= clock )then
                    break;
                end
            end
            ret.numerator = self._list[index].numerator;
            ret.denominator = self._list[index].denominator;
            return ret;
        end

        ---
        -- 指定されたゲートタイムにおける拍子情報を取得する
        -- @param (number) clock ゲートタイム
        -- @return (luavsq.TimesigTableItem) 指定されたゲートタイムでの拍子情報
        function this:findTimesigAt( clock )
            local index = 0;
            local c = self._list:size();
            local i;
            for i = c - 1, 0, -1 do
                index = i;
                if( self._list[i].clock <= clock )then
                    break;
                end
            end
            local item = self._list[index];
            local ret = item:clone();
            local diff = clock - item.clock;
            local clockPerBar = math.floor( 480 * 4 / ret.denominator * ret.numerator );
            ret.barCount = item.barCount + math.floor( diff / clockPerBar );
            return ret;
        end

        ---
        -- 指定した小節の開始クロックを調べます。ここで使用する小節数は、プリメジャーを考慮しない。即ち、曲頭の小節が0である。
        -- @param (integer) bar_count
        -- @return (integer)
        function this:getClockFromBarCount( bar_count )
            local index = 0;
            local c = self._list:size();
            local i;
            for i = c - 1, 0, -1 do
                index = i;
                if( self._list[i].barCount <= bar_count )then
                    break;
                end
            end
            local item = self._list[index];
            local numerator = item.numerator;
            local denominator = item.denominator;
            local init_clock = item.clock;
            local init_bar_count = item.barCount;
            local clock_per_bar = numerator * 480 * 4 / denominator;
            return init_clock + (bar_count - init_bar_count) * clock_per_bar;
        end

        ---
        -- 指定したクロックが、曲頭から何小節目に属しているかを調べます。ここで使用する小節数は、プリメジャーを考慮しない。即ち、曲頭の小節が0である。
        -- @param (integer) clock
        -- @return (integer)
        function this:getBarCountFromClock( clock )
            local index = 0;
            local c = self._list:size();
            local i;
            for i = c - 1, 0, -1 do
                index = i;
                if( self._list[i].clock <= clock )then
                    break;
                end
            end
            local bar_count = 0;
            if( index >= 0 )then
                local item = self._list[index];
                local last_clock = item.clock;
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


end
