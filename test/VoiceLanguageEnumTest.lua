require( "lunit" );
dofile( "../VoiceLanguageEnum.lua" );
module( "VoiceLanguageEnumTest", package.seeall, lunit.testcase );

function test()
    assert_equal( 0, luavsq.VoiceLanguageEnum.Japanese );
    assert_equal( 1, luavsq.VoiceLanguageEnum.English );

    assert_equal( luavsq.VoiceLanguageEnum.English, luavsq.VoiceLanguageEnum.valueFromSingerName( "sweet_ann" ) );
    assert_equal( luavsq.VoiceLanguageEnum.English, luavsq.VoiceLanguageEnum.valueFromSingerName( "prima" ) );
    assert_equal( luavsq.VoiceLanguageEnum.English, luavsq.VoiceLanguageEnum.valueFromSingerName( "luka_eng" ) );
    assert_equal( luavsq.VoiceLanguageEnum.English, luavsq.VoiceLanguageEnum.valueFromSingerName( "sonika" ) );
    assert_equal( luavsq.VoiceLanguageEnum.English, luavsq.VoiceLanguageEnum.valueFromSingerName( "lola" ) );
    assert_equal( luavsq.VoiceLanguageEnum.English, luavsq.VoiceLanguageEnum.valueFromSingerName( "leon" ) );
    assert_equal( luavsq.VoiceLanguageEnum.English, luavsq.VoiceLanguageEnum.valueFromSingerName( "miriam" ) );
    assert_equal( luavsq.VoiceLanguageEnum.English, luavsq.VoiceLanguageEnum.valueFromSingerName( "big_al" ) );
    assert_equal( luavsq.VoiceLanguageEnum.Japanese, luavsq.VoiceLanguageEnum.valueFromSingerName( "___FOO___" ) );
end
