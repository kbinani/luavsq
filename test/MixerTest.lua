dofile( "./test_bootstrap.lua" );
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
    stream:writeLine( "[Mixer]" );
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
    fail();
end

function testClone()
    fail();
end

function testWrite()
    fail();
end
