require( "lunit" );
dofile( "../TextStream.lua" );
module( "TextStreamTest", package.seeall, lunit.testcase );

function testConstruct()
    local stream = luavsq.TextStream.new();
    assert_false( stream:ready() );
    assert_equal( "", stream:toString() );
    assert_true( 0 > stream:getPointer() );
end

function testReadLine()
    local stream = luavsq.TextStream.new();
    stream.array = { "h", "e", "l", "\n", "l", "o" };
    stream.length = 6;
    assert_true( stream:ready() );
    assert_equal( "hel", stream:readLine() );
    assert_true( stream:ready() );
    assert_equal( "lo", stream:readLine() );
    assert_false( stream:ready() );
end

function testWrite()
    local stream = luavsq.TextStream.new();
    stream:write( "foo" );
    assert_equal( 2, stream:getPointer() );
    stream:setPointer( -1 );
    assert_equal( "foo", stream:readLine() );
end

function testWriteLine()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "foo" );
    assert_equal( 3, stream:getPointer() );
    stream:setPointer( -1 );
    assert_equal( "foo", stream:readLine() );
end

function testClose()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "foo" );
    -- エラーが起きなければ良しとする
    stream:close();
end

function testToString()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "foo" );
    stream:writeLine( "bar" );
    assert_equal( "foo\nbar\n", stream:toString() );
end
