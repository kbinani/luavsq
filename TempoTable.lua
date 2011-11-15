--[[
  TempoTable.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.TempoTable )then

    luavsq.TempoTable = {};

    ---
    -- テンポ情報を格納したテーブル．
    function luavsq.TempoTable.new()
        local this = {};
        this._array = luavsq.List.new();

        ---
        -- @return [Iterator<TempoTableEntry>]
        function this:iterator()
            return this._array:iterator();
        end

        ---
        -- データ点を時刻順に並べ替えます
        -- @return [void]
        function this:sort()
            self._array:sort( luavsq.TempoTableEntry.compare );
        end

        ---
        -- データ点を追加します
        -- @param value [TempoTableEntry]
        -- @return [void]
        function this:push( value )
            self._array:push( value );
        end

        ---
        -- テンポ・テーブルに登録されているデータ点の個数を調べます
        -- @return [int]
        function this:size()
            return self._array:size();
        end

        ---
        -- 第index番目のデータ点を取得します
        -- @param index [int] 0 から始まるインデックス
        -- @return [TempoTableEntry]
        function this:get( index )
            return self._array[index];
        end

        ---
        -- データ点を設定します
        -- @param index [int]
        -- @param value [TempoTableEntry]
        -- @return [void]
        function this:set( index, value )
            self._array[index] = value;
        end

        ---
        -- @param time [double]
        -- @return [double]
        function this:getClockFromSec( time )
            -- timeにおけるテンポを取得
            local tempo = luavsq.TempoTable.baseTempo;
            local base_clock = 0;
            local base_time = 0.0;
            local c = self._array:size();
            if( c == 0 )then
                tempo = luavsq.TempoTable.baseTempo;
                base_clock = 0;
                base_time = 0.0;
            elseif( c == 1 )then
                tempo = self._array[0].Tempo;
                base_clock = self._array[0].clock;
                base_time = self._array[0].time;
            else
                local i;
                for i = c - 1, 0, -1 do
                    local item = self._array[i];
                    if( item.time < time )then
                        return item.clock + (time - item.time) * luavsq.TempoTable.gatetimePerQuater * 1000000.0 / item.tempo;
                    end
                end
            end
            local dt = time - base_time;
            return base_clock + dt * luavsq.TempoTable.gatetimePerQuater * 1000000.0 / tempo;
        end

        ---
        -- @return [void]
        function this:updateTempoInfo()
            local c = self._array:size();
            if( c == 0 )then
                self._array:push( luavsq.TempoTableEntry.new( 0, luavsq.TempoTable.baseTempo, 0.0 ) );
            end
            self._array:sort( luavsq.TempoTableEntry.compare );
            local item0 = self._array[0];
            if( item0.clock ~= 0 )then
                item0.time = luavsq.TempoTable.baseTempo * item0.clock / (luavsq.TempoTable.gatetimePerQuater * 1000000.0);
            else
                item0.time = 0.0;
            end
            local prev_time = item0.time;
            local prev_clock = item0.clock;
            local prev_tempo = item0.tempo;
            local inv_tpq_sec = 1.0 / (luavsq.TempoTable.gatetimePerQuater * 1000000.0);
            local i;
            for i = 1, c - 1, 1 do
                local itemi = self._array[i];
                itemi.time = prev_time + prev_tempo * (itemi.clock - prev_clock) * inv_tpq_sec;
                prev_time = itemi.time;
                prev_tempo = itemi.tempo;
                prev_clock = itemi.clock;
            end
        end

        ---
        -- @param clock [double]
        -- @return [double]
        function this:getSecFromClock( clock )
            local c = self._array:size();
            local i;
            for i = c - 1, 0, -1 do
                local item = self._array[i];
                if( item.clock < clock )then
                    local init = item.time;
                    local dclock = clock - item.clock;
                    local sec_per_clock1 = item.tempo * 1e-6 / 480.0;
                    return init + dclock * sec_per_clock1;
                end
            end

            local sec_per_clock = luavsq.TempoTable.baseTempo * 1e-6 / 480.0;
            return clock * sec_per_clock;
        end

        return this;
    end

    luavsq.TempoTable.gatetimePerQuater = 480;
    luavsq.TempoTable.baseTempo = 500000;

end
