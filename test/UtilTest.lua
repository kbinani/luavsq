require( "lunit" )
dofile( "../Util.lua" )
module( "enhanced", package.seeall, lunit.testcase )

function testSplit()
    local value = "\t\tfoo\t\tbar"
    local actual = luavsq.Util.split( value, "\t\t" )
    assert_table( actual )
    assert_equal( 3, table.maxn( actual ) )
    assert_equal( "", actual[1] )
    assert_equal( "foo", actual[2] )
    assert_equal( "bar", actual[3] )
end

function testSplitNotSplitted()
    local value = "foo,bar"
    local actual = luavsq.Util.split( value, "\t" )
    assert_table( actual )
    assert_equal( 1, table.maxn( actual ) )
    assert_equal( value, actual[1] )
end

function testArray()
    local array = luavsq.Util.array( 2 )
    assert_table( array )
    assert_equal( 2, #array )
    assert_false( array[1] )
    assert_false( array[2] )
end
