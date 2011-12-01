require( "lunit" );
dofile( "../Id.lua" );
dofile( "../IdTypeEnum.lua" );
dofile( "../ArticulationTypeEnum.lua" );
dofile( "../Lyric.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../Util.lua" );
dofile( "../Handle.lua" );
dofile( "../HandleTypeEnum.lua" );
module( "IdTest", package.seeall, lunit.testcase );

function testConstructWithValue()
    local id = luavsq.Id.new( 1 );
    assert_equal( 1, id.value );
    assert_equal( 0, id.singerHandleIndex );
    assert_equal( 0, id.lyricHandleIndex );
    assert_equal( 0, id.vibratoHandleIndex );
    assert_equal( 0, id.noteHeadHandleIndex );
    assert_equal( luavsq.IdTypeEnum.Note, id.type );
    assert_nil( id.singerHandle );
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
    local id = luavsq.Id.new( 0 );
    local expected = 997586;
    assert_not_equal( expected, id:getLength() );
    id:setLength( expected );
    assert_equal( expected, id:getLength() );
end

function testClone()
    local id = luavsq.Id.new( 0 );
    id.value = 1;
    id.type = luavsq.IdTypeEnum.Note;
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
    assert_nil( id.lyricHandle );
    assert_nil( id.vibratoHandle );
    assert_nil( id.noteHeadHandle );
    assert_nil( id.iconDynamicsHandle );

    local copy = id:clone();
    assert_equal( 1, copy.value );
    assert_equal( luavsq.IdTypeEnum.Note, copy.type );
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
    iconHandle.caption = "foo";
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
    assert_equal( "foo", copy.singerHandle.caption );
    assert_equal( 102, copy.lyricHandle.index );
    assert_equal( "aho", copy.vibratoHandle.iconId );
    assert_equal( "baka", copy.noteHeadHandle.ids );
    assert_equal( 183635, copy.iconDynamicsHandle:getStartDyn() );
end

function testIsEOS()
    local id = luavsq.Id.new();
    assert_true( id:isEOS() );
    assert_true( luavsq.Id.getEOS():isEOS() );
    assert_false( luavsq.Id.new( 0 ):isEOS() );
end
