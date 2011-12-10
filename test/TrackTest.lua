require( "lunit" );
dofile( "../Track.lua" );
dofile( "../Common.lua" );
dofile( "../DynamicsModeEnum.lua" );
dofile( "../PlayModeEnum.lua" );
dofile( "../BPList.lua" );
dofile( "../EventList.lua" );
dofile( "../EventTypeEnum.lua" );
dofile( "../Event.lua" );
dofile( "../EventList.IndexIteratorKindEnum.lua" );
dofile( "../EventList.IndexIterator.lua" );
dofile( "../Util.lua" );
dofile( "../ArticulationTypeEnum.lua" );
dofile( "../BP.lua" );
dofile( "../EventList.Iterator.lua" );
dofile( "../Lyric.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../Master.lua" );
dofile( "../Mixer.lua" );
dofile( "../MixerItem.lua" );
dofile( "../TextStream.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleTypeEnum.lua" );
dofile( "../VoiceLanguageEnum.lua" );
dofile( "../PhoneticSymbol.lua" );
module( "TrackTest", package.seeall, lunit.testcase );

function testConstructMasterTrack()
    local track = luavsq.Track.new();
    assert_equal( "Master Track", track:getName() );
    assert_nil( track.common );
    assert_nil( track.master );
    assert_nil( track.mixer );
    assert_nil( track.events );

    assert_nil( track.pit );
    assert_nil( track.pbs );
    assert_nil( track.dyn );
    assert_nil( track.bre );
    assert_nil( track.bri );
    assert_nil( track.cle );
    assert_nil( track.reso1FreqBPList );
    assert_nil( track.reso2FreqBPList );
    assert_nil( track.reso3FreqBPList );
    assert_nil( track.reso4FreqBPList );
    assert_nil( track.reso1BWBPList );
    assert_nil( track.reso2BWBPList );
    assert_nil( track.reso3BWBPList );
    assert_nil( track.reso4BWBPList );
    assert_nil( track.reso1AmpBPList );
    assert_nil( track.reso2AmpBPList );
    assert_nil( track.reso3AmpBPList );
    assert_nil( track.reso4AmpBPList );
    assert_nil( track.harmonics );
    assert_nil( track.fx2depth );
    assert_nil( track.gen );
    assert_nil( track.por );
    assert_nil( track.ope );
end

function testConstructNormalTrack()
    local track = luavsq.Track.new( "DummyTrackName", "DummySingerName" );
    assert_equal( "DummyTrackName", track:getName() );
    assert_equal( 1, track.events:size() );
    assert_equal( luavsq.EventTypeEnum.Singer, track.events:get( 0 ).type );
    assert_equal( "DummySingerName", track.events:get( 0 ).singerHandle.ids );

    assert_not_nil( track.common );
    assert_nil( track.master );
    assert_nil( track.mixer );
    assert_not_nil( track.events );

    assert_not_nil( track:getCurve( "pit" ) );
    assert_not_nil( track:getCurve( "pbs" ) );
    assert_not_nil( track:getCurve( "dyn" ) );
    assert_not_nil( track:getCurve( "bre" ) );
    assert_not_nil( track:getCurve( "bri" ) );
    assert_not_nil( track:getCurve( "cle" ) );
    assert_not_nil( track:getCurve( "reso1Freq" ) );
    assert_not_nil( track:getCurve( "reso2Freq" ) );
    assert_not_nil( track:getCurve( "reso3Freq" ) );
    assert_not_nil( track:getCurve( "reso4Freq" ) );
    assert_not_nil( track:getCurve( "reso1BW" ) );
    assert_not_nil( track:getCurve( "reso2BW" ) );
    assert_not_nil( track:getCurve( "reso3BW" ) );
    assert_not_nil( track:getCurve( "reso4BW" ) );
    assert_not_nil( track:getCurve( "reso1Amp" ) );
    assert_not_nil( track:getCurve( "reso2Amp" ) );
    assert_not_nil( track:getCurve( "reso3Amp" ) );
    assert_not_nil( track:getCurve( "reso4Amp" ) );
    assert_not_nil( track:getCurve( "harmonics" ) );
    assert_not_nil( track:getCurve( "fx2depth" ) );
    assert_not_nil( track:getCurve( "gen" ) );
    assert_not_nil( track:getCurve( "por" ) );
    assert_not_nil( track:getCurve( "ope" ) );

    assert_equal( "pit", track:getCurve( "pit" ):getName() );
    assert_equal( 0, track:getCurve( "pit" ):getDefault() );
    assert_equal( -8192, track:getCurve( "pit" ):getMinimum() );
    assert_equal( 8191, track:getCurve( "pit" ):getMaximum() );
    assert_equal( "pbs", track:getCurve( "pbs" ):getName() );
    assert_equal( 2, track:getCurve( "pbs" ):getDefault() );
    assert_equal( 0, track:getCurve( "pbs" ):getMinimum() );
    assert_equal( 24, track:getCurve( "pbs" ):getMaximum() );
    assert_equal( "dyn", track:getCurve( "dyn" ):getName() );
    assert_equal( 0, track:getCurve( "dyn" ):getMinimum() );
    assert_equal( 127, track:getCurve( "dyn" ):getMaximum() );
    assert_equal( "bre", track:getCurve( "bre" ):getName() );
    assert_equal( 0, track:getCurve( "bre" ):getDefault() );
    assert_equal( 0, track:getCurve( "bre" ):getMinimum() );
    assert_equal( 127, track:getCurve( "bre" ):getMaximum() );
    assert_equal( "bri", track:getCurve( "bri" ):getName() );
    assert_equal( 64, track:getCurve( "bri" ):getDefault() );
    assert_equal( 0, track:getCurve( "bri" ):getMinimum() );
    assert_equal( 127, track:getCurve( "bri" ):getMaximum() );
    assert_equal( "cle", track:getCurve( "cle" ):getName() );
    assert_equal( 0, track:getCurve( "cle" ):getDefault() );
    assert_equal( 0, track:getCurve( "cle" ):getMinimum() );
    assert_equal( 127, track:getCurve( "cle" ):getMaximum() );
    assert_equal( "reso1freq", track:getCurve( "reso1Freq" ):getName() );
    assert_equal( 64, track:getCurve( "reso1Freq" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso1Freq" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso1Freq" ):getMaximum() );
    assert_equal( "reso2freq", track:getCurve( "reso2Freq" ):getName() );
    assert_equal( 64, track:getCurve( "reso2Freq" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso2Freq" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso2Freq" ):getMaximum() );
    assert_equal( "reso3freq", track:getCurve( "reso3Freq" ):getName() );
    assert_equal( 64, track:getCurve( "reso3Freq" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso3Freq" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso3Freq" ):getMaximum() );
    assert_equal( "reso4freq", track:getCurve( "reso4Freq" ):getName() );
    assert_equal( 64, track:getCurve( "reso4Freq" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso4Freq" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso4Freq" ):getMaximum() );
    assert_equal( "reso1bw", track:getCurve( "reso1BW" ):getName() );
    assert_equal( 64, track:getCurve( "reso1BW" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso1BW" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso1BW" ):getMaximum() );
    assert_equal( "reso2bw", track:getCurve( "reso2BW" ):getName() );
    assert_equal( 64, track:getCurve( "reso2BW" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso2BW" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso2BW" ):getMaximum() );
    assert_equal( "reso3bw", track:getCurve( "reso3BW" ):getName() );
    assert_equal( 64, track:getCurve( "reso3BW" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso3BW" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso3BW" ):getMaximum() );
    assert_equal( "reso4bw", track:getCurve( "reso4BW" ):getName() );
    assert_equal( 64, track:getCurve( "reso4BW" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso4BW" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso4BW" ):getMaximum() );
    assert_equal( "reso1amp", track:getCurve( "reso1Amp" ):getName() );
    assert_equal( 64, track:getCurve( "reso1Amp" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso1Amp" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso1Amp" ):getMaximum() );
    assert_equal( "reso2amp", track:getCurve( "reso2Amp" ):getName() );
    assert_equal( 64, track:getCurve( "reso2Amp" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso2Amp" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso2Amp" ):getMaximum() );
    assert_equal( "reso3amp", track:getCurve( "reso3Amp" ):getName() );
    assert_equal( 64, track:getCurve( "reso3Amp" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso3Amp" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso3Amp" ):getMaximum() );
    assert_equal( "reso4amp", track:getCurve( "reso4Amp" ):getName() );
    assert_equal( 64, track:getCurve( "reso4Amp" ):getDefault() );
    assert_equal( 0, track:getCurve( "reso4Amp" ):getMinimum() );
    assert_equal( 127, track:getCurve( "reso4Amp" ):getMaximum() );
    assert_equal( "harmonics", track:getCurve( "harmonics" ):getName() );
    assert_equal( 64, track:getCurve( "harmonics" ):getDefault() );
    assert_equal( 0, track:getCurve( "harmonics" ):getMinimum() );
    assert_equal( 127, track:getCurve( "harmonics" ):getMaximum() );
    assert_equal( "fx2depth", track:getCurve( "fx2depth" ):getName() );
    assert_equal( 64, track:getCurve( "fx2depth" ):getDefault() );
    assert_equal( 0, track:getCurve( "fx2depth" ):getMinimum() );
    assert_equal( 127, track:getCurve( "fx2depth" ):getMaximum() );
    assert_equal( "gen", track:getCurve( "gen" ):getName() );
    assert_equal( 64, track:getCurve( "gen" ):getDefault() );
    assert_equal( 0, track:getCurve( "gen" ):getMinimum() );
    assert_equal( 127, track:getCurve( "gen" ):getMaximum() );
    assert_equal( "por", track:getCurve( "por" ):getName() );
    assert_equal( 64, track:getCurve( "por" ):getDefault() );
    assert_equal( 0, track:getCurve( "por" ):getMinimum() );
    assert_equal( 127, track:getCurve( "por" ):getMaximum() );
    assert_equal( "ope", track:getCurve( "ope" ):getName() );
    assert_equal( 127, track:getCurve( "ope" ):getDefault() );
    assert_equal( 0, track:getCurve( "ope" ):getMinimum() );
    assert_equal( 127, track:getCurve( "ope" ):getMaximum() );
end

function testConstructFromMidiEvents()
--    fail();
end

function testGetIndexIterator()
    local track = luavsq.Track.new( "DummyTrackName", "DummySingerName" );
    local iterator = track:getIndexIterator( luavsq.EventList.IndexIteratorKindEnum.NOTE );
    assert_false( iterator:hasNext() );

    iterator = track:getIndexIterator( luavsq.EventList.IndexIteratorKindEnum.SINGER );
    assert_true( iterator:hasNext() );
    assert_equal( 0, iterator:next() );
    assert_false( iterator:hasNext() );
end

function testGetterAndSetterPlayMode()
--    fail();
end

function testGetterAndSetterTrackOn()
--    fail();
end

function testGetterAndSetterName()
    local track = luavsq.Track.new( "DummyTrackName", "DummySingerName" );
    assert_equal( "DummyTrackName", track:getName() );
    track:setName( "foo" );
    assert_equal( "foo", track:getName() );
end

function testGetPitchAt()
--    fail();
end

function testReflectDynamics()
--    fail();
end

function testGetSingerEventAt()
--    fail();
end

function testSortEvent()
--    fail();
end

function testGetIndexIteratorSinger()
    local track = luavsq.Track.new( "DummyTrackName", "DummySingerName" );
    local iterator = track:getIndexIterator( luavsq.EventList.IndexIteratorKindEnum.SINGER );
    assert_true( iterator:hasNext() );
    local event = track.events:get( iterator:next() );
    assert_equal( "DummySingerName", event.singerHandle.ids );
    assert_false( iterator:hasNext() );
end

function testGetIndexIteratorNote()
    local track = luavsq.Track.new( "DummyTrackName", "DummySingerName" );
    local iterator = track:getIndexIterator( luavsq.EventList.IndexIteratorKindEnum.NOTE );
    assert_false( iterator:hasNext() );

    local event = luavsq.Event.new( 480, luavsq.EventTypeEnum.Anote );
    track.events:add( event, 10 );
    iterator = track:getIndexIterator( luavsq.EventList.IndexIteratorKindEnum.NOTE );
    assert_true( iterator:hasNext() );
    local obtained = track.events:get( iterator:next() );
    assert_equal( event, obtained );
    assert_equal( 10, obtained.id );
    assert_false( iterator:hasNext() );
end

function testGetIndexIteratorDynamics()
    local track = luavsq.Track.new( "DummyTrackName", "DummySingerName" );
    local iterator = track:getIndexIterator( luavsq.EventList.IndexIteratorKindEnum.DYNAFF );
    assert_false( iterator:hasNext() );

    local event = luavsq.Event.new( 480, luavsq.EventTypeEnum.Aicon );
    event.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    event.iconDynamicsHandle.iconId = "$05019999";
    track.events:add( event, 10 );
    iterator = track:getIndexIterator( luavsq.EventList.IndexIteratorKindEnum.DYNAFF );
    assert_true( iterator:hasNext() );
    local obtained = track.events:get( iterator:next() );
    assert_equal( event, obtained );
    assert_equal( 10, obtained.id );
    assert_equal( "$05019999", obtained.iconDynamicsHandle.iconId );
    assert_false( iterator:hasNext() );
end

function testPrintMetaText()
    local track = luavsq.Track.new( "DummyTrackName", "DummySingerName" );

    local singerEvent = luavsq.Event.new( 0, luavsq.EventTypeEnum.Singer );
    singerEvent.singerHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Singer ); --h#0000
    singerEvent.singerHandle.iconId = "$07010002";
    singerEvent.singerHandle.ids = "Miku";
    singerEvent.singerHandle.original = 1;
    singerEvent.singerHandle:setCaption( "caption for miku" );
    singerEvent.singerHandle.language = 1;
    singerEvent.singerHandle.program = 2;
    track.events:set( 0, singerEvent );

    local crescendoEvent = luavsq.Event.new( 240, luavsq.EventTypeEnum.Aicon );
    crescendoEvent.note = 64;
    crescendoEvent.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics ); --h#0001
    crescendoEvent.iconDynamicsHandle.iconId = "$05020001";
    crescendoEvent.iconDynamicsHandle.ids = "crescendo";
    crescendoEvent.iconDynamicsHandle.original = 1;
    crescendoEvent.iconDynamicsHandle:setCaption( "caption for crescendo" );
    crescendoEvent.iconDynamicsHandle:setStartDyn( 4 );
    crescendoEvent.iconDynamicsHandle:setEndDyn( 7 );
    crescendoEvent:setLength( 10 );
    track.events:add( crescendoEvent, 2 );

    local dynaffEvent = luavsq.Event.new( 480, luavsq.EventTypeEnum.Aicon );
    dynaffEvent.note = 65;
    dynaffEvent.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );--h#0002
    dynaffEvent.iconDynamicsHandle.iconId = "$05010001";
    dynaffEvent.iconDynamicsHandle.ids = "dynaff";
    dynaffEvent.iconDynamicsHandle.original = 2;
    dynaffEvent.iconDynamicsHandle:setCaption( "caption for dynaff" );
    dynaffEvent.iconDynamicsHandle:setStartDyn( 5 );
    dynaffEvent.iconDynamicsHandle:setEndDyn( 8 );
    dynaffEvent:setLength( 11 );
    track.events:add( dynaffEvent, 3 );

    local decrescendoEvent = luavsq.Event.new( 720, luavsq.EventTypeEnum.Aicon );
    decrescendoEvent.note = 66;
    decrescendoEvent.iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );--h#0003
    decrescendoEvent.iconDynamicsHandle.iconId = "$05030001";
    decrescendoEvent.iconDynamicsHandle.ids = "decrescendo";
    decrescendoEvent.iconDynamicsHandle.original = 3;
    decrescendoEvent.iconDynamicsHandle:setCaption( "caption for decrescendo" );
    decrescendoEvent.iconDynamicsHandle:setStartDyn( 6 );
    decrescendoEvent.iconDynamicsHandle:setEndDyn( 9 );
    decrescendoEvent:setLength( 12 );
    track.events:add( decrescendoEvent, 4 );

    local singerEvent2 = luavsq.Event.new( 1920, luavsq.EventTypeEnum.Singer );
    singerEvent2.singerHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Singer );--h#0004
    singerEvent2.singerHandle.iconId = "$07020003";
    singerEvent2.singerHandle.ids = "Luka_EN";
    singerEvent2.singerHandle.original = 0x82;
    singerEvent2.singerHandle:setCaption( "caption for luka" );
    singerEvent2.singerHandle.language = 2;
    singerEvent2.singerHandle.program = 3;
    track.events:add( singerEvent2, 5 );

    local noteEvent = luavsq.Event.new( 1920, luavsq.EventTypeEnum.Anote );
    noteEvent.note = 67;
    noteEvent.dynamics = 68;
    noteEvent.pmBendDepth = 69;
    noteEvent.pmBendLength = 70;
    noteEvent.pmbPortamentoUse = 3;
    noteEvent.demDecGainRate = 71;
    noteEvent.demAccent = 72;
    noteEvent:setLength( 480 );
    noteEvent.lyricHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Lyric );
    noteEvent.lyricHandle:setLyricAt( 0, luavsq.Lyric.new( "ら", "4 a" ) );--h#0005
    noteEvent.vibratoHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );--h#0006
    noteEvent.vibratoDelay = 73;
    noteEvent.vibratoHandle.iconId ="$04040004";
    noteEvent.vibratoHandle.ids = "vibrato";
    noteEvent.vibratoHandle.original = 1;
    noteEvent.vibratoHandle:setCaption( "caption for vibrato" );
    noteEvent.vibratoHandle:setLength( 407 );
    noteEvent.vibratoHandle:setStartDepth( 13 );
    noteEvent.vibratoHandle:setStartRate( 14 );
    noteEvent.noteHeadHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.NoteHead );--h#0007
    noteEvent.noteHeadHandle.iconId = "$05030000";
    noteEvent.noteHeadHandle.ids = "attack";
    noteEvent.noteHeadHandle.original = 15;
    noteEvent.noteHeadHandle:setCaption( "caption for attack" );
    noteEvent.noteHeadHandle:setLength( 120 );
    noteEvent.noteHeadHandle:setDuration( 62 );
    noteEvent.noteHeadHandle:setDepth( 65 );
    track.events:add( noteEvent, 6 );

    track.master = luavsq.Master.new( 1 );

    track.mixer = luavsq.Mixer.new( 1, 2, 3, 4 );
    track.mixer.slave = {};
    track.mixer.slave[1] = luavsq.MixerItem.new( 5, 6, 7, 8 );

    track.common.version = "DSB301";
    track.common.name = "foo";
    track.common.color = "1,2,3";
    track.common.dynamicsMode = luavsq.DynamicsModeEnum.STANDARD;
    track.common.playMode = luavsq.PlayModeEnum.PlayWithSynth;

    local curves = {
        "pit", "pbs", "dyn", "bre", "bri", "cle",
        "RESO1FREQ", "RESO2FREQ", "RESO3FREQ", "RESO4FREQ",
        "RESO1BW", "RESO2BW", "RESO3BW", "RESO4BW",
        "RESO1amp", "RESO2amp", "RESO3amp", "RESO4amp",
        "HARMONICS", "fx2depth", "GEN", "pOr", "OPE"
    };
    local i, curveName;
    for i, curveName in ipairs( curves ) do
        track:getCurve( curveName ):add( 480 + i, i );
    end

    local stream = luavsq.TextStream.new();
    track:printMetaText( stream, 2400, 0 );
    local expected =
        "[Common]\n" ..
        "Version=DSB301\n" ..
        "Name=foo\n" ..
        "Color=1,2,3\n" ..
        "DynamicsMode=0\n" ..
        "PlayMode=1\n" ..

        "[Master]\n" ..
        "PreMeasure=1\n" ..

        "[Mixer]\n" ..
        "MasterFeder=1\n" ..
        "MasterPanpot=2\n" ..
        "MasterMute=3\n" ..
        "OutputMode=4\n" ..
        "Tracks=1\n" ..
        "Feder0=5\n" ..
        "Panpot0=6\n" ..
        "Mute0=7\n" ..
        "Solo0=8\n" ..

        "[EventList]\n" ..
        "0=ID#0000\n" ..
        "240=ID#0001\n" ..
        "480=ID#0002\n" ..
        "720=ID#0003\n" ..
        "1920=ID#0004,ID#0005\n" ..
        "2400=EOS\n" ..

        "[ID#0000]\n" ..
        "Type=Singer\n" ..
        "IconHandle=h#0000\n" ..

        "[ID#0001]\n" ..
        "Type=Aicon\n" ..
        "IconHandle=h#0001\n" ..
        "Note#=64\n" ..

        "[ID#0002]\n" ..
        "Type=Aicon\n" ..
        "IconHandle=h#0002\n" ..
        "Note#=65\n" ..

        "[ID#0003]\n" ..
        "Type=Aicon\n" ..
        "IconHandle=h#0003\n" ..
        "Note#=66\n" ..

        "[ID#0004]\n" ..
        "Type=Singer\n" ..
        "IconHandle=h#0004\n" ..

        "[ID#0005]\n" ..
        "Type=Anote\n" ..
        "Length=480\n" ..
        "Note#=67\n" ..
        "Dynamics=68\n" ..
        "PMBendDepth=69\n" ..
        "PMBendLength=70\n" ..
        "PMbPortamentoUse=3\n" ..
        "DEMdecGainRate=71\n" ..
        "DEMaccent=72\n" ..
        "LyricHandle=h#0005\n" ..
        "VibratoHandle=h#0006\n" ..
        "VibratoDelay=73\n" ..
        "NoteHeadHandle=h#0007\n" ..

        "[h#0000]\n" ..
        "IconID=$07010002\n" ..
        "IDS=Miku\n" ..
        "Original=1\n" ..
        "Caption=caption for miku\n" ..
        "Length=0\n" ..
        "Language=1\n" ..
        "Program=2\n" ..

        "[h#0001]\n" ..
        "IconID=$05020001\n" ..
        "IDS=crescendo\n" ..
        "Original=1\n" ..
        "Caption=caption for crescendo\n" ..
        "StartDyn=4\n" ..
        "EndDyn=7\n" ..
        "Length=10\n" ..
        "DynBPNum=0\n" ..

        "[h#0002]\n" ..
        "IconID=$05010001\n" ..
        "IDS=dynaff\n" ..
        "Original=2\n" ..
        "Caption=caption for dynaff\n" ..
        "StartDyn=5\n" ..
        "EndDyn=8\n" ..
        "Length=11\n" ..
        "DynBPNum=0\n" ..

        "[h#0003]\n" ..
        "IconID=$05030001\n" ..
        "IDS=decrescendo\n" ..
        "Original=3\n" ..
        "Caption=caption for decrescendo\n" ..
        "StartDyn=6\n" ..
        "EndDyn=9\n" ..
        "Length=12\n" ..
        "DynBPNum=0\n" ..

        "[h#0004]\n" ..
        "IconID=$07020003\n" ..
        "IDS=Luka_EN\n" ..
        "Original=130\n" ..
        "Caption=caption for luka\n" ..
        "Length=0\n" ..
        "Language=2\n" ..
        "Program=3\n" ..

        "[h#0005]\n" ..
        "L0=\"ら\",\"4 a\",1,64,0,0\n" ..

        "[h#0006]\n" ..
        "IconID=$04040004\n" ..
        "IDS=vibrato\n" ..
        "Original=1\n" ..
        "Caption=caption for vibrato\n" ..
        "Length=407\n" ..
        "StartDepth=13\n" ..
        "DepthBPNum=0\n" ..
        "StartRate=14\n" ..
        "RateBPNum=0\n" ..

        "[h#0007]\n" ..
        "IconID=$05030000\n" ..
        "IDS=attack\n" ..
        "Original=15\n" ..
        "Caption=caption for attack\n" ..
        "Length=120\n" ..
        "Duration=62\n" ..
        "Depth=65\n" ..

        "[PitchBendBPList]\n" ..
        "481=1\n" ..

        "[PitchBendSensBPList]\n" ..
        "482=2\n" ..

        "[DynamicsBPList]\n" ..
        "483=3\n" ..

        "[EpRResidualBPList]\n" ..
        "484=4\n" ..

        "[EpRESlopeBPList]\n" ..
        "485=5\n" ..

        "[EpRESlopeDepthBPList]\n" ..
        "486=6\n" ..

        "[GenderFactorBPList]\n" ..
        "501=21\n" ..

        "[PortamentoTimingBPList]\n" ..
        "502=22\n" ..

        "[OpeningBPList]\n" ..
        "503=23\n";

    assert_equal( expected, stream:toString() );
end

function testChangeRenderer()
--    fail();
end

function testGetterAndSetterCurve()
    local track = luavsq.Track.new( "DummyTrackName", "DummySingerName" );
    assert_equal( track._pit, track:getCurve( "PiT" ) );
    assert_equal( track._pbs, track:getCurve( "PBS" ) );
    assert_equal( track._dyn, track:getCurve( "DYN" ) );
    assert_equal( track._bre, track:getCurve( "bre" ) );
    assert_equal( track._bri, track:getCurve( "BRI" ) )
    assert_equal( track._cle, track:getCurve( "CLE" ) );
    assert_equal( track._reso1FreqBPList, track:getCurve( "RESO1FREQ" ) );
    assert_equal( track._reso2FreqBPList, track:getCurve( "RESO2FREQ" ) );
    assert_equal( track._reso3FreqBPList, track:getCurve( "RESO3FREQ" ) );
    assert_equal( track._reso4FreqBPList, track:getCurve( "RESO4FREQ" ) );
    assert_equal( track._reso1BWBPList, track:getCurve( "RESO1BW" ) );
    assert_equal( track._reso2BWBPList, track:getCurve( "RESO2BW" ) );
    assert_equal( track._reso3BWBPList, track:getCurve( "RESO3BW" ) );
    assert_equal( track._reso4BWBPList, track:getCurve( "RESO4BW" ) );
    assert_equal( track._reso1AmpBPList, track:getCurve( "RESO1amp" ) );
    assert_equal( track._reso2AmpBPList, track:getCurve( "RESO2amp" ) );
    assert_equal( track._reso3AmpBPList, track:getCurve( "RESO3amp" ) );
    assert_equal( track._reso4AmpBPList, track:getCurve( "RESO4amp" ) );
    assert_equal( track._harmonics, track:getCurve( "HARMONICS" ) );
    assert_equal( track._fx2depth, track:getCurve( "fx2depth" ) );
    assert_equal( track._gen, track:getCurve( "GEN" ) );
    assert_equal( track._por, track:getCurve( "pOr" ) );
    assert_equal( track._ope, track:getCurve( "OPE" ) );
    assert_nil( track:getCurve( "__UNKNOWN_CURVE_NAME__" ) );

    local curves = {
        "PiT", "PBS", "DYN", "bre", "BRI", "CLE",
        "RESO1FREQ", "RESO2FREQ", "RESO3FREQ", "RESO4FREQ",
        "RESO1BW", "RESO2BW", "RESO3BW", "RESO4BW",
        "RESO1amp", "RESO2amp", "RESO3amp", "RESO4amp",
        "HARMONICS", "fx2depth", "GEN", "pOr", "OPE"
    };
    local i;
    for i = 1, #curves, 1 do
        track:setCurve( curves[i], nil );
    end
    for i = 1, #curves, 1 do
        assert_nil( track:getCurve( curves[i] ) );
    end

    local dummyList = luavsq.BPList.new( "foo", 1, -1000, 1000 );
    for i = 1, #curves, 1 do
        local j;
        for j = 1, #curves, 1 do
            track:setCurve( curves[j], nil );
        end
        track:setCurve( curves[i], dummyList );
        for j = 1, #curves, 1 do
            if( curves[i] == curves[j] )then
                assert_equal( dummyList, track:getCurve( curves[j] ) );
            else
                assert_nil( track:getCurve( curves[j] ) );
            end
        end
    end
end

function testClone()
    local track = luavsq.Track.new( "DummyTrackName", "DummySingerName" );
    local event = luavsq.Event.new( 480, luavsq.EventTypeEnum.Anote );
    track.events:add( event );
    track:getCurve( "pit" ):add( 480, 100 );
    track.tag = "valueOfTag";

    local copy = track:clone();
    assert_equal( 2, copy.events:size() );
    assert_equal( 0, copy.events:get( 0 ).clock );
    assert_equal( luavsq.EventTypeEnum.Singer, copy.events:get( 0 ).type );
    assert_equal( "DummySingerName", copy.events:get( 0 ).singerHandle.ids );
    assert_equal( 480, copy.events:get( 1 ).clock );
    assert_equal( luavsq.EventTypeEnum.Anote, copy.events:get( 1 ).type );
    assert_equal( 1, copy:getCurve( "pit" ):size() );
    assert_equal( 480, copy:getCurve( "pit" ):getKeyClock( 0 ) );
    assert_equal( 100, copy:getCurve( "pit" ):get( 0 ).value );
    assert_equal( "DummyTrackName", copy:getName() );
    assert_equal( "valueOfTag", copy.tag );
end

function testGetLyricLength()
--    fail();
end
