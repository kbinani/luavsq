require( "lunit" );
dofile( "../MidiEvent.lua" );
dofile( "../ByteArrayOutputStream.lua" );
dofile( "../Util.lua" );
module( "MidiEventTest", package.seeall, lunit.testcase );

function testWriteData()
    local stream = nil;

    stream = luavsq.ByteArrayOutputStream.new();
    local event = luavsq.MidiEvent.new();
    event.firstByte = 0x91;
    event.data = { 64, 127 };
    event:writeData( stream );
    local expected = string.char( 0x91 ) .. string.char( 64 ) .. string.char( 127 );
    assert_equal( expected, stream:toString() );

    stream = luavsq.ByteArrayOutputStream.new();
    event = luavsq.MidiEvent.new();
    event.firstByte = 0xff;
    event.data = { 0x51, 0x82, 0x81, 0x80 };
    event:writeData( stream );
    expected = string.char( 0xff ) .. string.char( 0x51 ) .. string.char( 3 ) .. string.char( 0x82 ) .. string.char( 0x81 ) .. string.char( 0x80 );
    assert_equal( expected, stream:toString() );
end

function testCompareTo()
    local a = luavsq.MidiEvent.new();
    local b = luavsq.MidiEvent.new();
    a.clock = 0;
    b.clock = 480;
    assert_true( 0 < b:compareTo( a ) );
    assert_true( 0 > a:compareTo( b ) );

    a.firstByte = 1;
    b.firstByte = 2;
    a.clock = 0;
    b.clock = 0;
    assert_equal( 0, a:compareTo( b ) );

    --同じ音程の、Note OnとNote Offが続いていた場合、Note Offが先、Note Onが後ろになる
    a.firstByte = 0x92;
    b.firstByte = 0x82;
    a.clock = 0;
    b.clock = 0;
    a.data = { 64, 127 }; -- note#=64, vel=127の Note On
    b.data = { 64, 127 }; -- note#=64, vel=127の Note Off
    -- b => a
    assert_true( 0 < a:compareTo( b ) );
    assert_true( 0 > b:compareTo( a ) );

    --同じ音程の、Note OnとNote Offが続いていた場合、Note Offが先、Note Onが後ろになる
    --ただし、Note Offが、ベロシティー0のNote Onとして表現されている場合
    a.firstByte = 0x91;
    b.firstByte = 0x91;
    a.clock = 0;
    b.clock = 0;
    a.data = { 64, 127 }; -- note#=64, vel=127の Note On
    b.data = { 64, 0 };   -- note#=64, vel=0の Note On、vel=0なので Note Off とみなされる
    -- b => a
    assert_true( 0 < a:compareTo( b ) );
    assert_true( 0 > b:compareTo( a ) );

    a.firstByte = 90;
    b.firstByte = 80;
    a.clock = 0;
    b.clock = 0;
    a.data = { 63, 127 };
    b.data = { 64, 127 };
    assert_equal( 0, a:compareTo( b ) );
    assert_equal( 0, b:compareTo( a ) );
end

function testGenerateTimeSigEvent()
    local event = luavsq.MidiEvent.generateTimeSigEvent( 10, 3, 2 );
    assert_equal( 10, event.clock );
    assert_equal( 0xff, event.firstByte );
    assert_equal( 5, #event.data );
    assert_equal( 0x58, event.data[1] );
    assert_equal( 3, event.data[2] );
    assert_equal( 1, event.data[3] );
    assert_equal( 0x18, event.data[4] );
    assert_equal( 0x08, event.data[5] );
end

function testGenerateTempoChangeEvent()
    local event = luavsq.MidiEvent.generateTempoChangeEvent( 12, 0x828180 );
    assert_equal( 12, event.clock );
    assert_equal( 0xff, event.firstByte );
    assert_equal( 4, #event.data );
    assert_equal( 0x51, event.data[1] );
    assert_equal( 0x82, event.data[2] );
    assert_equal( 0x81, event.data[3] );
    assert_equal( 0x80, event.data[4] );
end

function testWriteDeltaClock()
    local stream = nil;

    stream = luavsq.ByteArrayOutputStream.new();
    luavsq.MidiEvent.writeDeltaClock( stream, 0 );
    assert_equal( string.char( 0x0 ), stream:toString() );

    stream = luavsq.ByteArrayOutputStream.new();
    luavsq.MidiEvent.writeDeltaClock( stream, 127 );
    assert_equal( string.char( 0x7f ), stream:toString() );

    stream = luavsq.ByteArrayOutputStream.new();
    luavsq.MidiEvent.writeDeltaClock( stream, 128 );
    assert_equal( string.char( 0x81 ) .. string.char( 0x00 ), stream:toString() );

    stream = luavsq.ByteArrayOutputStream.new();
    luavsq.MidiEvent.writeDeltaClock( stream, 12345678 );
    assert_equal( string.char( 0x85 ) .. string.char( 0xf1 ) .. string.char( 0xc2 ) .. string.char( 0x4e ), stream:toString() );
end

function testReadDeltaClock()
--    fail();
end

function testRead()
--    fail();
end
