--[[
  Handle.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local tonumber = tonumber;
local string = string;

module( "luavsq" );

---
-- ハンドルを取り扱います。ハンドルにはLyricHandle、VibratoHandle、SingerHandleおよびNoteHeadHandleがある
-- @class table
-- @name Handle
Handle = {};

---
-- 初期化を行う
-- @see this:_init_3
-- @return (Handle)
function Handle.new( ... )
    local arguments = { ... };
    local this = {};
    this._type = HandleTypeEnum.Lyric;
    this.index = 0;
    this.iconId = "";
    this.ids = "";
    this.lyrics = {};
    this.original = 0;
    this.caption = "";
    this.length = 0;
    this.startDepth = 0;
    this.depthBP = nil;
    this.startRate = 0;
    this.rateBP = nil;
    this.language = 0;
    this.program = 0;
    this.duration = 0;
    this.depth = 0;
    this.startDyn = 0;
    this.endDyn = 0;
    this.dynBP = nil;

    ---
    -- @field
    -- 歌詞・発音記号列の前後にクォーテーションマークを付けるかどうか
    this.addQuotationMark = true;

    ---
    -- Tick 単位の長さを取得する
    -- @return (integer)
    function this:getLength()
        return self.length;
    end

    ---
    -- 長さを設定する
    -- @param value (integer) Tick単位の長さ
    function this:setLength( value )
        self.length = value;
    end

    ---
    -- ハンドルのタイプを取得する
    -- @return (HandleTypeEnum) ハンドルのタイプ
    function this:getHandleType()
        return self._type;
    end

    ---
    -- このオブジェクトを歌詞ハンドルに型変換する
    -- @return (LyricHandle) 歌詞ハンドル
    function this:castToLyricHandle()
        local ret = LyricHandle.new();
        ret.index = self.index;
        ret.lyrics = self.lyrics;
        return ret;
    end

    ---
    -- このオブジェクトをビブラートハンドルに型変換する
    -- @return (VibratoHandle) ビブラートハンドル
    function this:castToVibratoHandle()
        local ret = VibratoHandle.new();
        ret.index = self.index;
        ret:setCaption( self.caption );
        ret:setDepthBP( self.depthBP );
        ret.iconId = self.iconId;
        ret.ids = self.ids;
        ret:setLength( self.length );
        ret.original = self.original;
        ret:setRateBP( self.rateBP );
        ret:setStartDepth( self.startDepth );
        ret:setStartRate( self.startRate );
        return ret;
    end

    ---
    -- このオブジェクトを歌手ハンドルに型変換する
    -- @return (SingerHandle) 歌手ハンドル
    function this:castToSingerHandle()
        local ret = SingerHandle.new();
        ret.index = self.index;
        ret.caption = self.caption;
        ret.iconId = self.iconId;
        ret.ids = self.ids;
        ret.language = self.language;
        ret:setLength( self.length );
        ret.original = self.original;
        ret.program = self.program;
        return ret;
    end

    ---
    -- このオブジェクトをアタックハンドルに型変換する
    -- @return (NoteHeadHandle) アタックハンドル
    function this:castToNoteHeadHandle()
        local ret = NoteHeadHandle.new();
        ret:setCaption( self.caption );
        ret:setDepth( self.depth );
        ret:setDuration( self.duration );
        ret.iconId = self.iconId;
        ret.ids = self.ids;
        ret:setLength( self:getLength() );
        ret.original = self.original;
        return ret;
    end

    ---
    -- このオブジェクトをダイナミクスハンドルに型変換する
    -- @return (IconDynamicsHandle) ダイナミクスハンドル
    function this:castToIconDynamicsHandle()
        local ret = IconDynamicsHandle.new();
        ret.ids = self.ids;
        ret.iconId = self.iconId;
        ret.original = self.original;
        ret:setCaption( self.caption );
        ret:setDynBP( self.dynBP );
        ret:setEndDyn( self.endDyn );
        ret:setLength( self:getLength() );
        ret:setStartDyn( self.startDyn );
        return ret;
    end

    ---
    -- ストリームに書き込む
    -- @param stream (TextStream) 書き込み先のストリーム
    function this:write( stream )
        stream:writeLine( self:toString() );
    end

    ---
    -- テキストストリームからハンドルの内容を読み込み初期化する
    -- @param sr (TextStream) 読み込み元のテキストストリーム
    -- @param index (integer) index フィールドの値
    -- @param last_line (table, { value = ? }) 読み込んだ最後の行。テーブルの ["value"] に文字列が格納される
    function this:_init_3( sr, index, last_line )
        self.index = index;
        local spl;
        local spl2;

        -- default値で埋める
        self._type = HandleTypeEnum.Vibrato;
        self.iconId = "";
        self.ids = "normal";
        self.lyrics = { Lyric.new( "" ) };
        self.original = 0;
        self.caption = "";
        self.length = 0;
        self.startDepth = 0;
        self.depthBP = null;
        self.startRate = 0;
        self.rateBP = null;
        self.language = 0;
        self.program = 0;
        self.duration = 0;
        self.depth = 64;

        local tmpDepthBPX = "";
        local tmpDepthBPY = "";
        local tmpDepthBPNum = "";

        local tmpRateBPX = "";
        local tmpRateBPY = "";
        local tmpRateBPNum = "";

        local tmpDynBPX = "";
        local tmpDynBPY = "";
        local tmpDynBPNum = "";

        -- "["にぶち当たるまで読込む
        last_line.value = sr:readLine();
        while( last_line.value:find( "[", 1, true ) ~= 1 )do
            spl = Util.split( last_line.value, '=' );
            local search = spl[1];
            if( search == "Language" )then
                self._type = HandleTypeEnum.Singer;
                self.language = tonumber( spl[2], 10 );
            elseif( search == "Program" )then
                self.program = tonumber( spl[2], 10 );
            elseif( search == "IconID" )then
                self.iconId = spl[2];
            elseif( search == "IDS" )then
                self.ids = spl[2];
                for i = 3, #spl, 1 do
                    self.ids = self.ids .. "=" .. spl[i];
                end
            elseif( search == "Original" )then
                self.original = tonumber( spl[2], 10 );
            elseif( search == "Caption" )then
                self.caption = spl[2];
                for i = 3, #spl, 1 do
                    self.caption = self.caption .. "=" .. spl[i];
                end
            elseif( search == "Length" )then
                self.length = tonumber( spl[2], 10 );
            elseif( search == "StartDepth" )then
                self.startDepth = tonumber( spl[2], 10 );
            elseif( search == "DepthBPNum" )then
                tmpDepthBPNum = spl[2];
            elseif( search == "DepthBPX" )then
                tmpDepthBPX = spl[2];
            elseif( search == "DepthBPY" )then
                tmpDepthBPY = spl[2];
            elseif( search == "StartRate" )then
                self._type = HandleTypeEnum.Vibrato;
                self.startRate = tonumber( spl[2], 10 );
            elseif( search == "RateBPNum" )then
                tmpRateBPNum = spl[2];
            elseif( search == "RateBPX" )then
                tmpRateBPX = spl[2];
            elseif( search == "RateBPY" )then
                tmpRateBPY = spl[2];
            elseif( search == "Duration" )then
                self._type = HandleTypeEnum.NoteHead;
                self.duration = tonumber( spl[2], 10 );
            elseif( search == "Depth" )then
                self.depth = tonumber( spl[2], 10 );
            elseif( search == "StartDyn" )then
                self._type = HandleTypeEnum.Dynamics;
                self.startDyn = tonumber( spl[2], 10 );
            elseif( search == "EndDyn" )then
                self._type = HandleTypeEnum.Dynamics;
                self.endDyn = tonumber( spl[2], 10 );
            elseif( search == "DynBPNum" )then
                tmpDynBPNum = spl[2];
            elseif( search == "DynBPX" )then
                tmpDynBPX = spl[2];
            elseif( search == "DynBPY" )then
                tmpDynBPY = spl[2];
            elseif( search:find( "L" ) == 1 and search:len() >= 2 )then
                local num = search:sub( 2, 2 );
                if( nil ~= tonumber( num ) )then
                    local lyric = Lyric.new( spl[2] );
                    self._type = HandleTypeEnum.Lyric;
                    local index = tonumber( num );
                    self.lyrics[index + 1] = lyric;
                end
            end
            if( not sr:ready() )then
                break;
            end
            last_line.value = sr:readLine();
        end

        -- RateBPX, RateBPYの設定
        if( self._type == HandleTypeEnum.Vibrato )then
            if( tmpRateBPNum ~= "" )then
                self.rateBP = VibratoBPList.new( tmpRateBPNum, tmpRateBPX, tmpRateBPY );
            else
                self.rateBP = VibratoBPList.new();
            end

            -- DepthBPX, DepthBPYの設定
            if( tmpDepthBPNum ~= "" )then
                self.depthBP = VibratoBPList.new( tmpDepthBPNum, tmpDepthBPX, tmpDepthBPY );
            else
                self.depthBP = VibratoBPList.new();
            end
        else
            self.depthBP = VibratoBPList.new();
            self.rateBP = VibratoBPList.new();
        end

        if( tmpDynBPNum ~= "" )then
            self.dynBP = VibratoBPList.new( tmpDynBPNum, tmpDynBPX, tmpDynBPY );
        else
            self.dynBP = VibratoBPList.new();
        end
    end

    ---
    -- オブジェクトを文字列に変換する
    -- @return (string) 文字列
    function this:toString()
        local result = "";
        result = result .. "[h#" .. string.format( "%04d", self.index ) .. "]";
        if( self._type == HandleTypeEnum.Lyric )then
            for i = 1, #self.lyrics, 1 do
                result = result .. "\n" .. "L" .. (i - 1) .. "=" .. self.lyrics[i]:toString( self.addQuotationMark );
            end
        elseif( self._type == HandleTypeEnum.Vibrato )then
            result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
            result = result .. "IDS=" .. self.ids .. "\n";
            result = result .. "Original=" .. self.original .. "\n";
            result = result .. "Caption=" .. self.caption .. "\n";
            result = result .. "Length=" .. self.length .. "\n";
            result = result .. "StartDepth=" .. self.startDepth .. "\n";
            result = result .. "DepthBPNum=" .. self.depthBP:size() .. "\n";
            if( self.depthBP:size() > 0 )then
                result = result .. "DepthBPX=" .. string.format( "%.6f", self.depthBP:get( 0 ).x );
                for i = 1, self.depthBP:size() - 1, 1 do
                    result = result .. "," .. string.format( "%.6f", self.depthBP:get( i ).x );
                end
                result = result .. "\n" .. "DepthBPY=" .. self.depthBP:get( 0 ).y;
                for i = 1, self.depthBP:size() - 1, 1 do
                    result = result .. "," .. self.depthBP:get( i ).y;
                end
                result = result .. "\n";
            end
            result = result .. "StartRate=" .. self.startRate .. "\n";
            result = result .. "RateBPNum=" .. self.rateBP:size();
            if( self.rateBP:size() > 0 )then
                result = result .. "\n" .. "RateBPX=" .. string.format( "%.6f", self.rateBP:get( 0 ).x );
                for i = 1, self.rateBP:size() - 1, 1 do
                    result = result .. "," .. string.format( "%.6f", self.rateBP:get( i ).x );
                end
                result = result .. "\n" .. "RateBPY=" .. self.rateBP:get( 0 ).y;
                for i = 1, self.rateBP:size() - 1, 1 do
                    result = result .. "," .. self.rateBP:get( i ).y;
                end
            end
        elseif( self._type == HandleTypeEnum.Singer )then
            result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
            result = result .. "IDS=" .. self.ids .. "\n";
            result = result .. "Original=" .. self.original .. "\n";
            result = result .. "Caption=" .. self.caption .. "\n";
            result = result .. "Length=" .. self.length .. "\n";
            result = result .. "Language=" .. self.language .. "\n";
            result = result .. "Program=" .. self.program;
        elseif( self._type == HandleTypeEnum.NoteHead )then
            result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
            result = result .. "IDS=" .. self.ids .. "\n";
            result = result .. "Original=" .. self.original .. "\n";
            result = result .. "Caption=" .. self.caption .. "\n";
            result = result .. "Length=" .. self.length .. "\n";
            result = result .. "Duration=" .. self.duration .. "\n";
            result = result .. "Depth=" .. self.depth;
        elseif( self._type == HandleTypeEnum.Dynamics )then
            result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
            result = result .. "IDS=" .. self.ids .. "\n";
            result = result .. "Original=" .. self.original .. "\n";
            result = result .. "Caption=" .. self.caption .. "\n";
            result = result .. "StartDyn=" .. self.startDyn .. "\n";
            result = result .. "EndDyn=" .. self.endDyn .. "\n";
            result = result .. "Length=" .. self:getLength() .. "\n";
            if( nil ~= self.dynBP )then
                if( self.dynBP:size() <= 0 )then
                    result = result .. "DynBPNum=0";
                else
                    local c = self.dynBP:size();
                    result = result .. "DynBPNum=" .. c .. "\n";
                    result = result .. "DynBPX=" .. string.format( "%.6f", self.dynBP:get( 0 ).x );
                    for i = 1, c - 1, 1 do
                        result = result .. "," .. string.format( "%.6f", self.dynBP:get( i ).x );
                    end
                    result = result .. "\n" .. "DynBPY=" .. self.dynBP:get( 0 ).y;
                    for i = 1, c - 1, 1 do
                        result = result .. "," .. self.dynBP:get( i ).y;
                    end
                end
            else
                result = result .. "DynBPNum=0";
            end
        end
        return result;
    end

    if( #arguments == 3 )then
        this:_init_3( arguments[1], arguments[2], arguments[3] );
    end

    return this;
end

---
-- ハンドル指定子（例えば"h#0123"という文字列）からハンドル番号を取得する
-- @param string (string) ハンドル指定子
-- @return (integer) ハンドル番号
function Handle.getHandleIndexFromString( _string )
    local spl = Util.split( _string, "#" );
    return tonumber( spl[2], 10 );
end
