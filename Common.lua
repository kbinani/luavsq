--[[
  Common.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

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

---
-- 初期化を行う
-- @see this:_init_2
-- @see this:_init_6
-- @return (Common)
function Common.new( ... )
    local this = {};
    local arguments = { ... };
    this.version = "DSB301";
    this.name = "Miku";
    this.color = "179,181,123";

    -- Dynamicsカーブを表示するモード(Expert)なら1、しない(Standard)なら0。
    this.dynamicsMode = DynamicsModeEnum.Expert;

    -- Play With Synthesisなら1、Play After Synthesiなら0、Offなら-1。
    this.playMode = PlayModeEnum.PlayWithSynth;

    -- PlayModeがOff(-1)にされる直前に，PlayAfterSynthかPlayWithSynthのどちらが指定されていたかを記憶しておく．
    this.lastPlayMode = PlayModeEnum.PlayWithSynth;

    ---
    -- 初期化を行う
    -- @param sr (TextStream) 読み込み元のテキストストリーム
    -- @param last_line (table, { value = ? }) 読み込んだ最後の行。テーブルの ["value"] に文字列が格納される
    function this:_init_2( sr, last_line )
        self.version = "";
        self.name = "";
        self.color = "0,0,0";
        self.dynamicsMode = 0;
        self.playMode = 1;
        last_line.value = sr:readLine();
        while( last_line.value:sub( 1, 1 ) ~= "[" )do
            local spl = Util.split( last_line.value, "=" );
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
            if( not sr:ready() )then
                break;
            end
            last_line.value = sr:readLine();
        end
    end

    ---
    -- 初期化を行う
    -- @param name (string) トラック名
    -- @param red (integer) 赤(意味は不明)
    -- @param green (integer) 緑(意味は不明)
    -- @param blue (integer) 青(意味は不明)
    -- @param dynamicsMode (DynamicsModeEnum) シーケンスの Dynamics モード
    -- @param playMode (PlayModeEnum) シーケンスの Play モード
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
        res.lastPlayMode = self.lastPlayMode;
        return res;
    end

    ---
    -- テキストストリームに出力する
    -- @param sw (TextStream) 出力先のストリーム
    function this:write( sw )
        sw:writeLine( "[Common]" );
        sw:writeLine( "Version=" .. self.version );
        sw:writeLine( "Name=" .. self.name );
        sw:writeLine( "Color=" .. self.color );
        sw:writeLine( "DynamicsMode=" .. self.dynamicsMode );
        sw:writeLine( "PlayMode=" .. self.playMode );
    end

    if( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    elseif( #arguments == 6 )then
        this:_init_6( arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6] );
    end

    return this;
end
