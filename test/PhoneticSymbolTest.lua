require( "lunit" );
dofile( "../PhoneticSymbol.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testIsConsonant()
    assert_true( luavsq.PhoneticSymbol.isConsonant( "k'" ) );
    assert_false( luavsq.PhoneticSymbol.isConsonant( "a" ) );
end

function testIsVowel()
    assert_true( luavsq.PhoneticSymbol.isVowel( "@" ) );
    assert_false( luavsq.PhoneticSymbol.isVowel( "b" ) );
end

function testIsValidSymbol()
    assert_true( luavsq.PhoneticSymbol.isValidSymbol( "a" ) );
    assert_true( luavsq.PhoneticSymbol.isValidSymbol( "br1" ) );
    assert_false( luavsq.PhoneticSymbol.isValidSymbol( "__INVALID_SYMBOL__" ) );
    assert_false( luavsq.PhoneticSymbol.isValidSymbol( "br_" ) );
end
