--[[
  Mixer.lua
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
-- VSQ ファイルのメタテキストの [Mixer] セクションに記録される内容を取り扱うクラス
-- @class table
-- @name Mixer
Mixer = {};

---
-- 初期化を行う
-- @see _init_2
-- @see _init_4
-- @return (Mixer)
-- @name <i>new</i>
function Mixer.new( ... )
    local this = {};
    local arguments = { ... };
    this.masterFeder = 0;
    this.masterMute = 0;
    this.masterPanpot = 0;
    this.outputMode = 0;

    ---
    -- vsqファイルの各トラックのfader, panpot, muteおよびoutputmode値を保持します
    this.slave = {};

    ---
    -- 各パラメータを指定し、初期化を行う
    -- @param master_fader (integer) MasterFader 値
    -- @param master_panpot (integer) MasterPanpot 値
    -- @param master_mute (integer) MasterMute 値
    -- @param output_mode (integer) OutputMode 値
    -- @name _init_4
    function this:_init_4( master_feder, master_panpot, master_mute, output_mode )
        self.masterFeder = master_feder;
        self.masterMute = master_mute;
        self.masterPanpot = master_panpot;
        self.outputMode = output_mode;

        ---
        -- vsqファイルの各トラックのfader, panpot, muteおよびoutputmode値を保持します
        self.slave = {};
    end

    ---
    -- テキストストリームから読み込みを行い、初期化を行う
    -- @param sr (TextStream) 読み込むテキストストリーム
    -- @param lastLine (table, { value = ? }) 読み込んだ最後の行。テーブルの ["value"] に文字列が格納される
    -- @name _init_2
    function this:_init_2( stream, last_line )
        self.masterFeder = 0;
        self.masterPanpot = 0;
        self.masterMute = 0;
        self.outputMode = 0;
        local tracks = 0;
        local spl;
        local buffer = "";
        last_line.value = stream:readLine();
        while( last_line.value:sub( 1, 1 ) ~= "[" )do
            spl = Util.split( last_line.value, "=" );
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
            last_line.value = stream:readLine();
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
    -- @name clone
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
    -- @param sw (TextStream) 出力先のストリーム
    -- @name write
    function this:write( sw )
        sw:writeLine( "[Mixer]" );
        sw:writeLine( "MasterFeder=" .. self.masterFeder );
        sw:writeLine( "MasterPanpot=" .. self.masterPanpot );
        sw:writeLine( "MasterMute=" .. self.masterMute );
        sw:writeLine( "OutputMode=" .. self.outputMode );
        local count = #self.slave;
        sw:writeLine( "Tracks=" .. count );
        local i;
        for i = 1, count, 1 do
            local item = self.slave[i];
            sw:writeLine( "Feder" .. (i - 1) .. "=" .. item.feder );
            sw:writeLine( "Panpot" .. (i - 1) .. "=" .. item.panpot );
            sw:writeLine( "Mute" .. (i - 1) .. "=" .. item.mute );
            sw:writeLine( "Solo" .. (i - 1) .. "=" .. item.solo );
        end
    end

    if( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    elseif( #arguments == 4 )then
        this:_init_4( arguments[1], arguments[2], arguments[3], arguments[4] );
    end

    return this;
end
