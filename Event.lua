--[[
  Event.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local string = string;
local tonumber = tonumber;
local type = type;
local assert = assert;

module( "luavsq" );

---
-- VSQ ファイルのメタテキスト内に記述されるイベントを表すクラス
-- @class table
-- @name Event
Event = {};

--
-- 初期化を行う
-- @return (Event)
function Event.new( ... )
    local arguments = { ... };
    local this = {};

    ---
    -- イベントに付けるタグ文字列
    -- @var string
    this.tag = "";

    ---
    -- 内部で使用するオブジェクト固有の ID
    -- @var integer
    this.id = -1;

    ---
    -- Tick 単位の時刻
    -- @var integer
    this.clock = 0;

    ---
    -- VSQ メタテキストに出力されるこのオブジェクトの ID
    -- @var integer
    this.index = -1;

    this._singerHandleIndex = 0;
    this._lyricHandleIndex = 0;
    this._vibratoHandleIndex = 0;
    this._noteHeadHandleIndex = 0;

    ---
    -- イベントの種類
    -- @var EventTypeEnum
    this.type = EventTypeEnum.Note;

    ---
    -- 歌手ハンドル
    -- @var Handle
    this.singerHandle = nil;

    this._length = 0;

    ---
    -- ノート番号
    -- @var integer
    this.note = 0;

    ---
    -- ベロシティ
    -- @var integer
    this.dynamics = 0;

    ---
    -- ベンド深さ
    -- @var integer
    this.pmBendDepth = 0;

    ---
    -- ベンド長さ
    -- @var integer
    this.pmBendLength = 0;

    ---
    -- ポルタメント
    -- @var integer
    this.pmbPortamentoUse = 0;

    ---
    -- ディケイ
    -- @var integer
    this.demDecGainRate = 0;

    ---
    -- アクセント
    -- @var integer
    this.demAccent = 0;

    ---
    -- 歌詞ハンドル
    -- @var Handle
    this.lyricHandle = nil;

    ---
    -- ビブラートハンドル
    -- @var Handle
    this.vibratoHandle = nil;

    ---
    -- イベント先頭から測った、ビブラートの開始位置(Tick 単位)
    -- @var integer
    this.vibratoDelay = 0;

    ---
    -- アタックハンドル
    -- @var Handle
    this.noteHeadHandle = nil;

    ---
    -- @var integer
    this.pMeanOnsetFirstNote = 10;

    ---
    -- @var integer
    this.vMeanNoteTransition = 12;

    ---
    -- @var integer
    this.d4mean = 24;

    ---
    -- @var integer
    this.pMeanEndingNote = 12;

    ---
    -- 強弱記号ハンドル
    -- @var Handle
    this.iconDynamicsHandle = nil;

    ---
    -- @var UstEvent
    -- @access private
    this.ustEvent = nil;

    ---
    -- 初期化を行う
    -- @param line (string) VSQ メタテキスト中の [EventList] セクション内のイベント宣言文字列(ex."480=ID#0001")
    -- @return (Event)
    -- @name new<!--2-->
    -- @access static ctor
    function this:_init_1( line )
        local spl = Util.split( line, '=' );
        self.clock = tonumber( spl[1], 10 );
        if( spl[2] == "EOS" )then
            self.index = -1;
        end
    end

    ---
    -- 初期化を行う。この初期化メソッドは末尾のイベントリストを表すインスタンスを初期化する
    -- @return (Event)
    -- @name new<!--1-->
    -- @access static ctor
    function this:_init_0()
        self.clock = 0;
        self.index = -1;
        self.id = 0;
    end

    ---
    -- 初期化を行う
    -- @param clock (integer) Tick 単位の時刻
    -- @param eventType (EventTypeEnum) イベントの種類
    -- @return (Event)
    -- @name new<!--3-->
    -- @access static ctor
    function this:_init_2( clock, eventType )
        self.clock = clock;
        self.type = eventType;
        if( eventType == EventTypeEnum.Singer )then
            self.singerHandle = Handle.new( HandleTypeEnum.Singer );
        elseif( eventType == EventTypeEnum.Anote )then
            self.lyricHandle = Handle.new( HandleTypeEnum.Lyric );
            self.lyricHandle:setLyricAt( 0, Lyric.new( "a", "a" ) );
        end
        self.id = 0;
    end

    ---
    -- 長さを取得する
    -- @return (integer) 長さ
    -- @name getLength
    function this:getLength()
        return self._length;
    end

    ---
    -- 長さを設定する
    -- @param value (integer) 長さ
    -- @name setLength
    function this:setLength( value )
        self._length = value;
    end

    --[[
        -- @param item [VsqEvent]
        -- @return [bool]
        function this:equals( item )
            if( self.clock ~= item.clock )then
                return false;
            end
            if( self.type ~= item.type )then
                return false;
            end
            if( self.type == idType.Anote )then
                if( self.note ~= item.note )then
                    return false;
                end
                if( self:getLength() ~= item:getLength() )then
                    return false;
                end
                if( self.d4mean ~= item.d4mean )then
                    return false;
                end
                if( self.demAccent ~= item.demAccent )then
                    return false;
                end
                if( self.demDecGainRate ~= item.demDecGainRate )then
                    return false;
                end
                if( self.dynamics ~= item.dynamics )then
                    return false;
                end
                if( self.lyricHandle ~= nil and item.lyricHandle ~= nil )then
                    return false;
                end
                if( self.lyricHandle ~= nil and item.lyricHandle == nil )then
                    return false;
                end
                if( self.lyricHandle ~= nil and item.lyricHandle ~= nil )then
                    if( self.lyricHandle:size() ~= item.lyricHandle:size() )then
                        return false;
                    end
                    local count = self.lyricHandle:size();
                    local k;
                    for k = 0, count - 1, 1 do
                        if( not self.lyricHandle:getLyricAt( k ):equalsForSynth( item.lyricHandle:getLyricAt( k ) ) )then
                            return false;
                        end
                    end
                end
                if( self.noteHeadHandle == nil and item.noteHeadHandle ~= nil )then
                    return false;
                end
                if( self.noteHeadHandle ~= nil and item.noteHeadHandle == nil )then
                    return false;
                end
                if( self.noteHeadHandle ~= nil and item.noteHeadHandle ~= nil )then
                    if( self.NoteHeadHandle.iconId ~= item.noteHeadHandle.iconId )then
                        return false;
                    end
                    if( self.noteHeadHandle:getDepth() ~= item.noteHeadHandle:getDepth() )then
                        return false;
                    end
                    if( self.noteHeadHandle:getDuration() ~= item.noteHeadHandle:getDuration() )then
                        return false;
                    end
                    if( self.noteHeadHandle:getLength() ~= item.noteHeadHandle:getLength() )then
                        return false;
                    end
                end
                if( self.pmBendDepth ~= item.pmBendDepth )then
                    return false;
                end
                if( self.pmBendLength ~= item.pmBendLength )then
                    return false;
                end
                if( self.pmbPortamentoUse ~= item.pmbPortamentoUse )then
                    return false;
                end
                if( self.pMeanEndingNote ~= item.pMeanEndingNote )then
                    return false;
                end
                if( self.pMeanOnsetFirstNote ~= item.pMeanOnsetFirstNote )then
                    return false;
                end
                local hVibratoThis = self.vibratoHandle;
                local hVibratoItem = item.vibratoHandle;
                if( hVibratoThis == nil and hVibratoItem ~= nil )then
                    return false;
                end
                if( hVibratoThis ~= nil and hVibratoItem == nil )then
                    return false;
                end
                if( hVibratoThis ~= nil and hVibratoItem ~= nil )then
                    if( self.vibratoDelay ~= item.vibratoDelay )then
                        return false;
                    end
                    if( hVibratoThis.iconId ~= hVibratoItem.iconId )then
                        return false;
                    end
                    if( hVibratoThis:getStartDepth() ~= hVibratoItem:getStartDepth() )then
                        return false;
                    end
                    if( hVibratoThis:getStartRate() ~= hVibratoItem:getStartRate() )then
                        return false;
                    end
                    local vibRateThis = hVibratoThis:getRateBP();
                    local vibRateItem = hVibratoItem:getRateBP();
                    if( vibRateThis == nil and vibRateItem ~= nil )then
                        return false;
                    end
                    if( vibRateThis ~= nil and vibRateItem == nil )then
                        return false;
                    end
                    if( vibRateThis ~= nil and vibRateItem ~= nil )then
                        local numRateCount = vibRateThis:size();
                        if( numRateCount ~= vibRateItem:size() )then
                            return false;
                        end
                        local k;
                        for k = 0, numRateCount - 1, 1 do
                            local pThis = vibRateThis:getElement( k );
                            local pItem = vibRateItem:getElement( k );
                            if( pThis.x ~= pItem.x )then
                                return false;
                            end
                            if( pThis.y ~= pItem.y )then
                                return false;
                            end
                        end
                    end
                    local vibDepthThis = hVibratoThis:getDepthBP();
                    local vibDepthItem = hVibratoItem:getDepthBP();
                    if( vibDepthThis == nil and vibDepthItem ~= nil )then
                        return false;
                    end
                    if( vibDepthThis ~= nil and vibDepthItem == nil )then
                        return false;
                    end
                    if( vibDepthThis ~= nil and vibDepthItem ~= nil )then
                        local numDepthCount = vibDepthThis:size();
                        if( numDepthCount ~= vibDepthItem:size() )then
                            return false;
                        end
                        local k;
                        for k = 0, numDepthCount - 1, 1 do
                            local pThis = vibDepthThis:getElement( k );
                            local pItem = vibDepthItem:getElement( k );
                            if( pThis.x ~= pItem.x )then
                                return false;
                            end
                            if( pThis.y ~= pItem.y )then
                                return false;
                            end
                        end
                    end
                end
                if( self.vMeanNoteTransition ~= item.vMeanNoteTransition )then
                    return false;
                end
            elseif( self.type == EventTypeEnum.Singer )then
                -- シンガーイベントの比較
                if( self.singerHandle.program ~= item.singerHandle.program )then
                    return false;
                end
            elseif( self.type == EventTypeEnum.Aicon )then
                if( self.iconDynamicsHandle.iconId ~= item.iconDynamicsHandle.iconId )then
                    return false;
                end
                if( self.iconDynamicsHandle:isDynaffType() )then
                    -- 強弱記号
                else
                    -- クレッシェンド・デクレッシェンド
                    if( self:getLength() ~= item:getLength() )then
                        return false;
                    end
                end
            end

            return true;
        end]]

    --
    -- テキストストリームに書き出す
    function this:write( ... )
        local arguments = { ... };
        if( #arguments == 1 )then
            self:_write_1( arguments[1] );
        elseif( #arguments == 2 )then
            self:_write_2( arguments[1], arguments[2] );
        end
    end

    ---
    -- テキストストリームに書き出す
    -- @param stream (TextStream) 出力先
    -- @name write<!--1-->
    function this:_write_1( stream )
        local def = { "Length",
                    "Note#",
                    "Dynamics",
                    "PMBendDepth",
                    "PMBendLength",
                    "PMbPortamentoUse",
                    "DEMdecGainRate",
                    "DEMaccent" };
        self:_write_2( stream, def );
    end

    ---
    -- テキストストリームに書き出す
    -- @param stream (TextStream) 出力先
    -- @param printTargets (table) 出力するアイテムのリスト
    -- @name write<!--2-->
    function this:_write_2( stream, printTargets )
        stream:writeLine( "[ID#" .. string.format( "%04d", self.index ) .. "]" );
        stream:writeLine( "Type=" .. EventTypeEnum.toString( self.type ) );
        if( self.type == EventTypeEnum.Anote )then
            if( Util.searchArray( printTargets, "Length" ) >= 1 )then
                stream:writeLine( "Length=" .. self:getLength() );
            end
            if( Util.searchArray( printTargets, "Note#" ) >= 1 )then
                stream:writeLine( "Note#=" .. self.note );
            end
            if( Util.searchArray( printTargets, "Dynamics" ) >= 1 )then
                stream:writeLine( "Dynamics=" .. self.dynamics );
            end
            if( Util.searchArray( printTargets, "PMBendDepth" ) >= 1 )then
                stream:writeLine( "PMBendDepth=" .. self.pmBendDepth );
            end
            if( Util.searchArray( printTargets, "PMBendLength" ) >= 1 )then
                stream:writeLine( "PMBendLength=" .. self.pmBendLength );
            end
            if( Util.searchArray( printTargets, "PMbPortamentoUse" ) >= 1 )then
                stream:writeLine( "PMbPortamentoUse=" .. self.pmbPortamentoUse );
            end
            if( Util.searchArray( printTargets, "DEMdecGainRate" ) >= 1 )then
                stream:writeLine( "DEMdecGainRate=" .. self.demDecGainRate );
            end
            if( Util.searchArray( printTargets, "DEMaccent" ) >= 1 )then
                stream:writeLine( "DEMaccent=" .. self.demAccent );
            end
            if( Util.searchArray( printTargets, "PreUtterance" ) >= 1 )then
                stream:writeLine( "PreUtterance=" .. self.ustEvent.preUtterance );
            end
            if( Util.searchArray( printTargets, "VoiceOverlap" ) >= 1 )then
                stream:writeLine( "VoiceOverlap=" .. self.ustEvent.voiceOverlap );
            end
            if( self.lyricHandle ~= nil )then
                stream:writeLine( "LyricHandle=h#" .. string.format( "%04d", self._lyricHandleIndex ) );
            end
            if( self.vibratoHandle ~= nil )then
                stream:writeLine( "VibratoHandle=h#" .. string.format( "%04d", self._vibratoHandleIndex ) );
                stream:writeLine( "VibratoDelay=" .. self.vibratoDelay );
            end
            if( self.noteHeadHandle ~= nil )then
                stream:writeLine( "NoteHeadHandle=h#" .. string.format( "%04d", self._noteHeadHandleIndex ) );
            end
        elseif( self.type == EventTypeEnum.Singer )then
            stream:writeLine( "IconHandle=h#" .. string.format( "%04d", self._singerHandleIndex ) );
        elseif( self.type == EventTypeEnum.Aicon )then
            stream:writeLine( "IconHandle=h#" .. string.format( "%04d", self._singerHandleIndex ) );
            stream:writeLine( "Note#=" .. self.note );
        end
    end

    ---
    -- コピーを作成する
    -- @return (Event) このインスタンスのコピー
    -- @name clone
    function this:clone()
        local result = Event.new( self.clock, self.type );

        result.type = self.type;
        if( self.singerHandle ~= nil )then
            result.singerHandle = self.singerHandle:clone();
        end
        result:setLength( self:getLength() );
        result.note = self.note;
        result.dynamics = self.dynamics;
        result.pmBendDepth = self.pmBendDepth;
        result.pmBendLength = self.pmBendLength;
        result.pmbPortamentoUse = self.pmbPortamentoUse;
        result.demDecGainRate = self.demDecGainRate;
        result.demAccent = self.demAccent;
        result.d4mean = self.d4mean;
        result.pMeanOnsetFirstNote = self.pMeanOnsetFirstNote;
        result.vMeanNoteTransition = self.vMeanNoteTransition;
        result.pMeanEndingNote = self.pMeanEndingNote;
        if( self.lyricHandle ~= nil )then
            result.lyricHandle = self.lyricHandle:clone();
        end
        if( self.vibratoHandle ~= nil )then
            result.vibratoHandle = self.vibratoHandle:clone();
        end
        result.vibratoDelay = self.vibratoDelay;
        if( self.noteHeadHandle ~= nil )then
            result.noteHeadHandle = self.noteHeadHandle:clone();
        end
        if( self.iconDynamicsHandle ~= nil )then
            result.iconDynamicsHandle = self.iconDynamicsHandle:clone();
        end
        result.index = self.index;

        result.id = self.id;
        if( self.ustEvent ~= nil )then
            result.ustEvent = self.ustEvent:clone();
        end
        result.tag = self.tag;
        return result;
    end

    --[[
        -- テキストファイルからのコンストラクタ
        -- @param sr [TextStream] 読み込み対象
        -- @param value [int]
        -- @param last_line [ByRef<string>] 読み込んだ最後の行が返されます
        -- @return (Id)
        function this:_init_3( sr, value, last_line )
            local spl;
            self.index = value;
            self.type = EventTypeEnum.Unknown;
            self._singerHandleIndex = -2;
            self._lyricHandleIndex = -1;
            self._vibratoHandleIndex = -1;
            self._noteHeadHandleIndex = -1;
            self:setLength( 0 );
            self.note = 0;
            self.dynamics = 64;
            self.pmBendDepth = 8;
            self.pmBendLength = 0;
            self.pmbPortamentoUse = 0;
            self.demDecGainRate = 50;
            self.demAccent = 50;
            self.vibratoDelay = 0;
            last_line.value = sr:readLine();
            while( last_line.value:find( "[" ) ~= 0 )do
                spl = Util.split( last_line.index, '=' );
                local search = spl[1];
                if( search == "Type" )then
                    if( spl[2] == "Anote" )then
                        self.type = EventTypeEnum.Anote;
                    elseif( spl[2] == "Singer" )then
                        self.type = EventTypeEnum.Singer;
                    elseif( spl[2] == "Aicon" )then
                        self.type = EventTypeEnum.Aicon;
                    else
                        self.type = EventTypeEnum.Unknown;
                    end
                elseif( search == "Length" )then
                    self:setLength( tonumber( spl[2], 10 ) );
                elseif( search == "Note#" )then
                    self.note = tonumber( spl[2], 10 );
                elseif( search == "Dynamics" )then
                    self.dynamics = tonumber( spl[2], 10 );
                elseif( search == "PMBendDepth" )then
                    self.pmBendDepth = tonumber( spl[2], 10 );
                elseif( search == "PMBendLength" )then
                    self.pmBendLength = tonumber( spl[2], 10 );
                elseif( search == "DEMdecGainRate" )then
                    self.demDecGainRate = tonumber( spl[2], 10 );
                elseif( search ==  "DEMaccent" )then
                    self.demAccent = tonumber( spl[2], 10 );
                elseif( search == "LyricHandle" )then
                    self._lyricHandleIndex = Handle.getHandleIndexFromString( spl[2] );
                elseif( search == "IconHandle" )then
                    self._singerHandleIndex = Handle.getHandleIndexFromString( spl[2] );
                elseif( search == "VibratoHandle" )then
                    self._vibratoHandleIndex = Handle.getHandleIndexFromString( spl[2] );
                elseif( search == "VibratoDelay" )then
                    self.vibratoDelay = tonumber( spl[2], 10 );
                elseif( search == "PMbPortamentoUse" )then
                    self.pmbPortamentoUse = tonumber( spl[2], 10 );
                elseif( search == "NoteHeadHandle" )then
                    self._noteHeadHandleIndex = Handle.getHandleIndexFromString( spl[2] );
                end
                if( not sr:ready() )then
                    break;
                end
                last_line.value = sr:readLine();
            end
        end]]

    ---
    -- このオブジェクトがイベントリストの末尾の要素( EOS )かどうかを取得する
    -- @return (boolean) このオブジェクトが EOS 要素であれば true を、そうでなければ false を返す
    -- @name isEOS
    function this:isEOS()
        if( self.index == -1 )then
            return true;
        else
            return false;
        end
    end

    ---
    -- 順序を比較する
    -- @param item (Event) 比較対象のアイテム
    -- @return (integer) このインスタンスが比較対象よりも小さい場合は負の整数、等しい場合は 0、大きい場合は正の整数を返す
    -- @name compareTo
    function this:compareTo( item )
        local ret = self.clock - item.clock;
        if( ret == 0 )then
            return self.type - item.type;
        else
            return ret;
        end
    end

    if( #arguments == 0 )then
        this:_init_0();
    elseif( #arguments == 1 )then
        this:_init_1( arguments[1] );
    elseif( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    end

    return this;
end

---
-- 2 つの Event を比較する
-- @param a (Event) 比較対象のオブジェクト
-- @param b (Event) 比較対象のオブジェクト
-- @return (boolean) a が b よりも小さい場合は true、そうでない場合は false を返す
-- @name compare
-- @access static
function Event.compare( a, b )
    return (a:compareTo( b ) < 0);
end

---
-- イベントリストの末尾の要素を表すオブジェクトを取得する
-- @return (Event オブジェクト
-- @name getEOS
-- @access static
function Event.getEOS()
    return Event.new();
end

---
-- ミリ秒で表した、音符の最大長さ
-- @access static
Event.MAX_NOTE_MILLISEC_LENGTH = 16383;
