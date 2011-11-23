require( "lunit" );
dofile( "../Sequence.lua" );
dofile( "../List.lua" );
dofile( "../Track.lua" );
dofile( "../Common.lua" );
dofile( "../DynamicsModeEnum.lua" );
dofile( "../PlayModeEnum.lua" );
dofile( "../BPList.lua" );
dofile( "../EventList.lua" );
dofile( "../Id.lua" );
dofile( "../IdTypeEnum.lua" );
dofile( "../SingerHandle.lua" );
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
dofile( "../LyricHandle.lua" );
dofile( "../ArticulationTypeEnum.lua" );
dofile( "../Lyric.lua" );
dofile( "../PhoneticSymbol.lua" );
module( "SequenceTest", package.seeall, lunit.testcase );

---
-- 指定されたシーケンスがデフォルトのシーケンスと等しいかどうかを検査する
function isEqualToDefaultSequence( sequence )
    assert_equal( 1 * 480 * 4 / 4 * 4, sequence.totalClocks );

    -- track
    assert_equal( 2, sequence.track:size() );
    -- 第1トラック, master track
    local track0 = sequence.track[0];
    assert_nil( track0.common );
    assert_nil( track0.pit );
    assert_nil( track0.pbs );
    assert_nil( track0.dyn );
    assert_nil( track0.bre );
    assert_nil( track0.bri );
    assert_nil( track0.cle );
    assert_nil( track0.reso1FreqBPList );
    assert_nil( track0.reso2FreqBPList );
    assert_nil( track0.reso3FreqBPList );
    assert_nil( track0.reso4FreqBPList );
    assert_nil( track0.reso1BWBPList );
    assert_nil( track0.reso2BWBPList );
    assert_nil( track0.reso3BWBPList );
    assert_nil( track0.reso4BWBPList );
    assert_nil( track0.reso1AmpBPList );
    assert_nil( track0.reso2AmpBPList );
    assert_nil( track0.reso3AmpBPList );
    assert_nil( track0.reso4AmpBPList );
    assert_nil( track0.harmonics );
    assert_nil( track0.fx2depth );
    assert_nil( track0.gen );
    assert_nil( track0.por );
    assert_nil( track0.ope );
    assert_nil( track0.pitch );
    assert_nil( track0.events );
    assert_equal( "", track0.tag );
    -- 第2トラック, 普通のトラック
    local track1 = sequence.track[1];
    assert_not_nil( track1.common );
    assert_not_nil( track1.pit );
    assert_not_nil( track1.pbs );
    assert_not_nil( track1.dyn );
    assert_not_nil( track1.bre );
    assert_not_nil( track1.bri );
    assert_not_nil( track1.cle );
    assert_not_nil( track1.reso1FreqBPList );
    assert_not_nil( track1.reso2FreqBPList );
    assert_not_nil( track1.reso3FreqBPList );
    assert_not_nil( track1.reso4FreqBPList );
    assert_not_nil( track1.reso1BWBPList );
    assert_not_nil( track1.reso2BWBPList );
    assert_not_nil( track1.reso3BWBPList );
    assert_not_nil( track1.reso4BWBPList );
    assert_not_nil( track1.reso1AmpBPList );
    assert_not_nil( track1.reso2AmpBPList );
    assert_not_nil( track1.reso3AmpBPList );
    assert_not_nil( track1.reso4AmpBPList );
    assert_not_nil( track1.harmonics );
    assert_not_nil( track1.fx2depth );
    assert_not_nil( track1.gen );
    assert_not_nil( track1.por );
    assert_not_nil( track1.ope );
    assert_not_nil( track1.pitch );
    assert_not_nil( track1.events );
    assert_equal( "", track1.tag );
    assert_equal( 1, track1.events:size() );
    assert_equal( 0, track1.events:getElement( 0 ).clock );
    assert_equal( luavsq.IdTypeEnum.Singer, track1.events:getElement( 0 ).id.type );

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
    assert_equal( 0, sequence.timesigTable:get( 0 ).clock );
    assert_equal( 4, sequence.timesigTable:get( 0 ).denominator );
    assert_equal( 4, sequence.timesigTable:get( 0 ).numerator );
    assert_equal( 0, sequence.timesigTable:get( 0 ).barCount );

    -- tempoTable
    assert_equal( 1, sequence.tempoTable:size() );
    assert_equal( 0, sequence.tempoTable:get( 0 ).clock );
    assert_equal( 500000, sequence.tempoTable:get( 0 ).tempo );
    assert_equal( 0.0, sequence.tempoTable:get( 0 ).time );
end

function test()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local note = luavsq.Event.new( 1920, luavsq.Id.new( 0 ) );
    note.id.type = luavsq.IdTypeEnum.Anote;
    note.id.note = 60;
    note.id:setLength( 480 );
    note.id.lyricHandle = luavsq.LyricHandle.new( "あ", "a" );
    sequence.track:get( 1 ):addEvent( note );
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
    assert_equal( 1 * 480 * 4 / 4 * 4, sequence.totalClocks );
    local note = luavsq.Event.new( 1920, luavsq.Id.new( 0 ) );
    note.id.type = luavsq.IdTypeEnum.Anote;
    note.id:setLength( 480 );
    note.id.note = 60;
    sequence.track[1]:addEvent( note );
    sequence:updateTotalClocks();
    assert_equal( 2400, sequence.totalClocks );
end

function testGenerateMetaTextEventWithoutPitch()
    fail();
end

function testGenerateMetaTextEventWithPitch()
--    fail();
end

function testGetPresendClockAt()
    fail();
end

function testGetMaximumNoteLengthAt()
--    fail();
end

function testGenerateTimeSig()
    fail();
end

function testGenerateTempoChange()
    fail();
end

function testWriteWithoutPitch()
    fail();
end

function testWriteWithPitch()
--    fail();
end

function testSubstring127Bytes()
    fail();
end

function testPrintTrack()
    fail();
end

function testGenerateExpressionNRPN()
    fail();
end

function testGenerateFx2DepthNRPN()
    fail();
end

function testGenerateHeaderNRPN()
    fail();
end

function testGenerateSingerNRPN()
    fail();
end

function testGenerateNoteNRPN()
    fail();
end

function testGenerateNRPNAll()
    fail();
end

function testGenerateNRPNPartial()
--    fail();
end

function testGeneratePitchBendNRPN()
    fail();
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
    fail();
end

function testGenerateVibratoNRPN()
    fail();
end

function testGenerateVoiceChangeParameterNRPN()
    fail();
end

function testGetMsbAndLsb()
    fail();
end

function testGetLinePrefix()
    fail();
end

function testGetLinePrefixBytes()
    fail();
end

function testGetHowManyDigits()
    fail();
end

function testWriteCharArray()
    fail();
end

function testWriteUnsignedShort()
    fail();
end

function testWriteUnsignedInt()
    fail();
end

function testToDo1()
    fail( "m_tpqを_tpqにリネーム" );
    fail( "MSBとLSBに分解するメソッドがあるので、利用できる所で使う" );
    fail( "getLinePrefixは使ってる?" );
end
