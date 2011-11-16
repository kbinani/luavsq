--[[
  SingerHandle.lua
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

if( nil == luavsq.SingerHandle )then

    ---
    -- 歌手設定を表します。
    luavsq.SingerHandle = {};

    ---
    -- 新しい歌手設定のインスタンスを初期化します。
    function luavsq.SingerHandle.new()
        local this = {};

        ---
        -- キャプション。
        this.caption = "";

        ---
        -- この歌手設定を一意に識別するための ID です。
        this.iconId = "";

        ---
        -- ユーザ・フレンドリー名。
        -- このフィールドの値は、他の歌手設定のユーザ・フレンドリー名と重複する場合があります。
        this.ids = "";

        this.index = 0;

        ---
        -- ゲートタイム長さ。
        this.length = 0;

        this.original = 0;
        this.program = 0;
        this.language = 0;

        ---
        -- ゲートタイム長さを取得します。
        -- @return [int]
        function this:getLength()
            return self.length;
        end

        ---
        -- ゲートタイム長さを設定します。
        -- @param value [int]
        -- @return [void]
        function this:setLength( value )
            self.length = value;
        end

        ---
        -- このインスタンスと、指定された歌手変更のインスタンスが等しいかどうかを判定します。
        -- @param item (luavsq.SingerHandle) 比較対象の歌手変更。
        -- @returns [bool] このインスタンスと、比較対象の歌手変更が等しければtrue、そうでなければfalseを返します。
        function this:equals( item )
            if( nil == item )then
                return false;
            else
                return self.iconId == item.iconId;
            end
        end

        ---
        -- このインスタンスのコピーを作成します。
        -- @return [object]
        function this:clone()
            local ret = luavsq.SingerHandle.new();
            ret.caption = self.caption;
            ret.iconId = self.iconId;
            ret.ids = self.ids;
            ret.index = self.index;
            ret.language = self.language;
            ret:setLength( self.length );
            ret.original = self.original;
            ret.program = self.program;
            return ret;
        end

        ---
        -- この歌手設定のインスタンスを、Handleに型キャストします。
        -- @return (luavsq.Handle)
        function this:castToHandle()
            local ret = luavsq.Handle.new();
            ret._type = luavsq.HandleTypeEnum.Singer;
            ret.caption = self.caption;
            ret.iconId = self.iconId;
            ret.ids = self.ids;
            ret.index = self.index;
            ret.language = self.language;
            ret:setLength( self.length );
            ret.program = self.program;
            ret.original = self.original;
            return ret;
        end

        return this;
    end

end
