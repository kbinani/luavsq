require( "lunit" );
dofile( "../java.lua" );

module( "JavaDocletTest", package.seeall, lunit.testcase );

function testGetLinkedTypeName()
    local allClasses = { "Handle", "table" };
    local typeName = "table&lt;Handle&gt;";
    local actual = luadoc.doclet.java.getLinkedTypeName( typeName, allClasses );
    local expected = "<a href=\"table.html\">table</a>&lt;<a href=\"Handle.html\">Handle</a>&gt;";
    assert_equal( expected, actual );
end
