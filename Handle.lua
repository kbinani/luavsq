--[[
  Handle.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local tonumber = tonumber;
local string = string;
local table = table;

module( "luavsq" );

---
-- ハンドルを取り扱います。ハンドルにはLyricHandle、VibratoHandle、SingerHandleおよびNoteHeadHandleがある
-- @class table
-- @name Handle
Handle = {};

---
-- 強弱記号の場合の、IconId の最初の5文字。
Handle.ICONID_HEAD_DYNAFF = "$0501";

---
-- クレッシェンドの場合の、IconId の最初の5文字。
Handle.ICONID_HEAD_CRESCEND = "$0502";

---
-- デクレッシェンドの場合の、IconId の最初の5文字。
Handle.ICONID_HEAD_DECRESCEND = "$0503";

--
-- 初期化を行う
-- @return (Handle)
function Handle.new( ... )
    local arguments = { ... };
    local this = {};
    this._type = HandleTypeEnum.LYRIC;
    this._articulation = nil;

    ---
    -- メタテキストに出力されるこのオブジェクトの ID
    -- @var int
    this.index = 0;

    ---
    -- ハンドルを特定するための文字列
    -- @var string
    this.iconId = "";

    ---
    -- ハンドルの名前
    -- @var string
    this.ids = "";

    ---
    -- 歌詞一覧
    -- @var table
    -- @access private
    this._lyrics = {};

    ---
    -- ハンドルのオリジナル
    -- @var int
    this.original = 0;

    ---
    -- キャプション
    -- @var string
    -- @access private
    this._caption = "";

    ---
    -- 長さ
    -- @var int
    -- @access private
    this._length = 0;

    ---
    -- Depth の開始値
    -- @var int
    -- @access private
    this._startDepth = 0;

    ---
    -- Depth のカーブ
    -- @var VibratoBPList
    -- @access private
    this._depthBP = nil;

    ---
    -- Rate の開始値
    -- @var int
    -- @access private
    this._startRate = 0;

    ---
    -- Rate のカーブ
    -- @var VibratoBPList
    -- @access private
    this._rateBP = nil;

    ---
    -- 歌手の歌唱言語を表す番号(バンクセレクト)。歌手ハンドルでのみ使われる
    -- @var int
    this.language = 0;

    ---
    -- 歌手の種類を表す番号(プログラムチェンジ)。歌手ハンドルでのみ使われる
    -- @var int
    this.program = 0;

    ---
    -- Duration
    -- @var int
    -- @access private
    this._duration = 0;

    ---
    -- Depth
    -- @var int
    -- @access private
    this._depth = 0;

    ---
    -- Dyn の開始値
    -- @var int
    -- @access private
    this._startDyn = 0;

    ---
    -- Dyn の終了値
    -- @var int
    -- @access private
    this._endDyn = 0;

    ---
    -- Dyn のカーブ
    -- @var VibratoBPList
    -- @access private
    this._dynBP = nil;

    ---
    -- 歌詞・発音記号列の前後にクォーテーションマークを付けるかどうか
    -- @var boolean
    this.addQuotationMark = true;

    ---
    -- @param type (HandleTypeEnum) ハンドルの種類
    -- @name new<!--1-->
    -- @return (Handle)
    -- @access static ctor
    function this:_init_1( type )
        self._type = type;
        if( type == HandleTypeEnum.DYNAMICS )then
            self:_init_icon_dynamics();
        elseif( type == HandleTypeEnum.NOTE_HEAD )then
            self._articulation = ArticulationTypeEnum.NOTE_ATTACK;
        elseif( type == HandleTypeEnum.VIBRATO )then
            self:_init_vibrato();
        elseif( type == HandleTypeEnum.LYRIC )then
            self:_init_lyric();
        end
    end

    ---
    -- テキストストリームからハンドルの内容を読み込み初期化する
    -- @param stream (TextStream) 読み込み元のテキストストリーム
    -- @param index (int) <code>index</code> フィールドの値
    -- @param lastLine (table) 読み込んだ最後の行。テーブルの ["value"] に文字列が格納される
    -- @name new<!--2-->
    -- @return (Handle)
    -- @access static ctor
    function this:_init_3( stream, index, lastLine )
        self.index = index;
        local spl;
        local spl2;

        -- default値で埋める
        self._type = HandleTypeEnum.VIBRATO;
        self.iconId = "";
        self.ids = "normal";
        self._lyrics = { Lyric.new( "" ) };
        self.original = 0;
        self._caption = "";
        self._length = 0;
        self._startDepth = 0;
        self._depthBP = null;
        self._startRate = 0;
        self._rateBP = null;
        self.language = 0;
        self.program = 0;
        self._duration = 0;
        self._depth = 64;

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
        lastLine.value = stream:readLine();
        while( lastLine.value:find( "[", 1, true ) ~= 1 )do
            spl = Util.split( lastLine.value, '=' );
            local search = spl[1];
            if( search == "Language" )then
                self._type = HandleTypeEnum.SINGER;
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
                self._caption = spl[2];
                for i = 3, #spl, 1 do
                    self._caption = self._caption .. "=" .. spl[i];
                end
            elseif( search == "Length" )then
                self._length = tonumber( spl[2], 10 );
            elseif( search == "StartDepth" )then
                self._startDepth = tonumber( spl[2], 10 );
            elseif( search == "DepthBPNum" )then
                tmpDepthBPNum = spl[2];
            elseif( search == "DepthBPX" )then
                tmpDepthBPX = spl[2];
            elseif( search == "DepthBPY" )then
                tmpDepthBPY = spl[2];
            elseif( search == "StartRate" )then
                self._type = HandleTypeEnum.VIBRATO;
                self._startRate = tonumber( spl[2], 10 );
            elseif( search == "RateBPNum" )then
                tmpRateBPNum = spl[2];
            elseif( search == "RateBPX" )then
                tmpRateBPX = spl[2];
            elseif( search == "RateBPY" )then
                tmpRateBPY = spl[2];
            elseif( search == "Duration" )then
                self._type = HandleTypeEnum.NOTE_HEAD;
                self._duration = tonumber( spl[2], 10 );
            elseif( search == "Depth" )then
                self._depth = tonumber( spl[2], 10 );
            elseif( search == "StartDyn" )then
                self._type = HandleTypeEnum.DYNAMICS;
                self._startDyn = tonumber( spl[2], 10 );
            elseif( search == "EndDyn" )then
                self._type = HandleTypeEnum.DYNAMICS;
                self._endDyn = tonumber( spl[2], 10 );
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
                    self._type = HandleTypeEnum.LYRIC;
                    local index = tonumber( num );
                    self._lyrics[index + 1] = lyric;
                end
            end
            if( not stream:ready() )then
                break;
            end
            lastLine.value = stream:readLine();
        end

        -- RateBPX, RateBPYの設定
        if( self._type == HandleTypeEnum.VIBRATO )then
            if( tmpRateBPNum ~= "" )then
                self._rateBP = VibratoBPList.new( tmpRateBPNum, tmpRateBPX, tmpRateBPY );
            else
                self._rateBP = VibratoBPList.new();
            end

            -- DepthBPX, DepthBPYの設定
            if( tmpDepthBPNum ~= "" )then
                self._depthBP = VibratoBPList.new( tmpDepthBPNum, tmpDepthBPX, tmpDepthBPY );
            else
                self._depthBP = VibratoBPList.new();
            end
        else
            self._depthBP = VibratoBPList.new();
            self._rateBP = VibratoBPList.new();
        end

        if( tmpDynBPNum ~= "" )then
            self._dynBP = VibratoBPList.new( tmpDynBPNum, tmpDynBPX, tmpDynBPY );
        else
            self._dynBP = VibratoBPList.new();
        end
    end

    ---
    -- ビブラートハンドルとして初期化を行う
    -- @access private
    function this:_init_vibrato()
        self._articulation = ArticulationTypeEnum.VIBRATO;
        self.index = 0;
        self.iconId = "$04040000";
        self.ids = "";
        self.original = 0;
        self._startRate = 64;
        self._startDepth = 64;
        self._rateBP = VibratoBPList.new();
        self._depthBP = VibratoBPList.new();
    end

    ---
    -- 強弱記号ハンドルとして初期化を行う
    -- @access private
    function this:_init_icon_dynamics()
        self._articulation = ArticulationTypeEnum.DYNAFF;
        self.iconId = "";
        self.ids = "";
        self.original = 0;
    end

    ---
    -- 歌詞ハンドルとして初期化を行う
    -- @access private
    function this:_init_lyric()
        self.index = 0;
        self._lyrics = {};
    end

    ---
    -- articulation の種類を取得する
    -- @return (ArticulationTypeEnum) articulation の種類
    function this:getArticulation()
        return self._articulation;
    end

    ---
    -- このハンドルが強弱記号を表すものかどうかを表すブール値を取得する
    -- @return (boolean) このオブジェクトが強弱記号を表すものであれば <code>true</code> を、そうでなければ <code>false</code> を返す
    function this:isDynaffType()
        if( nil ~= self.iconId )then
            return self.iconId:find( Handle.ICONID_HEAD_DYNAFF ) == 1;
        else
            return false;
        end
    end

    ---
    -- このハンドルがクレッシェンドを表すものかどうかを表すブール値を取得する
    -- @return (boolean) このオブジェクトがクレッシェンドを表すものであれば <code>true</code> を、そうでなければ <code>false</code> を返す
    function this:isCrescendType()
        if( nil ~= self.iconId )then
            return self.iconId:find( Handle.ICONID_HEAD_CRESCEND ) == 1;
        else
            return false;
        end
    end

    ---
    -- このハンドルがデクレッシェンドを表すものかどうかを表すブール値を取得する
    -- @return (boolean) このオブジェクトがデクレッシェンドを表すものであれば <code>true</code> を、そうでなければ <code>false</code> を返す
    function this:isDecrescendType()
        if( nil ~= self.iconId )then
            return self.iconId:find( Handle.ICONID_HEAD_DECRESCEND ) == 1;
        else
            return false;
        end
    end

    ---
    -- Tick 単位の長さを取得する
    -- @return (int)
    function this:getLength()
        return self._length;
    end

    ---
    -- 長さを設定する
    -- @param value (int) Tick単位の長さ
    function this:setLength( value )
        self._length = value;
    end

    ---
    -- キャプションを取得する
    -- @return (string) キャプション
    function this:getCaption()
        return self._caption;
    end

    ---
    -- キャプションを設定する
    -- @param value (string) キャプション
    function this:setCaption( value )
        self._caption = value;
    end

    ---
    -- DYN の開始値を取得する
    -- @return (int) DYN の開始値
    function this:getStartDyn()
        return self._startDyn;
    end

    ---
    -- DYN の開始値を設定する
    -- @param value (int) DYN の開始値
    function this:setStartDyn( value )
        self._startDyn = value;
    end

    ---
    -- DYN の終了値を取得する
    -- @return (int) DYN の終了値
    function this:getEndDyn()
        return self._endDyn;
    end

    ---
    -- DYN の終了値を設定する
    -- @param value (int) DYN の終了値
    function this:setEndDyn( value )
        self._endDyn = value;
    end

    ---
    -- DYN カーブを取得する
    -- @return (VibratoBPList) DYN カーブ
    function this:getDynBP()
        return self._dynBP;
    end

    ---
    -- DYN カーブを設定する
    -- @param value (VibratoBPList) DYN カーブ
    function this:setDynBP( value )
        self._dynBP = value;
    end

    ---
    -- Depth 値を取得する
    -- @return (int) Depth 値
    function this:getDepth()
        return self._depth;
    end

    ---
    -- Depth 値を設定する
    -- @param value (int) Depth 値
    function this:setDepth( value )
        self._depth = value;
    end

    ---
    -- Duration 値を取得する
    -- @return (int) Duration 値
    function this:getDuration()
        return self._duration;
    end

    ---
    -- Duration 値を設定する
    -- @param value (int) Duration 値
    function this:setDuration( value )
        self._duration = value;
    end

    ---
    -- Rate のビブラートカーブを取得する
    -- @return (VibratoBPList) Rate のビブラートカーブ
    function this:getRateBP()
        return self._rateBP;
    end

    ---
    -- Rate のビブラートカーブを設定する
    -- @param value (VibratoBPList) 設定するビブラートカーブ
    function this:setRateBP( value )
        self._rateBP = value;
    end

    ---
    -- Depth のビブラートカーブを取得する
    -- @return (VibratoBPList) Depth のビビラートカーブ
    function this:getDepthBP()
        return self._depthBP;
    end

    ---
    -- Depth のビブラートカーブを設定する
    -- @param value (VibratoBPList) 設定するビブラートカーブ
    function this:setDepthBP( value )
        self._depthBP = value;
    end

    ---
    -- Rate の開始値を取得する
    -- @return (int) Rate の開始値
    function this:getStartRate()
        return self._startRate;
    end

    ---
    -- Rate の開始値を設定する
    -- @param value (int) Rate の開始値
    function this:setStartRate( value )
        self._startRate = value;
    end

    ---
    -- Depth の開始値を取得する
    -- @return (int) Depth の開始値
    function this:getStartDepth()
        return self._startDepth;
    end

    ---
    -- Depth の開始値を設定する
    -- @param value (int) Depth の開始値
    function this:setStartDepth( value )
        self._startDepth = value;
    end

    ---
    -- 指定した位置にある歌詞を取得する
    -- @param index (int) 取得する要素のインデックス(最初のインデックスは0)
    -- @return (Lyric) 歌詞
    function this:getLyricAt( index )
        return self._lyrics[index + 1];
    end

    ---
    -- 指定した位置にある歌詞を指定した要素で置き換える
    -- @param index (int) 置き換える要素のインデックス(最初のインデックスは0)
    -- @param value (Lyric) 置き換える要素
    function this:setLyricAt( index, value )
        if( index + 1 >= #self._lyrics )then
            local remain = index + 1 - #self._lyrics;
            local i;
            for i = 1, remain, 1 do
                table.insert( self._lyrics, false );
            end
        end
        self._lyrics[index + 1] = value;
    end

    ---
    -- 歌詞の個数を返す
    -- @return (int) 歌詞の個数
    function this:getLyricCount()
        return #self._lyrics;
    end

    ---
    -- Display String 値を取得する
    -- @return (string) Display String 値
    function this:getDisplayString()
        return self.ids .. self._caption;
    end

    ---
    -- ハンドルのタイプを取得する
    -- @return (HandleTypeEnum) ハンドルのタイプ
    function this:getHandleType()
        return self._type;
    end

    ---
    -- ストリームに書き込む
    -- @param stream (TextStream) 書き込み先のストリーム
    function this:write( stream )
        stream:writeLine( self:toString() );
    end

    ---
    -- オブジェクトを文字列に変換する
    -- @return (string) 文字列
    function this:toString()
        local result = "";
        result = result .. "[h#" .. string.format( "%04d", self.index ) .. "]";
        if( self._type == HandleTypeEnum.LYRIC )then
            for i = 1, #self._lyrics, 1 do
                result = result .. "\n" .. "L" .. (i - 1) .. "=" .. self._lyrics[i]:toString( self.addQuotationMark );
            end
        elseif( self._type == HandleTypeEnum.VIBRATO )then
            result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
            result = result .. "IDS=" .. self.ids .. "\n";
            result = result .. "Original=" .. self.original .. "\n";
            result = result .. "Caption=" .. self._caption .. "\n";
            result = result .. "Length=" .. self._length .. "\n";
            result = result .. "StartDepth=" .. self._startDepth .. "\n";
            result = result .. "DepthBPNum=" .. self._depthBP:size() .. "\n";
            if( self._depthBP:size() > 0 )then
                result = result .. "DepthBPX=" .. string.format( "%.6f", self._depthBP:get( 0 ).x );
                for i = 1, self._depthBP:size() - 1, 1 do
                    result = result .. "," .. string.format( "%.6f", self._depthBP:get( i ).x );
                end
                result = result .. "\n" .. "DepthBPY=" .. self._depthBP:get( 0 ).y;
                for i = 1, self._depthBP:size() - 1, 1 do
                    result = result .. "," .. self._depthBP:get( i ).y;
                end
                result = result .. "\n";
            end
            result = result .. "StartRate=" .. self._startRate .. "\n";
            result = result .. "RateBPNum=" .. self._rateBP:size();
            if( self._rateBP:size() > 0 )then
                result = result .. "\n" .. "RateBPX=" .. string.format( "%.6f", self._rateBP:get( 0 ).x );
                for i = 1, self._rateBP:size() - 1, 1 do
                    result = result .. "," .. string.format( "%.6f", self._rateBP:get( i ).x );
                end
                result = result .. "\n" .. "RateBPY=" .. self._rateBP:get( 0 ).y;
                for i = 1, self._rateBP:size() - 1, 1 do
                    result = result .. "," .. self._rateBP:get( i ).y;
                end
            end
        elseif( self._type == HandleTypeEnum.SINGER )then
            result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
            result = result .. "IDS=" .. self.ids .. "\n";
            result = result .. "Original=" .. self.original .. "\n";
            result = result .. "Caption=" .. self._caption .. "\n";
            result = result .. "Length=" .. self._length .. "\n";
            result = result .. "Language=" .. self.language .. "\n";
            result = result .. "Program=" .. self.program;
        elseif( self._type == HandleTypeEnum.NOTE_HEAD )then
            result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
            result = result .. "IDS=" .. self.ids .. "\n";
            result = result .. "Original=" .. self.original .. "\n";
            result = result .. "Caption=" .. self._caption .. "\n";
            result = result .. "Length=" .. self._length .. "\n";
            result = result .. "Duration=" .. self._duration .. "\n";
            result = result .. "Depth=" .. self._depth;
        elseif( self._type == HandleTypeEnum.DYNAMICS )then
            result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
            result = result .. "IDS=" .. self.ids .. "\n";
            result = result .. "Original=" .. self.original .. "\n";
            result = result .. "Caption=" .. self._caption .. "\n";
            result = result .. "StartDyn=" .. self._startDyn .. "\n";
            result = result .. "EndDyn=" .. self._endDyn .. "\n";
            result = result .. "Length=" .. self:getLength() .. "\n";
            if( nil ~= self._dynBP )then
                if( self._dynBP:size() <= 0 )then
                    result = result .. "DynBPNum=0";
                else
                    local c = self._dynBP:size();
                    result = result .. "DynBPNum=" .. c .. "\n";
                    result = result .. "DynBPX=" .. string.format( "%.6f", self._dynBP:get( 0 ).x );
                    for i = 1, c - 1, 1 do
                        result = result .. "," .. string.format( "%.6f", self._dynBP:get( i ).x );
                    end
                    result = result .. "\n" .. "DynBPY=" .. self._dynBP:get( 0 ).y;
                    for i = 1, c - 1, 1 do
                        result = result .. "," .. self._dynBP:get( i ).y;
                    end
                end
            else
                result = result .. "DynBPNum=0";
            end
        end
        return result;
    end

    ---
    -- コピーを作成する
    -- @return (Handle) このオブジェクトのコピー
    function this:clone()
        if( self._type == HandleTypeEnum.DYNAMICS )then
            local ret = Handle.new( HandleTypeEnum.DYNAMICS );
            ret.iconId = self.iconId;
            ret.ids = self.ids;
            ret.original = self.original;
            ret:setCaption( self:getCaption() );
            ret:setStartDyn( self:getStartDyn() );
            ret:setEndDyn( self:getEndDyn() );
            if( nil ~= self._dynBP )then
                ret:setDynBP( self._dynBP:clone() );
            end
            ret:setLength( self:getLength() );
            return ret;
        elseif( self._type == HandleTypeEnum.LYRIC )then
            local result = Handle.new( HandleTypeEnum.LYRIC );
            result.index = self.index;
            result._lyrics = {};
            for i = 1, #self._lyrics, 1 do
                local buf = self._lyrics[i]:clone();
                table.insert( result._lyrics, buf );
            end
            return result;
        elseif( self._type == HandleTypeEnum.NOTE_HEAD )then
            local result = Handle.new( HandleTypeEnum.NOTE_HEAD );
            result.index = self.index;
            result.iconId = self.iconId;
            result.ids = self.ids;
            result.original = self.original;
            result:setCaption( self:getCaption() );
            result:setLength( self:getLength() );
            result:setDuration( self:getDuration() );
            result:setDepth( self:getDepth() );
            return result;
        elseif( self._type == HandleTypeEnum.SINGER )then
            local ret = Handle.new( HandleTypeEnum.SINGER );
            ret._caption = self._caption;
            ret.iconId = self.iconId;
            ret.ids = self.ids;
            ret.index = self.index;
            ret.language = self.language;
            ret:setLength( self._length );
            ret.original = self.original;
            ret.program = self.program;
            return ret;
        elseif( self._type == HandleTypeEnum.VIBRATO )then
            local result = Handle.new( HandleTypeEnum.VIBRATO );
            result.index = self.index;
            result.iconId = self.iconId;
            result.ids = self.ids;
            result.original = self.original;
            result:setCaption( self._caption );
            result:setLength( self:getLength() );
            result:setStartDepth( self._startDepth );
            if( nil ~= self._depthBP )then
                result:setDepthBP( self._depthBP:clone() );
            end
            result:setStartRate( self._startRate );
            if( nil ~= self._rateBP )then
                result:setRateBP( self._rateBP:clone() );
            end
            return result;
        end
    end

    if( #arguments == 0 )then
        assert( false, "too few argument" );
        print( "Handle.new; #arguments=0" );
    elseif( #arguments == 1 )then
        this:_init_1( arguments[1] );
    elseif( #arguments == 3 )then
        this:_init_3( arguments[1], arguments[2], arguments[3] );
    end

    return this;
end

---
-- ハンドル指定子（例えば"h#0123"という文字列）からハンドル番号を取得する
-- @param s (string) ハンドル指定子
-- @return (int) ハンドル番号
-- @access static private
function Handle.getHandleIndexFromString( s )
    local spl = Util.split( s, "#" );
    return tonumber( spl[2], 10 );
end
