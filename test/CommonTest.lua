require( "lunit" );
dofile( "../Common.lua" );
dofile( "../DynamicsModeEnum.lua" );
dofile( "../PlayModeEnum.lua" );
dofile( "../TextStream.lua" );
dofile( "../Util.lua" );
module( "CommonTest", package.seeall, lunit.testcase );

function testConstructFromStream()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "Version=DSB303" );
    stream:writeLine( "Name=Foo" );
    stream:writeLine( "Color=1,2,3" );
    stream:writeLine( "DynamicsMode=1" );
    stream:writeLine( "PlayMode=1" );
    stream:setPointer( -1 );
    local lastLine = { value = "" };
    local common = luavsq.Common.new( stream, lastLine );
    assert_equal( "DSB303", common.version );
    assert_equal( "Foo", common.name );
    assert_equal( "1,2,3", common.color );
    assert_equal( luavsq.DynamicsModeEnum.EXPERT, common.dynamicsMode );
    assert_equal( luavsq.PlayModeEnum.PLAY_WITH_SYNTH, common.playMode );
end

function testConstructFromArguments()
    local common = luavsq.Common.new( "__foo__", 3, 4, 5, luavsq.DynamicsModeEnum.STANDARD, luavsq.PlayModeEnum.PLAY_AFTER_SYNTH );
    assert_equal( "__foo__", common.name );
    assert_equal( "3,4,5", common.color );
    assert_equal( luavsq.DynamicsModeEnum.STANDARD, common.dynamicsMode );
    assert_equal( luavsq.PlayModeEnum.PLAY_AFTER_SYNTH, common.playMode );
end

function testClone()
    local common = luavsq.Common.new( "__foo__", 3, 4, 5, luavsq.DynamicsModeEnum.STANDARD, luavsq.PlayModeEnum.PLAY_AFTER_SYNTH );
    local copy = common:clone();
    assert_equal( "__foo__", copy.name );
    assert_equal( "3,4,5", copy.color );
    assert_equal( luavsq.DynamicsModeEnum.STANDARD, copy.dynamicsMode );
    assert_equal( luavsq.PlayModeEnum.PLAY_AFTER_SYNTH, copy.playMode );
end

function testWrite()
    local common = luavsq.Common.new( "__foo__", 3, 4, 5, luavsq.DynamicsModeEnum.STANDARD, luavsq.PlayModeEnum.PLAY_AFTER_SYNTH );
    local stream = luavsq.TextStream.new();
    common:write( stream );
    local expected =
        "[Common]\n" ..
        "Version=DSB301\n" ..
        "Name=__foo__\n" ..
        "Color=3,4,5\n" ..
        "DynamicsMode=0\n" ..
        "PlayMode=0\n";
    assert_equal( expected, stream:toString() );
end
