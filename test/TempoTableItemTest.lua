require( "lunit" );
dofile( "../TempoTableItem.lua" );
module( "TempoTableItemTest", package.seeall, lunit.testcase );

function testConstructor()
    local entry = luavsq.TempoTableItem.new();
    assert_equal( 0, entry.clock );
    assert_equal( 0, entry.tempo );
    assert_equal( 0.0, entry.time );

    entry = luavsq.TempoTableItem.new( 480, 500000, 0.5 );
    assert_equal( 480, entry.clock );
    assert_equal( 500000, entry.tempo );
    assert_equal( 0.5, entry.time );
end

function testToString()
    local entry = luavsq.TempoTableItem.new( 480, 500000, 0.5 );
    assert_equal( "{Clock=480, Tempo=500000, Time=0.5}", entry:toString() );
end

function testClone()
    local entry = luavsq.TempoTableItem.new( 480, 500000, 0.5 );
    local copy = entry:clone();
    assert_equal( 480, copy.clock );
    assert_equal( 500000, copy.tempo );
    assert_equal( 0.5, copy.time );
end

function testCompareTo()
    local a = luavsq.TempoTableItem.new();
    local b = luavsq.TempoTableItem.new( 480, 500000, 0.5 );
    assert_true( 0 < b:compareTo( a ) );
    assert_equal( 0, a:compareTo( a ) );
    assert_true( 0 > a:compareTo( b ) );
end

function testEquals()
    local a = luavsq.TempoTableItem.new( 480, 500000, 0.5 );
    local b = luavsq.TempoTableItem.new( 480, 500000, 0.5 );
    assert_true( a:equals( b ) );
    -- クロックは同じだがtimeが違う
    b.time = 1;
    assert_true( a:equals( b ) );
    b.clock = 1;
    b.time = 0.5;
    assert_false( a:equals( b ) );
end

function testCompare()
    local a = luavsq.TempoTableItem.new();
    local b = luavsq.TempoTableItem.new( 480, 500000, 0.5 );
    assert_false( luavsq.TempoTableItem.compare( b, a ) );
    assert_false( luavsq.TempoTableItem.compare( a, a ) );
    assert_true( luavsq.TempoTableItem.compare( a, b ) );
end