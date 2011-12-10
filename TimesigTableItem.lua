--[[
  TimesigTableItem.lua
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
-- 拍子変更情報テーブル内の要素を表現するためのクラス
-- @class table
-- @name TimesigTableItem
TimesigTableItem = {};

--
-- 初期化を行う
-- @return (TimesigTableItem)
function TimesigTableItem.new( ... )
    local this = {};
    local arguments = { ... };

    ---
    -- Tick 単位の時刻
    -- @var integer
    -- @access private
    this._clock = 0;

    ---
    -- 拍子の分子
    -- @var integer
    this.numerator = 4;

    ---
    -- 拍子の分母
    -- @var integer
    this.denominator = 4;

    ---
    -- 何小節目か
    -- @var integer
    this.barCount = 0;

    ---
    -- 初期化を行う
    -- @param numerator (integer) 拍子の分子の値
    -- @param denominator (integer) 拍子の分母値
    -- @param barCount (integer) 小節数
    -- @return (TimesigTableItem)
    -- @name new
    -- @access static ctor
    function this:_init_3( numerator, denominator, barCount )
        self.numerator = numerator;
        self.denominator = denominator;
        self.barCount = barCount;
    end

    ---
    -- Tick 単位の時刻を取得する
    -- @return (integer) 単位の時刻
    -- @name getTick
    function this:getTick()
        return self._clock;
    end

    ---
    -- 文字列に変換する
    -- @return (string) 変換後の文字列
    -- @name toString
    function this:toString()
        return "{Clock=" .. self._clock .. ", Numerator=" .. self.numerator .. ", Denominator=" .. self.denominator .. ", BarCount=" .. self.barCount .. "}";
    end

    ---
    -- コピーを作成する
    -- @return (TimesigTableItem) このオブジェクトのコピー
    -- @name clone
    function this:clone()
        local result = TimesigTableItem.new( self.numerator, self.denominator, self.barCount );
        result._clock = self._clock;
        return result;
    end

    ---
    -- 順序を比較する
    -- @param item (TimesigTableItem) 比較対象のアイテム
    -- @return (integer) このインスタンスが比較対象よりも小さい場合は負の整数、等しい場合は 0、大きい場合は正の整数を返す
    -- @name compareTo
    function this:compareTo( item )
        return self.barCount - item.barCount;
    end

    if( #arguments == 3 )then
        this:_init_3( arguments[1], arguments[2], arguments[3] );
    end

    return this;
end

---
-- 2 つの {@link TimesigTableItem} を比較する
-- @param a (TimesigTableItem) 比較対象のオブジェクト
-- @param b (TimesigTableItem) 比較対象のオブジェクト
-- @return (boolean) <code>a</code> が <code>b</code> よりも小さい場合は <code>true</code>、そうでない場合は <code>false</code> を返す
-- @name compare
-- @access static
function TimesigTableItem.compare( a, b )
    return (a:compareTo( b ) < 0);
end
