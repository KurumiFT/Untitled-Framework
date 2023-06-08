-- Mail component

local Mail = {}
Mail.__type = 'Mail'

function Mail.new(link : Instance)
    if typeof(link) ~= 'Instance' then error('Link should be Event-like!', 2) end

    local self = {
        boxes = {}, 
        orders = {},
        link = link
    }

    if link.ClassName == 'RemoteEvent' then
        self.remote = true
    elseif link.ClassName == 'BindableEvent' then
        self.remote = false
    else
        error('Link should be Event-like!', 2)
    end

    return setmetatable(self, Mail)
end