--[[
  ID.lua
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

if( nil == luavsq.ID )then

    ---
    -- メタテキストに埋め込まれるIDを表すクラス。
    luavsq.ID = {};

    function luavsq.ID.new( ... )
        local this = {};
        local arguments = { ... };
        this.value = -1;
        this.iconHandleIndex = 0;
        this.lyricHandleIndex = 0;
        this.vibratoHandleIndex = 0;
        this.noteHeadHandleIndex = 0;
        this.type = luavsq.IDType.Note;

        ---
        -- [IconHandle]
        this.iconHandle = nil;
        this._length = 0;
        this.note = 0;
        this.dynamics = 0;
        this.pmBendDepth = 0;
        this.pmBendLength = 0;
        this.pmbPortamentoUse = 0;
        this.demDecGainRate = 0;
        this.demAccent = 0;

        ---
        -- [LyricHandle]
        this.lyricHandle = nil;

        ---
        -- [VibratoHandle]
        this.vibratoHandle = nil;

        this.vibratoDelay = 0;

        ---
        -- [NoteHeadHandle]
        this.noteHeadHandle = nil;

        this.pMeanOnsetFirstNote = 10;
        this.vMeanNoteTransition = 12;
        this.d4mean = 24;
        this.pMeanEndingNote = 12;

        ---
        -- [IconDynamicsHandle]
        this.iconDynamicsHandle = nil;

        ---
        -- @param value [int]
        -- @return [VsqID]
        function this:_init_1( value )
            self.value = value;
        end

        --[[
        -- テキストファイルからのコンストラクタ
        -- @param sr [TextStream] 読み込み対象
        -- @param value [int]
        -- @param last_line [ByRef<string>] 読み込んだ最後の行が返されます
        -- @return [VsqID]
        function this:_init_3( sr, value, last_line )
            local spl;
            self.value = value;
            self.type = luavsq.IDType.Unknown;
            self.iconHandleIndex = -2;
            self.lyricHandleIndex = -1;
            self.vibratoHandleIndex = -1;
            self.noteHeadHandleIndex = -1;
            self:setLength( 0 );
            self.note = 0;
            self.dynamics = 64;
            self.pmBendDepth = 8;
            self.pmBendLength = 0;
            self.pmbPortamentoUse = 0;
            self.demDecGainRate = 50;
            self.demAccent = 50;
            self.vibratoDelay = 0;
            last_line.value = sr:readLine();
            while( last_line.value:find( "[" ) ~= 0 )do
                spl = luavsq.Util.split( last_line.value, '=' );
                local search = spl[1];
                if( search == "Type" )then
                    if( spl[2] == "Anote" )then
                        self.type = luavsq.IDType.Anote;
                    elseif( spl[2] == "Singer" )then
                        self.type = luavsq.IDType.Singer;
                    elseif( spl[2] == "Aicon" )then
                        self.type = luavsq.IDType.Aicon;
                    else
                        self.type = luavsq.IDType.Unknown;
                    end
                elseif( search == "Length" )then
                    self:setLength( tonumber( spl[2], 10 ) );
                elseif( search == "Note#" )then
                    self.note = tonumber( spl[2], 10 );
                elseif( search == "Dynamics" )then
                    self.dynamics = tonumber( spl[2], 10 );
                elseif( search == "PMBendDepth" )then
                    self.pmBendDepth = tonumber( spl[2], 10 );
                elseif( search == "PMBendLength" )then
                    self.pmBendLength = tonumber( spl[2], 10 );
                elseif( search == "DEMdecGainRate" )then
                    self.demDecGainRate = tonumber( spl[2], 10 );
                elseif( search ==  "DEMaccent" )then
                    self.demAccent = tonumber( spl[2], 10 );
                elseif( search == "LyricHandle" )then
                    self.lyricHandleIndex = luavsq.Handle.getHandleIndexFromString( spl[2] );
                elseif( search == "IconHandle" )then
                    self.iconHandleIndex = luavsq.Handle.getHandleIndexFromString( spl[2] );
                elseif( search == "VibratoHandle" )then
                    self.vibratoHandleIndex = luavsq.Handle.getHandleIndexFromString( spl[2] );
                elseif( search == "VibratoDelay" )then
                    self.vibratoDelay = tonumber( spl[2], 10 );
                elseif( search == "PMbPortamentoUse" )then
                    self.pmbPortamentoUse = tonumber( spl[2], 10 );
                elseif( search == "NoteHeadHandle" )then
                    self.noteHeadHandleIndex = luavsq.Handle.getHandleIndexFromString( spl[2] );
                end
                if( not sr:ready() )then
                    break;
                end
                last_line.value = sr:readLine();
            end
        end]]

        ---
        -- @return [int]
        function this:getLength()
            return self._length;
        end

        ---
        -- @param value [int]
        -- @return [void]
        function this:setLength( value )
            self._length = value;
        end

        ---
        -- このインスタンスの簡易コピーを取得します。
        -- @return [object] このインスタンスの簡易コピー
        function this:clone()
            local result = luavsq.ID.new( self.value );
            result.type = self.type;
            if( self.iconHandle ~= nil )then
                result.iconHandle = self.iconHandle:clone();
            end
            result:setLength( self:getLength() );
            result.note = self.note;
            result.dynamics = self.dynamics;
            result.pmBendDepth = self.pmBendDepth;
            result.pmBendLength = self.pmBendLength;
            result.pmbPortamentoUse = self.pmbPortamentoUse;
            result.demDecGainRate = self.demDecGainRate;
            result.demAccent = self.demAccent;
            result.d4mean = self.d4mean;
            result.pMeanOnsetFirstNote = self.pMeanOnsetFirstNote;
            result.vMeanNoteTransition = self.vMeanNoteTransition;
            result.pMeanEndingNote = self.pMeanEndingNote;
            if( self.lyricHandle ~= nil )then
                result.lyricHandle = self.lyricHandle:clone();
            end
            if( self.vibratoHandle ~= nil )then
                result.vibratoHandle = self.vibratoHandle:clone();
            end
            result.vibratoDelay = self.vibratoDelay;
            if( self.noteHeadHandle ~= nil )then
                result.noteHeadHandle = self.noteHeadHandle:clone();
            end
            if( self.iconDynamicsHandle ~= nil )then
                result.iconDynamicsHandle = self.iconDynamicsHandle:clone();
            end
            return result;
        end

        --[[
        -- @return [string]
        function this:toString()
            local ret = "{Type=" .. self.type;
            if( self.type == luavsq.IDType.Anote )then
                ret = ret .. ", Length=" .. self:getLength();
                ret = ret .. ", Note#=" .. self.note;
                ret = ret .. ", Dynamics=" .. self.dynamics;
                ret = ret .. ", PMBendDepth=" .. self.pmBendDepth;
                ret = ret .. ", PMBendLength=" .. self.pmBendLength;
                ret = ret .. ", PMbPortamentoUse=" .. self.pmbPortamentoUse;
                ret = ret .. ", DEMdecGainRate=" .. self.demDecGainRate;
                ret = ret .. ", DEMaccent=" .. self.demAccent;
                if( self.lyricHandle ~= nil )then
                    ret = ret .. ", LyricHandle=h#" .. string.format( "%04d", self.lyricHandleIndex );
                end
                if( self.vibratoHandle ~= nil )then
                    ret = ret .. ", VibratoHandle=h#" .. string.format( "%04d", self.vibratoHandleIndex );
                    ret = ret .. ", VibratoDelay=" .. self.vibratoDelay;
                end
            elseif( self.type == luavsq.IDType.Singer )then
                ret = ret .. ", IconHandle=h#" .. string.format( "%04d", self.iconHandleIndex );
            end
            ret = ret .. "}";
            return ret;
        end]]

        if( #arguments == 1 )then
            this:_init_1( arguments[1] );
        elseif( #arguments == 3 )then
            this:_init_3( arguments[1], arguments[2], arguments[3] );
        end

        return this;
    end

    luavsq.ID.EOS = luavsq.ID.new();

    ---
    -- ミリ秒で表した、音符の最大長さ
    luavsq.ID.MAX_NOTE_MILLISEC_LENGTH = 16383;

end