require( "lunit" );
dofile( "../ByteArrayOutputStream.lua" );
module( "ByteArrayOutputStreamTest", package.seeall, lunit.testcase );

function test()
    local stream = luavsq.ByteArrayOutputStream.new();
    assert_equal( -1, stream:getPointer() );
    stream:write( 0 );
    stream:write( 1 );
    assert_equal( 1, stream:getPointer() );
    stream:write( { 0, 0, 127, 0, 0 }, 3, 1 );
    stream:write( { 128, 255 }, 1, 2 );
    assert_equal( 4, stream:getPointer() );
    local actual = stream:toString();
    local expected = string.char( 0 ) .. string.char( 1 ) .. string.char( 127 ) .. string.char( 128 ) .. string.char( 255 );
    assert_equal( expected, actual );

    stream:seek( -1 );
    stream:write( 64 );
    assert_equal( 0, stream:getPointer() );
    expected = string.char( 64 ) .. string.char( 1 ) .. string.char( 127 ) .. string.char( 128 ) .. string.char( 255 );
    assert_equal( expected, stream:toString() );
end
