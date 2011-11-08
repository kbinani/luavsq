require( "lunit" );
dofile( "../Event.lua" );
dofile( "../IDType.lua" );
dofile( "../ID.lua" );
dofile( "../Util.lua" );
dofile( "../TextStream.lua" );
dofile( "../LyricHandle.lua" );
dofile( "../ArticulationType.lua" );
dofile( "../Lyric.lua" );
dofile( "../VibratoHandle.lua" );
dofile( "../IconParameter.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../NoteHeadHandle.lua" );
dofile( "../IconHandle.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function getNoteID()
    local noteID = luavsq.ID.new( 1 );
    noteID.type = luavsq.IDType.Anote;
    noteID:setLength( 2 );
    noteID.note = 6;
    noteID.dynamics = 21;
    noteID.pmBendDepth = 4;
    noteID.pmBendLength = 5;
    noteID.pmbPortamentoUse = 3;
    noteID.demDecGainRate = 7;
    noteID.demAccent = 8;
    noteID.preUtterance = 9;
    noteID.voiceOverlap = 10;
    noteID.lyricHandle = nil;
    noteID.lyricHandleIndex = 11;
    noteID.vibratoHandle = nil;
    noteID.vibratoHandleIndex = 12;
    noteID.vibratoDelay = 13;
    noteID.noteHeadHandle = nil;
    noteID.noteHeadHandleIndex = 14;
    return noteID;
end

function getSingerID()
    local singerID = luavsq.ID.new( 15 );
    singerID.type = luavsq.IDType.Singer;
    singerID.iconHandle = nil;
    singerID.iconHandleIndex = 16;
    return singerID;
end

function getIconID()
    local iconID = luavsq.ID.new( 17 );
    iconID.type = luavsq.IDType.Aicon;
    iconID.iconHandle = nil;
    iconID.iconHandleIndex = 18;
    iconID.note = 19;
    return iconID;
end

function testConstruct()
    local event = luavsq.Event.new();
    assert_equal( 0, event.clock );
    assert_not_nil( event.ID );
    assert_equal( 0, event.internalID );
end

function testConstructWithLine()
    local event = luavsq.Event.new( "123=ID#0001" );
    assert_equal( 123, event.clock );
    assert_nil( event.ID );

    event = luavsq.Event.new( "1230=EOS" );
    assert_equal( 1230, event.clock );
    assert_not_nil( event.ID );
end

function testConstructWithClockAndID()
    local id = luavsq.ID.new( 12 );
    id.note = 60;
    local event = luavsq.Event.new( 1, id );
    assert_equal( 1, event.clock );
    assert_equal( 12, event.ID.value );
    assert_equal( 60, event.ID.note );
end

function testEquals()
--    fail();
end

function testWriteNoteWithOption()
    local noteID = getNoteID();

    local event = luavsq.Event.new( 20, noteID );
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
    noteID.lyricHandle = luavsq.LyricHandle.new( "わ", "w a" );
    noteID.vibratoHandle = luavsq.VibratoHandle.new();
    noteID.noteHeadHandle = luavsq.NoteHeadHandle.new();
    event.ID = noteID;
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
    local singerID = getSingerID();
    local event = luavsq.Event.new( 1, singerID );
    local stream = luavsq.TextStream.new();
    event:write( stream );
    local expected =
        "[ID#0015]\n" ..
        "Type=Singer\n" ..
        "IconHandle=h#0016\n";
    assert_equal( expected, stream:toString() );
end

function testWriteIcon()
    local iconID = getIconID();
    local event = luavsq.Event.new( 2, iconID );
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
    local singerID = getSingerID();
    singerID.iconHandle = luavsq.IconHandle.new();
    singerID.iconHandle.index = 12;
    local event = luavsq.Event.new( 40, singerID );
    event.internalID = 4;
    local copy = event:clone();
    assert_equal( 40, copy.clock );
    assert_equal( 4, copy.internalID );
    assert_equal( 12, copy.ID.iconHandle.index );
--TODO: ustEventのclone
end

function testCompareTo()
    local singerEvent = luavsq.Event.new( 1920, getSingerID() );
    local noteEvent = luavsq.Event.new( 1920, getNoteID() );
    assert_equal( 0, singerEvent:compareTo( singerEvent ) );
    assert_true( 0 > singerEvent:compareTo( noteEvent ) );
    assert_true( 0 < noteEvent:compareTo( singerEvent ) );

    singerEvent.clock = 2000;
    noteEvent.clock = 1920;
    assert_true( 0 < singerEvent:compareTo( noteEvent ) );

    singerEvent.clock = 2000;
    singerEvent.ID = nil;
    noteEvent.clock = 2001;
    noteEvent.ID = nil;
    assert_equal( 1, noteEvent:compareTo( singerEvent ) );
end

function testCompare()
    local singerEvent = luavsq.Event.new( 1920, getSingerID() );
    local noteEvent = luavsq.Event.new( 1920, getNoteID() );
    assert_equal( 0, luavsq.Event.compare( singerEvent, singerEvent ) );
    assert_true( 0 > luavsq.Event.compare( singerEvent, noteEvent ) );
    assert_true( 0 < luavsq.Event.compare( noteEvent, singerEvent ) );

    singerEvent.clock = 2000;
    noteEvent.clock = 1920;
    assert_true( 0 < luavsq.Event.compare( singerEvent, noteEvent ) );

    singerEvent.clock = 2000;
    singerEvent.ID = nil;
    noteEvent.clock = 2001;
    noteEvent.ID = nil;
    assert_equal( 1, luavsq.Event.compare( noteEvent, singerEvent ) );
end
