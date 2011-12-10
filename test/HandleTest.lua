require( "lunit" );
dofile( "../Handle.lua" );
dofile( "../TextStream.lua" );
dofile( "../HandleTypeEnum.lua" );
dofile( "../Lyric.lua" );
dofile( "../Util.lua" );
dofile( "../VibratoBPList.lua" );
dofile( "../VibratoBP.lua" );
dofile( "../ArticulationTypeEnum.lua" );
dofile( "../PhoneticSymbol.lua" );
module( "HandleTest", package.seeall, lunit.testcase );

function getLyricStream()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "L0=あ,a,0.4,0,1" );
    stream:writeLine( "L1=は,h a,0.6,64,0,0" );
    stream:setPointer( -1 );
    return stream;
end

function getVibratoStream()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "IconID=$04040004" );
    stream:writeLine( "IDS=normal-da-yo" );
    stream:writeLine( "Caption=キャプションです=あ" );
    stream:writeLine( "Original=5" );
    stream:writeLine( "Length=120" );
    stream:writeLine( "StartDepth=64" );
    stream:writeLine( "DepthBPNum=3" );
    stream:writeLine( "DepthBPX=0.500000,0.750000,1.000000" );
    stream:writeLine( "DepthBPY=64,32,0" );
    stream:writeLine( "StartRate=64" );
    stream:writeLine( "RateBPNum=3" );
    stream:writeLine( "RateBPX=0.500000,0.750000,1.000000" );
    stream:writeLine( "RateBPY=64,32,0" );
    stream:writeLine( "[h#0002]" );
    stream:setPointer( -1 );
    return stream;
end

function getSingerStream()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "IconID=$07010002" );
    stream:writeLine( "IDS=Miku3=God" );
    stream:writeLine( "Original=2" );
    stream:writeLine( "Caption=" );
    stream:writeLine( "Length=1" );
    stream:writeLine( "Language=1" );
    stream:writeLine( "Program=2" );
    stream:setPointer( -1 );
    return stream;
end

function getAttackStream()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "IconID=$01010002" );
    stream:writeLine( "IDS=accent" );
    stream:writeLine( "Original=2" );
    stream:writeLine( "Caption=Accent" );
    stream:writeLine( "Length=120" );
    stream:writeLine( "Duration=64" );
    stream:writeLine( "Depth=63" );
    stream:setPointer( -1 );
    return stream;
end

function getCrescendoStream()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "IconID=$05020001" );
    stream:writeLine( "IDS=Crescendo" );
    stream:writeLine( "Original=4" );
    stream:writeLine( "Caption=Zero Crescendo Curve" );
    stream:writeLine( "Length=960" );
    stream:writeLine( "StartDyn=2" );
    stream:writeLine( "EndDyn=38" );
    stream:writeLine( "DynBPNum=1" );
    stream:writeLine( "DynBPX=0.5" );
    stream:writeLine( "DynBPY=11" );
    stream:setPointer( -1 );
    return stream;
end

function testConstructIconDynamicsHandle()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    assert_equal( luavsq.ArticulationTypeEnum.DYNAFF, handle:getArticulation() );
end

function testConstructNoteHeadHandle()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.NoteHead );
    assert_equal( luavsq.ArticulationTypeEnum.NOTE_ATTACK, handle:getArticulation() );
end

function testIsDynaffType()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    handle.iconId = nil;
    assert_false( handle:isDynaffType() );
    handle.iconId = "$05000000";
    assert_false( handle:isDynaffType() );
    handle.iconId = "$05010000";
    assert_true( handle:isDynaffType() );
end

function testIsCrescendType()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    handle.iconId = nil;
    assert_false( handle:isCrescendType() );
    handle.iconId = "$05000000";
    assert_false( handle:isCrescendType() );
    handle.iconId = "$05020000";
    assert_true( handle:isCrescendType() );
end

function testIsDecrescendType()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    handle.iconId = nil;
    assert_false( handle:isDecrescendType() );
    handle.iconId = "$05000000";
    assert_false( handle:isDecrescendType() );
    handle.iconId = "$05030000";
    assert_true( handle:isDecrescendType() );
end

function __testClone()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    handle.iconId = "$05010000";
    handle.ids = "foo";
    handle.original = 1;
    handle.caption = "bar";
    handle.startDyn = 2;
    handle.endDyn = 3;
    handle.length = 4;
    handle.dynBP = nil;
    local copy = handle:clone();
    assert_equal( "$05010000", copy.iconId );
    assert_equal( "foo", copy.ids );
    assert_equal( 1, copy.original );
    assert_equal( "bar", copy.caption );
    assert_equal( 2, copy:getStartDyn() );
    assert_equal( 3, copy:getEndDyn() );
    assert_equal( 4, copy:getLength() );
    assert_nil( copy:getDynBP() );

    local dynBP = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 64 } );
    handle:setDynBP( dynBP );
    copy = handle:clone();
    assert_equal( "0=1,1=64", copy:getDynBP():getData() );
end

function testGetterAndSetterCaption()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    handle:setCaption( "foo" );
    assert_equal( "foo", handle:getCaption() );
end

function testGetterAndSetterStartDyn()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    local expected = 100;
    assert_not_equal( expected, handle:getStartDyn() );
    handle:setStartDyn( expected );
    assert_equal( expected, handle:getStartDyn() );
end

function testGetterAndSetterEndDyn()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    local expected = 100;
    assert_not_equal( expected, handle:getEndDyn() );
    handle:setEndDyn( expected );
    assert_equal( expected, handle:getEndDyn() );
end

function testGetterAndSetterDynBP()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    local dynBP = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 2 } );
    handle:setDynBP( nil );
    assert_nil( handle:getDynBP() );
    handle:setDynBP( dynBP );
    assert_equal( "0=1,1=2", handle:getDynBP():getData() );
end

---
-- 歌詞ハンドルの読み込みテスト
-- EOFで読み込みが終了する場合
function testConstructLyricFromTextStreamStopWithEOF()
    local stream = getLyricStream();
    local lastLine = {};
    lastLine.value = "";
    local index = 100;

    local handle = luavsq.Handle.new( stream, index, lastLine );
    assert_equal( luavsq.HandleTypeEnum.Lyric, handle:getHandleType() );
    assert_equal( index, handle.index );
    assert_equal( 2, handle:getLyricCount() );

    local lyric1 = handle:getLyricAt( 0 );
    assert_equal( "あ", lyric1.phrase );
    assert_equal( "a", lyric1:getPhoneticSymbol() );
    assert_equal( 0.4, lyric1.lengthRatio );
    assert_equal( "0", lyric1:getConsonantAdjustment() );
    assert_true( lyric1.isProtected );

    local lyric2 = handle:getLyricAt( 1 );
    assert_equal( "は", lyric2.phrase );
    assert_equal( "h a", lyric2:getPhoneticSymbol() );
    assert_equal( 0.6, lyric2.lengthRatio );
    assert_equal( "64 0", lyric2:getConsonantAdjustment() );
    assert_false( lyric2.isProtected );
end

---
-- 歌詞ハンドルの読み込みテスト
-- 次の歌詞ハンドルの先頭に到達して読み込みが終了する場合
function testConstructLyricFromTextStreamStopWithNextHandle()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "L0=あ,a,0.4,0,1" );
    stream:writeLine( "[h#0002]" );
    stream:setPointer( -1 );
    local lastLine = {};
    lastLine.value = "";
    local index = 100;

    local handle = luavsq.Handle.new( stream, index, lastLine );
    assert_equal( luavsq.HandleTypeEnum.Lyric, handle:getHandleType() );
    assert_equal( index, handle.index );
    assert_equal( 1, handle:getLyricCount() );

    assert_not_nil( handle:getRateBP() );
    assert_equal( 0, handle:getRateBP():size() );
    assert_not_nil( handle:getDepthBP() );
    assert_equal( 0, handle:getDepthBP():size() );
    assert_not_nil( handle:getDynBP() );
    assert_equal( 0, handle:getDynBP():size() );

    local lyric = handle:getLyricAt( 0 );
    assert_equal( "あ", lyric.phrase );
    assert_equal( "a", lyric:getPhoneticSymbol() );
    assert_equal( 0.4, lyric.lengthRatio );
    assert_equal( "0", lyric:getConsonantAdjustment() );
    assert_true( lyric.isProtected );

    assert_equal( "[h#0002]", lastLine.value );
end

function testConstructVibratoFromTextStream()
    local stream = getVibratoStream();
    local lastLine = { ["value"] = "" };
    local index = 101;
    local handle = luavsq.Handle.new( stream, index, lastLine );

    assert_equal( luavsq.HandleTypeEnum.Vibrato, handle:getHandleType() );
    assert_equal( "$04040004", handle.iconId );
    assert_equal( "normal-da-yo", handle.ids );
    assert_equal( "キャプションです=あ", handle:getCaption() );
    assert_equal( 5, handle.original );
    assert_equal( 120, handle:getLength() );
    assert_equal( 64, handle:getStartDepth() );
    assert_equal( "0.5=64,0.75=32,1=0", handle:getDepthBP():getData() );
    assert_equal( 64, handle:getStartRate() );
    assert_equal( "0.5=64,0.75=32,1=0", handle:getRateBP():getData() );

    assert_equal( "[h#0002]", lastLine.value );
end

function testConstructVibratoFromTextStreamWithoutBP()
    local stream = luavsq.TextStream.new();
    stream:writeLine( "IconID=$04040004" );
    stream:writeLine( "IDS=normal-da-yo" );
    stream:writeLine( "Caption=キャプションです=あ" );
    stream:writeLine( "Original=5" );
    stream:writeLine( "Length=120" );
    stream:writeLine( "StartDepth=64" );
    stream:writeLine( "StartRate=64" );
    stream:writeLine( "[h#0002]" );
    stream:setPointer( -1 );

    local lastLine = { ["value"] = "" };
    local index = 101;
    local handle = luavsq.Handle.new( stream, index, lastLine );

    assert_not_nil( handle:getRateBP() );
    assert_equal( 0, handle:getRateBP():size() );
    assert_not_nil( handle:getDepthBP() );
    assert_equal( 0, handle:getDepthBP():size() );
end

function testConstructSingerFromTextStream()
    local stream = getSingerStream();
    local index = 101;
    local lastLine = { ["value"] = "" };
    local handle = luavsq.Handle.new( stream, index, lastLine );
    assert_equal( index, handle.index );
    assert_equal( luavsq.HandleTypeEnum.Singer, handle:getHandleType() );
    assert_equal( "$07010002", handle.iconId );
    assert_equal( "Miku3=God", handle.ids );
    assert_equal( 2, handle.original );
    assert_equal( "", handle:getCaption() );
    assert_equal( 1, handle:getLength() );
    assert_equal( 1, handle.language );
    assert_equal( 2, handle.program );
end

function testConstructAttackFromTextStream()
    local stream = getAttackStream();
    local lastLine = { ["value"] = "" };
    local index = 204;
    local handle = luavsq.Handle.new( stream, index, lastLine );
    assert_equal( luavsq.HandleTypeEnum.NoteHead, handle:getHandleType() );
    assert_equal( index, handle.index );
    assert_equal( "$01010002", handle.iconId );
    assert_equal( "accent", handle.ids );
    assert_equal( 2, handle.original );
    assert_equal( "Accent", handle:getCaption() );
    assert_equal( 120, handle:getLength() );
    assert_equal( 64, handle:getDuration() );
    assert_equal( 63, handle:getDepth() );
end

function testConstructCrescendFromTextStream()
    local stream = getCrescendoStream();
    local lastLine = { ["value"] = "" };
    local index = 204;
    local handle = luavsq.Handle.new( stream, index, lastLine );
    assert_equal( index, handle.index );
    assert_equal( luavsq.HandleTypeEnum.Dynamics, handle:getHandleType() );
    assert_equal( "$05020001", handle.iconId );
    assert_equal( "Crescendo", handle.ids );
    assert_equal( 4, handle.original );
    assert_equal( "Zero Crescendo Curve", handle:getCaption() );
    assert_equal( 960, handle:getLength() );
    assert_equal( 2, handle:getStartDyn() );
    assert_equal( 38, handle:getEndDyn() );
    assert_equal( "0.5=11", handle:getDynBP():getData() );
end

function testGetterAndSetterLength()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    local expected = 847;
    assert_not_equal( expected, handle:getLength() );
    handle:setLength( expected );
    assert_equal( expected, handle:getLength() );
end

function testWrite()
    local stream = getLyricStream();
    local handle = luavsq.Handle.new( stream, 1, {} );
    local dest = luavsq.TextStream.new();
    handle:write( dest );
    dest:setPointer( -1 );
    assert_equal( "[h#0001]", dest:readLine() );
    assert_equal( "L0=\"あ\",\"a\",0.4,0,1", dest:readLine() );
    assert_equal( "L1=\"は\",\"h a\",0.6,64,0,0", dest:readLine() );
end

function testLyricToString()
    local stream = getLyricStream();
    local handle = luavsq.Handle.new( stream, 1, {} );
    local expected =
        "[h#0001]\n" ..
        "L0=\"あ\",\"a\",0.4,0,1\n" ..
        "L1=\"は\",\"h a\",0.6,64,0,0";
    assert_equal( expected, handle:toString() );
end

function testVibratoToString()
    local stream = getVibratoStream();
    local handle = luavsq.Handle.new( stream, 1, {} );
    local expected =
        "[h#0001]\n" ..
        "IconID=$04040004\n" ..
        "IDS=normal-da-yo\n" ..
        "Original=5\n" ..
        "Caption=キャプションです=あ\n" ..
        "Length=120\n" ..
        "StartDepth=64\n" ..
        "DepthBPNum=3\n" ..
        "DepthBPX=0.500000,0.750000,1.000000\n" ..
        "DepthBPY=64,32,0\n" ..
        "StartRate=64\n" ..
        "RateBPNum=3\n" ..
        "RateBPX=0.500000,0.750000,1.000000\n" ..
        "RateBPY=64,32,0";
    assert_equal( expected, handle:toString() );

    handle:setRateBP( luavsq.VibratoBPList.new( {}, {} ) );
    handle:setDepthBP( luavsq.VibratoBPList.new( {}, {} ) );
    expected =
        "[h#0001]\n" ..
        "IconID=$04040004\n" ..
        "IDS=normal-da-yo\n" ..
        "Original=5\n" ..
        "Caption=キャプションです=あ\n" ..
        "Length=120\n" ..
        "StartDepth=64\n" ..
        "DepthBPNum=0\n" ..
        "StartRate=64\n" ..
        "RateBPNum=0";
    assert_equal( expected, handle:toString() );
end

function testSingerToString()
    local stream = getSingerStream();
    local handle = luavsq.Handle.new( stream, 2, {} );
    local expected =
        "[h#0002]\n" ..
        "IconID=$07010002\n" ..
        "IDS=Miku3=God\n" ..
        "Original=2\n" ..
        "Caption=\n" ..
        "Length=1\n" ..
        "Language=1\n" ..
        "Program=2";
    assert_equal( expected, handle:toString() );
end

function testAttackToString()
    local stream = getAttackStream();
    local handle = luavsq.Handle.new( stream, 3, {} );
    local expected =
        "[h#0003]\n" ..
        "IconID=$01010002\n" ..
        "IDS=accent\n" ..
        "Original=2\n" ..
        "Caption=Accent\n" ..
        "Length=120\n" ..
        "Duration=64\n" ..
        "Depth=63";
    assert_equal( expected, handle:toString() );
end

function testCrescendoToString()
    local stream = getCrescendoStream();
    local handle = luavsq.Handle.new( stream, 4, {} );
    local expected =
        "[h#0004]\n" ..
        "IconID=$05020001\n" ..
        "IDS=Crescendo\n" ..
        "Original=4\n" ..
        "Caption=Zero Crescendo Curve\n" ..
        "StartDyn=2\n" ..
        "EndDyn=38\n" ..
        "Length=960\n" ..
        "DynBPNum=1\n" ..
        "DynBPX=0.500000\n" ..
        "DynBPY=11";
    assert_equal( expected, handle:toString() );

    -- dynBPのデータ点が複数
    handle:setDynBP( luavsq.VibratoBPList.new( { 0.4, 0.8 }, { 1, 2 } ) );
    expected =
        "[h#0004]\n" ..
        "IconID=$05020001\n" ..
        "IDS=Crescendo\n" ..
        "Original=4\n" ..
        "Caption=Zero Crescendo Curve\n" ..
        "StartDyn=2\n" ..
        "EndDyn=38\n" ..
        "Length=960\n" ..
        "DynBPNum=2\n" ..
        "DynBPX=0.400000,0.800000\n" ..
        "DynBPY=1,2";
    assert_equal( expected, handle:toString() );

    -- dynBPのデータ点が 0 個
    handle:setDynBP( luavsq.VibratoBPList.new( {}, {} ) );
    expected =
        "[h#0004]\n" ..
        "IconID=$05020001\n" ..
        "IDS=Crescendo\n" ..
        "Original=4\n" ..
        "Caption=Zero Crescendo Curve\n" ..
        "StartDyn=2\n" ..
        "EndDyn=38\n" ..
        "Length=960\n" ..
        "DynBPNum=0";
    assert_equal( expected, handle:toString() );

    -- dynBPがnil
    handle.dynBP = nil;
    assert_equal( expected, handle:toString() );
end

function testGetHandleIndexFromString()
    assert_equal( 2, luavsq.Handle.getHandleIndexFromString( "h#0002" ) );
end

function testGetterAndSetterDepth()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.NoteHead );
    local expected = 1234;
    assert_not_equal( expected, handle:getDepth() );
    handle:setDepth( expected );
    assert_equal( expected, handle:getDepth() );
end

function testGetterAndSetterDuration()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.NoteHead );
    local expected = 947;
    assert_not_equal( expected, handle:getDuration() );
    handle:setDuration( expected );
    assert_equal( expected, handle:getDuration() );
end

function testGetDisplayString()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.NoteHead );
    handle.ids = "goo";
    handle:setCaption( "gle" );
    assert_equal( "google", handle:getDisplayString() );
end

function testGetterAndSetterRateBP()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    local rateBP = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 128 } );
    assert_not_equal( "0=1,1=128", handle:getRateBP():getData() );
    handle:setRateBP( rateBP );
    assert_equal( "0=1,1=128", handle:getRateBP():getData() );
end

function testGetterAndSetterDepthBP()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    local depthBP = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 128 } );
    assert_not_equal( "0=1,1=128", handle:getDepthBP():getData() );
    handle:setDepthBP( depthBP );
    assert_equal( "0=1,1=128", handle:getDepthBP():getData() );
end

function testGetterAndSetterStartRate()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    local expected = 12345;
    assert_not_equal( expected, handle:getStartRate() );
    handle:setStartRate( expected );
    assert_equal( expected, handle:getStartRate() );
end

function testGetterAndSetterStartDepth()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    local expected = 12345;
    assert_not_equal( expected, handle:getStartDepth() );
    handle:setStartDepth( expected );
    assert_equal( expected, handle:getStartDepth() );
end

function testGetterAndSetterLyric()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Lyric );
    handle:setLyricAt( 0, luavsq.Lyric.new( "は", "h a" ) );
    local lyric = luavsq.Lyric.new( "ら", "4 a" );
    handle:setLyricAt( 1, lyric );
    assert_equal( 2, handle:getLyricCount() );
    assert_true( handle:getLyricAt( 1 ):equals( lyric ) );
end

function testCloneIconDynamicsHandle()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Dynamics );
    handle.iconId = "$05010000";
    handle.ids = "foo";
    handle.original = 1;
    handle:setCaption( "bar" );
    handle:setStartDyn( 2 );
    handle:setEndDyn( 3 );
    handle:setLength( 4 );
    handle:setDynBP( nil );
    local copy = handle:clone();
    assert_equal( "$05010000", copy.iconId );
    assert_equal( "foo", copy.ids );
    assert_equal( 1, copy.original );
    assert_equal( "bar", copy:getCaption() );
    assert_equal( 2, copy:getStartDyn() );
    assert_equal( 3, copy:getEndDyn() );
    assert_equal( 4, copy:getLength() );
    assert_nil( copy:getDynBP() );

    local dynBP = luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 1, 64 } );
    handle:setDynBP( dynBP );
    copy = handle:clone();
    assert_equal( "0=1,1=64", copy:getDynBP():getData() );
end

function testCloneLyricHandle()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Lyric );
    handle:setLyricAt( 0, luavsq.Lyric.new( "ら", "4 a" ) );
    handle.index = 10;
    local copy = handle:clone();
    assert_equal( handle.index, copy.index );
    assert_true( handle:getLyricAt( 0 ):equals( copy:getLyricAt( 0 ) ) );
end

function testCloneNoteHeadHandle()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.NoteHead );
    handle.index = 1;
    handle.iconId = "$05010000";
    handle.ids = "dwango";
    handle.original = 2;
    handle:setCaption( "niwango" );
    handle:setLength( 3 );
    handle:setDuration( 4 );
    handle:setDepth( 5 );

    local copy = handle:clone();
    assert_equal( 1, copy.index );
    assert_equal( "$05010000", copy.iconId );
    assert_equal( "dwango", copy.ids );
    assert_equal( 2, copy.original );
    assert_equal( "niwango", copy:getCaption() );
    assert_equal( 3, copy:getLength() );
    assert_equal( 4, copy:getDuration() );
    assert_equal( 5, copy:getDepth() );
end

function testCloneVibratoHandle()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Vibrato );
    handle.index = 1;
    handle.iconId = "hahaha";
    handle.ids = "baka";
    handle.original = 2;
    handle:setCaption( "aho" );
    handle:setLength( 3 );
    handle:setStartDepth( 4 );
    handle:setDepthBP( luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 32, 56 } ) );
    handle:setStartRate( 5 );
    handle:setRateBP( luavsq.VibratoBPList.new( { 0.0, 1.0 }, { 64, 128 } ) );
    local copy = handle:clone();
    assert_equal( 1, copy.index );
    assert_equal( "hahaha", copy.iconId );
    assert_equal( "baka", copy.ids );
    assert_equal( 2, copy.original );
    assert_equal( "aho", copy:getCaption() );
    assert_equal( 3, copy:getLength() );
    assert_equal( 4, copy:getStartDepth() );
    assert_equal( "0=32,1=56", copy:getDepthBP():getData() );
    assert_equal( 5, copy:getStartRate() );
    assert_equal( "0=64,1=128", copy:getRateBP():getData() );
end

function testCloneSingerHandle()
    local handle = luavsq.Handle.new( luavsq.HandleTypeEnum.Singer );
    handle:setCaption( "bar" );
    handle.iconId = "$07010001";
    handle.ids = "foo";
    handle.index = 1;
    handle.length = 2;
    handle.original = 3;
    handle.program = 4;
    handle.language= 5;

    local copy = handle:clone();
    assert_equal( handle:getCaption(), copy:getCaption() );
    assert_equal( handle.iconId, copy.iconId );
    assert_equal( handle.ids, copy.ids );
    assert_equal( handle.index, copy.index );
    assert_equal( handle.language, copy.language );
    assert_equal( handle:getLength(), copy:getLength() );
    assert_equal( handle.original, copy.original );
    assert_equal( handle.program, copy.program );
end

--[[
function testToDo()
    fail( "sizeメソッドの名前を変える" );
end
]]
