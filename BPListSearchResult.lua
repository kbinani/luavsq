--[[
  BPListSearchResult.lua
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
-- コントロールパラメータのデータ点検索結果を格納するクラス
-- @class table
-- @name BPListSearchResult
-- @field clock (integer) データ点の Tick 単位の時刻
-- @field index (integer) データ点のインデックス。最初のインデックスは 0
-- @field point (BP) データ点のオブジェクト
BPListSearchResult = {};

---
-- 初期化を行う
-- @return (BPListSearchResult)
-- @name <i>new</i>
function BPListSearchResult.new()
    local this = {};
    this.clock = 0;
    this.index = 0;
    this.point = BP.new();
    return this;
end
