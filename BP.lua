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
BP = {};

---
-- コンストラクタ
-- @param _value (integer) データ点の値
-- @param _id (integer) データ点のユニークID
-- @return (BP) データ点のオブジェクト
-- @name <i>new</i>
function BP.new( _value, _id )
    local this = {};
    this.value = _value;
    this.id = _id;

    ---
    -- コピーを作成する
    -- @return (BP) このインスタンスのコピー
    -- @name clone
    function this:clone()
        return BP.new( self.value, self.id );
    end

    return this;
end
