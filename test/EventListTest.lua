require( "lunit" );
dofile( "../EventList.lua" );
dofile( "../Event.lua" );
dofile( "../Id.lua" );
dofile( "../IdTypeEnum.lua" );
dofile( "../ArticulationTypeEnum.lua" );
dofile( "../Lyric.lua" );
dofile( "../Util.lua" );
dofile( "../TextStream.lua" );
dofile( "../EventList.Iterator.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleTypeEnum.lua" );
dofile( "../VoiceLanguageEnum.lua" );
module( "EventListTest", package.seeall, lunit.testcase );

function testConstruct()
    local list = luavsq.EventList.new();
    assert_equal( 0, list:size() );
end

function testFindIndexFromId()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 1, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdTypeEnum.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Anote;
    list:add( a, 0 );
    list:add( b, 1 );

    --aのほうがclockが大きいので、後ろに並び替えられる
    assert_equal( 0, list:findIndexFromId( 1 ) );
    assert_equal( 1, list:findIndexFromId( 0 ) );
end

function testFindFromId()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdTypeEnum.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Singer;
    list:add( a, 0 );
    list:add( b, 1 );

    assert_equal( luavsq.IdTypeEnum.Anote, list:findFromId( 0 ).id.type );
    assert_equal( luavsq.IdTypeEnum.Singer, list:findFromId( 1 ).id.type );
    assert_nil( list:findFromId( 1000 ) );
end

function testSetForId()
    local list = luavsq.EventList.new();
    local event = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    event.id.type = luavsq.IdTypeEnum.Anote;
    event.id.note = 60;
    event.internalId = 10;

    local replace = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    replace.id.type = luavsq.IdTypeEnum.Anote;
    replace.id.note = 90;
    replace.internalId = 100;

    list:add( event, 10 );
    list:setForId( 10, replace );

    assert_equal( 10, list:get( 0 ).internalId );
    assert_equal( 90, list:get( 0 ).id.note );

    -- 無効なinternalIdを渡すので、setが行われない場合
    list = luavsq.EventList.new();
    list:add( event, 10 );
    list:setForId( 9999, replace );
    assert_equal( 60, list:get( 0 ).id.note );
end

function testSort()
    local list = luavsq.EventList.new();
    local b = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Anote;
    b.internalId = 14;
    a.id.type = luavsq.IdTypeEnum.Anote;
    a.internalId = 20;
    list._events = { b, a };
    list._ids = { 14, 20 };

    list:sort();

    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 480, list:get( 1 ).clock );
    assert_equal( 0, list:findIndexFromId( 20 ) );
    assert_equal( 1, list:findIndexFromId( 14 ) );
end

function testClear()
    local list = luavsq.EventList.new();
    local b = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Anote;
    a.id.type = luavsq.IdTypeEnum.Anote;
    list:add( b, 14 );
    list:add( a, 20 );

    assert_equal( 2, list:size() );
    assert_equal( 20, list:get( 0 ).internalId );

    list:clear();

    assert_equal( 0, list:size() );
end

function testIterator()
--fail();
end

function testAddWithoutInternalId()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 1, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdTypeEnum.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Anote;
    local idOfA = list:add( a );
    local idOfB = list:add( b );

    -- bよりaのほうがclockが大きいので、並べ替えが起きるはず
    assert_equal( idOfB, list:get( 0 ).internalId );
    assert_equal( idOfA, list:get( 1 ).internalId );
    assert_true( idOfA ~= idOfB );
end

function testAddWithInternalId()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdTypeEnum.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Anote;
    local idOfA = list:add( a, 100 );
    local idOfB = list:add( b, 2 );
    assert_equal( 100, idOfA );
    assert_equal( 2, idOfB );
    assert_equal( 100, list:get( 0 ).internalId );
    assert_equal( 2, list:get( 1 ).internalId );
end

function testRemoveAt()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdTypeEnum.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Anote;
    list:add( a, 100 );
    list:add( b, 2 );
    assert_equal( 100, list:get( 0 ).internalId );
    assert_equal( 2, list:get( 1 ).internalId );
    assert_equal( 2, list:size() );

    list:removeAt( 0 );

    assert_equal( 1, list:size() );
    assert_equal( 2, list:get( 0 ).internalId );
end

function testSize()
    local list = luavsq.EventList.new();
    assert_equal( 0, list:size() );
    local event = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    event.id.type = luavsq.IdTypeEnum.Anote;
    list:add( event );
    assert_equal( 1, list:size() );
end

function testGetAndSetElement()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdTypeEnum.Anote;
    local b = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Anote;
    list:add( a, 100 );
    list:add( b, 2 );
    assert_equal( 100, list:get( 0 ).internalId );
    assert_equal( 2, list:get( 1 ).internalId );

    local c = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    c.id.type = luavsq.IdTypeEnum.Anote;
    c.internalId = 99;
    list:set( 1, c );

    assert_equal( 100, list:get( 0 ).internalId );
    assert_equal( 2, list:get( 1 ).internalId );
    assert_equal( 480, list:get( 1 ).clock );
end

function testIterator()
    local list = luavsq.EventList.new();
    local iterator = list:iterator();
    assert_false( iterator:hasNext() );

    local singerEvent = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    singerEvent.id.type = luavsq.IdTypeEnum.Singer;
    singerEvent.id.singerHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Singer );
    list:add( singerEvent, 1 );

    local crescendoEvent = luavsq.Event.new( 240, luavsq.Id.new( 0 ) );
    crescendoEvent.id.type = luavsq.IdTypeEnum.Aicon;
    crescendoEvent.id.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    crescendoEvent.id.iconDynamicsHandle.iconId = "$05020001";
    list:add( crescendoEvent, 2 );

    iterator = list:iterator();
    assert_true( iterator:hasNext() );
    assert_equal( 0, iterator:next().clock );
    assert_true( iterator:hasNext() );
    assert_equal( 240, iterator:next().clock );
    assert_false( iterator:hasNext() );
end

function testWrite()
    local list = luavsq.EventList.new();

    local singerEvent = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    singerEvent.id.type = luavsq.IdTypeEnum.Singer;
    singerEvent.id.singerHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Singer );
    list:add( singerEvent, 1 );

    local crescendoEvent = luavsq.Event.new( 240, luavsq.Id.new( 0 ) );
    crescendoEvent.id.type = luavsq.IdTypeEnum.Aicon;
    crescendoEvent.id.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    crescendoEvent.id.iconDynamicsHandle.iconId = "$05020001";
    list:add( crescendoEvent, 2 );

    local dynaffEvent = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    dynaffEvent.id.type = luavsq.IdTypeEnum.Aicon;
    dynaffEvent.id.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    dynaffEvent.id.iconDynamicsHandle.iconId = "$05010001";
    list:add( dynaffEvent, 3 );

    local decrescendoEvent = luavsq.Event.new( 720, luavsq.Id.new( 0 ) );
    decrescendoEvent.id.type = luavsq.IdTypeEnum.Aicon;
    decrescendoEvent.id.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    decrescendoEvent.id.iconDynamicsHandle.iconId = "$05030001";
    list:add( decrescendoEvent, 4 );

    local singerEvent2 = luavsq.Event.new( 1920, luavsq.Id.new( 0 ) );
    singerEvent2.id.type = luavsq.IdTypeEnum.Singer;
    singerEvent2.id.singerHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Singer );
    list:add( singerEvent2, 5 );

    local noteEvent = luavsq.Event.new( 1920, luavsq.Id.new( 0 ) );
    noteEvent.id.type = luavsq.IdTypeEnum.Anote;
    noteEvent.id:setLength( 480 );
    noteEvent.id.lyricHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Lyric );
    noteEvent.id.lyricHandle:setLyricAt( 0, luavsq.Lyric.new( "ら", "4 a" ) );
    noteEvent.id.noteHeadHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.NoteHead );
    noteEvent.id.vibratoHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    list:add( noteEvent, 6 );

    local stream = luavsq.TextStream.new();
    local handles = list:write( stream, 2400 );
    local expected =
        "[EventList]\n" ..
        "0=ID#0000\n" ..
        "240=ID#0001\n" ..
        "480=ID#0002\n" ..
        "720=ID#0003\n" ..
        "1920=ID#0004,ID#0005\n" ..
        "2400=EOS\n";
    assert_equal( expected, stream:toString() );

    assert_equal( 8, #handles );
    assert_equal( luavsq.HandleTypeEnum.Singer, handles[1]:getHandleType() );
    assert_equal( luavsq.HandleTypeEnum.Dynamics, handles[2]:getHandleType() );
    assert_equal( luavsq.HandleTypeEnum.Dynamics, handles[3]:getHandleType() );
    assert_equal( luavsq.HandleTypeEnum.Dynamics, handles[4]:getHandleType() );
    assert_equal( luavsq.HandleTypeEnum.Singer, handles[5]:getHandleType() );
    assert_equal( luavsq.HandleTypeEnum.Lyric, handles[6]:getHandleType() );
    assert_equal( luavsq.HandleTypeEnum.Vibrato, handles[7]:getHandleType() );
    assert_equal( luavsq.HandleTypeEnum.NoteHead, handles[8]:getHandleType() );
end
