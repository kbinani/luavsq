--[[
  Master.lua
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
-- VSQ ファイルのメタテキストの [Master] に記録される内容を取り扱うクラス
-- @class table
-- @name Master
-- @field preMeasure (intger) プリメジャーの長さ(小節数)
Master = {};

--
-- 初期化を行う
-- @return (Master)
function Master.new( ... )
    local this = {};
    local arguments = { ... };

    this.preMeasure = 1;

    ---
    -- プリメジャーを指定し、初期化を行う
    -- @param preMeasure (integer) プリメジャーの長さ(小節数)
    -- @return (Master)
    -- @name <i>new</i><sup>1</sup>
    function this:_init_1( preMeasure )
        self.preMeasure = preMeasure;
    end

    ---
    -- テキストストリームから読み込むことで初期化を行う
    -- @param stream (TextStream) 読み込むテキストストリーム
    -- @param lastLine (table, { value = ? }) 読み込んだ最後の行。テーブルの ["value"] に文字列が格納される
    -- @return (Master)
    -- @name <i>new</i><sup>2</sup>
    function this:_init_2( stream, lastLine )
        self.preMeasure = 0;
        local spl;
        lastLine.value = stream:readLine();
        while( lastLine.value:find( "[", 1, true ) ~= 1 )do
            spl = Util.split( lastLine.value, "=" );
            if( spl[1] == "PreMeasure" )then
                self.preMeasure = tonumber( spl[2], 10 );
            end
            if( not stream:ready() )then
                break;
            end
            lastLine.value = stream:readLine();
        end
    end

    ---
    -- コピーを作成する
    -- @return (Master) このオブジェクトのコピー
    -- @name clone
    function this:clone()
        return Master.new( self.preMeasure );
    end

    ---
    -- テキストストリームに出力する
    -- @param stream (TextStream) 出力先
    -- @name write
    function this:write( stream )
        stream:writeLine( "[Master]" );
        stream:writeLine( "PreMeasure=" .. self.preMeasure );
    end

    if( #arguments == 1 )then
        this:_init_1( arguments[1] );
    elseif( #arguments == 2 )then
        this:_init_2( arguments[1], arguments[2] );
    end

    return this;
end
