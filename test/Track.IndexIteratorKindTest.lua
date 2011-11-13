require( "lunit" );
dofile( "../Track.IndexIteratorKind.lua" );
module( "Track.IndexIteratorKindTest", package.seeall, lunit.testcase );

function test()
    assert_equal( 1, luavsq.Track.IndexIteratorKind.SINGER );
    assert_equal( 2, luavsq.Track.IndexIteratorKind.NOTE );
    assert_equal( 4, luavsq.Track.IndexIteratorKind.CRESCEND );
    assert_equal( 8, luavsq.Track.IndexIteratorKind.DECRESCEND );
    assert_equal( 16, luavsq.Track.IndexIteratorKind.DYNAFF );
end
