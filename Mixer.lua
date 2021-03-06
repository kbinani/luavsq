--[[
  Mixer.lua
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
-- VSQ ファイルのメタテキストの [Mixer] セクションに記録される内容を取り扱うクラス
-- @class table
-- @name Mixer
Mixer = {};

--
-- 初期化を行う
-- @return (Mixer)
function Mixer.new( ... )
    local this = {};
    local arguments = { ... };

    ---
    -- MasterFader 値
    -- @var int
    this.masterFeder = 0;

    ---
    -- MasterMute 値
    -- @var int
    this.masterMute = 0;

    ---
    -- MasterPanpot 値
    -- @var int
    this.masterPanpot = 0;

    ---
    -- OutputMode 値
    -- @var int
    this.outputMode = 0;

    ---
    -- 各トラックのミキサー情報
    -- @var table<MixerItem>
    this.slave = {};

    ---
    -- 各パラメータを指定し、初期化を行う
    -- @param masterFeder (int) MasterFader 値
    -- @param masterPanpot (int) MasterPanpot 値
    -- @param masterMute (int) MasterMute 値
    -- @param outputMode (int) OutputMode 値
    -- @return (Mixer)
    -- @name new<!--2-->
    -- @access static ctor
    function this:_init_4( masterFeder, masterPanpot, masterMute, outputMode )
        self.masterFeder = masterFeder;
        self.masterMute = masterMute;
        self.masterPanpot = masterPanpot;
        self.outputMode = outputMode;
        self.slave = {};
    end

    ---
    -- テキストストリームから読み込みを行い、初期化を行う
    -- @param stream (TextStream) 読み込むテキストストリーム
    -- @param lastLine (table) 読み込んだ最後の行。テーブルの ["value"] に文字列が格納される
    -- @return (Mixer)
    -- @name new<!--1-->
    -- @access static ctor
    function this:_init_2( stream, lastLine )
        self.masterFeder = 0;
        self.masterPanpot = 0;
        self.masterMute = 0;
        self.outputMode = 0;
        local tracks = 0;
        local spl;
        local buffer = "";
        lastLine.value = stream:readLine();
        while( lastLine.value:sub( 1, 1 ) ~= "[" )do
            spl = Util.split( lastLine.value, "=" );
            if( spl[1] == "MasterFeder" )then
                self.masterFeder = tonumber( spl[2], 10 );
            elseif( spl[1] == "MasterPanpot" )then
                self.masterPanpot = tonumber( spl[2], 10 );
            elseif( spl[1] == "MasterMute" )then
                self.masterMute = tonumber( spl[2], 10 );
            elseif( spl[1] == "OutputMode" )then
                self.outputMode = tonumber( spl[2], 10 );
            elseif( spl[1] == "Tracks" )then
                tracks = tonumber( spl[2], 10 );
            else
                if( spl[1]:find( "Feder" ) == 1 or
                     spl[1]:find( "Panpot" ) == 1 or
                     spl[1]:find( "Mute" ) == 1 or
                     spl[1]:find( "Solo" ) == 1 )then
                    buffer = buffer .. spl[1] .. "=" .. spl[2] .. "\n";
                end
            end
            if( not stream:ready() )then
                break;
            end
            lastLine.value = stream:readLine();
        end

        self.slave = {};
        local i;
        for i = 1, tracks, 1 do
            self.slave[i] = MixerItem.new( 0, 0, 0, 0 );
        end
        spl = Util.split( buffer, "\n" );
        local spl2;
        for i = 1, #spl, 1 do
            local ind = "";
            local index;
            spl2 = Util.split( spl[i], "=" );
            if( spl2[1]:find( "Feder" ) == 1 )then
                ind = spl2[1]:gsub( "Feder", "" );
                index = tonumber( ind, 10 );
                self.slave[index + 1].feder = tonumber( spl2[2], 10 );
            elseif( spl2[1]:find( "Panpot" ) == 1 )then
                ind = spl2[1]:gsub( "Panpot", "" );
                index = tonumber( ind, 10 );
                self.slave[index + 1].panpot = tonumber( spl2[2], 10 );
            elseif( spl2[1]:find( "Mute" ) == 1 )then
                ind = spl2[1]:gsub( "Mute", "" );
                index = tonumber( ind, 10 );
                self.slave[index + 1].mute = tonumber( spl2[2], 10 );
            elseif( spl2[1]:find( "Solo" ) == 1 )then
                ind = spl2[1]:gsub( "Solo", "" );
                index = tonumber( ind, 10 );
                self.slave[index + 1].solo = tonumber( spl2[2], 10 );
            end
        end
    end

    ---
    -- コピーを作成する
    -- @return (Mixer) このオブジェクトのコピー
    function this:clone()
        local res = Mixer.new( self.masterFeder, self.masterPanpot, self.masterMute, self.outputMode );
        res.slave = {};
        local i;
        for i = 1, #self.slave, 1 do
            local item = self.slave[i];
            res.slave[i] = item:clone();
        end
        return res;
    end

    ---
    -- テキストストリームに出力する
    -- @param stream (TextStream) 出力先のストリーム
    function this:write( stream )
        stream:writeLine( "[Mixer]" );
        stream:writeLine( "MasterFeder=" .. self.masterFeder );
        stream:writeLine( "MasterPanpot=" .. self.masterPanpot );
        stream:writeLine( "MasterMute=" .. self.masterMute );
        stream:writeLine( "OutputMode=" .. self.outputMode );
        local count = #self.slave;
        stream:writeLine( "Tracks=" .. count );
        local i;
        for i = 1, count, 1 do
            local item = self.slave[i];
            stream:writeLine( "Feder" .. (i - 1) .. "=" .. item.feder );
            stream:writeLine( "Panpot" .. (i - 1) .. "=" .. item.panpot );
            stream:writeLine( "Mute" .. (i - 1) .. "=" .. item.mute );
            stream:writeLine( "Solo" .. (i - 1) .. "=" .. item.solo );
        end
    end

    if( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    elseif( #arguments == 4 )then
        this:_init_4( arguments[1], arguments[2], arguments[3], arguments[4] );
    end

    return this;
end
