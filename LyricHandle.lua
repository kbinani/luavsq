--[[
  LyricHandle.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

-- requires( VsqHandleType.lua )
-- requires( VsqHandle.lua )
-- requires( Lyric.lua )

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.LyricHandle )then

    luavsq.LyricHandle = {};

    ---
    -- type = Lyric用のhandleのコンストラクタ
    -- @param phrase (string) 歌詞
    -- @param phoneticSymbol (string) 発音記号
    function luavsq.LyricHandle.new( ... )
        local arguments = { ... };
        local this = {};
        this.articulation = luavsq.ArticulationType.Vibrato;

        ---
        -- @var index (integer)
        this.index = 0;

        ---
        -- @var lyrics (table<luavsq.Lyric>)
        this.lyrics = {};

        if( #arguments >= 2 )then
            local phrase = arguments[1];
            local phoneticSymbol = arguments[2];
            this.lyrics[1] = luavsq.Lyric.new( phrase, phoneticSymbol );
        else
            this.lyrics[1] = luavsq.Lyric.new();
        end

        ---
        -- @param index (integer) 0 から始まるインデックス
        -- @return (luavsq.Lyric)
        function this:getLyricAt( index )
            return self.lyrics[index + 1];
        end

        ---
        -- @param index (integer) 0 から始まるインデックス
        -- @param value (luavsq.Lyric)
        function this:setLyricAt( index, value )
            self.lyrics[index + 1] = value;
        end

        ---
        -- @return (integer)
        function this:getCount()
            return #self.lyrics;
        end

        ---
        -- @return (luavsq.LyricHandle)
        function this:clone()
            local result = luavsq.LyricHandle.new();
            result.index = self.index;
            result.lyrics = {};
            for i = 1, #self.lyrics, 1 do
                local buf = self.lyrics[i]:clone();
                table.insert( result.lyrics, buf );
            end
            return result;
        end

        ---
        -- @return (luavsq.Handle)
        function this:castToHandle()
            local result = luavsq.Handle.new();
            result._type = luavsq.HandleType.Lyric;
            result.lyrics = self.lyrics;
            result.index = self.index;
            return result;
        end

        return this;
    end

end
