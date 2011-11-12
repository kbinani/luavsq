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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.Handle )then

    ---
    -- ハンドルを取り扱います。ハンドルにはLyricHandle、VibratoHandle、IconHandleおよびNoteHeadHandleがある
    luavsq.Handle = {};

    function luavsq.Handle.new( ... )
        local arguments = { ... };
        local this = {};
        this._type = luavsq.HandleType.Lyric;
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
        -- 歌詞・発音記号列の前後にクォーテーションマークを付けるかどうか
        this.addQuotationMark = true;

        ---
        -- @return [int]
        function this:getLength()
            return self.length;
        end

        ---
        -- @param value [int]
        -- @return [void]
        function this:setLength( value )
            self.length = value;
        end

        ---
        -- @return (luavsq.LyricHandle)
        function this:castToLyricHandle()
            local ret = luavsq.LyricHandle.new();
            ret.index = self.index;
            ret.lyrics = self.lyrics;
            return ret;
        end

        ---
        -- @return (luavsq.VibratoHandle)
        function this:castToVibratoHandle()
            local ret = luavsq.VibratoHandle.new();
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
        -- @return [IconHandle]
        function this:castToIconHandle()
            local ret = luavsq.IconHandle.new();
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
        -- @return [NoteHeadHandle]
        function this:castToNoteHeadHandle()
            local ret = luavsq.NoteHeadHandle.new();
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
        -- @return [IconDynamicsHandle]
        function this:castToIconDynamicsHandle()
            local ret = luavsq.IconDynamicsHandle.new();
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
        -- インスタンスをストリームに書き込みます。
        -- encode=trueの場合、2バイト文字をエンコードして出力します。
        -- @param sw [ITextWriter] 書き込み対象
        function this:write( sw )
            sw:writeLine( self:toString() );
        end

        ---
        -- FileStreamから読み込みながらコンストラクト
        -- @param sr [TextStream]読み込み対象
        -- @param index [int]
        -- @param last_line [ByRef<string>]
        function this:_init_3( sr, index, last_line )
            self.index = index;
            local spl;
            local spl2;

            -- default値で埋める
            self._type = luavsq.HandleType.Vibrato;
            self.iconId = "";
            self.ids = "normal";
            self.lyrics = { luavsq.Lyric.new( "" ) };
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
                spl = luavsq.Util.split( last_line.value, '=' );
                local search = spl[1];
                if( search == "Language" )then
                    self._type = luavsq.HandleType.Singer;
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
                    self._type = luavsq.HandleType.Vibrato;
                    self.startRate = tonumber( spl[2], 10 );
                elseif( search == "RateBPNum" )then
                    tmpRateBPNum = spl[2];
                elseif( search == "RateBPX" )then
                    tmpRateBPX = spl[2];
                elseif( search == "RateBPY" )then
                    tmpRateBPY = spl[2];
                elseif( search == "Duration" )then
                    self._type = luavsq.HandleType.NoteHead;
                    self.duration = tonumber( spl[2], 10 );
                elseif( search == "Depth" )then
                    self.depth = tonumber( spl[2], 10 );
                elseif( search == "StartDyn" )then
                    self._type = luavsq.HandleType.Dynamics;
                    self.startDyn = tonumber( spl[2], 10 );
                elseif( search == "EndDyn" )then
                    self._type = luavsq.HandleType.Dynamics;
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
                        local lyric = luavsq.Lyric.new( spl[2] );
                        self._type = luavsq.HandleType.Lyric;
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
            if( self._type == luavsq.HandleType.Vibrato )then
                if( tmpRateBPNum ~= "" )then
                    self.rateBP = luavsq.VibratoBPList.new( tmpRateBPNum, tmpRateBPX, tmpRateBPY );
                else
                    self.rateBP = luavsq.VibratoBPList.new();
                end

                -- DepthBPX, DepthBPYの設定
                if( tmpDepthBPNum ~= "" )then
                    self.depthBP = luavsq.VibratoBPList.new( tmpDepthBPNum, tmpDepthBPX, tmpDepthBPY );
                else
                    self.depthBP = luavsq.VibratoBPList.new();
                end
            else
                self.depthBP = luavsq.VibratoBPList.new();
                self.rateBP = luavsq.VibratoBPList.new();
            end

            if( tmpDynBPNum ~= "" )then
                self.dynBP = luavsq.VibratoBPList.new( tmpDynBPNum, tmpDynBPX, tmpDynBPY );
            else
                self.dynBP = luavsq.VibratoBPList.new();
            end
        end

        ---
        -- インスタンスを文字列に変換します
        -- @return [string] インスタンスを変換した文字列
        function this:toString()
            local result = "";
            result = result .. "[h#" .. string.format( "%04d", self.index ) .. "]";
            if( self._type == luavsq.HandleType.Lyric )then
                for i = 1, #self.lyrics, 1 do
                    result = result .. "\n" .. "L" .. (i - 1) .. "=" .. self.lyrics[i]:toString( self.addQuotationMark );
                end
            elseif( self._type == luavsq.HandleType.Vibrato )then
                result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
                result = result .. "IDS=" .. self.ids .. "\n";
                result = result .. "Original=" .. self.original .. "\n";
                result = result .. "Caption=" .. self.caption .. "\n";
                result = result .. "Length=" .. self.length .. "\n";
                result = result .. "StartDepth=" .. self.startDepth .. "\n";
                result = result .. "DepthBPNum=" .. self.depthBP:size() .. "\n";
                if( self.depthBP:size() > 0 )then
                    result = result .. "DepthBPX=" .. string.format( "%.6f", self.depthBP:getElement( 0 ).x );
                    for i = 1, self.depthBP:size() - 1, 1 do
                        result = result .. "," .. string.format( "%.6f", self.depthBP:getElement( i ).x );
                    end
                    result = result .. "\n" .. "DepthBPY=" .. self.depthBP:getElement( 0 ).y;
                    for i = 1, self.depthBP:size() - 1, 1 do
                        result = result .. "," .. self.depthBP:getElement( i ).y;
                    end
                    result = result .. "\n";
                end
                result = result .. "StartRate=" .. self.startRate .. "\n";
                result = result .. "RateBPNum=" .. self.rateBP:size();
                if( self.rateBP:size() > 0 )then
                    result = result .. "\n" .. "RateBPX=" .. string.format( "%.6f", self.rateBP:getElement( 0 ).x );
                    for i = 1, self.rateBP:size() - 1, 1 do
                        result = result .. "," .. string.format( "%.6f", self.rateBP:getElement( i ).x );
                    end
                    result = result .. "\n" .. "RateBPY=" .. self.rateBP:getElement( 0 ).y;
                    for i = 1, self.rateBP:size() - 1, 1 do
                        result = result .. "," .. self.rateBP:getElement( i ).y;
                    end
                end
            elseif( self._type == luavsq.HandleType.Singer )then
                result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
                result = result .. "IDS=" .. self.ids .. "\n";
                result = result .. "Original=" .. self.original .. "\n";
                result = result .. "Caption=" .. self.caption .. "\n";
                result = result .. "Length=" .. self.length .. "\n";
                result = result .. "Language=" .. self.language .. "\n";
                result = result .. "Program=" .. self.program;
            elseif( self._type == luavsq.HandleType.NoteHead )then
                result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
                result = result .. "IDS=" .. self.ids .. "\n";
                result = result .. "Original=" .. self.original .. "\n";
                result = result .. "Caption=" .. self.caption .. "\n";
                result = result .. "Length=" .. self.length .. "\n";
                result = result .. "Duration=" .. self.duration .. "\n";
                result = result .. "Depth=" .. self.depth;
            elseif( self._type == luavsq.HandleType.Dynamics )then
                result = result .. "\n" .. "IconID=" .. self.iconId .. "\n";
                result = result .. "IDS=" .. self.ids .. "\n";
                result = result .. "Original=" .. self.original .. "\n";
                result = result .. "Caption=" .. self.caption .. "\n";
                result = result .. "StartDyn=" .. self.startDyn .. "\n";
                result = result .. "EndDyn=" .. self.endDyn .. "\n";
                result = result .. "Length=" .. self.length .. "\n";
                if( nil ~= self.dynBP )then
                    if( self.dynBP:size() <= 0 )then
                        result = result .. "DynBPNum=0";
                    else
                        local c = self.dynBP:size();
                        result = result .. "DynBPNum=" .. c .. "\n";
                        result = result .. "DynBPX=" .. string.format( "%.6f", self.dynBP:getElement( 0 ).x );
                        for i = 1, c - 1, 1 do
                            result = result .. "," .. string.format( "%.6f", self.dynBP:getElement( i ).x );
                        end
                        result = result .. "\n" .. "DynBPY=" .. self.dynBP:getElement( 0 ).y;
                        for i = 1, c - 1, 1 do
                            result = result .. "," .. self.dynBP:getElement( i ).y;
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
    -- ハンドル指定子（例えば"h#0123"という文字列）からハンドル番号を取得します
    -- @param _string [string] ハンドル指定子
    -- @return [int] ハンドル番号
    function luavsq.Handle.getHandleIndexFromString( _string )
        local spl = luavsq.Util.split( _string, "#" );
        return tonumber( spl[2], 10 );
    end

end
