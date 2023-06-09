-- Mail component
local RunService = game:FindService('RunService')

local IsServer = RunService:IsServer()

local Message = {}
Message.__type = 'Message'
Message.__call = function(self, ... : any)
    local id = self.id or tick()

    if self.mail.remote then
        if IsServer then
            local args = {...}
            if typeof(args[1]) ~= 'Instance' or args[1]:IsA('Player') then error('First argument should be player!', 2) end
            local target_player : Player = table.remove(args, 1)

            self.mail.link:FireClient(target_player, id, self.recipient, unpack(args))
        else
            self.mail.link:FireClient(id, self.recipient, ...)
        end
    else
        self.mail.link:Fire(id, self.recipient, ...)
    end    
end

function Message.new(mail, recipient : string, id : number?)
    return setmetatable({ 
        mail = mail,
        recipient = recipient,
        id = id
    }, Message)
end

local Mail = {}
Mail.__type = 'Mail'
Mail.__newindex = function(self, index : string, value : (...any) -> any)
    if typeof(index) ~= 'string' then error('Box index can be only string!', 2) end
    if typeof(value) ~= 'function' then error('Box value can be only function!', 2) end
    
    -- TODO: Make possible to set nil for index, to remove box!
    self.boxes[index] = value
end
Mail.__index  = function(self, index : string)
    if Mail[index] then return Mail[index] end
    
    -- TODO:  Add Possible to call forward to box if this bindable event!

    return Message.new(self, index)
end

function Mail.new(link : Instance)
    if typeof(link) ~= 'Instance' then error('Link should be Event-like!', 2) end

    local self = {
        boxes = {}, 
        orders = {},
        link = link
    }

    if link:IsA('RemoteEvent') then
        self.remote = true
    elseif link:IsA('BindableEvent') then
        self.remote = false
    else
        error('Link should be Event-like!', 2)
    end

    return setmetatable(self, Mail)
end

return Mail