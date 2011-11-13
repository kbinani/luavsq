require( "lunit" );
dofile( "../DynamicsMode.lua" );
module( "DynamicsModeTest", package.seeall, lunit.testcase );

function test()
    assert_equal( 0, luavsq.DynamicsModeEnum.Standard );
    assert_equal( 1, luavsq.DynamicsModeEnum.Expert );
end
