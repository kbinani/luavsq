require( "lunit" );
dofile( "../PlayMode.lua" );
module( "PlayModeTest", package.seeall, lunit.testcase );

function test()
    assert_equal( -1, luavsq.PlayMode.Off );
    assert_equal( 0, luavsq.PlayMode.PlayAfterSynth );
    assert_equal( 1, luavsq.PlayMode.PlayWithSynth );
end
