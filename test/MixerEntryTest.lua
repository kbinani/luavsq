dofile( "./test_bootstrap.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstruct()
    local mixerEntry = luavsq.MixerEntry.new( 1, 2, 3, 4 );
    assert_equal( 1, mixerEntry.feder );
    assert_equal( 2, mixerEntry.panpot );
    assert_equal( 3, mixerEntry.mute );
    assert_equal( 4, mixerEntry.solo );
end

function testClone()
    local mixerEntry = luavsq.MixerEntry.new( 1, 2, 3, 4 );
    local copy = mixerEntry:clone();
    assert_equal( 1, copy.feder );
    assert_equal( 2, copy.panpot );
    assert_equal( 3, copy.mute );
    assert_equal( 4, copy.solo );
end
