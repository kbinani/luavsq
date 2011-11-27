--[[
  VibratoHandle.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

-- requires( IconParameter.lua )
-- requires( ArticulationTypeEnum.lua )
-- requires( VibratoBPList.lua )

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.VibratoHandle )then

    ---
    -- ビブラートハンドルを表すクラス
    -- @class table
    -- @name luavsq.VibratoHandle
    luavsq.VibratoHandle = {};

    ---
    -- 初期化を行う
    -- @return (luavsq.VibratoHandle)
    function luavsq.VibratoHandle.new()
        local this = luavsq.IconParameter.new();
        this.articulation = luavsq.ArticulationTypeEnum.Vibrato;
        this.index = 0;
        this.iconId = "";
        this.ids = "";
        this.original = 0;
        this.startRate = 64;
        this.startDepth = 64;
        this.rateBP = luavsq.VibratoBPList.new();
        this.depthBP = luavsq.VibratoBPList.new();

        ---
        -- 文字列に変換する
        -- @return (string) 文字列
        function this:toString()
            return self:getDisplayString();
        end

        ---
        -- Rate のビブラートカーブを取得する
        -- @return (luavsq.VibratoBPList) Rate のビブラートカーブ
        function this:getRateBP()
            return self.rateBP;
        end

        ---
        -- Rate のビブラートカーブを設定する
        -- @param value (luavsq.VibratoBPList) 設定するビブラートカーブ
        function this:setRateBP( value )
            self.rateBP = value;
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
        -- Rate の開始値を取得する
        -- @return (integer) Rate の開始値
        function this:getStartRate()
            return self.startRate;
        end

        ---
        -- Rate の開始値を設定する
        -- @param value (integer) Rate の開始値
        function this:setStartRate( value )
            self.startRate = value;
        end

        ---
        -- Depth のビブラートカーブを取得する
        -- @return (luavsq.VibratoBPList) Depth のビビラートカーブ
        function this:getDepthBP()
            return self.depthBP;
        end

        ---
        -- Depth のビブラートカーブを設定する
        -- @param value (luavsq.VibratoBPList) 設定するビブラートカーブ
        function this:setDepthBP( value )
            self.depthBP = value;
        end

        ---
        -- Depth の開始値を取得する
        -- @return (integer) Depth の開始値
        function this:getStartDepth()
            return self.startDepth;
        end

        ---
        -- Depth の開始値を設定する
        -- @param value (integer) Depth の開始値
        function this:setStartDepth( value )
            self.startDepth = value;
        end

        ---
        -- 長さを取得する
        -- @return (integer) Tick 単位の長さ
        function this:getLength()
            return self.length;
        end

        ---
        -- 長さを設定する
        -- @param value (integer) Tick 単位の長さ
        function this:setLength( value )
            self.length = value;
        end

        ---
        -- Display String の値を取得する
        -- @return (string) Display String の値
        function this:getDisplayString()
            return self.caption;
        end

        ---
        -- コピーを作成する
        -- @return (luavsq.VibratoHandle) このオブジェクトのコピー
        function this:clone()
            local result = luavsq.VibratoHandle.new();
            result.index = self.index;
            result.iconId = self.iconId;
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
            ret._type = luavsq.HandleTypeEnum.Vibrato;
            ret.index = self.index;
            ret.iconId = self.iconId;
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
