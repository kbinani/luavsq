require( "lunit" );
dofile( "../NRPN.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testGetVoiceChangeParameterId()
    assert_equal( 0x30, luavsq.NRPN.getVoiceChangeParameterId( "HarMoNiCS" ) );
    assert_equal( nil, luavsq.NRPN.getVoiceChangeParameterId( nil ) );
    assert_equal( 0x31, luavsq.NRPN.getVoiceChangeParameterId( "UNKNOWN_CURVE_NAME" ) );
end

function testIsDataLsbRequire()
    assert_true( luavsq.NRPN.isDataLsbRequire( luavsq.NRPN.CC_PBS_VERSION_AND_DEVICE ) );
end
