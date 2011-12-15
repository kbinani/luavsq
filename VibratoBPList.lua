--[[
  VibratoBPList.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

local tonumber = tonumber;
local math = math;
local table = table;

module( "luavsq" );

---
-- ビブラートデータポイントのリストを表すクラス
-- @class table
-- @name VibratoBPList
VibratoBPList = {};

--
-- 初期化を行う
-- @return (VibratoBPList)
function VibratoBPList.new( ... )
    local arguments = { ... };
    local this = {};

    ---
    -- カーブのデータ点を保持するリスト
    -- @var table<VibratoBP>
    -- @access private
    this._list = {};

    ---
    -- 初期化を行う
    -- @param textNum (string) データ点の個数の文字列表現
    -- @param textBPX (string) x 軸のデータ点の値をカンマ区切りで繋げた文字列
    -- @param textBPY (string) y 軸のデータ点の値をカンマ区切りで繋げた文字列
    -- @return (VibratoBPList)
    -- @name new<!--1-->
    -- @access static ctor
    function this:_init_3( textNum, textBPX, textBPY )
        local num = tonumber( textNum );
        if( nil == num )then
            num = 0;
        end
        local bpx = Util.split( textBPX, ',' );
        local bpy = Util.split( textBPY, ',' );
        local actNum = math.min( num, math.min( #bpx, #bpy ) );
        if( actNum > 0 )then
            local x = Util.array( actNum );
            local y = Util.array( actNum );
            for i = 1, actNum, 1 do
                x[i] = tonumber( bpx[i] );
                y[i] = tonumber( bpy[i] );
            end

            local len = math.min( #x, #y );
            for i = 1, len, 1 do
                self._list[i] = VibratoBP.new( x[i], y[i] );
            end
            table.sort( self._list, VibratoBP.compare );
        end
    end

    ---
    -- 初期化を行う
    -- @param x (table<double>) x 軸の値のリスト
    -- @param y (table<int>) y 軸の値のリスト
    -- @return (VibratoBPList)
    -- @name new<!--2-->
    -- @access static ctor
    function this:_init_2( x, y )
        local len = math.min( #x, #y );
        for i = 1, len, 1 do
            self._list[i] = VibratoBP.new( x[i], y[i] );
        end
        local comparator = function( a, b )
            if( a:compareTo( b ) < 0 )then
                return true;
            else
                return false;
            end
        end
        table.sort( self._list, VibratoBP.compare );
    end

    ---
    -- 指定した位置のビブラートカーブの値を取得する
    -- @param x (double) 取得したい x 軸の値
    -- @param defaultValue (int) ビブラートカーブのデフォルト値
    -- @return (int) ビブラートカーブの値
    function this:getValueAt( x, defaultValue )
        if( #self._list <= 0 )then
            return defaultValue;
        end
        local index = -1;
        for i = 1, #self._list, 1 do
            if( x < self._list[i].x )then
                break;
            end
            index = i;
        end
        if( index == -1 )then
            return defaultValue;
        else
            return self._list[index].y;
        end
    end

    ---
    -- コピーを作成する
    -- @return (VibratoBPList) このオブジェクトのコピー
    function this:clone()
        local ret = VibratoBPList.new();
        for i = 1, #self._list, 1 do
            ret._list[i] = VibratoBP.new( self._list[i].x, self._list[i].y );
        end
        return ret;
    end

    ---
    -- データ点の個数を返す
    -- @return (int) データ点の個数
    function this:size()
        return #self._list;
    end

    ---
    -- 指定したインデックスのデータ点を取得する
    -- @param index (int) 0から始まるインデックス
    -- @return (VibratoBP) データ点
    function this:get( index )
        return self._list[index + 1];
    end

    ---
    -- 指定したインデックスのデータ点を設定する
    -- @param index (int) インデックス(最初のインデックスは0)
    -- @param value (VibratoBP) 設定するデータ点
    function this:set( index, value )
        self._list[index + 1] = value;
    end

    ---
    -- データ点のリストを、文字列に変換する。例えば "key1=value1,key2=value2" のように変換される
    -- @return (string) 変換後の文字列
    function this:getData()
        local ret = "";
        for i = 1, #self._list, 1 do
            if( i > 1 )then
                ret = ret .. ",";
            end
            ret = ret .. self._list[i].x .. "=" .. self._list[i].y;
        end
        return ret;
    end

    ---
    -- "key1=value=1,key2=value2" のような文字列から、データ点のリストを設定する
    -- @param value (string) データ点の文字列形式
    function this:setData( value )
        self._list = {};
        local spl = Util.split( value, ',' );
        local j = 1
        for i = 1, #spl, 1 do
            local spl2 = Util.split( spl[i], '=' );
            if( #spl2 >= 2 )then
                self._list[j] = VibratoBP.new( tonumber( spl2[1] ), tonumber( spl2[2] ) );
                j = j + 1
            end
        end
        table.sort( self._list, VibratoBP.compare );
    end

    if( #arguments == 3 )then
        this:_init_3( arguments[1], arguments[2], arguments[3] );
    elseif( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    end

    return this;
end
