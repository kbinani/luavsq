require( "lunit" );
dofile( "../TimesigTableEntry.lua" );
module( "TimesigTableEntryTest", package.seeall, lunit.testcase );

function testConstruct()
    local item = luavsq.TimesigTableEntry.new();
    assert_equal( 0, item.clock );
    assert_equal( 4, item.numerator );
    assert_equal( 4, item.denominator );
    assert_equal( 0, item.barCount );

    item = luavsq.TimesigTableEntry.new( 480, 3, 4, 1 );
    assert_equal( 480, item.clock );
    assert_equal( 3, item.numerator );
    assert_equal( 4, item.denominator );
    assert_equal( 1, item.barCount );
end

function testToString()
    local item = luavsq.TimesigTableEntry.new( 480, 3, 4, 1 );
    assert_equal( "{Clock=480, Numerator=3, Denominator=4, BarCount=1}", item:toString() );
end

function testClone()
    local item = luavsq.TimesigTableEntry.new( 480, 3, 4, 1 );
    local copy = item:clone();
    assert_equal( 480, copy.clock );
    assert_equal( 3, copy.numerator );
    assert_equal( 4, copy.denominator );
    assert_equal( 1, copy.barCount );
end

function testCompareTo()
    local a = luavsq.TimesigTableEntry.new( 480, 3, 4, 1 );
    local b = luavsq.TimesigTableEntry.new( 480, 3, 4, 1 );
    assert_equal( 0, a:compareTo( b ) );

    -- barCount が異なる
    a.barCount = 2;
    assert_true( 0 < a:compareTo( b ) );
    assert_true( 0 > b:compareTo( a ) );

    -- barCount が同じだが、他が異なる
    a.barCount = 1;
    a.clock = 1;
    assert_equal( 0, a:compareTo( b ) );
end

function testCompare()
    local a = luavsq.TimesigTableEntry.new( 480, 3, 4, 1 );
    local b = luavsq.TimesigTableEntry.new( 480, 3, 4, 1 );
    assert_equal( 0, luavsq.TimesigTableEntry.compare( a, b ) );

    -- barCount が異なる
    a.barCount = 2;
    assert_true( 0 <  luavsq.TimesigTableEntry.compare( a, b ) );
    assert_true( 0 > luavsq.TimesigTableEntry.compare( b, a ) );

    -- barCount が同じだが、他が異なる
    a.barCount = 1;
    a.clock = 1;
    assert_equal( 0, luavsq.TimesigTableEntry.compare( a, b ) );
end
