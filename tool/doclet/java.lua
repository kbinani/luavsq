local print = print;
local ipairs = ipairs;
local string = string;
local pairs = pairs;
local type = type;
local table = table;
local io = io;
local lfs = require( "lfs" );

module "luadoc.doclet.java";

local allClasses = {};

function start( doc )
    printStylesheet();
    printIndex();
    printOverviewSummary( doc );
    for i, fileName in ipairs( doc.files ) do
        local className = fileName:gsub( ".lua", "" );
        table.insert( allClasses, className );
    end

    printAllClasses( doc );
    for i, fileName in ipairs( doc.files ) do
        printClassDoc( fileName, doc );
    end
end

function printClassDoc( fileName, docinfo )
    local htmlName = fileName:gsub( ".lua", ".html" );
    local doc = docinfo.files[fileName];
    local f = lfs.open( options.output_dir .. "/files/" .. htmlName, "w" );
    local className = doc.tables[1];
    f:write( "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n" );
    f:write( "<html>\n" );
    f:write( "<head>\n" );
    f:write( "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF8\">\n" );
    f:write( "  <link rel=\"stylesheet\" type=\"text/css\" href=\"../stylesheet.css\">\n" );
    f:write( "  <title>" .. className .. "</title>\n" );
    f:write( "  <script type=\"text/javascript\">\n" );
    f:write( "      function windowTitle()\n" );
    f:write( "      {\n" );
    f:write( "          parent.document.title = \"" .. className .. "\";\n" );
    f:write( "      }\n" );
    f:write( "  </script>\n" );
    f:write( "</head>\n" );
    f:write( "<body onload=\"windowTitle();\">\n" );
    f:write( "  <h2>\n" );
    f:write( "    クラス " .. className .. "\n" );
    f:write( "  </h2>\n" );
    f:write( "  <p>\n" );
    f:write( "    " .. createLinks( getSummary( doc.tables[className].description ) ) .. "\n" );
    f:write( "  <p>\n" );
    f:write( "  <hr>\n" );
    f:write( "\n" );

    local fields = getFields( doc );
    local ctors = getConstructors( doc );
    local methods = getMethods( doc );

    printClassDocFieldSummary( f, fields );
    printClassDocMethodSummary( f, ctors, "コンストラクタ" );
    printClassDocMethodSummary( f, methods, "メソッド" );

    printClassDocFieldDetail( f, fields );
    printClassDocMethodDetail( f, ctors, "コンストラクタ" );
    printClassDocMethodDetail( f, methods, "メソッド" );

    f:write( "</body>\n" );
    f:write( "</html>\n" );
    f:close();
end

function printClassDocFieldSummary( f, fields )
    if( #fields > 0 )then
        f:write( "  <table border=\"1\" width=\"100%\" cellpadding=\"3\" cellspacing=\"0\">\n" );
        f:write( "    <tr bgcolor=\"#ccccff\" class=\"TableHeadingColor\">\n" );
        f:write( "      <th align=\"left\" colspan=\"2\">\n" );
        f:write( "        <font size=\"+2\">\n" );
        f:write( "          <b>フィールドの概要</b>\n" );
        f:write( "        </font>\n" );
        f:write( "      </th>\n" );
        f:write( "    </tr>\n" );
        for i, field in pairs( fields ) do
            local description = field.summary;
            f:write( "    <tr bgcolor=\"white\" class=\"TableRowColor\">\n" );
            f:write( "      <td align=\"right\" valign=\"top\" width=\"1%\">\n" );
            f:write( "        <font size=\"-1\">\n" );
            local access = getAccess( field.access );
            f:write( "          <code>" .. access .. " &nbsp;" .. getLinkedTypeName( field.var )  .. "</code>\n" );
            f:write( "        </font>\n" );
            f:write( "      </td>\n" );
            f:write( "      <td>\n" );
            f:write( "        <code><b><a href=\"#" .. field.name .. "\">" .. field.name .. "</a></b></code>\n" );
            f:write( "        <br>\n" );
            f:write( "        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\n" );
            f:write( "        " .. createLinks( getSummary( field.description ) ) .. "\n" );
            f:write( "      </td>\n" );
            f:write( "    </tr>\n" );
        end
        f:write( "  </table>\n" );
        f:write( "  &nbsp;\n" );
    end
    return fields;
end

function printClassDocMethodSummary( f, methods, methodKind )
    if( #methods > 0 )then
        f:write( "  <table border=\"1\" width=\"100%\" cellpadding=\"3\" cellspacing=\"0\">\n" );
        f:write( "    <tr bgcolor=\"#ccccff\" class=\"TableHeadingColor\">\n" );
        f:write( "      <th align=\"left\" colspan=\"2\">\n" );
        f:write( "        <font size=\"+2\"><b>" .. methodKind .. "の概要</b></font>\n" );
        f:write( "      </th>\n" );
        f:write( "    </tr>\n" );
        for i, info in pairs( methods ) do
            local returnType = "void";
            if( info.ret ~= nil )then
                returnType = getType( info.ret );
            end
            f:write( "    <tr bgcolor=\"white\" class=\"TableRowColor\">\n" );
            f:write( "      <td align=\"right\" valign=\"top\" width=\"1%\">\n" );
            local access = getAccess( info.access );
            f:write( "        <font size=\"-1\"><code>" .. access .. " &nbsp;" .. getLinkedTypeName( htmlspecialchars( returnType ) ) .. "</code></font>\n" );
            f:write( "      <td>\n" );
            f:write( "       <code><b><a href=\"#" .. getMethodId( info ) .. "\">" .. info.name .. "</a></b>(" );
            for paramIndex, paramName in ipairs( info.param ) do
                argType, summary = getType( info.param[paramName] );
                if( paramIndex > 1 )then
                    f:write( "," );
                end
                f:write( getLinkedTypeName( htmlspecialchars( argType ) ) .. "&nbsp;" .. paramName );
            end
            f:write( ")</code>\n" );
            f:write( "       <br>\n" );
            f:write( "       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" .. createLinks( getSummary( info.description ) ) .. "\n" );
            f:write( "      </td>\n" );
            f:write( "    </tr>\n" );
        end
        f:write( "  </table>\n" );
        f:write( "  &nbsp;\n" );
    end
    return methods;
end

function printClassDocFieldDetail( f, fields )
    if( #fields > 0 )then
        f:write( "  <table border=\"1\" width=\"100%\" cellpadding=\"3\" cellspacing=\"0\">\n" );
        f:write( "    <tr bgcolor=\"#ccccff\" class=\"TableHeadingColor\">\n" );
        f:write( "      <th align=\"left\" colspan=\"1\">\n" );
        f:write( "        <font size=\"+2\"><b>フィールドの詳細</b></font>\n" );
        f:write( "      </th>\n" );
        f:write( "    </tr>\n" );
        f:write( "  </table>\n" );

        local i, info;
        for i, info in pairs( fields ) do
            f:write( "  <a name=\"" .. info.name .. "\"><!-- --></a><h3>" .. info.name .. "</h3>\n" );
            f:write( "  <pre>\n" );
            local access = getAccess( info.access, true );
            f:write( access .. " " .. getLinkedTypeName( htmlspecialchars( info.var ) ) .. " <b>" .. info.name .. "</b></pre>\n" );
            f:write( "  <dl>\n" );
            f:write( "    <dd>" .. createLinks( info.description ) .. "\n" );
            f:write( "    <p>\n" );
            f:write( "    <dl>\n" );
            f:write( "    </dl>\n" );
            f:write( "  </dl>\n" );
            if( i < #fields )then
                f:write( "  <hr>\n" );
            end
            f:write( "\n" );
        end
    end
end

function printClassDocMethodDetail( f, ctors, methodKind )
    if( #ctors == 0 )then
        return;
    end
    f:write( "  <table border=\"1\" width=\"100%\" cellpadding=\"3\" cellspacing=\"0\">\n" );
    f:write( "    <tr bgcolor=\"#ccccff\" class=\"TableHeadingColor\">\n" );
    f:write( "      <th align=\"left\" colspan=\"1\">\n" );
    f:write( "        <font size=\"+2\"><b>" .. methodKind .. "の詳細</b></font>\n" );
    f:write( "      </th>\n" );
    f:write( "    </tr>\n" );
    f:write( "  </table>\n" );

    local i, ctor;
    for i, ctor in pairs( ctors ) do
        f:write( "  <a name=\"" .. getMethodId( ctor ) .. "\"><!-- --></a>\n" );
        local name = ctor.name:gsub( "<!--.*-->", "" );
        f:write( "  <h3>" .. name .. "</h3>\n" );
        f:write( "  <pre>\n" );
        local access = getAccess( ctor.access, true );
        local retType = getType( ctor.ret );
        f:write( access .. " " .. getLinkedTypeName( htmlspecialchars( retType ) ) .. " <b>" .. name .. "</b>(" );
        local paramPrefixSpaces = string.rep( " ", access:len() + retType:len() + name:len() + 3 );
        local paramIndex, paramName;
        for paramIndex, paramName in ipairs( ctor.param ) do
            local param = ctor.param[paramName];
            local t, c = getType( param );
            if( paramIndex > 1 )then
                f:write( ",\n" .. paramPrefixSpaces );
            end
            f:write( getLinkedTypeName( htmlspecialchars( t ) ) .. "&nbsp;" .. paramName );
        end
        f:write( ")</pre>\n" );
        f:write( "  <p>\n" );
        f:write( "  <dl>\n" );
        f:write( "    <dd>" .. createLinks( ctor.description ) .. "\n" );
        f:write( "    <p>\n" );
        f:write( "  </dl>\n" );
        if( #ctor.param > 0 )then
            f:write( "  <dd>\n" );
            f:write( "    <dl>\n" );
            f:write( "      <dt><b>パラメータ:</b>\n" );
            for paramIndex, paramName in ipairs( ctor.param ) do
                local param = ctor.param[paramName];
                local t, c = getType( param );
                f:write( "        <dd><code>" .. paramName .. "</code> - " .. c .. "\n" );
            end
            f:write( "    </dl>\n" );
            f:write( "  </dd>\n" );
        end
        if( ctor.ret ~= nil )then
            local t, c = getType( ctor.ret );
            f:write( "  <dd>\n" );
            f:write( "    <dl>\n" );
            f:write( "      <dt><b>戻り値:</b>\n" );
            f:write( "        <dd>" .. createLinks( c ) .. "" );
            f:write( "    </dl>\n" );
            f:write( "  </dd>\n" );
        end
        if( i < #ctors )then
            f:write( "  <hr>\n" );
        end
        f:write( "\n" );
    end
end

function printAllClasses( doc )
    local f = lfs.open( options.output_dir .. "/files/allclasses-frame.html", "w" );
    f:write( "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n" );
    f:write( "<html>\n" );
    f:write( "<head>\n" );
    f:write( "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF8\">\n" );
    f:write( "  <link rel=\"stylesheet\" type=\"text/css\" href=\"../stylesheet.css\">\n" );
    f:write( "</head>\n" );
    f:write( "<body>\n" );
    f:write( "  <font size=\"+1\" class=\"FrameHeadingFont\">\n" );
    f:write( "    <b>すべてのクラス</b>\n" );
    f:write( "  </font>\n" );
    f:write( "  <br>\n" );
    f:write( "  <table border=\"0\" width=\"100%\">\n" );
    f:write( "    <tr>\n" );
    f:write( "      <td nowrap>\n" );
    for i, file in ipairs( doc.files ) do
        local className = doc.files[file].tables[1];
        f:write( "        <font class=\"FrameItemFont\">\n" );
        f:write( "          <a href=\"" .. className .. ".html\" target=\"classFrame\">" );
        f:write( "          " .. className .. "\n" );
        f:write( "          </a>\n" );
        f:write( "        </font>\n" );
        f:write( "        <br>\n" );
    end
    f:write( "      </td>\n" );
    f:write( "    </tr>\n" );
    f:write( "  </table>\n" );
    f:write( "</body>\n" );
    f:write( "</html>\n" );
    f:close();
end

function printIndex()
    local f = lfs.open( options.output_dir .. "/index.html", "w" );
    f:write( "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n" );
    f:write( "<html>\n" );
    f:write( "<head>\n" );
    f:write( "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n" );
    f:write( "</head>\n" );
    f:write( "<frameset cols=\"20%,80%\" title=\"\">\n" );
    f:write( "  <frame src=\"files/allclasses-frame.html\" name=\"packageFrame\">\n" );
    f:write( "  <frame src=\"files/overview-summary.html\" name=\"classFrame\" scrolling=\"yes\">\n" );
    f:write( "</frameset>\n" );
    f:write( "</html>\n" );
    f:close();
end

function printOverviewSummary( doc )
    local moduleName = "";
    local description = "";
    local i, name;
    for i, name in ipairs( doc.modules ) do
        moduleName = name;
        description = doc.modules[moduleName].description;
        break;
    end

    local f = lfs.open( options.output_dir .. "/files/overview-summary.html", "w" );
    f:write( "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n" );
    f:write( "<html>\n" );
    f:write( "<head>\n" );
    f:write( "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF8\">\n" );
    f:write( "  <link rel=\"stylesheet\" type=\"text/css\" href=\"../stylesheet.css\">\n" );
    f:write( "  <title>" .. moduleName .. "</title>\n" );
    f:write( "  <script type=\"text/javascript\">\n" );
    f:write( "      function windowTitle()\n" );
    f:write( "      {\n" );
    f:write( "          parent.document.title = \"" .. moduleName .. "\";\n" );
    f:write( "      }\n" );
    f:write( "  </script>\n" );
    f:write( "</head>\n" );
    f:write( "<body onload=\"windowTitle();\">\n" );
    f:write( "  <h2>モジュール " .. moduleName .. "</h2>\n" );
    f:write( "  <p>" .. createLinks( description ) .. "</p>\n" );

    f:write( "  <table border=\"1\" width=\"100%\" cellpadding=\"3\" cellspacing=\"0\">\n" );
    f:write( "    <tr bgcolor=\"#ccccff\" class=\"TableHeadingColor\">\n" );
    f:write( "      <th align=\"left\" colspan=\"2\">\n" );
    f:write( "        <font size=\"+2\"><b>クラスの概要</b></font>\n" );
    f:write( "      </th>\n" );
    f:write( "    </tr>\n" );

    local i, file;
    for i, file in ipairs( doc.files ) do
        local className = doc.files[file].tables[1];
        local description = doc.files[file].tables[className].description;
        f:write( "    <tr bgcolor=\"white\" class=\"TableRowColor\">\n" );
        f:write( "      <td width=\"15%\">\n" );
        f:write( "        <b><a href=\"" .. className .. ".html\">" .. className .. "</a></b>\n" );
        f:write( "      </td>\n" );
        f:write( "      <td>\n" );
        f:write( "        " .. createLinks( description ) .. "\n" );
        f:write( "      </td>\n" );
        f:write( "    </tr>\n" );
    end

    f:write( "  </table>\n" );

    f:write( "</body>\n" );
    f:write( "</html>\n" );
    f:close();
end

function printStylesheet()
    local f = lfs.open( options.output_dir .. "/stylesheet.css", "w" );
    f:write( "body{\n" );
    f:write( "    background-color: #FFFFFF;\n" );
    f:write( "    color:#000000;\n" );
    f:write( "}\n" );
    f:write( "\n" );
    f:write( "h1{\n" );
    f:write( "    font-size: 145%;\n" );
    f:write( "}\n" );
    f:write( "\n" );
    f:write( ".TableHeadingColor{\n" );
    f:write( "    background: #CCCCFF;\n" );
    f:write( "    color:#000000;\n" );
    f:write( "}\n" );
    f:write( "\n" );
    f:write( ".TableSubHeadingColor{\n" );
    f:write( "    background: #EEEEFF;\n" );
    f:write( "    color:#000000;\n" );
    f:write( "}\n" );
    f:write( "\n" );
    f:write( ".TableRowColor{\n" );
    f:write( "    background: #FFFFFF;\n" );
    f:write( "    color:#000000;\n" );
    f:write( "}\n" );
    f:write( "\n" );
    f:write( ".FrameTitleFont{\n" );
    f:write( "    font-size: 100%;\n" );
    f:write( "    font-family: Helvetica, Arial, sans-serif;\n" );
    f:write( "    color:#000000;\n" );
    f:write( "}\n" );
    f:write( "\n" );
    f:write( ".FrameHeadingFont{\n" );
    f:write( "    font-size:  90%;\n" );
    f:write( "    font-family: Helvetica, Arial, sans-serif;\n" );
    f:write( "    color:#000000;\n" );
    f:write( "}\n" );
    f:write( "\n" );
    f:write( ".FrameItemFont{\n" );
    f:write( "    font-size:  90%;\n" );
    f:write( "    font-family: Helvetica, Arial, sans-serif;\n" );
    f:write( "    color:#000000;\n" );
    f:write( "}\n" );
    f:write( "\n" );
    f:write( ".NavBarCell1    { background-color:#EEEEFF; color:#000000}\n" );
    f:write( ".NavBarCell1Rev { background-color:#00008B; color:#FFFFFF}\n" );
    f:write( ".NavBarFont1    { font-family: Arial, Helvetica, sans-serif; color:#000000;color:#000000;}\n" );
    f:write( ".NavBarFont1Rev { font-family: Arial, Helvetica, sans-serif; color:#FFFFFF;color:#FFFFFF;}\n" );
    f:write( "\n" );
    f:write( ".NavBarCell2    { font-family: Arial, Helvetica, sans-serif; background-color:#FFFFFF; color:#000000}\n" );
    f:write( ".NavBarCell3    { font-family: Arial, Helvetica, sans-serif; background-color:#FFFFFF; color:#000000}\n" );
    f:close();
end

---
-- ファイルの doc 情報から、フィールドについての doc 情報を取り出す
function getFields( fileDoc )
    local result = {};
    for i, info in pairs( fileDoc.vars ) do
        if( type( info ) == "table" )then
            if( not (isPrivate( info.access ) and options.noprivate == 1) )then
                table.insert( result, info );
            end
        end
    end

    sortItems( result );

    return result;
end

---
-- ファイルの doc 情報から、function についての doc 情報を取り出す
function getMethods( fileDoc )
    local result = {};
    for i, info in pairs( fileDoc.functions ) do
        if( type( info ) == "table" and isConstructor( info.access ) == false )then
            if( not (isPrivate( info.access ) and options.noprivate == 1) )then
                table.insert( result, info );
            end
        end
    end

    sortItems( result );

    return result;
end

---
-- テーブルの要素のname属性の昇順に並び替える
-- @param itmems (table) ソート対象のテーブル
-- @return (table) ソート後のテーブル
function sortItems( items )
    local comparator = function( a, b )
        local nameA = a.name;
        local nameB = b.name;
        return nameA < nameB;
    end

    table.sort( items, comparator );
    return items;
end

---
-- メソッドのdoc情報から、そのメソッドを特定するID文字列を作成する
function getMethodId( methodInfo )
    return methodInfo.name;
end

---
-- コンストラクタの情報を取り出す
function getConstructors( fileDoc )
    local result = {};
    for i, info in pairs( fileDoc.functions ) do
        if( type( info ) == "table" and isConstructor( info.access ) )then
           table.insert( result, info );
        end
    end

    sortItems( result );

    return result;
end

---
-- access タグの文字列から、コンストラクタかどうかを判定する
-- コンストラクタの場合、access タグに ctor が入っている
function isConstructor( access )
    if( access == nil )then
        return false;
    else
        return access:find( "ctor" ) ~= nil;
    end
end

---
-- 型名に、HTMLドキュメントへのリンクを付加した文字列を取得する
-- @param typeName (string)
-- @return (string)
function getLinkedTypeName( typeName, classes )
    if( classes == nil )then
        classes = allClasses;
    end
    local startIndex = 1;
    local endIndex;
    while( startIndex <= typeName:len() )do
        startIndex, endIndex = typeName:find( "[a-zA-Z0-9_.]*", startIndex );
        if( startIndex == nil )then
            break;
        end
        if( endIndex < startIndex )then
            startIndex = startIndex + 1;
        else
            local extractedTypeName = typeName:sub( startIndex, endIndex );
            local i, className;
            local found = false;
            for i, className in ipairs( classes ) do
                if( extractedTypeName == className )then
                    local linkedClassName = "<a href=\"" .. className .. ".html\">" .. className .. "</a>";
                    typeName = typeName:sub( 1, startIndex - 1 ) .. linkedClassName .. typeName:sub( endIndex + 1 );
                    startIndex = endIndex + (linkedClassName:len() - className:len());
                    found = true;
                    break;
                end
            end
            if( not found )then
                startIndex = endIndex + 1;
            end
        end
    end
    return typeName;
end

---
-- "(integer) 説明"のような文字列を、"integer", "説明"に分解する
function getType( comment )
    if( comment == nil )then
        return "void", "";
    end
    if( type( comment ) == "table" )then
        return "void", "";
    end
    local startIndex = string.find( comment, "(", 1, true );
    if( startIndex == nil )then
        return "void", comment;
    end
    local endIndex = comment:find( ")", startIndex, true );
    if( endIndex == nil )then
        return "void", comment;
    end
    local t = comment:sub( startIndex + 1, endIndex - 1 );
    local c = comment:sub( endIndex + 1 );
    while( c:sub( 1, 1 ) == " " )do
        c = c:sub( 2 );
    end

    if( t == "" )then
        t = "void";
    end

    return t, c;
end

function htmlspecialchars( text )
    text = text:gsub( "&", "&amp;" );
    text = text:gsub( "<", "&lt;" );
    text = text:gsub( ">", "&gt;" );
    return text;
end

function isPrivate( access )
    if( access == nil )then
        return false;
    else
        return (access:find( "private" ) ~= nil);
    end
end

function isStatic( access )
    if( access == nil )then
        return false;
    else
        return (access:find( "static" ) ~= nil);
    end
end

function getAccess( access, long )
    if( long == nil )then
        long = false;
    end
    local result = "";
    if( options.noprivate == 1 and (not long) )then
        if( access == nil )then
            result = "";
        else
            if( access:find( "static" ) ~= nil )then
                result = "static";
            else
                result = "";
            end
        end
    else
        if( access == nil )then
            result = "public";
        else
            if( access:find( "private" ) ~= nil )then
                result = "private";
            else
                result = "public";
            end
            if( access:find( "static" ) ~= nil )then
                result = result .. " static";
            end
        end
    end
    return result;
end

function getSummary( summary )
    local c = "。";
    local i = summary:find( c );
    local result = summary;
    if( i ~= nil )then
        result = summary:sub( 1, i + c:len() - 1 );
    else
        c = "．";
        i = summary:find( c );
        if( i ~= nil )then
            result = summary:sub( 1, i + c:len() - 1 );
        end
    end
    while( result:sub( 1, 1 ) == " " )do
        result = result:sub( 2 );
    end
    return result;
end

---
-- {@link hoge} の hoge の部分にリンクを貼る
function createLinks( text, classes )
    if( classes == nil )then
        classes = allClasses;
    end
    while( true )do
        local startIndex, endIndex;
        startIndex, endIndex = string.find( text, "{@link (.*)}", 1 );
        if( startIndex == nil )then
            break;
        end
        local link = text:sub( startIndex, endIndex );
        local linkTarget = string.match( link, "{@link (.*)}" );
        local i, className;
        local found = false;
        for i, className in ipairs( classes ) do
            if( className == linkTarget )then
                found = true;
                break;
            end
        end
        if( found )then
            text = text:sub( 1, startIndex - 1 ) .. "<code><a href=\"" .. linkTarget .. ".html\">" .. linkTarget .. "</a></code>" .. text:sub( endIndex + 1 );
        else
            text = text:sub( 1, startIndex - 1 ) .. linkTarget .. text:sub( endIndex + 1 );
        end
    end
    return text;
end

---
-- 変数の中身をダンプする
-- @param value (?) ダンプする変数
-- @param option (table) ダンプ時の設定値
-- <ul>
--   <li>hex: 数値を 16 進数表記にする場合 true を設定する
--   <li>func: 関数をダンプする場合 true を設定する
-- </ul>
-- @return (string) 変数のダンプ
-- @name <i>dump</i>
function dump( value, option )
    if( option == nil )then
        option = {};
    end
    if( type( option.hex ) == "nil" )then
        option.hex = false;
    end
    if( type( option.func ) == "nil" )then
        option.func = false;
    end
    return _dump( value, 0, {}, option );
end

--
-- @access private
-- @param value (?) ダンプする変数
-- @param depth (integer) ダンプのネスト深さ
-- @param state (table) ダンプ済みオブジェクトのテーブル
-- @param option (table) ダンプ時の設定値
function _dump( value, depth, state, option )
    local hex = option.hex;
    if( hex == nil )then
        hex = false;
    end
    local func = option.func
    if( func == nil )then
        func = true;
    end

    local indent = string.rep( " ", 4 * depth );
    if( value == nil )then
        return indent .. "nil,";
    elseif( type( value ) == "boolean" )then
        if( value )then
            return indent .. "true,";
        else
            return indent .. "false,";
        end
    elseif( type( value ) == "string" )then
        return indent .. "'" .. value .. "',";
    elseif( type( value ) == "function" )then
        return indent .. "function,";
    elseif( type( value ) == "userdata" )then
        return indent .. "userdata,";
    elseif( type( value ) == "number" )then
        if( hex == false or value < 0 or value ~= math.floor( value ) )then
            return indent .. value .. ",";
        else
            return indent .. string.format( "0x%X", value ) .. ",";
        end
    elseif( type( value ) ~= "table" )then
        return indent .. value .. ",";
    else
        local i, s;
        local found = false;
        for i, s in pairs( state ) do
            if( s == value )then
                found = true;
                break;
            end
        end
        if( found )then
            return indent .. "(cycromatic reference),";
        else
            table.insert( state, value );
            local nextDepth = depth + 1;
            local str = "";
            local count = 0;
            for k, v in pairs( value ) do
                if( (func and type( v ) == "function") or type( v ) ~= "function" )then
                    local dumped = _dump( v, nextDepth, state, option );
                    while( dumped:len() > 0 and dumped:sub( 1, 1 ) == " " )do
                        dumped = dumped:sub( 2 );
                    end
                    local key;
                    if( type( k ) == "string" )then
                        key = "'" .. k .. "'";
                    else
                        key = "" .. k;
                    end
                    str = str .. indent .. "    " .. key .. " => " .. dumped .. "\n";
                    count = count + 1;
                end
            end
            if( count > 0 )then
                local result = indent .. "table(" .. count .. "){\n";
                result = result .. str;
                return result .. indent .. "},";
            else
                return indent .. "table(0){},";
            end
        end
    end
end
