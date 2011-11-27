--[[
  TempoTableItem.lua
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

if( nil == luavsq.TempoTableItem )then

    ---
    -- テンポ情報テーブル内の要素を表現するクラス
    -- @class table
    -- @name luavsq.TempoTableItem
    luavsq.TempoTableItem = {};

    ---
    -- 初期化を行う
    -- @see luavsq.TempoTable:_init_3
    -- @return (luavsq.TempoTableItem)
    function luavsq.TempoTableItem.new( ... )
        local this = {};
        local arguments = { ... };
        this.clock = 0;
        this.tempo = 0;
        this.time = 0.0;

        ---
        -- 文字列に変換する
        -- @return (string) 変換後の文字列
        function this:toString()
            return "{Clock=" .. self.clock .. ", Tempo=" .. self.tempo .. ", Time=" .. self.time .. "}";
        end

        ---
        -- コピーを作成する
        -- @return (TempoTableItem) このオブジェクトのコピー
        function this:clone()
            return luavsq.TempoTableItem.new( self.clock, self.tempo, self.time );
        end

        ---
        -- 初期化を行う
        -- @param clock (integer) Tick 単位の時刻
        -- @param tempo (integer) テンポ値。四分音符の長さをマイクロ秒単位で表した値
        -- @param time (double) 秒単位の時刻。この値は最初は 0 を指定して良い。
        --                      time フィールドの値は、TempoTable:updateTempoInfo によって更新する
        function this:_init_3( clock, tempo, time )
            self.clock = clock;
            self.tempo = tempo;
            self.time = time;
        end

        ---
        -- 順序を比較する
        -- @param item (TempoTableItem) 比較対象のアイテム
        -- @return (integer) このインスタンスが比較対象よりも小さい場合は負の整数、等しい場合は 0、大きい場合は正の整数を返す
        function this:compareTo( entry )
            return self.clock - entry.clock;
        end

        ---
        -- このオブジェクトのインスタンスと、指定されたオブジェクトが同じかどうかを調べる
        -- @param item (TempoTableItem) 比較対象のオブジェクト
        -- @return (boolean) 比較対象と同じであれば true を、そうでなければ false を返す
        function this:equals( entry )
            if( self.clock == entry.clock )then
                return true;
            else
                return false;
            end
        end

        if( #arguments == 3 )then
            this:_init_3( arguments[1], arguments[2], arguments[3] );
        end

        return this;
    end

    ---
    -- 2 つの TempoTableItem を比較する
    -- @param a (TempoTableItem) 比較対象のオブジェクト
    -- @param b (TempoTableItem) 比較対象のオブジェクト
    -- @return (boolean) a が b よりも小さい場合は true、そうでない場合は false を返す
    function luavsq.TempoTableItem.compare( a, b )
        if( a:compareTo( b ) < 0 )then
            return true;
        else
            return false;
        end
    end

end
