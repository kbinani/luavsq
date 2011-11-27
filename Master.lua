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

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.Master )then

    ---
    -- VSQ ファイルのメタテキストの [Master] に記録される内容を取り扱うクラス
    -- @class table
    -- @name luavsq.Master
    luavsq.Master = {};

    ---
    -- 初期化を行う
    -- @see luavsq.Master:_init_1
    -- @see luavsq.Master:_init_2
    -- @return (luavsq.Master)
    function luavsq.Master.new( ... )
        local this = {};
        local arguments = { ... };

        this.preMeasure = 1;

        ---
        -- プリメジャーを指定し、初期化を行う
        -- @param preMeasure (integer) プリメジャーの長さ(小節数)
        function this:_init_1( preMeasure )
            self.preMeasure = preMeasure;
        end

        ---
        -- テキストストリームから読み込むことで初期化を行う
        -- @param sr (luavsq.TextStream) 読み込むテキストストリーム
        -- @param lastLine (table, { value = ? }) 読み込んだ最後の行。テーブルの ["value"] に文字列が格納される
        function this:_init_2( sr, lastLine )
            self.preMeasure = 0;
            local spl;
            lastLine.value = sr:readLine();
            while( lastLine.value:find( "[", 1, true ) ~= 1 )do
                spl = luavsq.Util.split( lastLine.value, "=" );
                if( spl[1] == "PreMeasure" )then
                    self.preMeasure = tonumber( spl[2], 10 );
                end
                if( not sr:ready() )then
                    break;
                end
                lastLine.value = sr:readLine();
            end
        end

        ---
        -- コピーを作成する
        -- @return (luavsq.Master) このオブジェクトのコピー
        function this:clone()
            return luavsq.Master.new( self.preMeasure );
        end

        ---
        -- テキストストリームに出力する
        -- @param stream (luavsq.TextStream) 出力先
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

end
