require( "lunit" );
dofile( "../BPList.lua" );
dofile( "../BPList.KeyClockIterator.lua" );
dofile( "../BP.lua" );
dofile( "../Util.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function test()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    local iterator = luavsq.BPList.KeyClockIterator.new( list );
    assert_false( iterator:hasNext() );
    list:add( 480, 1 );
    list:add( 1920, 2 );

    iterator = luavsq.BPList.KeyClockIterator.new( list );
    assert_true( iterator:hasNext() );
    assert_equal( 480, iterator:next() );
    assert_true( iterator:hasNext() );
    assert_equal( 1920, iterator:next() );
    assert_false( iterator:hasNext() );

    iterator = luavsq.BPList.KeyClockIterator.new( list );
    assert_true( iterator:hasNext() );
    assert_equal( 480, iterator:next() );
    iterator:remove();
    assert_equal( 1920, iterator:next() );
    assert_false( iterator:hasNext() );
end
