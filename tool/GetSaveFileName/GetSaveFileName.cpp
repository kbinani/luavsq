/**
 * GetSaveFileName.cpp
 * Copyright © 2011-2012 kbinani
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
#pragma comment( lib, "version.lib" )
extern "C"{
    #include <lua.h>
    #include <lualib.h>
    #include <lauxlib.h>
}
#include <windows.h>
#include <tchar.h>
#include <unicode/ucnv.h>
#include <vector>
#include "StringUtil.h"

using namespace std;

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

string getFileVersion( const char *path )
{
    string result = "";
    DWORD dwZero = 0;
    DWORD dwVerInfoSize = GetFileVersionInfoSizeA( path, &dwZero );
    if( dwVerInfoSize == 0 ){
        return result;
    }

    unsigned char *pBlock = new unsigned char[dwVerInfoSize];
    if( pBlock == NULL ){
        return result;
    }
    GetFileVersionInfoA( path, dwZero, dwVerInfoSize, pBlock );

    void *pvVersion;
    UINT VersionLen;

    struct LANGANDCODEPAGE {
        WORD wLanguage;
        WORD wCodePage;
    } *lpTranslate;

    UINT TranslateLen;
    VerQueryValue(
        pBlock,
        TEXT( "\\VarFileInfo\\Translation" ),
        (LPVOID*)&lpTranslate,
        &TranslateLen
    );
    for( UINT i = 0; i < TranslateLen / sizeof( *lpTranslate ); i++ ){
        char name[256];
        sprintf( name, "\\StringFileInfo\\%04x%04x\\ProductVersion",
                  lpTranslate[i].wLanguage, lpTranslate[i].wCodePage );
        if( VerQueryValueA( pBlock, name, &pvVersion, &VersionLen ) ){
            result = (char *)pvVersion;
            break;
        }
    }
    delete [] pBlock;
    return result;
}

/**
 * VOCALOID3 エディタのバージョンから、そのバージョンがUTF8のio.openをサポートするかどうかを判定する
 */
bool isUtf8Supported( string version )
{
    vector<string> versionNumbers = StringUtil::explode( ", ", version );
    if( versionNumbers.size() >= 4 ){
        int major = atoi( versionNumbers[0].c_str() );
        int minor = atoi( versionNumbers[1].c_str() );
        int release = atoi( versionNumbers[2].c_str() );
        int build = atoi( versionNumbers[3].c_str() );
        if( major > 3 ){
            return true;
        }else if( major < 3 ){
            return false;
        }else{
            if( minor > 0 ){
                return true;
            }else{
                if( release >= 4 ){
                    return true;
                }else if( release < 4 ){
                    return false;
                }
            }
        }
    }else{
        return true;
    }
}

extern "C"{

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
    int luavsq_GetSaveFileName( lua_State *state )
    {
        int n = lua_gettop( state );

        if( n == 2 ){
            const char *path = lua_tostring( state, 1 );
            const char *vocaloid3exe = lua_tostring( state, 2 );
            HWND progressDialog = FindWindow( NULL, TEXT( "Running Job Plugin ..." ) );

            string version = getFileVersion( vocaloid3exe );

            if( isUtf8Supported( version ) ){
                WCHAR fileNameFull[MAX_PATH] = L"";
                WCHAR fileName[MAX_PATH] = L"";

                OPENFILENAMEW arg;
                ZeroMemory( &arg, sizeof( arg ) );
                arg.lStructSize = sizeof( arg );
                arg.hwndOwner = progressDialog;
                arg.lpstrFilter = L"VOCALOID2 Sequence (*.vsq)\0*.vsq\0All Files (*.*)\0*.*\0\0";
                arg.lpstrFile = fileNameFull;
                arg.lpstrFileTitle = fileName;
                arg.nMaxFile = sizeof( fileNameFull );
                arg.nMaxFileTitle = sizeof( fileName );
                arg.Flags = OFN_OVERWRITEPROMPT;
                arg.lpstrTitle = L"Export VOCALOID2 Sequence";
                arg.lpstrDefExt = L"vsq";

                if( GetSaveFileNameW( &arg ) ){
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
                CHAR fileNameFull[MAX_PATH] = "";
                CHAR fileName[MAX_PATH] = "";

                OPENFILENAMEA arg;
                ZeroMemory( &arg, sizeof( arg ) );
                arg.lStructSize = sizeof( arg );
                arg.hwndOwner = progressDialog;
                arg.lpstrFilter = "VOCALOID2 Sequence (*.vsq)\0*.vsq\0All Files (*.*)\0*.*\0\0";
                arg.lpstrFile = fileNameFull;
                arg.lpstrFileTitle = fileName;
                arg.nMaxFile = sizeof( fileNameFull );
                arg.nMaxFileTitle = sizeof( fileName );
                arg.Flags = OFN_OVERWRITEPROMPT;
                arg.lpstrTitle = "Export VOCALOID2 Sequence";
                arg.lpstrDefExt = "vsq";

                if( GetSaveFileNameA( &arg ) ){
                    lua_pushstring( state, arg.lpstrFile );
                    lua_pushstring( state, "Succeeded." );
                }else{
                    lua_pushnil( state );
                    lua_pushstring( state, "GetSaveFileName WinAPI call return FALSE." );
                }
            }
        }else{
            lua_pushnil( state );
            lua_pushstring( state, "Invalid number of argument(s)." );
        }

        return 2;
    }
}
