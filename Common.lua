--[[
  Common.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local tonumber = tonumber;

module( "luavsq" );

---
-- VSQ ファイルのメタテキストの [Common] セクションに記録される内容を格納するクラス
-- @class table
-- @name Common
Common = {};

--
-- 初期化を行う
-- @return (Common)
function Common.new( ... )
    local this = {};
    local arguments = { ... };

    ---
    -- トラックの歌声合成エンジンのバージョンを表す文字列
    -- @var string
    this.version = "DSB301";

    ---
    -- トラックの名前
    -- @var string
    this.name = "Miku";

    ---
    -- (不明)
    -- @var string
    this.color = "179,181,123";

    ---
    -- ダイナミクスモード
    -- @var DynamicsModeEnum
    this.dynamicsMode = DynamicsModeEnum.EXPERT;

    ---
    -- 再生モード
    -- @var PlayModeEnum
    this.playMode = PlayModeEnum.PLAY_WITH_SYNTH;

    ---
    -- PlayModeがOff(-1)にされる直前に，PlayAfterSynthかPlayWithSynthのどちらが指定されていたかを記憶しておく．
    -- @var PlayModeEnum
    -- @access private
    this._lastPlayMode = PlayModeEnum.PLAY_WITH_SYNTH;

    ---
    -- 初期化を行う
    -- @param stream (TextStream) 読み込み元のテキストストリーム
    -- @param lastLine (table) 読み込んだ最後の行。テーブルの ["value"] に文字列が格納される
    -- @return (Common)
    -- @name new<!--1-->
    -- @access static ctor
    function this:_init_2( stream, lastLine )
        self.version = "";
        self.name = "";
        self.color = "0,0,0";
        self.dynamicsMode = 0;
        self.playMode = 1;
        lastLine.value = stream:readLine();
        while( lastLine.value:sub( 1, 1 ) ~= "[" )do
            local spl = Util.split( lastLine.value, "=" );
            local search = spl[1];
            if( search == "Version" )then
                self.version = spl[2];
            elseif( search == "Name" )then
                self.name = spl[2];
            elseif( search == "Color" )then
                self.color = spl[2];
            elseif( search == "DynamicsMode" )then
                self.dynamicsMode = tonumber( spl[2], 10 );
            elseif( search == "PlayMode" )then
                self.playMode = tonumber( spl[2], 10 );
            end
            if( not stream:ready() )then
                break;
            end
            lastLine.value = stream:readLine();
        end
    end

    ---
    -- 初期化を行う
    -- @param name (string) トラック名
    -- @param r (int) 赤(意味は不明)
    -- @param g (int) 緑(意味は不明)
    -- @param b (int) 青(意味は不明)
    -- @param dynamicsMode (DynamicsModeEnum) シーケンスの Dynamics モード
    -- @param playMode (PlayModeEnum) シーケンスの Play モード
    -- @return (Common)
    -- @name new<!--2-->
    -- @access static ctor
    function this:_init_6( name, r, g, b, dynamicsMode, playMode )
        self.version = "DSB301";
        self.name = name;
        self.color = r .. "," .. g .. "," .. b;
        self.dynamicsMode = dynamicsMode;
        self.playMode = playMode;
    end

    ---
    -- コピーを作成する
    -- @return (Common) このインスタンスのコピー
    function this:clone()
        local spl = Util.split( self.color, "," );
        local r = tonumber( spl[1], 10 );
        local g = tonumber( spl[2], 10 );
        local b = tonumber( spl[3], 10 );
        local res = Common.new( self.name, r, g, b, self.dynamicsMode, self.playMode );
        res.version = self.version;
        res._lastPlayMode = self._lastPlayMode;
        return res;
    end

    ---
    -- テキストストリームに出力する
    -- @param stream (TextStream) 出力先のストリーム
    function this:write( stream )
        stream:writeLine( "[Common]" );
        stream:writeLine( "Version=" .. self.version );
        stream:writeLine( "Name=" .. self.name );
        stream:writeLine( "Color=" .. self.color );
        stream:writeLine( "DynamicsMode=" .. self.dynamicsMode );
        stream:writeLine( "PlayMode=" .. self.playMode );
    end

    if( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    elseif( #arguments == 6 )then
        this:_init_6( arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6] );
    end

    return this;
end
