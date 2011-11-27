--[[
  TempoTable.lua
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

if( nil == luavsq.TempoTable )then

    ---
    -- テンポ情報を格納したテーブルを表すクラス
    -- @class table
    -- @name luavsq.TempoTable
    luavsq.TempoTable = {};

    ---
    -- 初期化を行う
    -- @return (luavsq.TempoTable)
    function luavsq.TempoTable.new()
        local this = {};
        this._array = luavsq.List.new();

        ---
        -- リスト内のテンポ変更イベントを順に返す反復子を取得する
        -- @return (List.Iterator<TempoTableItem>) 反復子
        function this:iterator()
            return this._array:iterator();
        end

        ---
        -- データ点を時刻順に並べ替える
        function this:sort()
            self._array:sort( luavsq.TempoTableItem.compare );
        end

        ---
        -- データ点を追加する
        -- @param value (TempoTableItem) 追加するテンポ変更情報
        function this:push( value )
            self._array:push( value );
        end

        ---
        -- リスト内のテンポ変更情報の個数を取得する
        -- @return (integer) テンポ変更情報の個数
        function this:size()
            return self._array:size();
        end

        ---
        -- 指定したインデックスのテンポ変更情報を取得する
        -- @param index (integer) インデックス(最初のインデックスは0)
        -- @return (TempoTableItem) テンポ変更情報
        function this:get( index )
            return self._array[index];
        end

        ---
        -- 指定したインデックスのテンポ変更情報を設定する
        -- @param index (integer) インデックス(最初のインデックスは0)
        -- @param value (TempoTableItem) 設定するイベント
        function this:set( index, value )
            self._array[index] = value;
        end

        ---
        -- 時刻の単位を、秒単位から Tick 単位に変換する
        -- @param time (double) 秒単位の時刻
        -- @return (double) Tick 単位の時刻
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
                tempo = self._array[0].tempo;
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
        -- リスト内のテンポ変更情報の秒単位の時刻部分を更新する
        function this:updateTempoInfo()
            local c = self._array:size();
            if( c == 0 )then
                self._array:push( luavsq.TempoTableItem.new( 0, luavsq.TempoTable.baseTempo, 0.0 ) );
            end
            self._array:sort( luavsq.TempoTableItem.compare );
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
        -- 時刻の単位を、Tick 単位から秒単位に変換する
        -- @param clock (double) Tick 単位の時刻
        -- @return (double) 秒単位の時刻
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

        ---
        -- 指定した時刻におけるテンポを取得する
        -- @param clock (integer) Tick 単位の時刻
        -- @return (integer) テンポ値。四分音符の長さをマイクロ秒単位で表した値
        function this:getTempoAt( clock )
            local index = 0;
            local c = self:size();
            local i;
            for i = c - 1, 0, -1 do
                index = i;
                if( self:get( i ).clock <= clock )then
                    break;
                end
            end
            return self:get( index ).tempo;
        end

        return this;
    end

    luavsq.TempoTable.gatetimePerQuater = 480;
    luavsq.TempoTable.baseTempo = 500000;

end
