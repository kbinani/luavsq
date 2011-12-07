local print = print;
local ipairs = ipairs;
local string = string;
local pairs = pairs;
local type = type;
local table = table;
local io = io;

module "luadoc.doclet.java";

function start( doc )
--print( dump( doc ) );
--print( "options=" .. dump( options ) );
    printStylesheet();
    printIndex();
    printOverview();
    printAllClasses( doc );
    for i, fileName in ipairs( doc.files ) do
        printClassDoc( fileName, doc );
--print( dump( doc.files[fileName].doc ) );
    end
--    print( dump( doc.files ) );
end

function printClassDocFieldSummary( f, fileDoc )
    local fields = getFields( fileDoc );
    if( #fields > 0 )then
print( "printClassDocFieldSummary; fields=" .. dump( fields ) );
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
            f:write( "          <code>" .. access .. " &nbsp;" .. field.var  .. "</code>\n" );
            f:write( "        </font>\n" );
            f:write( "      </td>\n" );
            f:write( "      <td>\n" );
            f:write( "        <code><b>" .. field.name .. "</b></code>\n" );
            f:write( "        <br>\n" );
            f:write( "        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\n" );
            f:write( "        " .. getSummary( field.description ) .. "\n" );
            f:write( "      </td>\n" );
            f:write( "    </tr>\n" );
        end
        f:write( "  </table>\n" );
        f:write( "  &nbsp;\n" );
    end
    return fields;
end

function printClassDocConstructorSummary( f, doc )
    local ctors = getConstructors( doc.doc );
    if( #ctors > 0 )then
        f:write( "  <table border=\"1\" width=\"100%\" cellpadding=\"3\" cellspacing=\"0\">\n" );
        f:write( "    <tr bgcolor=\"#ccccff\" class=\"TableHeadingColor\">\n" );
        f:write( "      <th align=\"left\" colspan=\"2\">\n" );
        f:write( "        <font size=\"+2\">\n" );
        f:write( "          <b>コンストラクタの概要</b>\n" );
        f:write( "        </font>\n" );
        f:write( "      </th>\n" );
        f:write( "    </tr>\n" );
        for i, info in pairs( ctors ) do
            local returnType = "void";
            if( info.ret ~= nil )then
                returnType = getType( info.ret );
            end
            f:write( "    <tr bgcolor=\"white\" class=\"TableRowColor\">\n" );
            f:write( "      <td align=\"right\" valign=\"top\" width=\"1%\">\n" );
            local access = getAccess( info.access );
            f:write( "        <font size=\"-1\"><code>" .. access .. " &nbsp;" .. returnType .. "</code></font>\n" );
            f:write( "      <td>\n" );
            f:write( "       <code><b>" .. info.name .. "</b></code>\n" );
            f:write( "       <br>\n" );
            f:write( "       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" .. getSummary( info.description ) .. "\n" );
            f:write( "      </td>\n" );
            f:write( "    </tr>\n" );
        end
        f:write( "  </table>\n" );
        f:write( "  &nbsp;\n" );
    end
    return ctors;
end

function printClassDocMethodSummary( f, doc )
    local methods = getMethods( doc );
    if( #methods > 0 )then
        f:write( "  <table border=\"1\" width=\"100%\" cellpadding=\"3\" cellspacing=\"0\">\n" );
        f:write( "    <tr bgcolor=\"#ccccff\" class=\"TableHeadingColor\">\n" );
        f:write( "      <th align=\"left\" colspan=\"2\">\n" );
        f:write( "        <font size=\"+2\"><b>メソッドの概要</b></font>\n" );
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
            f:write( "        <font size=\"-1\"><code>" .. access .. " &nbsp;" .. returnType .. "</code></font>\n" );
            f:write( "      <td>\n" );
            f:write( "       <code><b>" .. info.name .. "</b>(" );
            for paramIndex, paramName in ipairs( info.param ) do
                argType, summary = getType( info.param[paramName] );
                if( paramIndex > 1 )then
                    f:write( "," );
                end
                f:write( argType .. "&nbsp;" .. paramName );
            end
            f:write( ")</code>\n" );
            f:write( "       <br>\n" );
            f:write( "       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" .. getSummary( info.description ) .. "\n" );
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
            f:write( "  <a name=\"" .. info.name .. "\"<!-- --></a><h3>" .. info.name .. "</h3>\n" );
            f:write( "  <pre>\n" );
            local access = getAccess( info.access, true );
            f:write( access .. " " .. info.var .. " <b>" .. info.name .. "</b></pre>\n" );
            f:write( "  <dl>\n" );
            f:write( "    <dd>" .. info.description .. "\n" );
            f:write( "    <p>\n" );
            f:write( "    <dl>\n" );
            f:write( "    </dl>\n" );
            f:write( "  </dl>\n" );
            f:write( "  <hr>\n" );
            f:write( "\n" );
        end
    end
end

function printClassDoc( fileName, docinfo )
print( "* " .. fileName .. " ************************************************" );
    local htmlName = fileName:gsub( ".lua", ".html" );
    local doc = docinfo.files[fileName];
    local f = io.open( options.output_dir .. "/" .. htmlName, "w" );
    local className = doc.tables[1];
    f:write( "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n" );
    f:write( "<html>\n" );
    f:write( "<head>\n" );
    f:write( "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF8\">\n" );
    f:write( "  <link rel=\"stylesheet\" type=\"text/css\" href=\"stylesheet.css\">\n" );
    f:write( "</head>\n" );
    f:write( "<body>\n" );
    f:write( "  <h2>\n" );
    f:write( "    クラス " .. className .. "\n" );
    f:write( "  </h2>\n" );
    f:write( "  <p>\n" );
    f:write( "    " .. getSummary( doc.tables[className].description ) .. "\n" );
    f:write( "  <p>\n" );
    f:write( "  <hr>\n" );
    f:write( "\n" );

    local fields = printClassDocFieldSummary( f, doc );
    local ctors = printClassDocConstructorSummary( f, doc );
    local methods = printClassDocMethodSummary( f, doc );

    printClassDocFieldDetail( f, fields );

    f:write( "</body>\n" );
    f:write( "</html>\n" );
    f:close();
end

function printAllClasses( doc )
    local f = io.open( options.output_dir .. "/allclasses-frame.html", "w" );
    f:write(
[[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF8">
  <link rel="stylesheet" type="text/css" href="stylesheet.css">
</head>
<body>
  <font size="+1" class="FrameHeadingFont">
    <b>すべてのクラス</b>
  </font>
  <br>
  <table border="0" width="100%">
    <tr>
      <td nowrap>
]] );
    for i, file in ipairs( doc.files ) do
        local htmlName = file:gsub( ".lua", ".html" );
        f:write( "        <font class=\"FrameItemFont\">\n" );
        f:write( "          <a href=\"" .. htmlName .. "\" target=\"classFrame\">" );
        f:write( "          " .. file .. "\n" );
        f:write( "          </a>\n" );
        f:write( "        </font>\n" );
        f:write( "        <br>\n" );
    end
    f:write(
[[
      </td>
    </tr>
  </table>
</body>
</html>
]] );
    f:close();
end

function printOverview()
    local f = io.open( options.output_dir .. "/overview-frame.html", "w" );
    f:write(
[[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF8">
  <link rel="stylesheet" type="text/css" href="stylesheet.css">
</head>
<body>
  <table border="0" width="100%">
    <tr>
      <td nowrap>
        <font class="frameItemFont"><a href="allclasses-frame.html" target="packageFrame">すべてのクラス</a></font>
        <br>
      </td>
    </tr>
  </table>
</body>
</html>]] );
    f:close();
end

function printIndex()
    local f = io.open( options.output_dir .. "/index.html", "w" );
    f:write(
[[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<frameset cols="20%,80%" title="">
  <frameset rows="30%,70%" title="">
    <frame src="overview-frame.html" name="packageListFrame">
    <frame src="allclasses-frame.html" name="packageFrame">
  </frameset>
  <frame src="overview-summary.html" name="classFrame" scrolling="yes">
</frameset>
</html>]] );
    f:close();
end

function printStylesheet()
    local f = io.open( options.output_dir .. "/stylesheet.css", "w" );
    f:write( [[
body{
    background-color: #FFFFFF;
    color:#000000;
}

h1{
    font-size: 145%;
}

.TableHeadingColor{
    background: #CCCCFF;
    color:#000000;
}

.TableSubHeadingColor{
    background: #EEEEFF;
    color:#000000;
}

.TableRowColor{
    background: #FFFFFF;
    color:#000000;
}

.FrameTitleFont{
    font-size: 100%;
    font-family: Helvetica, Arial, sans-serif;
    color:#000000;
}

.FrameHeadingFont{
    font-size:  90%;
    font-family: Helvetica, Arial, sans-serif;
    color:#000000;
}

.FrameItemFont{
    font-size:  90%;
    font-family: Helvetica, Arial, sans-serif;
    color:#000000;
}

.NavBarCell1    { background-color:#EEEEFF; color:#000000}
.NavBarCell1Rev { background-color:#00008B; color:#FFFFFF}
.NavBarFont1    { font-family: Arial, Helvetica, sans-serif; color:#000000;color:#000000;}
.NavBarFont1Rev { font-family: Arial, Helvetica, sans-serif; color:#FFFFFF;color:#FFFFFF;}

.NavBarCell2    { font-family: Arial, Helvetica, sans-serif; background-color:#FFFFFF; color:#000000}
.NavBarCell3    { font-family: Arial, Helvetica, sans-serif; background-color:#FFFFFF; color:#000000}
]] );
    f:close();
end

---
-- ファイルの doc 情報から、フィールドについての doc 情報を取り出す
function getFields( fileDoc )
print( "getFields; fileDoc=" .. dump( fileDoc ) );
    local result = {};
    for i, info in pairs( fileDoc.doc ) do
        if( type( info.var ) ~= "nil" )then
            if( not (isPrivate( info.access ) and options.noprivate == 1) )then
                table.insert( result, info );
            end
        end
    end
    return result;
end

---
-- ファイルの doc 情報から、function についての doc 情報を取り出す
function getMethods( fileDoc )
    local result = {};
    for i, info in pairs( fileDoc.functions ) do
        if( type( info ) == "table" )then
            if( (not (isPrivate( info.access ) and options.noprivate == 1))
                or
                (not (info.name == "new" and isStatic( info.access ))) )then
                table.insert( result, info );
            end
        end
    end
    return result;
end

---
-- コンストラクタの情報を取り出す
function getConstructors( docinfo )
    local result = {};
    for i, info in pairs( docinfo ) do
        local clazz = info.class;
        if( clazz == "function" )then
            if( info.name == "new" and isStatic( info.access ) )then
                table.insert( result, info );
            end
        end
    end
    return result;
end

---
-- "(integer) 説明"のような文字列を、"integer", "説明"に分解する
function getType( comment )
    local startIndex = comment:find( "(", 1, true );
    if( startIndex == nil )then
        return "", comment;
    end
    local endIndex = comment:find( ")", startIndex, true );
    if( endIndex == nil )then
        return "", comment;
    end
    local t = comment:sub( startIndex + 1, endIndex - 1 );
    local c = comment:sub( endIndex + 1 );
    while( c:sub( 1, 1 ) == " " )do
        c = c:sub( 2 );
    end
    return t, c;
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
