require( "lunit" );
dofile( "../EventList.lua" );
dofile( "../EventList.Iterator.lua" );
dofile( "../Event.lua" );
dofile( "../Id.lua" );
dofile( "../IdTypeEnum.lua" );
module( "EventList.IteratorTest", package.seeall, lunit.testcase );

function test()
    local list = luavsq.EventList.new();
    local iterator = luavsq.EventList.Iterator.new( list );
    assert_false( iterator:hasNext() );

    local a = luavsq.Event.new( 1920, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdTypeEnum.Anote;
    local b = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Aicon;
    local idA = list:add( a, 1 );
    local idB = list:add( b, 2 );

    iterator = luavsq.EventList.Iterator.new( list );
    assert_true( iterator:hasNext() );
    local eventA = iterator:next();
    assert_equal( 480, eventA.clock );
    assert_equal( 2, eventA.internalId );
    assert_equal( luavsq.IdTypeEnum.Aicon, eventA.id.type );
    assert_true( iterator:hasNext() );
    iterator:remove();
    assert_true( iterator:hasNext() );
    local eventB = iterator:next();
    assert_equal( 1920, eventB.clock );
    assert_equal( 1, eventB.internalId );
    assert_equal( luavsq.IdTypeEnum.Anote, eventB.id.type );
    assert_false( iterator:hasNext() );

    assert_equal( 1, list:size() );
    assert_equal( 1920, list:get( 0 ).clock );
    assert_equal( 1, list:get( 0 ).internalId );
end
