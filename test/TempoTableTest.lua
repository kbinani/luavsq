require( "lunit" );
dofile( "../TempoTable.lua" );
dofile( "../List.lua" );
dofile( "../TempoTableEntry.lua" );
module( "TempoTableTest", package.seeall, lunit.testcase );

---
-- push, get, set, size のテスト
function test()
    local list = luavsq.TempoTable.new();
    assert_equal( 0, list:size() );
    list:push( luavsq.TempoTableEntry.new( 0, 500000, 0.0 ) );
    list:push( luavsq.TempoTableEntry.new( 480, 525000, 0.5 ) );
    assert_equal( 2, list:size() );
    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 500000, list:get( 0 ).tempo );
    assert_equal( 0.0, list:get( 0 ).time );
    assert_equal( 480, list:get( 1 ).clock );
    assert_equal( 525000, list:get( 1 ).tempo );
    assert_equal( 0.5, list:get( 1 ).time );
end

function testIterator()
    local list = luavsq.TempoTable.new();
    assert_equal( 0, list:size() );
    list:push( luavsq.TempoTableEntry.new( 0, 500000, 0.0 ) );
    list:push( luavsq.TempoTableEntry.new( 480, 525000, 0.5 ) );
    local i = list:iterator();
    assert_true( i:hasNext() );
    local item = i:next();
    assert_equal( 0, item.clock );
    assert_equal( 500000, item.tempo );
    assert_equal( 0.0, item.time );
    assert_true( i:hasNext() );
    item = i:next();
    assert_equal( 480, item.clock );
    assert_equal( 525000, item.tempo );
    assert_equal( 0.5, item.time );
    assert_false( i:hasNext() );
end

function testSort()
    local list = luavsq.TempoTable.new();
    list:push( luavsq.TempoTableEntry.new( 480, 525000, 0.5 ) );
    list:push( luavsq.TempoTableEntry.new( 0, 500000, 0.0 ) );

    list:sort();

    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 500000, list:get( 0 ).tempo );
    assert_equal( 0.0, list:get( 0 ).time );
    assert_equal( 480, list:get( 1 ).clock );
    assert_equal( 525000, list:get( 1 ).tempo );
    assert_equal( 0.5, list:get( 1 ).time );
end

function testClockFromSec()
    local list = luavsq.TempoTable.new();
    list:push( luavsq.TempoTableEntry.new( 480, 480000, 0.0 ) );
    list:push( luavsq.TempoTableEntry.new( 0, 500000, 0.0 ) );
    list:updateTempoInfo();

    assert_equal( 0, list:getClockFromSec( 0.0 ) );
    assert_equal( 480, list:getClockFromSec( 0.5 ) );
    assert_equal( 384, list:getClockFromSec( 0.4 ) );
    assert_equal( 680, list:getClockFromSec( 0.7 ) );
end

function testUpdateTempoInfo()
    local list = luavsq.TempoTable.new();
    list:updateTempoInfo();
    assert_equal( 1, list:size() );
    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 500000, list:get( 0 ).tempo );
    assert_equal( 0.0, list:get( 0 ).time );

    list = luavsq.TempoTable.new();
    list:push( luavsq.TempoTableEntry.new( 480, 525000, 0.0 ) );
    list:push( luavsq.TempoTableEntry.new( 0, 500000, 0.0 ) );
    list:updateTempoInfo();
    assert_equal( 2, list:size() );
    assert_equal( 0, list:get( 0 ).clock );
    assert_equal( 500000, list:get( 0 ).tempo );
    assert_equal( 0.0, list:get( 0 ).time );
    assert_equal( 480, list:get( 1 ).clock );
    assert_equal( 525000, list:get( 1 ).tempo );
    assert_equal( 0.5, list:get( 1 ).time );
end

function testGetSecFromClock()
    list = luavsq.TempoTable.new();
    list:push( luavsq.TempoTableEntry.new( 480, 480000, 0.0 ) );
    list:push( luavsq.TempoTableEntry.new( 0, 500000, 0.0 ) );
    list:updateTempoInfo();

    assert_equal( 0.0, list:getSecFromClock( 0 ) );
    assert_equal( 0.5, list:getSecFromClock( 480 ) );
    assert_equal( 0.4, list:getSecFromClock( 384 ) );
    assert_equal( 0.7, list:getSecFromClock( 680 ) );
end
