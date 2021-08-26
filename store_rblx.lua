-- Converted using Mokiros's Model to Script Version 3
-- Converted string size: 2228 characters
local boombox = {}
local function Decode(str)
    local StringLength = #str

    -- Base64 decoding
    do
        local decoder = {}
        for b64code, char in pairs(('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='):split('')) do
            decoder[char:byte()] = b64code-1
        end
        local n = StringLength
        local t,k = table.create(math.floor(n/4)+1),1
        local padding = str:sub(-2) == '==' and 2 or str:sub(-1) == '=' and 1 or 0
        for i = 1, padding > 0 and n-4 or n, 4 do
            local a, b, c, d = str:byte(i,i+3)
            local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
            t[k] = string.char(bit32.extract(v,16,8),bit32.extract(v,8,8),bit32.extract(v,0,8))
            k = k + 1
        end
        if padding == 1 then
            local a, b, c = str:byte(n-3,n-1)
            local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
            t[k] = string.char(bit32.extract(v,16,8),bit32.extract(v,8,8))
        elseif padding == 2 then
            local a, b = str:byte(n-3,n-2)
            local v = decoder[a]*0x40000 + decoder[b]*0x1000
            t[k] = string.char(bit32.extract(v,16,8))
        end
        str = table.concat(t)
    end

    local Position = 1
    local function Parse(fmt)
        local Values = {string.unpack(fmt,str,Position)}
        Position = table.remove(Values)
        return table.unpack(Values)
    end

    local Settings = Parse('B')
    local Flags = Parse('B')
    Flags = {
        --[[ValueIndexByteLength]] bit32.extract(Flags,6,2)+1,
        --[[InstanceIndexByteLength]] bit32.extract(Flags,4,2)+1,
        --[[ConnectionsIndexByteLength]] bit32.extract(Flags,2,2)+1,
        --[[MaxPropertiesLengthByteLength]] bit32.extract(Flags,0,2)+1,
        --[[Use Double instead of Float]] bit32.band(Settings,0b1) > 0
    }

    local ValueFMT = ('I'..Flags[1])
    local InstanceFMT = ('I'..Flags[2])
    local ConnectionFMT = ('I'..Flags[3])
    local PropertyLengthFMT = ('I'..Flags[4])

    local ValuesLength = Parse(ValueFMT)
    local Values = table.create(ValuesLength)
    local CFrameIndexes = {}

    local ValueDecoders = {
        --!!Start
        [1] = function(Modifier)
            return Parse('s'..Modifier)
        end,
        --!!Split
        [2] = function(Modifier)
            return Modifier ~= 0
        end,
        --!!Split
        [3] = function()
            return Parse('d')
        end,
        --!!Split
        [4] = function(_,Index)
            table.insert(CFrameIndexes,{Index,Parse(('I'..Flags[1]):rep(3))})
        end,
        --!!Split
        [5] = {CFrame.new,Flags[5] and 'dddddddddddd' or 'ffffffffffff'},
        --!!Split
        [6] = {Color3.fromRGB,'BBB'},
        --!!Split
        [7] = {BrickColor.new,'I2'},
        --!!Split
        [8] = function(Modifier)
            local len = Parse('I'..Modifier)
            local kpts = table.create(len)
            for i = 1,len do
                kpts[i] = ColorSequenceKeypoint.new(Parse('f'),Color3.fromRGB(Parse('BBB')))
            end
            return ColorSequence.new(kpts)
        end,
        --!!Split
        [9] = function(Modifier)
            local len = Parse('I'..Modifier)
            local kpts = table.create(len)
            for i = 1,len do
                kpts[i] = NumberSequenceKeypoint.new(Parse(Flags[5] and 'ddd' or 'fff'))
            end
            return NumberSequence.new(kpts)
        end,
        --!!Split
        [10] = {Vector3.new,Flags[5] and 'ddd' or 'fff'},
        --!!Split
        [11] = {Vector2.new,Flags[5] and 'dd' or 'ff'},
        --!!Split
        [12] = {UDim2.new,Flags[5] and 'di2di2' or 'fi2fi2'},
        --!!Split
        [13] = {Rect.new,Flags[5] and 'dddd' or 'ffff'},
        --!!Split
        [14] = function()
            local flags = Parse('B')
            local ids = {"Top","Bottom","Left","Right","Front","Back"}
            local t = {}
            for i = 0,5 do
                if bit32.extract(flags,i,1)==1 then
                    table.insert(t,Enum.NormalId[ids[i+1]])
                end
            end
            return Axes.new(unpack(t))
        end,
        --!!Split
        [15] = function()
            local flags = Parse('B')
            local ids = {"Top","Bottom","Left","Right","Front","Back"}
            local t = {}
            for i = 0,5 do
                if bit32.extract(flags,i,1)==1 then
                    table.insert(t,Enum.NormalId[ids[i+1]])
                end
            end
            return Faces.new(unpack(t))
        end,
        --!!Split
        [16] = {PhysicalProperties.new,Flags[5] and 'ddddd' or 'fffff'},
        --!!Split
        [17] = {NumberRange.new,Flags[5] and 'dd' or 'ff'},
        --!!Split
        [18] = {UDim.new,Flags[5] and 'di2' or 'fi2'},
        --!!Split
        [19] = function()
            return Ray.new(Vector3.new(Parse(Flags[5] and 'ddd' or 'fff')),Vector3.new(Parse(Flags[5] and 'ddd' or 'fff')))
        end
        --!!End
    }

    for i = 1,ValuesLength do
        local TypeAndModifier = Parse('B')
        local Type = bit32.band(TypeAndModifier,0b11111)
        local Modifier = (TypeAndModifier - Type) / 0b100000
        local Decoder = ValueDecoders[Type]
        if type(Decoder)=='function' then
            Values[i] = Decoder(Modifier,i)
        else
            Values[i] = Decoder[1](Parse(Decoder[2]))
        end
    end

    for i,t in pairs(CFrameIndexes) do
        Values[t[1]] = CFrame.fromMatrix(Values[t[2]],Values[t[3]],Values[t[4]])
    end

    local InstancesLength = Parse(InstanceFMT)
    local Instances = {}
    local NoParent = {}

    for i = 1,InstancesLength do
        local ClassName = Values[Parse(ValueFMT)]
        local obj
        local MeshPartMesh,MeshPartScale
        if ClassName == "UnionOperation" then
            obj = DecodeUnion(Values,Flags,Parse)
            obj.UsePartColor = true
        elseif ClassName:find("Script") then
            obj = Instance.new("Folder")
            Script(obj,ClassName=='ModuleScript')
        elseif ClassName == "MeshPart" then
            obj = Instance.new("Part")
            MeshPartMesh = Instance.new("SpecialMesh")
            MeshPartMesh.MeshType = Enum.MeshType.FileMesh
            MeshPartMesh.Parent = obj
        else
            obj = Instance.new(ClassName)
        end
        local Parent = Instances[Parse(InstanceFMT)]
        local PropertiesLength = Parse(PropertyLengthFMT)
        local AttributesLength = Parse(PropertyLengthFMT)
        Instances[i] = obj
        for i = 1,PropertiesLength do
            local Prop,Value = Values[Parse(ValueFMT)],Values[Parse(ValueFMT)]

            -- ok this looks awful
            if MeshPartMesh then
                if Prop == "MeshId" then
                    MeshPartMesh.MeshId = Value
                    continue
                elseif Prop == "TextureID" then
                    MeshPartMesh.TextureId = Value
                    continue
                elseif Prop == "Size" then
                    if not MeshPartScale then
                        MeshPartScale = Value
                    else
                        MeshPartMesh.Scale = Value / MeshPartScale
                    end
                elseif Prop == "MeshSize" then
                    if not MeshPartScale then
                        MeshPartScale = Value
                        MeshPartMesh.Scale = obj.Size / Value
                    else
                        MeshPartMesh.Scale = MeshPartScale / Value
                    end
                    continue
                end
            end

            obj[Prop] = Value
        end
        if MeshPartMesh then
            if MeshPartMesh.MeshId=='' then
                if MeshPartMesh.TextureId=='' then
                    MeshPartMesh.TextureId = 'rbxasset://textures/meshPartFallback.png'
                end
                MeshPartMesh.Scale = obj.Size
            end
        end
        for i = 1,AttributesLength do
            obj:SetAttribute(Values[Parse(ValueFMT)],Values[Parse(ValueFMT)])
        end
        if not Parent then
            table.insert(NoParent,obj)
        else
            obj.Parent = Parent
        end
    end

    local ConnectionsLength = Parse(ConnectionFMT)
    for i = 1,ConnectionsLength do
        local a,b,c = Parse(InstanceFMT),Parse(ValueFMT),Parse(InstanceFMT)
        Instances[a][Values[b]] = Instances[c]
    end

    return NoParent
end


local Objects = Decode('AAB6IQVNb2RlbCEKV29ybGRQaXZvdAR3eHkhBFBhcnQhBE5hbWUhBERvb3IhCEFuY2hvcmVkIiENQm90dG9tU3VyZmFjZQMAAAAAAAAAACEGQ0ZyYW1lBBJ4eSEKQ2FuQ29sbGlkZQIhCE1hdGVyaWFsAwAAAAAAgJhAIQhQb3NpdGlvbgqgzMy+ZGbmvzMzQ0EhBFNp'
    ..'emUKzMysQGZm5kCzzEw+IQpUb3BTdXJmYWNlIQxUcmFuc3BhcmVuY3kDAAAAAAAA4D8EGnh5AwAAAAAAAHFACoCZmb7//6/AAM3MvQpnZqZBzMxMPmdmxkEEHXh5CpmZKcEAAAA1mZmZQArNzEw+MzMzQf//b0EEIHh5CjQzw0AAAAA1MzNDQQozM/NAMzMzQbPMTD4E'
    ..'I3h5CpmZKcEzM6NAzczswArNzEw+AACAPzMzI0EEJnh5CgEAIEEAAAA1AM3MvQrNzEw+MzMzQWZmxkEEKnh5AwAAAAAAgIBACs7MbEBmZobAAQDQwApmZkZBl5kZQDMzM0AELXh5CszM3MAAAAA1MzNDQQQveHkKmZkpwczMjMABAPDACs3MTD6YmRlA//8fQQQyeHkK'
    ..'MjOzwAAAADVmZkbBCjMzI0EzMzNBwMxMPgQ1eHkKmZkpwUgzMz9lZtbACs3MTD6ZmflA/f//QAQ4eHkK/P9fwM7MbEAzM0NBCmZmZkEyM3NAs8xMPgQ8eHkDAAAAAAAAgEAKnJlZQP//P8DNzMzACgAAUEG2zMw+mplZQAQ/eHkKmZkpwQAAADWamTnBCs3MTD4zMzNB'
    ..'YGbmPwRCeHkKgJmZvgEAsEAAzcy9CmdmpkHAzEw+ZmbGQSEKUG9pbnRMaWdodARGeHkKgJmZvgAAADVmZkbBCmdmpkEzMzNBwMxMPiEFUmFkaW8ETHp5IQtPcmllbnRhdGlvbgoAAAAAAAATQwAAAAAKH1f7QGDrAsDgqMTAIQhSb3RhdGlvbgoAADTDAAAEQgAANMMK'
    ..'UR/BP1EfwT9RH8E/IQtTcGVjaWFsTWVzaCEFU2NhbGUKUR9BP1EfQT9RH0E/IQZNZXNoSWQhKWh0dHA6Ly93d3cucm9ibG94LmNvbS9hc3NldC8/aWQ9MTUxNzYwMDMwIQlUZXh0dXJlSWQhFnJieGFzc2V0aWQ6Ly8xNTE3NjAwNzIhCE1lc2hUeXBlAwAAAAAAABRA'
    ..'IQRzaWduBFt4eQrAzMy+zsxsQGZmRkEK//+fQDIzc0CzzEw+IQpTdXJmYWNlR3VpIQ5aSW5kZXhCZWhhdmlvcgMAAAAAAADwPyEHQWRvcm5lZSEERmFjZQMAAAAAAAAAQCEOTGlnaHRJbmZsdWVuY2UhDVBpeGVsc1BlclN0dWQDAAAAAABAj0AhClNpemluZ01vZGUh'
    ..'CVRleHRMYWJlbCEQQmFja2dyb3VuZENvbG9yMwb///8hD0JvcmRlclNpemVQaXhlbAwAAIA/AAAAAIA/AAAhBEZvbnQDAAAAAAAACEAhCFJpY2hUZXh0IQRUZXh0IQllcGljIHN0b3IhClRleHRDb2xvcjMGAAAAIQpUZXh0U2NhbGVkIQhUZXh0U2l6ZQMAAAAAAABZ'
    ..'QCELVGV4dFdyYXBwZWQKgJmZvgAAADUAAIC1CgAAgD8AAAAAAAAAAAoAAAAAAACAPwAAAAAKJLNWvwAAAAB6bQu/FwEAAQACAwQBCgAFBgcICQoLDA0ODxAREhMUFQoWFwQBBwAHCAkKCxgPGREaExsVCgQBBwAHCAkKCxwPGREdEx4VCgQBBwAHCAkKCx8PGREgEyEV'
    ..'CgQBBwAHCAkKCyIPGREjEyQVCgQBBwAHCAkKCyUPGREmEycVCgQBBwAHCAkKCygPKREqEysVCgQBBwAHCAkKCywPGREtEyEVCgQBBwAHCAkKCy4PGREvEzAVCgQBBwAHCAkKCzEPGREyEzMVCgQBBwAHCAkKCzQPGRE1EzYVCgQBBwAHCAkKCzcPGRE4EzkVCgQBBwAH'
    ..'CAkKCzoPOxE8Ez0VCgQBBwAHCAkKCz4PGRE/E0AVCgQBBwAHCAkKC0EPGRFCE0MVCkQQAAAEAQcABwgJCgtFDxkRRhNHFQoEAQoABUgHCAkKC0kNDkpLEUxNThNPFQpQEwQAUVJTVFVWV1gEAQgABVkHCAkKC1oPGRFbE1wVCl0VBQBeX2FiY19kZWZfZxYKAGhpagoT'
    ..'a2xtbghvcHFycwh0dXYIARZgFQ==')

tweenservice = game:GetService("TweenService")
for _,obj in pairs(Objects) do
	obj.Parent = script
end
local main = owner.Character.HumanoidRootPart
local cframe = CFrame.new(main.CFrame.X,main.CFrame.Y + 3,main.CFrame.Z)
for _,v in pairs(script:GetDescendants()) do
    if v:IsA("BasePart") then
        obj = v
        obj.Transparency = 1
        if obj.Name ~= "Door" then
            tweenservice:Create(obj,TweenInfo.new(0.5),{
                Transparency = 0
            }):Play()
        else
            tweenservice:Create(obj,TweenInfo.new(0.5),{
                Transparency = 0.6
            }):Play()
        end
        v.CFrame = (v.CFrame:Inverse() * (cframe:Inverse())):Inverse()
    end
end
local CoolMusic = {142300919, --Happy Day in Robloxia
    188645941, --ROBLOXia's Last Stand
    249657166, --Chrono Symphonic - Darkness Dueling (Plastic Men and Iron Blades)
    5943732257, --Noob Alert!
    863998265, --Laidback Danger
    5039086600, --Crossroad Times
    4518314445, --Deceiving Match!
    846415183, --Training Day
    27697348, --Better Off Alone (remix)
    4575329367, --Jeff Syndicate - Hip Hop
    488980937, --Solaris ft. Phawk ~ Packet Power.
    3585481594, --Daniel Bautista - Flight of the Bumblebee
    251818328, --Daniel Bautista - Intro
    5034052016, --Zero Project - Gothic
    5710718745, --Shadow of the Colossus - The Opened Way
    170955412, --Cursed Abbey - Full Version
    4574605694, --Positively Dark - Awakening
    5894765220, --Halo 2 Theme Song
    2400723864, --M.U.L.E (Bitblaster Mix)
    959108662, --Nezzera
    5894821207, --Roblox Soundtrack - Bob-omb Battlefield
    4903029140, --Caramella Girls - Caramelldansen Swedish Original
    4620422621, --The Great Strategy
    5894815772, --Roblox Soundtrack - Come On (Tunnel)
    2801308469, --ssbm Final Destination
    4974638085, --Star Fox 64 Opening Theme
    4244843485, --Star Fox - Corneria
    4611725905, --Wind of Fjords 
    5816216620, --Roblox Soundtrack - Explore ROBLOX
    257700160, --Outrun the Nightmare [Temple of the Ninja Masters]
    5894760203, --Roblox Soundtrack - Cube Land
}
local sound = ""
function ChangeSong(song)
    if CoolMusic[math.random(1,#CoolMusic)] ~= sound then
        sound = CoolMusic[math.random(1,#CoolMusic)]
    else
        task.spawn(function()
            task.wait()
            ChangeSong()
        end)
    end
end
local SoundRemote = Instance.new("RemoteEvent")
local SongRemote = Instance.new("RemoteEvent")
radio = nil 
loudness= 25
SoundRemote.Name = "SoundRemote"
SoundRemote.Parent = owner
SoundRemote.OnServerEvent:Connect(function(pl,ld)
    loudness = ld
end)
SongRemote.Name = "SongRemote"
SongRemote.Parent = owner
SongRemote.OnServerEvent:Connect(function(pl)
    sound = CoolMusic[math.random(1,#CoolMusic)]
end)
NLS([==[
task.wait()
script.Parent = nil
local mouse = owner:GetMouse()
mouse.KeyDown:connect(function(k)
k = k:lower()
if k == "t" then
owner.SongRemote:FireServer()
end
end)
owner.SoundRemote.OnClientEvent:connect(function(snd)
owner.SoundRemote:FireServer(snd.PlaybackLoudness)
end)
]==],owner.PlayerGui)
for _,v in pairs(script:GetDescendants()) do
    if v.Name == "Radio" then
        siz = v.Size
        sc = v:GetChildren()[1].Scale
        local song = Instance.new("Sound",v)
        song.TimePosition = 0
        song.Looped = false
        song.Name = "SongForEpic".. owner.Name
        sound = CoolMusic[math.random(1,#CoolMusic)]
        song.SoundId = "rbxassetid://"..tostring(sound)
        song.Playing = true
        do
            SoundValue = Instance.new("ObjectValue",owner)
            SoundValue.Name = "SoundValue"
            SoundValue.Value = song
        end
        task.spawn(function()
            while true do
                song.Ended:wait()
                ChangeSong(song)
            end
        end)
        task.spawn(function()
            while true do 
                v:GetChildren()[1].Scale = Vector3.new(sc.X+loudness/340,sc.Y+loudness/340,sc.Z+loudness/340)
                SoundRemote:FireAllClients(song)
                song.SoundId = "rbxassetid://"..tostring(sound)
                task.wait()
            end
        end)
        radio = v
        warn("radio found lo")
    end
end
function getcola()
    local cola = Instance.new("Tool")
    cola.Parent = owner.Backpack
    cola.RequiresHandle = false
    cola.CanBeDropped = true 
    local handle = Instance.new("SpawnLocation",cola)
    handle.Name = "Handle"
    handle.Neutral = false
    handle.Anchored = false
    handle.Size = Vector3.new(1, 1.2, 1)
    local drink = Instance.new("Sound",handle)
    drink.Volume = 0.5
    drink.SoundId = "http://www.roblox.com/asset/?id=10722059"
    drink.Name = "DrinkSound"
    local open = Instance.new("Sound",handle)
    open.Volume = 0.5
    open.SoundId = "http://www.roblox.com/asset/?id=10721950"
    open.Name = "OpenSound"
    local mesh = Instance.new("SpecialMesh",handle)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "http://www.roblox.com/asset/?id=10470609"
    mesh.TextureId = "http://www.roblox.com/asset/?id=10470600"
    mesh.Scale = Vector3.new(1.2,1.2,1.2)
    mesh.Name = "Mesh"
    NS([==[
    task.wait(0.5)
    warn("Tool loaded!")
    script.Name = "ToolScript"
    
    local Tool = script.Parent;

enabled = true




function onActivated()
	if not enabled  then
		return
	end

	enabled = false
	Tool.GripForward = Vector3.new(0,-.759,-.651)
	Tool.GripPos = Vector3.new(1.5,-.5,.3)
	Tool.GripRight = Vector3.new(1,0,0)
	Tool.GripUp = Vector3.new(0,.651,-.759)


	Tool.Handle.DrinkSound:Play()

	wait(3)
	
	local h = Tool.Parent:FindFirstChild("Humanoid")
	if (h ~= nil) then
		if (h.MaxHealth > h.Health + 5) then
			h.Health = h.Health + 5
		else	
			h.Health = h.MaxHealth
		end
	end

	Tool.GripForward = Vector3.new(-.976,0,-0.217)
	Tool.GripPos = Vector3.new(0.03,0,0)
	Tool.GripRight = Vector3.new(.217,0,-.976)
	Tool.GripUp = Vector3.new(0,1,0)

	enabled = true

end

function onEquipped()
	Tool.Handle.OpenSound:play()
end

script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)
warn("Tool init.")
]==], cola)
end
function getBurger() do
    local cola = Instance.new("Tool")
    cola.Parent = owner.Backpack
    cola.RequiresHandle = false
    cola.CanBeDropped = true 
    local handle = Instance.new("SpawnLocation",cola)
    handle.Name = "Handle"
    handle.Neutral = false
    handle.Anchored = false
    handle.Size = Vector3.new(1, 0.8, 1)
    local drink = Instance.new("Sound",handle)
    drink.Volume = 0.5
    drink.SoundId = "http://www.roblox.com/asset/?id=16647579"
    drink.Name = "DrinkSound"
    local open = Instance.new("Sound",handle)
    open.Volume = 0.5
    open.SoundId = "http://www.roblox.com/asset/?id=16647570"
    open.Name = "OpenSound"
    local mesh = Instance.new("SpecialMesh",handle)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "http://www.roblox.com/asset/?id=16646125"
    mesh.TextureId = "http://www.roblox.com/asset/?id=16432575"
    mesh.Scale = Vector3.new(1,1,1)
    mesh.Name = "Mesh"
    NS([==[
    task.wait(0.5)
    warn("Tool loaded!")
    script.Name = "ToolScript"
    
    local Tool = script.Parent;

enabled = true




function onActivated()
	if not enabled  then
		return
	end

	enabled = false
	Tool.GripForward = Vector3.new(0,-.759,-.651)
	Tool.GripPos = Vector3.new(1.5,-.5,.3)
	Tool.GripRight = Vector3.new(0,0,0)
	Tool.GripUp = Vector3.new(0,.651,-.759)


	Tool.Handle.DrinkSound:Play()

	wait(3)
	
	local h = Tool.Parent:FindFirstChild("Humanoid")
	if (h ~= nil) then
		if (h.MaxHealth > h.Health + 25) then
			h.Health = h.Health + 25
		else	
			h.Health = h.MaxHealth
		end
	end

	Tool.GripForward = Vector3.new(-.976,0,-0.217)
	Tool.GripPos = Vector3.new(0.03,0,0)
	Tool.GripRight = Vector3.new(.217,0,-.976)
	Tool.GripUp = Vector3.new(0,1,0)

	enabled = true

end

function onEquipped()
	Tool.Handle.OpenSound:play()
end

script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)
warn("Tool init.")
]==], cola)
end
end
owner.Chatted:connect(function(msg)
    local args = msg:split("#item ")
    if args[2] ~= nil then
        if args[2]:sub(1,#"cola") == "cola" then
            local num = tonumber(args[2]:sub(#"cola"+1))
            if num ~= nil then
                if typeof(num) == 'number' and num ~= nil then
                    for l1 = 0,num,1 do 
                        getcola()
                    end
                else
                    getcola()
                end
            else
                getBurger()
            end
        elseif args[2]:sub(1,#"cheeseburger") == "cheeseburger" then
            local num = tonumber(args[2]:sub(#"cheeseburger"+1))
            if num ~= nil then
                if typeof(num) == 'number' and num ~= nil then
                    for l1 = 0,num,1 do 
                        getBurger()
                    end
                else
                    getBurger()
                end
            else
                getBurger()
            end
        end
    end
end)
