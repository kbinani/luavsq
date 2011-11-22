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
module( "SequenceTest", package.seeall, lunit.testcase );

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

function test()
    local sequence = luavsq.Sequence.new( "Miku", 1, 4, 4, 500000 );
    local fileHandle = io.open( "foo.vsq", "wb" );
    fileHandle:write( sequence:write( 500, "Shift_JIS" ) );
    fileHandle:close();
    fail();
end

function testConstruct()
    fail();
end

function testClone()
    fail();
end

