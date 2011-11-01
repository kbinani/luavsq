LuaUnitResult = {}

LuaUnitResult.new = function()
    local this = {}

    this.name = ""
    this.class = ""
    this.file = ""
    this.line = 0
    this.assertions = 0
    this.time = 0.0
    this.failures = {}
    this.errors = {}

    return this
end

LuaUnitTestCase = {}

LuaUnitTestCase.new = function()
    local this = {}

    this.results = {}

    this.assertEquals = function( self, expected, actual )
    end

    this.assertTrue = function( self, actual )
        local result = LuaUnitResult.new()
        self.assertions = self.assertions + 1
        if( not actual )then
            local message = "Failed asserting that &lt;boolean:false&gt; is true."
            table.insert( self.failures, message )
        end
        table.insert( self.results, result )
    end

    this.assertFalse = function( self, actual )
    end

    this.debugPrint = function( self )
        for i = 0, table.maxn( self.failures ), 1 do
            print( self.failures[i] )
        end
    end

end

SampleTestCase = {}
SampleTestCase.new = function()
    local this = {}
    local parent = LuaUnitTestCase.new()
    setmetatable( this, { __index = parent } )

    this.testFoo = function( self )
        self:assertTrue( true )
    end

    return this
end

local obj = SampleTestCase.new()
obj:testFoo()
