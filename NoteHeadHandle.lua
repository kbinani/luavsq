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

    ---
    -- アタックハンドル
    luavsq.NoteHeadHandle = {};

    ---
    -- 初期化を行う
    -- @return (luavsq.NoteHeadHandle)
    function luavsq.NoteHeadHandle.new( ids, iconId, index )
        local this = luavsq.IconParameter.new();

        this.articulation = luavsq.ArticulationTypeEnum.NoteAttack;
        this.index = 0;
        this.iconId = "";
        this.ids = "";
        this.original = 0;

        ---
        -- 文字列に変換する
        -- @return (string) 変換後の文字列
        function this:toString()
            return self:getDisplayString();
        end

        ---
        -- Depth 値を取得する
        -- @return (integer) Depth 値
        function this:getDepth()
            return self.depth;
        end

        ---
        -- Depth 値を設定する
        -- @param value (integer) Depth 値
        function this:setDepth( value )
            self.depth = value;
        end

        ---
        -- Duration 値を取得する
        -- @return (integer) Duration 値
        function this:getDuration()
            return self.duration;
        end

        ---
        -- Duration 値を設定する
        -- @param value (integer) Duration 値
        function this:setDuration( value )
            self.duration = value;
        end

        ---
        -- キャプションを取得する
        -- @return (string) キャプション
        function this:getCaption()
            return self.caption;
        end

        ---
        -- キャプションを設定する
        -- @param value (string) キャプション
        function this:setCaption( value )
            self.caption = value;
        end

        ---
        -- 長さを取得する
        -- @return (integer) 長さ
        function this:getLength()
            return self.length;
        end

        ---
        -- 長さを設定する
        -- @param value (integer) 長さ
        function this:setLength( value )
            self.length = value;
        end

        ---
        -- Display String 値を取得する
        -- @return (string) Display String 値
        function this:getDisplayString()
            return self.ids .. self.caption;
        end

        ---
        -- コピーを作成する
        -- @return (luavsq.NoteHeadHandle) このオブジェクトのコピー
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
        -- Handle に型変換する
        -- @return (luavsq.Handle) Handle
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

        this.ids = ids;
        this.iconId = iconId;
        this.index = index;

        return this;
    end

end
