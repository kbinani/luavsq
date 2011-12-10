require( "lunit" );
dofile( "../VoiceLanguageEnum.lua" );
module( "VoiceLanguageEnumTest", package.seeall, lunit.testcase );

function test()
    assert_equal( 0, luavsq.VoiceLanguageEnum.JAPANESE );
    assert_equal( 1, luavsq.VoiceLanguageEnum.ENGLISH );

    assert_equal( luavsq.VoiceLanguageEnum.ENGLISH, luavsq.VoiceLanguageEnum.valueFromSingerName( "sweet_ann" ) );
    assert_equal( luavsq.VoiceLanguageEnum.ENGLISH, luavsq.VoiceLanguageEnum.valueFromSingerName( "prima" ) );
    assert_equal( luavsq.VoiceLanguageEnum.ENGLISH, luavsq.VoiceLanguageEnum.valueFromSingerName( "luka_eng" ) );
    assert_equal( luavsq.VoiceLanguageEnum.ENGLISH, luavsq.VoiceLanguageEnum.valueFromSingerName( "sonika" ) );
    assert_equal( luavsq.VoiceLanguageEnum.ENGLISH, luavsq.VoiceLanguageEnum.valueFromSingerName( "lola" ) );
    assert_equal( luavsq.VoiceLanguageEnum.ENGLISH, luavsq.VoiceLanguageEnum.valueFromSingerName( "leon" ) );
    assert_equal( luavsq.VoiceLanguageEnum.ENGLISH, luavsq.VoiceLanguageEnum.valueFromSingerName( "miriam" ) );
    assert_equal( luavsq.VoiceLanguageEnum.ENGLISH, luavsq.VoiceLanguageEnum.valueFromSingerName( "big_al" ) );
    assert_equal( luavsq.VoiceLanguageEnum.JAPANESE, luavsq.VoiceLanguageEnum.valueFromSingerName( "___FOO___" ) );
end
