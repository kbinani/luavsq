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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.PlayModeEnum )then

    ---
    -- 歌声合成の再生モードを表す列挙子
    -- @class table
    -- @name luavsq.PlayModeEnum
    luavsq.PlayModeEnum = {};

    ---
    -- トラックはミュートされる(-1)
    luavsq.PlayModeEnum.Off = -1;

    ---
    -- トラックは合成された後再生される(0)
    luavsq.PlayModeEnum.PlayAfterSynth = 0;

    ---
    -- トラックは合成しながら再生される(1)
    luavsq.PlayModeEnum.PlayWithSynth = 1;

end
