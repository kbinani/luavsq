--[[
  BPPair.lua
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
-- コントロールカーブのデータ点を表現するクラス
-- @class table
-- @name BP
BP = {};

---
-- コンストラクタ
-- @param value (int) データ点の値
-- @param id (int) データ点のユニーク ID
-- @return (BP) データ点のオブジェクト
-- @access static ctor
function BP.new( value, id )
    local this = {};

    ---
    -- データ点の値
    -- @var int
    this.value = value;

    ---
    -- データ点のユニーク ID
    -- @var int
    this.id = id;

    ---
    -- コピーを作成する
    -- @return (BP) このインスタンスのコピー
    function this:clone()
        return BP.new( self.value, self.id );
    end

    return this;
end
