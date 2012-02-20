require( "lunit" );
dofile( "../Util.lua" );
dofile( "../Log.lua" );
module( "UtilTest", package.seeall, lunit.testcase );

function testSplit()
    local value = "\t\tfoo\t\tbar"
    local actual = luavsq.Util.split( value, "\t\t" )
    assert_table( actual )
    assert_equal( 3, table.maxn( actual ) )
    assert_equal( "", actual[1] )
    assert_equal( "foo", actual[2] )
    assert_equal( "bar", actual[3] )
end

function testSplitNotSplitted()
    local value = "foo,bar"
    local actual = luavsq.Util.split( value, "\t" )
    assert_table( actual )
    assert_equal( 1, table.maxn( actual ) )
    assert_equal( value, actual[1] )
end

function testArray()
    local array = luavsq.Util.array( 2 )
    assert_table( array )
    assert_equal( 2, #array )
    assert_false( array[1] )
    assert_false( array[2] )
end

function testSearchArray()
    local array = { "a", "b", "c" };
    assert_equal( 2, luavsq.Util.searchArray( array, "b" ) );
    assert_equal( -1, luavsq.Util.searchArray( array, "A" ) );
    assert_equal( -1, luavsq.Util.searchArray( nil, "a" ) );
end

function testMakeUInt16BE()
    local bytes = { 0x12, 0x34 };
    assert_equal( 0x1234, luavsq.Util.makeUInt16BE( bytes ) );
end

function testMakeUInt32BE()
    local bytes = { 0x12, 0x34, 0x56, 0x78 };
    assert_equal( 0x12345678, luavsq.Util.makeUInt32BE( bytes ) );
end

function testGetBytesUInt16BE()
    local bytes = luavsq.Util.getBytesUInt16BE( 0x1234 );
    assert_equal( 2, #bytes );
    assert_equal( 0x12, bytes[1] );
    assert_equal( 0x34, bytes[2] );
end

function testGetBytesUInt32BE()
    local bytes = luavsq.Util.getBytesUInt32BE( 0x12345678 );
    assert_equal( 4, #bytes );
    assert_equal( 0x12, bytes[1] );
    assert_equal( 0x34, bytes[2] );
    assert_equal( 0x56, bytes[3] );
    assert_equal( 0x78, bytes[4] );
end

function testSort()
    local array = { 1, 2, 3, 8, 7, 6, 5, 4, 9 };
    luavsq.Util.sort( array, 3, 5 );
    local expected = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
    local i;
    for i = 1, #expected, 1 do
        assert_equal( expected[i], array[i] );
    end

    array = { 210, 236, 240, 0 };
    luavsq.Util.sort( array, 0, 3 );
    expected = { 210, 236, 240, 0 };
    for i = 1, #expected, 1 do
        assert_equal( expected[i], array[i] );
    end
end

function testAnd()
    assert_equal( 0, luavsq.Util.band( 0x1, 0x2 ) );
    assert_equal( 1, luavsq.Util.band( 0x1, 0x1 ) );
    assert_equal( 0x6, luavsq.Util.band( 0xf, 0x6 ) );
    assert_equal( 0x80000000, luavsq.Util.band( 0xC0000000, 0x80000000 ) );
    assert_equal( 0x0, luavsq.Util.band( 0x0, 0xC0000000, 0x80000000 ) );
    assert_nil( luavsq.Util.band() );
end

function testOr()
    assert_equal( 0xC0000000, luavsq.Util.bor( 0x0, 0x40000000, 0x80000000 ) );
    assert_nil( luavsq.Util.bor() );
end

function testLShift()
    local n = 0x1;
    assert_equal( 0x1, luavsq.Util.lshift( n, 0 ) )
    assert_equal( 0x2, luavsq.Util.lshift( n, 1 ) );
    assert_equal( 0x10, luavsq.Util.lshift( n, 4 ) );
    assert_equal( 0x8000000000000000, luavsq.Util.lshift( n, 63 ) );
    assert_equal( 0x0, luavsq.Util.lshift( n, 64 ) );
end

function testRShift()
    local n = 0x8002;
    assert_equal( 0x4001, luavsq.Util.rshift( n, 1 ) );
    assert_equal( 0x2000, luavsq.Util.rshift( n, 2 ) );
    assert_equal( 0x1000, luavsq.Util.rshift( n, 3 ) );
    assert_equal( 0x800, luavsq.Util.rshift( n, 4 ) );
    assert_equal( 0x400, luavsq.Util.rshift( n, 5 ) );
    assert_equal( 0x200, luavsq.Util.rshift( n, 6 ) );
    assert_equal( 0x100, luavsq.Util.rshift( n, 7 ) );
    assert_equal( 0x80, luavsq.Util.rshift( n, 8 ) );
    assert_equal( 0x40, luavsq.Util.rshift( n, 9 ) );
    assert_equal( 0x20, luavsq.Util.rshift( n, 10 ) );
    assert_equal( 0x10, luavsq.Util.rshift( n, 11 ) );
    assert_equal( 0x8, luavsq.Util.rshift( n, 12 ) );
    assert_equal( 0x4, luavsq.Util.rshift( n, 13 ) );
    assert_equal( 0x2, luavsq.Util.rshift( n, 14 ) );
    assert_equal( 0x1, luavsq.Util.rshift( n, 15 ) );
    assert_equal( 0x0, luavsq.Util.rshift( n, 16 ) );
    assert_equal( 0x0, luavsq.Util.rshift( n, 17 ) );
end

function testStringToArray()
    local s = "abc";
    local actual = luavsq.Util.stringToArray( s );
    assert_equal( 3, #actual );
    assert_equal( string.byte( "a" ), actual[1] );
    assert_equal( string.byte( "b" ), actual[2] );
    assert_equal( string.byte( "c" ), actual[3] );
end

function testDump()
    local tmpFile = os.tmpname();
    local fp = io.open( tmpFile, "w" );

    local f = { 3, 4 };
    local t = { 1, "a", { ["b"] = fp }, { ["c"] = fp }, f, f };

    local actual = luavsq.Util.dump( t );

    local expected =
        "table(6){\n" ..
        "    1 => 1,\n" ..
        "    2 => 'a',\n" ..
        "    3 => table(1){\n" ..
        "        'b' => userdata,\n" ..
        "    },\n" ..
        "    4 => table(1){\n" ..
        "        'c' => userdata,\n" ..
        "    },\n" ..
        "    5 => table(2){\n" ..
        "        1 => 3,\n" ..
        "        2 => 4,\n" ..
        "    },\n" ..
        "    6 => (cycromatic reference),\n" ..
        "},";

    assert_equal( expected, actual );
end

function testExplodeUTF8String()
    local s =
        "0" .. -- 0x30
        "Ǻ" .. --0xC7 0xBA
        "☺" .. -- 0xE2 0x98 0xBA
        string.char( 0xF7 ) .. string.char( 0xBF ) .. string.char( 0xBF ) .. string.char( 0xBF ) ..
        string.char( 0xFB ) .. string.char( 0xBF ) .. string.char( 0xBF ) .. string.char( 0xBF ) .. string.char( 0xBF ) ..
        string.char( 0xFC ) .. string.char( 0x84 ) .. string.char( 0x80 ) .. string.char( 0x80 ) .. string.char( 0x80 ) .. string.char( 0x80 );
    local actual = luavsq.Util.explodeUTF8String( s );

    assert_equal( 6, #actual );

    assert_equal( 1, #actual[1] );
    assert_equal( 0x30, actual[1][1] );

    assert_equal( 2, #actual[2] );
    assert_equal( 0xC7, actual[2][1] );
    assert_equal( 0xBA, actual[2][2] );

    assert_equal( 3, #actual[3] );
    assert_equal( 0xE2, actual[3][1] );
    assert_equal( 0x98, actual[3][2] );
    assert_equal( 0xBA, actual[3][3] );

    assert_equal( 4, #actual[4] );
    assert_equal( 0xF7, actual[4][1] );
    assert_equal( 0xBF, actual[4][2] );
    assert_equal( 0xBF, actual[4][3] );
    assert_equal( 0xBF, actual[4][4] );

    assert_equal( 5, #actual[5] );
    assert_equal( 0xFB, actual[5][1] );
    assert_equal( 0xBF, actual[5][2] );
    assert_equal( 0xBF, actual[5][3] );
    assert_equal( 0xBF, actual[5][4] );
    assert_equal( 0xBF, actual[5][5] );

    assert_equal( 6, #actual[6] );
    assert_equal( 0xFC, actual[6][1] );
    assert_equal( 0x84, actual[6][2] );
    assert_equal( 0x80, actual[6][3] );
    assert_equal( 0x80, actual[6][4] );
    assert_equal( 0x80, actual[6][5] );
    assert_equal( 0x80, actual[6][6] );
end

function testExport()
    local a = { keyA = "valueA", keyB = 1 };
    local expected = "{keyA='valueA',keyB=1,}";
    local actual = luavsq.Util.export( a );
    assert_equal( expected, actual );
end
