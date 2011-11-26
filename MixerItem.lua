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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.MixerItem )then

    ---
    -- Mixer の slave 要素に格納されるアイテムを表すクラス
    luavsq.MixerItem = {};

    ---
    -- 各パラメータを指定し、初期化を行う
    -- @param feder (integer) Feder値
    -- @param panpot (integer) Panpot値
    -- @param mute (integer) Mute値
    -- @param solo (integer) Solo値
    -- @return (luavsq.MixerItem)
    function luavsq.MixerItem.new( feder, panpot, mute, solo )
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
        -- @return (luavsq.MixerItem) このオブジェクトのコピー
        function this:clone()
            return luavsq.MixerItem.new( self.feder, self.panpot, self.mute, self.solo );
        end

        return this;
    end

end
