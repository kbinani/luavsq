require( "lunit" );
dofile( "../IdType.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testToString()
    assert_equal( "Singer", luavsq.IdType.toString( luavsq.IdType.Singer ) );
    assert_equal( "Anote", luavsq.IdType.toString( luavsq.IdType.Anote ) );
    assert_equal( "Aicon", luavsq.IdType.toString( luavsq.IdType.Aicon ) );
    assert_equal( "Unknown", luavsq.IdType.toString( luavsq.IdType.Unknown ) );
    assert_equal( "Unknown", luavsq.IdType.toString( nil ) );
end
