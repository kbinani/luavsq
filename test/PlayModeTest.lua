dofile( "./test_bootstrap.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function test()
    assert_equal( -1, luavsq.PlayMode.Off );
    assert_equal( 0, luavsq.PlayMode.PlayAfterSynth );
    assert_equal( 1, luavsq.PlayMode.PlayWithSynth );
end
