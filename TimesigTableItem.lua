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

---
-- 初期化を行う
-- @see TimesigTableItem:_init_4
-- @return (TimesigTableItem)
function TimesigTableItem.new( ... )
    local this = {};
    local arguments = { ... };

    ---
    -- クロック数
    this.clock = 0;

    ---
    -- 拍子の分子
    this.numerator = 4;

    ---
    -- 拍子の分母
    this.denominator = 4;

    ---
    -- 何小節目か
    this.barCount = 0;

    ---
    -- 初期化を行う
    -- @param clock (integer) Tick 単位の時刻
    -- @param numerator (integer) 拍子の分子の値
    -- @param denominator (integer) 拍子の分母値
    -- @param bar_count (integer) 小節数
    function this:_init_4( clock, numerator, denominator, barCount )
        self.clock = clock;
        self.numerator = numerator;
        self.denominator = denominator;
        self.barCount = barCount;
    end

    ---
    -- 文字列に変換する
    -- @return (string) 変換後の文字列
    function this:toString()
        return "{Clock=" .. self.clock .. ", Numerator=" .. self.numerator .. ", Denominator=" .. self.denominator .. ", BarCount=" .. self.barCount .. "}";
    end

    ---
    -- コピーを作成する
    -- @return (TimesigTableItem) このオブジェクトのコピー
    function this:clone()
        return TimesigTableItem.new( self.clock, self.numerator, self.denominator, self.barCount );
    end

    ---
    -- 順序を比較する
    -- @param item (TimesigTableItem) 比較対象のアイテム
    -- @return (integer) このインスタンスが比較対象よりも小さい場合は負の整数、等しい場合は 0、大きい場合は正の整数を返す
    function this:compareTo( item )
        return self.barCount - item.barCount;
    end

    if( #arguments == 4 )then
        this:_init_4( arguments[1], arguments[2], arguments[3], arguments[4] );
    end

    return this;
end

---
-- 2 つの TimesigTableItem を比較する
-- @param a (TimesigTableItem) 比較対象のオブジェクト
-- @param b (TimesigTableItem) 比較対象のオブジェクト
-- @return (boolean) a が b よりも小さい場合は true、そうでない場合は false を返す
function TimesigTableItem.compare( a, b )
    return (a:compareTo( b ) < 0);
end
