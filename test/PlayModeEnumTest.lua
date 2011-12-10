require( "lunit" );
dofile( "../PlayModeEnum.lua" );
module( "PlayModeEnumTest", package.seeall, lunit.testcase );

function test()
    assert_equal( -1, luavsq.PlayModeEnum.OFF );
    assert_equal( 0, luavsq.PlayModeEnum.PLAY_AFTER_SYNTH );
    assert_equal( 1, luavsq.PlayModeEnum.PLAY_WITH_SYNTH );
end
