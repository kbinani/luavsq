--[[
  IconParameter.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

-- requires( ArticulationEnum.lua )

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.IconParameter )then

    ---
    -- アイコン設定ファイルである*.AICファイルを読み取ることで作成されるアイコン設定を表します。
    -- アイコン設定ファイルを使用するIconDynamicsHandle、NoteHeadHandle、およびVibratoHandleの基底クラスとなっています。
    luavsq.IconParameter = {};

    function luavsq.IconParameter.new()
        local this = {};

        ---
        -- アイコン設定の種類
        -- @var (luavsq.ArticulationTypeEnum)
        this.articulation = luavsq.ArticulationTypeEnum.Dynaff;

        ---
        -- アイコンのボタンに使用される画像ファイルへの相対パス
        this.button = "";

        ---
        -- キャプション
        this.caption = "";

        ---
        -- ゲートタイム長さ
        this.length = 0;

        ---
        -- ビブラート深さの開始値
        this.startDepth = 64;

        ---
        -- ビブラート深さの終了値
        this.endDepth = 64;

        ---
        -- ビブラート速さの開始値
        this.startRate = 64;

        ---
        -- ビブラート速さの終了値
        this.endRate = 64;

        this.startDyn = 64;
        this.endDyn = 64;
        this.duration = 1;
        this.depth = 64;
        this.dynBP = nil;
        this.depthBP = nil;
        this.rateBP = nil;
        this.buttonImageFullPath = "";

        --TODO: AIC ファイルからのコンストラクタを追加する

        ---
        -- @return [String]
        function this:getButton()
            return self.button;
        end

        ---
        -- @return [String]
        function this:getButtonImageFullPath()
            return self.buttonImageFullPath;
        end

        ---
        -- @param value [String]
        -- @return [void]
        function this:setButtonImageFullPath( value )
            self.buttonImageFullPath = value;
        end

        return this;
    end

end
