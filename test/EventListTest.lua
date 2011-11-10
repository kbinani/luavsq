dofile( "./test_bootstrap.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstruct()
    local list = luavsq.EventList.new();
    assert_equal( 0, list:getCount() );
end

function testFindIndexFromID()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 1, luavsq.ID.new( 0 ) );
    a.ID.type = luavsq.IDType.Anote;
    local b = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    b.ID.type = luavsq.IDType.Anote;
    list:add( a, 0 );
    list:add( b, 1 );

    --aのほうがclockが大きいので、後ろに並び替えられる
    assert_equal( 0, list:findIndexFromID( 1 ) );
    assert_equal( 1, list:findIndexFromID( 0 ) );
end

function testFindFromID()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    a.ID.type = luavsq.IDType.Anote;
    local b = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    b.ID.type = luavsq.IDType.Singer;
    list:add( a, 0 );
    list:add( b, 1 );

    assert_equal( luavsq.IDType.Anote, list:findFromID( 0 ).ID.type );
    assert_equal( luavsq.IDType.Singer, list:findFromID( 1 ).ID.type );
    assert_nil( list:findFromID( 1000 ) );
end

function testSetForID()
    local list = luavsq.EventList.new();
    local event = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    event.ID.type = luavsq.IDType.Anote;
    event.ID.note = 60;
    event.internalID = 10;

    local replace = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    replace.ID.type = luavsq.IDType.Anote;
    replace.ID.note = 90;
    replace.internalID = 100;

    list:add( event, 10 );
    list:setForID( 10, replace );

    assert_equal( 10, list:getElement( 0 ).internalID );
    assert_equal( 90, list:getElement( 0 ).ID.note );

    -- 無効なinternalIDを渡すので、setが行われない場合
    list = luavsq.EventList.new();
    list:add( event, 10 );
    list:setForID( 9999, replace );
    assert_equal( 60, list:getElement( 0 ).ID.note );
end

function testSort()
    local list = luavsq.EventList.new();
    local b = luavsq.Event.new( 480, luavsq.ID.new( 0 ) );
    local a = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    b.ID.type = luavsq.IDType.Anote;
    b.internalID = 14;
    a.ID.type = luavsq.IDType.Anote;
    a.internalID = 20;
    list._events = { b, a };
    list._ids = { 14, 20 };

    list:sort();

    assert_equal( 0, list:getElement( 0 ).clock );
    assert_equal( 480, list:getElement( 1 ).clock );
    assert_equal( 0, list:findIndexFromID( 20 ) );
    assert_equal( 1, list:findIndexFromID( 14 ) );
end

function testClear()
    local list = luavsq.EventList.new();
    local b = luavsq.Event.new( 480, luavsq.ID.new( 0 ) );
    local a = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    b.ID.type = luavsq.IDType.Anote;
    a.ID.type = luavsq.IDType.Anote;
    list:add( b, 14 );
    list:add( a, 20 );

    assert_equal( 2, list:getCount() );
    assert_equal( 20, list:getElement( 0 ).internalID );

    list:clear();

    assert_equal( 0, list:getCount() );
end

function testIterator()
--fail();
end

function testAddWithoutInternalID()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 1, luavsq.ID.new( 0 ) );
    a.ID.type = luavsq.IDType.Anote;
    local b = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    b.ID.type = luavsq.IDType.Anote;
    local idOfA = list:add( a );
    local idOfB = list:add( b );

    -- bよりaのほうがclockが大きいので、並べ替えが起きるはず
    assert_equal( idOfB, list:getElement( 0 ).internalID );
    assert_equal( idOfA, list:getElement( 1 ).internalID );
    assert_true( idOfA ~= idOfB );
end

function testAddWithInternalID()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    a.ID.type = luavsq.IDType.Anote;
    local b = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    b.ID.type = luavsq.IDType.Anote;
    local idOfA = list:add( a, 100 );
    local idOfB = list:add( b, 2 );
    assert_equal( 100, idOfA );
    assert_equal( 2, idOfB );
    assert_equal( 100, list:getElement( 0 ).internalID );
    assert_equal( 2, list:getElement( 1 ).internalID );
end

function testRemoveAt()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    a.ID.type = luavsq.IDType.Anote;
    local b = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    b.ID.type = luavsq.IDType.Anote;
    list:add( a, 100 );
    list:add( b, 2 );
    assert_equal( 100, list:getElement( 0 ).internalID );
    assert_equal( 2, list:getElement( 1 ).internalID );
    assert_equal( 2, list:getCount() );

    list:removeAt( 0 );

    assert_equal( 1, list:getCount() );
    assert_equal( 2, list:getElement( 0 ).internalID );
end

function testGetCount()
    local list = luavsq.EventList.new();
    assert_equal( 0, list:getCount() );
    local event = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    event.ID.type = luavsq.IDType.Anote;
    list:add( event );
    assert_equal( 1, list:getCount() );
end

function testGetAndSetElement()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    a.ID.type = luavsq.IDType.Anote;
    local b = luavsq.Event.new( 0, luavsq.ID.new( 0 ) );
    b.ID.type = luavsq.IDType.Anote;
    list:add( a, 100 );
    list:add( b, 2 );
    assert_equal( 100, list:getElement( 0 ).internalID );
    assert_equal( 2, list:getElement( 1 ).internalID );

    local c = luavsq.Event.new( 480, luavsq.ID.new( 0 ) );
    c.ID.type = luavsq.IDType.Anote;
    c.internalID = 99;
    list:setElement( 1, c );

    assert_equal( 100, list:getElement( 0 ).internalID );
    assert_equal( 2, list:getElement( 1 ).internalID );
    assert_equal( 480, list:getElement( 1 ).clock );
end
