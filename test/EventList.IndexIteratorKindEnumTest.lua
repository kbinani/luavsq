require( "lunit" );
dofile( "../EventList.IndexIteratorKindEnum.lua" );
module( "EventList.IndexIteratorKindEnumTest", package.seeall, lunit.testcase );

function test()
    assert_equal( 1, luavsq.EventList.IndexIteratorKindEnum.SINGER );
    assert_equal( 2, luavsq.EventList.IndexIteratorKindEnum.NOTE );
    assert_equal( 4, luavsq.EventList.IndexIteratorKindEnum.CRESCENDO );
    assert_equal( 8, luavsq.EventList.IndexIteratorKindEnum.DECRESCENDO );
    assert_equal( 16, luavsq.EventList.IndexIteratorKindEnum.DYNAFF );
end
