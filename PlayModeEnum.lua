--[[
  PlayModeEnum.lua
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
-- 歌声合成の再生モードを表す列挙子
-- @class table
-- @name PlayModeEnum
-- @field Off トラックはミュートされる(-1)
-- @field PlayAfterSynth トラックは合成された後再生される(0)
-- @field PlayWithSynth トラックは合成しながら再生される(1)
PlayModeEnum = {
    ---
    -- トラックはミュートされる(-1)
    Off = -1,

    ---
    -- トラックは合成された後再生される(0)
    PlayAfterSynth = 0,

    ---
    -- トラックは合成しながら再生される(1)
    PlayWithSynth = 1,
};
