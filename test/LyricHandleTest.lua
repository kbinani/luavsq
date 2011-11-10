dofile( "./test_bootstrap.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstruct()
    local handle = luavsq.LyricHandle.new();
    assert_equal( 0, handle.index );
    assert_equal( 1, handle:getCount() );
    assert_equal( "a", handle:getLyricAt( 0 ).phrase );
    assert_equal( "a", handle:getLyricAt( 0 ):getPhoneticSymbol() );
end

function testConstructWithPhrase()
    local handle = luavsq.LyricHandle.new( "は", "h a" );
    assert_equal( 0, handle.index );
    assert_equal( 1, handle:getCount() );
    assert_equal( "は", handle:getLyricAt( 0 ).phrase );
    assert_equal( "h a", handle:getLyricAt( 0 ):getPhoneticSymbol() );
end

function testGetterAndSetterLyric()
    local handle = luavsq.LyricHandle.new( "は", "h a" );
    local lyric = luavsq.Lyric.new( "ら", "4 a" );
    handle:setLyricAt( 1, lyric );
    assert_equal( 2, handle:getCount() );
    assert_true( handle:getLyricAt( 1 ):equals( lyric ) );
end

function testClone()
    local handle = luavsq.LyricHandle.new( "ら", "4 a" );
    handle.index = 10;
    local copy = handle:clone();
    assert_equal( handle.index, copy.index );
    assert_true( handle:getLyricAt( 0 ):equals( copy:getLyricAt( 0 ) ) );
end

function testCastToHandle()
    local lyricHandle = luavsq.LyricHandle.new( "ら", "4 a" );
    lyricHandle.index = 10;
    local handle = lyricHandle:castToHandle();
    assert_equal( luavsq.HandleType.Lyric, handle._type );
    assert_equal( 1, #handle.lyrics );
    assert_equal( "ら", handle.lyrics[1].phrase );
    assert_equal( "4 a", handle.lyrics[1]:getPhoneticSymbol() );
    assert_equal( 10, handle.index );
end
