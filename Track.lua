--[[
  Track.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.Track )then

    luavsq.Track = {};

    function luavsq.Track.new( ... )
        local this = {};
        local arguments = { ... };
        this.tag = "";

        ---
        -- @var luavsq.Common
        this.common = nil;

        ---
        -- @var luavsq.Master
        this.master = nil;

        ---
        -- @var luavsq.Mixer
        this.mixer = nil;

        ---
        -- @var luavsq.EventList
        this.events = nil;

        ---
        --  PIT。ピッチベンド(pitchBendBPList)。default=0
        this.pit = nil;

        ---
        --  PBS。ピッチベンドセンシティビティ(pitchBendSensBPList)。dfault=2
        this.pbs = nil;

        ---
        --  DYN。ダイナミクス(dynamicsBPList)。default=64
        this.dyn = nil;

        ---
        --  BRE。ブレシネス(epRResidualBPList)。default=0
        this.bre = nil;

        ---
        --  BRI。ブライトネス(epRESlopeBPList)。default=64
        this.bri = nil;

        ---
        --  CLE。クリアネス(epRESlopeDepthBPList)。default=0
        this.cle = nil;

        this.reso1FreqBPList = nil;
        this.reso2FreqBPList = nil;
        this.reso3FreqBPList = nil;
        this.reso4FreqBPList = nil;
        this.reso1BWBPList = nil;
        this.reso2BWBPList = nil;
        this.reso3BWBPList = nil;
        this.reso4BWBPList = nil;
        this.reso1AmpBPList = nil;
        this.reso2AmpBPList = nil;
        this.reso3AmpBPList = nil;
        this.reso4AmpBPList = nil;

        ---
        --  Harmonics。(EpRSineBPList)default = 64
        this.harmonics = nil;

        ---
        --  Effect2 Depth。
        this.fx2depth = nil;

        ---
        --  GEN。ジェンダーファクター(genderFactorBPList)。default=64
        this.gen = nil;

        ---
        -- POR。ポルタメントタイミング(portamentoTimingBPList)。default=64
        this.por = nil;

        ---
        --  OPE。オープニング(openingBPList)。default=127
        this.ope = nil;

        ---
        -- cent単位のピッチベンド。vsqに保存するときは、VsqFile#reflectPitchによってPIT, PBSに落とし込む。それらの範囲をオーバーしてたら知らん(cutoff)
        this.pitch = nil;

        ---
        -- Master Trackを構築
        -- @return [VsqTrack]
        function this:_init_0()
        end

        ---
        -- Master Trackでないトラックを構築。
        -- @param name [string]
        -- @param singer [string]
        -- @return [VsqTrack]
        function this:_init_2a( name, singer )
            self:_initCor( name, singer );
        end

        --[[
        -- @param midi_event [Array<MidiEvent>]
        -- @param encoding [string]
        function this:_init_2b( midi_event, encoding )
            local track_name = "";

            local sw = nil;
            sw = luavsq.TextStream.new();
            local count = #midi_event;
            local buffer = Array.new(); -- Vector<Integer>();
            local i;
            for i = 0; i < count; i++
                local item = midi_event[i];
                if( item.firstByte == 0xff and #item.data > 0 )then
                    -- meta textを抽出
                    local type = item.data[0];
                    if( type == 0x01 or type == 0x03 )then
                        if( type == 0x01 )then
                            local colon_count = 0;
                            local j;
                            for j = 0; j < #item.data - 1; j++
                                local d = item.data[j + 1];
                                if( d == 0x3a )then
                                    colon_count++;
                                    if( colon_count <= 2 )then
                                        continue;
                                    end
                                end
                                if( colon_count < 2 )then
                                    continue;
                                end
                                buffer.push( d );
                            end

                            local index_0x0a = org.kbinani.PortUtil.arrayIndexOf( buffer, 0x0a );
                            while( index_0x0a >= 0 )do
                                local cpy = Array.new( index_0x0a );
                                local j;
                                for j = 0; j < index_0x0a; j++
                                    cpy[j] = 0xff & buffer[0];
                                    buffer.shift();
                                end

                                local line = org.kbinani.Cp932.convertToUTF8( cpy );
--alert( "VsqTrack#_init_2b; line=" + line );
                                sw:writeLine( line );
                                buffer.shift();
                                index_0x0a = org.kbinani.PortUtil.arrayIndexOf( buffer, 0x0a );
                            end
                        else
                            local j;
                            for j = 0; j < #item.data - 1; j++
                                buffer.push( item.data[j + 1] );
                            end
                            local c = #buffer;
                            local d = Array.new( c );
                            local j;
                            for j = 0; j < c; j++
                                d[j] = 0xff & buffer[j];
                            end
                            track_name = org.kbinani.Cp932.convertToUTF8( d );
                            buffer.splice( 0, #buffer );
                        end
                    end
                else
                    continue;
                end
            end

            local remain = #buffer;
            if( remain > 0 )then
                local cpy = Array.new( remain );
                local j;
                for j = 0; j < remain; j++
                    cpy[j] = 0xff & buffer[j];
                end
                local line = org.kbinani.Cp932.convertToUTF8( cpy );
                sw:writeLine( line );
            end

            sw:setPointer( -1 );
            self.MetaText = luavsq.MetaText.new( sw );
            self.setName( track_name );
        end]]

        ---
        -- @param name [string]
        -- @param singer [string]
        function this:_initCor( name, singer )
            self.common = luavsq.Common.new( name, 179, 181, 123, 1, 1 );
            self.pit = luavsq.BPList.new( "pit", 0, -8192, 8191 );
            self.pbs = luavsq.BPList.new( "pbs", 2, 0, 24 );
            self.dyn = luavsq.BPList.new( "dyn", 64, 0, 127 );
            self.bre = luavsq.BPList.new( "bre", 0, 0, 127 );
            self.bri = luavsq.BPList.new( "bri", 64, 0, 127 );
            self.cle = luavsq.BPList.new( "cle", 0, 0, 127 );
            self.reso1FreqBPList = luavsq.BPList.new( "reso1freq", 64, 0, 127 );
            self.reso2FreqBPList = luavsq.BPList.new( "reso2freq", 64, 0, 127 );
            self.reso3FreqBPList = luavsq.BPList.new( "reso3freq", 64, 0, 127 );
            self.reso4FreqBPList = luavsq.BPList.new( "reso4freq", 64, 0, 127 );
            self.reso1BWBPList = luavsq.BPList.new( "reso1bw", 64, 0, 127 );
            self.reso2BWBPList = luavsq.BPList.new( "reso2bw", 64, 0, 127 );
            self.reso3BWBPList = luavsq.BPList.new( "reso3bw", 64, 0, 127 );
            self.reso4BWBPList = luavsq.BPList.new( "reso4bw", 64, 0, 127 );
            self.reso1AmpBPList = luavsq.BPList.new( "reso1amp", 64, 0, 127 );
            self.reso2AmpBPList = luavsq.BPList.new( "reso2amp", 64, 0, 127 );
            self.reso3AmpBPList = luavsq.BPList.new( "reso3amp", 64, 0, 127 );
            self.reso4AmpBPList = luavsq.BPList.new( "reso4amp", 64, 0, 127 );
            self.harmonics = luavsq.BPList.new( "harmonics", 64, 0, 127 );
            self.fx2depth = luavsq.BPList.new( "fx2depth", 64, 0, 127 );
            self.gen = luavsq.BPList.new( "gen", 64, 0, 127 );
            self.por = luavsq.BPList.new( "por", 64, 0, 127 );
            self.ope = luavsq.BPList.new( "ope", 127, 0, 127 );
            self.pitch = luavsq.BPList.new( "pitch", 0, -15000, 15000 );
            --[[if ( is_first_track ) {
                self.master = luavsq.Master.new( pre_measure );
            } else {
                self.master = null;
            }]]
            self.events = luavsq.EventList.new();
            local id = luavsq.Id.new( 0 );
            id.type = luavsq.IdTypeEnum.Singer;
            local ish = luavsq.SingerHandle.new();
            ish.iconId = "$07010000";
            ish.ids = singer;
            ish.original = 0;
            ish.caption = "";
            ish:setLength( 1 );
            ish.language = 0;
            ish.program = 0;
            id.singerHandle = ish;
            self.events:add( luavsq.Event.new( 0, id ) );
        end

        ---
        -- 指定された種類のイベントのインデクスを順に返すイテレータを取得します．
        --
        -- @param iterator_kind [int]
        -- @return [IndexIterator]
        function this:getIndexIterator( iterator_kind )
            return luavsq.Track.IndexIterator.new( self.events, iterator_kind );
        end

        --[[
        -- このトラックの再生モードを取得します．
        --
        -- @return [int] PlayMode.PlayAfterSynthまたはPlayMode.PlayWithSynth
        function this:getPlayMode()
            if( self.common == nil )then
                return luavsq.PlayModeEnum.PlayWithSynth;
            end
            if( self.common.lastPlayMode ~= luavsq.PlayModeEnum.PlayAfterSynth and
                 self.common.lastPlayMode ~= luavsq.PlayModeEnum.PlayWithSynth )then
                self.common.lastPlayMode = luavsq.PlayModeEnum.PlayWithSynth;
            end
            return self.common.lastPlayMode;
        end]]

        --[[
        -- このトラックの再生モードを設定します．
        --
        -- @param value [int] PlayMode.PlayAfterSynth, PlayMode.PlayWithSynth, またはPlayMode.Offのいずれかを指定します
        -- @return [void]
        function this:setPlayMode( value )
            if( self.MetaText == nil ) return;
            if( self.common == nil )then
                self.common = luavsq.Common.new( "Miku", 128, 128, 128, luavsq.DynamicsModeEnum.Expert, value );
                return;
            end
            if( value == luavsq.PlayModeEnum.Off )then
                if( self.common.playMode ~= luavsq.PlayModeEnum.Off )then
                    self.common.lastPlayMode = self.common.playMode;
                end
            else
                self.common.lastPlayMode = value;
            end
            self.common.playMode = value;
        end]]

        --[[
        -- このトラックがレンダリングされるかどうかを取得します．
        --
        -- @return [bool]
        function this:isTrackOn()
            if( self.MetaText == nil ) return true;
            if( self.common == nil ) return true;
            return self.common.playMode ~= luavsq.PlayModeEnum.Off;
        end]]

        --[[
        -- このトラックがレンダリングされるかどうかを設定します，
        --
        -- @param value [bool]
        function this:setTrackOn( value )
            if( self.MetaText == nil ) return;
            if( self.common == nil )then
                self.common = luavsq.Common.new( "Miku", 128, 128, 128, luavsq.DynamicsModeEnum.Expert, value ? luavsq.PlayModeEnum.PlayWithSynth : luavsq.PlayModeEnum.Off );
            end
            if( value )then
                if( self.common.lastPlayMode ~= luavsq.PlayModeEnum.PlayAfterSynth and
                     self.common.lastPlayMode ~= luavsq.PlayModeEnum.PlayWithSynth )then
                    self.common.lastPlayMode = luavsq.PlayModeEnum.PlayWithSynth;
                end
                self.common.playMode = self.common.lastPlayMode;
            else
                if( self.common.playMode == luavsq.PlayModeEnum.PlayAfterSynth or
                     self.common.playMode == luavsq.PlayModeEnum.PlayWithSynth )then
                    self.common.lastPlayMode = self.common.playMode;
                end
                self.common.playMode = luavsq.PlayModeEnum.Off;
            end
        end]]

        ---
        -- このトラックの名前を取得します．
        --
        -- @return [string]
        function this:getName()
            if( self.common == nil )then
                return "Master Track";
            else
                return self.common.name;
            end
        end

        ---
        -- このトラックの名前を設定します．
        --
        -- @param value [string]
        function this:setName( value )
            if( self.common ~= nil )then
                self.common.name = value;
            end
        end

        --[[
        -- このトラックの，指定したゲートタイムにおけるピッチベンドを取得します．単位はCentです．
        --
        -- @param clock [int] ピッチベンドを取得するゲートタイム
        -- @return [double]
        function this:getPitchAt( clock )
            local inv2_13 = 1.0 / 8192.0;
            local pit = self.PIT.getValue( clock );
            local pbs = self.PBS.getValue( clock );
            return pit * pbs * inv2_13 * 100.0;
        end]]

        --[[
        -- クレッシェンド，デクレッシェンド，および強弱記号をダイナミクスカーブに反映させます．
        -- この操作によって，ダイナミクスカーブに設定されたデータは全て削除されます．
        -- @return [void]
        function this:reflectDynamics()
            local dyn = self.getCurve( "dyn" );
            dyn.clear();
            local itr;
            for itr = self.getDynamicsEventIterator(); itr.hasNext();
                local item = itr.next();
                local handle = item.id.IconDynamicsHandle;
                if( handle == nil )then
                    continue;
                end
                local clock = item.Clock;
                local length = item.id.getLength();

                if( handle.isDynaffType() )then
                    -- 強弱記号
                    dyn.add( clock, handle.getStartDyn() );
                else
                    -- クレッシェンド，デクレッシェンド
                    local start_dyn = dyn.getValue( clock );

                    -- 範囲内のアイテムを削除
                    local count = dyn.size();
                    local i;
                    for i = count - 1; i >= 0; i--
                        local c = dyn.getKeyClock( i );
                        if( clock <= c and c <= clock + length )then
                            dyn.removeElementAt( i );
                        elseif( c < clock )then
                            break;
                        end
                    end

                    local bplist = handle.getDynBP();
                    if( bplist == nil or (bplist ~= nil and bplist.size() <= 0) )then
                        -- カーブデータが無い場合
                        local a = 0.0;
                        if( length > 0 )then
                            a = (handle.getEndDyn() - handle.getStartDyn()) / length;
                        end
                        local last_val = start_dyn;
                        local i;
                        for i = clock; i < clock + length; i++
                            local val = start_dyn + org.kbinani.PortUtil.castToInt( a * (i - clock) );
                            if( val < dyn.getMinimum() )then
                                val = dyn.getMinimum();
                            elseif( dyn.getMaximum() < val )then
                                val = dyn.getMaximum();
                            end
                            if( last_val ~= val )then
                                dyn.add( i, val );
                                last_val = val;
                            end
                        end
                    else
                        -- カーブデータがある場合
                        local last_val = handle.getStartDyn();
                        local last_clock = clock;
                        local bpnum = bplist:size();
                        local last = start_dyn;

                        -- bplistに指定されている分のデータ点を追加
                        local i;
                        for i = 0; i < bpnum; i++
                            local point = bplist.getElement( i );
                            local pointClock = clock + org.kbinani.PortUtil.castToInt( length * point.X );
                            if( pointClock <= last_clock )then
                                continue;
                            end
                            local pointValue = point.Y;
                            local a = (pointValue - last_val) / (pointClock - last_clock);
                            local j;
                            for j = last_clock; j <= pointClock; j++
                                local val = start_dyn + org.kbinani.PortUtil.castToInt( (j - last_clock) * a );
                                if( val < dyn.getMinimum() )then
                                    val = dyn.getMinimum();
                                elseif( dyn.getMaximum() < val )then
                                    val = dyn.getMaximum();
                                end
                                if( val ~= last )then
                                    dyn.add( j, val );
                                    last = val;
                                end
                            end
                            last_val = point.Y;
                            last_clock = pointClock;
                        end

                        -- bplistの末尾から，clock => clock + lengthまでのデータ点を追加
                        local last2 = last;
                        if( last_clock < clock + length )then
                            local a = (handle.getEndDyn() - last_val) / (clock + length - last_clock);
                            local j;
                            for j = last_clock; j < clock + length; j++
                                local val = last2 + org.kbinani.PortUtil.castToInt( (j - last_clock) * a );
                                if( val < dyn.getMinimum() )then
                                    val = dyn.getMinimum();
                                elseif( dyn.getMaximum() < val )then
                                    val = dyn.getMaximum();
                                end
                                if( val ~= last )then
                                    dyn.add( j, val );
                                    last = val;
                                end
                            end
                        end
                    end
                end
            end
        end]]

        --[[
        -- 指定したゲートタイムにおいて、歌唱を担当している歌手のVsqEventを取得します．
        --
        -- @param clock [int]
        -- @return [VsqEvent]
        function this:getSingerEventAt( clock )
            local last = nil;
            local itr;
            for itr = self.getSingerEventIterator(); itr.hasNext();
                local item = itr.next();
                if( clock < item.Clock )then
                    return last;
                end
                last = item;
            end
            return last;
        end]]

        --[[
        -- このトラックに設定されているイベントを，ゲートタイム順に並べ替えます．
        --
        -- @reutrn [void]
        function this:sortEvent()
            self.events:sort();
        end]]

        ---
        -- 歌手変更イベントを，曲の先頭から順に返すIteratorを取得します．
        --
        -- @return [SingerEventIterator]
        function this:getSingerEventIterator()
            return luavsq.Track.SingerEventIterator.new( self.events );
        end

        ---
        -- 音符イベントを，曲の先頭から順に返すIteratorを取得します．
        --
        -- @return [NoteEventIterator]
        function this:getNoteEventIterator()
            if( self.events == nil )then
                return luavsq.Track.NoteEventIterator.new( luavsq.EventList.new() );
            else
                return luavsq.Track.NoteEventIterator.new( self.events );
            end
        end

        ---
        -- クレッシェンド，デクレッシェンド，および強弱記号を表すイベントを，曲の先頭から順に返すIteratorを取得します．
        --
        -- @return [DynamicsEventIterator]
        function this:getDynamicsEventIterator()
            if( self.events == nil )then
                return luavsq.Track.DynamicsEventIterator.new( luavsq.EventList.new() );
            else
                return luavsq.Track.DynamicsEventIterator.new( self.events );
            end
        end

        function this:printMetaText( ... )
            local arguments = { ... };
            if( #arguments == 3 )then
                self:_printMetaTextCore( arguments[1], arguments[2], arguments[3], false );
            elseif( #arguments == 4 )then
                self:_printMetaTextCore( arguments[1], arguments[2], arguments[3], arguments[4] );
            end
        end

        ---
        -- このトラックのメタテキストをストリームに出力します．
        --
        -- @param sw [ITextWriter]
        -- @param eos [int]
        -- @param start [int]
        -- @param print_pitch [bool]
        -- @return [void]
        function this:_printMetaTextCore( sw, eos, start, print_pitch )
            if( self.common ~= nil )then
                self.common:write( sw );
            end
            if( self.master ~= nil )then
                self.master:write( sw );
            end
            if( self.mixer ~= nil )then
                self.mixer:write( sw );
            end
            local handle = self.events:write( sw, eos );
            local itr = self.events:iterator()
            while( itr:hasNext() )do
                local item = itr:next();
                item:write( sw );
            end
            local i;
            for i = 1, #handle, 1 do
                handle[i]:write( sw );
            end
            local version = self.common.version;
            if( self.pit:size() > 0 )then
                self.pit:print( sw, start, "[PitchBendBPList]" );
            end
            if( self.pbs:size() > 0 )then
                self.pbs:print( sw, start, "[PitchBendSensBPList]" );
            end
            if( self.dyn:size() > 0 )then
                self.dyn:print( sw, start, "[DynamicsBPList]" );
            end
            if( self.bre:size() > 0 )then
                self.bre:print( sw, start, "[EpRResidualBPList]" );
            end
            if( self.bri:size() > 0 )then
                self.bri:print( sw, start, "[EpRESlopeBPList]" );
            end
            if( self.cle:size() > 0 )then
                self.cle:print( sw, start, "[EpRESlopeDepthBPList]" );
            end
            if( version:sub( 1, 4 ) == "DSB2" )then
                if( self.harmonics:size() > 0 )then
                    self.harmonics:print( sw, start, "[EpRSineBPList]" );
                end
                if( self.fx2depth:size() > 0 )then
                    self.fx2depth:print( sw, start, "[VibTremDepthBPList]" );
                end

                if( self.reso1FreqBPList:size() > 0 )then
                    self.reso1FreqBPList:print( sw, start, "[Reso1FreqBPList]" );
                end
                if( self.reso2FreqBPList:size() > 0 )then
                    self.reso2FreqBPList:print( sw, start, "[Reso2FreqBPList]" );
                end
                if( self.reso3FreqBPList:size() > 0 )then
                    self.reso3FreqBPList:print( sw, start, "[Reso3FreqBPList]" );
                end
                if( self.reso4FreqBPList:size() > 0 )then
                    self.reso4FreqBPList:print( sw, start, "[Reso4FreqBPList]" );
                end

                if( self.reso1BWBPList:size() > 0 )then
                    self.reso1BWBPList:print( sw, start, "[Reso1BWBPList]" );
                end
                if( self.reso2BWBPList:size() > 0 )then
                    self.reso2BWBPList:print( sw, start, "[Reso2BWBPList]" );
                end
                if( self.reso3BWBPList:size() > 0 )then
                    self.reso3BWBPList:print( sw, start, "[Reso3BWBPList]" );
                end
                if( self.reso4BWBPList:size() > 0 )then
                    self.reso4BWBPList:print( sw, start, "[Reso4BWBPList]" );
                end

                if( self.reso1AmpBPList:size() > 0 )then
                    self.reso1AmpBPList:print( sw, start, "[Reso1AmpBPList]" );
                end
                if( self.reso2AmpBPList:size() > 0 )then
                    self.reso2AmpBPList:print( sw, start, "[Reso2AmpBPList]" );
                end
                if( self.reso3AmpBPList:size() > 0 )then
                    self.reso3AmpBPList:print( sw, start, "[Reso3AmpBPList]" );
                end
                if( self.reso4AmpBPList:size() > 0 )then
                    self.reso4AmpBPList:print( sw, start, "[Reso4AmpBPList]" );
                end
            end

            if( self.gen:size() > 0 )then
                self.gen:print( sw, start, "[GenderFactorBPList]" );
            end
            if( self.por:size() > 0 )then
                self.por:print( sw, start, "[PortamentoTimingBPList]" );
            end
            if( version:sub( 1, 4 ) == "DSB3" )then
                if( self.ope:size() > 0 )then
                    self.ope:print( sw, start, "[OpeningBPList]" );
                end
            end
        end

        --[[
        -- レンダラーを変更します
        --
        -- @param new_renderer [string]
        -- @param singers [Array<VsqID>]
        function this:changeRenderer( new_renderer, singers )
            local default_id = nil;
            local singers_size = #singers;
            if( singers_size <= 0 )then
                default_id = luavsq.Id.new();
                default_id.type = luavsq.IdTypeEnum.Singer;
                local singer_handle = luavsq.SingerHandle.new();
                singer_handle.IconID = "$0701" + org.kbinani.PortUtil.sprintf( "%04X", 0 );
                singer_handle.ids = "Unknown";
                singer_handle.Index = 0;
                singer_handle.Language = 0;
                singer_handle.setLength( 1 );
                singer_handle.Original = 0;
                singer_handle.Program = 0;
                singer_handle.Caption = "";
                default_id.singerHandle = singer_handle;
            else
                default_id = singers[0];
            end

            local itr;
            for ( itr = self.getSingerEventIterator(); itr.hasNext();
                local ve = itr.next();
                local singer_handle = ve.id.IconHandle;
                local program = singer_handle.Program;
                local found = false;
                local i;
                for i = 0; i < singers_size; i++
                    local id = singers[i];
                    if( program == singer_handle.Program )then
                        ve.id = id:clone();
                        found = true;
                        break;
                    end
                end
                if( !found )then
                    local add = default_id:clone();
                    add.IconHandle.Program = program;
                    ve.id = add;
                end
            end
            self.common.Version = new_renderer;
        end]]

        ---
        -- このトラックが保持している，指定されたカーブのBPListを取得します
        --
        -- @param curve [string]
        function this:getCurve( curve )
            local search = curve:lower();
            if( search == "bre" )then
                return self.bre;
            elseif( search == "bri" )then
                return self.bri;
            elseif( search == "cle" )then
                return self.cle;
            elseif( search == "dyn" )then
                return self.dyn;
            elseif( search == "gen" )then
                return self.gen;
            elseif( search == "ope" )then
                return self.ope;
            elseif( search == "pbs" )then
                return self.pbs;
            elseif( search == "pit" )then
                return self.pit;
            elseif( search == "por" )then
                return self.por;
            elseif( search == "harmonics" )then
                return self.harmonics;
            elseif( search == "fx2depth" )then
                return self.fx2depth;
            elseif( search == "reso1amp" )then
                return self.reso1AmpBPList;
            elseif( search == "reso1bw" )then
                return self.reso1BWBPList;
            elseif( search == "reso1freq" )then
                return self.reso1FreqBPList;
            elseif( search == "reso2amp" )then
                return self.reso2AmpBPList;
            elseif( search == "reso2bw" )then
                return self.reso2BWBPList;
            elseif( search == "reso2freq" )then
                return self.reso2FreqBPList;
            elseif( search == "reso3amp" )then
                return self.reso3AmpBPList;
            elseif( search == "reso3bw" )then
                return self.reso3BWBPList;
            elseif( search == "reso3freq" )then
                return self.reso3FreqBPList;
            elseif( search == "reso4amp" )then
                return self.reso4AmpBPList;
            elseif( search == "reso4bw" )then
                return self.reso4BWBPList;
            elseif( search == "reso4freq" )then
                return self.reso4FreqBPList;
            elseif( search == "pitch" )then
                return self.pitch;
            else
                return nil;
            end
        end

        ---
        -- @param curve [string]
        -- @param value [VsqBPList]
        -- @return [void]
        function this:setCurve( curve, value )
            local search = curve:lower();
            if( search == "bre" )then
                self.bre = value;
            elseif( search == "bri" )then
                self.bri = value;
            elseif( search == "cle" )then
                self.cle = value;
            elseif( search == "dyn" )then
                self.dyn = value;
            elseif( search == "gen" )then
                self.gen = value;
            elseif( search == "ope" )then
                self.ope = value;
            elseif( search == "pbs" )then
                self.pbs = value;
            elseif( search == "pit" )then
                self.pit = value;
            elseif( search == "por" )then
                self.por = value;
            elseif( search == "harmonics" )then
                self.harmonics = value;
            elseif( search == "fx2depth" )then
                self.fx2depth = value;
            elseif( search == "reso1amp" )then
                self.reso1AmpBPList = value;
            elseif( search == "reso1bw" )then
                self.reso1BWBPList = value;
            elseif( search == "reso1freq" )then
                self.reso1FreqBPList = value;
            elseif( search == "reso2amp" )then
                self.reso2AmpBPList = value;
            elseif( search == "reso2bw" )then
                self.reso2BWBPList = value;
            elseif( search == "reso2freq" )then
                self.reso2FreqBPList = value;
            elseif( search == "reso3amp" )then
                self.reso3AmpBPList = value;
            elseif( search == "reso3bw" )then
                self.reso3BWBPList = value;
            elseif( search == "reso3freq" )then
                self.reso3FreqBPList = value;
            elseif( search == "reso4amp" )then
                self.reso4AmpBPList = value;
            elseif( search == "reso4bw" )then
                self.reso4BWBPList = value;
            elseif( search == "reso4freq" )then
                self.reso4FreqBPList = value;
            elseif( search == "pitch" )then
                self.pitch = value;
            end
        end

        ---
        -- @return [int]
        function this:getEventCount()
            return self.events:size();
        end

        ---
        -- @param index [int]
        -- @return [VsqEvent]
        function this:getEvent( index )
            return self.events:getElement( index );
        end

        ---
        -- @param index [int]
        -- @param item [VsqEvent]
        -- @return [void]
        function this:setEvent( index, item )
            self.events:setElement( index, item );
        end

        ---
        -- @param internal_id [int]
        -- @return [VsqEvent]
        function this:findEventFromId( internal_id )
            return self.events:findFromId( internal_id );
        end

        ---
        -- @param internal_id [int]
        -- @return [int]
        function this:findEventIndexFromId( internal_id )
            return self.events:findIndexFromId( internal_id );
        end

        function this:addEvent( ... )
            local arguments = { ... };
            if( #arguments == 1 )then
                return self:_addEvent_1( arguments[1] );
            elseif( #arguments == 2 )then
                return self:_addEvent_2( arguments[1], arguments[2] );
            end
        end

        ---
        -- @param item [VsqEvent]
        -- @return [int]
        function this:_addEvent_1( item )
            return self.events:add( item );
        end

        ---
        -- @param item [VsqEvent]
        -- @param internal_id [int:
        -- @return [void]
        function this:_addEvent_2( item, internal_id )
            return self.events:add( item, internal_id );
        end

        ---
        -- @return [EventIterator]
        function this:getEventIterator()
            return self.events:iterator();
        end

        ---
        -- @param index [int]
        -- @return [void]
        function this:removeEvent( index )
            self.events:removeAt( index );
        end

        ---
        -- このインスタンスのコピーを作成します
        --
        -- @return [object]
        function this:clone()
            local res = luavsq.Track.new();
            res:setName( self:getName() );

            if( self.common ~= nil )then
                res.common = self.common:clone();
            end
            if( self.master ~= nil )then
                res.master = self.master:clone();
            end
            if( self.mixer ~= nil )then
                res.mixer = self.mixer:clone();
            end
            if( self.events ~= nil )then
                res.events = luavsq.EventList.new();
                local i;
                for i = 0, self.events:size() - 1, 1 do
                    local item = self.events:getElement( i );
                    res.events:add( item:clone(), item.internalID );
                end
            end
            if( self.pit ~= nil )then
                res.pit = self.pit:clone();
            end
            if( self.pbs ~= nil )then
                res.pbs = self.pbs:clone();
            end
            if( self.dyn ~= nil )then
                res.dyn = self.dyn:clone();
            end
            if( self.bre ~= nil )then
                res.bre = self.bre:clone();
            end
            if( self.bri ~= nil )then
                res.bri = self.bri:clone();
            end
            if( self.cle ~= nil )then
                res.cle = self.cle:clone();
            end
            if( self.reso1FreqBPList ~= nil )then
                res.reso1FreqBPList = self.reso1FreqBPList:clone();
            end
            if( self.reso2FreqBPList ~= nil )then
                res.reso2FreqBPList = self.reso2FreqBPList:clone();
            end
            if( self.reso3FreqBPList ~= nil )then
                res.reso3FreqBPList = self.reso3FreqBPList:clone();
            end
            if( self.reso4FreqBPList ~= nil )then
                res.reso4FreqBPList = self.reso4FreqBPList:clone();
            end
            if( self.reso1BWBPList ~= nil )then
                res.reso1BWBPList = self.reso1BWBPList:clone();
            end
            if( self.reso2BWBPList ~= nil )then
                res.reso2BWBPList = self.reso2BWBPList:clone();
            end
            if( self.reso3BWBPList ~= nil )then
                res.reso3BWBPList = self.reso3BWBPList:clone();
            end
            if( self.reso4BWBPList ~= nil )then
                res.reso4BWBPList = self.reso4BWBPList:clone();
            end
            if( self.reso1AmpBPList ~= nil )then
                res.reso1AmpBPList = self.reso1AmpBPList:clone();
            end
            if( self.reso2AmpBPList ~= nil )then
                res.reso2AmpBPList = self.reso2AmpBPList:clone();
            end
            if( self.reso3AmpBPList ~= nil )then
                res.reso3AmpBPList = self.reso3AmpBPList:clone();
            end
            if( self.reso4AmpBPList ~= nil )then
                res.reso4AmpBPList = self.reso4AmpBPList:clone();
            end
            if( self.harmonics ~= nil )then
                res.harmonics = self.harmonics:clone();
            end
            if( self.fx2depth ~= nil )then
                res.fx2depth = self.fx2depth:clone();
            end
            if( self.gen ~= nil )then
                res.gen = self.gen:clone();
            end
            if( self.por ~= nil )then
                res.por = self.por:clone();
            end
            if( self.ope ~= nil )then
                res.ope = self.ope:clone();
            end
            if( self.pitch ~= nil )then
                res.pitch = self.pitch:clone();
            end
            res.tag = self.tag;
            return res;
        end

        --[[
        -- 歌詞の文字数を調べます
        -- @return [int]
        function this:getLyricLength()
            local counter = 0;
            local i;
            for i = 0; i < self.events:size(); i++
                if( self.events:getElement( i ).id.type == luavsq.IdTypeEnum.Anote )then
                    counter++;
                end
            end
            return counter;
        end]]

        if( #arguments == 0 )then
            this:_init_0();
        elseif( #arguments == 2 )then
            if( type( arguments[1] ) == "string" )then
                this:_init_2a( arguments[1], arguments[2] );
            else
                this:_init_2b( arguments[1], arguments[2] );
            end
        end

        return this;
    end

end
