require( "lunit" );
dofile( "../List.lua" );
module( "ListTest", package.seeall, lunit.testcase );

function test()
    local list = luavsq.List.new();
    assert_equal( 0, list:size() );
    list:add( 1 );
    assert_equal( 1, list:size() );
    list:add( nil );
    assert_equal( 2, list:size() );
    assert_equal( 1, list:get( 0 ) );
    assert_equal( nil, list:get( 1 ) );
    list:set( 1, 2 );
    assert_equal( 2, list:get( 1 ) );
end

function testIterator()
    local list = luavsq.List.new();
    list:add( 0 );
    list:add( 2 );
    list:add( 1 );
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
    list:add( 0 );
    list:add( 2 );
    list:add( 1 );
    list:sort();

    assert_equal( 0, list:get( 0 ) );
    assert_equal( 1, list:get( 1 ) );
    assert_equal( 2, list:get( 2 ) );

    local desc = function( a, b )
        return a > b;
    end
    list:sort( desc );

    assert_equal( 2, list:get( 0 ) );
    assert_equal( 1, list:get( 1 ) );
    assert_equal( 0, list:get( 2 ) );
end
