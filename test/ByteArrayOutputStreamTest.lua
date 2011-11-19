require( "lunit" );
dofile( "../ByteArrayOutputStream.lua" );
module( "ByteArrayOutputStreamTest", package.seeall, lunit.testcase );

function test()
    local stream = luavsq.ByteArrayOutputStream.new();
    stream:write( 0 );
    stream:write( 1 );
    stream:write( { 0, 0, 127, 0, 0 }, 3, 1 );
    stream:write( { 128, 255 }, 1, 2 );
    local actual = stream:toString();
    local expected = string.char( 0 ) .. string.char( 1 ) .. string.char( 127 ) .. string.char( 128 ) .. string.char( 255 );
    assert_equal( expected, actual );
end
