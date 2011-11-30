--[[
  VibratoBP.lua
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
-- ビブラートのデータポイント
-- @class table
-- @name VibratoBP
VibratoBP = {};

--
-- 初期化を行う
function VibratoBP.new( ... )
    local arguments = { ... };
    local this = {};
    this.x = 0.0;
    this.y = 0;

    ---
    -- 初期化を行う
    -- @return (VibratoBP)
    -- @name <i>new</i><sup>1</sup>
    function this:_init_0()
    end

    ---
    -- 初期化を行う
    -- @param x (double) x 軸の値
    -- @param y (integer) y 軸の値
    -- @return (VibratoBP)
    -- @name <i>new</i><sup>2</sup>
    function this:_init_2( x, y )
        self.x = x;
        self.y = y;
    end

    ---
    -- 順序を比較する
    -- @param item (VibratoBP) 比較対象のアイテム
    -- @return (integer) このインスタンスが比較対象よりも小さい場合は負の整数、等しい場合は 0、大きい場合は正の整数を返す
    -- @name compareTo
    function this:compareTo( item )
        local v = self.x - item.x;
        if( v > 0.0 )then
            return 1;
        elseif( v < 0.0 )then
            return -1;
        end
        return 0;
    end

    if( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    else
        this:_init_0();
    end

    return this;
end

---
-- 2 つの Event を比較する
-- @param a (VibratoBP) 比較対象のオブジェクト
-- @param b (VibratoBP) 比較対象のオブジェクト
-- @return (boolean) a が b よりも小さい場合は true、そうでない場合は false を返す
-- @name <i>compare</i>
function VibratoBP.compare( a, b )
    return (a:compareTo( b ) < 0);
end
