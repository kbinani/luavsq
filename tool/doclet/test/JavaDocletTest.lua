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

function testCreateLinks()
    local classes = { "Handle" };
    local text = "foo {@link Handle} bar";
    local actual = luadoc.doclet.java.createLinks( text, classes );
    local expected = "foo <code><a href=\"Handle.html\">Handle</a></code> bar";
    assert_equal( expected, actual );
end

function testGetShortName()
    assert_equal( "clone", luadoc.doclet.java.getShortName( "this:clone" ) );
    assert_equal( "clone", luadoc.doclet.java.getShortName( "moduleName.className.clone" ) );
    assert_equal( "clone", luadoc.doclet.java.getShortName( "moduleName.className:clone" ) );
end
