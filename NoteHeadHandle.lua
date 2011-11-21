--[[
  NoteHeadHandle.lua
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

if( nil == luavsq.NoteHeadHandle )then

    luavsq.NoteHeadHandle = {};

    function luavsq.NoteHeadHandle.new( ... )
        local arguments = { ... };
        local this = luavsq.IconParameter.new();

        this.articulation = luavsq.ArticulationTypeEnum.NoteAttack;
        this.index = 0;
        this.iconId = "";
        this.ids = "";
        this.original = 0;

        ---
        -- @return [String]
        function this:toString()
            return self:getDisplayString();
        end

        ---
        -- @return [int]
        function this:getDepth()
            return self.depth;
        end

        ---
        -- @param value [int]
        -- @return [void]
        function this:setDepth( value )
            self.depth = value;
        end

        ---
        -- @return [int]
        function this:getDuration()
            return self.duration;
        end

        ---
        -- @param value [int]
        -- @return [void]
        function this:setDuration( value )
            self.duration = value;
        end

        ---
        -- @return [String]
        function this:getCaption()
            return self.caption;
        end

        ---
        -- @param value [String]
        -- @return [void]
        function this:setCaption( value )
            self.caption = value;
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
        -- @return [String]
        function this:getDisplayString()
            return self.ids .. self.caption;
        end

        ---
        -- @return [object]
        function this:clone()
            local result = luavsq.NoteHeadHandle.new();
            result.index = self.index;
            result.iconId = self.iconId;
            result.ids = self.ids;
            result.original = self.original;
            result:setCaption( self:getCaption() );
            result:setLength( self:getLength() );
            result:setDuration( self:getDuration() );
            result:setDepth( self:getDepth() );
            return result;
        end

        ---
        -- @return [VsqHandle]
        function this:castToHandle()
            local ret = luavsq.Handle.new();
            ret._type = luavsq.HandleTypeEnum.NoteHead;
            ret.index = self.index;
            ret.iconId = self.iconId;
            ret.ids = self.ids;
            ret.original = self.original;
            ret.caption = self:getCaption();
            ret:setLength( self:getLength() );
            ret.duration = self:getDuration();
            ret.depth = self:getDepth();
            return ret;
        end

        if( #arguments == 3 )then
            this.ids = arguments[1];
            this.iconId = arguments[2];
            this.index = arguments[3];
        end

        return this;
    end

end
