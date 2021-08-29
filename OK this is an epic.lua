char = owner.Character 
COS = math.cos
SIN = math.sin
local SINE= 0
RAD = math.rad
for _,v in pairs(owner:GetDescendants()) do if v.Name == "Remote" or v.Name == "MouseEvent" then v:Destroy() end end
task.wait()
local sn = 0
removed = nil
Remote = Instance.new("RemoteEvent",owner)
Remote.Name = "Remote"
local atacc
local Mouse = {Hit=CFrame.new(0,0,0),Target=nil}
function tween(a,b,c)
    return game:GetService("TweenService"):Create(a,TweenInfo.new(unpack(b)),c)
end
function debris(b,c)
    pcall(function()
        game:GetService("Debris"):AddItem(b,(c or 1))
    end)
end
function debree(tble)
    local ammount = (tble.ammount or 35)
    local from = (tble.from or CFrame.new(0, 0, 0))
    local s = 1
    task.spawn(function()
        for i = 0,ammount,s do
            local Debree = Instance.new("SpawnLocation",script)
            Debree.Neutral = false
            Debree.CFrame = from
            Debree.Size = Vector3.new(math.random(-6,6),math.random(-6,6),math.random(-6,6))
            Debree.Anchored = true
            Debree.CanCollide = false
            tween(Debree,{0.5},{
                CFrame = from * CFrame.new(math.random(-24,24),math.random(-24,24),math.random(-24,24))*CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360)))
            }):Play()
            task.spawn(function()
                for i = 1,math.random(6,16) do task.wait() end
                tween(Debree,{0.5},{
                    Transparency = 1
                }):Play()
                debris(Debree,0.5)
            end)
        end
    end)
end
local tweens = game:GetService("TweenService")
function Create(class,properties)
    local obj = Instance.new(class)
    pcall(function()
        for k,v in pairs(properties) do
            obj[k] = v
        end
    end)
    return obj
end
function brick(mainpos,ms)
    task.spawn((function()
        local doattack = true
        for i2 = 1,35 do
            local e = 0
            local a = 100
            local partpos = mainpos
            local movingpart = Create("Part",{CFrame=partpos,Parent=script,Size=Vector3.new(2,2,2)*math.random(1,1.1),Material="Glass",Color=Color3.fromRGB(151, 0, 0),Anchored=true,CanCollide=false})
            movingpart.CFrame= mainpos*CFrame.new(0,a/10,0)
            task.spawn((function()
                local where = CFrame.new(movingpart.Position,ms.p) local distance = (movingpart.Position - ms.p).magnitude
                local x,y,z = 0,0,0
                for i = 1, 70 do game:GetService("RunService").Stepped:wait() 
                    x+=0.05
                    y+=0.1
                    z+=0.05
                    partpos = where*CFrame.new(0,(70/200)+((70/70)-((i*2.7)/70)),-distance/70)
                    where = partpos
                    movingpart.Size = Vector3.new(2+(i2/12),2+(i2/12),2+(i2/12))
                    movingpart.CFrame=partpos*CFrame.Angles(x,y,z)
                end
                if doattack then
                    doattack = false
                    pcall(function()
                        for _,v in pairs(workspace:GetDescendants()) do
                            if not v == movingpart then
                                if v:IsA("BasePart") then
                                    if (v.CFrame.p - movingpart.CFrame.p).Magnitude <= 5 then
                                        v.CFrame = CFrame.new(0,9e9,0)
                                        local CFrameChanged = v:GetPropertyChangedSignal("CFrame"):connect(function(pos)
                                            if pos ~= CFrame.new(0,1e6,0) then
                                                v.CFrame = CFrame.new(0,9e9,0)
                                            end
                                        end)
                                        local AncestryChanged
                                        AncestryChanged = v.AncestryChanged:Connect(function(parent)
                                            if parent ~= workspace then
                                                CFrameChanged:Disconnect()
                                                AncestryChanged:Disconnect()
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                end
                debris(movingpart,0)
            end))
            task.wait()
        end
    end))
end
mainpos = CFrame.new(0, 15, -10)
Remote.OnServerEvent:connect(function(pl,m,a,b)
    if m == "stuff" then
        pcall(function()
            mainpos,Moving = a,b
        end)
    elseif m == "mouse" then
        Mouse.Hit,Mouse.Target = a,b
    elseif m == "brick" then
        brick(mainpos,Mouse.Hit)
    elseif m == "mugen" then
        local L__0 = Instance.new('SpawnLocation', script) L__0.Color = Color3.fromRGB(159, 161, 172) L__0.Material = Enum.Material.Slate L__0.Anchored = false L__0.Reflectance = -1 L__0.Size = Vector3.new(10.081, 10.081, 10.081) local Decal__1 = Instance.new('Decal', L__0) Decal__1.Texture = 'rbxassetid://1410504025' Decal__1.Transparency = 0.05
        L__0.CFrame = CFrame.new(Mouse.Hit.p) * CFrame.new(0, 15, 0)
        L__0.Shape = Enum.PartType.Ball
        local BodyGyro__2 = Instance.new("BodyGyro",L__0)
        local BodyPosition__3 = Instance.new("BodyPosition",L__0)
        NS([==[
        task.spawn(function()
        bin = script.Parent

function move(target)
	local dir = (target.Position - bin.Position).unit
	local spawnPos = bin.Position
	local pos = spawnPos + (dir * 1)
	bin:findFirstChild("BodyGyro").cframe = CFrame.new(pos,  pos + dir)
	bin:findFirstChild("BodyGyro").maxTorque = Vector3.new(9000,9000,9000)
end

function moveTo(target)
	bin.BodyPosition.position = target.Position
	bin.BodyPosition.maxForce = Vector3.new(10000,10000,10000) * bin.Speed.Value
end

function findNearestTorso(pos)
	local list = game.Workspace:GetChildren()
	local torso = nil
	local dist = 1000
	local temp = nil
	local human = nil
	local temp2 = nil
	for x = 1, #list do
		temp2 = list[x]
		if (temp2.className == "Model") and (temp2 ~= script.Parent) then
			temp = temp2:findFirstChild("Head")
			human = temp2:findFirstChildOfClass("Humanoid")
			if (temp ~= nil) and (human ~= nil) and (human.Health > 0)  then
				if (temp.Position - pos).magnitude < dist then
					torso = temp
					dist = (temp.Position - pos).magnitude
				end
			end
		end
	end
	return torso
end

while true do
	local torso = findNearestTorso(bin.Position)
	if torso~=nil then
		move(torso)
		moveTo(torso)
	end
	wait()
end

end)
        chat = game:GetService("Chat")
phrases = {
"hallo",
"asd",
"nem",
"OK this is an epic",
"könyörög",
"?",
"igen",
"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
"🤠",
"Dresmor alakazard is immortal",
}

coroutine.resume(coroutine.create(function()
while wait(math.random(3,8)) do
	chat:Chat(script.Parent, phrases[math.random(1,#phrases)],3)
end
end))
local debo = false
script.Parent.Touched:Connect(function(v)
if v.Parent:FindFirstChild("Humanoid") then
	if debo == true then return end
	debo = true
	local mk = math.random(1,3)
	if mk == 1 then
		chat:Chat(script.Parent, "STOP",3)
	elseif mk == 2 then
		chat:Chat(script.Parent, "GET OFF ME",3)
	elseif mk == 2 then
		chat:Chat(script.Parent, "GET DOWN",3)
	end
	wait(math.random(1,3))
	debo = false
end
end)
]==],L__0)
    
    end
end)
NLS([==[
if not game.Loaded then
    game.Loaded:Wait()
end
wait(1/60)
script.Parent = nil
local WalkSpeed = 16
local FlyMode = false
local CFrameValue = Instance.new("CFrameValue")
CFrameValue.Value = CFrame.new(0, 15, 0)
local LocalPlayer = game:GetService("Players").LocalPlayer
local mainpos = CFrame.new(0,25,0)
local PotentialCFrame, OldCFrame, Moving, LastFrame = mainpos, mainpos, false, tick()
CFrameValue.Value = mainpos
local UserInputService = game:GetService("UserInputService")
local RayProperties = RaycastParams.new()
RayProperties.IgnoreWater,RayProperties.FilterType = true,Enum.RaycastFilterType.Blacklist
local function KeyDown(Key)
    return not game:GetService("UserInputService"):GetFocusedTextBox() and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode[Key]) or false
end
local function KeyUp(Key)
    return not game:GetService("UserInputService"):GetFocusedTextBox() and not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode[Key]) or false
end
    local MouseProps,Hit,Target = RaycastParams.new(),CFrame.new(),nil
game:GetService'UserInputService'.InputBegan:Connect(function(Input,sa)
    if sa then return end 
    if Input.KeyCode == Enum.KeyCode.F then
        FlyMode = not FlyMode
    end
        if Input.KeyCode == Enum.KeyCode.N then
        task.spawn(function()
        owner.Remote:FireServer("Song")
        end)
elseif Input.KeyCode == Enum.KeyCode.Z then
        task.spawn(function()
owner.Remote:FireServer("mugen")
        end)
    end
end)
warn("same")

game:GetService("RunService").RenderStepped:Connect(function()
    MouseProps.FilterType = Enum.RaycastFilterType.Blacklist
    pcall(function()
    owner.Remote:FireServer("mouse",Hit,Target)
    end)
    MouseProps.FilterDescendantsInstances = {workspace:FindFirstChild(LocalPlayer.Name),workspace.Terrain} -- add stuff if youy want loser
    local MousePosition = game:GetService("UserInputService"):GetMouseLocation()-game:GetService("GuiService"):GetGuiInset()
    local UnitRay = workspace.CurrentCamera:ScreenPointToRay(MousePosition.X,MousePosition.Y)
    local Ray_ = workspace:Raycast(UnitRay.Origin,UnitRay.Direction*1e3,MouseProps)
    Hit,Target = Ray_ and CFrame.new(Ray_.Position) or CFrame.new(),Ray_ and Ray_.Instance or nil
    local LookVector = workspace.CurrentCamera.CFrame.LookVector
    local Closest, __L = math.huge, nil
    local _Ray = nil
    local _Raycasts = {}
    if (UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default) then
        if not FlyMode then
            mainpos = CFrame.new(mainpos.p,Vector3.new(mainpos.X+LookVector.X,mainpos.Y,mainpos.Z+LookVector.Z))
        else
            mainpos = CFrame.new(mainpos.p,mainpos.p+LookVector)
        end
    end
    for b,_Raycast in pairs(_Raycasts) do
        local Magnitude = (mainpos.Position-_Raycast.Position).Magnitude
        if Magnitude < Closest then
            Closest,_Ray = Magnitude,_Raycast
        end
    end
    table.clear(_Raycasts)
    pcall(function()
        game:GetService'TweenService':Create(CFrameValue,TweenInfo.new(0.1),{
            Value = mainpos
        }):Play()
        owner.Remote:FireServer("stuff",CFrameValue.Value,Moving)
        RayProperties.FilterDescendantsInstances = {workspace:FindFirstChild(LocalPlayer.Name)}
    end)
    pcall(function()
    Part = workspace:FindFirstChild(LocalPlayer.Name).Head
    workspace.CurrentCamera.CameraSubject = Part
    end)
    if not FlyMode then
    pcall(function()
    local Ray = workspace:Raycast(mainpos.Position-Vector3.new(0,1,0),Vector3.new(0,-9e9,0),RayProperties)
    if Ray then
    mainpos = CFrame.new(0,(Ray.Position.Y-mainpos.Y)+3,0)*mainpos
    end
    end)
    end
    if FlyMode then
        PotentialCFrame = CFrame.new(mainpos.p,mainpos.p+LookVector)
    else
        PotentialCFrame = CFrame.new(mainpos.p,Vector3.new(mainpos.X+LookVector.X,mainpos.Y,mainpos.Z+LookVector.Z))
    end
    OldCFrame = mainpos
    if KeyDown("W") then
        PotentialCFrame = PotentialCFrame *  CFrame.new(0,0,-1)
    end
    if KeyDown("A") then
        PotentialCFrame   = PotentialCFrame *  CFrame.new(-1,0,0)
    end
    if KeyDown("S") then
        PotentialCFrame = PotentialCFrame * CFrame.new(0,0,1)
    end
    if KeyDown("D") then
        PotentialCFrame = PotentialCFrame * CFrame.new(1,0,0)
    end
    if KeyDown("Space") and _Ray and pcall(function()
            workspace:Raycast(mainpos.Position-Vector3.new(0,1,0),Vector3.new(0,-9e9,0),RayProperties)
        end) then
        PotentialCFrame = PotentialCFrame * CFrame.new(0,1,0)
    end
    if (PotentialCFrame.X ~= OldCFrame.X or PotentialCFrame.Z ~= OldCFrame.Z) then
        Moving = true
        mainpos = mainpos:Lerp(CFrame.new(mainpos.p,PotentialCFrame.p)*CFrame.new(0,0,(tick()-LastFrame)*-(WalkSpeed)), 0.65)
    else
        Moving = false
    end
    LastFrame = tick()
end)
]==],owner.PlayerGui)
wait(0.1)
owner:LoadCharacter()
wait(1)
local RNG = Random.new()
local hat = Instance.new("SpawnLocation",script)
hat.Neutral = false
hat.Name = math.random().."Sun"
hat.Size = Vector3.new(2,2,2)
local mesh = Instance.new("SpecialMesh",hat)
mesh.MeshId = "http://www.roblox.com/asset/?id=84385433"
mesh.Scale = Vector3.new(0.95, 1, 0.99)
task.spawn(function()
    while 0/0 do
        wait(0.1)
        if not hat or not pcall(function()
                hat.Parent = script
                hat.Reflectance = 0.25
                hat.CanCollide = false
                hat.Anchored = true
                hat.Color = Color3.fromRGB(255,0,0)
            end) then
            game:GetService("Debris"):AddItem(hat,0)
            hat = Instance.new("SpawnLocation",script)
            hat.Neutral = false
            hat.Name = math.random().."Sun"
            hat.Size = Vector3.new(2,2,2)
        end
        if not mesh or not pcall(function()
                mesh.Parent = hat
                mesh.MeshId = "http://www.roblox.com/asset/?id=84385433"
                mesh.Scale = Vector3.new(0.95, 1, 0.99)
            end) then
            game:GetService("Debris"):AddItem(mesh,0)
            mesh = Instance.new("SpecialMesh",hat)
            mesh.MeshId = "http://www.roblox.com/asset/?id=84385433"
            mesh.Scale = Vector3.new(0.95, 1, 0.99)
        end
    end
end)
local c = {}
for _,v in pairs(owner.Character:GetChildren()) do
    if v:IsA("BasePart") then
        local         PartName = tostring(v.Name)
        warn(v.Name == PartName)
        
        local New = v:Clone()
        New.Parent = script
        New.Anchored = true
        New:BreakJoints()
        New.CanCollide = false
        local Fake = New:Clone()
        Fake.Parent = owner
        task.spawn(function()
            while script:IsDescendantOf(game) do
                if not New or not pcall(function()
                        New.Parent = script
                        New.Anchored = true
                        New.CanCollide = false
    
                        New.Color = Color3.fromRGB(255, 0, 0)
                        New.Reflectance = 0.5
                    end) then
                    game:GetService("Debris"):AddItem(New,0)
                    New = Fake:Clone()
                    New.Parent = script
                end
                pcall(function()
                    for _,v in pairs(New:GetChildren()) do
                        if v:IsA("Decal") and v.Parent.Name == "Head" then
                            v.Texture = "rbxassetid://138437944"
                        end
                    end
                end)
task.wait()
            end
        end)
    end
end
wait(0.5)
Sine = 0
task.spawn(function()
    while wait(0.1) do
        Sine = (tick()*30)
    end
end)
game:GetService("RunService").Stepped:Connect(function()
    if owner.Character then
        owner.Character = nil
    end
    script.Name = owner.Name
    if not Moving then
        c.Torso = mainpos
        c.Head = c.Torso*CFrame.new(0,1.5,0)
        c["Right Arm"] = c.Torso*CFrame.new(1.5,0,-0.09*math.sin(Sine/25))*CFrame.Angles(math.rad(2*math.sin(Sine/25)),0,0)
        c["Left Arm"] = c.Torso*CFrame.new(-1.5,0,0.09*math.sin(Sine/25))*CFrame.Angles(math.rad(-2*math.sin(Sine/25)),0,0)
        c["Right Leg"] = c.Torso*CFrame.new(0.5,-2,0.09*math.sin(Sine/25))*CFrame.Angles(math.rad(-2*math.sin(Sine/25)),0,0)
        c["Left Leg"] = c.Torso*CFrame.new(-0.5,-2,-0.09*math.sin(Sine/25))*CFrame.Angles(math.rad(2*math.sin(Sine/25)),0,0)
    else
        c.Torso = mainpos
        c.Head = c.Torso*CFrame.new(0,1.5,0)
        c["Right Arm"] = c.Torso*CFrame.new(1.5,0,-0.6*math.sin(Sine/25))*CFrame.Angles(math.rad(35*math.sin(Sine/25)),0,0)
        c["Left Arm"] = c.Torso*CFrame.new(-1.5,0,0.6*math.sin(Sine/25))*CFrame.Angles(math.rad(-35*math.sin(Sine/25)),0,0)
        c["Right Leg"] = c.Torso*CFrame.new(0.5,-2,0.6*math.sin(Sine/25))*CFrame.Angles(math.rad(-35*math.sin(Sine/25)),0,0)
        c["Left Leg"] = c.Torso*CFrame.new(-0.5,-2,-0.6*math.sin(Sine/25))*CFrame.Angles(math.rad(35*math.sin(Sine/25)),0,0)
    end
    pcall(function()
        for _,v in pairs(script:GetChildren()) do
            if c[v.Name] ~= nil then
                v.CFrame = c[v.Name]
            end
        end
    end)
    pcall(function()
        hat.CFrame = c.Head*CFrame.new(-0, 0.604, 0.147)
    end)
end)
