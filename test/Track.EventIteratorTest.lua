require( "lunit" );
dofile( "../Track.EventIterator.lua" );
dofile( "../EventList.lua" );
dofile( "../Event.lua" );
dofile( "../Id.lua" );
dofile( "../IdType.lua" );
module( "Track.EventIteratorTest", package.seeall, lunit.testcase );

function test()
    local list = luavsq.EventList.new();
    local iterator = luavsq.Track.EventIterator.new( list );
    assert_false( iterator:hasNext() );

    local a = luavsq.Event.new( 1920, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdType.Anote;
    local b = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdType.Aicon;
    local idA = list:add( a, 1 );
    local idB = list:add( b, 2 );

    iterator = luavsq.Track.EventIterator.new( list );
    assert_true( iterator:hasNext() );
    local eventA = iterator:next();
    assert_equal( 480, eventA.clock );
    assert_equal( 2, eventA.internalId );
    assert_equal( luavsq.IdType.Aicon, eventA.id.type );
    assert_true( iterator:hasNext() );
    iterator:remove();
    assert_true( iterator:hasNext() );
    local eventB = iterator:next();
    assert_equal( 1920, eventB.clock );
    assert_equal( 1, eventB.internalId );
    assert_equal( luavsq.IdType.Anote, eventB.id.type );
    assert_false( iterator:hasNext() );

    assert_equal( 1, list:size() );
    assert_equal( 1920, list:getElement( 0 ).clock );
    assert_equal( 1, list:getElement( 0 ).internalId );
end
