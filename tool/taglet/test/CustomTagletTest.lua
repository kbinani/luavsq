require( "lunit" );
dofile( "../custom.lua" );

module( "CustomTagletTest", package.seeall, lunit.testcase );

function testCheckVar()
    local comments = {
        "    ---",
        "    -- @var integer",
    };
    local code = "    this.foo = 1;";
    local name = luadoc.taglet.custom.check_var( comments, code );
    assert_equal( "foo", name );
end
