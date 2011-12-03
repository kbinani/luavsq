require( "lunit" );
dofile( "../Sequence.lua" );
dofile( "../List.lua" );
dofile( "../Track.lua" );
dofile( "../Common.lua" );
dofile( "../DynamicsModeEnum.lua" );
dofile( "../PlayModeEnum.lua" );
dofile( "../BPList.lua" );
dofile( "../EventList.lua" );
dofile( "../EventTypeEnum.lua" );
dofile( "../Event.lua" );
dofile( "../Master.lua" );
dofile( "../Mixer.lua" );
dofile( "../MixerItem.lua" );
dofile( "../TimesigTable.lua" );
dofile( "../TimesigTableItem.lua" );
dofile( "../TempoTable.lua" );
dofile( "../TempoTableItem.lua" );
dofile( "../ByteArrayOutputStream.lua" );
dofile( "../Util.lua" );
dofile( "../MidiEvent.lua" );
dofile( "../CP932Converter.lua" );
dofile( "../TextStream.lua" );
dofile( "../EventList.Iterator.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleTypeEnum.lua" );
dofile( "../VoiceLanguageEnum.lua" );
dofile( "../NrpnEvent.lua" );
dofile( "../MidiParameterEnum.lua" );
dofile( "../ArticulationTypeEnum.lua" );
dofile( "../Lyric.lua" );
dofile( "../PhoneticSymbol.lua" );
dofile( "../BP.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../VibratoBP.lua" );
module( "SequenceTest", package.seeall, lunit.testcase );

---
-- 指定されたシーケンスがデフォルトのシーケンスと等しいかどうかを検査する
function isEqualToDefaultSequence( sequence )
    assert_equal( 1 * 480 * 4 / 4 * 4, sequence:getTotalClocks() );

    -- track
    assert_equal( 2, sequence.track:size() );
    -- 第1トラック, master track
    local track0 = sequence.track[0];
    assert_nil( track0.common );
    assert_nil( track0._pit );
    assert_nil( track0._pbs );
    assert_nil( track0._dyn );
    assert_nil( track0._bre );
    assert_nil( track0._bri );
    assert_nil( track0._cle );
    assert_nil( track0._reso1FreqBPList );
    assert_nil( track0._reso2FreqBPList );
    assert_nil( track0._reso3FreqBPList );
    assert_nil( track0._reso4FreqBPList );
    assert_nil( track0._reso1BWBPList );
    assert_nil( track0._reso2BWBPList );
    assert_nil( track0._reso3BWBPList );
    assert_nil( track0._reso4BWBPList );
    assert_nil( track0._reso1AmpBPList );
    assert_nil( track0._reso2AmpBPList );
    assert_nil( track0._reso3AmpBPList );
    assert_nil( track0._reso4AmpBPList );
    assert_nil( track0._harmonics );
    assert_nil( track0._fx2depth );
    assert_nil( track0._gen );
    assert_nil( track0._por );
    assert_nil( track0._ope );
    assert_nil( track0._pitch );
    assert_nil( track0.events );
    assert_equal( "", track0.tag );
    -- 第2トラック, 普通のトラック
    local track1 = sequence.track[1];
    assert_not_nil( track1.common );
    assert_not_nil( track1._pit );
    assert_not_nil( track1._pbs );
    assert_not_nil( track1._dyn );
    assert_not_nil( track1._bre );
    assert_not_nil( track1._bri );
    assert_not_nil( track1._cle );
    assert_not_nil( track1._reso1FreqBPList );
    assert_not_nil( track1._reso2FreqBPList );
    assert_not_nil( track1._reso3FreqBPList );
    assert_not_nil( track1._reso4FreqBPList );
    assert_not_nil( track1._reso1BWBPList );
    assert_not_nil( track1._reso2BWBPList );
    assert_not_nil( track1._reso3BWBPList );
    assert_not_nil( track1._reso4BWBPList );
    assert_not_nil( track1._reso1AmpBPList );
    assert_not_nil( track1._reso2AmpBPList );
    assert_not_nil( track1._reso3AmpBPList );
    assert_not_nil( track1._reso4AmpBPList );
    assert_not_nil( track1._harmonics );
    assert_not_nil( track1._fx2depth );
    assert_not_nil( track1._gen );
    assert_not_nil( track1._por );
    assert_not_nil( track1._ope );
    assert_not_nil( track1._pitch );
    assert_not_nil( track1.events );
    assert_equal( "", track1.tag );
    assert_equal( 1, track1.events:size() );
    assert_equal( 0, track1.events:get( 0 ).clock );
    assert_equal( luavsq.EventTypeEnum.Singer, track1.events:get( 0 ).type );

    -- master
    assert_equal( 1, sequence.master.preMeasure );

    -- mixer
    assert_equal( 0, sequence.mixer.masterFeder );
    assert_equal( 0, sequence.mixer.masterMute );
    assert_equal( 0, sequence.mixer.masterPanpot );
    assert_equal( 0, sequence.mixer.outputMode );
    -- mixer.slave
    assert_equal( 1, #sequence.mixer.slave );
    assert_equal( 0, sequence.mixer.slave[1].feder );
    assert_equal( 0, sequence.mixer.slave[1].panpot );
    assert_equal( 0, sequence.mixer.slave[1].mute );
    assert_equal( 0, sequence.mixer.slave[1].solo );

    -- timesigTable
    assert_equal( 1, sequence.timesigTable:size() );
    assert_equal( 0, sequence.timesigTable:get( 0 ):getTick() );
    assert_equal( 4, sequence.timesigTable:get( 0 ).denominator );
    assert_equal( 4, sequence.timesigTable:get( 0 ).numerator );
    assert_equal( 0, sequence.timesigTable:get( 0 ).barCount );

    -- tempoTable
    assert_equal( 1, sequence.tempoTable:size() );
    assert_equal( 0, sequence.tempoTable:get( 0 ).clock );
    assert_equal( 500000, sequence.tempoTable:get( 0 ).tempo );
    assert_equal( 0.0, sequence.tempoTable:get( 0 ):getTime() );
end

function test()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local note = luavsq.Event.new( 1920, luavsq.EventTypeEnum.Anote );
    note.note = 60;
    note:setLength( 480 );
    note.lyricHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Lyric );
    note.lyricHandle:setLyricAt( 0, luavsq.Lyric.new( "あ", "a" ) );
    sequence.track:get( 1 ).events:add( note );
    local fileHandle = io.open( "foo.vsq", "wb" );
    fileHandle:write( sequence:write( 500, "Shift_JIS" ) );
    fileHandle:close();
    fail();
end

function testConstruct()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    isEqualToDefaultSequence( sequence );
end

function testClone()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local copy = sequence:clone();
    isEqualToDefaultSequence( copy );
end

function testGetBaseTempo()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    assert_equal( 500000, sequence:getBaseTempo() );
end

function testGetPreMeasure()
    local preMeasure = 1;
    local sequence = luavsq.Sequence.new( "Miku", preMeasure, 4, 4, 500000 );
    assert_equal( preMeasure, sequence:getPreMeasure() );
end

function testGetPreMeasureClocks()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    assert_equal( 1920, sequence:getPreMeasureClocks() );
end

function testGetTickPerQuarter()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    assert_equal( 480, sequence:getTickPerQuarter() );
end

function testUpdateTotalClocks()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    assert_equal( 1 * 480 * 4 / 4 * 4, sequence:getTotalClocks() );
    local note = luavsq.Event.new( 1920, luavsq.EventTypeEnum.Anote );
    note:setLength( 480 );
    note.note = 60;
    sequence.track[1].events:add( note );
    sequence:updateTotalClocks();
    assert_equal( 2400, sequence:getTotalClocks() );
end

function testGenerateMetaTextEventWithoutPitch()
    fail();
end

function testGenerateMetaTextEventWithPitch()
--    fail();
end

function testGetActualClockAndDelay()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local actualClock, delay;

    actualClock, delay = sequence:getActualClockAndDelay( 1920, 500 );
    assert_equal( 1440, actualClock );
    assert_equal( 500, delay );

    actualClock, delay = sequence:getActualClockAndDelay( 1920, 499 );
    assert_equal( 1440, actualClock );
    assert_equal( 500, delay );

    actualClock, delay = sequence:getActualClockAndDelay( 1920, 498 );
    assert_equal( 1441, actualClock );
    assert_equal( 498, delay );
end

function testGetMaximumNoteLengthAt()
--    fail();
end

function testGenerateTimeSig()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    sequence.timesigTable = luavsq.TimesigTable.new();
    sequence.timesigTable:push( luavsq.TimesigTableItem.new( 4, 4, 0 ) );
    sequence.timesigTable:push( luavsq.TimesigTableItem.new( 6, 8, 1 ) );
    sequence.timesigTable:updateTimesigInfo();

    local actual = sequence:generateTimeSig();

    assert_equal( 2, #actual );
    local item = actual[1];
    assert_equal( 0, item.clock );
    assert_equal( 0xff, item.firstByte );
    assert_equal( 5, #item.data );
    assert_equal( 0x58, item.data[1] );
    assert_equal( 4, item.data[2] );
    assert_equal( 2, item.data[3] );
    assert_equal( 0x18, item.data[4] );
    assert_equal( 0x08, item.data[5] );

    item = actual[2];
    assert_equal( 1920, item.clock );
    assert_equal( 0xff, item.firstByte );
    assert_equal( 5, #item.data );
    assert_equal( 0x58, item.data[1] );
    assert_equal( 6, item.data[2] );
    assert_equal( 3, item.data[3] );
    assert_equal( 0x18, item.data[4] );
    assert_equal( 0x08, item.data[5] );
end

function testGenerateTempoChange()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    sequence.tempoTable = luavsq.TempoTable.new();
    sequence.tempoTable:push( luavsq.TempoTableItem.new( 0, 500000 ) );
    sequence.tempoTable:push( luavsq.TempoTableItem.new( 1920, 600000 ) );
    sequence.tempoTable:updateTempoInfo();

    local actual = sequence:generateTempoChange();

    assert_equal( 2, #actual );
    local item = actual[1];
    assert_equal( 0, item.clock );
    assert_equal( 0xff, item.firstByte );
    assert_equal( 4, #item.data );
    assert_equal( 0x51, item.data[1] );
    assert_equal( 0x07, item.data[2] );
    assert_equal( 0xA1, item.data[3] );
    assert_equal( 0x20, item.data[4] );

    item = actual[2];
    assert_equal( 1920, item.clock );
    assert_equal( 0xff, item.firstByte );
    assert_equal( 4, #item.data );
    assert_equal( 0x51, item.data[1] );
    assert_equal( 0x09, item.data[2] );
    assert_equal( 0x27, item.data[3] );
    assert_equal( 0xc0, item.data[4] );
end

function testWriteWithoutPitch()
    fail();
end

function testWriteWithPitch()
--    fail();
end

function testPrintTrack()
    fail();
end

function testGenerateExpressionNRPN()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local dynamics = sequence.track:get( 1 ):getCurve( "DYN" );
    dynamics:add( 480, 127 );
    dynamics:add( 1920, 0 );

    local actual = luavsq.Sequence.generateExpressionNRPN( sequence, 1, 500 );
    assert_equal( 3, #actual );

    assert_equal( 0, actual[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CC_E_DELAY, actual[1].nrpn );
    assert_equal( 0x03, actual[1].dataMSB );
    assert_equal( 0x74, actual[1].dataLSB );
    assert_true( actual[1].hasLSB );
    assert_false( actual[1].isMSBOmittingRequired );

    assert_equal( 0, actual[2].clock );
    assert_equal( luavsq.MidiParameterEnum.CC_E_EXPRESSION, actual[2].nrpn );
    assert_equal( 127, actual[2].dataMSB );
    assert_false( actual[2].hasLSB );
    assert_false( actual[2].isMSBOmittingRequired );

    assert_equal( 1440, actual[3].clock );
    assert_equal( luavsq.MidiParameterEnum.CC_E_EXPRESSION, actual[3].nrpn );
    assert_equal( 0, actual[3].dataMSB );
    assert_false( actual[3].hasLSB );
    assert_false( actual[3].isMSBOmittingRequired );
end

function testGenerateFx2DepthNRPN()
--    fail();
end

function testGenerateHeaderNRPN()
    local actual = luavsq.Sequence.generateHeaderNRPN():expand();
    assert_equal( 3, #actual );

    assert_equal( 0, actual[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CC_BS_VERSION_AND_DEVICE, actual[1].nrpn );
    assert_equal( 0x00, actual[1].dataMSB );
    assert_equal( 0x00, actual[1].dataLSB );
    assert_true( actual[1].hasLSB );
    assert_false( actual[1].isMSBOmittingRequired );

    assert_equal( 0, actual[2].clock );
    assert_equal( luavsq.MidiParameterEnum.CC_BS_DELAY, actual[2].nrpn );
    assert_equal( 0x00, actual[2].dataMSB );
    assert_equal( 0x00, actual[2].dataLSB );
    assert_true( actual[2].hasLSB );
    assert_false( actual[2].isMSBOmittingRequired );

    assert_equal( 0, actual[3].clock );
    assert_equal( luavsq.MidiParameterEnum.CC_BS_LANGUAGE_TYPE, actual[3].nrpn );
    assert_equal( 0x00, actual[3].dataMSB );
    assert_false( actual[3].hasLSB );
    assert_false( actual[3].isMSBOmittingRequired );
end

function testGenerateSingerNRPN()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local singerEvent = luavsq.Event.new( 1920, luavsq.EventTypeEnum.Singer );
    singerEvent.singerHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Singer );
    sequence.track:get( 1 ).events:add( singerEvent );
    local actual = luavsq.Sequence.generateSingerNRPN( sequence, singerEvent, 500 );

    assert_equal( 1, #actual );
    local actualExpanded = actual[1]:expand();

    assert_equal( 4, #actualExpanded );
    local item = actualExpanded[1];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_BS_VERSION_AND_DEVICE, item.nrpn );
    assert_equal( 0x00, item.dataMSB );
    assert_equal( 0x00, item.dataLSB );
    assert_true( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );

    item = actualExpanded[2];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_BS_DELAY, item.nrpn );
    assert_equal( 0x03, item.dataMSB );
    assert_equal( 0x74, item.dataLSB );
    assert_true( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );

    item = actualExpanded[3];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_BS_LANGUAGE_TYPE, item.nrpn );
    assert_equal( singerEvent.singerHandle.language, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );

    item = actualExpanded[4];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.PC_VOICE_TYPE, item.nrpn );
    assert_equal( singerEvent.singerHandle.program, item.dataMSB );
    assert_false( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );
end

function testGenerateNoteNRPN()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local noteEvent = luavsq.Event.new( 1920, luavsq.EventTypeEnum.Anote );
    noteEvent:setLength( 480 );
    noteEvent.note = 60;
    noteEvent.dynamics = 127;
    noteEvent.pmBendDepth = 8;
    noteEvent.pmBendLength = 0;
    noteEvent.d4mean = 63;
    noteEvent.pMeanOnsetFirstNote = 65;
    noteEvent.vMeanNoteTransition = 66;
    noteEvent.pMeanEndingNote = 67;
    noteEvent.pmbPortamentoUse = 3;
    noteEvent.demDecGainRate = 50;
    noteEvent.demAccent = 50;
    noteEvent.vibratoDelay = 240;
    noteEvent.vibratoHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    noteEvent.vibratoHandle:setLength( 240 );
    noteEvent.vibratoHandle.iconId = "$04040005";
    noteEvent.lyricHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Lyric );
    noteEvent.lyricHandle:setLyricAt( 0, luavsq.Lyric.new( "あ", "a" ) );
    sequence.track:get( 1 ).common.version = "DSB3";

    -- lastDelay が nil であるために、CVM_NM_VERSION_AND_DEVICE が出力されるケース
    local lastDelay = nil;
    local noteLocation = 1;
    local msPreSend = 500;
    local track = 1;
    local actual, delay = luavsq.Sequence.generateNoteNRPN( sequence, track, noteEvent, msPreSend, noteLocation, lastDelay );
    local actualExpanded = actual:expand();
    assert_equal( 24, #actualExpanded );
    assert_equal( 500, delay );
    local item = actualExpanded[1];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VERSION_AND_DEVICE, item.nrpn );
    assert_equal( 0x00, item.dataMSB );
    assert_equal( 0x00, item.dataLSB );
    assert_true( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );
    item = actualExpanded[2];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_DELAY, item.nrpn );
    assert_equal( 0x03, item.dataMSB );
    assert_equal( 0x74, item.dataLSB );
    assert_true( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[3];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_NOTE_NUMBER, item.nrpn );
    assert_equal( 60, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[4];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, item.nrpn );
    assert_equal( 127, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[5];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_NOTE_DURATION, item.nrpn );
    assert_equal( 0x03, item.dataMSB );
    assert_equal( 0x74, item.dataLSB );
    assert_true( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[6];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_NOTE_LOCATION, item.nrpn );
    assert_equal( 1, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[7];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_INDEX_OF_VIBRATO_DB, item.nrpn );
    assert_equal( 0x00, item.dataMSB );
    assert_equal( 0x00, item.dataLSB );
    assert_true( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[8];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VIBRATO_CONFIG, item.nrpn );
    assert_equal( 5, item.dataMSB );
    assert_equal( 63, item.dataLSB );
    assert_true( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[9];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VIBRATO_DELAY, item.nrpn );
    assert_equal( 64, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[10];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL_BYTES, item.nrpn );
    assert_equal( 1, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[11];
    assert_equal( 1440, item.clock );
    assert_equal( 0x5013, item.nrpn );
    assert_equal( string.byte( "a" ), item.dataMSB );
    assert_equal( 0, item.dataLSB );
    assert_true( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[12];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL_CONTINUATION, item.nrpn );
    assert_equal( 0x7f, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[13];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_V1MEAN, item.nrpn );
    assert_equal( 4, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[14];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_D1MEAN, item.nrpn );
    assert_equal( 8, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[15];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_D1MEAN_FIRST_NOTE, item.nrpn );
    assert_equal( 0x14, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[16];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_D2MEAN, item.nrpn );
    assert_equal( 28, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[17];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_D4MEAN, item.nrpn );
    assert_equal( 63, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[18];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_PMEAN_ONSET_FIRST_NOTE, item.nrpn );
    assert_equal( 65, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[19];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VMEAN_NOTE_TRNSITION, item.nrpn );
    assert_equal( 66, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[20];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_PMEAN_ENDING_NOTE, item.nrpn );
    assert_equal( 67, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[21];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_ADD_PORTAMENTO, item.nrpn );
    assert_equal( 3, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[22];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_CHANGE_AFTER_PEAK, item.nrpn );
    assert_equal( 50, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[23];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_ACCENT, item.nrpn );
    assert_equal( 50, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[24];
    assert_equal( 1440, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_NOTE_MESSAGE_CONTINUATION, item.nrpn );
    assert_equal( 0x7f, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );

    --lastDelay が nil でないために、CVM_NM_VERSION_AND_DEVICE が出力されないパターン
    lastDelay = 0;
    actual, delay = luavsq.Sequence.generateNoteNRPN( sequence, track, noteEvent, msPreSend, noteLocation, lastDelay );
    actualExpanded = actual:expand();
    assert_equal( 23, #actualExpanded );
    assert_equal( 500, delay );

    -- lastDelay が、該当音符についての delay と同じであるために、CVM_NM_DELAY が出力されないパターン
    lastDelay = 500;
    actual, delay = luavsq.Sequence.generateNoteNRPN( sequence, track, noteEvent, msPreSend, noteLocation, lastDelay );
    actualExpanded = actual:expand();
    assert_equal( 22, #actualExpanded );
    assert_equal( 500, delay );

    -- vibratoHandle が nil であるために、CVM_NM_INDEX_OF_VIBRATO_DB, CVM_NM_VIBRATO_CONFIG, CVM_NM_VIBRATO_DELAY
    -- が出力されないパターン
    lastDelay = 500;
    noteEvent.vibratoHandle = nil;
    actual, delay = luavsq.Sequence.generateNoteNRPN( sequence, track, noteEvent, msPreSend, noteLocation, lastDelay );
    actualExpanded = actual:expand();
    assert_equal( 19, #actualExpanded );
    assert_equal( 500, delay );

    sequence.track:get( 1 ).common.version = "DSB2";
    -- VOCALOID1 であるために、0x5011が出力され、CVM_NM_PHONETIC_SYMBOL_CONTINUATIONとVOCALOID2用のNRPNが出力されない
    lastDelay = 500;
    noteEvent.vibratoHandle = nil;
    actual, delay = luavsq.Sequence.generateNoteNRPN( sequence, track, noteEvent, msPreSend, noteLocation, lastDelay );
    actualExpanded = actual:expand();
    assert_equal( 8, #actualExpanded );
    item = actualExpanded[5];
    assert_equal( 1440, item.clock );
    assert_equal( 0x5011, item.nrpn );
    assert_equal( 0x01, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
end

function testGenerateNRPNAll()
    fail();
end

function testGenerateNRPNPartial()
--    fail();
end

function testGeneratePitchBendNRPN()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local pit = sequence.track:get( 1 ):getCurve( "PIT" );
    pit:add( 480, 8191 );
    pit:add( 1920, -8192 );

    local actual = luavsq.Sequence.generatePitchBendNRPN( sequence, 1, 500 );
    assert_equal( 3, #actual );

    assert_equal( 0, actual[1].clock );
    assert_equal( luavsq.MidiParameterEnum.PB_DELAY, actual[1].nrpn );
    assert_equal( 0x03, actual[1].dataMSB );
    assert_equal( 0x74, actual[1].dataLSB );
    assert_true( actual[1].hasLSB );
    assert_false( actual[1].isMSBOmittingRequired );

    assert_equal( 0, actual[2].clock );
    assert_equal( luavsq.MidiParameterEnum.PB_PITCH_BEND, actual[2].nrpn );
    assert_equal( 0x7F, actual[2].dataMSB );
    assert_equal( 0x7F, actual[2].dataLSB );
    assert_true( actual[2].hasLSB );
    assert_false( actual[2].isMSBOmittingRequired );

    assert_equal( 1440, actual[3].clock );
    assert_equal( luavsq.MidiParameterEnum.PB_PITCH_BEND, actual[3].nrpn );
    assert_equal( 0x00, actual[3].dataMSB );
    assert_equal( 0x00, actual[3].dataLSB );
    assert_true( actual[3].hasLSB );
    assert_false( actual[3].isMSBOmittingRequired );
end

function test_array_add_all()
    local a = { 1, 2 };
    local b = { 3, 4, 5 };
    luavsq.Sequence._array_add_all( a, b );
    assert_equal( 5, #a );
    assert_equal( 3, #b );
    assert_equal( 1, a[1] );
    assert_equal( 2, a[2] );
    assert_equal( 3, a[3] );
    assert_equal( 4, a[4] );
    assert_equal( 5, a[5] );
end

function testGeneratePitchBendSensitivityNRPN()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local pbs = sequence.track:get( 1 ):getCurve( "PBS" );
    pbs:add( 480, 0 );
    pbs:add( 1920, 24 );

    local actual = luavsq.Sequence.generatePitchBendSensitivityNRPN( sequence, 1, 500 );
    assert_equal( 3, #actual );

    assert_equal( 0, actual[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CC_PBS_DELAY, actual[1].nrpn );
    assert_equal( 0x03, actual[1].dataMSB );
    assert_equal( 0x74, actual[1].dataLSB );
    assert_true( actual[1].hasLSB );
    assert_false( actual[1].isMSBOmittingRequired );

    assert_equal( 0, actual[2].clock );
    assert_equal( luavsq.MidiParameterEnum.CC_PBS_PITCH_BEND_SENSITIVITY, actual[2].nrpn );
    assert_equal( 0, actual[2].dataMSB );
    assert_equal( 0x00, actual[2].dataLSB );
    assert_true( actual[2].hasLSB );
    assert_false( actual[2].isMSBOmittingRequired );

    assert_equal( 1440, actual[3].clock );
    assert_equal( luavsq.MidiParameterEnum.CC_PBS_PITCH_BEND_SENSITIVITY, actual[3].nrpn );
    assert_equal( 24, actual[3].dataMSB );
    assert_equal( 0x00, actual[3].dataLSB );
    assert_true( actual[3].hasLSB );
    assert_false( actual[3].isMSBOmittingRequired );
end

function testGenerateVibratoNRPN()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local noteEvent = luavsq.Event.new( 480, luavsq.EventTypeEnum.Anote );
    noteEvent.vibratoHandle = nil;

    -- ビブラートがないため、NRPN が生成されない場合
    local actual = luavsq.Sequence.generateVibratoNRPN( sequence, noteEvent, 500 );
    assert_equal( 0, #actual );

    -- ビブラートがある場合
    noteEvent.vibratoHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    noteEvent:setLength( 480 );
    noteEvent.vibratoDelay = 240;
    noteEvent.vibratoHandle:setLength( 240 );
    noteEvent.vibratoHandle:setStartDepth( 71 );
    noteEvent.vibratoHandle:setStartRate( 72 );
    local rateCurve = luavsq.VibratoBPList.new( { 0.5, 1.0 }, { 11, 12 } );
    local depthCurve = luavsq.VibratoBPList.new( { 0.4, 0.9 }, { 13, 14 } );
    noteEvent.vibratoHandle:setRateBP( rateCurve );
    noteEvent.vibratoHandle:setDepthBP( depthCurve );
    actual = luavsq.Sequence.generateVibratoNRPN( sequence, noteEvent, 500 );
    assert_equal( 5, #actual );

    local actualExpanded = actual[1]:expand();
    assert_equal( 4, #actualExpanded );
    local item = actualExpanded[1];
    assert_equal( 240, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VD_VERSION_AND_DEVICE, item.nrpn );
    assert_equal( 0x00, item.dataMSB );
    assert_equal( 0x00, item.dataLSB );
    assert_true( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );
    item = actualExpanded[2];
    assert_equal( 240, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VD_DELAY, item.nrpn );
    assert_equal( 0x03, item.dataMSB );
    assert_equal( 0x74, item.dataLSB );
    assert_true( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[3];
    assert_equal( 240, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VD_VIBRATO_DEPTH, item.nrpn );
    assert_equal( 71, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );
    item = actualExpanded[4];
    assert_equal( 240, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VR_VIBRATO_RATE, item.nrpn );
    assert_equal( 72, item.dataMSB );
    assert_false( item.hasLSB );
    assert_true( item.isMSBOmittingRequired );

    actualExpanded = actual[2]:expand();
    assert_equal( 2, #actualExpanded );
    item = actualExpanded[1];
    assert_equal( 336, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VD_DELAY, item.nrpn );
    assert_equal( 0x03, item.dataMSB );
    assert_equal( 0x74, item.dataLSB );
    assert_true( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );
    item = actualExpanded[2];
    assert_equal( 336, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VD_VIBRATO_DEPTH, item.nrpn );
    assert_equal( 13, item.dataMSB );
    assert_false( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );

    item = actual[3];
    actualExpanded = item:expand();
    assert_equal( 2, #actualExpanded );
    item = actualExpanded[1];
    assert_equal( 360, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VR_DELAY, item.nrpn );
    assert_equal( 0x03, item.dataMSB );
    assert_equal( 0x74, item.dataLSB );
    assert_true( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );
    item = actualExpanded[2];
    assert_equal( 360, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VR_VIBRATO_RATE, item.nrpn );
    assert_equal( 11, item.dataMSB );
    assert_false( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );

    item = actual[4];
    assert_equal( 456, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VD_VIBRATO_DEPTH, item.nrpn );
    assert_equal( 14, item.dataMSB );
    assert_false( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );

    item = actual[5];
    assert_equal( 480, item.clock );
    assert_equal( luavsq.MidiParameterEnum.CC_VR_VIBRATO_RATE, item.nrpn );
    assert_equal( 12, item.dataMSB );
    assert_false( item.hasLSB );
    assert_false( item.isMSBOmittingRequired );
end

function testGenerateVoiceChangeParameterNRPN()
    fail();
end

function testGetMsbAndLsb()
    local msb, lsb;
    msb, lsb = luavsq.Sequence.getMsbAndLsb( 264 );
    assert_equal( 2, msb );
    assert_equal( 8, lsb );
end

function testGetLinePrefixBytes()
    -- 4 桁
    local expected = {
        string.byte( "D" ),
        string.byte( "M" ),
        string.byte( ":" ),
        string.byte( "0" ),
        string.byte( "1" ),
        string.byte( "2" ),
        string.byte( "3" ),
        string.byte( ":" )
    };
    local actual = luavsq.Sequence.getLinePrefixBytes( 123 );
    assert_equal( #expected, #actual );
    local i;
    for i = 1, #expected, 1 do
        assert_equal( expected[i], actual[i] );
    end

    -- 4 桁
    expected = {
        string.byte( "D" ),
        string.byte( "M" ),
        string.byte( ":" ),
        string.byte( "9" ),
        string.byte( "9" ),
        string.byte( "9" ),
        string.byte( "9" ),
        string.byte( ":" )
    };
    actual = luavsq.Sequence.getLinePrefixBytes( 9999 );
    assert_equal( #expected, #actual );
    for i = 1, #expected, 1 do
        assert_equal( expected[i], actual[i] );
    end

    -- 8 桁
    expected = {
        string.byte( "D" ),
        string.byte( "M" ),
        string.byte( ":" ),
        string.byte( "0" ),
        string.byte( "0" ),
        string.byte( "0" ),
        string.byte( "1" ),
        string.byte( "2" ),
        string.byte( "3" ),
        string.byte( "4" ),
        string.byte( "5" ),
        string.byte( ":" )
    };
    actual = luavsq.Sequence.getLinePrefixBytes( 12345 );
    assert_equal( #expected, #actual );
    for i = 1, #expected, 1 do
        assert_equal( expected[i], actual[i] );
    end

    -- 8 桁
    expected = {
        string.byte( "D" ),
        string.byte( "M" ),
        string.byte( ":" ),
        string.byte( "0" ),
        string.byte( "1" ),
        string.byte( "2" ),
        string.byte( "3" ),
        string.byte( "4" ),
        string.byte( "5" ),
        string.byte( "6" ),
        string.byte( "7" ),
        string.byte( ":" )
    };
    actual = luavsq.Sequence.getLinePrefixBytes( 1234567 );
    assert_equal( #expected, #actual );
    for i = 1, #expected, 1 do
        assert_equal( expected[i], actual[i] );
    end
end

function testGetHowManyDigits()
    assert_equal( 1, luavsq.Sequence.getHowManyDigits( 0 ) );
    assert_equal( 1, luavsq.Sequence.getHowManyDigits( 9 ) );
    assert_equal( 2, luavsq.Sequence.getHowManyDigits( 99 ) );
    assert_equal( 10, luavsq.Sequence.getHowManyDigits( 1000000000 ) );
    assert_equal( 2, luavsq.Sequence.getHowManyDigits( -10 ) );
end

function testWriteUnsignedShort()
    local stream = luavsq.ByteArrayOutputStream.new();
    luavsq.Sequence.writeUnsignedShort( stream, 0x8421 );
    local actual = stream:toString();
    local expected = string.char( 0x84 ) .. string.char( 0x21 );
    assert_equal( expected, actual );
end

function testWriteUnsignedInt()
    local stream = luavsq.ByteArrayOutputStream.new();
    luavsq.Sequence.writeUnsignedInt( stream, 0x84212184 );
    local actual = stream:toString();
    local expected = string.char( 0x84 ) .. string.char( 0x21 ) .. string.char( 0x21 ) .. string.char( 0x84 );
    assert_equal( expected, actual );
end
