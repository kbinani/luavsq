require( "lunit" );
dofile( "../IDType.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testToString()
    assert_equal( "Singer", luavsq.IDType.toString( luavsq.IDType.Singer ) );
    assert_equal( "Anote", luavsq.IDType.toString( luavsq.IDType.Anote ) );
    assert_equal( "Aicon", luavsq.IDType.toString( luavsq.IDType.Aicon ) );
    assert_equal( "Unknown", luavsq.IDType.toString( luavsq.IDType.Unknown ) );
    assert_equal( "Unknown", luavsq.IDType.toString( nil ) );
end
