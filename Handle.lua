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
    this._type = HandleTypeEnum.Lyric;
    this._articulation = nil;
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
    -- @param type (HandleTypeEnum) ハンドルの種類
    -- @name <i>new</i><sup>1</sup>
    -- @return (Handle)
    function this:_init_1( type )
        self._type = type;
        if( type == HandleTypeEnum.Dynamics )then
            self:_init_icon_dynamics();
        elseif( type == HandleTypeEnum.NoteHead )then
            self._articulation = ArticulationTypeEnum.NoteAttack;
        elseif( type == HandleTypeEnum.Vibrato )then
            self:_init_vibrato();
        elseif( type == HandleTypeEnum.Lyric )then
            self:_init_lyric();
        end
    end

    ---
    -- テキストストリームからハンドルの内容を読み込み初期化する
    -- @param sr (TextStream) 読み込み元のテキストストリーム
    -- @param index (integer) index フィールドの値
    -- @param last_line (table, { value = ? }) 読み込んだ最後の行。テーブルの ["value"] に文字列が格納される
    -- @name <i>new</i><sup>2</sup>
    -- @return (Handle)
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

    --
    -- ビブラートハンドルとして初期化を行う
    -- @access private
    function this:_init_vibrato()
        self._articulation = ArticulationTypeEnum.Vibrato;
        self.index = 0;
        self.iconId = "";
        self.ids = "";
        self.original = 0;
        self.startRate = 64;
        self.startDepth = 64;
        self.rateBP = VibratoBPList.new();
        self.depthBP = VibratoBPList.new();
    end

    --
    -- 強弱記号ハンドルとして初期化を行う
    -- @access private
    function this:_init_icon_dynamics()
        self._articulation = ArticulationTypeEnum.Dynaff;
        self.iconId = "";
        self.ids = "";
        self.original = 0;
    end

    --
    -- @access private
    function this:_init_lyric()
        self.index = 0;
        self.lyrics = {};
    end

    ---
    -- articulation の種類を取得する
    -- @return (ArticulationTypeEnum) articulation の種類
    -- @name getArticulation
    function this:getArticulation()
        return self._articulation;
    end

    ---
    -- このハンドルが強弱記号を表すものかどうかを表すブール値を取得する
    -- @return (boolean) このオブジェクトが強弱記号を表すものであれば true を、そうでなければ false を返す
    -- @name isDynaffType
    function this:isDynaffType()
        if( nil ~= self.iconId )then
            return self.iconId:find( Handle.ICONID_HEAD_DYNAFF ) == 1;
        else
            return false;
        end
    end

    ---
    -- このハンドルがクレッシェンドを表すものかどうかを表すブール値を取得する
    -- @return (boolean) このオブジェクトがクレッシェンドを表すものであれば true を、そうでなければ false を返す
    -- @name isCrescendType
    function this:isCrescendType()
        if( nil ~= self.iconId )then
            return self.iconId:find( Handle.ICONID_HEAD_CRESCEND ) == 1;
        else
            return false;
        end
    end

    ---
    -- このハンドルがデクレッシェンドを表すものかどうかを表すブール値を取得する
    -- @return (boolean) このオブジェクトがデクレッシェンドを表すものであれば true を、そうでなければ false を返す
    -- @name isDecrescendType
    function this:isDecrescendType()
        if( nil ~= self.iconId )then
            return self.iconId:find( Handle.ICONID_HEAD_DECRESCEND ) == 1;
        else
            return false;
        end
    end

    ---
    -- Tick 単位の長さを取得する
    -- @return (integer)
    -- @name getLength
    function this:getLength()
        return self.length;
    end

    ---
    -- 長さを設定する
    -- @param value (integer) Tick単位の長さ
    -- @name setLength
    function this:setLength( value )
        self.length = value;
    end

    ---
    -- キャプションを取得する
    -- @return (string) キャプション
    -- @name getCaption
    function this:getCaption()
        return self.caption;
    end

    ---
    -- キャプションを設定する
    -- @param value (string)
    -- @name setCaption
    function this:setCaption( value )
        self.caption = value;
    end

    ---
    -- DYN の開始値を取得する
    -- @return (integer) DYN の開始値
    -- @name getStartDyn
    function this:getStartDyn()
        return self.startDyn;
    end

    ---
    -- DYN の開始値を設定する
    -- @param value (integer) DYN の開始値
    -- @name setStartDyn
    function this:setStartDyn( value )
        self.startDyn = value;
    end

    ---
    -- DYN の終了値を取得する
    -- @return (integer) DYN の終了値
    -- @name getEndDyn
    function this:getEndDyn()
        return self.endDyn;
    end

    ---
    -- DYN の終了値を設定する
    -- @param value (integer) DYN の終了値
    -- @name setEndDyn
    function this:setEndDyn( value )
        self.endDyn = value;
    end

    ---
    -- DYN カーブを取得する
    -- @return (VibratoBPList) DYN カーブ
    -- @name getDynBP
    function this:getDynBP()
        return self.dynBP;
    end

    ---
    -- DYN カーブを設定する
    -- @param value (VibratoBPList) DYN カーブ
    -- @name setDynBP
    function this:setDynBP( value )
        self.dynBP = value;
    end

    ---
    -- Depth 値を取得する
    -- @return (integer) Depth 値
    -- @name getDepth
    function this:getDepth()
        return self.depth;
    end

    ---
    -- Depth 値を設定する
    -- @param value (integer) Depth 値
    -- @name setDepth
    function this:setDepth( value )
        self.depth = value;
    end

    ---
    -- Duration 値を取得する
    -- @return (integer) Duration 値
    -- @name getDuration
    function this:getDuration()
        return self.duration;
    end

    ---
    -- Duration 値を設定する
    -- @param value (integer) Duration 値
    -- @name setDuration
    function this:setDuration( value )
        self.duration = value;
    end

    ---
    -- Rate のビブラートカーブを取得する
    -- @return (VibratoBPList) Rate のビブラートカーブ
    -- @name getRateBP
    function this:getRateBP()
        return self.rateBP;
    end

    ---
    -- Rate のビブラートカーブを設定する
    -- @param value (VibratoBPList) 設定するビブラートカーブ
    -- @name setRateBP
    function this:setRateBP( value )
        self.rateBP = value;
    end

    ---
    -- Depth のビブラートカーブを取得する
    -- @return (VibratoBPList) Depth のビビラートカーブ
    -- @name getDepthBP
    function this:getDepthBP()
        return self.depthBP;
    end

    ---
    -- Depth のビブラートカーブを設定する
    -- @param value (VibratoBPList) 設定するビブラートカーブ
    -- @name setDepthBP
    function this:setDepthBP( value )
        self.depthBP = value;
    end

    ---
    -- Rate の開始値を取得する
    -- @return (integer) Rate の開始値
    -- @name getStartRate
    function this:getStartRate()
        return self.startRate;
    end

    ---
    -- Rate の開始値を設定する
    -- @param value (integer) Rate の開始値
    -- @name setStartRate
    function this:setStartRate( value )
        self.startRate = value;
    end

    ---
    -- Depth の開始値を取得する
    -- @return (integer) Depth の開始値
    -- @name getStartDepth
    function this:getStartDepth()
        return self.startDepth;
    end

    ---
    -- Depth の開始値を設定する
    -- @param value (integer) Depth の開始値
    -- @name setStartDepth
    function this:setStartDepth( value )
        self.startDepth = value;
    end

    ---
    -- 指定した位置にある歌詞を取得する
    -- @param index (integer) 取得する要素のインデックス(最初のインデックスは0)
    -- @return (Lyric) 歌詞
    -- @name getLyricAt
    function this:getLyricAt( index )
        return self.lyrics[index + 1];
    end

    ---
    -- 指定した位置にある歌詞を指定した要素で置き換える
    -- @param index (integer) 置き換える要素のインデックス(最初のインデックスは0)
    -- @param value (Lyric) 置き換える要素
    -- @name setLyricAt
    function this:setLyricAt( index, value )
        if( index + 1 >= #self.lyrics )then
            local remain = index + 1 - #self.lyrics;
            local i;
            for i = 1, remain, 1 do
                table.insert( self.lyrics, false );
            end
        end
        self.lyrics[index + 1] = value;
    end

    ---
    -- 歌詞の個数を返す
    -- @return (integer) 歌詞の個数
    -- @name size
    function this:size()
        return #self.lyrics;
    end

    ---
    -- Display String 値を取得する
    -- @return (string) Display String 値
    -- @name getDisplayString
    function this:getDisplayString()
        return self.ids .. self.caption;
    end

    ---
    -- ハンドルのタイプを取得する
    -- @return (HandleTypeEnum) ハンドルのタイプ
    -- @name getHandleType
    function this:getHandleType()
        return self._type;
    end

    ---
    -- ストリームに書き込む
    -- @param stream (TextStream) 書き込み先のストリーム
    -- @name write
    function this:write( stream )
        stream:writeLine( self:toString() );
    end

    ---
    -- オブジェクトを文字列に変換する
    -- @return (string) 文字列
    -- @name toString
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

    ---
    -- コピーを作成する
    -- @return (Handle) このオブジェクトのコピー
    -- @name clone
    function this:clone()
        if( self._type == HandleTypeEnum.Dynamics )then
            local ret = Handle.new( HandleTypeEnum.Dynamics );
            ret.iconId = self.iconId;
            ret.ids = self.ids;
            ret.original = self.original;
            ret:setCaption( self:getCaption() );
            ret:setStartDyn( self:getStartDyn() );
            ret:setEndDyn( self:getEndDyn() );
            if( nil ~= self.dynBP )then
                ret:setDynBP( self.dynBP:clone() );
            end
            ret:setLength( self:getLength() );
            return ret;
        elseif( self._type == HandleTypeEnum.Lyric )then
            local result = Handle.new( HandleTypeEnum.Lyric );
            result.index = self.index;
            result.lyrics = {};
            for i = 1, #self.lyrics, 1 do
                local buf = self.lyrics[i]:clone();
                table.insert( result.lyrics, buf );
            end
            return result;
        elseif( self._type == HandleTypeEnum.NoteHead )then
            local result = Handle.new( HandleTypeEnum.NoteHead );
            result.index = self.index;
            result.iconId = self.iconId;
            result.ids = self.ids;
            result.original = self.original;
            result:setCaption( self:getCaption() );
            result:setLength( self:getLength() );
            result:setDuration( self:getDuration() );
            result:setDepth( self:getDepth() );
            return result;
        elseif( self._type == HandleTypeEnum.Singer )then
            local ret = Handle.new( HandleTypeEnum.Singer );
            ret.caption = self.caption;
            ret.iconId = self.iconId;
            ret.ids = self.ids;
            ret.index = self.index;
            ret.language = self.language;
            ret:setLength( self.length );
            ret.original = self.original;
            ret.program = self.program;
            return ret;
        elseif( self._type == HandleTypeEnum.Vibrato )then
            local result = Handle.new( HandleTypeEnum.Vibrato );
            result.index = self.index;
            result.iconId = self.iconId;
            result.ids = self.ids;
            result.original = self.original;
            result:setCaption( self.caption );
            result:setLength( self:getLength() );
            result:setStartDepth( self.startDepth );
            if( nil ~= self.depthBP )then
                result:setDepthBP( self.depthBP:clone() );
            end
            result:setStartRate( self.startRate );
            if( nil ~= self.rateBP )then
                result:setRateBP( self.rateBP:clone() );
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
-- @param string (string) ハンドル指定子
-- @return (integer) ハンドル番号
-- @name <i>getHandleIndexFromString</i>
function Handle.getHandleIndexFromString( _string )
    local spl = Util.split( _string, "#" );
    return tonumber( spl[2], 10 );
end
