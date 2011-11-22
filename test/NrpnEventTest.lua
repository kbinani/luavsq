require( "lunit" );
dofile( "../NrpnEvent.lua" );
dofile( "../MidiParameterEnum.lua" );
dofile( "../Util.lua" );
dofile( "../MidiEvent.lua" );
module( "NrpnEventTest", package.seeall, lunit.testcase );

function testConstructWithoutLSB()
    local event = luavsq.NrpnEvent.new( 480, luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 64 );
    assert_equal( 480, event.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, event.nrpn );
    assert_equal( 64, event.dataMSB );
    assert_equal( 0, event.dataLSB );
    assert_false( event.hasLSB );
    assert_false( event.isMSBOmittingRequired );
end

function testConstructWithLSB()
    local event = luavsq.NrpnEvent.new( 480, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01, 0x23 );
    assert_equal( 480, event.clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_DELAY, event.nrpn );
    assert_equal( 0x01, event.dataMSB );
    assert_equal( 0x23, event.dataLSB );
    assert_true( event.hasLSB );
    assert_false( event.isMSBOmittingRequired );
end

function testCompareTo()
    -- clock が異なる場合
    local a = luavsq.NrpnEvent.new( 480, luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 64 );
    local b = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CC_CV_VERSION_AND_DEVICE, 0x01, 0x23 );
    assert_true( b:compareTo( a ) > 0 );
    assert_true( a:compareTo( b ) < 0 );
    assert_equal( 0, a:compareTo( a ) );

    -- clockが同じ場合
    -- CVM_NM_VELOCITY:          0x5003 <- a
    -- CC_CV_VERSION_AND_DEVICE: 0x6100 <- b
    -- b - a の並びになるはず
    b.clock = 480;
    assert_true( 0 > b:compareTo( a ) );
    assert_true( 0 < a:compareTo( b ) );
    assert_equal( 0, a:compareTo( a ) );
end

function testAppend()
    local target = nil;

    -- NRPNとDATA MSBを指定したappend
    target = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01, 0x23 );
    target:append( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 0x02 );
    assert_equal( 1, #target._list );
    assert_equal( 1920, target._list[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, target._list[1].nrpn );
    assert_equal( 0x02, target._list[1].dataMSB );
    assert_equal( 0x00, target._list[1].dataLSB );
    assert_false( target._list[1].hasLSB );
    assert_false( target._list[1].isMSBOmittingRequired );

    -- NRPN, DATA MSB,およびDATA LSBを指定したappend
    target = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01, 0x23 );
    target:append( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 0x02, 0x03 );
    assert_equal( 1, #target._list );
    assert_equal( 1920, target._list[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, target._list[1].nrpn );
    assert_equal( 0x02, target._list[1].dataMSB );
    assert_equal( 0x03, target._list[1].dataLSB );
    assert_true( target._list[1].hasLSB );
    assert_false( target._list[1].isMSBOmittingRequired );

    -- NRPN, DATA MSBと、MSB省略フラグを指定したappend
    target = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01, 0x23 );
    target:append( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 0x01, true );
    assert_equal( 1, #target._list );
    assert_equal( 1920, target._list[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, target._list[1].nrpn );
    assert_equal( 0x01, target._list[1].dataMSB );
    assert_equal( 0x00, target._list[1].dataLSB );
    assert_false( target._list[1].hasLSB );
    assert_true( target._list[1].isMSBOmittingRequired );

    -- NRPN, DATA MSB, DATA LSBと、MSB省略フラグを指定したappend
    target = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01, 0x23 );
    target:append( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 0x01, 0x02, true );
    assert_equal( 1, #target._list );
    assert_equal( 1920, target._list[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, target._list[1].nrpn );
    assert_equal( 0x01, target._list[1].dataMSB );
    assert_equal( 0x02, target._list[1].dataLSB );
    assert_true( target._list[1].hasLSB );
    assert_true( target._list[1].isMSBOmittingRequired );
end

function testExpand()
    local target = nil;

    -- DATA LSB を保持している単一 NrpnEvent アイテムの expand
    target = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01, 0x23 );
    local list = target:expand();
    assert_equal( 1, #list );
    assert_equal( 1920, list[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_DELAY, list[1].nrpn );
    assert_equal( 0x01, list[1].dataMSB );
    assert_equal( 0x23, list[1].dataLSB );
    assert_true( list[1].hasLSB );
    assert_false( list[1].isMSBOmittingRequired );

    -- DATA LSB を保持していない単一 NrpnEvent アイテムの expand
    target = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01 );
    list = target:expand();
    assert_equal( 1, #list );
    assert_equal( 1920, list[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_DELAY, list[1].nrpn );
    assert_equal( 0x01, list[1].dataMSB );
    assert_equal( 0x00, list[1].dataLSB );
    assert_false( list[1].hasLSB );
    assert_false( list[1].isMSBOmittingRequired );

    -- 子・孫アイテムを持つ NrpnEvent の expand
    target = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01 );
    target:append( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 64 ); -- 子アイテムを追加
    target._list[1]:append( luavsq.MidiParameterEnum.CVM_NM_NOTE_NUMBER, 60 ); -- 孫アイテムを追加
    list = target:expand();
    assert_equal( 3, #list );

    assert_equal( 1920, list[1].clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_DELAY, list[1].nrpn );
    assert_equal( 0x01, list[1].dataMSB );
    assert_equal( 0x00, list[1].dataLSB );
    assert_false( list[1].hasLSB );
    assert_false( list[1].isMSBOmittingRequired );

    assert_equal( 1920, list[2].clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, list[2].nrpn );
    assert_equal( 64, list[2].dataMSB );
    assert_equal( 0x00, list[2].dataLSB );
    assert_false( list[2].hasLSB );
    assert_false( list[2].isMSBOmittingRequired );

    assert_equal( 1920, list[3].clock );
    assert_equal( luavsq.MidiParameterEnum.CVM_NM_NOTE_NUMBER, list[3].nrpn );
    assert_equal( 60, list[3].dataMSB );
    assert_equal( 0x00, list[3].dataLSB );
    assert_false( list[3].hasLSB );
    assert_false( list[3].isMSBOmittingRequired );
end

function testCompare()
    local a = luavsq.NrpnEvent.new( 480, luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 64 );
    local b = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01, 0x23 );
    assert_true( luavsq.NrpnEvent.compare( a, b ) );
    assert_false( luavsq.NrpnEvent.compare( b, a ) );
    assert_false( luavsq.NrpnEvent.compare( a, a ) );
end

function testConvert()
    local target = nil;
    target = luavsq.NrpnEvent.new( 1920, luavsq.MidiParameterEnum.CVM_NM_DELAY, 0x01, 0x23 );
    target:append( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 0x01, 0x02, true );
    target:append( luavsq.MidiParameterEnum.CVM_NM_NOTE_NUMBER, 60 );

    local events = luavsq.NrpnEvent.convert( target:expand() );
    assert_equal( 10, #events );
    local e = nil;

    -- CVM_NM_DELAY
    e = events[1];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x63, e.data[1] );
    assert_equal( luavsq.Util.rshift( luavsq.Util.band( luavsq.MidiParameterEnum.CVM_NM_DELAY, 0xff00 ), 8 ), e.data[2] );
    e = events[2];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x62, e.data[1] );
    assert_equal( luavsq.Util.band( luavsq.MidiParameterEnum.CVM_NM_DELAY, 0xff ), e.data[2] );
    e = events[3];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x06, e.data[1] );
    assert_equal( 0x01, e.data[2] );
    e = events[4];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x26, e.data[1] );
    assert_equal( 0x23, e.data[2] );

    -- CVM_NM_VELOCITY
    e = events[5];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x62, e.data[1] );
    assert_equal( luavsq.Util.band( luavsq.MidiParameterEnum.CVM_NM_VELOCITY, 0xff ), e.data[2] );
    e = events[6];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x06, e.data[1] );
    assert_equal( 0x01, e.data[2] );
    e = events[7];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x26, e.data[1] );
    assert_equal( 0x02, e.data[2] );

    -- CVM_NM_NOTE_NUMBER
    e = events[8];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x63, e.data[1] );
    assert_equal( luavsq.Util.rshift( luavsq.Util.band( luavsq.MidiParameterEnum.CVM_NM_NOTE_NUMBER, 0xff00 ), 8 ), e.data[2] );
    e = events[9];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x62, e.data[1] );
    assert_equal( luavsq.Util.band( luavsq.MidiParameterEnum.CVM_NM_NOTE_NUMBER, 0xff ), e.data[2] );
    e = events[10];
    assert_equal( 1920, e.clock );
    assert_equal( 0xb0, e.firstByte );
    assert_equal( 2, #e.data );
    assert_equal( 0x06, e.data[1] );
    assert_equal( 60, e.data[2] );
end
