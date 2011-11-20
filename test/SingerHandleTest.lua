require( "lunit" );
dofile( "../SingerHandle.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleTypeEnum.lua" );
module( "SingerHandleTest", package.seeall, lunit.testcase );

function getSingerHandle()
    local handle = luavsq.SingerHandle.new();
    handle.caption = "bar";
    handle.iconId = "$07010001";
    handle.ids = "foo";
    handle.index = 1;
    handle.length = 2;
    handle.original = 3;
    handle.program = 4;
    handle.language= 5;
    return handle;
end

function testGetterAndSetterLength()
    local handle = getSingerHandle();
    local expected = 12084;
    assert_not_equal( expected, handle:getLength() );
    handle:setLength( expected );
    assert_equal( expected, handle:getLength() );
end

function testEqual()
    local a = getSingerHandle();
    local b = getSingerHandle();
    assert_true( a:equals( b ) );
    a.iconId = "$07010001";
    b.iconId = "$07010002";
    assert_false( a:equals( b ) );
end

function testClone()
    local handle = getSingerHandle();
    local copy = handle:clone();
    assert_equal( handle.caption, copy.caption );
    assert_equal( handle.iconId, copy.iconId );
    assert_equal( handle.ids, copy.ids );
    assert_equal( handle.index, copy.index );
    assert_equal( handle.language, copy.language );
    assert_equal( handle:getLength(), copy:getLength() );
    assert_equal( handle.original, copy.original );
    assert_equal( handle.program, copy.program );
end

function testCastToHandle()
    local handle = getSingerHandle();
    local casted = handle:castToHandle();
    assert_equal( luavsq.HandleTypeEnum.Singer, casted._type );
    assert_equal( "bar", casted.caption );
    assert_equal( "$07010001", casted.iconId );
    assert_equal( "foo", casted.ids );
    assert_equal( 1, casted.index );
    assert_equal( 5, casted.language );
    assert_equal( 2, casted:getLength() );
    assert_equal( 4, casted.program );
    assert_equal( 3, casted.original );
end