require( "lunit" );
dofile( "../EventList.lua" );
dofile( "../EventList.Iterator.lua" );
dofile( "../Event.lua" );
dofile( "../EventTypeEnum.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleTypeEnum.lua" );
dofile( "../Lyric.lua" );
dofile( "../Util.lua" );
module( "EventList.IteratorTest", package.seeall, lunit.testcase );

function test()
    local list = luavsq.EventList.new();
    local iterator = luavsq.EventList.Iterator.new( list );
    assert_false( iterator:hasNext() );

    local a = luavsq.Event.new( 1920, luavsq.EventTypeEnum.NOTE );
    local b = luavsq.Event.new( 480, luavsq.EventTypeEnum.ICON );
    local idA = list:add( a, 1 );
    local idB = list:add( b, 2 );

    iterator = luavsq.EventList.Iterator.new( list );
    assert_true( iterator:hasNext() );
    local eventA = iterator:next();
    assert_equal( 480, eventA.clock );
    assert_equal( 2, eventA.id );
    assert_equal( luavsq.EventTypeEnum.ICON, eventA.type );
    assert_true( iterator:hasNext() );
    iterator:remove();
    assert_true( iterator:hasNext() );
    local eventB = iterator:next();
    assert_equal( 1920, eventB.clock );
    assert_equal( 1, eventB.id );
    assert_equal( luavsq.EventTypeEnum.NOTE, eventB.type );
    assert_false( iterator:hasNext() );

    assert_equal( 1, list:size() );
    assert_equal( 1920, list:get( 0 ).clock );
    assert_equal( 1, list:get( 0 ).id );
end
