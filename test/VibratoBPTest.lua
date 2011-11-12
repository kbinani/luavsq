require( "lunit" );
dofile( "../VibratoBP.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstruct()
    local point = luavsq.VibratoBP.new();
    assert_equal( 0.0, point.x );
    assert_equal( 0, point.y );
end

function testConstructWithCoordinate()
    local point = luavsq.VibratoBP.new( 2.0, 3 );
    assert_equal( 2, point.x );
    assert_equal( 3, point.y );
end

function testCompareTo()
    local a = luavsq.VibratoBP.new( 2.0, 3 );
    local b = luavsq.VibratoBP.new( 2.0, 10 );
    assert_equal( 0, a:compareTo( b ) );

    local c = luavsq.VibratoBP.new( 1.0, 3 );
    assert_equal( 1, b:compareTo( c ) );
    assert_equal( -1, c:compareTo( b ) );
end

function testCompare()
    local a = luavsq.VibratoBP.new( 2.0, 3 );
    local b = luavsq.VibratoBP.new( 2.0, 10 );
    assert_equal( 0, luavsq.VibratoBP.compare( a, b ) );

    local c = luavsq.VibratoBP.new( 1.0, 3 );
    assert_equal( 1, luavsq.VibratoBP.compare( b, c ) );
    assert_equal( -1, luavsq.VibratoBP.compare( c, b ) );
end
