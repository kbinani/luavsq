require( "lunit" );
dofile( "../PlayMode.lua" );
module( "PlayModeTest", package.seeall, lunit.testcase );

function test()
    assert_equal( -1, luavsq.PlayModeEnum.Off );
    assert_equal( 0, luavsq.PlayModeEnum.PlayAfterSynth );
    assert_equal( 1, luavsq.PlayModeEnum.PlayWithSynth );
end
