require( "lunit" );
dofile( "../Track.NoteEventIterator.lua" );
dofile( "../EventList.lua" );
dofile( "../Event.lua" );
dofile( "../Id.lua" );
dofile( "../IdTypeEnum.lua" );
module( "Track.NoteEventIteratorTest", package.seeall, lunit.testcase );

function test()
    local list = luavsq.EventList.new();
    local a = luavsq.Event.new( 1920, luavsq.Id.new( 0 ) );
    a.id.type = luavsq.IdTypeEnum.Aicon;
    local idA = list:add( a, 1 );

    -- note イベントがひとつも無いので、最初から hasNext が false を返す
    local iterator = luavsq.Track.NoteEventIterator.new( list );
    assert_false( iterator:hasNext() );

    -- note イベントをひとつ足してテスト
    local b = luavsq.Event.new( 480, luavsq.Id.new( 0 ) );
    b.id.type = luavsq.IdTypeEnum.Anote;
    local idB = list:add( b, 2 );
    iterator = luavsq.Track.NoteEventIterator.new( list );
    assert_true( iterator:hasNext() );
    local event = iterator:next();
    assert_equal( 480, event.clock );
    assert_equal( 2, event.internalId );
    assert_equal( luavsq.IdTypeEnum.Anote, event.id.type );
    assert_false( iterator:hasNext() );

    -- remove 後の残っているイベントをチェック
    local c = luavsq.Event.new( 2000, luavsq.Id.new( 0 ) );
    c.id.type = luavsq.IdTypeEnum.Anote;
    list:add( c, 3 );
    iterator = luavsq.Track.NoteEventIterator.new( list );
    iterator:next(); --clock=480のを取得
    iterator:remove();--clock=480のを削除
    -- ここに来た段階で、clock=2000のが残っているはず
    assert_true( iterator:hasNext() );
    iterator:next();
    iterator:remove();
    assert_false( iterator:hasNext() );
    assert_equal( 1, list:size() );
    assert_equal( 1920, list:get( 0 ).clock );
    assert_equal( luavsq.IdTypeEnum.Aicon, list:get( 0 ).id.type );
end
