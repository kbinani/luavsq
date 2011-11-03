--[[
  Lyric.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( not luavsq )then
    luavsq = {};
end

if( not luavsq.Lyric )then

    if( not luavsq.Util )then
        dofile( "Util.lua" )
    end

    luavsq.Lyric = {};

    ---
    -- overload1
    -- 歌詞、発音記号を指定したコンストラクタ
    -- @param phrase String 歌詞
    -- @param phonetic_symbol String 発音記号
    -- overload2
    -- 文字列(ex."a","a",0.0000,0.0)からのコンストラクタ
    luavsq.Lyric.new = function( ... )
        local arguments = { ... }
        local this = {};
        this.Phrase = "a";
        this.UnknownFloat = 1.0;
        this.m_consonant_adjustment = {};
        this.isProtected = false;
        this.m_phonetic_symbol = {};

        ---
        -- @param line String
        function this:_init_1( line )
            if( line == nil or (line ~= nil and line:len() == 0) )then
                self.Phrase = "a";
                self:setPhoneticSymbol( "a" );
                self.UnknownFloat = 1.0;
                self.isProtected = false;
                self:setConsonantAdjustment( "0" );
                return;
            end
            local len = line:len();
            local indx = 0;
            local dquote_count = 0;
            local work = "";
            local consonant_adjustment = "";
            for i = 1, len, 1 do
                local c = line:sub( i, i );
                if( c == ',' )then
                    if( dquote_count % 2 == 0 )then
                        -- ,の左側に偶数個の"がある場合→,は区切り文字
                        indx = indx + 1;
                        local search = "\"";
                        if( indx == 1 )then
                            -- Phrase
                            work = work:gsub( "\"\"", "\"" );  -- "は""として保存される
                            if( work:find( search ) == 0 and work.lastIndexOf( search ) == (work.length - search.length) )then
                                local l = work:len();
                                if( l > 2 )then
                                    self.Phrase = work:sub( 1, l - 3 );
                                else
                                    self.Phrase = "a";
                                end
                            else
                                self.Phrase = work;
                            end
                            work = "";
                        elseif( indx == 2 )then
                            -- symbols
                            local symbols = "";
                            if( (work:find( search ) == 0) and (work.lastIndexOf( search ) == (work.length - search.length)) )then
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
                            -- UnknownFloat
                            self.UnknownFloat = work + 0.0;
                            work = "";
                        else
                            if( indx - 4 < #self.m_phonetic_symbol )then
                                -- consonant adjustment
                                if( indx - 4 == 0 )then
                                    consonant_adjustment = consonant_adjustment .. work;
                                else
                                    consonant_adjustment = consonant_adjustment .. "," .. work;
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
            self:setConsonantAdjustment( consonant_adjustment );
        end

        ---
        -- @param phrase String
        -- @param phoneticSymbol String
        this._init_2 = function( self, phrase, phoneticSymbol )
            self.Phrase = phrase;
            self:setPhoneticSymbol( phoneticSymbol );
            self.UnknownFloat = 0.0;
            self.m_consonant_adjustment = {};
            self.isProtected = false;
        end

        ---
        -- このオブジェクトのインスタンスと、指定されたアイテムが同じかどうかを調べます。
        -- 音声合成したときに影響のある範囲のフィールドしか比較されません。
        -- たとえば、isProtectedがthisとitemで違っていても、他が同一であればtrueが返る。
        -- @param item [Lyric]
        -- @return [bool]
        this.equalsForSynth = function( self, item )
            if( self.isProtected ~= item.isProtected )then
                return false;
            end
            if( self:getPhoneticSymbol() ~= item:getPhoneticSymbol() )then
                return false;
            end
            if( self:getConsonantAdjustment() ~= item:getConsonantAdjustment() )then
                return false;
            end
            return true;
        end

        ---
        -- このオブジェクトのインスタンスと、指定されたオブジェクトが同じかどうかを調べます。
        -- @param item [Lyric]
        -- @return [bool]
        this.equals = function( self, item )
            if( not self:equalsForSynth( item ) )then
                return false;
            end
            if( self.Phrase ~= item.Phrase )then
                return false;
            end
            if( self.UnknownFloat ~= item.UnknownFloat )then
                return false;
            end
            return true;
        end

        ---
        -- Consonant Adjustmentの文字列形式を取得します。
        -- @return [String]
        this.getConsonantAdjustment = function( self )
            local arr = self:getConsonantAdjustmentList();
            if( #arr == 0 )then
                return "";
            end
            local ret = arr[1];
            for i = 2, #arr, 1 do
                ret = ret .. " " .. arr[i];
            end
            return ret;
        end

        ---
        -- Consonant Adjustmentを文字列形式で設定します。
        -- @param value [String]
        -- @return [void]
        this.setConsonantAdjustment = function( self, value )
            local spl = luavsq.Util.split( value, "," );
            local arr = luavsq.Util.array( #spl );
            for i = 1, #spl, 1 do
                arr[i] = spl[i];
            end
            self:setConsonantAdjustmentList( arr );
        end

        ---
        -- Consonant Adjustmentを、整数配列で取得します。
        -- @return int[]
        this.getConsonantAdjustmentList = function( self )
            if( self.m_consonant_adjustment == nil )then
                if( self.m_phonetic_symbol == nil )then
                    self.m_consonant_adjustment = {};
                else
                    self.m_consonant_adjustment = luavsq.Util.array( #self.m_phonetic_symbol );
                    for i = 1, #self.m_phonetic_symbol, 1 do
                        local consonantAdjustment;
                        if( luavsq.VsqPhoneticSymbol.isConsonant( self.m_phonetic_symbol[i] ) )then
                            consonantAdjustment = 64;
                        else
                            consonantAdjustment = 0;
                        end
                        self.m_consonant_adjustment[i] = consonantAdjustment;
                    end
                end
            end
            return self.m_consonant_adjustment;
        end

        ---
        -- Consonant Adjustmentを、整数配列形式で設定します。
        -- @param value int[]
        this.setConsonantAdjustmentList = function( self, value )
            if( value == nil )then
                return;
            end
            self.m_consonant_adjustment = luavsq.Util.array( #value );
            for i = 1, #value, 1 do
                self.m_consonant_adjustment[i] = value[i];
            end
        end

        ---
        -- このオブジェクトの簡易コピーを取得します。
        -- @return [object] このインスタンスの簡易コピー
        this.clone = function( self )
            local result = luavsq.Lyric.new();
            result.Phrase = self.Phrase;
            result.m_phonetic_symbol = luavsq.Util.array( #self.m_phonetic_symbol );
            for i = 1, #self.m_phonetic_symbol, 1 do
                result.m_phonetic_symbol[i] = self.m_phonetic_symbol[i];
            end
            result.UnknownFloat = self.UnknownFloat;
            if( self.m_consonant_adjustment ~= nil )then
                result.m_consonant_adjustment = luavsq.Util.array( #self.m_consonant_adjustment );
                for i = 1, #self.m_consonant_adjustment, 1 do
                    result.m_consonant_adjustment[i] = self.m_consonant_adjustment[i];
                end
            end
            result.isProtected = self.isProtected;
            return result;
        end

        ---
        -- この歌詞の発音記号を取得します。
        -- @return [String]
        this.getPhoneticSymbol = function( self )
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
        -- この歌詞の発音記号を設定します。
        -- @param value [String]
        -- @return [void]
        this.setPhoneticSymbol = function( self, value )
            local s = value:gsub( "  ", " " );
            self.m_phonetic_symbol = luavsq.Util.split( s, " " );
            for i = 1, #self.m_phonetic_symbol, 1 do
                self.m_phonetic_symbol[i] = self.m_phonetic_symbol[i]:gsub( "\\" .. "\\", "\\" );
            end
        end

        ---
        -- @return String[]
        this.getPhoneticSymbolList = function( self )
            local ret = luavsq.Util.array( #self.m_phonetic_symbol );
            for i = 1, #self.m_phonetic_symbol, 1 do
                ret[i] = self.m_phonetic_symbol[i];
            end
            return ret;
        end

        ---
        -- このインスタンスを文字列に変換します
        -- @param add_quatation_mark [bool]
        -- @return 変換後の文字列 [String]
        this.toString = function( self, add_quatation_mark )
            local quot;
            if( add_quatation_mark )then
                quot = "\"";
            else
                quot = "";
            end
            local result;
            result = quot + self.Phrase + quot + ",";
            local symbol = self.getPhoneticSymbolList();
            local strSymbol = self.getPhoneticSymbol();
            if( not add_quatation_mark )then
                if( (strSymbol == null) or (strSymbol ~= null and strSymbol == "" ) )then
                    strSymbol = "u:";
                end
            end
            result = result .. quot .. strSymbol .. quot .. "," .. self.UnknownFloat;
            result = result:gsub( "\\" .. "\\", "\\" );
            if( self.m_consonant_adjustment == nil )then
                self.m_consonant_adjustment = luavsq.Util.array( #symbol );
                for i = 1, #symbol, 1 do
                    local consonantAdjustment;
                    if( luavsq.VsqPhoneticSymbol.isConsonant( symbol[i] ) )then
                        consonantAdjustment = 64;
                    else
                        consonantAdjustment = 0;
                    end
                    self.m_consonant_adjustment[i] = consonantAdjustment;
                end
            end
            for i = 1, #self.m_consonant_adjustment, 1 do
                result = result .. "," .. self.m_consonant_adjustment[i];
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
end
