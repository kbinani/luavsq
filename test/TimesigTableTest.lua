require( "lunit" );
dofile( "../TimesigTable.lua" );
dofile( "../List.lua" );
dofile( "../TimesigTableItem.lua" );
module( "TimesigTableTest", package.seeall, lunit.testcase );

function testUpdateTimesigInfo()
    local table = luavsq.TimesigTable.new();
    table:push( luavsq.TimesigTableItem.new( 4, 4, 2 ) );
    table:push( luavsq.TimesigTableItem.new( 4, 4, 0 ) );
    table:push( luavsq.TimesigTableItem.new( 3, 4, 1 ) );
    table:updateTimesigInfo();

    assert_equal( 0, table:get( 0 ):getTick() );
    assert_equal( 0, table:get( 0 ).barCount );
    assert_equal( 1920, table:get( 1 ):getTick() );
    assert_equal( 1, table:get( 1 ).barCount );
    assert_equal( 3360, table:get( 2 ):getTick() );
    assert_equal( 2, table:get( 2 ).barCount );
end

function testGetTimesigAt()
    local table = luavsq.TimesigTable.new();
    table:push( luavsq.TimesigTableItem.new( 4, 6, 2 ) );
    table:push( luavsq.TimesigTableItem.new( 4, 4, 0 ) );
    table:push( luavsq.TimesigTableItem.new( 3, 4, 1 ) );
    table:updateTimesigInfo();

    local timesig = table:getTimesigAt( 480 );
    assert_equal( 4, timesig.numerator );
    assert_equal( 4, timesig.denominator );

    timesig = table:getTimesigAt( 1920 );
    assert_equal( 3, timesig.numerator );
    assert_equal( 4, timesig.denominator );

    timesig = table:getTimesigAt( 10000 );
    assert_equal( 4, timesig.numerator );
    assert_equal( 6, timesig.denominator );
end

function testFindTimesigAt()
    local table = luavsq.TimesigTable.new();
    table:push( luavsq.TimesigTableItem.new( 4, 6, 2 ) );-- 3360 clock開始
    table:push( luavsq.TimesigTableItem.new( 4, 4, 0 ) );--    0 clock開始
    table:push( luavsq.TimesigTableItem.new( 3, 4, 1 ) );-- 1920 clock開始
    table:updateTimesigInfo();

    local timesig = table:findTimesigAt( 480 );
    assert_equal( 4, timesig.numerator );
    assert_equal( 4, timesig.denominator );
    assert_equal( 0, timesig.barCount );

    timesig = table:findTimesigAt( 1920, barCount );
    assert_equal( 3, timesig.numerator );
    assert_equal( 4, timesig.denominator );
    assert_equal( 1, timesig.barCount );

    timesig = table:findTimesigAt( 10000, barCount );
    assert_equal( 4, timesig.numerator );
    assert_equal( 6, timesig.denominator );
    assert_equal( 7, timesig.barCount );

    -- 最初に戻った場合にインデクスがリセットされるか
    timesig = table:findTimesigAt( 0, barCount );
    assert_equal( 4, timesig.numerator );
    assert_equal( 4, timesig.denominator );
end

function testGetClockFromBarCount()
    local table = luavsq.TimesigTable.new();
    table:push( luavsq.TimesigTableItem.new( 4, 6, 2 ) );-- 3360 clock開始
    table:push( luavsq.TimesigTableItem.new( 4, 4, 0 ) );--    0 clock開始
    table:push( luavsq.TimesigTableItem.new( 3, 4, 1 ) );-- 1920 clock開始
    table:updateTimesigInfo();

    assert_equal( 0, table:getClockFromBarCount( 0 ) );
    assert_equal( 1920, table:getClockFromBarCount( 1 ) );
    assert_equal( 3360, table:getClockFromBarCount( 2 ) );
    assert_equal( 9760, table:getClockFromBarCount( 7 ) );
end

function testGetBarCountFromClock()
    local table = luavsq.TimesigTable.new();
    table:push( luavsq.TimesigTableItem.new( 4, 6, 2 ) );-- 3360 clock開始
    table:push( luavsq.TimesigTableItem.new( 4, 4, 0 ) );--    0 clock開始
    table:push( luavsq.TimesigTableItem.new( 3, 4, 1 ) );-- 1920 clock開始
    table:updateTimesigInfo();

    assert_equal( 0, table:getBarCountFromClock( 0 ) );
    assert_equal( 0, table:getBarCountFromClock( 1919 ) );
    assert_equal( 1, table:getBarCountFromClock( 1920 ) );
    assert_equal( 2, table:getBarCountFromClock( 3360 ) );
    assert_equal( 7, table:getBarCountFromClock( 9760 ) );
end

function testIterator()
    local table = luavsq.TimesigTable.new();
    table:push( luavsq.TimesigTableItem.new( 4, 4, 2 ) );
    table:push( luavsq.TimesigTableItem.new( 4, 4, 0 ) );
    table:push( luavsq.TimesigTableItem.new( 3, 4, 1 ) );
    table:updateTimesigInfo();

    local i = table:iterator();
    assert_true( i:hasNext() );
    assert_equal( 0, i:next():getTick() );
    assert_true( i:hasNext() );
    assert_equal( 1920, i:next():getTick() );
    assert_true( i:hasNext() );
    assert_equal( 3360, i:next():getTick() );
end

function testSize()
    local table = luavsq.TimesigTable.new();
    assert_equal( 0, table:size() );
    table:push( luavsq.TimesigTableItem.new( 4, 4, 2 ) );
    assert_equal( 1, table:size() );
end
