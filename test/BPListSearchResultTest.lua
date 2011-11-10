dofile( "./test_bootstrap.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstruct()
    local result = luavsq.BPListSearchResult.new();
    assert_equal( 0, result.clock );
    assert_equal( 0, result.index );
    assert_not_nil( result.point );
end
