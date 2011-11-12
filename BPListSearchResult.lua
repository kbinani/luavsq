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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.BPListSearchResult )then

    luavsq.BPListSearchResult = {};

    function luavsq.BPListSearchResult.new()
        local this = {};
        this.clock = 0;
        this.index = 0;
        this.point = luavsq.BP.new();
        return this;
    end

end