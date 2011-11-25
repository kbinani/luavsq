#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <windows.h>
#include <tchar.h>

int luavsq_GetOpenFileName( lua_State *L )
{
    int n = lua_gettop( L );

    if( n == 1 ){
        const char *path = lua_tostring( L, 1 );

        TCHAR fileNameFull[MAX_PATH] = "";
        TCHAR fileName[MAX_PATH] = "";

        HWND processDialog = FindWindow( NULL, "Running Job Plugin ..." );

        OPENFILENAME arg;
        ZeroMemory( &arg, sizeof( arg ) );
        arg.lStructSize = sizeof( arg );
        arg.hwndOwner = processDialog;
        arg.lpstrFilter = _T( "VOCALOID2 Sequence (*.vsq)\0*.vsq\0All Files (*.*)\0*.*\0\0" );
        arg.lpstrFile = fileNameFull;
        arg.lpstrFileTitle = fileName;
        arg.nMaxFile = sizeof( fileNameFull );
        arg.nMaxFileTitle = sizeof( fileName );
        arg.Flags = OFN_OVERWRITEPROMPT;
        arg.lpstrTitle = _T( "Export VOCALOID2 Sequence" );
        arg.lpstrDefExt = _T( "vsq" );

        if( GetOpenFileName( &arg ) ){
            lua_pushstring( L, (const char*)fileNameFull );
        }else{
            lua_pushnil( L );
        }

        return 1;
    }else{
        lua_pushnil( L );
        return 1;
    }
}
