require( "lunit" );
dofile( "../Event.lua" );
dofile( "../Id.lua" );
dofile( "../Util.lua" );
dofile( "../IdTypeEnum.lua" );
dofile( "../SingerHandle.lua" );
dofile( "../TextStream.lua" );
dofile( "../LyricHandle.lua" );
dofile( "../ArticulationTypeEnum.lua" );
dofile( "../Lyric.lua" );
dofile( "../VibratoHandle.lua" );
dofile( "../IconParameter.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../NoteHeadHandle.lua" );
module( "EventTest", package.seeall, lunit.testcase );

function getNoteId()
    local noteId = luavsq.Id.new( 1 );
    noteId.type = luavsq.IdTypeEnum.Anote;
    noteId:setLength( 2 );
    noteId.note = 6;
    noteId.dynamics = 21;
    noteId.pmBendDepth = 4;
    noteId.pmBendLength = 5;
    noteId.pmbPortamentoUse = 3;
    noteId.demDecGainRate = 7;
    noteId.demAccent = 8;
    noteId.preUtterance = 9;
    noteId.voiceOverlap = 10;
    noteId.lyricHandle = nil;
    noteId.lyricHandleIndex = 11;
    noteId.vibratoHandle = nil;
    noteId.vibratoHandleIndex = 12;
    noteId.vibratoDelay = 13;
    noteId.noteHeadHandle = nil;
    noteId.noteHeadHandleIndex = 14;
    return noteId;
end

function getSingerId()
    local singerId = luavsq.Id.new( 15 );
    singerId.type = luavsq.IdTypeEnum.Singer;
    singerId.singerHandle = nil;
    singerId.singerHandleIndex = 16;
    return singerId;
end

function getIconId()
    local iconId = luavsq.Id.new( 17 );
    iconId.type = luavsq.IdTypeEnum.Aicon;
    iconId.singerHandle = nil;
    iconId.singerHandleIndex = 18;
    iconId.note = 19;
    return iconId;
end

function testConstruct()
    local event = luavsq.Event.new();
    assert_equal( 0, event.clock );
    assert_not_nil( event.id );
    assert_equal( 0, event.internalId );
end

function testConstructWithLine()
    local event = luavsq.Event.new( "123=ID#0001" );
    assert_equal( 123, event.clock );
    assert_nil( event.id );

    event = luavsq.Event.new( "1230=EOS" );
    assert_equal( 1230, event.clock );
    assert_not_nil( event.id );
end

function testConstructWithClockAndId()
    local id = luavsq.Id.new( 12 );
    id.note = 60;
    local event = luavsq.Event.new( 1, id );
    assert_equal( 1, event.clock );
    assert_equal( 12, event.id.value );
    assert_equal( 60, event.id.note );
end

function testEquals()
--    fail();
end

function testWriteNoteWithOption()
    local noteId = getNoteId();

    local event = luavsq.Event.new( 20, noteId );
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
    noteId.lyricHandle = luavsq.LyricHandle.new( "わ", "w a" );
    noteId.vibratoHandle = luavsq.VibratoHandle.new();
    noteId.noteHeadHandle = luavsq.NoteHeadHandle.new();
    event.id = noteId;
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
    local singerId = getSingerId();
    local event = luavsq.Event.new( 1, singerId );
    local stream = luavsq.TextStream.new();
    event:write( stream );
    local expected =
        "[ID#0015]\n" ..
        "Type=Singer\n" ..
        "IconHandle=h#0016\n";
    assert_equal( expected, stream:toString() );
end

function testWriteIcon()
    local iconId = getIconId();
    local event = luavsq.Event.new( 2, iconId );
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
    local singerId = getSingerId();
    singerId.singerHandle = luavsq.SingerHandle.new();
    singerId.singerHandle.index = 12;
    local event = luavsq.Event.new( 40, singerId );
    event.internalId = 4;
    local copy = event:clone();
    assert_equal( 40, copy.clock );
    assert_equal( 4, copy.internalId );
    assert_equal( 12, copy.id.singerHandle.index );
--TODO: ustEventのclone
end

function testCompareTo()
    local singerEvent = luavsq.Event.new( 1920, getSingerId() );
    local noteEvent = luavsq.Event.new( 1920, getNoteId() );
    assert_equal( 0, singerEvent:compareTo( singerEvent ) );
    assert_true( 0 > singerEvent:compareTo( noteEvent ) );
    assert_true( 0 < noteEvent:compareTo( singerEvent ) );

    singerEvent.clock = 2000;
    noteEvent.clock = 1920;
    assert_true( 0 < singerEvent:compareTo( noteEvent ) );

    singerEvent.clock = 2000;
    singerEvent.id = nil;
    noteEvent.clock = 2001;
    noteEvent.id = nil;
    assert_equal( 1, noteEvent:compareTo( singerEvent ) );
end

function testCompare()
    local singerEvent = luavsq.Event.new( 1920, getSingerId() );
    local noteEvent = luavsq.Event.new( 1920, getNoteId() );
    assert_equal( 0, luavsq.Event.compare( singerEvent, singerEvent ) );
    assert_true( 0 > luavsq.Event.compare( singerEvent, noteEvent ) );
    assert_true( 0 < luavsq.Event.compare( noteEvent, singerEvent ) );

    singerEvent.clock = 2000;
    noteEvent.clock = 1920;
    assert_true( 0 < luavsq.Event.compare( singerEvent, noteEvent ) );

    singerEvent.clock = 2000;
    singerEvent.id = nil;
    noteEvent.clock = 2001;
    noteEvent.id = nil;
    assert_equal( 1, luavsq.Event.compare( noteEvent, singerEvent ) );
end
