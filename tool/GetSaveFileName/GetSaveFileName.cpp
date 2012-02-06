/**
 * GetSaveFileName.c
 * Copyright © 2011 kbinani
 *
 * This file is part of ExportVSQ.
 *
 * ExportVSQ is free software; you can redistribute it and/or
 * modify it under the terms of the BSD License.
 *
 * ExportVSQ is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */
#pragma comment( lib, "lua5.1.lib" )
#pragma comment( lib, "icuuc.lib" )
extern "C"{
    #include <lua.h>
    #include <lualib.h>
    #include <lauxlib.h>
}
#include <windows.h>
#include <tchar.h>
#include <unicode/ucnv.h>
#include <vector>

void encode( const std::wstring& src, const std::string& codepage, std::string& dst )
{
    const icu::UnicodeString ustr( src.c_str(), src.size() );
    const int32_t len = ustr.extract( 0, ustr.length(), 0, codepage.c_str() );

    if( len > 0 ){
        std::vector<char> buf( len );

        ustr.extract( 0, ustr.length(), &buf[0], buf.size(), codepage.c_str() );
        dst.assign( buf.begin(), buf.end() );
    }else{
        dst.clear();
    }
}

/**
 * 「ファイル名を付けて保存」ダイアログボックスを開き、ダイアログで指定されたファイル名を取得する。
 * VOCALOID3 Editor が JobPlugin 起動時に表示する "Running Job Plugin ..." というタイトルのウィンドウを
 * 検索し、そのウィンドウに対してモーダルにダイアログボックスを開こうとする
 *
 * @usage Lua スクリプトからは、以下のように使用する
 * <code>
 *     local luavsq_GetSaveFileName = package.loadlib( "GetSaveFileName.dll", "luavsq_GetSaveFileName" );
 *     if( nil == luavsq_GetSaveFileName )then
 *         assert( false, "DLL のロードエラー" );
 *     end
 *     local path, message = luavsq_GetSaveFileName( "" );
 *     if( nil == path )then
 *         assert( false, "DLL の実行時エラー; エラーメッセージ: " .. message );
 *     else
 *         print( "指定されたファイルパス: " .. path );
 *     end
 * </code>
 */

extern "C"{

    int luavsq_GetSaveFileName( lua_State *state )
    {
        int n = lua_gettop( state );

        if( n == 1 ){
            const char *path = lua_tostring( state, 1 );

            TCHAR fileNameFull[MAX_PATH] = TEXT( "" );
            TCHAR fileName[MAX_PATH] = TEXT( "" );

            HWND progressDialog = FindWindow( NULL, TEXT( "Running Job Plugin ..." ) );

            OPENFILENAME arg;
            ZeroMemory( &arg, sizeof( arg ) );
            arg.lStructSize = sizeof( arg );
            arg.hwndOwner = progressDialog;
            arg.lpstrFilter = TEXT( "VOCALOID2 Sequence (*.vsq)\0*.vsq\0All Files (*.*)\0*.*\0\0" );
            arg.lpstrFile = fileNameFull;
            arg.lpstrFileTitle = fileName;
            arg.nMaxFile = sizeof( fileNameFull );
            arg.nMaxFileTitle = sizeof( fileName );
            arg.Flags = OFN_OVERWRITEPROMPT;
            arg.lpstrTitle = TEXT( "Export VOCALOID2 Sequence" );
            arg.lpstrDefExt = TEXT( "vsq" );

            if( GetSaveFileName( &arg ) ){
                std::wstring fileNameWide = arg.lpstrFile;
                std::string fileNameUtf8;
                encode( fileNameWide, "UTF-8", fileNameUtf8 );
                lua_pushstring( state, fileNameUtf8.c_str() );
                lua_pushstring( state, "Succeeded." );
            }else{
                lua_pushnil( state );
                lua_pushstring( state, "GetSaveFileName WinAPI call return FALSE." );
            }

        }else{
            lua_pushnil( state );
            lua_pushstring( state, "Invalid number of argument(s)." );
        }

        return 2;
    }
}
