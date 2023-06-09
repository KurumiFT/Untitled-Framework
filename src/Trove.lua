-- Trove implementation module

local function destroy(object : Instance | () -> nil | { any } | RBXScriptConnection)
    local _type = typeof(object)
    if _type == 'Instance' then object:Destroy(); return end
    if _type == 'function' then object() end
    if _type == 'RBXScriptConnection' then object:Disconnect() end
    if _type == 'table' then
        if object['Destroy'] then object:Destroy() end
    end

    -- TODO: Add Order here
end

local Trove = {}
Trove.__newindex = function(self, index, value)
    if self.collection[index] then destroy(self.collection[index]) end

    self.collection[index] = value
end

Trove.__index = function(self, index)
    return self.collection[index]
end

function Trove:add(object : any)
    table.insert(self.collection, object)
    return object
end

function Trove:Destroy()
    for _, v in pairs(self.collection) do
        destroy(v)
    end

    for _, v in ipairs(self.collection) do
        destroy(v)
    end

    self.collection = {}
end

function Trove.new()
    local self = setmetatable({
        collection = {}
    }, Trove)
end