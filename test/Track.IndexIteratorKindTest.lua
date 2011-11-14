require( "lunit" );
dofile( "../Track.IndexIteratorKindEnum.lua" );
module( "Track.IndexIteratorKindTest", package.seeall, lunit.testcase );

function test()
    assert_equal( 1, luavsq.Track.IndexIteratorKindEnum.SINGER );
    assert_equal( 2, luavsq.Track.IndexIteratorKindEnum.NOTE );
    assert_equal( 4, luavsq.Track.IndexIteratorKindEnum.CRESCEND );
    assert_equal( 8, luavsq.Track.IndexIteratorKindEnum.DECRESCEND );
    assert_equal( 16, luavsq.Track.IndexIteratorKindEnum.DYNAFF );
end
