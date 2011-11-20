require( "lunit" );
dofile( "../CP932Converter.lua" );
dofile( "../Util.lua" );
module( "CP932ConverterTest", package.seeall, lunit.testcase );

function testConvertFromUTF8()
    local s = "aあ\t\n";
    local actual = luavsq.CP932Converter.convertFromUTF8( s );
    local expected = string.char( 0x61 ) .. string.char( 0x82 ) .. string.char( 0xA0 ) .. "\t\n";
    assert_equal( expected, actual );
end

function test_getUnicodeBytesFromUTF8Bytes()
    local a = nil;

    -- 1 byte
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0x00 } );
    assert_equal( 1, #a );
    assert_equal( 0x00, a[1] );
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0x7F } );
    assert_equal( 1, #a );
    assert_equal( 0x7F, a[1] );

    -- 2 bytes
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xC2, 0x80 } );
    assert_equal( 1, #a );
    assert_equal( 0x80, a[1] );
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xDF, 0xBF } );
    assert_equal( 2, #a );
    assert_equal( 0x07, a[1] );
    assert_equal( 0xFF, a[2] );

    -- 3 bytes
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xE0, 0xA0, 0x80 } );
    assert_equal( 2, #a );
    assert_equal( 0x08, a[1] );
    assert_equal( 0x00, a[2] );
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xEF, 0xBF, 0xBF } );
    assert_equal( 2, #a );
    assert_equal( 0xFF, a[1] );
    assert_equal( 0xFF, a[2] );

    -- 4 bytes
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xF0, 0x90, 0x80, 0x80 } );
    assert_equal( 3, #a );
    assert_equal( 0x01, a[1] );
    assert_equal( 0x00, a[2] );
    assert_equal( 0x00, a[3] );
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xF7, 0xBF, 0xBF, 0xBF } );
    assert_equal( 3, #a );
    assert_equal( 0x1F, a[1] );
    assert_equal( 0xFF, a[2] );
    assert_equal( 0xFF, a[3] );

    -- 5 bytes
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xF8, 0x88, 0x80, 0x80, 0x80 } );
    assert_equal( 3, #a );
    assert_equal( 0x20, a[1] );
    assert_equal( 0x00, a[2] );
    assert_equal( 0x00, a[3] )
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xFB, 0xBF, 0xBF, 0xBF, 0xBF } );
    assert_equal( 4, #a );
    assert_equal( 0x03, a[1] );
    assert_equal( 0xFF, a[2] );
    assert_equal( 0xFF, a[3] );
    assert_equal( 0xFF, a[4] )

    -- 6 bytes
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xFC, 0x84, 0x80, 0x80, 0x80, 0x80 } );
    assert_equal( 4, #a );
    assert_equal( 0x04, a[1] );
    assert_equal( 0x00, a[2] );
    assert_equal( 0x00, a[3] );
    assert_equal( 0x00, a[4] );
    a = luavsq.CP932Converter._getUnicodeBytesFromUTF8Bytes( { 0xFD, 0xBF, 0xBF, 0xBF, 0xBF, 0xBF } );
    assert_equal( 4, #a );
    assert_equal( 0x7F, a[1] );
    assert_equal( 0xFF, a[2] );
    assert_equal( 0xFF, a[3] );
    assert_equal( 0xFF, a[4] );
end
