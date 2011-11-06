--[[
  VibratoHandle.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

-- requires( IconParameter.lua )
-- requires( ArticulationType.lua )
-- requires( VibratoBPList.lua )

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.VibratoHandle )then

    luavsq.VibratoHandle = {};

    function luavsq.VibratoHandle.new()
        local this = luavsq.IconParameter.new();
        this.articulation = luavsq.ArticulationType.Vibrato;
        this.startRate = 64;
        this.startDepth = 64;
        this.rateBP = luavsq.VibratoBPList.new();
        this.depthBP = luavsq.VibratoBPList.new();

        ---
        -- @return [string]
        function this:toString()
            return self:getDisplayString();
        end

        ---
        -- @return [VibratoBPList]
        function this:getRateBP()
            return self.rateBP;
        end

        ---
        -- @param value [VibratoBPList]
        -- @return [void]
        function this:setRateBP( value )
            self.rateBP = value;
        end

        ---
        -- @return [string]
        function this:getCaption()
            return self.caption;
        end

        ---
        -- @param value [string]
        -- @return [void]
        function this:setCaption( value )
            self.caption = value;
        end

        ---
        -- @return [int]
        function this:getStartRate()
            return self.startRate;
        end

        ---
        -- @param value [int]
        -- @return [void]
        function this:setStartRate( value )
            self.startRate = value;
        end

        ---
        -- @return [VibratoBPList]
        function this:getDepthBP()
            return self.depthBP;
        end

        ---
        -- @param value [VibratoBPList]
        -- @return [void]
        function this:setDepthBP( value )
            self.depthBP = value;
        end

        ---
        -- @return [int]
        function this:getStartDepth()
            return self.startDepth;
        end

        ---
        -- @param value [int]
        -- @return [void]
        function this:setStartDepth( value )
            self.startDepth = value;
        end

        ---
        -- @return [int]
        function this:getLength()
            return self.length;
        end

        ---
        -- @param value [int]
        -- @return [void]
        function this:setLength( value )
            self.length = value;
        end

        ---
        -- @return [string]
        function this:getDisplayString()
            return self.caption;
        end

        ---
        -- @return [object]
        function this:clone()
            local result = luavsq.VibratoHandle.new();
            result.index = self.index;
            result.iconID = self.iconID;
            result.ids = self.ids;
            result.original = self.original;
            result:setCaption( self.caption );
            result:setLength( self:getLength() );
            result:setStartDepth( self.startDepth );
            if( nil ~= self.depthBP )then
                result:setDepthBP( self.depthBP:clone() );
            end
            result:setStartRate( self.startRate );
            if( nil ~= self.rateBP )then
                result:setRateBP( self.rateBP:clone() );
            end
            return result;
        end

        ---
        -- @return [VsqHandle]
        function this:castToHandle()
            local ret = luavsq.Handle.new();
            ret._type = luavsq.HandleType.Vibrato;
            ret.index = self.index;
            ret.iconID = self.iconID;
            ret.ids = self.ids;
            ret.original = self.original;
            ret.caption = self.caption;
            ret:setLength( self:getLength() );
            ret.startDepth = self.startDepth;
            ret.startRate = self.startRate;
            ret.depthBP = self.depthBP:clone();
            ret.rateBP = self.rateBP:clone();
            return ret;
        end

        return this;
    end

end
