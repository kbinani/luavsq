require( "lunit" );
dofile( "../Util.lua" );
dofile( "../VsqPhoneticSymbol.lua" );
dofile( "../Lyric.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstructWithLine()
    local line = "あ,a,0.4,0,0";
    local lyric = luavsq.Lyric.new( line );
    assert_false( lyric.isProtected );
    assert_equal( "あ", lyric.phrase );
    assert_equal( "a", lyric:getPhoneticSymbol() );
    assert_equal( 0.4, lyric.lengthRatio );

    line = "あ\"\",a,1.0,0,0";
    lyric = luavsq.Lyric.new( line );
    assert_equal( "あ\"", lyric.phrase );

    line = "は,h a,1.0,64,0,1";
    lyric = luavsq.Lyric.new( line );
    assert_equal( "は", lyric.phrase );
    assert_true( lyric.isProtected );
    local symbols = lyric:getPhoneticSymbolList();
    assert_equal( 2, #symbols );
    assert_equal( "h", symbols[1] );
    assert_equal( "a", symbols[2] );
end

function testConstructWithPhrase()
    local lyric = luavsq.Lyric.new( "は", "h a" );
    assert_equal( "は", lyric.phrase );
    assert_equal( "h a", lyric:getPhoneticSymbol() );
    assert_equal( "64 0", lyric:getConsonantAdjustment() );
    assert_false( lyric.isProtected );
end

function testGetPhoneticSymbol()
    local lyric = luavsq.Lyric.new( "は,h a,1.0,64,0,0" );
    local actual = lyric:getPhoneticSymbol();
    assert_equal( "h a", actual );
end

function testGetPhoneticSymbolList()
    local lyric = luavsq.Lyric.new( "は,h a,1.0,64,0,0" );
    local actual = lyric:getPhoneticSymbolList();
    assert_equal( 2, #actual );
    assert_equal( "h", actual[1] );
    assert_equal( "a", actual[2] );
end

function testSetPhoneticSymbol()
    local lyric = luavsq.Lyric.new( "あ,a,1.0,0,0" );
    lyric:setPhoneticSymbol( "h a" );
    local actual = lyric:getPhoneticSymbolList();
    assert_equal( 2, #actual );
    assert_equal( "h", actual[1] );
    assert_equal( "a", actual[2] );
end

function testGetConsonantAdjustmentList()
    local lyric = luavsq.Lyric.new( "は,h a,1,64,0,0" );
    local actual = lyric:getConsonantAdjustmentList();
    assert_equal( 2, #actual );
    assert_equal( 64, actual[1] );
    assert_equal( 0, actual[2] );
end

function testGetConsonantAdjustmentListWithNil()
    local lyric = luavsq.Lyric.new( "は,h a,1,32,16,0" );
    local actual = lyric:getConsonantAdjustmentList();
    assert_equal( 2, #actual );
    assert_equal( 32, actual[1] );
    assert_equal( 16, actual[2] );

    lyric._consonantAdjustment = nil;
    actual = lyric:getConsonantAdjustmentList();
    assert_equal( 2, #actual );
    assert_equal( 64, actual[1] );
    assert_equal( 0, actual[2] );
end

function testGetConsonantAdjustment()
    local lyric = luavsq.Lyric.new( "は,h a,1,64,0,0" );
    local actual = lyric:getConsonantAdjustment();
    assert_equal( "64 0", actual );
end

function testToString()
    local expected = "は,h a,1,64,0,0";
    local lyric = luavsq.Lyric.new( expected );
    assert_equal( expected, lyric:toString() );
end

function testClone()
    local lyric = luavsq.Lyric.new( "は,h a,1,64,0,0" );
    local copy = lyric:clone();
    assert_equal( lyric:toString(), copy:toString() );
end

function testEquals()
    local a = luavsq.Lyric.new( "は,h a,1,64,0,0" );
    local b = luavsq.Lyric.new( "は,h a,1,64,0,0" );
    assert_true( a:equals( b ) );
    local c = luavsq.Lyric.new( "あ,a,1.0,0,0" );
    assert_false( a:equals( c ) );
end

function testEqualsForSynth()
    local a = luavsq.Lyric.new( "は,h a,1,64,0,0" );
    local b = luavsq.Lyric.new( "あ,h a,0.5,64,0,1" );
    assert_true( a:equalsForSynth( b ) );

    -- consonantAdjustmentだけ違う場合
    local c = luavsq.Lyric.new( "は,h a,1,64,1,0" );
    assert_false( a:equalsForSynth( c ) );

    -- 発音記号が違う場合
    local d = luavsq.Lyric.new( "は,h e,1,64,0,0" );
    assert_false( a:equalsForSynth( d ) );
end
