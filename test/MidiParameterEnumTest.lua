require( "lunit" );
dofile( "../MidiParameterEnum.lua" );
module( "MidiParameterEnumTest", package.seeall, lunit.testcase );

function testGetVoiceChangeParameterId()
    assert_equal( 0x30, luavsq.MidiParameterEnum.getVoiceChangeParameterId( "HarMoNiCS" ) );
    assert_equal( nil, luavsq.MidiParameterEnum.getVoiceChangeParameterId( nil ) );
    assert_equal( 0x31, luavsq.MidiParameterEnum.getVoiceChangeParameterId( "UNKNOWN_CURVE_NAME" ) );
end

function testIsDataLsbRequire()
    assert_true( luavsq.MidiParameterEnum.isDataLsbRequire( luavsq.MidiParameterEnum.CC_PBS_VERSION_AND_DEVICE ) );
end
