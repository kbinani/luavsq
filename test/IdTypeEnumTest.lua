require( "lunit" );
dofile( "../IdTypeEnum.lua" );
module( "IdTypeTest", package.seeall, lunit.testcase );

function testToString()
    assert_equal( "Singer", luavsq.IdTypeEnum.toString( luavsq.IdTypeEnum.Singer ) );
    assert_equal( "Anote", luavsq.IdTypeEnum.toString( luavsq.IdTypeEnum.Anote ) );
    assert_equal( "Aicon", luavsq.IdTypeEnum.toString( luavsq.IdTypeEnum.Aicon ) );
    assert_equal( "Unknown", luavsq.IdTypeEnum.toString( luavsq.IdTypeEnum.Unknown ) );
    assert_equal( "Unknown", luavsq.IdTypeEnum.toString( nil ) );
end
