--[[
  BPListSearchResult.lua
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
-- コントロールパラメータのデータ点検索結果を格納するクラス
-- @class table
-- @name BPListSearchResult
BPListSearchResult = {};

---
-- 初期化を行う
-- @return (BPListSearchResult)
-- @access static ctor
function BPListSearchResult.new()
    local this = {};

    ---
    -- データ点の Tick 単位の時刻
    -- @var int
    this.clock = 0;

    ---
    -- データ点のインデックス。最初のインデックスは 0
    -- @var int
    this.index = 0;

    ---
    -- データ点のオブジェクト
    -- @var BP
    this.point = BP.new();
    return this;
end
