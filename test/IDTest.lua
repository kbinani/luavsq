require( "lunit" );
dofile( "../IDType.lua" );
dofile( "../ID.lua" );
dofile( "../IconHandle.lua" );
dofile( "../LyricHandle.lua" );
dofile( "../ArticulationType.lua" );
dofile( "../Lyric.lua" );
dofile( "../VibratoHandle.lua" );
dofile( "../IconParameter.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../NoteHeadhandle.lua" );
dofile( "../IconDynamicsHandle.lua" );
dofile( "../Util.lua" );
module( "enhanced", package.seeall, lunit.testcase );

function testConstructWithValue()
    local id = luavsq.ID.new( 1 );
    assert_equal( 1, id.value );
    assert_equal( 0, id.iconHandleIndex );
    assert_equal( 0, id.lyricHandleIndex );
    assert_equal( 0, id.vibratoHandleIndex );
    assert_equal( 0, id.noteHeadHandleIndex );
    assert_equal( luavsq.IDType.Note, id.type );
    assert_nil( id.iconHandle );
    assert_equal( 0, id.note );
    assert_equal( 0, id.dynamics );
    assert_equal( 0, id.pmBendDepth );
    assert_equal( 0, id.pmBendLength );
    assert_equal( 0, id.pmbPortamentoUse );
    assert_equal( 0, id.demDecGainRate );
    assert_equal( 0, id.demAccent );
    assert_nil( id.lyricHandle );
    assert_nil( id.vibratoHandle );
    assert_equal( 0, id.vibratoDelay );
    assert_nil( id.noteHeadHandle );
    assert_equal( 10, id.pMeanOnsetFirstNote );
    assert_equal( 12, id.vMeanNoteTransition );
    assert_equal( 24, id.d4mean );
    assert_equal( 12, id.pMeanEndingNote );
    assert_nil( id.iconDynamicsHandle );
end

function testConstructFromStream()
--    fail();
end

function testGetterAndSetterLength()
    local id = luavsq.ID.new( 0 );
    local expected = 997586;
    assert_not_equal( expected, id:getLength() );
    id:setLength( expected );
    assert_equal( expected, id:getLength() );
end

function testClone()
    local id = luavsq.ID.new( 0 );
    id.value = 1;
    id.type = luavsq.IDType.Note;
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
    assert_nil( id.iconHandle );
    assert_nil( id.lyricHandle );
    assert_nil( id.vibratoHandle );
    assert_nil( id.noteHeadHandle );
    assert_nil( id.iconDynamicsHandle );

    local copy = id:clone();
    assert_equal( 1, copy.value );
    assert_equal( luavsq.IDType.Note, copy.type );
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

    local iconHandle = luavsq.IconHandle.new();
    iconHandle.caption = "foo";
    id.iconHandle = iconHandle;
    local lyricHandle = luavsq.LyricHandle.new();
    lyricHandle.index = 102;
    id.lyricHandle = lyricHandle;
    local vibratoHandle = luavsq.VibratoHandle.new();
    vibratoHandle.iconID = "aho";
    id.vibratoHandle = vibratoHandle;
    local noteHeadHandle = luavsq.NoteHeadHandle.new();
    noteHeadHandle.ids = "baka";
    id.noteHeadHandle = noteHeadHandle;
    local iconDynamicsHandle = luavsq.IconDynamicsHandle.new();
    iconDynamicsHandle:setStartDyn( 183635 );
    id.iconDynamicsHandle = iconDynamicsHandle;

    copy = id:clone();
    assert_equal( "foo", copy.iconHandle.caption );
    assert_equal( 102, copy.lyricHandle.index );
    assert_equal( "aho", copy.vibratoHandle.iconID );
    assert_equal( "baka", copy.noteHeadHandle.ids );
    assert_equal( 183635, copy.iconDynamicsHandle:getStartDyn() );
end
