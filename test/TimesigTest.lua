require( "lunit" );
dofile( "../Timesig.lua" );
module( "TimesigTest", package.seeall, lunit.testcase );

function testConstructor()
    local timesig = luavsq.Timesig.new();
    assert_equal( 0, timesig.numerator );
    assert_equal( 0, timesig.denominator );

    timesig = luavsq.Timesig.new( 3, 4 );
    assert_equal( 3, timesig.numerator );
    assert_equal( 4, timesig.denominator );
end
