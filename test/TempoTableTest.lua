require( "lunit" );
dofile( "../TempoList.lua" );
dofile( "../List.lua" );
dofile( "../Tempo.lua" );
dofile( "../List.Iterator.lua" );
module( "TempoListTest", package.seeall, lunit.testcase );

---
-- push, get, set, size のテスト
function test()
    local list = luavsq.TempoList.new();
    assert_equal( 0, list:size() );
    list:push( luavsq.Tempo.new( 0, 500000 ) );
    list:push( luavsq.Tempo.new( 480, 525000 ) );
    list:updateTempoInfo();

    assert_equal( 2, list:size() );
    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 500000, list:get( 0 ).tempo );
    assert_equal( 0.0, list:get( 0 ):getTime() );
    assert_equal( 480, list:get( 1 ).clock );
    assert_equal( 525000, list:get( 1 ).tempo );
    assert_equal( 0.5, list:get( 1 ):getTime() );
end

function testIterator()
    local list = luavsq.TempoList.new();
    assert_equal( 0, list:size() );
    list:push( luavsq.Tempo.new( 0, 500000 ) );
    list:push( luavsq.Tempo.new( 480, 525000 ) );
    list:updateTempoInfo();

    local i = list:iterator();
    assert_true( i:hasNext() );
    local item = i:next();
    assert_equal( 0, item.clock );
    assert_equal( 500000, item.tempo );
    assert_equal( 0.0, item:getTime() );
    assert_true( i:hasNext() );
    item = i:next();
    assert_equal( 480, item.clock );
    assert_equal( 525000, item.tempo );
    assert_equal( 0.5, item:getTime() );
    assert_false( i:hasNext() );
end

function testSort()
    local list = luavsq.TempoList.new();
    list:push( luavsq.Tempo.new( 480, 525000 ) );
    list:push( luavsq.Tempo.new( 0, 500000 ) );
    list:get( 0 )._time = 0.5;

    list:sort();

    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 500000, list:get( 0 ).tempo );
    assert_equal( 0.0, list:get( 0 ):getTime() );
    assert_equal( 480, list:get( 1 ).clock );
    assert_equal( 525000, list:get( 1 ).tempo );
    assert_equal( 0.5, list:get( 1 ):getTime() );
end

function testClockFromSec()
    local list = luavsq.TempoList.new();
    list:push( luavsq.Tempo.new( 480, 480000 ) );
    list:push( luavsq.Tempo.new( 0, 500000 ) );
    list:updateTempoInfo();

    assert_equal( 0, list:getClockFromSec( 0.0 ) );
    assert_equal( 480, list:getClockFromSec( 0.5 ) );
    assert_equal( 384, list:getClockFromSec( 0.4 ) );
    assert_equal( 680, list:getClockFromSec( 0.7 ) );
end

function testUpdateTempoInfo()
    local list = luavsq.TempoList.new();
    list:updateTempoInfo();
    assert_equal( 1, list:size() );
    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 500000, list:get( 0 ).tempo );
    assert_equal( 0.0, list:get( 0 ):getTime() );

    list = luavsq.TempoList.new();
    list:push( luavsq.Tempo.new( 480, 525000 ) );
    list:push( luavsq.Tempo.new( 0, 500000 ) );
    list:updateTempoInfo();
    assert_equal( 2, list:size() );
    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 500000, list:get( 0 ).tempo );
    assert_equal( 0.0, list:get( 0 ):getTime() );
    assert_equal( 480, list:get( 1 ).clock );
    assert_equal( 525000, list:get( 1 ).tempo );
    assert_equal( 0.5, list:get( 1 ):getTime() );
end

function testGetSecFromClock()
    list = luavsq.TempoList.new();
    list:push( luavsq.Tempo.new( 480, 480000 ) );
    list:push( luavsq.Tempo.new( 0, 500000 ) );
    list:updateTempoInfo();

    assert_equal( 0.0, list:getSecFromClock( 0 ) );
    assert_equal( 0.5, list:getSecFromClock( 480 ) );
    assert_equal( 0.4, list:getSecFromClock( 384 ) );
    assert_equal( 0.7, list:getSecFromClock( 680 ) );
end

function testGetTempoAt()
    local list = luavsq.TempoList.new();
    list:push( luavsq.Tempo.new( 480, 480000 ) );
    list:push( luavsq.Tempo.new( 0, 500000 ) );
    list:updateTempoInfo();

    assert_equal( 500000, list:getTempoAt( 0 ) );
    assert_equal( 500000, list:getTempoAt( 479 ) );
    assert_equal( 480000, list:getTempoAt( 480 ) );
end
