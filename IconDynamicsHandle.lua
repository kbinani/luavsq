--[[
  IconDynamicsHandle.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the GPL version 3 License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

module( "luavsq" );

---
-- ダイナミクスハンドル
-- @class table
-- @name IconDynamicsHandle
IconDynamicsHandle = {};

---
-- 強弱記号の場合の、IconId の最初の5文字。
IconDynamicsHandle.ICONID_HEAD_DYNAFF = "$0501";

---
-- クレッシェンドの場合の、IconId の最初の5文字。
IconDynamicsHandle.ICONID_HEAD_CRESCEND = "$0502";

---
-- デクレッシェンドの場合の、IconId の最初の5文字。
IconDynamicsHandle.ICONID_HEAD_DECRESCEND = "$0503";

---
-- 初期化を行う
-- @return (IconDynamicsHandle)
function IconDynamicsHandle.new()
    local this = IconParameter.new();

    this.articulation = ArticulationTypeEnum.Dynaff;

    ---
    -- この強弱記号設定を一意に識別するためのIDです。
    this.iconId = "";

    ---
    -- ユーザ・フレンドリー名です。
    -- このフィールドの値は、他の強弱記号設定のユーザ・フレンドリー名と重複する場合があります。
    this.ids = "";

    ---
    -- この強弱記号設定が他の強弱記号設定から派生したものである場合、派生元を特定するための番号です。
    this.original = 0;

    ---
    -- このハンドルが強弱記号を表すものかどうかを表すブール値を取得する
    -- @return (boolean) このオブジェクトが強弱記号を表すものであれば true を、そうでなければ false を返す
    function this:isDynaffType()
        if( nil ~= self.iconId )then
            return self.iconId:find( IconDynamicsHandle.ICONID_HEAD_DYNAFF ) == 1;
        else
            return false;
        end
    end

    ---
    -- このハンドルがクレッシェンドを表すものかどうかを表すブール値を取得する
    -- @return (boolean) このオブジェクトがクレッシェンドを表すものであれば true を、そうでなければ false を返す
    function this:isCrescendType()
        if( nil ~= self.iconId )then
            return self.iconId:find( IconDynamicsHandle.ICONID_HEAD_CRESCEND ) == 1;
        else
            return false;
        end
    end

    ---
    -- このハンドルがデクレッシェンドを表すものかどうかを表すブール値を取得する
    -- @return (boolean) このオブジェクトがデクレッシェンドを表すものであれば true を、そうでなければ false を返す
    function this:isDecrescendType()
        if( nil ~= self.iconId )then
            return self.iconId:find( IconDynamicsHandle.ICONID_HEAD_DECRESCEND ) == 1;
        else
            return false;
        end
    end

    ---
    -- コピーを作成する
    -- @return (IconDynamicsHandle) このインスタンスのコピー
    function this:clone()
        local ret = IconDynamicsHandle.new();
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
    end

    ---
    -- このオブジェクトを、Handle に型変換する
    -- @return (Handle) ハンドル
    function this:castToHandle()
        local ret = Handle.new();
        ret._type = HandleTypeEnum.Dynamics;
        ret.iconId = self.iconId;
        ret.ids = self.ids;
        ret.original = self.original;
        ret.caption = self:getCaption();
        ret.dynBP = self:getDynBP();
        ret.endDyn = self:getEndDyn();
        ret:setLength( self:getLength() );
        ret.startDyn = self:getStartDyn();
        return ret;
    end

    ---
    -- キャプションを取得する
    -- @return (string) キャプション
    function this:getCaption()
        return self.caption;
    end

    ---
    -- キャプションを設定する
    -- @param value (string)
    function this:setCaption( value )
        self.caption = value;
    end

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
    -- DYN の開始値を取得する
    -- @return (integer) DYN の開始値
    function this:getStartDyn()
        return self.startDyn;
    end

    ---
    -- DYN の開始値を設定する
    -- @param value (integer) DYN の開始値
    function this:setStartDyn( value )
        self.startDyn = value;
    end

    ---
    -- DYN の終了値を取得する
    -- @return (integer) DYN の終了値
    function this:getEndDyn()
        return self.endDyn;
    end

    ---
    -- DYN の終了値を設定する
    -- @param value (integer) DYN の終了値
    function this:setEndDyn( value )
        self.endDyn = value;
    end

    ---
    -- DYN カーブを取得する
    -- @return (VibratoBPList) DYN カーブ
    function this:getDynBP()
        return self.dynBP;
    end

    ---
    -- DYN カーブを設定する
    -- @param value (VibratoBPList) DYN カーブ
    function this:setDynBP( value )
        self.dynBP = value;
    end

    return this;
end
