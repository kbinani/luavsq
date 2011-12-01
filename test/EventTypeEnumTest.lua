require( "lunit" );
dofile( "../EventTypeEnum.lua" );
module( "EventTypeEnumTest", package.seeall, lunit.testcase );

function testToString()
    assert_equal( "Singer", luavsq.EventTypeEnum.toString( luavsq.EventTypeEnum.Singer ) );
    assert_equal( "Anote", luavsq.EventTypeEnum.toString( luavsq.EventTypeEnum.Anote ) );
    assert_equal( "Aicon", luavsq.EventTypeEnum.toString( luavsq.EventTypeEnum.Aicon ) );
    assert_equal( "Unknown", luavsq.EventTypeEnum.toString( luavsq.EventTypeEnum.Unknown ) );
    assert_equal( "Unknown", luavsq.EventTypeEnum.toString( nil ) );
end
