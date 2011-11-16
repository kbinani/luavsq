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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.MixerItem )then

    ---
    -- VsqMixerのSlave要素に格納される各エントリ
    luavsq.MixerItem = {};

    ---
    -- 各パラメータを指定したコンストラクタ
    -- @param feder (integer) Feder値
    -- @param panpot (integer) Panpot値
    -- @param mute (integer) Mute値
    -- @param solo (integer) Solo値
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

        function this:clone()
            return luavsq.MixerItem.new( self.feder, self.panpot, self.mute, self.solo );
        end

        return this;
    end

end
