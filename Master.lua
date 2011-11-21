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
    -- vsqファイルのメタテキストの[Master]に記録される内容を取り扱う
    luavsq.Master = {};

    function luavsq.Master.new( ... )
        local this = {};
        local arguments = { ... };

        this.preMeasure = 1;

        ---
        -- @param preMeasure (integer)
        function this:_init_1( preMeasure )
            self.preMeasure = preMeasure;
        end

        ---
        -- @param sr [TextStream]
        -- @param lastLine [ByRef<string>]
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

        function this:clone()
            return luavsq.Master.new( self.preMeasure );
        end

        ---
        -- インスタンスの内容をテキストファイルに出力します
        -- @param stream (TextStream) 出力先
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
