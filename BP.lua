--[[
  BPPair.lua
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

if( nil == luavsq.BP )then

    ---
    -- コントロールカーブのデータ点を表現するクラス
    luavsq.BP = {};

    function luavsq.BP.new( _value, _id )
        local this = {};
        this.value = _value;
        this.id = _id;

        ---
        -- 簡易コピーを返す
        -- @return [object]
        function this:clone()
            return luavsq.BP.new( self.value, self.id );
        end

        return this;
    end

end
