require( "lunit" );
dofile( "../EventList.lua" );
dofile( "../EventList.IndexIterator.lua" );
dofile( "../Event.lua" );
dofile( "../Id.lua" );
dofile( "../IdTypeEnum.lua" );
dofile( "../IconParameter.lua" );
dofile( "../ArticulationTypeEnum.lua" );
dofile( "../EventList.IndexIteratorKindEnum.lua" );
dofile( "../Util.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleTypeEnum.lua" );
module( "EventList.IndexIteratorTest", package.seeall, lunit.testcase );

function test()
    local list = luavsq.EventList.new();

    local noteEvent = luavsq.Event.new( 1920, luavsq.Id.new( 0 ) );
    noteEvent.id.type = luavsq.IdTypeEnum.Anote;
    list:add( noteEvent, 5 );

    local singerEvent = luavsq.Event.new( 0, luavsq.Id.new( 0 ) );
    singerEvent.id.type = luavsq.IdTypeEnum.Singer;
    list:add( singerEvent, 1 );

    local dynaffEvent = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    dynaffEvent.id.type = luavsq.IdTypeEnum.Aicon;
    dynaffEvent.id.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    dynaffEvent.id.iconDynamicsHandle.iconId = "$05010001";
    list:add( dynaffEvent, 3 );

    local crescendoEvent = luavsq.Event.new( 240, luavsq.Id.new( 0 ) );
    crescendoEvent.id.type = luavsq.IdTypeEnum.Aicon;
    crescendoEvent.id.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    crescendoEvent.id.iconDynamicsHandle.iconId = "$05020001";
    list:add( crescendoEvent, 2 );

    local decrescendoEvent = luavsq.Event.new( 720, luavsq.Id.new( 0 ) );
    decrescendoEvent.id.type = luavsq.IdTypeEnum.Aicon;
    decrescendoEvent.id.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    decrescendoEvent.id.iconDynamicsHandle.iconId = "$05030001";
    list:add( decrescendoEvent, 4 );

    --音符イベントのみのイテレータ
    local noteIterator = luavsq.EventList.IndexIterator.new( list, luavsq.EventList.IndexIteratorKindEnum.NOTE );
    assert_true( noteIterator:hasNext() );
    assert_equal( 4, noteIterator:next() );
    assert_false( noteIterator:hasNext() );
    local event = list:get( 4 );
    assert_equal( 1920, event.clock );
    assert_equal( 5, event.internalId );

    --歌手変更イベントのみのイテレータ
    local singerIterator = luavsq.EventList.IndexIterator.new( list, luavsq.EventList.IndexIteratorKindEnum.SINGER );
    assert_true( singerIterator:hasNext() );
    assert_equal( 0, singerIterator:next() );
    assert_false( singerIterator:hasNext() );
    event = list:get( 0 );
    assert_equal( 0, event.clock );
    assert_equal( 1, event.internalId );

    --強弱記号のみのイテレータ
    local dynaffIterator = luavsq.EventList.IndexIterator.new( list, luavsq.EventList.IndexIteratorKindEnum.DYNAFF );
    assert_true( dynaffIterator:hasNext() );
    assert_equal( 2, dynaffIterator:next() );
    assert_false( dynaffIterator:hasNext() );
    event = list:get( 2 );
    assert_equal( 480, event.clock );
    assert_equal( 3, event.internalId );

    --クレッシェンドのみのイテレータ
    local crescendoIterator = luavsq.EventList.IndexIterator.new( list, luavsq.EventList.IndexIteratorKindEnum.CRESCEND );
    assert_true( crescendoIterator:hasNext() );
    assert_equal( 1, crescendoIterator:next() );
    assert_false( crescendoIterator:hasNext() );
    event = list:get( 1 );
    assert_equal( 240, event.clock );
    assert_equal( 2, event.internalId );

    local decrescendoIterator = luavsq.EventList.IndexIterator.new( list, luavsq.EventList.IndexIteratorKindEnum.DECRESCEND );
    assert_true( decrescendoIterator:hasNext() );
    assert_equal( 3, decrescendoIterator:next() );
    assert_false( decrescendoIterator:hasNext() );
    event = list:get( 3 );
    assert_equal( 720, event.clock );
    assert_equal( 4, event.internalId );

    local kindAll = luavsq.Util.bor(
        luavsq.EventList.IndexIteratorKindEnum.NOTE,
        luavsq.EventList.IndexIteratorKindEnum.SINGER,
        luavsq.EventList.IndexIteratorKindEnum.DYNAFF,
        luavsq.EventList.IndexIteratorKindEnum.CRESCEND,
        luavsq.EventList.IndexIteratorKindEnum.DECRESCEND
    );
    local iteratorAll = luavsq.EventList.IndexIterator.new( list, kindAll );
    assert_true( iteratorAll:hasNext() );
    assert_equal( 0, iteratorAll:next() );
    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 1, list:get( 0 ).internalId );

    assert_true( iteratorAll:hasNext() );
    assert_equal( 1, iteratorAll:next() );
    assert_equal( 240, list:get( 1 ).clock );
    assert_equal( 2, list:get( 1 ).internalId );

    assert_true( iteratorAll:hasNext() );
    assert_equal( 2, iteratorAll:next() );
    assert_equal( 480, list:get( 2 ).clock );
    assert_equal( 3, list:get( 2 ).internalId );

    assert_true( iteratorAll:hasNext() );
    assert_equal( 3, iteratorAll:next() );
    assert_equal( 720, list:get( 3 ).clock );
    assert_equal( 4, list:get( 3 ).internalId );

    assert_true( iteratorAll:hasNext() );
    assert_equal( 4, iteratorAll:next() );
    assert_equal( 1920, list:get( 4 ).clock );
    assert_equal( 5, list:get( 4 ).internalId );

    assert_false( iteratorAll:hasNext() );
end
