--[[
  LyricHandle.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

-- requires( VsqHandleTypeEnum.lua )
-- requires( VsqHandle.lua )
-- requires( Lyric.lua )

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.LyricHandle )then

    ---
    -- 歌詞ハンドル
    -- @class table
    -- @name luavsq.LyricHandle
    luavsq.LyricHandle = {};

    ---
    -- 初期化を行う
    -- @param phrase (string) 歌詞
    -- @param phoneticSymbol (string) 発音記号
    -- @return (luavsq.LyricHandle)
    function luavsq.LyricHandle.new( ... )
        local arguments = { ... };
        local this = {};
        this.articulation = luavsq.ArticulationTypeEnum.Vibrato;

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
        -- 指定した位置にある歌詞を取得する
        -- @param index (integer) 取得する要素のインデックス(最初のインデックスは0)
        -- @return (luavsq.Lyric) 歌詞
        function this:getLyricAt( index )
            return self.lyrics[index + 1];
        end

        ---
        -- 指定した位置にある歌詞を指定した要素で置き換える
        -- @param index (integer) 置き換える要素のインデックス(最初のインデックスは0)
        -- @param value (luavsq.Lyric) 置き換える要素
        function this:setLyricAt( index, value )
            self.lyrics[index + 1] = value;
        end

        ---
        -- 歌詞の個数を返す
        -- @return (integer) 歌詞の個数
        function this:size()
            return #self.lyrics;
        end

        ---
        -- コピーを作成する
        -- @return (luavsq.LyricHandle) このオブジェクトのコピー
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
        -- このオブジェクトを Handle に型変換する
        -- @return (luavsq.Handle) 変換後の Handle
        function this:castToHandle()
            local result = luavsq.Handle.new();
            result._type = luavsq.HandleTypeEnum.Lyric;
            result.lyrics = self.lyrics;
            result.index = self.index;
            return result;
        end

        return this;
    end

end
