require( "lunit" );
dofile( "../Mixer.lua" );
dofile( "../MixerEntry.lua" );
dofile( "../TextStream.lua" );
dofile( "../Util.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstruct()
    local mixer = luavsq.Mixer.new( 1, 2, 3, 4 );
    assert_equal( 1, mixer.masterFeder );
    assert_equal( 2, mixer.masterPanpot );
    assert_equal( 3, mixer.masterMute );
    assert_equal( 4, mixer.outputMode );
    assert_equal( 0, #mixer.slave );
end

function testConstructFromStream()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "MasterFeder=1" );
    stream:writeLine( "MasterPanpot=2" );
    stream:writeLine( "MasterMute=3" );
    stream:writeLine( "OutputMode=4" );
    stream:writeLine( "Tracks=1" );
    stream:writeLine( "Feder0=5" );
    stream:writeLine( "Panpot0=6" );
    stream:writeLine( "Mute0=7" );
    stream:writeLine( "Solo0=8" );
    stream:setPointer( -1 );

    local lastLine = { value = "" };
    local mixer = luavsq.Mixer.new( stream, lastLine );

    assert_equal( 1, #mixer.slave );
    assert_equal( 1, mixer.masterFeder );
    assert_equal( 2, mixer.masterPanpot );
    assert_equal( 3, mixer.masterMute );
    assert_equal( 4, mixer.outputMode );
    assert_equal( 5, mixer.slave[1].feder );
    assert_equal( 6, mixer.slave[1].panpot );
    assert_equal( 7, mixer.slave[1].mute );
    assert_equal( 8, mixer.slave[1].solo );
end

function testClone()
    local mixer = luavsq.Mixer.new( 1, 2, 3, 4 );
    mixer.slave = {};
    mixer.slave[1] = luavsq.MixerEntry.new( 5, 6, 7, 8 );
    mixer.slave[2] = luavsq.MixerEntry.new( 9, 10, 11, 12 );

    local copy = mixer:clone();
    assert_equal( 2, #copy.slave );
    assert_equal( 1, copy.masterFeder );
    assert_equal( 2, copy.masterPanpot );
    assert_equal( 3, copy.masterMute );
    assert_equal( 4, copy.outputMode );
    assert_equal( 5, copy.slave[1].feder );
    assert_equal( 6, copy.slave[1].panpot );
    assert_equal( 7, copy.slave[1].mute );
    assert_equal( 8, copy.slave[1].solo );
    assert_equal( 9, copy.slave[2].feder );
    assert_equal( 10, copy.slave[2].panpot );
    assert_equal( 11, copy.slave[2].mute );
    assert_equal( 12, copy.slave[2].solo );
end

function testWrite()
    local mixer = luavsq.Mixer.new( 1, 2, 3, 4 );
    mixer.slave = {};
    mixer.slave[1] = luavsq.MixerEntry.new( 5, 6, 7, 8 );
    mixer.slave[2] = luavsq.MixerEntry.new( 9, 10, 11, 12 );
    local stream = luavsq.TextStream.new();
    mixer:write( stream );
    local expected =
        "[Mixer]\n" ..
        "MasterFeder=1\n" ..
        "MasterPanpot=2\n" ..
        "MasterMute=3\n" ..
        "OutputMode=4\n" ..
        "Tracks=2\n" ..
        "Feder0=5\n" ..
        "Panpot0=6\n" ..
        "Mute0=7\n" ..
        "Solo0=8\n" ..
        "Feder1=9\n" ..
        "Panpot1=10\n" ..
        "Mute1=11\n" ..
        "Solo1=12\n";
    assert_equal( expected, stream:toString() );
end
