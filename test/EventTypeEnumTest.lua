require( "lunit" );
dofile( "../EventTypeEnum.lua" );
module( "EventTypeEnumTest", package.seeall, lunit.testcase );

function testToString()
    assert_equal( "Singer", luavsq.EventTypeEnum.toString( luavsq.EventTypeEnum.SINGER ) );
    assert_equal( "Anote", luavsq.EventTypeEnum.toString( luavsq.EventTypeEnum.NOTE ) );
    assert_equal( "Aicon", luavsq.EventTypeEnum.toString( luavsq.EventTypeEnum.ICON ) );
    assert_equal( "Unknown", luavsq.EventTypeEnum.toString( luavsq.EventTypeEnum.UNKNOWN ) );
    assert_equal( "Unknown", luavsq.EventTypeEnum.toString( nil ) );
end
