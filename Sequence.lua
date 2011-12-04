--[[
  Sequence.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local table = table;
local math = math;
local string = string;
local tonumber = tonumber;
local print = print;

module( "luavsq" );

---
-- VSQ ファイルのシーケンスを保持するクラス
-- @class table
-- @name Sequence
-- @field track (<a href="../files/List.html">List</a>&lt;<a href="../files/Track.html">Track</a>&gt;) トラックのリスト。最初のトラックは MasterTrack であり、通常の音符が格納されるトラックはインデックス 1 以降となる
-- @field tempoTable (<a href="../files/TempoTable.html">TempoTable</a>) テンポ情報を保持したテーブル
-- @field timesigTable (<a href="../files/TimesigTable.html">TimesigTable</a>) 拍子情報を保持したテーブル
-- @field master (<a href="../files/Master.html">Master</a>) プリメジャーを保持する
-- @field mixer (<a href="../files/Mixer.html">Mixer</a>) ミキサー情報
-- @field tag (?) シーケンスに付属するタグ情報
Sequence = {};

Sequence.baseTempo = 500000;
Sequence._MTRK = { 0x4d, 0x54, 0x72, 0x6b };
Sequence._MTHD = { 0x4d, 0x54, 0x68, 0x64 };
Sequence._MASTER_TRACK = { 0x4D, 0x61, 0x73, 0x74, 0x65, 0x72, 0x20, 0x54, 0x72, 0x61, 0x63, 0x6B };
Sequence._CURVES = { "VEL", "DYN", "BRE", "BRI", "CLE", "OPE", "GEN", "POR", "PIT", "PBS" };

--
-- VOCALOID の NRPN を出力するかどうか
-- @todo NRPN 出力関連の メソッドのテストが書けたらデフォルトで true にする
Sequence._WRITE_NRPN = false;

--
-- 初期化を行う
-- @return (<a href="../files/Sequence.html">Sequence</a>)
function Sequence.new( ... )
    local this = {};
    local arguments = { ... };

    this._tickPerQuarter = 480;

    ---
    -- [Vector<VsqTrack>]
    -- トラックのリスト．最初のトラックはMasterTrackであり，通常の音符が格納されるトラックはインデックス1以降となる
    this.track = nil;
    ---
    -- [TempoVector]
    -- テンポ情報を保持したテーブル
    this.tempoTable = nil;
    ---
    -- [Vector<TimeSigTableEntry>]
    this.timesigTable = nil;
    ---
    -- 曲の長さを取得します。(クロック(4分音符は480クロック))
    this._totalClocks = 0;
    ---
    -- [VsqMaster]
    this.master = nil;  -- VsqMaster, VsqMixerは通常，最初の非Master Trackに記述されるが，可搬性のため，
    ---
    -- [VsqMixer]
    this.mixer = nil;    -- ここではVsqFileに直属するものとして取り扱う．
    this.tag = nil;

    ---
    -- 初期化を行う
    -- @param singer (string) 歌手名
    -- @param preMeasure (integer) 小節単位のプリメジャー
    -- @param numerator (integer) 拍子の分子の値
    -- @param denominator (integer) 拍子の分母の値
    -- @param tempo (integer) テンポ値。四分音符の長さのマイクロ秒単位の長さ
    -- @return (<a href="../files/Sequence.html">Sequence</a>)
    -- @name <i>new</i>
    function this:_init_5( singer, preMeasure, numerator, denominator, tempo )
        self._totalClocks = preMeasure * 480 * 4 / denominator * numerator;

        self.track = List.new();--Array.new();
        self.track:push( Track.new() );
        self.track:push( Track.new( "Voice1", singer ) );
        self.master = Master.new( preMeasure );
        self.mixer = Mixer.new( 0, 0, 0, 0 );
        self.mixer.slave[1] = MixerItem.new( 0, 0, 0, 0 );
        self.timesigTable = TimesigTable.new();
        self.timesigTable:push( TimesigTableItem.new( numerator, denominator, 0 ) );
        self.tempoTable = TempoTable.new();
        self.tempoTable:push( TempoTableItem.new( 0, tempo ) );
    end

    ---
    -- コピーを作成する
    -- @return (<a href="../files/Sequence.html">Sequence</a>) オブジェクトのコピー
    -- @name clone
    function this:clone()
        local ret = Sequence.new();
        ret.track = List.new();
        local i;
        for i = 0, self.track:size() - 1, 1 do
            ret.track:push( self.track[i]:clone() );
        end

        ret.tempoTable = TempoTable.new();
        for i = 0, self.tempoTable:size() - 1, 1 do
            ret.tempoTable:push( self.tempoTable:get( i ):clone() );
        end

        ret.timesigTable = TimesigTable.new();
        for i = 0, self.timesigTable:size() - 1, 1 do
            ret.timesigTable:push( self.timesigTable:get( i ):clone() );
        end
        ret._totalClocks = self._totalClocks;
        ret.master = self.master:clone();
        ret.mixer = self.mixer:clone();
        return ret;
    end

    ---
    -- テンポが一つも指定されていない場合の、基本テンポ値を取得する
    -- @return (integer) テンポ値。四分音符の長さのマイクロ秒単位の長さ
    -- @name getBaseTempo
    function this:getBaseTempo()
        return Sequence.baseTempo;
    end

    ---
    -- Tick 単位の曲の長さを取得する
    -- シーケンスに変更を加えた場合、updateTotalClocks を読んでからこのメソッドを呼ぶこと
    -- @return (integer) Tick 単位の曲の長さ
    -- @name getTotalClocks
    function this:getTotalClocks()
        return self._totalClocks;
    end

    ---
    -- プリメジャー値を取得する
    -- @return (integer) 小節単位のプリメジャー長さ
    -- @name getPreMeasure
    function this:getPreMeasure()
        return self.master.preMeasure;
    end

    ---
    -- Tick 単位のプリメジャー部分の長さを取得する
    -- @return (integer) Tick 単位のプリメジャー長さ
    -- @name getPreMeasureClocks
    function this:getPreMeasureClocks()
        return self:_calculatePreMeasureInClock();
    end

    --
    -- プリメジャーの Tick 単位の長さを計算する
    -- @access private
    -- @return (integer) Tick 単位のプリメジャー長さ
    function this:_calculatePreMeasureInClock()
        local pre_measure = self.master.preMeasure;
        local last_bar_count = self.timesigTable:get( 0 ).barCount;
        local last_clock = self.timesigTable:get( 0 ):getTick();
        local last_denominator = self.timesigTable:get( 0 ).denominator;
        local last_numerator = self.timesigTable:get( 0 ).numerator;
        for i = 1, self.timesigTable:size() - 1, 1 do
            if( self.timesigTable:get( i ).barCount >= pre_measure )then
                break;
            else
                last_bar_count = self.timesigTable:get( i ).barCount;
                last_clock = self.timesigTable:get( i ):getTick();
                last_denominator = self.timesigTable:get( i ).denominator;
                last_numerator = self.timesigTable:get( i ).numerator;
            end
        end

        local remained = pre_measure - last_bar_count;--プリメジャーの終わりまでの残り小節数
        return last_clock + math.floor( remained * last_numerator * 480 * 4 / last_denominator );
    end

    ---
    -- 四分音符あたりの Tick 数を取得する
    -- @return (integer) 四分音符一つあたりの Tick 数
    -- @name getTickPerQuarter
    function this:getTickPerQuarter()
        return self._tickPerQuarter;
    end

    ---
    -- totalClock の値を更新する
    -- @name updateTotalClocks
    function this:updateTotalClocks()
        local max = self:getPreMeasureClocks();
        for i = 1, self.track:size() - 1, 1 do
            local track = self.track:get( i );
            local numEvents = track.events:size();
            if( numEvents > 0 )then
                local lastItem = track.events:get( numEvents - 1 );
                max = math.max( max, lastItem.clock + lastItem:getLength() );
            end
            local j;
            for j = 1, #Sequence._CURVES, 1 do
                local vct = Sequence._CURVES[j];
                local list = track:getCurve( vct );
                if( list ~= nil )then
                    local keys = list:size();
                    if( keys > 0 )then
                        local last_key = list:getKeyClock( keys - 1 );
                        max = math.max( max, last_key );
                    end
                end
            end
        end
        self._totalClocks = max;
    end

    --
    -- メタテキストイベントを作成する
    -- @return (table&lt;<a href="../files/MidiEvent.html">MidiEvent</a>&gt;) メタテキストを格納した MidiEvent の配列
    -- @name <i>_generateMetaTextEvent</i>
    function this:_generateMetaTextEvent( ... )
        local arguments = { ... };
        if( #arguments == 2 )then
            return self:_generateMetaTextEvent_2( arguments[1], arguments[2] );
        elseif( #arguments == 3 )then
            return self:_generateMetaTextEvent_3( arguments[1], arguments[2], arguments[3] );
        elseif( #arguments == 4 )then
            return self:_generateMetaTextEvent_4( arguments[1], arguments[2], arguments[3], arguments[4] );
        end
    end

    --
    -- メタテキストイベントを作成する
    -- @param track (integer) トラック番号
    -- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
    -- @return (table&lt;<a href="../files/MidiEvent.html">MidiEvent</a>&gt;) メタテキストを格納した <a href="../files/MidiEvent.html">MidiEvent</a> の配列
    -- @name _generateMetaTextEvent_2
    function this:_generateMetaTextEvent_2( track, encoding )
        self:_generateMetaTextEvent_4( track, encoding, self:_calculatePreMeasureInClock(), false );
    end

    --
    -- メタテキストイベントを作成する
    -- @param track (integer) トラック番号
    -- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
    -- @param startClock (integer) イベント作成の開始位置
    -- @return (table&lt;<a href="../files/MidiEvent.html">MidiEvent</a>&gt;) メタテキストを格納した <a href="../files/MidiEvent.html">MidiEvent</a> の配列
    -- @name _generateMetaTextEvent_3
    function this:_generateMetaTextEvent_3( track, encoding, startClock )
        self:_generateMetaTextEvent_4( track, encoding, startClock, false );
    end

    --
    -- メタテキストイベントを作成する
    -- @param track (integer) トラック番号
    -- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
    -- @param startClock (integer) イベント作成の開始位置
    -- @param printPitch (boolean) pitch を含めて出力するかどうか(現在は false 固定で、引数は無視される)
    -- @return (table&lt;<a href="../files/MidiEvent.html">MidiEvent</a>&gt;) メタテキストを格納した MidiEvent の配列
    -- @name _generateMetaTextEvent_4
    function this:_generateMetaTextEvent_4( track, encoding, startClock, printPitch )
        local _NL = string.char( 0x0a );
        local ret = {};
        local sr = TextStream.new();
        self.track:get( track ):printMetaText( sr, self._totalClocks + 120, startClock, printPitch );
        sr:setPointer( -1 );
        local line_count = -1;
        local tmp = "";
        if( sr:ready() )then
            local buffer = {};
            local first = true;
            while( sr:ready() )do
                if( first )then
                    tmp = sr:readLine();
                    first = false;
                else
                    tmp = _NL .. sr:readLine();
                end
                local line = CP932Converter.convertFromUTF8( tmp );
                local linebytes = Util.stringToArray( line );
                Sequence._array_add_all( buffer, linebytes );
                local prefix = Sequence._getLinePrefixBytes( line_count + 1 );
                while( #prefix + #buffer >= 127 )do
                    line_count = line_count + 1;
                    local prefix = Sequence._getLinePrefixBytes( line_count );
                    local add = MidiEvent.new();
                    add.clock = 0;
                    add.firstByte = 0xff;
                    add.data = {};--new int[128];
                    add.data[1] = 0x01;
                    local remain = 127;
                    local i;
                    for i = 1, #prefix, 1 do
                        add.data[i + 1] = prefix[i];
                    end
                    for i = #prefix + 1, remain, 1 do
                        local d = buffer[1];
                        add.data[i + 1] = d;
                        table.remove( buffer, 1 );
                    end
                    table.insert( ret, add );
                    prefix = Sequence._getLinePrefixBytes( line_count + 1 );
                end
            end
            if( #buffer > 0 )then
                local prefix = Sequence._getLinePrefixBytes( line_count + 1 );
                while( #prefix + #buffer >= 127 )do
                    line_count = line_count + 1;
                    prefix = Sequence._getLinePrefixBytes( line_count );
                    local add = MidiEvent.new();
                    add.clock = 0;
                    add.firstByte = 0xff;
                    add.data = {};--new int[128];
                    add.data[1] = 0x01;
                    local remain = 127;
                    local i;
                    for i = 1, #prefix, 1 do
                        add.data[i + 1] = prefix[i];
                    end
                    for i = #prefix + 1, remain, 1 do
                        add.data[i + 1] = buffer[1];
                        table.remove( buffer, 1 );
                    end
                    table.insert( ret, add );
                    prefix = Sequence._getLinePrefixBytes( line_count + 1 );
                end
                if( #buffer > 0 )then
                    line_count = line_count + 1;
                    local prefix = Sequence._getLinePrefixBytes( line_count );
                    local add = MidiEvent.new();
                    add.clock = 0;
                    add.firstByte = 0xff;
                    local remain = #prefix + #buffer;
                    add.data = {};--new int[remain + 1];
                    add.data[1] = 0x01;
                    local i;
                    for i = 1, #prefix, 1 do
                        add.data[i + 1] = prefix[i];
                    end
                    for i = #prefix + 1, remain, 1 do
                        add.data[i + 1] = buffer[1];
                        table.remove( buffer, 1 );
                    end
                    table.insert( ret, add );
                end
            end
        end

        return ret;
    end

    --
    -- 指定した時刻における、プリセンド込の時刻と、ディレイを取得する
    -- @param clock (integer) Tick 単位の時刻
    -- @param msPreSend (integer) ミリ秒単位のプリセンド時間
    -- @return (integer) プリセンド分のクロックを引いた Tick 単位の時刻
    -- @return (integer) ミリ秒単位のプリセンド時間
    -- @name _getActualClockAndDelay
    function this:_getActualClockAndDelay( clock, msPreSend )
        local clock_msec = self.tempoTable:getSecFromClock( clock ) * 1000.0;

        local actualClock;
        if( clock_msec - msPreSend <= 0 )then
            actualClock = 0;
        else
            local draft_clock_sec = (clock_msec - msPreSend) / 1000.0;
            actualClock = math.floor( self.tempoTable:getClockFromSec( draft_clock_sec ) );
        end
        local delay = math.floor( clock_msec - self.tempoTable:getSecFromClock( actualClock ) * 1000.0 );
        return actualClock, delay;
    end

--[[
        --
        -- 指定したクロックにおける、音符長さ(ゲートタイム単位)の最大値を調べます
        -- @param clock [int]
        -- @return [int]
        function this:getMaximumNoteLengthAt( clock )
            local secAtStart = self.tempoTable:getSecFromClock( clock );
            local secAtEnd = secAtStart + Id.MAX_NOTE_MILLISEC_LENGTH / 1000.0;
            local clockAtEnd = math.floor( self.tempoTable:getClockFromSec( secAtEnd ) - 1 );
            secAtEnd = self.tempoTable:getSecFromClock( clockAtEnd );
            while ( math.floor( secAtEnd * 1000.0 ) - math.floor( secAtStart * 1000.0 ) <= Id.MAX_NOTE_MILLISEC_LENGTH )do
                clockAtEnd = clockAtEnd + 1;
                secAtEnd = self.tempoTable:getSecFromClock( clockAtEnd );
            end
            clockAtEnd = clockAtEnd - 1;
            return clockAtEnd - clock;
        end
]]

    --
    -- ストリームに出力する
    function this:write( ... )
        local arguments = { ... };
        if( #arguments == 3 )then
            return self:_write_3( arguments[1], arguments[2], arguments[3] );
        elseif( #arguments == 4 )then
            return self:_write_4( arguments[1], arguments[2], arguments[3], arguments[4] );
        end
    end

    ---
    -- ストリームに出力する
    -- @param stream (?OutputStream) 出力先のストリーム
    -- @param msPreSend (integer) ミリ秒単位のプリセンドタイム
    -- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
    -- @name write<sup>1</sup>
    function this:_write_3( stream, msPreSend, encoding )
        self:_write_4( stream, msPreSend, encoding, false );
    end

    ---
    -- ストリームに出力する
    -- @param stream (?OutputStream) 出力先のストリーム
    -- @param msPreSend (integer) ミリ秒単位のプリセンドタイム
    -- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
    -- @param printPitch (boolean) pitch を含めて出力するかどうか(現在は false 固定で、引数は無視される)
    -- @name write<sup>2</sup>
    function this:_write_4( stream, msPreSend, encoding, printPitch )
        self:updateTotalClocks();
        local first_position;--チャンクの先頭のファイル位置

        -- ヘッダ
        --チャンクタイプ
        stream:write( Sequence._MTHD, 1, 4 );
        --データ長
        stream:write( 0x00 );
        stream:write( 0x00 );
        stream:write( 0x00 );
        stream:write( 0x06 );
        --フォーマット
        stream:write( 0x00 );
        stream:write( 0x01 );
        --トラック数
        Sequence._writeUnsignedShort( stream, self.track:size() );
        --時間単位
        stream:write( 0x01 );
        stream:write( 0xe0 );

        -- Master Track
        --チャンクタイプ
        stream:write( Sequence._MTRK, 1, 4 );
        --データ長。とりあえず0を入れておく
        stream:write( { 0x00, 0x00, 0x00, 0x00 }, 1, 4 );
        first_position = stream:getPointer();
        --トラック名
        MidiEvent.writeDeltaClock( stream, 0 );--デルタタイム
        stream:write( 0xff );--ステータスタイプ
        stream:write( 0x03 );--イベントタイプSequence/Track Name
        stream:write( #Sequence._MASTER_TRACK );--トラック名の文字数。これは固定
        stream:write( Sequence._MASTER_TRACK, 1, #Sequence._MASTER_TRACK );

        local events = {};
        local itr = self.timesigTable:iterator();
        while( itr:hasNext() )do
            local entry = itr:next();
            table.insert( events, MidiEvent.generateTimeSigEvent( entry:getTick(), entry.numerator, entry.denominator ) );
        end
        itr = self.tempoTable.iterator();
        while( itr:hasNext() )do
            local entry = itr:next();
            table.insert( events, MidiEvent.generateTempoChangeEvent( entry.clock, entry.tempo ) );
        end
        table.sort( events, MidiEvent.compare );
        local last = 0;
        local itr = List.fromTable( events ):iterator();
        while( itr:hasNext() )do
            local midiEvent = itr:next();
            MidiEvent.writeDeltaClock( stream, midiEvent.clock - last );
            midiEvent:writeData( stream );
            last = midiEvent.clock;
        end

        MidiEvent.writeDeltaClock( stream, 0 );
        stream:write( 0xff );
        stream:write( 0x2f );--イベントタイプEnd of Track
        stream:write( 0x00 );
        local pos = stream:getPointer();
        stream:seek( first_position - 4 );
        Sequence._writeUnsignedInt( stream, pos - first_position );
        stream:seek( pos );

        -- トラック
        local temp = self:clone();
        temp.track:get( 1 ).master = self.master:clone();
        temp.track:get( 1 ).mixer = self.mixer:clone();
        Sequence._printTrack( temp, 1, stream, msPreSend, encoding, printPitch );
        local count = self.track:size();
        local track;
        for track = 2, count - 1, 1 do
            Sequence._printTrack( self, track, stream, msPreSend, encoding, printPitch );
        end
    end

    if( #arguments == 1 )then
        this:_init_1( arguments[1] );
    elseif( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    elseif( #arguments == 5 )then
        this:_init_5( arguments[1], arguments[2], arguments[3], arguments[4], arguments[5] );
    end

    return this;
end

--
-- トラックをストリームに出力する
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) 出力するシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param stream (? extends OutputStream) 出力先のストリーム
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
-- @param printPitch (boolean) pitch を含めて出力するかどうか(現在は false 固定で、引数は無視される)
-- @name <i>_printTrack</i>
function Sequence._printTrack( sequence, track, stream, msPreSend, encoding, printPitch )
    local _NL = string.char( 0x0a );
    --ヘッダ
    stream:write( Sequence._MTRK, 1, 4 );
    --データ長。とりあえず0
    stream:write( { 0x00, 0x00, 0x00, 0x00 }, 1, 4 );
    local first_position = stream:getPointer();
    --トラック名
    MidiEvent.writeDeltaClock( stream, 0x00 );--デルタタイム
    stream:write( 0xff );--ステータスタイプ
    stream:write( 0x03 );--イベントタイプSequence/Track Name
    local seq_name = CP932Converter.convertFromUTF8( sequence.track:get( track ):getName() );--PortUtil.getEncodedByte( encoding, sequence.Track.get( track ).getName() );
    MidiEvent.writeDeltaClock( stream, #seq_name );--seq_nameの文字数
    stream:write( seq_name, 1, #seq_name );

    --Meta Textを準備
    local meta = sequence:_generateMetaTextEvent( track, encoding, 0, printPitch );
    local lastClock = 0;
    local i;
    for i = 1, #meta, 1 do
        MidiEvent.writeDeltaClock( stream, meta[i].clock - lastClock );
        meta[i]:writeData( stream );
        lastClock = meta[i].clock;
    end
    local maxClock = lastClock;

    if( Sequence._WRITE_NRPN )then
        lastClock = 0;
        -- @var data (table<NrpnEvent>)
        local data = Sequence.generateNRPN( sequence, track, msPreSend );
        -- @var nrpns (table<MidiEvent>)
        local nrpns = NrpnEvent.convert( data );
        for i = 1, #nrpns, 1 do
            local item = nrpns[i];
            MidiEvent.writeDeltaClock( stream, item.clock - lastClock );
            item:writeData( stream );
            lastClock = item.clock;
        end
        maxClock = math.max( maxClock, lastClock );
    end

    --トラックエンド
    lastClock = maxClock;
    local last_event = sequence.track:get( track ).events:get( sequence.track:get( track ).events:size() - 1 );
    maxClock = math.max( maxClock, last_event.clock + last_event:getLength() );
    local lastDeltaClock = maxClock - lastClock;
    if( lastDeltaClock < 0 )then
        lastDeltaClock = 0;
    end
    MidiEvent.writeDeltaClock( stream, lastDeltaClock );
    stream:write( 0xff );
    stream:write( 0x2f );
    stream:write( 0x00 );
    local pos = stream:getPointer();
    stream:seek( first_position - 4 );
    Sequence._writeUnsignedInt( stream, pos - first_position );
    stream:seek( pos );
end

--
-- トラックの Expression(DYN) の NRPN リストを作成する
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) 出力するシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table&lt;<a href="../files/NrpnEvent.html">NrpnEvent</a>&gt;) NrpnEvent の配列
-- @name <i>_generateExpressionNRPN</i>
function Sequence._generateExpressionNRPN( sequence, track, msPreSend )
    local ret = {};
    local dyn = sequence.track:get( track ):getCurve( "DYN" );
    local count = dyn:size();
    local i;
    local lastDelay = 0;
    for i = 0, count - 1, 1 do
        local clock = dyn:getKeyClock( i );
        local c, delay = sequence:_getActualClockAndDelay( clock, msPreSend );
        if( c >= 0 )then
            if( lastDelay ~= delay )then
                local delayMsb, delayLsb;
                delayMsb, delayLsb = Sequence._getMsbAndLsb( delay );
                local delayNrpn = NrpnEvent.new( c, MidiParameterEnum.CC_E_DELAY, delayMsb, delayLsb );
                table.insert( ret, delayNrpn );
            end
            lastDelay = delay;

            local add = NrpnEvent.new(
                c,
                MidiParameterEnum.CC_E_EXPRESSION,
                dyn:getValue( i )
            );
            table.insert( ret, add );
        end
    end
    return ret;
end

--[[
    --
    -- @param vsq [VsqFile]
    -- @param track [int]
    -- @param msPreSend [int]
    -- @return [VsqNrpn[] ]
    function Sequence.generateFx2DepthNRPN( vsq, track, msPreSend )
        local ret = {};--Array.new();--Vector<VsqNrpn>();
        local fx2depth = vsq.track:get( track ):getCurve( "fx2depth" );
        local count = fx2depth:size();
        local i;
        for i = 0, count - 1, do
            local clock = fx2depth:getKeyClock( i );
            local c = clock - vsq:getPresendClockAt( clock, msPreSend );
            if( c >= 0 )then
                local add = NrpnEvent.new(
                    c,
                    MidiParameterEnum.CC_FX2_EFFECT2_DEPTH,
                    fx2depth:getValue( i )
                );
                table.insert( ret, add );
            end
        end
        return ret;
    end
]]

--
-- トラックの先頭に記録される NRPN のリストを作成する
-- @return (table&lt;<a href="../files/NrpnEvent.html">NrpnEvent</a>&gt;) NrpnEvent の配列
-- @name <i>_generateHeaderNRPN</i>
function Sequence._generateHeaderNRPN()
    local ret = NrpnEvent.new( 0, MidiParameterEnum.CC_BS_VERSION_AND_DEVICE, 0x00, 0x00 );
    ret:append( MidiParameterEnum.CC_BS_DELAY, 0x00, 0x00 );
    ret:append( MidiParameterEnum.CC_BS_LANGUAGE_TYPE, 0x00 );
    return ret;
end

--
-- 歌手変更イベントの NRPN リストを作成する。
-- トラック先頭の歌手変更イベントについては、このメソッドで作成してはいけない。
-- トラック先頭のgenerateNRPN メソッドが担当する
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) 出力元のシーケンス
-- @param singerEvent (<a href="../files/Event.html">Event</a>) 出力する歌手変更イベント
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table&lt;<a href="../files/NrpnEvent.html">NrpnEvent</a>&gt;) NrpnEvent の配列
-- @name <i>_generateSingerNRPN</i>
function Sequence._generateSingerNRPN( sequence, singerEvent, msPreSend )
    local clock = singerEvent.clock;
    local singer_handle = nil;
    if( singerEvent.singerHandle ~= nil )then
        singer_handle = singerEvent.singerHandle;
    end
    if( singer_handle == nil )then
        return {};
    end

    local clock_msec = sequence.tempoTable:getSecFromClock( clock ) * 1000.0;

    local msEnd = sequence.tempoTable:getSecFromClock( singerEvent.clock + singerEvent:getLength() ) * 1000.0;
    local duration = math.floor( math.ceil( msEnd - clock_msec ) );

    local duration0, duration1 = Sequence._getMsbAndLsb( duration );

    local actualClock, delay;
    actualClock, delay = sequence:_getActualClockAndDelay( clock, msPreSend );
    local delayMsb, delayLsb = Sequence._getMsbAndLsb( delay );
    local ret = {};

    local add = NrpnEvent.new( actualClock, MidiParameterEnum.CC_BS_VERSION_AND_DEVICE, 0x00, 0x00 );
    add:append( MidiParameterEnum.CC_BS_DELAY, delayMsb, delayLsb, true );
    add:append( MidiParameterEnum.CC_BS_LANGUAGE_TYPE, singer_handle.language, true );
    add:append( MidiParameterEnum.PC_VOICE_TYPE, singer_handle.program );
    local arr = {};
    table.insert( arr, add );
    return arr;
end

--
-- トラックの音符イベントから NRPN のリストを作成する
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param noteEvent (<a href="../files/Event.html">Event</a>) 出力する音符イベント
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @param noteLocation (integer) <ul>
--                               <li>00:前後共に連続した音符がある
--                               <li>01:後ろにのみ連続した音符がある
--                               <li>02:前にのみ連続した音符がある
--                               <li>03:前後どちらにも連続した音符が無い
--                           </ul>
-- @param lastDelay (integer) 直前の音符イベントに指定された、ミリ秒単位のディレイ値。最初の音符イベントの場合は nil を指定する
-- @return (<a href="../files/NrpnEvent.html">NrpnEvent</a>) NrpnEvent
-- @return (integer) この音符に対して設定された、ミリ秒単位のディレイ値
-- @name <i>_generateNoteNRPN</i>
function Sequence._generateNoteNRPN( sequence, track, noteEvent, msPreSend, noteLocation, lastDelay )
    local clock = noteEvent.clock;
    local add = nil;

    local actualClock, delay;
    actualClock, delay = sequence:_getActualClockAndDelay( clock, msPreSend );

    if( lastDelay == nil )then
        add = NrpnEvent.new(
            actualClock,
            MidiParameterEnum.CVM_NM_VERSION_AND_DEVICE,
            0x00, 0x00
        );
        lastDelay = 0;
    end

    if( lastDelay ~= delay )then
        local delayMsb, delayLsb = Sequence._getMsbAndLsb( delay );
        if( add == nil )then
            add = NrpnEvent.new( actualClock, MidiParameterEnum.CVM_NM_DELAY, delayMsb, delayLsb );
        else
            add:append( MidiParameterEnum.CVM_NM_DELAY, delayMsb, delayLsb, true );
        end
    end

    if( add == nil )then
        add = NrpnEvent.new( actualClock, MidiParameterEnum.CVM_NM_NOTE_NUMBER, noteEvent.note );
    else
        add:append( MidiParameterEnum.CVM_NM_NOTE_NUMBER, noteEvent.note, true );
    end

    -- Velocity
    add:append( MidiParameterEnum.CVM_NM_VELOCITY, noteEvent.dynamics, true );

    -- Note Duration
    local msEnd = sequence.tempoTable:getSecFromClock( clock + noteEvent:getLength() ) * 1000.0;
    local clock_msec = sequence.tempoTable:getSecFromClock( clock ) * 1000.0;
    local duration = math.floor( msEnd - clock_msec );
    local duration0, duration1 = Sequence._getMsbAndLsb( duration );
    add:append( MidiParameterEnum.CVM_NM_NOTE_DURATION, duration0, duration1, true );

    -- Note Location
    add:append( MidiParameterEnum.CVM_NM_NOTE_LOCATION, noteLocation, true );

    if( noteEvent.vibratoHandle ~= nil )then
        add:append( MidiParameterEnum.CVM_NM_INDEX_OF_VIBRATO_DB, 0x00, 0x00, true );
        local icon_id = noteEvent.vibratoHandle.iconId;
        local num = icon_id:sub( icon_id:len() - 3 );
        local vibrato_type = math.floor( tonumber( num, 16 ) );
        local note_length = noteEvent:getLength();
        local vibrato_delay = noteEvent.vibratoDelay;
        local bVibratoDuration = math.floor( (note_length - vibrato_delay) / note_length * 127.0 );
        local bVibratoDelay = 0x7f - bVibratoDuration;
        add:append( MidiParameterEnum.CVM_NM_VIBRATO_CONFIG, vibrato_type, bVibratoDuration, true );
        add:append( MidiParameterEnum.CVM_NM_VIBRATO_DELAY, bVibratoDelay, true );
    end

    local spl = noteEvent.lyricHandle:getLyricAt( 0 ):getPhoneticSymbolList();
    local s = "";
    local j;
    for j = 1, #spl, 1 do
        s = s .. spl[j];
    end
    local symbols = {};
    local i;
    for i = 1, s:len(), 1 do
        symbols[i] = s:sub( i, i );
    end

    local renderer = sequence.track:get( track ).common.version;
    if( renderer:sub( 1, 4 ) == "DSB2" )then
        add:append( 0x5011, 0x01, true );--TODO: (byte)0x5011の意味は解析中
    end

    add:append( MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL_BYTES, #symbols, true );-- (byte)0x12(Number of phonetic symbols in bytes)
    local count = -1;
    local consonantAdjustment = noteEvent.lyricHandle:getLyricAt( 0 ):getConsonantAdjustmentList();
    for j = 1, #spl, 1 do
        local chars = Util.stringToArray( spl[j] );--Array.new();
        local k;
        for k = 1, #chars, 1 do
            count = count + 1;
            if( k == 1 )then
                add:append( Util.bor( Util.lshift( 0x50, 8 ), (0x13 + count) ), chars[k], consonantAdjustment[j], true ); -- Phonetic symbol j
            else
                add:append( Util.bor( Util.lshift( 0x50, 8 ), (0x13 + count) ), chars[k], true ); -- Phonetic symbol j
            end
        end
    end
    if( renderer:sub( 1, 4 ) ~= "DSB2" )then
        add:append( MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL_CONTINUATION, 0x7f, true ); -- End of phonetic symbols
    end
    if( renderer:sub( 1, 4 ) == "DSB3" )then
        local v1mean = math.floor( noteEvent.pmBendDepth * 60 / 100 );
        if( v1mean < 0 )then
            v1mean = 0;
        end
        if( 60 < v1mean )then
            v1mean = 60;
        end
        local d1mean = math.floor( 0.3196 * noteEvent.pmBendLength + 8.0 );
        local d2mean = math.floor( 0.92 * noteEvent.pmBendLength + 28.0 );
        add:append( MidiParameterEnum.CVM_NM_V1MEAN, v1mean, true );-- (byte)0x50(v1mean)
        add:append( MidiParameterEnum.CVM_NM_D1MEAN, d1mean, true );-- (byte)0x51(d1mean)
        add:append( MidiParameterEnum.CVM_NM_D1MEAN_FIRST_NOTE, 0x14, true );-- (byte)0x52(d1meanFirstNote)
        add:append( MidiParameterEnum.CVM_NM_D2MEAN, d2mean, true );-- (byte)0x53(d2mean)
        add:append( MidiParameterEnum.CVM_NM_D4MEAN, noteEvent.d4mean, true );-- (byte)0x54(d4mean)
        add:append( MidiParameterEnum.CVM_NM_PMEAN_ONSET_FIRST_NOTE, noteEvent.pMeanOnsetFirstNote, true ); -- 055(pMeanOnsetFirstNote)
        add:append( MidiParameterEnum.CVM_NM_VMEAN_NOTE_TRNSITION, noteEvent.vMeanNoteTransition, true ); -- (byte)0x56(vMeanNoteTransition)
        add:append( MidiParameterEnum.CVM_NM_PMEAN_ENDING_NOTE, noteEvent.pMeanEndingNote, true );-- (byte)0x57(pMeanEndingNote)
        add:append( MidiParameterEnum.CVM_NM_ADD_PORTAMENTO, noteEvent.pmbPortamentoUse, true );-- (byte)0x58(AddScoopToUpInternals&AddPortamentoToDownIntervals)
        local decay = math.floor( noteEvent.demDecGainRate / 100.0 * 0x64 );
        add:append( MidiParameterEnum.CVM_NM_CHANGE_AFTER_PEAK, decay, true );-- (byte)0x59(changeAfterPeak)
        local accent = math.floor( 0x64 * noteEvent.demAccent / 100.0 );
        add:append( MidiParameterEnum.CVM_NM_ACCENT, accent, true );-- (byte)0x5a(Accent)
    end
    add:append( MidiParameterEnum.CVM_NM_NOTE_MESSAGE_CONTINUATION, 0x7f, true );-- (byte)0x7f(Note message continuation)
    return add, delay;
end

--
-- 指定したシーケンスの指定したトラックから、NRPN のリストを作成する
function Sequence.generateNRPN( ... )
    local arguments = { ... };
    if( #arguments == 3 )then
        return Sequence._generateNRPN_3( arguments[1], arguments[2], arguments[3] );
    elseif( #arguments == 5 )then
        return Sequence._generateNRPN_5( arguments[1], arguments[2], arguments[3], arguments[4], arguments[5] );
    end
end

--[[
    --
    --  指定したトラックのデータから，NRPNを作成します
    -- @param vsq [VsqFile]
    -- @param track [int]
    -- @param msPreSend [int]
    -- @param clock_start [int]
    -- @param clock_end [int]
    -- @return [VsqNrpn[] ]
    function Sequence._generateNRPN_5( vsq, track, msPreSend, clock_start, clock_end )
        local temp = vsq:clone();
        temp.removePart( clock_end, vsq.TotalClocks );
        if( 0 < clock_start )then
            temp.removePart( 0, clock_start );
        end
        temp.Master.PreMeasure = 1;
        --temp.m_premeasure_clocks = temp.getClockFromBarCount( 1 );
        local ret = Sequence._generateNRPN_3( temp, track, msPreSend );
        temp = nil;
        return ret;
    end
]]

--
-- 指定したシーケンスの指定したトラックから、NRPN のリストを作成する
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table&lt;<a href="../files/NrpnEvent.html">NrpnEvent</a>&gt;) NrpnEvent の配列
-- @name <i>_generateNRPN_3</i>
function Sequence._generateNRPN_3( sequence, track, msPreSend )
    local list = {};

    local target = sequence.track:get( track );
    local version = target.common.version;

    local count = target.events:size();
    local note_start = 0;
    local note_end = target.events:size() - 1;
    local i;
    for i = 0, count - 1, 1 do
        if( 0 <= target.events:get( i ).clock )then
            note_start = i;
            break;
        end
        note_start = i;
    end
    for i = target.events:size() - 1, 0, -1 do
        if( target.events:get( i ).clock <= sequence._totalClocks )then
            note_end = i;
            break;
        end
    end

    -- 最初の歌手を決める
    local singer_event = -1;
    for i = note_start, 0, -1 do
        if( target.events:get( i ).type == EventTypeEnum.Singer )then
            singer_event = i;
            break;
        end
    end
    if( singer_event >= 0 )then --見つかった場合
        Sequence._array_add_all( list, Sequence._generateSingerNRPN( sequence, target.events:get( singer_event ), 0 ) );
    else                   --多分ありえないと思うが、歌手が不明の場合。
        --throw new Exception( "first singer was not specified" );
        table.insert( list, NrpnEvent.new( 0, MidiParameterEnum.CC_BS_LANGUAGE_TYPE, 0x0 ) );
        table.insert( list, NrpnEvent.new( 0, MidiParameterEnum.PC_VOICE_TYPE, 0x0 ) );
    end

    Sequence._array_add_all( list, Sequence._generateVoiceChangeParameterNRPN( sequence, track, msPreSend ) );
    if( version:sub( 1, 4 ) == "DSB2" )then
        Sequence._array_add_all( list, Sequence.generateFx2DepthNRPN( sequence, track, msPreSend ) );
    end

    local ms_presend = msPreSend;
    local dyn = target:getCurve( "dyn" );
    if( dyn:size() > 0 )then
        local listdyn = Sequence._generateExpressionNRPN( sequence, track, ms_presend );
        if( #listdyn > 0 )then
            Sequence._array_add_all( list, listdyn );
        end
    end
    local pbs = target:getCurve( "pbs" );
    if( pbs:size() > 0 )then
        local listpbs = Sequence._generatePitchBendSensitivityNRPN( sequence, track, ms_presend );
        if( #listpbs > 0 )then
            Sequence._array_add_all( list, listpbs );
        end
    end
    local pit = target:getCurve( "pit" );
    if( pit:size() > 0 )then
        local listpit = Sequence._generatePitchBendNRPN( sequence, track, ms_presend );
        if( #listpit > 0 )then
            Sequence._array_add_all( list, listpit );
        end
    end

    local lastDelay = nil;
    local last_note_end = 0;
    for i = note_start, note_end, 1 do
        local item = target.events:get( i );
        if( item.type == EventTypeEnum.Anote )then
            local note_loc = 0x03;
            if( item.clock == last_note_end )then
                note_loc = note_loc - 0x02;
            end

            -- 次に現れる音符イベントを探す
            local nextclock = item.clock + item:getLength() + 1;
            local event_count = target.events:size();
            local j;
            for j = i + 1, event_count - 1, 1 do
                local itemj = target.events:get( j );
                if( itemj.type == EventTypeEnum.Anote )then
                    nextclock = itemj.clock;
                    break;
                end
            end
            if( item.clock + item:getLength() == nextclock )then
                note_loc = note_loc - 0x01;
            end

            local noteNrpn;
            noteNrpn, lastDelay = Sequence._generateNoteNRPN(
                sequence,
                track,
                item,
                msPreSend,
                note_loc,
                lastDelay
            );

            table.insert( list, noteNrpn );
            Sequence._array_add_all(
                list,
                Sequence._generateVibratoNRPN( sequence, item, msPreSend )
            );
            last_note_end = item.clock + item:getLength();
        elseif( item.type == EventTypeEnum.Singer )then
            if( i > note_start and i ~= singer_event )then
                Sequence._array_add_all(
                    list,
                    Sequence._generateSingerNRPN( sequence, item, msPreSend )
                );
            end
        end
    end

    table.sort( list, NrpnEvent.compare );
    local merged = {};
    for i = 1, #list, 1 do
        Sequence._array_add_all( merged, list[i]:expand() );
    end
    return merged;
end

--
-- 指定したシーケンスの指定したトラックから、PitchBend の NRPN リストを作成する
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table&lt;<a href="../files/NrpnEvent.html">NrpnEvent</a>&gt;) NrpnEvent の配列
-- @name <i>_generatePitchBendNRPN</i>
function Sequence._generatePitchBendNRPN( sequence, track, msPreSend )
    local ret = {};
    local pit = sequence.track:get( track ):getCurve( "PIT" );
    local count = pit:size();
    local i, lastDelay;
    for i = 0, count - 1, 1 do
        local clock = pit:getKeyClock( i );

        local actualClock, delay;
        actualClock, delay = sequence:_getActualClockAndDelay( clock, msPreSend );
        if( actualClock >= 0 )then
            if( lastDelay ~= delay )then
                local delayMsb, delayLsb;
                delayMsb, delayLsb = Sequence._getMsbAndLsb( delay );
                table.insert(
                    ret,
                    NrpnEvent.new( actualClock, MidiParameterEnum.PB_DELAY, delayMsb, delayLsb )
                );
            end
            lastDelay = delay;

            local value = pit:getValue( i ) + 0x2000;
            local msb, lsb = Sequence._getMsbAndLsb( value );
            table.insert(
                ret,
                NrpnEvent.new( actualClock, MidiParameterEnum.PB_PITCH_BEND, msb, lsb )
            );
        end
    end
    return ret;
end

--
-- 配列を連結する
-- @access private
-- @param src_array (table) 連結先のテーブル。参照として更新される
-- @param add_array (table) 追加される要素が格納されたテーブル
-- @return (table) src_array と同じインスタンス
function Sequence._array_add_all( src_array, add_array )
    local i;
    for i = 1, #add_array, 1 do
        table.insert( src_array, add_array[i] );
    end
    return src_array;
end

--
-- 指定したシーケンスの指定したトラックから、PitchBendSensitivity の NRPN リストを作成する
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table&lt;<a href="../files/NrpnEvent.html">NrpnEvent</a>&gt;) NrpnEvent の配列
-- @name <i>_generatePitchBendSensitivityNRPN</i>
-- @todo ディレイを設定する必要があるのでは？
function Sequence._generatePitchBendSensitivityNRPN( sequence, track, msPreSend )
    local ret = {};
    local pbs = sequence.track:get( track ):getCurve( "PBS" );
    local count = pbs:size();
    local i;
    local lastDelay = 0;
    for i = 0, count - 1, 1 do
        local clock = pbs:getKeyClock( i );
        local actualClock, delay;
        actualClock, delay = sequence:_getActualClockAndDelay( clock, msPreSend );
        if( actualClock >= 0 )then
            if( lastDelay ~= delay )then
                local delayMsb, delayLsb;
                delayMsb, delayLsb = Sequence._getMsbAndLsb( delay );
                table.insert(
                    ret,
                    NrpnEvent.new( actualClock, MidiParameterEnum.CC_PBS_DELAY, delayMsb, delayLsb )
                );
            end
            lastDelay = delay;

            local add = NrpnEvent.new(
                actualClock,
                MidiParameterEnum.CC_PBS_PITCH_BEND_SENSITIVITY,
                pbs:getValue( i ),
                0x00
            );
            table.insert( ret, add );
        end
    end
    return ret;
end

--
-- トラックの音符イベントから、ビブラート出力用の NRPN のリストを作成する
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) 出力元のシーケンス
-- @param noteEvent (<a href="../files/Event.html">Event</a>) 出力する音符イベント
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table&lt;<a href="../files/NrpnEvent.html">NrpnEvent</a>&gt;) NrpnEvent の配列
-- @name <i>_generateVibratoNRPN</i>
function Sequence._generateVibratoNRPN( sequence, noteEvent, msPreSend )
    local ret = {};
    if( noteEvent.vibratoHandle ~= nil )then
        local vclock = noteEvent.clock + noteEvent.vibratoDelay;
        local actualClock, delay;
        actualClock, delay = sequence:_getActualClockAndDelay( vclock, msPreSend );
        local delayMsb, delayLsb = Sequence._getMsbAndLsb( delay );
        local add2 = NrpnEvent.new( actualClock, MidiParameterEnum.CC_VD_VERSION_AND_DEVICE, 0x00, 0x00 );
        add2:append( MidiParameterEnum.CC_VR_VERSION_AND_DEVICE, 0x00, 0x00 );
        add2:append( MidiParameterEnum.CC_VD_DELAY, delayMsb, delayLsb );
        add2:append( MidiParameterEnum.CC_VR_DELAY, delayMsb, delayLsb );
        -- CC_VD_VIBRATO_DEPTH, CC_VR_VIBRATO_RATE では、NRPN の MSB を省略してはいけない
        add2:append( MidiParameterEnum.CC_VD_VIBRATO_DEPTH, noteEvent.vibratoHandle:getStartDepth() );
        add2:append( MidiParameterEnum.CC_VR_VIBRATO_RATE, noteEvent.vibratoHandle:getStartRate() );
        table.insert( ret, add2 );
        local vlength = noteEvent:getLength() - noteEvent.vibratoDelay;

        local depthBP = noteEvent.vibratoHandle:getDepthBP();
        local count = depthBP:size();
        if( count > 0 )then
            local i, lastDelay;
            lastDelay = 0;
            for i = 0, count - 1, 1 do
                local itemi = depthBP:get( i );
                local percent = itemi.x;
                local cl = vclock + math.floor( percent * vlength );
                actualClock, delay = sequence:_getActualClockAndDelay( cl, msPreSend );
                local nrpnEvent = nil;
                if( lastDelay ~= delay )then
                    delayMsb, delayLsb = Sequence._getMsbAndLsb( delay );
                    nrpnEvent = NrpnEvent.new( actualClock, MidiParameterEnum.CC_VD_DELAY, delayMsb, delayLsb );
                    nrpnEvent:append( MidiParameterEnum.CC_VD_VIBRATO_DEPTH, itemi.y );
                else
                    nrpnEvent = NrpnEvent.new( actualClock, MidiParameterEnum.CC_VD_VIBRATO_DEPTH, itemi.y );
                end
                lastDelay = delay;
                table.insert( ret, nrpnEvent );
            end
        end

        local rateBP = noteEvent.vibratoHandle:getRateBP();
        count = rateBP:size();
        if( count > 0 )then
            local i, lastDelay;
            lastDelay = 0;
            for i = 0, count - 1, 1 do
                local itemi = rateBP:get( i );
                local percent = itemi.x;
                local cl = vclock + math.floor( percent * vlength );
                actualClock, delay = sequence:_getActualClockAndDelay( cl, msPreSend );
                local nrpnEvent = nil;
                if( lastDelay ~= delay )then
                    delayMsb, delayLsb = Sequence._getMsbAndLsb( delay );
                    nrpnEvent = NrpnEvent.new( actualClock, MidiParameterEnum.CC_VR_DELAY, delayMsb, delayLsb );
                    nrpnEvent:append( MidiParameterEnum.CC_VR_VIBRATO_RATE, itemi.y );
                else
                    nrpnEvent = NrpnEvent.new( actualClock, MidiParameterEnum.CC_VR_VIBRATO_RATE, itemi.y );
                end
                lastDelay = delay;
                table.insert( ret, nrpnEvent );
            end
        end
    end
    table.sort( ret, NrpnEvent.compare );
    return ret;
end

--
-- 指定したシーケンスの指定したトラックから、VoiceChangeParameter の NRPN リストを作成する
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table&lt;<a href="../files/NrpnEvent.html">NrpnEvent</a>&gt;) NrpnEvent の配列
-- @name <i>_generateVoiceChangeParameterNRPN</i>
function Sequence._generateVoiceChangeParameterNRPN( sequence, track, msPreSend )
    local premeasure_clock = sequence:getPreMeasureClocks();
    local renderer = sequence.track:get( track ).common.version;
    local res = {};

    local curves;
    if( renderer:sub( 1, 4 ) == "DSB3" )then
        curves = { "BRE", "BRI", "CLE", "POR", "OPE", "GEN" };
    elseif( renderer:sub( 1, 4 ) == "DSB2" )then
        curves = { "BRE", "BRI", "CLE", "POR", "GEN", "harmonics",
                   "reso1amp", "reso1bw", "reso1freq",
                   "reso2amp", "reso2bw", "reso2freq",
                   "reso3amp", "reso3bw", "reso3freq",
                   "reso4amp", "reso4bw", "reso4freq" };
    else
        curves = { "BRE", "BRI", "CLE", "POR", "GEN" };
    end

    local i, lastDelay;
    lastDelay = 0;
    for i = 1, #curves, 1 do
        local list = sequence.track:get( track ):getCurve( curves[i] );
        if( list:size() > 0 )then
            Sequence._addVoiceChangeParameters( res, list, sequence, msPreSend );
        end
    end
    table.sort( res, NrpnEvent.compare );
    return res;
end

--
-- Voice Change Parameter の NRPN を追加する
-- @access private
-- @param dest (table) 追加先のテーブル
-- @param list (<a href="../files/BPList.html">BPList</a>) Voice Change Parameter のデータ点が格納された BPList
-- @param sequence (<a href="../files/Sequence.html">Sequence</a>) シーケンス
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @name <i>_addVoiceChangeParameters</i>
function Sequence._addVoiceChangeParameters( dest, list, sequence, msPreSend )
    local id = MidiParameterEnum.getVoiceChangeParameterId( list:getName() );
    local count = list:size();
    local j;
    for j = 0, count - 1, 1 do
        local clock = list:getKeyClock( j );
        local value = list:getValue( j );
        local actualClock, delay;
        actualClock, delay = sequence:_getActualClockAndDelay( clock, msPreSend );

        if( actualClock >= 0 )then
            local add = nil;
            if( lastDelay ~= delay )then
                local delayMsb, delayLsb;
                delayMsb, delayLsb = Sequence._getMsbAndLsb( delay );
                add = NrpnEvent.new( actualClock, MidiParameterEnum.VCP_DELAY, delayMsb, delayLsb );
            end
            lastDelay = delay;

            if( add == nil )then
                add = NrpnEvent.new( actualClock, MidiParameterEnum.VCP_VOICE_CHANGE_PARAMETER_ID, id );
            else
                add:append( MidiParameterEnum.VCP_VOICE_CHANGE_PARAMETER_ID, id );
            end
            add:append( MidiParameterEnum.VCP_VOICE_CHANGE_PARAMETER, value, true );
            table.insert( dest, add );
        end
    end
end

--
-- DATA の値を MSB と LSB に分解する
-- @param value (integer) 分解する値
-- @return (integer) MSB の値
-- @return (integer) LSB の値
-- @name <i>_getMsbAndLsb</i>
function Sequence._getMsbAndLsb( value )
    if( 0x3fff < value )then
        return 0x7f, 0x7f;
    else
        local msb = Util.rshift( value, 7 );
        return msb, value - Util.lshift( msb, 7 );
    end
end

--
-- "DM:0001:"といった、VSQメタテキストの行の先頭につくヘッダー文字列のバイト列表現を取得する
-- @param count (integer) ヘッダーの番号
-- @return (table<integer>) バイト列
-- @name <i>_getLinePrefixBytes</i>
function Sequence._getLinePrefixBytes( count )
    local digits = Sequence._getHowManyDigits( count );
    local c = math.floor( (digits - 1) / 4 ) + 1;
    local format = "";
    local i;
    for i = 1, c, 1 do
        format = format .. "0000";
    end
    local str = "DM:" .. string.format( "%0" .. (c * 4) .. "d", count ) .. ":";
    local count = str:len();
    local result = {};
    for i = 1, count, 1 do
        table.insert( result, string.byte( str:sub( i, i ) ) );
    end
    return result;
end

--
-- 数値の 10 進数での桁数を取得する
-- @param number (integer) 検査対象の数値
-- @return (integer) 数値の 10 進数での桁数
-- @name <i>_getHowManyDigits</i>
function Sequence._getHowManyDigits( number )
    number = math.abs( number );
    if( number == 0 )then
        return 1;
    else
        return math.floor( math.log10( number ) ) + 1;
    end
end

--
-- 16 ビットの unsigned int 値をビッグエンディアンでストリームに書きこむ
-- @param stream (? extends OutputStream) 出力先のストリーム
-- @param data (integer) 出力する値
-- @name <i>_writeUnsignedShort</i>
function Sequence._writeUnsignedShort( stream, data )
    local dat = Util.getBytesUInt16BE( data );
    stream:write( dat, 1, #dat );
end

--
-- 32 ビットの unsigned int 値をビッグエンディアンでストリームに書きこむ
-- @param stream (? extends OutputStram) 出力先のストリーム
-- @param data (integer) 出力する値
-- @name <i>_writeUnsignedInt</i>
function Sequence._writeUnsignedInt( stream, data )
    local dat = Util.getBytesUInt32BE( data );
    stream:write( dat, 1, #dat );
end
