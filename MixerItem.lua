--[[
  MixerItem.lua
  Copyright © 2011 kbinani

  This file is part of luavvsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

---
-- <a href="../files/Mixer.html">Mixer</a> の slave 要素に格納されるアイテムを表すクラス
-- @class table
-- @name MixerItem
-- @field feder (integer) Feder値
-- @field panpot (integer) Panpot値
-- @field mute (integer) Mute値
-- @field solo (integer) Solo値
MixerItem = {};

---
-- 各パラメータを指定し、初期化を行う
-- @param feder (integer) Feder値
-- @param panpot (integer) Panpot値
-- @param mute (integer) Mute値
-- @param solo (integer) Solo値
-- @return (<a href="../files/MixerItem.html">MixerItem</a>)
-- @name <i>new</i>
function MixerItem.new( feder, panpot, mute, solo )
    local this = {};
    this.feder = feder;
    this.panpot = panpot;
    this.mute = mute;
    this.solo = solo;

    function this:_init_4( feder, panpot, mute, solo )
        self.feder = feder;
        self.panpot = panpot;
        self.mute = mute;
        self.solo = solo;
    end

    ---
    -- コピーを作成する
    -- @return (<a href="../files/MixerItem.html">MixerItem</a>) このオブジェクトのコピー
    -- @name clone
    function this:clone()
        return MixerItem.new( self.feder, self.panpot, self.mute, self.solo );
    end

    return this;
end
