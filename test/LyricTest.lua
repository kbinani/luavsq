require( "lunit" );
dofile( "../Util.lua" );
dofile( "../Lyric.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstructWithLine()
    local line = "あ,a,1.0,0,0";
    local lyric = luavsq.Lyric.new( line );
    assert_false( lyric.isProtected );
    assert_equal( "あ", lyric.Phrase );
    assert_equal( "a", lyric:getPhoneticSymbol() );

    line = "あ\"\",a,1.0,0,0";
    lyric = luavsq.Lyric.new( line );
    assert_equal( "あ\"", lyric.Phrase );

    line = "は,h a,1.0,64,0,1";
    lyric = luavsq.Lyric.new( line );
    assert_equal( "は", lyric.Phrase );
    assert_true( lyric.isProtected );
    local symbols = lyric:getPhoneticSymbolList();
    assert_equal( 2, #symbols );
    assert_equal( "h", symbols[1] );
    assert_equal( "a", symbols[2] );
end
