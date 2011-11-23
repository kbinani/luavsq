--[[
  MidiEvent.lua
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

if( nil == luavsq.MidiEvent )then

    luavsq.MidiEvent = {};

    ---
    -- midiイベント。メタイベントは、メタイベントのデータ長をData[1]に格納せず、生のデータをDataに格納するので、注意が必要
    function luavsq.MidiEvent.new()
        local this = {};
        this.clock = 0;
        this.firstByte = 0;
        this.data = {};

        ---
        -- @param (ByteArrayOutputStream) stream
        function this:writeData( stream )
            stream:write( self.firstByte );
            if( self.firstByte == 0xff )then
                stream:write( self.data[1] );
                luavsq.MidiEvent.writeDeltaClock( stream, #self.data - 1 );
                stream:write( self.data, 2, #self.data - 1 );
            else
                stream:write( self.data, 1, #self.data );
            end
        end

        ---
        -- @param item [MidiEvent]
        -- @return [int]
        function this:compareTo( item )
            if( self.clock ~= item.clock )then
                return self.clock - item.clock;
            else
                local first_this = luavsq.Util.band( self.firstByte, 0xf0 );
                local first_item = luavsq.Util.band( item.firstByte, 0xf0 );

                if( (first_this == 0x80 or first_this == 0x90) and (first_item == 0x80 or first_item == 0x90) )then
                    if( self.data ~= nil and #self.data >= 2 and item.data ~= nil and #item.data >= 2 )then
                        if( first_item == 0x90 and item.data[2] == 0 )then
                            first_item = 0x80;
                        end
                        if( first_this == 0x90 and self.data[2] == 0 )then
                            first_this = 0x80;
                        end
                        if( self.data[1] == item.data[1] )then
                            if( first_this == 0x90 )then
                                if( first_item == 0x80 )then
                                    -- ON -> OFF
                                    return 1;
                                else
                                    -- ON -> ON
                                    return 0;
                                end
                            else
                                if( first_item == 0x80 )then
                                    -- OFF -> OFF
                                    return 0;
                                else
                                    -- OFF -> ON
                                    return -1;
                                end
                            end
                        end
                    end
                end
                return self.clock - item.clock;
            end
        end

        return this;
    end

    ---
    -- @param clock [int]
    -- @param numerator [int]
    -- @param denominator [int]
    -- @return [MidiEvent]
    function luavsq.MidiEvent.generateTimeSigEvent( clock, numerator, denominator )
        local ret = luavsq.MidiEvent.new();
        ret.clock = clock;
        ret.firstByte = 0xff;
        local b_numer = math.floor( math.log( denominator ) / math.log( 2 ) + 0.1 );
        ret.data = { 0x58, numerator, b_numer, 0x18, 0x08 };
        return ret;
    end

    ---
    -- @param clock [int]
    -- @param tempo [int]
    -- @return [MidiEvent]
    function luavsq.MidiEvent.generateTempoChangeEvent( clock, tempo )
        local ret = luavsq.MidiEvent.new();
        ret.clock = clock;
        ret.firstByte = 0xff;
        local b1 = luavsq.Util.band( tempo, 0xff );
        tempo = luavsq.Util.rshift( tempo, 8 );
        local b2 = luavsq.Util.band( tempo, 0xff );
        tempo = luavsq.Util.rshift( tempo, 8 );
        local b3 = luavsq.Util.band( tempo, 0xff );
        ret.data = { 0x51, b3, b2, b1 };
        return ret;
    end

    luavsq.MidiEvent._x = {};
    local i;
    for i = 0, 64, 1 do
        luavsq.MidiEvent._x[i + 1] = math.pow( 2, i );
    end

    ---
    -- @param (ByteArrayOutputStream) stream
    -- @param (long) number
    function luavsq.MidiEvent.writeDeltaClock( stream, number )
        local bits = {};
        local p = luavsq.MidiEvent._x[1];
        local p2;
        local first = 0;
        local p2 = luavsq.MidiEvent._x[65];
        for i = 63, 0, -1 do
            p = luavsq.MidiEvent._x[i + 1];
            local b = (number % p2 >= p);
            p2 = p;
            bits[i + 1] = b;
            if( first == 0 and b )then
                first = i;
            end
        end

        -- 何バイト必要か？
        local bytes = math.floor( first / 7 ) + 1;
        for i = 1, bytes, 1 do
            local num = 0;
            local count = 0x80;
            local j;
            local startJ = (bytes - i + 1) * 7 - 1;
            for j = startJ, startJ - 6, -1 do
                count = count / 2;
                if( bits[j + 1] )then
                    num = num + count;
                end
            end
            if( i ~= bytes )then
                num = num + 0x80;
            end
            stream:write( num );
        end
    end

--[[
    /**
     * @param stream [ByteArrayInputStream]
     * @return [long]
     */
    luavsq.MidiEvent.readDeltaClock = function( stream ){
        local ret = 0; // [long]
        while ( true ) {
            local i = stream.read();
            if( i < 0 )then
                break;
            end
            local d = i; // [byte]
            ret = (ret << 7) | (d & 0x7f);
            if( (d & 0x80) == 0x00 )then
                break;
            end
        end
        return ret;
    end
]]

--[[
    /**
     * @param stream [ByteArrayInputStream]
     * @param last_clock [ByRef<Long>]
     * @param last_status_byte [ByRef<Integer>]
     */
    luavsq.MidiEvent.read = function( stream, last_clock, last_status_byte ){
        local delta_clock = this.readDeltaClock( stream ); // [long]
        last_clock.value += delta_clock;
        local first_byte = stream.read(); // [int]
        if( first_byte < 0x80 )then
            // ランニングステータスが適用される
            local pos = stream.getFilePointer();
            stream.seek( pos - 1 );
            first_byte = last_status_byte.value;
        else
            last_status_byte.value = first_byte;
        end
        local ctrl = first_byte & 0xf0;
        if( ctrl == 0x80 || ctrl == 0x90 || ctrl == 0xA0 || ctrl == 0xB0 || ctrl == 0xE0 || first_byte == 0xF2 )then
            // 3byte使用するチャンネルメッセージ：
            //     0x8*: ノートオフ
            //     0x9*: ノートオン
            //     0xA*: ポリフォニック・キープレッシャ
            //     0xB*: コントロールチェンジ
            //     0xE*: ピッチベンドチェンジ
            // 3byte使用するシステムメッセージ
            //     0xF2: ソングポジション・ポインタ
            local me = new luavsq.MidiEvent(); // [MidiEvent]
            me.clock = last_clock.value;
            me.firstByte = first_byte;
            me.data = new Array( 2 ); //int[2];
            local d = new Array( 2 ); // byte[2];
            stream.readArray( d, 0, 2 );
            for ( local i = 0; i < 2; i++ ) {
                me.data[i] = 0xff & d[i];
            end
            return me;
        elseif( ctrl == 0xC0 || ctrl == 0xD0 || first_byte == 0xF1 || first_byte == 0xF2 )then
            // 2byte使用するチャンネルメッセージ
            //     0xC*: プログラムチェンジ
            //     0xD*: チャンネルプレッシャ
            // 2byte使用するシステムメッセージ
            //     0xF1: クォータフレーム
            //     0xF3: ソングセレクト
            local me = new luavsq.MidiEvent(); // [MidiEvent]
            me.clock = last_clock.value;
            me.firstByte = first_byte;
            me.data = new Array( 1 );// int[1];
            local d = new Array( 1 );// byte[1];
            stream.readArray( d, 0, 1 );
            me.data[0] = 0xff & d[0];
            return me;
        elseif( first_byte == 0xF6 )then
            // 1byte使用するシステムメッセージ
            //     0xF6: チューンリクエスト
            //     0xF7: エンドオブエクスクルーシブ（このクラスではF0ステータスのSysExの一部として取り扱う）
            //     0xF8: タイミングクロック
            //     0xFA: スタート
            //     0xFB: コンティニュー
            //     0xFC: ストップ
            //     0xFE: アクティブセンシング
            //     0xFF: システムリセット
            local me = new luavsq.MidiEvent(); // [MidiEvent]
            me.clock = last_clock.value;
            me.firstByte = first_byte;
            me.data = new Array(); //int[0];
            return me;
        elseif( first_byte == 0xff )then
            // メタイベント
            local meta_event_type = stream.read(); //[int]
            local meta_event_length = this.readDeltaClock( stream ); // [long]
            local me = new luavsq.MidiEvent(); //[MidiEvent]
            me.clock = last_clock.value;
            me.firstByte = first_byte;
            me.data = new Array( meta_event_length + 1 ); // int[]
            me.data[0] = meta_event_type;
            local d = new Array( meta_event_length + 1 ); // byte[]
            stream.readArray( d, 1, meta_event_length );
            for ( local i = 1; i < meta_event_length + 1; i++ ) {
                me.data[i] = 0xff & d[i];
            end
            return me;
        elseif( first_byte == 0xf0 )then
            // f0ステータスのSysEx
            local me = new luavsq.MidiEvent();// [MidiEvent]
            me.clock = last_clock.value;
            me.firstByte = first_byte;
            local sysex_length = this.readDeltaClock( stream ); // [long]
            me.data = new Array( sysex_length + 1 ); // int[]
            local d = new Array( sysex_length + 1 ); // byte[]
            stream.readArray( d, 0, sysex_length + 1 );
            for ( local i = 0; i < sysex_length + 1; i++ ) {
                me.data[i] = 0xff & d[i];
            end
            return me;
        elseif( first_byte == 0xf7 )then
            // f7ステータスのSysEx
            local me = new luavsq.MidiEvent();
            me.clock = last_clock.value;
            me.firstByte = first_byte;
            local sysex_length = this.readDeltaClock( stream );
            me.data = new Array( sysex_length );
            local d = new Array( sysex_length );//byte[]
            stream.readArray( d, 0, sysex_length );
            for ( local i = 0; i < sysex_length; i++ ) {
                me.data[i] = 0xff & d[i];
            end
            return me;
        else
            throw new Exception( "don't know how to process first_byte: 0x" + PortUtil.toHexString( first_byte ) );
        end
    end
]]

    ---
    -- @param (luavsq.MidiEvent) a
    -- @param (luavsq.MidiEvent) b
    -- @return (boolean)
    function luavsq.MidiEvent.compare( a, b )
        return (a:compareTo( b ) < 0);
    end

end
