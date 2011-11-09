require( "lunit" );
dofile( "../BP.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstruct()
    local value = 64;
    local id = 1;
    local point = luavsq.BP.new( value, id );
    assert_equal( 64, point.value );
    assert_equal( 1, point.id );
end

function testClone()
    local value = 64;
    local id = 1;
    local point = luavsq.BP.new( value, id );
    local copy = point:clone();
    assert_equal( 64, copy.value );
    assert_equal( 1, copy.id );
end
