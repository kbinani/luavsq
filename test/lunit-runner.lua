--[[
      begin()
        run(testcasename, testname)
          err(fullname, message, traceback)
          fail(fullname, where, message, usermessage)
          pass(testcasename, testname)
      done()

      Fullname:
        testcase.testname
        testcase.testname:setupname
        testcase.testname:teardownname
--]]


--require "lunit"

module( "lunit-runner", package.seeall )

r = {};

function begin()
end

function run( testcasename, testname )
    if( nil == r[testcasename] )then
        r[testcasename] = {};
    end
    r[testcasename][testname] = false;
end

function err( fullname, message, traceback )
end

function fail( fullname, where, message, usermessage )
end

function pass( testcasename, testname )
    r[testcasename][testname] = true;
end

function done()
    local isOK = true;
    for testcasename, tests in pairs( r ) do
        io.write( testcasename .. "\n" );
        for testname, result in pairs( tests ) do
            local prefix = " [";
            if( result )then
                prefix = prefix .. "x";
            else
                isOK = false;
                prefix = prefix .. " ";
            end
            prefix = prefix .. "] ";
            os.execute( "echo \"" .. prefix .. "\\033[0;32m" .. testname .. "\\033[0m\"" );
        end
        io.write( "\n" );
    end

    local tests = 0;
    for tcname in lunit.testcases() do
        for testname, test in lunit.tests(tcname) do
            tests = tests + 1
        end
    end
    local assertions = lunit.stats.assertions;
    local failures = lunit.stats.failed;

    if( isOK )then
        local message = string.format( "OK (%d test, %d assertions)", tests, assertions );
        os.execute( "echo \"\\033[42m\\033[3m" .. message .. "\\033[0m\"" );
    else
        local message = "FAILURES!";
        os.execute( "echo \"\\033[41m\\033[1;37m" .. message .. "\\033[0m\"" );
        message = string.format( "Tests: %d, Assertions: %d, Failures: %d.", tests, assertions, failures );
        os.execute( "echo \"\\033[41m\\033[1;37m" .. message .. "\\033[0m\"" );
    end
end

function var_dump( obj )
    if( obj == nil )then
        return
    end
--[[
"nil" (という文字列。nil 値ではなく。)
    "number"
    "string"
    "boolean"
    "table"
    "function"
    "thread"
    "userdata"
]]
    local t = type( obj );
    if( t == "string" or t == "number" )then
        return "" .. obj;
    elseif( t == "nil" )then
        return "nil";
    elseif( t == "boolean" )then
        if( obj == true )then
            return "true";
        else
            return "false";
        end
    elseif( t == "table" )then
        local result = "";
        local k, v;
        for k, v in pairs( obj )do
            result = result .. "    " .. var_dump( k ) .. "=" .. var_dump( v ) .. "\n";
        end
        return result;
    end
end
