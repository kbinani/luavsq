require( "lunit" );
dofile( "../VibratoBPList.lua" );
dofile( "../VibratoBP.lua" );
dofile( "../Util.lua" );
module( "VibratoBPListTest", package.seeall, lunit.testcase );

function testConstructWithString()
    local list = luavsq.VibratoBPList.new( "2", "1.0,0.0", "128,1" );
    assert_equal( 2, list:size() );
    assert_equal( "0=1,1=128", list:getData() );
end

function testConstructWithArray()
    local list = luavsq.VibratoBPList.new( { 1.0, 0.0 }, { 128, 1 } );
    assert_equal( 2, list:size() );
    assert_equal( "0=1,1=128", list:getData() );
end

function testGetValueAt()
    local list = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 128 } );
    assert_equal( 1, list:getValueAt( 0.0 ) );
    assert_equal( 1, list:getValueAt( 0.99999 ) );
    assert_equal( 128, list:getValueAt( 1.0 ) );
    assert_equal( 64, list:getValueAt( -0.0000001, 64 ) );
end

function testClone()
    local list = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 128 } );
    local copy = list:clone();
    assert_equal( "0=1,1=128", copy:getData() );
end

function testGetCount()
    local list = luavsq.VibratoBPList.new( { 0.0, 0.4, 1.0 }, { 1, 64, 128 } );
    assert_equal( 3, list:size() );
end

function testGet()
    local list = luavsq.VibratoBPList.new( { 0.4, 0.0, 1.0 }, { 64, 1, 128 } );
    assert_equal( 0, list:get( 0 ).x );
    assert_equal( 1, list:get( 0 ).y );
    assert_equal( 0.4, list:get( 1 ).x );
    assert_equal( 64, list:get( 1 ).y );
    assert_equal( 1, list:get( 2 ).x );
    assert_equal( 128, list:get( 2 ).y );
end

function testSet()
    local list = luavsq.VibratoBPList.new( { 0.0, 0.4, 1.0 }, { 1, 64, 128 } );
    list:set( 1, luavsq.VibratoBP.new( 0.2, 32 ) );
    assert_equal( 0.2, list:get( 1 ).x );
    assert_equal( 32, list:get( 1 ).y );
end

function testGetData()
    local list = luavsq.VibratoBPList.new( { 0.0, 0.4, 1.0 }, { 1, 64, 128 } );
    assert_equal( "0=1,0.4=64,1=128", list:getData() );
    list = luavsq.VibratoBPList.new( {}, {} );
    assert_equal( "", list:getData() );
end

function testSetData()
    local list = luavsq.VibratoBPList.new( {}, {} );
    list:setData( "0.4=64,0=1,1=128" );
    assert_equal( 3, list:size() );
    assert_equal( 0, list:get( 0 ).x );
    assert_equal( 1, list:get( 0 ).y );
    assert_equal( 0.4, list:get( 1 ).x );
    assert_equal( 64, list:get( 1 ).y );
    assert_equal( 1, list:get( 2 ).x );
    assert_equal( 128, list:get( 2 ).y );
end
