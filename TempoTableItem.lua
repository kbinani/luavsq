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

module( "luavsq" );

---
-- テンポ情報テーブル内の要素を表現するクラス
-- @class table
-- @name TempoTableItem
TempoTableItem = {};

--
-- 初期化を行う
-- @return (TempoTableItem)
function TempoTableItem.new( ... )
    local this = {};
    local arguments = { ... };

    ---
    -- Tick 単位の時刻
    -- @var integer
    this.clock = 0;

    ---
    -- テンポ値。四分音符の長さをマイクロ秒単位で表した値
    -- @var integer
    this.tempo = 0;

    this._time = 0.0;

    ---
    -- 文字列に変換する
    -- @return (string) 変換後の文字列
    function this:toString()
        return "{Clock=" .. self.clock .. ", Tempo=" .. self.tempo .. ", Time=" .. self._time .. "}";
    end

    ---
    -- コピーを作成する
    -- @return (TempoTableItem) このオブジェクトのコピー
    function this:clone()
        local result = TempoTableItem.new( self.clock, self.tempo );
        result._time = self._time;
        return result;
    end

    ---
    -- 初期化を行う
    -- @param clock (integer) Tick 単位の時刻
    -- @param tempo (integer) テンポ値。四分音符の長さをマイクロ秒単位で表した値
    -- @return (TempoTableItem)
    -- @name new
    -- @access static ctor
    function this:_init_2( clock, tempo )
        self.clock = clock;
        self.tempo = tempo;
    end

    ---
    -- 順序を比較する
    -- @param entry (TempoTableItem) 比較対象のアイテム
    -- @return (integer) このインスタンスが比較対象よりも小さい場合は負の整数、等しい場合は 0、大きい場合は正の整数を返す
    function this:compareTo( entry )
        return self.clock - entry.clock;
    end

    ---
    -- このオブジェクトのインスタンスと、指定されたオブジェクトが同じかどうかを調べる
    -- @param entry (TempoTableItem) 比較対象のオブジェクト
    -- @return (boolean) 比較対象と同じであれば <code>true</code> を、そうでなければ <code>false</code> を返す
    function this:equals( entry )
        if( self.clock == entry.clock )then
            return true;
        else
            return false;
        end
    end

    ---
    -- 秒単位の時刻を取得する
    -- @return (double) 秒単位の時刻
    function this:getTime()
        return self._time;
    end

    if( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    end

    return this;
end

---
-- 2 つの {@link TempoTableItem} を比較する
-- @param a (TempoTableItem) 比較対象のオブジェクト
-- @param b (TempoTableItem) 比較対象のオブジェクト
-- @return (boolean) <code>a</code> が <code>b</code> よりも小さい場合は <code>true</code>、そうでない場合は <code>false</code> を返す
-- @access static
function TempoTableItem.compare( a, b )
    if( a:compareTo( b ) < 0 )then
        return true;
    else
        return false;
    end
end
