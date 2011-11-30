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

module( "luavsq" );

---
-- VSQ ファイルのシーケンスを保持するクラス
-- @class table
-- @name Sequence
Sequence = {};

Sequence.baseTempo = 500000;
Sequence._MTRK = { 0x4d, 0x54, 0x72, 0x6b };
Sequence._MTHD = { 0x4d, 0x54, 0x68, 0x64 };
Sequence._MASTER_TRACK = { 0x4D, 0x61, 0x73, 0x74, 0x65, 0x72, 0x20, 0x54, 0x72, 0x61, 0x63, 0x6B };
Sequence._CURVES = { "VEL", "DYN", "BRE", "BRI", "CLE", "OPE", "GEN", "POR", "PIT", "PBS" };

---
-- 初期化を行う
-- @see _init_5
-- @return (Sequence)
-- @name <i>new</i>
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
    this.totalClocks = 0;
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
    -- @param pre_measure (integer) 小節単位のプリメジャー
    -- @param numerator (integer) 拍子の分子の値
    -- @param denominator (integer) 拍子の分母の値
    -- @param tempo (integer) テンポ値。四分音符の長さのマイクロ秒単位の長さ
    -- @name _init_5
    function this:_init_5( singer, pre_measure, numerator, denominator, tempo )
        self.totalClocks = pre_measure * 480 * 4 / denominator * numerator;

        self.track = List.new();--Array.new();
        self.track:push( Track.new() );
        self.track:push( Track.new( "Voice1", singer ) );
        self.master = Master.new( pre_measure );
        self.mixer = Mixer.new( 0, 0, 0, 0 );
        self.mixer.slave[1] = MixerItem.new( 0, 0, 0, 0 );
        self.timesigTable = TimesigTable.new();
        self.timesigTable:push( TimesigTableItem.new( 0, numerator, denominator, 0 ) );
        self.tempoTable = TempoTable.new();
        self.tempoTable:push( TempoTableItem.new( 0, tempo, 0.0 ) );
    end

    ---
    -- コピーを作成する
    -- @return (Sequence) オブジェクトのコピー
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
        ret.totalClocks = self.totalClocks;
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
        local last_clock = self.timesigTable:get( 0 ).clock;
        local last_denominator = self.timesigTable:get( 0 ).denominator;
        local last_numerator = self.timesigTable:get( 0 ).numerator;
        for i = 1, self.timesigTable:size() - 1, 1 do
            if( self.timesigTable:get( i ).barCount >= pre_measure )then
                break;
            else
                last_bar_count = self.timesigTable:get( i ).barCount;
                last_clock = self.timesigTable:get( i ).clock;
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
                max = math.max( max, lastItem.clock + lastItem.id:getLength() );
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
        self.totalClocks = max;
    end

    ---
    -- メタテキストイベントを作成する
    -- @see _generateMetaTextEventCore
    -- @return (table<MidiEvent>) メタテキストを格納した MidiEvent の配列
    -- @name generateMetaTextEvent
    function this:generateMetaTextEvent( ... )
        local arguments = { ... };
        if( #arguments == 2 )then
            return self:_generateMetaTextEventCore( arguments[1], arguments[2], self:_calculatePreMeasureInClock(), false );
        elseif( #arguments == 3 )then
            return self:_generateMetaTextEventCore( arguments[1], arguments[2], arguments[3], false );
        elseif( #arguments == 4 )then
            return self:_generateMetaTextEventCore( arguments[1], arguments[2], arguments[3], arguments[4] );
        end
    end

    ---
    -- メタテキストイベントを作成する
    -- @accesss private
    -- @param track (integer) トラック番号
    -- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
    -- @param start_clock (integer) イベント作成の開始位置
    -- @param print_pitch (boolean) pitch を含めて出力するかどうか(現在は false 固定で、引数は無視される)
    -- @return (table<MidiEvent>) メタテキストを格納した MidiEvent の配列
    -- @name _generateMetaTextEventCore
    function this:_generateMetaTextEventCore( track, encoding, start_clock, print_pitch )
        local _NL = string.char( 0x0a );
        local ret = {};--new Vector<MidiEvent>();
        local sr = TextStream.new();
        self.track:get( track ):printMetaText( sr, self.totalClocks + 120, start_clock, print_pitch );
        sr:setPointer( -1 );
        local line_count = -1;
        local tmp = "";
        if( sr:ready() )then
            local buffer = {};--new Vector<Byte>();
            local first = true;
            while( sr:ready() )do
                if( first )then
                    tmp = sr:readLine();
                    first = false;
                else
                    tmp = _NL .. sr:readLine();
                end
                local line = CP932Converter.convertFromUTF8( tmp );--PortUtil.convertByteArray( PortUtil.getEncodedByte( encoding, tmp ) );
                local linebytes = Util.stringToArray( line );
                Sequence._array_add_all( buffer, linebytes );
                local prefix = Sequence.getLinePrefixBytes( line_count + 1 );
                while( #prefix + #buffer >= 127 )do
                    line_count = line_count + 1;
                    local prefix = Sequence.getLinePrefixBytes( line_count );
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
                    prefix = Sequence.getLinePrefixBytes( line_count + 1 );
                end
            end
            if( #buffer > 0 )then
                local prefix = Sequence.getLinePrefixBytes( line_count + 1 );
                while( #prefix + #buffer >= 127 )do
                    line_count = line_count + 1;
                    prefix = Sequence.getLinePrefixBytes( line_count );
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
                    prefix = Sequence.getLinePrefixBytes( line_count + 1 );
                end
                if( #buffer > 0 )then
                    line_count = line_count + 1;
                    local prefix = Sequence.getLinePrefixBytes( line_count );
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

    ---
    -- 指定した時刻におけるプリセンド・クロックを取得する
    -- @param clock (integer) Tick 単位の時刻
    -- @param msPreSend (integer) ミリ秒単位のプリセンド時間
    -- @return (integer) Tick 単位の時間
    -- @name getPresendClockAt
    function this:getPresendClockAt( clock, msPreSend )
        local clock_msec = self.tempoTable:getSecFromClock( clock ) * 1000.0;
        local draft_clock_sec = (clock_msec - msPreSend) / 1000.0;
        local draft_clock = math.floor( self.tempoTable:getClockFromSec( draft_clock_sec ) );
        return clock - draft_clock;
    end

--[[
        ---
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

    ---
    -- 拍子情報のテーブルから、拍子変更の MidiEvent を作成する
    -- @return (table<MidiEvent>) 拍子変更イベントを格納した MidiEvent の配列
    -- @name generateTimeSig
    function this:generateTimeSig()
        local events = {};--new Vector<MidiEvent>();
        local itr = self.timesigTable:iterator();
        while( itr:hasNext() )do
            local item = itr:next();
            local event = MidiEvent.generateTimeSigEvent(
                item.clock,
                item.numerator,
                item.denominator
            );
            table.insert( events, event );
        end
        return events;
    end

    ---
    -- テンポ情報のテーブルから、テンポ変更の MidiEvent を作成する
    -- @return (table<MidiEvent>) テンポ変更イベントを格納した MidiEvent の配列
    -- @name generateTempoChange
    function this:generateTempoChange()
        local events = {};--new Vector<MidiEvent>();
        local itr = self.tempoTable:iterator();
        while( itr:hasNext() )do
            local item = itr:next();
            local event = MidiEvent.generateTempoChangeEvent( item.clock, item.tempo );
            table.insert( events, event );
        end
        return events;
    end

    ---
    -- ストリームに出力する
    -- @param msPreSend (integer) ミリ秒単位のプリセンドタイム
    -- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
    -- @see _writeCore
    -- @name write
    function this:write( ... )
        local arguments = { ... };
        if( #arguments == 3 )then
            return self:_writeCore( arguments[1], arguments[2], arguments[3], false );
        elseif( #arguments == 4 )then
            return self:_writeCore( arguments[1], arguments[2], arguments[3], arguments[4] );
        end
    end

    ---
    -- ストリームに出力する
    -- @param (integer) msPreSend ミリ秒単位のプリセンドタイム
    -- @param (string) encoding マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
    -- @name _writeCore
    function this:_writeCore( fs, msPreSend, encoding, print_pitch )
        local last_clock = 0;
        local track_size = self.track:size();
        local track;
        for track = 1, track_size - 1, 1 do
            if( self.track:get( track ).events:size() > 0 )then
                local index = self.track:get( track ).events:size() - 1;
                local last = self.track:get( track ).events:get( index );
                last_clock = math.max( last_clock, last.clock + last.id:getLength() );
            end
        end

        local first_position;--チャンクの先頭のファイル位置

        -- ヘッダ
        --チャンクタイプ
        fs:write( Sequence._MTHD, 1, 4 );
        --データ長
        fs:write( 0x00 );
        fs:write( 0x00 );
        fs:write( 0x00 );
        fs:write( 0x06 );
        --フォーマット
        fs:write( 0x00 );
        fs:write( 0x01 );
        --トラック数
        Sequence.writeUnsignedShort( fs, self.track:size() );
        --時間単位
        fs:write( 0x01 );
        fs:write( 0xe0 );

        -- Master Track
        --チャンクタイプ
        fs:write( Sequence._MTRK, 1, 4 );
        --データ長。とりあえず0を入れておく
        fs:write( { 0x00, 0x00, 0x00, 0x00 }, 1, 4 );
        first_position = fs:getPointer();
        --トラック名
        MidiEvent.writeDeltaClock( fs, 0 );--デルタタイム
        fs:write( 0xff );--ステータスタイプ
        fs:write( 0x03 );--イベントタイプSequence/Track Name
        fs:write( #Sequence._MASTER_TRACK );--トラック名の文字数。これは固定
        fs:write( Sequence._MASTER_TRACK, 1, #Sequence._MASTER_TRACK );

        local events = {};--Vector<MidiEvent>();
        local itr = self.timesigTable:iterator();
        while( itr:hasNext() )do
            local entry = itr:next();
            table.insert( events, MidiEvent.generateTimeSigEvent( entry.clock, entry.numerator, entry.denominator ) );
            last_clock = math.max( last_clock, entry.clock );
        end
        itr = self.tempoTable.iterator();
        while( itr:hasNext() )do
            local entry = itr:next();
            table.insert( events, MidiEvent.generateTempoChangeEvent( entry.clock, entry.tempo ) );
            last_clock = math.max( last_clock, entry.clock );
        end
        table.sort( events, MidiEvent.compare );
        local last = 0;
        local itr = List.fromTable( events ):iterator();
        while( itr:hasNext() )do
            local midiEvent = itr:next();
            MidiEvent.writeDeltaClock( fs, midiEvent.clock - last );
            midiEvent:writeData( fs );
            last = midiEvent.clock;
        end

        MidiEvent.writeDeltaClock( fs, 0 );
        fs:write( 0xff );
        fs:write( 0x2f );--イベントタイプEnd of Track
        fs:write( 0x00 );
        local pos = fs:getPointer();
        fs:seek( first_position - 4 );
        Sequence.writeUnsignedInt( fs, pos - first_position );
        fs:seek( pos );

        -- トラック
        local temp = self:clone();
        temp.track:get( 1 ).master = self.master:clone();
        temp.track:get( 1 ).mixer = self.mixer:clone();
        Sequence.printTrack( temp, 1, fs, msPreSend, encoding, print_pitch );
        local count = self.track:size();
        local track;
        for track = 2, count - 1, 1 do
            Sequence.printTrack( self, track, fs, msPreSend, encoding, print_pitch );
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

---
-- 文字列 s の先頭から、先頭から 127 バイト以下の文字を切り取る。
-- ただし、指定されたテキストエンコーディングでエンコードした場合にも、127 バイト以下となるよう切り取りを行う
-- @param s (string) 切り取り元の文字列
-- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
-- @return (string) 切り取った文字列
-- @name <i>substring127Bytes</i>
function Sequence.substring127Bytes( s, encoding )
    local count = math.min( 127, s:len() );
    local arr = CP932Converter.convertFromUTF( s:sub( 1, count ) );
    local c = #arr;--PortUtil.getEncodedByteCount( encoding, s.Substring( 0, count ) );
    if( c == 127 )then
        return s:sub( 1, count );
    end
    local delta;
    if( c > 127 )then
        delta = -1;
    else
        delta = 1;
    end
    while( (delta == -1 and c > 127) or (delta == 1 and c < 127) )do
        count = count + delta;
        if( delta == -1 and count == 0 )then
            break;
        elseif( delta == 1 and count == s:len() )then
            break;
        end
        arr = CP932Converter.convertFromUTF( s:sub( 1, count ) );
        c = #arr;--PortUtil.getEncodedByteCount( encoding, s.Substring( 0, count ) );
    end
    return s:sub( 1, count );
end

---
-- トラックをストリームに出力する
-- @param vsq (Sequence) 出力するシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param fs (? extends OutputStream) 出力先のストリーム
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @param encoding (string) マルチバイト文字のテキストエンコーディング(現在は Shift_JIS 固定で、引数は無視される)
-- @param print_pitch (boolean) pitch を含めて出力するかどうか(現在は false 固定で、引数は無視される)
-- @name <i>printTrack</i>
function Sequence.printTrack( vsq, track, fs, msPreSend, encoding, print_pitch )
    local _NL = string.char( 0x0a );
    --ヘッダ
    fs:write( Sequence._MTRK, 1, 4 );
    --データ長。とりあえず0
    fs:write( { 0x00, 0x00, 0x00, 0x00 }, 1, 4 );
    local first_position = fs:getPointer();
    --トラック名
    MidiEvent.writeDeltaClock( fs, 0x00 );--デルタタイム
    fs:write( 0xff );--ステータスタイプ
    fs:write( 0x03 );--イベントタイプSequence/Track Name
    local seq_name = CP932Converter.convertFromUTF8( vsq.track:get( track ):getName() );--PortUtil.getEncodedByte( encoding, vsq.Track.get( track ).getName() );
    MidiEvent.writeDeltaClock( fs, #seq_name );--seq_nameの文字数
    fs:write( seq_name, 1, #seq_name );

    --Meta Textを準備
    local meta = vsq:generateMetaTextEvent( track, encoding, 0, print_pitch );
    local lastclock = 0;
    local i;
    for i = 1, #meta, 1 do
        MidiEvent.writeDeltaClock( fs, meta[i].clock - lastclock );
        meta[i]:writeData( fs );
        lastclock = meta[i].clock;
    end

    local last = 0;
    -- @var data (table<NrpnEvent>)
    local data = Sequence.generateNRPN( vsq, track, msPreSend );
    -- @var nrpns (table<MidiEvent>)
    local nrpns = NrpnEvent.convert( data );
    for i = 1, #nrpns, 1 do
        local item = nrpns[i];
        MidiEvent.writeDeltaClock( fs, item.clock - last );
        item:writeData( fs );
        last = item.clock;
    end

    --トラックエンド
    local last_event = vsq.track:get( track ).events:get( vsq.track:get( track ).events:size() - 1 );
    local last_clock = last_event.clock + last_event.id:getLength();
    MidiEvent.writeDeltaClock( fs, last_clock );
    fs:write( 0xff );
    fs:write( 0x2f );
    fs:write( 0x00 );
    local pos = fs:getPointer();
    fs:seek( first_position - 4 );
    Sequence.writeUnsignedInt( fs, pos - first_position );
    fs:seek( pos );
end

---
-- トラックの Expression(DYN) の NRPN リストを作成する
-- @param vsq (Sequence) 出力するシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table<NrpnEvent>) NrpnEvent の配列
-- @name <i>generateExpressionNRPN</i>
function Sequence.generateExpressionNRPN( vsq, track, msPreSend )
    local ret = {};--Array.new();--Vector<VsqNrpn>();
    local dyn = vsq.track:get( track ):getCurve( "DYN" );
    local count = dyn:size();
    local i;
    for i = 0, count - 1, 1 do
        local clock = dyn:getKeyClock( i );
        local c = clock - vsq:getPresendClockAt( clock, msPreSend );
        if( c >= 0 )then
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

---
-- トラックの先頭に記録される NRPN のリストを作成する
-- @return (table<NrpnEvent>) NrpnEvent の配列
-- @name <i>generateHeaderNRPN</i>
function Sequence.generateHeaderNRPN()
    local ret = NrpnEvent.new( 0, MidiParameterEnum.CC_BS_VERSION_AND_DEVICE, 0x00, 0x00 );
    ret:append( MidiParameterEnum.CC_BS_DELAY, 0x00, 0x00 );
    ret:append( MidiParameterEnum.CC_BS_LANGUAGE_TYPE, 0x00 );
    return ret;
end

---
-- 歌手変更イベントの NRPN リストを作成する
-- @param vsq (Sequence) 出力元のシーケンス
-- @param ve (Event) 出力する歌手変更イベント
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table<NrpnEvent>) NrpnEvent の配列
-- @name <i>generateSingerNRPN</i>
function Sequence.generateSingerNRPN( vsq, ve, msPreSend )
    local clock = ve.clock;
    local singer_handle = nil; --IconHandle
    if( ve.id.singerHandle ~= nil )then
        singer_handle = ve.id.singerHandle;
    end
    if( singer_handle == nil )then
        return {};--VsqNrpn[] { end;
    end

    local clock_msec = vsq.tempoTable:getSecFromClock( clock ) * 1000.0;

    local ttempo = vsq.tempoTable:getTempoAt( clock );
    local tempo = 6e7 / ttempo;
    local msEnd = vsq.tempoTable:getSecFromClock( ve.clock + ve.id:getLength() ) * 1000.0;
    local duration = math.floor( math.ceil( msEnd - clock_msec ) );

    local duration0, duration1 = Sequence.getMsbAndLsb( duration );
    local delay0, delay1 = Sequence.getMsbAndLsb( msPreSend );
    local ret = {};-- Vector<VsqNrpn>();

    local i = clock - vsq:getPresendClockAt( clock, msPreSend );
    local add = NrpnEvent.new( i, MidiParameterEnum.CC_BS_VERSION_AND_DEVICE, 0x00, 0x00 );
    add:append( MidiParameterEnum.CC_BS_DELAY, delay0, delay1, true );
    add:append( MidiParameterEnum.CC_BS_LANGUAGE_TYPE, singer_handle.language, true );
    add:append( MidiParameterEnum.PC_VOICE_TYPE, singer_handle.program );
    local arr = {};
    table.insert( arr, add );
    return arr;
end

---
-- トラックの音符イベントから NRPN のリストを作成する
-- @param vsq (Sequence) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param ve (Event) 出力する音符イベント
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @param note_loc (integer) <ul>
--                               <li>00:前後共に連続した音符がある
--                               <li>01:後ろにのみ連続した音符がある
--                               <li>02:前にのみ連続した音符がある
--                               <li>03:前後どちらにも連続した音符が無い
--                           </ul>
-- @param add_delay_sign (boolean) ディレイイベントを追加するかどうか
-- @return (table<NrpnEvent>) NrpnEvent の配列
-- @name <i>generateNoteNRPN</i>
function Sequence.generateNoteNRPN( vsq, track, ve, msPreSend, note_loc, add_delay_sign )
    local clock = ve.clock;
    local renderer = vsq.track:get( track ).common.version;

    local clock_msec = vsq.tempoTable:getSecFromClock( clock ) * 1000.0;

    local ttempo = vsq.tempoTable:getTempoAt( clock );
    local tempo = 6e7 / ttempo;
    local msEnd = vsq.tempoTable:getSecFromClock( ve.clock + ve.id:getLength() ) * 1000.0;
    local duration = math.floor( msEnd - clock_msec );
    local duration0, duration1 = Sequence.getMsbAndLsb( duration );

    local add;
    if( add_delay_sign )then
        local delay0, delay1 = Sequence.getMsbAndLsb( msPreSend );
        add = NrpnEvent.new(
            clock - vsq:getPresendClockAt( clock, msPreSend ),
            MidiParameterEnum.CVM_NM_VERSION_AND_DEVICE,
            0x00, 0x00
        );
        add:append( MidiParameterEnum.CVM_NM_DELAY, delay0, delay1, true );
        add:append( MidiParameterEnum.CVM_NM_NOTE_NUMBER, ve.id.note, true ); -- Note number
    else
        add = NrpnEvent.new(
            clock - vsq:getPresendClockAt( clock, msPreSend ),
            MidiParameterEnum.CVM_NM_NOTE_NUMBER, ve.id.note
        ); -- Note number
    end
    add:append( MidiParameterEnum.CVM_NM_VELOCITY, ve.id.dynamics, true ); -- Velocity
    add:append( MidiParameterEnum.CVM_NM_NOTE_DURATION, duration0, duration1, true ); -- Note duration
    add:append( MidiParameterEnum.CVM_NM_NOTE_LOCATION, note_loc, true ); -- Note Location

    if( ve.id.vibratoHandle ~= nil )then
        add:append( MidiParameterEnum.CVM_NM_INDEX_OF_VIBRATO_DB, 0x00, 0x00, true );
        local icon_id = ve.id.vibratoHandle.iconId;
        local num = icon_id:sub( icon_id:len() - 4 );
        local vibrato_type = math.floor( tonumber( num, 16 ) );
        local note_length = ve.id:getLength();
        local vibrato_delay = ve.id.vibratoDelay;
        local bVibratoDuration = math.floor( (note_length - vibrato_delay) / note_length * 127.0 );
        local bVibratoDelay = 0x7f - bVibratoDuration;
        add:append( MidiParameterEnum.CVM_NM_VIBRATO_CONFIG, vibrato_type, bVibratoDuration, true );
        add:append( MidiParameterEnum.CVM_NM_VIBRATO_DELAY, bVibratoDelay, true );
    end

    local spl = ve.id.lyricHandle:getLyricAt( 0 ):getPhoneticSymbolList();
    local s = "";
    local j;
    for j = 1, #spl, 1 do
        s = s .. spl[j];
    end
    local symbols = {};
    local i;
    for i = 1, s:len(), 1 do
        symbols[i] = s:sub( i, i );
    end--s.ToCharArray();
    if( renderer:sub( 1, 4 ) == "DSB2" )then
        add:append( 0x5011, 0x01, true );--TODO: (byte)0x5011の意味は解析中
    end
    add:append( MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL_BYTES, #symbols, true );-- (byte)0x12(Number of phonetic symbols in bytes)
    local count = -1;
    local consonantAdjustment = ve.id.lyricHandle:getLyricAt( 0 ):getConsonantAdjustmentList();
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
        local v1mean = math.floor( ve.id.pmBendDepth * 60 / 100 );
        if( v1mean < 0 )then
            v1mean = 0;
        end
        if( 60 < v1mean )then
            v1mean = 60;
        end
        local d1mean = math.floor( 0.3196 * ve.id.pmBendLength + 8.0 );
        local d2mean = math.floor( 0.92 * ve.id.pmBendLength + 28.0 );
        add:append( MidiParameterEnum.CVM_NM_V1MEAN, v1mean, true );-- (byte)0x50(v1mean)
        add:append( MidiParameterEnum.CVM_NM_D1MEAN, d1mean, true );-- (byte)0x51(d1mean)
        add:append( MidiParameterEnum.CVM_NM_D1MEAN_FIRST_NOTE, 0x14, true );-- (byte)0x52(d1meanFirstNote)
        add:append( MidiParameterEnum.CVM_NM_D2MEAN, d2mean, true );-- (byte)0x53(d2mean)
        add:append( MidiParameterEnum.CVM_NM_D4MEAN, ve.id.d4mean, true );-- (byte)0x54(d4mean)
        add:append( MidiParameterEnum.CVM_NM_PMEAN_ONSET_FIRST_NOTE, ve.id.pMeanOnsetFirstNote, true ); -- 055(pMeanOnsetFirstNote)
        add:append( MidiParameterEnum.CVM_NM_VMEAN_NOTE_TRNSITION, ve.id.vMeanNoteTransition, true ); -- (byte)0x56(vMeanNoteTransition)
        add:append( MidiParameterEnum.CVM_NM_PMEAN_ENDING_NOTE, ve.id.pMeanEndingNote, true );-- (byte)0x57(pMeanEndingNote)
        add:append( MidiParameterEnum.CVM_NM_ADD_PORTAMENTO, ve.id.pmbPortamentoUse, true );-- (byte)0x58(AddScoopToUpInternals&AddPortamentoToDownIntervals)
        local decay = math.floor( ve.id.demDecGainRate / 100.0 * 0x64 );
        add:append( MidiParameterEnum.CVM_NM_CHANGE_AFTER_PEAK, decay, true );-- (byte)0x59(changeAfterPeak)
        local accent = math.floor( 0x64 * ve.id.demAccent / 100.0 );
        add:append( MidiParameterEnum.CVM_NM_ACCENT, accent, true );-- (byte)0x5a(Accent)
    end
--[[
        if( renderer:sub( 1, 4 ) == "UTU0" )then
            -- エンベロープ
            if( ve.ustEvent ~= nil )then
                local env = nil;
                if( ve.ustEvent.envelope ~= nil )then
                    env = ve.ustEvent.envelope;
                else
                    env = UstEnvelope.new();
                end
                local vals = nil;
                vals = Array.new();--int[10];
                vals[0] = env.p1;
                vals[1] = env.p2;
                vals[2] = env.p3;
                vals[3] = env.v1;
                vals[4] = env.v2;
                vals[5] = env.v3;
                vals[6] = env.v4;
                vals[7] = env.p4;
                vals[8] = env.p5;
                vals[9] = env.v5;
                for ( local i = 0; i < vals.length; i++ ) {
                    --(value3.msb & (byte)0xf) << 28 | (value2.msb & (byte)0x7f) << 21 | (value2.lsb & (byte)0x7f) << 14 | (value1.msb & (byte)0x7f) << 7 | (value1.lsb & (byte)0x7f)
                    local msb, lsb;
                    local v = vals[i];
                    lsb = (v & 0x7f);
                    v = v >> 7;
                    msb = (v & 0x7f);
                    v = v >> 7;
                    add.append( MidiParameterEnum.CVM_EXNM_ENV_DATA1, msb, lsb );
                    lsb = (v & 0x7f);
                    v = v >> 7;
                    msb = (v & 0x7f);
                    v = v >> 7;
                    add.append( MidiParameterEnum.CVM_EXNM_ENV_DATA2, msb, lsb );
                    msb = (v & 0xf);
                    add.append( MidiParameterEnum.CVM_EXNM_ENV_DATA3, msb );
                    add.append( MidiParameterEnum.CVM_EXNM_ENV_DATA_CONTINUATION, 0x00 );
                end
                add.append( MidiParameterEnum.CVM_EXNM_ENV_DATA_CONTINUATION, 0x7f );

                -- モジュレーション
                --ValuePair<Byte, Byte>
                local m;
                if( -100 <= ve.UstEvent.Moduration and ve.UstEvent.Moduration <= 100 )then
                    m = this.getMsbAndLsb( ve.UstEvent.Moduration + 100 );
                    add.append( MidiParameterEnum.CVM_EXNM_MODURATION, m.getKey(), m.getValue() );
                end

                -- 先行発声
                if( ve.UstEvent.PreUtterance ~= 0 )then
                    m = getMsbAndLsb( org.kbinani.PortUtil.castToInt( ve.UstEvent.PreUtterance + 8192 ) );
                    add.append( MidiParameterEnum.CVM_EXNM_PRE_UTTERANCE, m.getKey(), m.getValue() );
                end

                -- Flags
                if( ve.UstEvent.Flags ~= "" )then
                    add.append( MidiParameterEnum.CVM_EXNM_FLAGS_BYTES, ve.UstEvent.Flags.length );
                    for ( local i = 0; i < arr.length; i++ ) {
                        local b = ve.UstEvent.Flags.charAt( i );
                        add.append( MidiParameterEnum.CVM_EXNM_FLAGS, b );
                    end
                    add.append( MidiParameterEnum.CVM_EXNM_FLAGS_CONINUATION, 0x7f );
                end

                -- オーバーラップ
                if( ve.UstEvent.VoiceOverlap ~= 0 )then
                    m = this.getMsbAndLsb( org.kbinani.PortUtil.castToInt( ve.UstEvent.VoiceOverlap + 8192 ) );
                    add.append( MidiParameterEnum.CVM_EXNM_VOICE_OVERLAP, m.getKey(), m.getValue() );
                end
            end
        end
]]
    add:append( MidiParameterEnum.CVM_NM_NOTE_MESSAGE_CONTINUATION, 0x7f, true );-- (byte)0x7f(Note message continuation)
    return add;
end

---
-- 指定したシーケンスの指定したトラックから、NRPN のリストを作成する
-- @see <i>_generateNRPN_3</i>
-- <!--see _generateNRPN_5-->
-- @name <i>generateNRPN</i>
function Sequence.generateNRPN( ... )
    local arguments = { ... };
    if( #arguments == 3 )then
        return Sequence._generateNRPN_3( arguments[1], arguments[2], arguments[3] );
    elseif( #arguments == 5 )then
        return Sequence._generateNRPN_5( arguments[1], arguments[2], arguments[3], arguments[4], arguments[5] );
    end
end

--[[
    ---
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

---
-- 指定したシーケンスの指定したトラックから、NRPN のリストを作成する
-- @param vsq (Sequence) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table<NrpnEvent>) NrpnEvent の配列
-- @name <i>_generateNRPN_3</i>
function Sequence._generateNRPN_3( vsq, track, msPreSend )
    local list = {};--Vector<VsqNrpn>();

    local target = vsq.track:get( track );
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
        if( target.events:get( i ).clock <= vsq.totalClocks )then
            note_end = i;
            break;
        end
    end

    -- 最初の歌手を決める
    local singer_event = -1;
    for i = note_start, 0, -1 do
        if( target.events:get( i ).id.type == IdTypeEnum.Singer )then
            singer_event = i;
            break;
        end
    end
    if( singer_event >= 0 )then --見つかった場合
        Sequence._array_add_all( list, Sequence.generateSingerNRPN( vsq, target.events:get( singer_event ), 0 ) );
    else                   --多分ありえないと思うが、歌手が不明の場合。
        --throw new Exception( "first singer was not specified" );
        table.insert( list, NrpnEvent.new( 0, MidiParameterEnum.CC_BS_LANGUAGE_TYPE, 0x0 ) );
        table.insert( list, NrpnEvent.new( 0, MidiParameterEnum.PC_VOICE_TYPE, 0x0 ) );
    end

    Sequence._array_add_all( list, Sequence.generateVoiceChangeParameterNRPN( vsq, track, msPreSend ) );
    if( version:sub( 1, 4 ) == "DSB2" )then
        Sequence._array_add_all( list, Sequence.generateFx2DepthNRPN( vsq, track, msPreSend ) );
    end

    local ms_presend = msPreSend;
--[[
        if( version.substring( 0, 4 ) == "UTU0" )then
            local sec_maxlen = 0.0;
            for ( local itr = target.getNoteEventIterator(); itr:hasNext(); ) {
                local ve = itr:next();
                local len = vsq.getSecFromClock( ve.Clock + ve.ID.getLength() ) - vsq.getSecFromClock( ve.Clock );
                sec_maxlen = math.max( sec_maxlen, len );
            end
            ms_presend += org.kbinani.PortUtil.castToInt( sec_maxlen * 1000.0 );
        end
]]
    local dyn = target:getCurve( "dyn" );
    if( dyn:size() > 0 )then
        local listdyn = Sequence.generateExpressionNRPN( vsq, track, ms_presend );
        if( #listdyn > 0 )then
            Sequence._array_add_all( list, listdyn );
        end
    end
    local pbs = target:getCurve( "pbs" );
    if( pbs:size() > 0 )then
        local listpbs = Sequence.generatePitchBendSensitivityNRPN( vsq, track, ms_presend );
        if( #listpbs > 0 )then
            Sequence._array_add_all( list, listpbs );
        end
    end
    local pit = target:getCurve( "pit" );
    if( pit:size() > 0 )then
        local listpit = Sequence.generatePitchBendNRPN( vsq, track, ms_presend );
        if( #listpit > 0 )then
            Sequence._array_add_all( list, listpit );
        end
    end

    local first = true;
    local last_note_end = 0;
    for i = note_start, note_end, 1 do
        local item = target.events:get( i );
        if( item.id.type == IdTypeEnum.Anote )then
            local note_loc = 0x03;
            if( item.clock == last_note_end )then
                note_loc = note_loc - 0x02;
            end

            -- 次に現れる音符イベントを探す
            local nextclock = item.clock + item.id:getLength() + 1;
            local event_count = target.events:size();
            local j;
            for j = i + 1, event_count - 1, 1 do
                local itemj = target.events:get( j );
                if( itemj.id.type == IdTypeEnum.Anote )then
                    nextclock = itemj.clock;
                    break;
                end
            end
            if( item.clock + item.id:getLength() == nextclock )then
                note_loc = note_loc - 0x01;
            end

            table.insert(
                list,
                Sequence.generateNoteNRPN(
                    vsq,
                    track,
                    item,
                    msPreSend,
                    note_loc,
                    first
                )
            );
            first = false;
            Sequence._array_add_all(
                list,
                Sequence.generateVibratoNRPN(
                    vsq,
                    item,
                    msPreSend
                )
            );
            last_note_end = item.clock + item.id:getLength();
        elseif( item.id.type == IdTypeEnum.Singer )then
            if( i > note_start and i ~= singer_event )then
                Sequence._array_add_all(
                    list,
                    Sequence.generateSingerNRPN( vsq, item, msPreSend )
                );
            end
        end
    end

    table.sort( list, NrpnEvent.compare );
    local merged = {};--Vector<VsqNrpn>();
    for i = 1, #list, 1 do
        Sequence._array_add_all( merged, list[i]:expand() );
    end
    return merged;
end

---
-- 指定したシーケンスの指定したトラックから、PitchBend の NRPN リストを作成する
-- @param vsq (Sequence) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table<NrpnEvent>) NrpnEvent の配列
-- @name <i>generatePitchBendNRPN</i>
function Sequence.generatePitchBendNRPN( vsq, track, msPreSend )
    local ret = {};--Vector<VsqNrpn>();
    local pit = vsq.track:get( track ):getCurve( "PIT" );
    local count = pit:size();
    local i;
    for i = 0, count - 1, 1 do
        local clock = pit:getKeyClock( i );
        local value = pit:getValue( i ) + 0x2000;

        local msb, lsb = Sequence.getMsbAndLsb( value );
        local c = clock - vsq:getPresendClockAt( clock, msPreSend );
        if( c >= 0 )then
            local add = NrpnEvent.new(
                c,
                MidiParameterEnum.PB_PITCH_BEND,
                msb,
                lsb
            );
            table.insert( ret, add );
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

---
-- 指定したシーケンスの指定したトラックから、PitchBendSensitivity の NRPN リストを作成する
-- @param vsq (Sequence) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table<NrpnEvent>) NrpnEvent の配列
-- @name <i>generatePitchBendSensitivityNRPN</i>
function Sequence.generatePitchBendSensitivityNRPN( vsq, track, msPreSend )
    local ret = {};-- Vector<VsqNrpn>();
    local pbs = vsq.track:get( track ):getCurve( "PBS" );
    local count = pbs:size();
    local i;
    for i = 0, count - 1, 1 do
        local clock = pbs:getKeyClock( i );
        local c = clock - vsq:getPresendClockAt( clock, msPreSend );
        if( c >= 0 )then
            local add = NrpnEvent.new(
                c,
                MidiParameterEnum.CC_PBS_PITCH_BEND_SENSITIVITY,
                pbs:getValue( i ),
                0x00
            );
            table.insert( ret, add );
        end
    end
    return ret;
end

---
-- トラックの音符イベントから、ビブラート出力用の NRPN のリストを作成する
-- @param vsq (Sequence) 出力元のシーケンス
-- @param ve (Event) 出力する音符イベント
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table<NrpnEvent>) NrpnEvent の配列
-- @name <i>generateVibratoNRPN</i>
function Sequence.generateVibratoNRPN( vsq, ve, msPreSend )
    local ret = {};--Vector<VsqNrpn>();
    if( ve.id.vibratoHandle ~= nil )then
        local vclock = ve.clock + ve.id.vibratoDelay;
        local delayMSB, delayLSB = Sequence.getMsbAndLsb( msPreSend );
        local add2 = NrpnEvent.new(
            vclock - vsq:getPresendClockAt( vclock, msPreSend ),
            MidiParameterEnum.CC_VD_VERSION_AND_DEVICE,
            0x00,
            0x00
        );
        add2:append( MidiParameterEnum.CC_VD_DELAY, delayMSB, delayLSB, true );
        add2:append( MidiParameterEnum.CC_VD_VIBRATO_DEPTH, ve.id.vibratoHandle:getStartDepth(), true );
        add2:append( MidiParameterEnum.CC_VR_VIBRATO_RATE, ve.id.vibratoHandle:getStartRate() );
        table.insert( ret, add2 );
        local vlength = ve.id:getLength() - ve.id.vibratoDelay;
        local rateBP = ve.id.vibratoHandle:getRateBP();
        local count = rateBP:size();
        if( count > 0 )then
            local i;
            for i = 0, count - 1, 1 do
                local itemi = rateBP:get( i );
                local percent = itemi.x;
                local cl = vclock + math.floor( percent * vlength );
                table.insert(
                    ret,
                    NrpnEvent.new(
                        cl - vsq:getPresendClockAt( cl, msPreSend ),
                        MidiParameterEnum.CC_VR_VIBRATO_RATE,
                        itemi.y
                    )
                );
            end
        end
        local depthBP = ve.id.vibratoHandle:getDepthBP();
        count = depthBP:size();
        if( count > 0 )then
            local i;
            for i = 0, count - 1, 1 do
                local itemi = depthBP:get( i );
                local percent = itemi.x;
                local cl = vclock + math.floor( percent * vlength );
                table.insert(
                    ret,
                    NrpnEvent.new(
                        cl - vsq:getPresendClockAt( cl, msPreSend ),
                        MidiParameterEnum.CC_VD_VIBRATO_DEPTH,
                        itemi.y
                    )
                );
            end
        end
    end
    table.sort( ret, NrpnEvent.compare );--Collections.sort( ret );
    return ret;
end

---
-- 指定したシーケンスの指定したトラックから、VoiceChangeParameter の NRPN リストを作成する
-- @param vsq (Sequence) 出力元のシーケンス
-- @param track (integer) 出力するトラックの番号
-- @param msPreSend (integer) ミリ秒単位のプリセンド時間
-- @return (table<NrpnEvent>) NrpnEvent の配列
-- @name <i>generateVoiceChangeParameterNRPN</i>
function Sequence.generateVoiceChangeParameterNRPN( vsq, track, msPreSend )
    local premeasure_clock = vsq:getPreMeasureClocks();
    local renderer = vsq.track:get( track ).common.version;
    local res = {};--Vector<VsqNrpn>();

    --String[]
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

    local i;
    for i = 1, #curves, 1 do
        local vbpl = vsq.track:get( track ):getCurve( curves[i] );
        if( vbpl:size() > 0 )then
            local lsb = MidiParameterEnum.getVoiceChangeParameterId( curves[i] );
            local count = vbpl:size();
            local j;
            for j = 0, count - 1, 1 do
                local clock = vbpl:getKeyClock( j );
                local c = clock - vsq:getPresendClockAt( clock, msPreSend );
                if( c >= 0 )then
                    local add = NrpnEvent.new(
                        c,
                        MidiParameterEnum.VCP_VOICE_CHANGE_PARAMETER_ID,
                        lsb
                    );
                    add:append( MidiParameterEnum.VCP_VOICE_CHANGE_PARAMETER, vbpl:getValue( j ), true );
                    table.insert( res, add );
                end
            end
        end
    end
    table.sort( res, NrpnEvent.compare );--Collections.sort( res );
    return res;
end

---
-- DATA の値を MSB と LSB に分解する
-- @param value (integer) 分解する値
-- @return (integer) MSB の値
-- @return (integer) LSB の値
-- @name <i>getMsbAndLsb</i>
function Sequence.getMsbAndLsb( value )
    if( 0x3fff < value )then
        return 0x7f, 0x7f;
    else
        local msb = Util.rshift( value, 7 );
        return msb, value - Util.lshift( msb, 7 );
    end
end

---
-- "DM:0001:"といった、VSQメタテキストの行の先頭につくヘッダー文字列のバイト列表現を取得する
-- @param count (integer) ヘッダーの番号
-- @return (table<integer>) バイト列
-- @name <i>getLinePrefixBytes</i>
function Sequence.getLinePrefixBytes( count )
    local digits = Sequence.getHowManyDigits( count );
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

---
-- 数値の 10 進数での桁数を取得する
-- @param number (integer) 検査対象の数値
-- @return (integer) 数値の 10 進数での桁数
-- @name <i>getHowManyDigits</i>
function Sequence.getHowManyDigits( number )
    number = math.abs( number );
    if( number == 0 )then
        return 1;
    else
        return math.floor( math.log10( number ) ) + 1;
    end
end

---
-- 16 ビットの unsigned int 値をビッグエンディアンでストリームに書きこむ
-- @param stream (? extends OutputStream) 出力先のストリーム
-- @param data (integer) 出力する値
-- @name <i>writeUnsignedShort</i>
function Sequence.writeUnsignedShort( stream, data )
    local dat = Util.getBytesUInt16BE( data );
    stream:write( dat, 1, #dat );
end

---
-- 32 ビットの unsigned int 値をビッグエンディアンでストリームに書きこむ
-- @param fs (? extends OutputStram) 出力先のストリーム
-- @param data (integer) 出力する値
-- @name <i>writeUnsignedInt</i>
function Sequence.writeUnsignedInt( fs, data )
    local dat = Util.getBytesUInt32BE( data );
    fs:write( dat, 1, #dat );
end
