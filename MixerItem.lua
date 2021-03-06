--[[
  MixerItem.lua
  Copyright © 2011 kbinani

  This file is part of luavvsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

---
-- {@link Mixer} の <code>slave</code> 要素に格納されるアイテムを表すクラス
-- @class table
-- @name MixerItem
MixerItem = {};

---
-- 各パラメータを指定し、初期化を行う
-- @param feder (int) Feder値
-- @param panpot (int) Panpot値
-- @param mute (int) Mute値
-- @param solo (int) Solo値
-- @return (MixerItem)
-- @access static ctor
function MixerItem.new( feder, panpot, mute, solo )
    local this = {};

    ---
    -- Feder値
    -- @var int
    this.feder = feder;

    ---
    -- Panpot値
    -- @var int
    this.panpot = panpot;

    ---
    -- Mute値
    -- @var int
    this.mute = mute;

    ---
    -- Solo値
    -- @var int
    this.solo = solo;

    function this:_init_4( feder, panpot, mute, solo )
        self.feder = feder;
        self.panpot = panpot;
        self.mute = mute;
        self.solo = solo;
    end

    ---
    -- コピーを作成する
    -- @return (MixerItem) このオブジェクトのコピー
    function this:clone()
        return MixerItem.new( self.feder, self.panpot, self.mute, self.solo );
    end

    return this;
end
