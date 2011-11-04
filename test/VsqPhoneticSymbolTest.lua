require( "lunit" );
dofile( "../Util.lua" );
dofile( "../VsqPhoneticSymbol.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testIsConsonant()
    assert_true( luavsq.VsqPhoneticSymbol.isConsonant( "k'" ) );
    assert_false( luavsq.VsqPhoneticSymbol.isConsonant( "a" ) );
end

function testIsVowel()
    assert_true( luavsq.VsqPhoneticSymbol.isVowel( "@" ) );
    assert_false( luavsq.VsqPhoneticSymbol.isVowel( "b" ) );
end

function testIsValidSymbol()
    assert_true( luavsq.VsqPhoneticSymbol.isValidSymbol( "a" ) );
    assert_true( luavsq.VsqPhoneticSymbol.isValidSymbol( "br1" ) );
    assert_false( luavsq.VsqPhoneticSymbol.isValidSymbol( "__INVALID_SYMBOL__" ) );
    assert_false( luavsq.VsqPhoneticSymbol.isValidSymbol( "br_" ) );
end
