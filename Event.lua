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
        this.internalId = -1;

        this.clock = 0;

        ---
        -- @var (luavsq.Id)
        this.id = nil;

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
            if( self.id.type ~= item.id.type )then
                return false;
            end
            if( self.id.type == luavsq.idType.Anote )then
                if( self.id.note ~= item.id.note )then
                    return false;
                end
                if( self.id:getLength() ~= item.id:getLength() )then
                    return false;
                end
                if( self.id.d4mean ~= item.id.d4mean )then
                    return false;
                end
                if( self.id.demAccent ~= item.id.demAccent )then
                    return false;
                end
                if( self.id.demDecGainRate ~= item.id.demDecGainRate )then
                    return false;
                end
                if( self.id.dynamics ~= item.id.dynamics )then
                    return false;
                end
                if( self.id.lyricHandle ~= nil and item.id.lyricHandle ~= nil )then
                    return false;
                end
                if( self.id.lyricHandle ~= nil and item.id.lyricHandle == nil )then
                    return false;
                end
                if( self.id.lyricHandle ~= nil and item.id.lyricHandle ~= nil )then
                    if( self.id.lyricHandle:size() ~= item.id.lyricHandle:size() )then
                        return false;
                    end
                    local count = self.id.lyricHandle:size();
                    local k;
                    for k = 0, count - 1, 1 do
                        if( not self.id.lyricHandle:getLyricAt( k ):equalsForSynth( item.id.lyricHandle:getLyricAt( k ) ) )then
                            return false;
                        end
                    end
                end
                if( self.id.noteHeadHandle == nil and item.id.noteHeadHandle ~= nil )then
                    return false;
                end
                if( self.id.noteHeadHandle ~= nil and item.id.noteHeadHandle == nil )then
                    return false;
                end
                if( self.id.noteHeadHandle ~= nil and item.id.noteHeadHandle ~= nil )then
                    if( self.id.NoteHeadHandle.iconId ~= item.id.noteHeadHandle.iconId )then
                        return false;
                    end
                    if( self.id.noteHeadHandle:getDepth() ~= item.id.noteHeadHandle:getDepth() )then
                        return false;
                    end
                    if( self.id.noteHeadHandle:getDuration() ~= item.id.noteHeadHandle:getDuration() )then
                        return false;
                    end
                    if( self.id.noteHeadHandle:getLength() ~= item.id.noteHeadHandle:getLength() )then
                        return false;
                    end
                end
                if( self.id.pmBendDepth ~= item.id.pmBendDepth )then
                    return false;
                end
                if( self.id.pmBendLength ~= item.id.pmBendLength )then
                    return false;
                end
                if( self.id.pmbPortamentoUse ~= item.id.pmbPortamentoUse )then
                    return false;
                end
                if( self.id.pMeanEndingNote ~= item.id.pMeanEndingNote )then
                    return false;
                end
                if( self.id.pMeanOnsetFirstNote ~= item.id.pMeanOnsetFirstNote )then
                    return false;
                end
                local hVibratoThis = self.id.vibratoHandle;
                local hVibratoItem = item.id.vibratoHandle;
                if( hVibratoThis == nil and hVibratoItem ~= nil )then
                    return false;
                end
                if( hVibratoThis ~= nil and hVibratoItem == nil )then
                    return false;
                end
                if( hVibratoThis ~= nil and hVibratoItem ~= nil )then
                    if( self.id.vibratoDelay ~= item.id.vibratoDelay )then
                        return false;
                    end
                    if( hVibratoThis.iconId ~= hVibratoItem.iconId )then
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
                        local numRateCount = vibRateThis:size();
                        if( numRateCount ~= vibRateItem:size() )then
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
                        local numDepthCount = vibDepthThis:size();
                        if( numDepthCount ~= vibDepthItem:size() )then
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
                if( self.id.vMeanNoteTransition ~= item.id.vMeanNoteTransition )then
                    return false;
                end
            elseif( self.id.type == luavsq.IdTypeEnum.Singer )then
                -- シンガーイベントの比較
                if( self.id.iconHandle.program ~= item.id.iconHandle.program )then
                    return false;
                end
            elseif( self.id.type == luavsq.IdTypeEnum.Aicon )then
                if( self.id.iconDynamicsHandle.iconId ~= item.id.iconDynamicsHandle.iconId )then
                    return false;
                end
                if( self.id.iconDynamicsHandle:isDynaffType() )then
                    -- 強弱記号
                else
                    -- クレッシェンド・デクレッシェンド
                    if( self.id:getLength() ~= item.id:getLength() )then
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
            writer:writeLine( "[ID#" .. string.format( "%04d", self.id.value ) .. "]" );
            writer:writeLine( "Type=" .. luavsq.IdTypeEnum.toString( self.id.type ) );
            if( self.id.type == luavsq.IdTypeEnum.Anote )then
                if( luavsq.Util.searchArray( print_targets, "Length" ) >= 1 )then
                    writer:writeLine( "Length=" .. self.id:getLength() );
                end
                if( luavsq.Util.searchArray( print_targets, "Note#" ) >= 1 )then
                    writer:writeLine( "Note#=" .. self.id.note );
                end
                if( luavsq.Util.searchArray( print_targets, "Dynamics" ) >= 1 )then
                    writer:writeLine( "Dynamics=" .. self.id.dynamics );
                end
                if( luavsq.Util.searchArray( print_targets, "PMBendDepth" ) >= 1 )then
                    writer:writeLine( "PMBendDepth=" .. self.id.pmBendDepth );
                end
                if( luavsq.Util.searchArray( print_targets, "PMBendLength" ) >= 1 )then
                    writer:writeLine( "PMBendLength=" .. self.id.pmBendLength );
                end
                if( luavsq.Util.searchArray( print_targets, "PMbPortamentoUse" ) >= 1 )then
                    writer:writeLine( "PMbPortamentoUse=" .. self.id.pmbPortamentoUse );
                end
                if( luavsq.Util.searchArray( print_targets, "DEMdecGainRate" ) >= 1 )then
                    writer:writeLine( "DEMdecGainRate=" .. self.id.demDecGainRate );
                end
                if( luavsq.Util.searchArray( print_targets, "DEMaccent" ) >= 1 )then
                    writer:writeLine( "DEMaccent=" .. self.id.demAccent );
                end
                if( luavsq.Util.searchArray( print_targets, "PreUtterance" ) >= 1 )then
                    writer:writeLine( "PreUtterance=" .. self.ustEvent.preUtterance );
                end
                if( luavsq.Util.searchArray( print_targets, "VoiceOverlap" ) >= 1 )then
                    writer:writeLine( "VoiceOverlap=" .. self.ustEvent.voiceOverlap );
                end
                if( self.id.lyricHandle ~= nil )then
                    writer:writeLine( "LyricHandle=h#" .. string.format( "%04d", self.id.lyricHandleIndex ) );
                end
                if( self.id.vibratoHandle ~= nil )then
                    writer:writeLine( "VibratoHandle=h#" .. string.format( "%04d", self.id.vibratoHandleIndex ) );
                    writer:writeLine( "VibratoDelay=" .. self.id.vibratoDelay );
                end
                if( self.id.noteHeadHandle ~= nil )then
                    writer:writeLine( "NoteHeadHandle=h#" .. string.format( "%04d", self.id.noteHeadHandleIndex ) );
                end
            elseif( self.id.type == luavsq.IdTypeEnum.Singer )then
                writer:writeLine( "IconHandle=h#" .. string.format( "%04d", self.id.iconHandleIndex ) );
            elseif( self.id.type == luavsq.IdTypeEnum.Aicon )then
                writer:writeLine( "IconHandle=h#" .. string.format( "%04d", self.id.iconHandleIndex ) );
                writer:writeLine( "Note#=" .. self.id.note );
            end
        end

        ---
        -- このオブジェクトのコピーを作成します
        -- @return [object]
        function this:clone()
            local ret = luavsq.Event.new( self.clock, self.id:clone() );
            ret.internalId = self.internalId;
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
                if( self.id ~= nil and item.id ~= nil )then
                    return self.id.type - item.id.type;
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
                self.id = luavsq.Id.getEOS();
            end
        end

        function this:_init_0()
            self.clock = 0;
            self.id = luavsq.Id.new();
            self.internalId = 0;
        end

        ---
        -- @param clcok (number)
        -- @param id (luavsq.Id)
        -- @return (luavsq.Event)
        function this:_init_2( clock, id )
            self.clock = clock;
            self.id = id;
            self.internalId = 0;
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
