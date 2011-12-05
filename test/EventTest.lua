require( "lunit" );
dofile( "../Event.lua" );
dofile( "../Util.lua" );
dofile( "../EventTypeEnum.lua" );
dofile( "../TextStream.lua" );
dofile( "../ArticulationTypeEnum.lua" );
dofile( "../Lyric.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleTypeEnum.lua" );
module( "EventTest", package.seeall, lunit.testcase );

function getNoteEvent()
    local noteEvent = luavsq.Event.new( 0, luavsq.EventTypeEnum.Anote );
    noteEvent:setLength( 2 );
    noteEvent.note = 6;
    noteEvent.dynamics = 21;
    noteEvent.pmBendDepth = 4;
    noteEvent.pmBendLength = 5;
    noteEvent.pmbPortamentoUse = 3;
    noteEvent.demDecGainRate = 7;
    noteEvent.demAccent = 8;
    noteEvent.preUtterance = 9;
    noteEvent.voiceOverlap = 10;
    noteEvent.lyricHandle = nil;
    noteEvent._lyricHandleIndex = 11;
    noteEvent.vibratoHandle = nil;
    noteEvent._vibratoHandleIndex = 12;
    noteEvent.vibratoDelay = 13;
    noteEvent.noteHeadHandle = nil;
    noteEvent._noteHeadHandleIndex = 14;
    return noteEvent;
end

function getSingerEvent()
    local singerEvent = luavsq.Event.new( 0, luavsq.EventTypeEnum.Singer );
    singerEvent.singerHandle = nil;
    singerEvent._singerHandleIndex = 16;
    singerEvent.index = 15;
    return singerEvent;
end

function getIconEvent()
    local iconEvent = luavsq.Event.new( 0, luavsq.EventTypeEnum.Aicon );
    iconEvent.singerHandle = nil;
    iconEvent._singerHandleIndex = 18;
    iconEvent.note = 19;
    iconEvent.index = 17;
    return iconEvent;
end

function testConstruct()
    local event = luavsq.Event.new();
    assert_equal( 0, event.clock );
    assert_equal( 0, event.id );
end

function testConstructWithLine()
    local event = luavsq.Event.new( "123=ID#0001" );
    assert_equal( 123, event.clock );

    event = luavsq.Event.new( "1230=EOS" );
    assert_equal( 1230, event.clock );
    assert_true( event:isEOS() );
end

function testConstructWithClockAndId()
    local event = luavsq.Event.new( 1, luavsq.EventTypeEnum.Anote );
    event.note = 60;
    event.index = 12;

    assert_equal( 1, event.clock );
    assert_equal( 12, event.index );
    assert_equal( 60, event.note );
end

function testEquals()
--    fail();
end

function testWriteNoteWithOption()
    local event = getNoteEvent();
    event.clock = 20;
    event.index = 1;
    local optionAll = {
        "Length",
        "Note#",
        "Dynamics",
        "PMBendDepth",
        "PMBendLength",
        "PMbPortamentoUse",
        "DEMdecGainRate",
        "DEMaccent",
        --TODO: "PreUtterance",
        --TODO: "VoiceOverlap"
    };

    local stream = luavsq.TextStream.new();

    --handleがどれもnilな音符イベント
    event:write( stream, optionAll );
    local expected =
        "[ID#0001]\n" ..
        "Type=Anote\n" ..
        "Length=2\n" ..
        "Note#=6\n" ..
        "Dynamics=21\n" ..
        "PMBendDepth=4\n" ..
        "PMBendLength=5\n" ..
        "PMbPortamentoUse=3\n" ..
        "DEMdecGainRate=7\n" ..
        "DEMaccent=8\n";
        --TODO: "PreUtterance=9\n" ..
        --TODO: "VoiceOverlap=10\n" ..
    assert_equal( expected, stream:toString() );

    --handleに全部値が入っている音符イベント
    --現在、PreUtteranceとVoiceOverlapは扱わないようにしているので、
    --オプション全指定と、オプションが無い場合の動作が全くおなじになってしまっている。
    --ustEventをちゃんと処理するようになったら、TODOコメントのところを外すこと
    event.lyricHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Lyric );
    event.lyricHandle:setLyricAt( 0, luavsq.Lyric.new( "わ", "w a" ) );
    event.vibratoHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    event.noteHeadHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.NoteHead );
    stream = luavsq.TextStream.new();
    event:write( stream, optionAll );
    expected =
        "[ID#0001]\n" ..
        "Type=Anote\n" ..
        "Length=2\n" ..
        "Note#=6\n" ..
        "Dynamics=21\n" ..
        "PMBendDepth=4\n" ..
        "PMBendLength=5\n" ..
        "PMbPortamentoUse=3\n" ..
        "DEMdecGainRate=7\n" ..
        "DEMaccent=8\n" ..
        --TODO: "PreUtterance=9\n" ..
        --TODO: "VoiceOverlap=10\n" ..
        "LyricHandle=h#0011\n" ..
        "VibratoHandle=h#0012\n" ..
        "VibratoDelay=13\n" ..
        "NoteHeadHandle=h#0014\n";
    assert_equal( expected, stream:toString() );

    -- オプションが無い場合
    stream = luavsq.TextStream.new();
    event:write( stream );
    expected =
        "[ID#0001]\n" ..
        "Type=Anote\n" ..
        "Length=2\n" ..
        "Note#=6\n" ..
        "Dynamics=21\n" ..
        "PMBendDepth=4\n" ..
        "PMBendLength=5\n" ..
        "PMbPortamentoUse=3\n" ..
        "DEMdecGainRate=7\n" ..
        "DEMaccent=8\n" ..
        "LyricHandle=h#0011\n" ..
        "VibratoHandle=h#0012\n" ..
        "VibratoDelay=13\n" ..
        "NoteHeadHandle=h#0014\n";
    assert_equal( expected, stream:toString() );

    -- オプションが空の場合
    stream = luavsq.TextStream.new();
    event:write( stream, {} );
    expected =
        "[ID#0001]\n" ..
        "Type=Anote\n" ..
        "LyricHandle=h#0011\n" ..
        "VibratoHandle=h#0012\n" ..
        "VibratoDelay=13\n" ..
        "NoteHeadHandle=h#0014\n";
    assert_equal( expected, stream:toString() );
end

function testWriteSinger()
    local event = getSingerEvent();
    event.clock = 1;
    event.index = 15;
    local stream = luavsq.TextStream.new();
    event:write( stream );
    local expected =
        "[ID#0015]\n" ..
        "Type=Singer\n" ..
        "IconHandle=h#0016\n";
    assert_equal( expected, stream:toString() );
end

function testWriteIcon()
    local event = getIconEvent();
    event.clock = 2;
    event.index = 17;
    local stream = luavsq.TextStream.new();
    event:write( stream );
    local expected =
        "[ID#0017]\n" ..
        "Type=Aicon\n" ..
        "IconHandle=h#0018\n" ..
        "Note#=19\n";
    assert_equal( expected, stream:toString() );
end

function testClone()
    local event = getSingerEvent();
    event.clock = 40;
    event.id = 4;
    event.singerHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Singer );
    event.singerHandle.index = 12;
    local copy = event:clone();
    assert_equal( 40, copy.clock );
    assert_equal( 4, copy.id );
    assert_equal( 12, copy.singerHandle.index );
--TODO: ustEventのclone

    local id = luavsq.Event.new( 0, luavsq.EventTypeEnum.Anote );
    id.index = 1;
    id.note = 6;
    id.dynamics = 7;
    id.pmBendDepth = 8;
    id.pmBendLength = 9;
    id.pmbPortamentoUse = 10;
    id.demDecGainRate = 11;
    id.demAccent = 12;
    id.vibratoDelay = 13;
    id.pMeanOnsetFirstNote = 14;
    id.vMeanNoteTransition = 15;
    id.d4mean = 16;
    id.pMeanEndingNote = 17;
    assert_nil( id.singerHandle );
    assert_not_nil( id.lyricHandle );
    assert_nil( id.vibratoHandle );
    assert_nil( id.noteHeadHandle );
    assert_nil( id.iconDynamicsHandle );

    local copy = id:clone();
    assert_equal( 1, copy.index );
    assert_equal( luavsq.EventTypeEnum.Anote, copy.type );
    assert_equal( 6, copy.note );
    assert_equal( 7, copy.dynamics );
    assert_equal( 8, copy.pmBendDepth );
    assert_equal( 9, copy.pmBendLength );
    assert_equal( 10, copy.pmbPortamentoUse );
    assert_equal( 11, copy.demDecGainRate );
    assert_equal( 12, copy.demAccent );
    assert_equal( 13, copy.vibratoDelay );
    assert_equal( 14, copy.pMeanOnsetFirstNote );
    assert_equal( 15, copy.vMeanNoteTransition );
    assert_equal( 16, copy.d4mean );
    assert_equal( 17, copy.pMeanEndingNote );

    local iconHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Singer );
    iconHandle:setCaption( "foo" );
    id.singerHandle = iconHandle;
    local lyricHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Lyric );
    lyricHandle.index = 102;
    id.lyricHandle = lyricHandle;
    local vibratoHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    vibratoHandle.iconId = "aho";
    id.vibratoHandle = vibratoHandle;
    local noteHeadHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.NoteHead );
    noteHeadHandle.ids = "baka";
    id.noteHeadHandle = noteHeadHandle;
    local iconDynamicsHandle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    iconDynamicsHandle:setStartDyn( 183635 );
    id.iconDynamicsHandle = iconDynamicsHandle;

    copy = id:clone();
    assert_equal( "foo", copy.singerHandle:getCaption() );
    assert_equal( 102, copy.lyricHandle.index );
    assert_equal( "aho", copy.vibratoHandle.iconId );
    assert_equal( "baka", copy.noteHeadHandle.ids );
    assert_equal( 183635, copy.iconDynamicsHandle:getStartDyn() );
end

function testCompareTo()
    local singerEvent = luavsq.Event.new( 1920, luavsq.EventTypeEnum.Singer );
    local noteEvent = luavsq.Event.new( 1920, luavsq.EventTypeEnum.Anote );
    assert_equal( 0, singerEvent:compareTo( singerEvent ) );
    assert_true( 0 > singerEvent:compareTo( noteEvent ) );
    assert_true( 0 < noteEvent:compareTo( singerEvent ) );

    singerEvent.clock = 2000;
    noteEvent.clock = 1920;
    assert_true( 0 < singerEvent:compareTo( noteEvent ) );

    singerEvent.clock = 2000;
    noteEvent.clock = 2001;
    assert_equal( 1, noteEvent:compareTo( singerEvent ) );
end

function testCompare()
    local singerEvent = getSingerEvent();
    singerEvent.clock = 1920;
    local noteEvent = getNoteEvent();
    noteEvent.clock = 1920;
    assert_false( luavsq.Event.compare( singerEvent, singerEvent ) );
    assert_true( luavsq.Event.compare( singerEvent, noteEvent ) );
    assert_false( luavsq.Event.compare( noteEvent, singerEvent ) );

    singerEvent.clock = 2000;
    noteEvent.clock = 1920;
    assert_false( luavsq.Event.compare( singerEvent, noteEvent ) );

    singerEvent.clock = 2000;
    noteEvent.clock = 2001;
    assert_false( luavsq.Event.compare( noteEvent, singerEvent ) );
end
