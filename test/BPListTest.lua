require( "lunit" );
dofile( "../BPList.lua" );
dofile( "../BP.lua" );
dofile( "../Util.lua" );
dofile( "../BPList.KeyClockIterator.lua" );
dofile( "../TextStream.lua" );
dofile( "../BPListSearchResult.lua" );
module( "BPListTest", package.seeall, lunit.testcase );

function testConstruct()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    assert_equal( "foo", list:getName() );
    assert_equal( 63, list:getDefault() );
    assert_equal( -10, list:getMinimum() );
    assert_equal( 1000, list:getMaximum() );
    assert_equal( 0, list:getMaxId() );
end

function testGetterAndSetterName()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    assert_equal( "foo", list:getName() );
    list:setName( "bar" );
    assert_equal( "bar", list:getName() );
end

function testGetMaxId()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    list:add( 0, 1 );
    assert_equal( 1, list:getMaxId() );
end

function testGetterAndSetterDefaultValue()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    assert_equal( 63, list:getDefault() );
    list:setDefault( 62 );
    assert_equal( 62, list:getDefault() );
end

function testRenumberIds()
--    fail();
end

function testGetData()
--    fail();
end

function testSetData()
--    fail();
end

function testClone()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    list:add( 480, 1 );
    list:add( 1920, 2 );
    local copy = list:clone();
    assert_equal( "foo", copy:getName() );
    assert_equal( 63, copy:getDefault() );
    assert_equal( -10, copy:getMinimum() );
    assert_equal( 1000, copy:getMaximum() );
    assert_equal( 2, copy:size() );
    assert_equal( 1, copy:getElementB( 0 ).id );
    assert_equal( 1, copy:getElementB( 0 ).value );
    assert_equal( 480, copy:getKeyClock( 0 ) );
    assert_equal( 2, copy:getElementB( 1 ).id );
    assert_equal( 2, copy:getElementB( 1 ).value );
    assert_equal( 1920, copy:getKeyClock( 1 ) );
end

function testGetterAndSetterMaximum()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    assert_equal( 1000, list:getMaximum() );
    list:setMaximum( 1001 );
    assert_equal( 1001, list:getMaximum() );
end

function testGetterAndSetterMinimum()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    assert_equal( -10, list:getMinimum() );
    list:setMinimum( 1 );
    assert_equal( 1, list:getMinimum() );
end

function testRemove()
--    fail();
end

function testRemoveElementAt()
--    fail();
end

function testIsContainsKey()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    assert_false( list:isContainsKey( 480 ) );
    list:add( 480, 1 );
    assert_true( list:isContainsKey( 480 ) );
end

function testMove()
--    fail();
end

function testGetElement()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    list:add( 480, 1 );
    list:add( 1920, 2 );
    assert_equal( 1, list:getElement( 0 ) );
    assert_equal( 2, list:getElement( 1 ) );
end

function testGetElementA()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    list:add( 480, 1 );
    list:add( 1920, 2 );
    assert_equal( 1, list:getElementA( 0 ) );
    assert_equal( 2, list:getElementA( 1 ) );
end

function testGetElementB()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    list:add( 480, 11 );
    list:add( 1920, 12 );
    assert_equal( 1, list:getElementB( 0 ).id );
    assert_equal( 11, list:getElementB( 0 ).value );
    assert_equal( 2, list:getElementB( 1 ).id );
    assert_equal( 12, list:getElementB( 1 ).value );
end

function testGetKeyClock()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    list:add( 480, 11 );
    list:add( 1920, 12 );
    assert_equal( 480, list:getKeyClock( 0 ) );
    assert_equal( 1920, list:getKeyClock( 1 ) );
end

function testFindValueFromId()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    local idA = list:add( 480, 11 );
    local idB = list:add( 1920, 12 );
    assert_equal( 11, list:findValueFromId( idA ) );
    assert_equal( 12, list:findValueFromId( idB ) );
end

function testFindElement()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    local idA = list:add( 480, 11 );
    local idB = list:add( 1920, 12 );
    local resultA = list:findElement( idA );
    local resultB = list:findElement( idB );
    assert_equal( 480, resultA.clock );
    assert_equal( 0, resultA.index );
    assert_equal( idA, resultA.point.id );
    assert_equal( 11, resultA.point.value );
    assert_equal( 1920, resultB.clock );
    assert_equal( 1, resultB.index );
    assert_equal( idB, resultB.point.id );
    assert_equal( 12, resultB.point.value );
end

function testSetValueForId()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    local idA = list:add( 480, 11 );
    local idB = list:add( 1920, 12 );
    list:setValueForId( idA, 13 );
    assert_equal( 13, list:findValueFromId( idA ) );
end

function testPrint()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    local header = "[BPList]";

    local stream = luavsq.TextStream.new();
    list:print( stream, 0, header );
    local expected =
        "[BPList]\n"
    assert_equal( expected, stream:toString() );

    stream = luavsq.TextStream.new();
    list:add( 480, 11 );
    list:add( 1920, 12 );
    list:print( stream, 0, header );
    expected =
        "[BPList]\n" ..
        "480=11\n" ..
        "1920=12\n";
    assert_equal( expected, stream:toString() );

    stream = luavsq.TextStream.new();
    list:print( stream, 1921, header );
    expected =
        "[BPList]\n" ..
        "1921=12\n";
    assert_equal( expected, stream:toString() );
end

function testAppendFromText()
--    fail();
end

function testSize()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    assert_equal( 0, list:size() );
    list:add( 480, 11 );
    assert_equal( 1, list:size() );
end

function testKeyClockIterator()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    list:add( 480, 11 );
    list:add( 1920, 12 );
    local iterator = list:keyClockIterator();
    assert_true( iterator:hasNext() );
    assert_equal( 480, iterator:next() );
    assert_true( iterator:hasNext() );
    assert_equal( 1920, iterator:next() );
    assert_false( iterator:hasNext() );
end

function testAdd()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    local idA = list:add( 480, 11 );
    assert_equal( 1, idA );
    assert_equal( 11, list:getElement( 0 ) );

    --同じclockに値をaddすると、データ点は増えずに値が上書きされる
    idA = list:add( 480, 12 );
    assert_equal( 1, idA );
    assert_equal( 12, list:getElement( 0 ) );

    --既存の点より小さいclockに値をaddすると、並び替えが起こる
    local idB = list:add( 240, 99 );
    assert_not_equal( idA, idB );
    assert_equal( 240, list:getKeyClock( 0 ) );
    assert_equal( idB, list:getElementB( 0 ).id );
    assert_equal( 99, list:getElementB( 0 ).value );
    assert_equal( 480, list:getKeyClock( 1 ) );
    assert_equal( idA, list:getElementB( 1 ).id );
    assert_equal( 12, list:getElementB( 1 ).value );
end

function testAddWithId()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    local idA = list:addWithId( 480, 11, 3 );
    assert_equal( 3, idA );
    assert_equal( 11, list:getElement( 0 ) );
    assert_equal( 3, list:getMaxId() );

    --同じclockに値をaddすると、データ点は増えずに値が上書きされる
    idA = list:addWithId( 480, 12, 4 );
    assert_equal( 4, idA );
    assert_equal( 12, list:getElement( 0 ) );
    assert_equal( 4, list:getMaxId() );

    --既存の点より小さいclockに値をaddすると、並び替えが起こる
    local idB = list:addWithId( 240, 99, 5 );
    assert_equal( 5, idB );
    assert_equal( 5, list:getMaxId() );
    assert_equal( 240, list:getKeyClock( 0 ) );
    assert_equal( 5, list:getElementB( 0 ).id );
    assert_equal( 99, list:getElementB( 0 ).value );
    assert_equal( 480, list:getKeyClock( 1 ) );
    assert_equal( 4, list:getElementB( 1 ).id );
    assert_equal( 12, list:getElementB( 1 ).value );
end

function testRemoveWithId()
--    fail();
end

function testGetValueWithoutLastIndex()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    list:add( 480, 11 );
    list:add( 1920, 12 );
    assert_equal( 63, list:getValue( 479 ) );
    assert_equal( 11, list:getValue( 480 ) );
    assert_equal( 12, list:getValue( 2000 ) );
end

function testGetValueWithLastIndex()
    local list = luavsq.BPList.new( "foo", 63, -10, 1000 );
    list:add( 480, 11 );
    list:add( 1920, 12 );
    local index = { value = 0 };
    assert_equal( 63, list:getValue( 479, index ) );
    assert_equal( 0, index.value );
    assert_equal( 11, list:getValue( 480, index ) );
    assert_equal( 0, index.value );
    assert_equal( 12, list:getValue( 2000, index ) );
    assert_equal( 1, index.value );
    assert_equal( 63, list:getValue( 479, index ) );
    assert_equal( 0, index.value );
end
