--[[
  Timesig.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

---
-- 拍子変更情報テーブル内の要素を表現するためのクラス
-- @class table
-- @name Timesig
Timesig = {};

--
-- 初期化を行う
-- @return (Timesig)
function Timesig.new( ... )
    local this = {};
    local arguments = { ... };

    ---
    -- Tick 単位の時刻
    -- @var int
    -- @access private
    this._clock = 0;

    ---
    -- 拍子の分子
    -- @var int
    this.numerator = 4;

    ---
    -- 拍子の分母
    -- @var int
    this.denominator = 4;

    ---
    -- 何小節目か
    -- @var int
    this.barCount = 0;

    ---
    -- 初期化を行う
    -- @param numerator (int) 拍子の分子の値
    -- @param denominator (int) 拍子の分母値
    -- @param barCount (int) 小節数
    -- @return (Timesig)
    -- @name new
    -- @access static ctor
    function this:_init_3( numerator, denominator, barCount )
        self.numerator = numerator;
        self.denominator = denominator;
        self.barCount = barCount;
    end

    ---
    -- Tick 単位の時刻を取得する
    -- @return (int) 単位の時刻
    function this:getTick()
        return self._clock;
    end

    ---
    -- 文字列に変換する
    -- @return (string) 変換後の文字列
    function this:toString()
        return "{Clock=" .. self._clock .. ", Numerator=" .. self.numerator .. ", Denominator=" .. self.denominator .. ", BarCount=" .. self.barCount .. "}";
    end

    ---
    -- コピーを作成する
    -- @return (Timesig) このオブジェクトのコピー
    function this:clone()
        local result = Timesig.new( self.numerator, self.denominator, self.barCount );
        result._clock = self._clock;
        return result;
    end

    ---
    -- 順序を比較する
    -- @param item (Timesig) 比較対象のアイテム
    -- @return (int) このインスタンスが比較対象よりも小さい場合は負の整数、等しい場合は 0、大きい場合は正の整数を返す
    function this:compareTo( item )
        return self.barCount - item.barCount;
    end

    if( #arguments == 3 )then
        this:_init_3( arguments[1], arguments[2], arguments[3] );
    end

    return this;
end

---
-- 2 つの {@link Timesig} を比較する
-- @param a (Timesig) 比較対象のオブジェクト
-- @param b (Timesig) 比較対象のオブジェクト
-- @return (boolean) <code>a</code> が <code>b</code> よりも小さい場合は <code>true</code>、そうでない場合は <code>false</code> を返す
-- @access static
function Timesig.compare( a, b )
    return (a:compareTo( b ) < 0);
end
