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
PlayModeEnum = {
    ---
    -- トラックはミュートされる(-1)
    -- @var integer
    OFF = -1,

    ---
    -- トラックは合成された後再生される(0)
    -- @var integer
    PLAY_AFTER_SYNTH = 0,

    ---
    -- トラックは合成しながら再生される(1)
    -- @var integer
    PLAY_WITH_SYNTH = 1,
};
