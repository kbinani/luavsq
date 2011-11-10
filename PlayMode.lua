--[[
  PlayMode.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPLv3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.PlayMode )then

    luavsq.PlayMode = {};

    ---
    -- トラックはミュートされる．(-1)
    luavsq.PlayMode.Off = -1;

    ---
    -- トラックは合成された後再生される(0)
    luavsq.PlayMode.PlayAfterSynth = 0;

    ---
    -- トラックは合成しながら再生される(1)
    luavsq.PlayMode.PlayWithSynth = 1;

end
