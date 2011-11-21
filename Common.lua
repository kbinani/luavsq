--[[
  Common.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  org.kbinani.vsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.Common )then

    ---
    -- vsqファイルのメタテキストの[Common]セクションに記録される内容を取り扱う
    luavsq.Common = {};

    ---
    -- overload1
    -- @param text_stream [TextStream]
    -- @param last_line [ByRef<String>]
    --
    -- overload2
    -- @param name [String]
    -- @param red [int]
    -- @param green [int]
    -- @param blue [int]
    -- @param dynamics_mode [int]
    -- @param play_mode [int]
    function luavsq.Common.new( ... )
        local this = {};
        local arguments = { ... };
        this.version = "DSB301";
        this.name = "Miku";
        this.color = "179,181,123";

        -- Dynamicsカーブを表示するモード(Expert)なら1、しない(Standard)なら0。
        this.dynamicsMode = luavsq.DynamicsModeEnum.Expert;

        -- Play With Synthesisなら1、Play After Synthesiなら0、Offなら-1。
        this.playMode = luavsq.PlayModeEnum.PlayWithSynth;

        -- PlayModeがOff(-1)にされる直前に，PlayAfterSynthかPlayWithSynthのどちらが指定されていたかを記憶しておく．
        this.lastPlayMode = luavsq.PlayModeEnum.PlayWithSynth;

        ---
        -- @param sr [TextStream]
        -- @param last_line [ByRef<string>]
        -- @return [void]
        function this:_init_2( sr, last_line )
            self.version = "";
            self.name = "";
            self.color = "0,0,0";
            self.dynamicsMode = 0;
            self.playMode = 1;
            last_line.value = sr:readLine();
            while( last_line.value:sub( 1, 1 ) ~= "[" )do
                local spl = luavsq.Util.split( last_line.value, "=" );
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

        function this:_init_6( name, r, g, b, dynamicsMode, playMode )
            self.version = "DSB301";
            self.name = name;
            self.color = r .. "," .. g .. "," .. b;
            self.dynamicsMode = dynamicsMode;
            self.playMode = playMode;
        end

        function this:clone()
            local spl = luavsq.Util.split( self.color, "," );
            local r = tonumber( spl[1], 10 );
            local g = tonumber( spl[2], 10 );
            local b = tonumber( spl[3], 10 );
            local res = luavsq.Common.new( self.name, r, g, b, self.dynamicsMode, self.playMode );
            res.version = self.version;
            res.lastPlayMode = self.lastPlayMode;
            return res;
        end

        ---
        -- インスタンスの内容をテキストファイルに出力します
        -- @param sw [ITextWriter] 出力先
        -- @return [void]
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

end
