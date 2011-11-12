require( "lunit" );
dofile( "../NoteHeadHandle.lua" );
dofile( "../IconParameter.lua" );
dofile( "../ArticulationType.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleType.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstruct()
    local handle = luavsq.NoteHeadHandle.new();
    assert_equal( luavsq.ArticulationType.NoteAttack, handle.articulation );
end

function testConstructWithArguments()
    local ids = "foo";
    local iconId = "$05030000";
    local index = 1000;
    local handle = luavsq.NoteHeadHandle.new( ids, iconId, index );
    assert_equal( luavsq.ArticulationType.NoteAttack, handle.articulation );
    assert_equal( ids, handle.ids );
    assert_equal( iconId, handle.iconId );
    assert_equal( index, handle.index );
end

function testToString()
    local handle = luavsq.NoteHeadHandle.new();
    handle.ids = "foo";
    handle.caption = "bar";
    assert_equal( "foobar", handle:toString() );
end

function testGetterAndSetterDepth()
    local handle = luavsq.NoteHeadHandle.new();
    local expected = 1234;
    assert_not_equal( expected, handle:getDepth() );
    handle:setDepth( expected );
    assert_equal( expected, handle:getDepth() );
end

function testGetterAndSetterDuration()
    local handle = luavsq.NoteHeadHandle.new();
    local expected = 947;
    assert_not_equal( expected, handle:getDuration() );
    handle:setDuration( expected );
    assert_equal( expected, handle:getDuration() );
end

function testGetterAndSetterCaption()
    local handle = luavsq.NoteHeadHandle.new();
    local expected = "aho";
    assert_not_equal( expected, handle:getCaption() );
    handle:setCaption( expected );
    assert_equal( expected, handle:getCaption() );
end

function testGetterAndSetterLength()
    local handle = luavsq.NoteHeadHandle.new();
    local expected = 31347;
    assert_not_equal( expected, handle:getLength() );
    handle:setLength( expected );
    assert_equal( expected, handle:getLength() );
end

function testGetDisplayString()
    local handle = luavsq.NoteHeadHandle.new();
    handle.ids = "goo";
    handle.caption = "gle";
    assert_equal( "google", handle:getDisplayString() );
end

function testClone()
    local handle = luavsq.NoteHeadHandle.new();
    handle.index = 1;
    handle.iconId = "$05010000";
    handle.ids = "dwango";
    handle.original = 2;
    handle.caption = "niwango";
    handle:setLength( 3 );
    handle:setDuration( 4 );
    handle:setDepth( 5 );

    local copy = handle:clone();
    assert_equal( 1, copy.index );
    assert_equal( "$05010000", copy.iconId );
    assert_equal( "dwango", copy.ids );
    assert_equal( 2, copy.original );
    assert_equal( "niwango", copy.caption );
    assert_equal( 3, copy:getLength() );
    assert_equal( 4, copy:getDuration() );
    assert_equal( 5, copy:getDepth() );
end

function testCastToHandle()
    local handle = luavsq.NoteHeadHandle.new();
    handle.index = 1;
    handle.iconId = "$05010000";
    handle.ids = "dwango";
    handle.original = 2;
    handle.caption = "niwango";
    handle:setLength( 3 );
    handle:setDuration( 4 );
    handle:setDepth( 5 );

    local casted = handle:castToHandle();
    assert_equal( luavsq.HandleType.NoteHeadHandle, casted._type );
    assert_equal( 1, casted.index );
    assert_equal( "$05010000", casted.iconId );
    assert_equal( "dwango", casted.ids );
    assert_equal( 2, casted.original );
    assert_equal( "niwango", casted.caption );
    assert_equal( 3, casted.length );
    assert_equal( 4, casted.duration );
    assert_equal( 5, casted.depth );
end
