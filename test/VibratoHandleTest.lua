require( "lunit" );
dofile( "../Util.lua" );
dofile( "../ArticulationType.lua" );
dofile( "../IconParameter.lua" );
dofile( "../VibratoBP.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../VibratoHandle.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleType.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testToString()
    local handle = luavsq.VibratoHandle.new();
    handle:setCaption( "foo" );
    assert_equal( "foo", handle:toString() );
end

function testGetterAndSetterRateBP()
    local handle = luavsq.VibratoHandle.new();
    local rateBP = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 128 } );
    assert_not_equal( "0=1,1=128", handle:getRateBP():getData() );
    handle:setRateBP( rateBP );
    assert_equal( "0=1,1=128", handle:getRateBP():getData() );
end

function testGetterAndSetterDepthBP()
    local handle = luavsq.VibratoHandle.new();
    local depthBP = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 128 } );
    assert_not_equal( "0=1,1=128", handle:getDepthBP():getData() );
    handle:setDepthBP( depthBP );
    assert_equal( "0=1,1=128", handle:getDepthBP():getData() );
end

function testGetterAndSetterCaption()
    local handle = luavsq.VibratoHandle.new();
    local expected = "asdf";
    assert_not_equal( expected, handle:getCaption() );
    handle:setCaption( expected );
    assert_equal( expected, handle:getCaption() );
end

function testGetterAndSetterStartRate()
    local handle = luavsq.VibratoHandle.new();
    local expected = 12345;
    assert_not_equal( expected, handle:getStartRate() );
    handle:setStartRate( expected );
    assert_equal( expected, handle:getStartRate() );
end

function testGetterAndSetterStartDepth()
    local handle = luavsq.VibratoHandle.new();
    local expected = 12345;
    assert_not_equal( expected, handle:getStartDepth() );
    handle:setStartDepth( expected );
    assert_equal( expected, handle:getStartDepth() );
end

function testGetterAndSetterLength()
    local handle = luavsq.VibratoHandle.new();
    local expected = 9999;
    assert_not_equal( handle:getLength() );
    handle:setLength( expected );
    assert_equal( expected, handle:getLength() );
end

function testGetDisplayString()
    local handle = luavsq.VibratoHandle.new();
    handle:setCaption( "yahoo" );
    assert_equal( "yahoo", handle:getDisplayString() );
end

function testClone()
    local handle = luavsq.VibratoHandle.new();
    handle.index = 1;
    handle.iconID = "hahaha";
    handle.ids = "baka";
    handle.original = 2;
    handle:setCaption( "aho" );
    handle:setLength( 3 );
    handle:setStartDepth( 4 );
    handle:setDepthBP( luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 32, 56 } ) );
    handle:setStartRate( 5 );
    handle:setRateBP( luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 64, 128 } ) );
    local copy = handle:clone();
    assert_equal( 1, copy.index );
    assert_equal( "hahaha", copy.iconID );
    assert_equal( "baka", copy.ids );
    assert_equal( 2, copy.original );
    assert_equal( "aho", copy:getCaption() );
    assert_equal( 3, copy:getLength() );
    assert_equal( 4, copy:getStartDepth() );
    assert_equal( "0=32,1=56", copy:getDepthBP():getData() );
    assert_equal( 5, copy:getStartRate() );
    assert_equal( "0=64,1=128", copy:getRateBP():getData() );
end

function testCastToHandle()
    local vibratoHandle = luavsq.VibratoHandle.new();
    vibratoHandle.index = 1;
    vibratoHandle.iconID = "hahaha";
    vibratoHandle.ids = "baka";
    vibratoHandle.original = 2;
    vibratoHandle:setCaption( "aho" );
    vibratoHandle:setLength( 3 );
    vibratoHandle:setStartDepth( 4 );
    vibratoHandle:setDepthBP( luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 32, 56 } ) );
    vibratoHandle:setStartRate( 5 );
    vibratoHandle:setRateBP( luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 64, 128 } ) );

    local handle = vibratoHandle:castToHandle();
    assert_equal( luavsq.HandleType.Vibrato, handle._type );
    assert_equal( 1, handle.index );
    assert_equal( "hahaha", handle.iconID );
    assert_equal( "baka", handle.ids );
    assert_equal( 2, handle.original );
    assert_equal( "aho", handle.caption );
    assert_equal( 3, handle:getLength() );
    assert_equal( 4, handle.startDepth );
    assert_equal( "0=32,1=56", handle.depthBP:getData() );
    assert_equal( 5, handle.startRate );
    assert_equal( "0=64,1=128", handle.rateBP:getData() );
end
