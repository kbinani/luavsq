require( "lunit" );
dofile( "../PlayModeEnum.lua" );
module( "PlayModeEnumTest", package.seeall, lunit.testcase );

function test()
    assert_equal( -1, luavsq.PlayModeEnum.Off );
    assert_equal( 0, luavsq.PlayModeEnum.PlayAfterSynth );
    assert_equal( 1, luavsq.PlayModeEnum.PlayWithSynth );
end
