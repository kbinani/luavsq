--[[
  SingerHandle.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.SingerHandle )then

    ---
    -- 歌手ハンドルを表すクラス
    -- @class table
    -- @name SingerHandle
    luavsq.SingerHandle = {};

    ---
    -- 初期化を行う
    -- @return (SingerHandle)
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
        -- 長さを取得する
        -- @return (integer) Tick 単位の長さ
        function this:getLength()
            return self.length;
        end

        ---
        -- 長さを設定する
        -- @param value (integer) Tick 単位の長さ
        function this:setLength( value )
            self.length = value;
        end

        ---
        -- このオブジェクトのインスタンスと、指定されたオブジェクトが同じかどうかを調べる
        -- @param item (SingerHandle) 比較対象のオブジェクト
        -- @return (boolean) 比較対象と同じであれば true を、そうでなければ false を返す
        function this:equals( item )
            if( nil == item )then
                return false;
            else
                return self.iconId == item.iconId;
            end
        end

        ---
        -- コピーを作成する
        -- @return (SingerHandle) このオブジェクトのコピー
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
        -- このオブジェクトを、Handle に型変換する
        -- @return (luavsq.Handle) ハンドル
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
