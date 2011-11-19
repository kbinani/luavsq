require( "lunit" );
dofile( "../List.lua" );
module( "ListTest", package.seeall, lunit.testcase );

function test()
    local list = luavsq.List.new();
    assert_equal( 0, list:size() );
    list:push( 1 );
    assert_equal( 1, list:size() );
    list:push( nil );
    assert_equal( 2, list:size() );

    assert_equal( 1, list[0] );
    assert_equal( nil, list[1] );
    list[1] = 2;
    assert_equal( 2, list[1] );
    list[1] = 3;
    assert_equal( 3, list[1] );
end

function testIterator()
    local list = luavsq.List.new();
    list:push( 0 );
    list:push( 2 );
    list:push( 1 );
    local i = list:iterator();
    assert_true( i:hasNext() );
    assert_equal( 0, i:next() );
    assert_true( i:hasNext() );
    assert_equal( 2, i:next() );
    assert_true( i:hasNext() );
    assert_equal( 1, i:next() );
    assert_false( i:hasNext() );
end

function testSort()
    local list = luavsq.List.new();
    list:push( 0 );
    list:push( 2 );
    list:push( 1 );
    list:sort();

    assert_equal( 0, list[0] );
    assert_equal( 1, list[1] );
    assert_equal( 2, list[2] );

    local desc = function( a, b )
        return a > b;
    end
    list:sort( desc );

    assert_equal( 2, list[0] );
    assert_equal( 1, list[1] );
    assert_equal( 0, list[2] );
end

function testConstruct()
    local list = luavsq.List.new();
    assert_equal( 0, list:size() );

    list = luavsq.List.new( 0 );
    assert_equal( 0, list:size() );

    list = luavsq.List.new( 2 );
    assert_equal( 2, list:size() );
    assert_nil( list[0] );
    assert_nil( list[1] );
end

function testFromTable()
    local list = luavsq.List.fromTable( { 1, 2 } );
    local i = list:iterator();
    assert_true( i:hasNext() );
    assert_equal( 1, i:next() );
    assert_true( i:hasNext() );
    assert_equal( 2, i:next() );
    assert_false( i:hasNext() );
end
