dofile( "./test_bootstrap.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstruct()
    local handle = luavsq.IconDynamicsHandle.new();
    assert_equal( luavsq.ArticulationType.Dynaff, handle.articulation );
end

function testIsDynaffType()
    local handle = luavsq.IconDynamicsHandle.new();
    handle.iconID = nil;
    assert_false( handle:isDynaffType() );
    handle.iconID = "$05000000";
    assert_false( handle:isDynaffType() );
    handle.iconID = "$05010000";
    assert_true( handle:isDynaffType() );
end

function testIsCrescendType()
    local handle = luavsq.IconDynamicsHandle.new();
    handle.iconID = nil;
    assert_false( handle:isCrescendType() );
    handle.iconID = "$05000000";
    assert_false( handle:isCrescendType() );
    handle.iconID = "$05020000";
    assert_true( handle:isCrescendType() );
end

function testIsDecrescendType()
    local handle = luavsq.IconDynamicsHandle.new();
    handle.iconID = nil;
    assert_false( handle:isDecrescendType() );
    handle.iconID = "$05000000";
    assert_false( handle:isDecrescendType() );
    handle.iconID = "$05030000";
    assert_true( handle:isDecrescendType() );
end

function testClone()
    local handle = luavsq.IconDynamicsHandle.new();
    handle.iconID = "$05010000";
    handle.ids = "foo";
    handle.original = 1;
    handle.caption = "bar";
    handle.startDyn = 2;
    handle.endDyn = 3;
    handle.length = 4;
    handle.dynBP = nil;
    local copy = handle:clone();
    assert_equal( "$05010000", copy.iconID );
    assert_equal( "foo", copy.ids );
    assert_equal( 1, copy.original );
    assert_equal( "bar", copy.caption );
    assert_equal( 2, copy:getStartDyn() );
    assert_equal( 3, copy:getEndDyn() );
    assert_equal( 4, copy:getLength() );
    assert_nil( copy:getDynBP() );

    local dynBP = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 64 } );
    handle:setDynBP( dynBP );
    copy = handle:clone();
    assert_equal( "0=1,1=64", copy:getDynBP():getData() );
end

function testCastToHandle()
    local handle = luavsq.IconDynamicsHandle.new();
    handle.iconID = "$05010000";
    handle.ids = "foo";
    handle.original = 1;
    handle.caption = "bar";
    handle.dynBP = nil;
    handle.startDyn = 2;
    handle.endDyn = 3;
    handle.length = 4;
    local casted = handle:castToHandle();
    assert_equal( "$05010000", casted.iconID );
    assert_equal( "foo", casted.ids );
    assert_equal( 1, casted.original );
    assert_equal( "bar", casted.caption );
    assert_equal( nil, casted.dynBP );
    assert_equal( 2, casted.startDyn );
    assert_equal( 3, casted.endDyn );
    assert_equal( 4, casted.length );
end

function testGetterAndSetterCaption()
    local handle = luavsq.IconDynamicsHandle.new();
    handle:setCaption( "foo" );
    assert_equal( "foo", handle:getCaption() );
end

function testGetterAndSetterLength()
    local handle = luavsq.IconDynamicsHandle.new();
    local expected = 100;
    assert_not_equal( expected, handle:getLength() );
    handle:setLength( expected );
    assert_equal( expected, handle:getLength() );
end

function testGetterAndSetterStartDyn()
    local handle = luavsq.IconDynamicsHandle.new();
    local expected = 100;
    assert_not_equal( expected, handle:getStartDyn() );
    handle:setStartDyn( expected );
    assert_equal( expected, handle:getStartDyn() );
end

function testGetterAndSetterEndDyn()
    local handle = luavsq.IconDynamicsHandle.new();
    local expected = 100;
    assert_not_equal( expected, handle:getEndDyn() );
    handle:setEndDyn( expected );
    assert_equal( expected, handle:getEndDyn() );
end

function testGetterAndSetterDynBP()
    local handle = luavsq.IconDynamicsHandle.new();
    local dynBP = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 2 } );
    handle:setDynBP( nil );
    assert_nil( handle:getDynBP() );
    handle:setDynBP( dynBP );
    assert_equal( "0=1,1=2", handle:getDynBP():getData() );
end
