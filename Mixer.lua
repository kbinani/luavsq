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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.Mixer )then

    ---
    -- vsqファイルのメタテキストの[Mixer]セクションに記録される内容を取り扱う
    luavsq.Mixer = {};

    function luavsq.Mixer.new( ... )
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
        -- 各パラメータを指定したコンストラクタ
        -- @param master_fader [int] MasterFader値
        -- @param master_panpot [int] MasterPanpot値
        -- @param master_mute [int] MasterMute値
        -- @param output_mode [int]
        -- @return [VsqMixer]
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
        -- @param sr [TextStream]
        -- @param last_line [ByRef<string>]
        -- @return [VsqMixer]
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
                spl = luavsq.Util.split( last_line.value, "=" );
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
                self.slave[i] = luavsq.MixerItem.new( 0, 0, 0, 0 );
            end
            spl = luavsq.Util.split( buffer, "\n" );
            local spl2;
            for i = 1, #spl, 1 do
                local ind = "";
                local index;
                spl2 = luavsq.Util.split( spl[i], "=" );
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

        function this:clone()
            local res = luavsq.Mixer.new( self.masterFeder, self.masterPanpot, self.masterMute, self.outputMode );
            res.slave = {};
            local i;
            for i = 1, #self.slave, 1 do
                local item = self.slave[i];
                res.slave[i] = item:clone();
            end
            return res;
        end

        ---
        -- このインスタンスをテキストファイルに出力します
        -- @param sw (TextStream) 出力対象
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

end
