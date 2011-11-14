require( "lunit" );
dofile( "../DynamicsModeEnum.lua" );
module( "DynamicsModeEnumTest", package.seeall, lunit.testcase );

function test()
    assert_equal( 0, luavsq.DynamicsModeEnum.Standard );
    assert_equal( 1, luavsq.DynamicsModeEnum.Expert );
end
