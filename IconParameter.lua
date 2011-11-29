--[[
  IconParameter.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

---
-- アイコン設定ファイルである*.AICファイルを読み取ることで作成されるアイコン設定を表すクラス
-- アイコン設定ファイルを使用するIconDynamicsHandle、NoteHeadHandle、およびVibratoHandleの基底クラスとなっている
-- @class table
-- @name IconParameter
IconParameter = {};

---
-- 初期化を行う
-- @return (IconParameter)
function IconParameter.new()
    local this = {};

    ---
    -- アイコン設定の種類
    -- @var (ArticulationTypeEnum)
    this.articulation = ArticulationTypeEnum.Dynaff;

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
    -- ボタンテキストを取得する
    -- @return (string) ボタンテキスト
    function this:getButton()
        return self.button;
    end

    ---
    -- ボタン画像のパスを取得する
    -- @return (string) ボタン画像のパス
    function this:getButtonImageFullPath()
        return self.buttonImageFullPath;
    end

    ---
    -- ボタン画像のパスを設定する
    -- @param value (string) ボタン画像のパス
    function this:setButtonImageFullPath( value )
        self.buttonImageFullPath = value;
    end

    return this;
end
