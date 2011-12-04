--[[
  BPPair.lua
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
-- コントロールカーブのデータ点を表現するクラス
-- @class table
-- @name BP
-- @field value (integer) データ点の値
-- @field id (integer) データ点のユニーク ID
BP = {};

---
-- コンストラクタ
-- @param value (integer) データ点の値
-- @param id (integer) データ点のユニーク ID
-- @return (<a href="../files/BP.html">BP</a>) データ点のオブジェクト
-- @name <i>new</i>
function BP.new( value, id )
    local this = {};
    this.value = value;
    this.id = id;

    ---
    -- コピーを作成する
    -- @return (<a href="../files/BP.html">BP</a>) このインスタンスのコピー
    -- @name clone
    function this:clone()
        return BP.new( self.value, self.id );
    end

    return this;
end
