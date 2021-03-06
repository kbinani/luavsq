require( "lunit" );
dofile( "../Tempo.lua" );
module( "TempoTest", package.seeall, lunit.testcase );

function testConstructor()
    local entry = luavsq.Tempo.new();
    assert_equal( 0, entry.clock );
    assert_equal( 0, entry.tempo );
    assert_equal( 0.0, entry:getTime() );

    entry = luavsq.Tempo.new( 480, 500000 );
    assert_equal( 480, entry.clock );
    assert_equal( 500000, entry.tempo );
end

function testToString()
    local entry = luavsq.Tempo.new( 480, 500000 );
    assert_equal( "{Clock=480, Tempo=500000, Time=0}", entry:toString() );
end

function testClone()
    local entry = luavsq.Tempo.new( 480, 500000 );
    entry._time = 0.5;

    local copy = entry:clone();
    assert_equal( 480, copy.clock );
    assert_equal( 500000, copy.tempo );
    assert_equal( 0.5, copy:getTime() );
end

function testCompareTo()
    local a = luavsq.Tempo.new();
    local b = luavsq.Tempo.new( 480, 500000 );
    assert_true( 0 < b:compareTo( a ) );
    assert_equal( 0, a:compareTo( a ) );
    assert_true( 0 > a:compareTo( b ) );
end

function testEquals()
    local a = luavsq.Tempo.new( 480, 500000 );
    local b = luavsq.Tempo.new( 480, 500000 );
    a._time = 0.5;
    b._time = 0.5;
    assert_true( a:equals( b ) );
    -- クロックは同じだがtimeが違う
    b._time = 1;
    assert_true( a:equals( b ) );
    b.clock = 1;
    b._time = 0.5;
    assert_false( a:equals( b ) );
end

function testCompare()
    local a = luavsq.Tempo.new();
    local b = luavsq.Tempo.new( 480, 500000 );
    assert_false( luavsq.Tempo.compare( b, a ) );
    assert_false( luavsq.Tempo.compare( a, a ) );
    assert_true( luavsq.Tempo.compare( a, b ) );
end
