dofile( "./test_bootstrap.lua" );
module( "enhanced", package.seeall, lunit.testcase );

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

---
-- 歌詞ハンドルの読み込みテスト
-- EOFで読み込みが終了する場合
function testConstructLyricFromTextStreamStopWithEOF()
    local stream = getLyricStream();
    local lastLine = {};
    lastLine.value = "";
    local index = 100;

    local handle = luavsq.Handle.new( stream, index, lastLine );
    assert_equal( luavsq.HandleType.Lyric, handle._type );
    assert_equal( index, handle.index );
    assert_equal( 2, #handle.lyrics );

    local lyric1 = handle.lyrics[1];
    assert_equal( "あ", lyric1.phrase );
    assert_equal( "a", lyric1:getPhoneticSymbol() );
    assert_equal( 0.4, lyric1.lengthRatio );
    assert_equal( "0", lyric1:getConsonantAdjustment() );
    assert_true( lyric1.isProtected );

    local lyric2 = handle.lyrics[2];
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
    assert_equal( luavsq.HandleType.Lyric, handle._type );
    assert_equal( index, handle.index );
    assert_equal( 1, #handle.lyrics );

    assert_not_nil( handle.rateBP );
    assert_equal( 0, handle.rateBP:size() );
    assert_not_nil( handle.depthBP );
    assert_equal( 0, handle.depthBP:size() );
    assert_not_nil( handle.dynBP );
    assert_equal( 0, handle.dynBP:size() );

    local lyric = handle.lyrics[1];
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

    assert_equal( luavsq.HandleType.Vibrato, handle._type );
    assert_equal( "$04040004", handle.iconId );
    assert_equal( "normal-da-yo", handle.ids );
    assert_equal( "キャプションです=あ", handle.caption );
    assert_equal( 5, handle.original );
    assert_equal( 120, handle:getLength() );
    assert_equal( 64, handle.startDepth );
    assert_equal( "0.5=64,0.75=32,1=0", handle.depthBP:getData() );
    assert_equal( 64, handle.startRate );
    assert_equal( "0.5=64,0.75=32,1=0", handle.rateBP:getData() );

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

    assert_not_nil( handle.rateBP );
    assert_equal( 0, handle.rateBP:size() );
    assert_not_nil( handle.depthBP );
    assert_equal( 0, handle.depthBP:size() );
end

function testConstructSingerFromTextStream()
    local stream = getSingerStream();
    local index = 101;
    local lastLine = { ["value"] = "" };
    local handle = luavsq.Handle.new( stream, index, lastLine );
    assert_equal( index, handle.index );
    assert_equal( luavsq.HandleType.Singer, handle._type );
    assert_equal( "$07010002", handle.iconId );
    assert_equal( "Miku3=God", handle.ids );
    assert_equal( 2, handle.original );
    assert_equal( "", handle.caption );
    assert_equal( 1, handle:getLength() );
    assert_equal( 1, handle.language );
    assert_equal( 2, handle.program );
end

function testConstructAttackFromTextStream()
    local stream = getAttackStream();
    local lastLine = { ["value"] = "" };
    local index = 204;
    local handle = luavsq.Handle.new( stream, index, lastLine );
    assert_equal( luavsq.HandleType.NoteHead, handle._type );
    assert_equal( index, handle.index );
    assert_equal( "$01010002", handle.iconId );
    assert_equal( "accent", handle.ids );
    assert_equal( 2, handle.original );
    assert_equal( "Accent", handle.caption );
    assert_equal( 120, handle:getLength() );
    assert_equal( 64, handle.duration );
    assert_equal( 63, handle.depth );
end

function testConstructCrescendFromTextStream()
    local stream = getCrescendoStream();
    local lastLine = { ["value"] = "" };
    local index = 204;
    local handle = luavsq.Handle.new( stream, index, lastLine );
    assert_equal( index, handle.index );
    assert_equal( luavsq.HandleType.Dynamics, handle._type );
    assert_equal( "$05020001", handle.iconId );
    assert_equal( "Crescendo", handle.ids );
    assert_equal( 4, handle.original );
    assert_equal( "Zero Crescendo Curve", handle.caption );
    assert_equal( 960, handle:getLength() );
    assert_equal( 2, handle.startDyn );
    assert_equal( 38, handle.endDyn );
    assert_equal( "0.5=11", handle.dynBP:getData() );
end

function testGetterAndSetterLength()
    local handle = luavsq.Handle.new();
    local expected = 847;
    assert_not_equal( expected, handle:getLength() );
    handle:setLength( expected );
    assert_equal( expected, handle:getLength() );
end

function testCastToLyricHandle()
    local stream = getLyricStream();
    local lastLine = { ["value"] = "" };
    local index = 3847;
    local handle = luavsq.Handle.new( stream, index, lastLine );
    local casted = handle:castToLyricHandle();
    assert_equal( index, casted.index );
    assert_equal( #handle.lyrics, #casted.lyrics );
    local i;
    for i = 1, #handle.lyrics, 1 do
        assert_equal( handle.lyrics[i]:toString(), casted.lyrics[i]:toString() );
    end
end

function testCastToVibratoHandle()
    local stream = getVibratoStream();
    local lastLine = { ["value"] = "" };
    local index = 347;
    local handle = luavsq.Handle.new( stream, index, lastLine );

    local casted = handle:castToVibratoHandle();
    assert_equal( index, casted.index );
    assert_equal( "キャプションです=あ", casted:getCaption() );
    assert_equal( "0.5=64,0.75=32,1=0", casted:getDepthBP():getData() );
    assert_equal( "$04040004", casted.iconId );
    assert_equal( "normal-da-yo", casted.ids );
    assert_equal( 120, casted:getLength() );
    assert_equal( 5, casted.original );
    assert_equal( "0.5=64,0.75=32,1=0", casted:getRateBP():getData() );
    assert_equal( 64, casted:getStartDepth() );
    assert_equal( 64, casted:getStartRate() );
end

function testCastToIconHandle()
    local stream = getSingerStream();
    local lastLine = { ["value"] = "" };
    local index = 9476;
    local handle = luavsq.Handle.new( stream, index, lastLine );

    local casted = handle:castToIconHandle();
    assert_equal( index, casted.index );
    assert_equal( "", casted.caption );
    assert_equal( "$07010002", casted.iconId );
    assert_equal( "Miku3=God", casted.ids );
    assert_equal( 1, casted.language );
    assert_equal( 1, casted:getLength() );
    assert_equal( 2, casted.original );
    assert_equal( 2, casted.program );
end

function testCastToNoteHeadHandle()
    local stream = getAttackStream();
    local lastLine = { ["value"] = "" };
    local index = 70375;
    local handle = luavsq.Handle.new( stream, index, lastLine );
    local casted = handle:castToNoteHeadHandle();
    assert_equal( "Accent", casted:getCaption() );
    assert_equal( 63, casted:getDepth() );
    assert_equal( 64, casted:getDuration() );
    assert_equal( "$01010002", casted.iconId );
    assert_equal( "accent", casted.ids );
    assert_equal( 120, casted:getLength() );
    assert_equal( 2, casted.original );
end

function testCastToIconDynamicsHandle()
    local stream = getCrescendoStream();
    local lastLine = { ["value"] = "" };
    local index = 1548;
    local handle = luavsq.Handle.new( stream, index, lastLine );
    local casted = handle:castToIconDynamicsHandle();
    assert_equal( "Crescendo", casted.ids );
    assert_equal( "$05020001", casted.iconId );
    assert_equal( 4, casted.original );
    assert_equal( "Zero Crescendo Curve", casted:getCaption() );
    assert_equal( "0.5=11", casted.dynBP:getData() );
    assert_equal( 38, casted.endDyn );
    assert_equal( 960, casted:getLength() );
    assert_equal( 2, casted.startDyn );
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

    handle.rateBP = luavsq.VibratoBPList.new( {}, {} );
    handle.depthBP = luavsq.VibratoBPList.new( {}, {} );
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
    handle.dynBP = luavsq.VibratoBPList.new( { 0.4, 0.8 }, { 1, 2 } );
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
    handle.dynBP = luavsq.VibratoBPList.new( {}, {} );
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
