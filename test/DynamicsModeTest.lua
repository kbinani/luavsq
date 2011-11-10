require( "lunit" );
dofile( "../DynamicsMode.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function test()
    assert_equal( 0, luavsq.DynamicsMode.Standard );
    assert_equal( 1, luavsq.DynamicsMode.Expert );
end
