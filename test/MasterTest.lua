require( "lunit" );
dofile( "../Master.lua" );
dofile( "../TextStream.lua" );
dofile( "../Util.lua" );
module( "MasterTest", package.seeall, lunit.testcase );

function testConstructWithoutArgument()
    local master = luavsq.Master.new();
    assert_equal( 1, master.preMeasure );
end

function testConstructWithPreMeasure()
    local master = luavsq.Master.new( 10 );
    assert_equal( 10, master.preMeasure );
end

function testConstructFromStream()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "PreMeasure=12" );
    stream:setPointer( -1 );
    local lastLine = { value = "" };
    local master = luavsq.Master.new( stream, lastLine );
    assert_equal( 12, master.preMeasure );
end

function testWrite()
    local stream = luavsq.TextStream.new();
    local master = luavsq.Master.new( 14 );
    master:write( stream );
    local expected =
        "[Master]\n" ..
        "PreMeasure=14\n";
    assert_equal( expected, stream:toString() );
end

function testClone()
    local master = luavsq.Master.new( 15 );
    local copy = master:clone();
    assert_equal( 15, copy.preMeasure );
end
