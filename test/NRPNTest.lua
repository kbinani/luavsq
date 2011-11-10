dofile( "./test_bootstrap.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testGetVoiceChangeParameterID()
    assert_equal( 0x30, luavsq.NRPN.getVoiceChangeParameterID( "HarMoNiCS" ) );
    assert_equal( nil, luavsq.NRPN.getVoiceChangeParameterID( nil ) );
    assert_equal( 0x31, luavsq.NRPN.getVoiceChangeParameterID( "UNKNOWN_CURVE_NAME" ) );
end

function testIsDataLsbRequire()
    assert_true( luavsq.NRPN.isDataLsbRequire( luavsq.NRPN.CC_PBS_VERSION_AND_DEVICE ) );
end
