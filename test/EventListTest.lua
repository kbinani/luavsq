require( "lunit" );
dofile( "../EventList.lua" );
dofile( "../Event.lua" );
dofile( "../Id.lua" );
dofile( "../IdType.lua" );
module( "EventListTest", package.seeall, lunit.testcase );

function testConstruct()
    local list = luavsq.EventList.new();
    assert_equal( 0, list:size() );
end

function testFindIndexFromId()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 1, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdType.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdType.Anote;
    list:add( a, 0 );
    list:add( b, 1 );

    --aのほうがclockが大きいので、後ろに並び替えられる
    assert_equal( 0, list:findIndexFromId( 1 ) );
    assert_equal( 1, list:findIndexFromId( 0 ) );
end

function testFindFromId()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdType.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdType.Singer;
    list:add( a, 0 );
    list:add( b, 1 );

    assert_equal( luavsq.IdType.Anote, list:findFromId( 0 ).id.type );
    assert_equal( luavsq.IdType.Singer, list:findFromId( 1 ).id.type );
    assert_nil( list:findFromId( 1000 ) );
end

function testSetForId()
    local list = luavsq.EventList.new();
    local event = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    event.id.type = luavsq.IdType.Anote;
    event.id.note = 60;
    event.internalId = 10;

    local replace = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    replace.id.type = luavsq.IdType.Anote;
    replace.id.note = 90;
    replace.internalId = 100;

    list:add( event, 10 );
    list:setForId( 10, replace );

    assert_equal( 10, list:getElement( 0 ).internalId );
    assert_equal( 90, list:getElement( 0 ).id.note );

    -- 無効なinternalIdを渡すので、setが行われない場合
    list = luavsq.EventList.new();
    list:add( event, 10 );
    list:setForId( 9999, replace );
    assert_equal( 60, list:getElement( 0 ).id.note );
end

function testSort()
    local list = luavsq.EventList.new();
    local b = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdType.Anote;
    b.internalId = 14;
    a.id.type = luavsq.IdType.Anote;
    a.internalId = 20;
    list._events = { b, a };
    list._ids = { 14, 20 };

    list:sort();

    assert_equal( 0, list:getElement( 0 ).clock );
    assert_equal( 480, list:getElement( 1 ).clock );
    assert_equal( 0, list:findIndexFromId( 20 ) );
    assert_equal( 1, list:findIndexFromId( 14 ) );
end

function testClear()
    local list = luavsq.EventList.new();
    local b = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdType.Anote;
    a.id.type = luavsq.IdType.Anote;
    list:add( b, 14 );
    list:add( a, 20 );

    assert_equal( 2, list:size() );
    assert_equal( 20, list:getElement( 0 ).internalId );

    list:clear();

    assert_equal( 0, list:size() );
end

function testIterator()
--fail();
end

function testAddWithoutInternalId()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 1, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdType.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdType.Anote;
    local idOfA = list:add( a );
    local idOfB = list:add( b );

    -- bよりaのほうがclockが大きいので、並べ替えが起きるはず
    assert_equal( idOfB, list:getElement( 0 ).internalId );
    assert_equal( idOfA, list:getElement( 1 ).internalId );
    assert_true( idOfA ~= idOfB );
end

function testAddWithInternalId()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdType.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdType.Anote;
    local idOfA = list:add( a, 100 );
    local idOfB = list:add( b, 2 );
    assert_equal( 100, idOfA );
    assert_equal( 2, idOfB );
    assert_equal( 100, list:getElement( 0 ).internalId );
    assert_equal( 2, list:getElement( 1 ).internalId );
end

function testRemoveAt()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdType.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdType.Anote;
    list:add( a, 100 );
    list:add( b, 2 );
    assert_equal( 100, list:getElement( 0 ).internalId );
    assert_equal( 2, list:getElement( 1 ).internalId );
    assert_equal( 2, list:size() );

    list:removeAt( 0 );

    assert_equal( 1, list:size() );
    assert_equal( 2, list:getElement( 0 ).internalId );
end

function testSize()
    local list = luavsq.EventList.new();
    assert_equal( 0, list:size() );
    local event = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    event.id.type = luavsq.IdType.Anote;
    list:add( event );
    assert_equal( 1, list:size() );
end

function testGetAndSetElement()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdType.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdType.Anote;
    list:add( a, 100 );
    list:add( b, 2 );
    assert_equal( 100, list:getElement( 0 ).internalId );
    assert_equal( 2, list:getElement( 1 ).internalId );

    local c = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    c.id.type = luavsq.IdType.Anote;
    c.internalId = 99;
    list:setElement( 1, c );

    assert_equal( 100, list:getElement( 0 ).internalId );
    assert_equal( 2, list:getElement( 1 ).internalId );
    assert_equal( 480, list:getElement( 1 ).clock );
end
