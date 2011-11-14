--[[
  IconDynamicsHandle.lua
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

if( nil == luavsq.IconDynamicsHandle )then

    luavsq.IconDynamicsHandle = {};

    ---
    -- 強弱記号の場合の、IconId の最初の5文字。
    luavsq.IconDynamicsHandle.ICONID_HEAD_DYNAFF = "$0501";

    ---
    -- クレッシェンドの場合の、IconId の最初の5文字。
    luavsq.IconDynamicsHandle.ICONID_HEAD_CRESCEND = "$0502";

    ---
    -- デクレッシェンドの場合の、IconId の最初の5文字。
    luavsq.IconDynamicsHandle.ICONID_HEAD_DECRESCEND = "$0503";

    function luavsq.IconDynamicsHandle.new()
        local this = luavsq.IconParameter.new();

        this.articulation = luavsq.ArticulationTypeEnum.Dynaff;

        ---
        -- この強弱記号設定を一意に識別するためのIDです。
        this.iconId = "";

        ---
        -- ユーザ・フレンドリー名です。
        -- このフィールドの値は、他の強弱記号設定のユーザ・フレンドリー名と重複する場合があります。
        this.ids = "";

        ---
        -- この強弱記号設定が他の強弱記号設定から派生したものである場合、派生元を特定するための番号です。
        this.original = 0;

        ---
        -- このハンドルが強弱記号を表すものかどうかを表すブール値を取得します。
        -- @return [bool]
        function this:isDynaffType()
            if( nil ~= self.iconId )then
                return self.iconId:find( luavsq.IconDynamicsHandle.ICONID_HEAD_DYNAFF ) == 1;
            else
                return false;
            end
        end

        ---
        -- このハンドルがクレッシェンドを表すものかどうかを表すブール値を取得します。
        -- @return [bool]
        function this:isCrescendType()
            if( nil ~= self.iconId )then
                return self.iconId:find( luavsq.IconDynamicsHandle.ICONID_HEAD_CRESCEND ) == 1;
            else
                return false;
            end
        end

        ---
        -- このハンドルがデクレッシェンドを表すものかどうかを表すブール値を取得します。
        -- @return [bool]
        function this:isDecrescendType()
            if( nil ~= self.iconId )then
                return self.iconId:find( luavsq.IconDynamicsHandle.ICONID_HEAD_DECRESCEND ) == 1;
            else
                return false;
            end
        end

        ---
        -- このインスタンスのコピーを作成します。
        -- @return [object]
        function this:clone()
            local ret = luavsq.IconDynamicsHandle.new();
            ret.iconId = self.iconId;
            ret.ids = self.ids;
            ret.original = self.original;
            ret:setCaption( self:getCaption() );
            ret:setStartDyn( self:getStartDyn() );
            ret:setEndDyn( self:getEndDyn() );
            if( nil ~= self.dynBP )then
                ret:setDynBP( self.dynBP:clone() );
            end
            ret:setLength( self:getLength() );
            return ret;
        end

        ---
        -- この強弱記号設定のインスタンスを、Handleに型キャストします。
        -- @return [VsqHandle]
        function this:castToHandle()
            local ret = luavsq.Handle.new();
            ret._type = luavsq.HandleTypeEnum.Dynamics;
            ret.iconId = self.iconId;
            ret.ids = self.ids;
            ret.original = self.original;
            ret.caption = self:getCaption();
            ret.dynBP = self:getDynBP();
            ret.endDyn = self:getEndDyn();
            ret:setLength( self:getLength() );
            ret.startDyn = self:getStartDyn();
            return ret;
        end

        ---
        -- キャプションを取得します。
        -- @return [string]
        function this:getCaption()
            return self.caption;
        end

        ---
        -- キャプションを設定します。
        -- @param value [string]
        -- @return [void]
        function this:setCaption( value )
            self.caption = value;
        end

        ---
        -- ゲートタイム長さを取得します。
        -- @return [int]
        function this:getLength()
            return self.length;
        end

        ---
        -- ゲートタイム長さを設定します。
        -- @param value [int]
        -- @return [void]
        function this:setLength( value )
            self.length = value;
        end

        ---
        -- DYNの開始値を取得します。
        -- @return [int]
        function this:getStartDyn()
            return self.startDyn;
        end

        ---
        -- DYNの開始値を設定します。
        -- @param value [int]
        function this:setStartDyn( value )
            self.startDyn = value;
        end

        ---
        -- DYNの終了値を取得します。
        -- @return [int]
        function this:getEndDyn()
            return self.endDyn;
        end

        ---
        -- DYNの終了値を設定します。
        -- @param value [int]
        -- @return [void]
        function this:setEndDyn( value )
            self.endDyn = value;
        end

        ---
        -- DYNカーブを表すリストを取得します。
        -- @return [VibratoBPList]
        function this:getDynBP()
            return self.dynBP;
        end

        ---
        -- DYNカーブを表すリストを設定します。
        -- @param value [VibratoBPList]
        -- @return [void]
        function this:setDynBP( value )
            self.dynBP = value;
        end

        return this;
    end

end
