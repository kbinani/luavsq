--[[
  Lyric.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local tonumber = tonumber;

module( "luavsq" );

---
-- 歌詞ハンドルに格納する歌詞情報を保持するクラス
-- @class table
-- @name Lyric
Lyric = {};

--
-- 初期化を行う
-- @return (Lyric)
function Lyric.new( ... )
    local arguments = { ... }
    local this = {};

    ---
    -- 歌詞
    -- @var string
    this.phrase = "a";

    ---
    -- 歌詞ハンドル内に複数の歌詞が入る場合の、この歌詞の長さ分率。デフォルトは 1.0
    -- @var double
    this.lengthRatio = 1.0;

    ---
    -- 発音記号がプロテクトされた状態かどうか
    -- @var boolean
    this.isProtected = false;

    this._phoneticSymbol = { "a" };
    this._consonantAdjustment = { 0 };

    ---
    -- 文字列を元に初期化を行う
    -- @param line (string) 「"あ","a",0.0000,0.0」などのような文字列
    -- @return (Lyric)
    -- @name new<!--1-->
    -- @access static ctor
    function this:_init_1( line )
        if( line == nil or (line ~= nil and line:len() == 0) )then
            self.phrase = "a";
            self:setPhoneticSymbol( "a" );
            self.lengthRatio = 1.0;
            self.isProtected = false;
            self:setConsonantAdjustment( "0" );
            return;
        end
        local len = line:len();
        local indx = 0;
        local dquote_count = 0;
        local work = "";
        local consonantAdjustment = "";
        for i = 1, len, 1 do
            local c = line:sub( i, i );
            if( c == ',' or i == len )then
                if( i == len )then
                    work = work .. c;
                end
                if( dquote_count % 2 == 0 )then
                    -- ,の左側に偶数個の"がある場合→,は区切り文字
                    indx = indx + 1;
                    local search = "\"";
                    if( indx == 1 )then
                        -- phrase
                        work = work:gsub( "\"\"", "\"" );  -- "は""として保存される
                        if( work:find( search ) == 0 and work.lastIndexOf( search ) == (work:len() - search:len()) )then
                            local l = work:len();
                            if( l > 2 )then
                                self.phrase = work:sub( 1, l - 3 );
                            else
                                self.phrase = "a";
                            end
                        else
                            self.phrase = work;
                        end
                        work = "";
                    elseif( indx == 2 )then
                        -- symbols
                        local symbols = "";
                        if( (work:find( search ) == 0) and (work.lastIndexOf( search ) == (work:len() - search:len())) )then
                            local l = work:len();
                            if( l > 2 )then
                                symbols = work:sub( 1, l - 3 );
                            else
                                symbols = "a";
                            end
                        else
                            symbols = work;
                        end
                        self:setPhoneticSymbol( symbols );
                        work = "";
                    elseif( indx == 3 )then
                        -- lengthRatio
                        self.lengthRatio = work + 0.0;
                        work = "";
                    else
                        if( indx - 3 <= #self._phoneticSymbol )then
                            -- consonant adjustment
                            if( indx - 3 == 1 )then
                                consonantAdjustment = consonantAdjustment .. work;
                            else
                                consonantAdjustment = consonantAdjustment .. "," .. work;
                            end
                        else
                            -- protected
                            self.isProtected = (work == "1");
                        end
                        work = "";
                    end
                else
                    -- ,の左側に奇数個の"がある場合→,は歌詞等の一部
                    work = work .. "" .. c;
                end
            else
                work = work .. "" .. c;
                if( c == '"' )then
                    dquote_count = dquote_count + 1;
                end
            end
        end
        self:setConsonantAdjustment( consonantAdjustment );
    end

    ---
    -- 歌詞、発音記号を指定して初期化を行う
    -- @param phrase (string) 歌詞
    -- @param phoneticSymbol (string) 発音記号
    -- @return (Lyric)
    -- @name new<!--2-->
    -- @access static ctor
    function this:_init_2( phrase, phoneticSymbol )
        self.phrase = phrase;
        self._consonantAdjustment = nil;
        self:setPhoneticSymbol( phoneticSymbol );
        self.lengthRatio = 1.0;
        self.isProtected = false;
    end

    ---
    -- このオブジェクトと、指定されたオブジェクトが同じかどうかを調べる。
    -- 音声合成したときに影響のある範囲のフィールドしか比較されない。
    -- たとえば、isProtectedがthisとitemで違っていても、他が同一であればtrueが返る。
    -- @param item (Lyric) 比較対象のオブジェクト
    -- @return (boolean) 比較対象と同じであれば true を、そうでなければ false を返す
    -- @name equalsForSynth
    function this:equalsForSynth( item )
        if( self:getPhoneticSymbol() ~= item:getPhoneticSymbol() )then
            return false;
        end
        if( self:getConsonantAdjustment() ~= item:getConsonantAdjustment() )then
            return false;
        end
        return true;
    end

    ---
    -- このオブジェクトのインスタンスと、指定されたオブジェクトが同じかどうかを調べる
    -- @param item (Lyric) 比較対象のオブジェクト
    -- @return (boolean) 比較対象と同じであれば true を、そうでなければ false を返す
    -- @name equals
    function this:equals( item )
        if( not self:equalsForSynth( item ) )then
            return false;
        end
        if( self.isProtected ~= item.isProtected )then
            return false;
        end
        if( self.phrase ~= item.phrase )then
            return false;
        end
        if( self.lengthRatio ~= item.lengthRatio )then
            return false;
        end
        return true;
    end

    ---
    -- Consonant Adjustmentの文字列形式を取得する
    -- @return (string) Consonant Adjustment を空白区切りで連結した文字列
    -- @name getConsonantAdjustment
    function this:getConsonantAdjustment()
        local arr = self:getConsonantAdjustmentList();
        if( #arr == 0 )then
            return "";
        end
        local ret = arr[1];
        for i = 2, #arr, 1 do
            ret = ret .. " " .. arr[i];
        end
        return "" .. ret;
    end

    ---
    -- Consonant Adjustmentを文字列形式で設定する
    -- @param value (string) Consonant Adjustment を空白区切りで連結した文字列
    -- @name setConsonantAdjustment
    function this:setConsonantAdjustment( value )
        local spl = Util.split( value, "," );
        local arr = Util.array( #spl );
        for i = 1, #spl, 1 do
            arr[i] = tonumber( spl[i] );
        end
        self:setConsonantAdjustmentList( arr );
    end

    ---
    -- Consonant Adjustment を、整数配列で取得する
    -- @return (table<integer>) Consonant Adjustment を格納した整数の配列
    -- @name getConsonantAdjustmentList
    function this:getConsonantAdjustmentList()
        if( self._consonantAdjustment == nil )then
            if( self._phoneticSymbol == nil )then
                self._consonantAdjustment = {};
            else
                self._consonantAdjustment = Util.array( #self._phoneticSymbol );
                for i = 1, #self._phoneticSymbol, 1 do
                    local consonantAdjustment;
                    if( PhoneticSymbol.isConsonant( self._phoneticSymbol[i] ) )then
                        consonantAdjustment = 64;
                    else
                        consonantAdjustment = 0;
                    end
                    self._consonantAdjustment[i] = consonantAdjustment;
                end
            end
        end
        return self._consonantAdjustment;
    end

    ---
    -- Consonant Adjustment を、整数配列形式で設定する
    -- @param value (table<integer>) Consonant Adjustment を格納した整数の配列
    -- @name setConsonantAdjustmentList
    function this:setConsonantAdjustmentList( value )
        if( value == nil )then
            return;
        end
        self._consonantAdjustment = Util.array( #value );
        for i = 1, #value, 1 do
            self._consonantAdjustment[i] = value[i];
        end
    end

    ---
    -- コピーを作成する
    -- @return (Lyric) このインスタンスのコピー
    -- @name clone
    function this:clone()
        local result = Lyric.new();
        result.phrase = self.phrase;
        result._phoneticSymbol = Util.array( #self._phoneticSymbol );
        for i = 1, #self._phoneticSymbol, 1 do
            result._phoneticSymbol[i] = self._phoneticSymbol[i];
        end
        result.lengthRatio = self.lengthRatio;
        if( nil == self._consonantAdjustment )then
            result._consonantAdjustment = nil;
        else
            result._consonantAdjustment = Util.array( #self._consonantAdjustment );
            for i = 1, #self._consonantAdjustment, 1 do
                result._consonantAdjustment[i] = self._consonantAdjustment[i];
            end
        end
        result.isProtected = self.isProtected;
        return result;
    end

    ---
    -- この歌詞の発音記号を取得する
    -- @return (string) 発音記号
    -- @name getPhoneticSymbol
    function this:getPhoneticSymbol()
        local symbol = self:getPhoneticSymbolList();
        if( #symbol == 0 )then
            return "";
        end
        local result = symbol[1];
        for i = 2, #symbol, 1 do
            result = result .. " " .. symbol[i];
        end
        return result;
    end

    ---
    -- この歌詞の発音記号を設定する
    -- @param value (string) 発音記号
    -- @name setPhoneticSymbol
    function this:setPhoneticSymbol( value )
        local s = value:gsub( "  ", " " );
        self._phoneticSymbol = Util.split( s, " " );
        for i = 1, #self._phoneticSymbol, 1 do
            self._phoneticSymbol[i] = self._phoneticSymbol[i]:gsub( "\\" .. "\\", "\\" );
        end
    end

    ---
    -- この歌詞の発音記号の配列を取得する
    -- @return (table<string>) 発音記号の配列
    -- @name getPhoneticSymbolList
    function this:getPhoneticSymbolList()
        local ret = Util.array( #self._phoneticSymbol );
        for i = 1, #self._phoneticSymbol, 1 do
            ret[i] = self._phoneticSymbol[i];
        end
        return ret;
    end

    ---
    -- このインスタンスを文字列に変換する
    -- @param addQuateMark (boolean) 歌詞、発音記号の前後に引用符(")を追加するかどうか
    -- @return (string) 変換後の文字列
    -- @name toString
    function this:toString( addQuateMark )
        local quot;
        if( addQuateMark )then
            quot = "\"";
        else
            quot = "";
        end
        local result;
        result = quot .. self.phrase .. quot .. ",";
        local symbol = self:getPhoneticSymbolList();
        local strSymbol = self:getPhoneticSymbol();
        if( not addQuateMark )then
            if( (strSymbol == nil) or (strSymbol ~= nil and strSymbol == "" ) )then
                strSymbol = "u:";
            end
        end
        result = result .. quot .. strSymbol .. quot .. "," .. self.lengthRatio;
        result = result:gsub( "\\" .. "\\", "\\" );
        if( self._consonantAdjustment == nil )then
            self._consonantAdjustment = Util.array( #symbol );
            for i = 1, #symbol, 1 do
                local consonantAdjustment;
                if( PhoneticSymbol.isConsonant( symbol[i] ) )then
                    consonantAdjustment = 64;
                else
                    consonantAdjustment = 0;
                end
                self._consonantAdjustment[i] = consonantAdjustment;
            end
        end
        for i = 1, #self._consonantAdjustment, 1 do
            result = result .. "," .. self._consonantAdjustment[i];
        end
        if( self.isProtected )then
            result = result .. ",1";
        else
            result = result .. ",0";
        end
        return result;
    end

    if( #arguments == 1 )then
        this:_init_1( arguments[1] );
    elseif( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    end

    return this;
end
