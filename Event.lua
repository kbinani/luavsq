--[[
  Event.lua
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

if( nil == luavsq.Event )then

    ---
    -- vsqファイルのメタテキスト内に記述されるイベント。
    luavsq.Event = {};

    function luavsq.Event.new( ... )
        local arguments = { ... };
        local this = {};
        this.tag = "";

        ---
        -- 内部で使用するインスタンス固有のID
        -- @var (integer)
        this.internalID = -1;

        this.clock = 0;

        ---
        -- @var (luavsq.ID)
        this.ID = nil;

        ---
        -- @var (luavsq.UstEvent)
        this.ustEvent = nil;

        --[[
        -- @param item [VsqEvent]
        -- @return [bool]
        function this:equals( item )
            if( self.clock ~= item.clock )then
                return false;
            end
            if( self.ID.type ~= item.ID.type )then
                return false;
            end
            if( self.ID.type == luavsq.IDType.Anote )then
                if( self.ID.note ~= item.ID.note )then
                    return false;
                end
                if( self.ID:getLength() ~= item.ID:getLength() )then
                    return false;
                end
                if( self.ID.d4mean ~= item.ID.d4mean )then
                    return false;
                end
                if( self.ID.demAccent ~= item.ID.demAccent )then
                    return false;
                end
                if( self.ID.demDecGainRate ~= item.ID.demDecGainRate )then
                    return false;
                end
                if( self.ID.dynamics ~= item.ID.dynamics )then
                    return false;
                end
                if( self.ID.lyricHandle ~= nil and item.ID.lyricHandle ~= nil )then
                    return false;
                end
                if( self.ID.lyricHandle ~= nil and item.ID.lyricHandle == nil )then
                    return false;
                end
                if( self.ID.lyricHandle ~= nil and item.ID.lyricHandle ~= nil )then
                    if( self.ID.lyricHandle:getCount() ~= item.ID.lyricHandle:getCount() )then
                        return false;
                    end
                    local count = self.ID.lyricHandle:getCount();
                    local k;
                    for k = 0, count - 1, 1 do
                        if( not self.ID.lyricHandle:getLyricAt( k ):equalsForSynth( item.ID.lyricHandle:getLyricAt( k ) ) )then
                            return false;
                        end
                    end
                end
                if( self.ID.noteHeadHandle == nil and item.ID.noteHeadHandle ~= nil )then
                    return false;
                end
                if( self.ID.noteHeadHandle ~= nil and item.ID.noteHeadHandle == nil )then
                    return false;
                end
                if( self.ID.noteHeadHandle ~= nil and item.ID.noteHeadHandle ~= nil )then
                    if( self.ID.NoteHeadHandle.iconID ~= item.ID.noteHeadHandle.iconID )then
                        return false;
                    end
                    if( self.ID.noteHeadHandle:getDepth() ~= item.ID.noteHeadHandle:getDepth() )then
                        return false;
                    end
                    if( self.ID.noteHeadHandle:getDuration() ~= item.ID.noteHeadHandle:getDuration() )then
                        return false;
                    end
                    if( self.ID.noteHeadHandle:getLength() ~= item.ID.noteHeadHandle:getLength() )then
                        return false;
                    end
                end
                if( self.ID.pmBendDepth ~= item.ID.pmBendDepth )then
                    return false;
                end
                if( self.ID.pmBendLength ~= item.ID.pmBendLength )then
                    return false;
                end
                if( self.ID.pmbPortamentoUse ~= item.ID.pmbPortamentoUse )then
                    return false;
                end
                if( self.ID.pMeanEndingNote ~= item.ID.pMeanEndingNote )then
                    return false;
                end
                if( self.ID.pMeanOnsetFirstNote ~= item.ID.pMeanOnsetFirstNote )then
                    return false;
                end
                local hVibratoThis = self.ID.vibratoHandle;
                local hVibratoItem = item.ID.vibratoHandle;
                if( hVibratoThis == nil and hVibratoItem ~= nil )then
                    return false;
                end
                if( hVibratoThis ~= nil and hVibratoItem == nil )then
                    return false;
                end
                if( hVibratoThis ~= nil and hVibratoItem ~= nil )then
                    if( self.ID.vibratoDelay ~= item.ID.vibratoDelay )then
                        return false;
                    end
                    if( hVibratoThis.iconID ~= hVibratoItem.iconID )then
                        return false;
                    end
                    if( hVibratoThis:getStartDepth() ~= hVibratoItem:getStartDepth() )then
                        return false;
                    end
                    if( hVibratoThis:getStartRate() ~= hVibratoItem:getStartRate() )then
                        return false;
                    end
                    local vibRateThis = hVibratoThis:getRateBP();
                    local vibRateItem = hVibratoItem:getRateBP();
                    if( vibRateThis == nil and vibRateItem ~= nil )then
                        return false;
                    end
                    if( vibRateThis ~= nil and vibRateItem == nil )then
                        return false;
                    end
                    if( vibRateThis ~= nil and vibRateItem ~= nil )then
                        local numRateCount = vibRateThis:getCount();
                        if( numRateCount ~= vibRateItem:getCount() )then
                            return false;
                        end
                        local k;
                        for k = 0, numRateCount - 1, 1 do
                            local pThis = vibRateThis:getElement( k );
                            local pItem = vibRateItem:getElement( k );
                            if( pThis.x ~= pItem.x )then
                                return false;
                            end
                            if( pThis.y ~= pItem.y )then
                                return false;
                            end
                        end
                    end
                    local vibDepthThis = hVibratoThis:getDepthBP();
                    local vibDepthItem = hVibratoItem:getDepthBP();
                    if( vibDepthThis == nil and vibDepthItem ~= nil )then
                        return false;
                    end
                    if( vibDepthThis ~= nil and vibDepthItem == nil )then
                        return false;
                    end
                    if( vibDepthThis ~= nil and vibDepthItem ~= nil )then
                        local numDepthCount = vibDepthThis:getCount();
                        if( numDepthCount ~= vibDepthItem:getCount() )then
                            return false;
                        end
                        local k;
                        for k = 0, numDepthCount - 1, 1 do
                            local pThis = vibDepthThis:getElement( k );
                            local pItem = vibDepthItem:getElement( k );
                            if( pThis.x ~= pItem.x )then
                                return false;
                            end
                            if( pThis.y ~= pItem.y )then
                                return false;
                            end
                        end
                    end
                end
                if( self.ID.vMeanNoteTransition ~= item.ID.vMeanNoteTransition )then
                    return false;
                end
            elseif( self.ID.type == luavsq.IDType.Singer )then
                -- シンガーイベントの比較
                if( self.ID.iconHandle.program ~= item.ID.iconHandle.program )then
                    return false;
                end
            elseif( self.ID.type == luavsq.IDType.Aicon )then
                if( self.ID.iconDynamicsHandle.iconID ~= item.ID.iconDynamicsHandle.iconID )then
                    return false;
                end
                if( self.ID.iconDynamicsHandle:isDynaffType() )then
                    -- 強弱記号
                else
                    -- クレッシェンド・デクレッシェンド
                    if( self.ID:getLength() ~= item.ID:getLength() )then
                        return false;
                    end
                end
            end

            return true;
        end]]

        function this:write( ... )
            local arguments = { ... };
            if( #arguments == 1 )then
                self:_write_1( arguments[1] );
            elseif( #arguments == 2 )then
                self:_write_2( arguments[1], arguments[2] );
            end
        end

        ---
        -- インスタンスをテキストファイルに出力します
        -- @param sw [ITextWriter] 出力先
        function this:_write_1( sw )
            local def = { "Length",
                        "Note#",
                        "Dynamics",
                        "PMBendDepth",
                        "PMBendLength",
                        "PMbPortamentoUse",
                        "DEMdecGainRate",
                        "DEMaccent" };
            self:_write_2( sw, def );
        end

        ---
        -- @param writer [ITextWriter]
        -- @param print_targets [vector<string>]
        function this:_write_2( writer, print_targets )
            writer:writeLine( "[ID#" .. string.format( "%04d", self.ID.value ) .. "]" );
            writer:writeLine( "Type=" .. luavsq.IDType.toString( self.ID.type ) );
            if( self.ID.type == luavsq.IDType.Anote )then
                if( luavsq.Util.searchArray( print_targets, "Length" ) >= 1 )then
                    writer:writeLine( "Length=" .. self.ID:getLength() );
                end
                if( luavsq.Util.searchArray( print_targets, "Note#" ) >= 1 )then
                    writer:writeLine( "Note#=" .. self.ID.note );
                end
                if( luavsq.Util.searchArray( print_targets, "Dynamics" ) >= 1 )then
                    writer:writeLine( "Dynamics=" .. self.ID.dynamics );
                end
                if( luavsq.Util.searchArray( print_targets, "PMBendDepth" ) >= 1 )then
                    writer:writeLine( "PMBendDepth=" .. self.ID.pmBendDepth );
                end
                if( luavsq.Util.searchArray( print_targets, "PMBendLength" ) >= 1 )then
                    writer:writeLine( "PMBendLength=" .. self.ID.pmBendLength );
                end
                if( luavsq.Util.searchArray( print_targets, "PMbPortamentoUse" ) >= 1 )then
                    writer:writeLine( "PMbPortamentoUse=" .. self.ID.pmbPortamentoUse );
                end
                if( luavsq.Util.searchArray( print_targets, "DEMdecGainRate" ) >= 1 )then
                    writer:writeLine( "DEMdecGainRate=" .. self.ID.demDecGainRate );
                end
                if( luavsq.Util.searchArray( print_targets, "DEMaccent" ) >= 1 )then
                    writer:writeLine( "DEMaccent=" .. self.ID.demAccent );
                end
                if( luavsq.Util.searchArray( print_targets, "PreUtterance" ) >= 1 )then
                    writer:writeLine( "PreUtterance=" .. self.ustEvent.preUtterance );
                end
                if( luavsq.Util.searchArray( print_targets, "VoiceOverlap" ) >= 1 )then
                    writer:writeLine( "VoiceOverlap=" .. self.ustEvent.voiceOverlap );
                end
                if( self.ID.lyricHandle ~= nil )then
                    writer:writeLine( "LyricHandle=h#" .. string.format( "%04d", self.ID.lyricHandleIndex ) );
                end
                if( self.ID.vibratoHandle ~= nil )then
                    writer:writeLine( "VibratoHandle=h#" .. string.format( "%04d", self.ID.vibratoHandleIndex ) );
                    writer:writeLine( "VibratoDelay=" .. self.ID.vibratoDelay );
                end
                if( self.ID.noteHeadHandle ~= nil )then
                    writer:writeLine( "NoteHeadHandle=h#" .. string.format( "%04d", self.ID.noteHeadHandleIndex ) );
                end
            elseif( self.ID.type == luavsq.IDType.Singer )then
                writer:writeLine( "IconHandle=h#" .. string.format( "%04d", self.ID.iconHandleIndex ) );
            elseif( self.ID.type == luavsq.IDType.Aicon )then
                writer:writeLine( "IconHandle=h#" .. string.format( "%04d", self.ID.iconHandleIndex ) );
                writer:writeLine( "Note#=" .. self.ID.note );
            end
        end

        ---
        -- このオブジェクトのコピーを作成します
        -- @return [object]
        function this:clone()
            local ret = luavsq.Event.new( self.clock, self.ID:clone() );
            ret.internalID = self.internalID;
            if( self.ustEvent ~= nil )then
                ret.ustEvent = self.ustEvent:clone();
            end
            ret.tag = self.tag;
            return ret;
        end

        ---
        -- @param item [VsqEvent]
        -- @return [int]
        function this:compareTo( item )
            local ret = self.clock - item.clock;
            if( ret == 0 )then
                if( self.ID ~= nil and item.ID ~= nil )then
                    return self.ID.type - item.ID.type;
                else
                    return ret;
                end
            else
                return ret;
            end
        end

        ---
        -- @param line [string]
        -- @return [VsqEvent]
        function this:_init_1( line )
            local spl = luavsq.Util.split( line, '=' );
            self.clock = tonumber( spl[1], 10 );
            if( spl[2] == "EOS" )then
                self.ID = luavsq.ID.EOS:clone();
            end
        end

        function this:_init_0()
            self.clock = 0;
            self.ID = luavsq.ID.new();
            self.internalID = 0;
        end

        ---
        -- @param clcok [int]
        -- @param id [VsqID]
        -- @return [VsqEvent]
        function this:_init_2( clock, id )
            self.clock = clock;
            self.ID = id;
            self.internalID = 0;
        end

        if( #arguments == 0 )then
            this:_init_0();
        elseif( #arguments == 1 )then
            this:_init_1( arguments[1] );
        elseif( #arguments == 2 )then
            this:_init_2( arguments[1], arguments[2] );
        end

        return this;
    end

    ---
    -- 2 つの Event を比較します
    -- @param a (luavsq.Event)
    -- @param b (luavsq.Event)
    -- @return (integer)
    function luavsq.Event.compare( a, b )
        return a:compareTo( b );
    end

end
