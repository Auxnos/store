-- Converted using Mokiros's Model to Script Version 3
-- Converted string size: 2120 characters

local ScriptFunctions = {
function(script,require)
function waitForChild(parent, childName)
	local child = parent:findFirstChild(childName)
	if child then return child end
	while true do
		child = parent.ChildAdded:wait()
		if child.Name==childName then return child end
	end
end

-- ANIMATION

-- declarations

local Figure = script.Parent
local Torso = waitForChild(Figure, "Torso")
local RightShoulder = waitForChild(Torso, "Right Shoulder")
local LeftShoulder = waitForChild(Torso, "Left Shoulder")
local RightHip = waitForChild(Torso, "Right Hip")
local LeftHip = waitForChild(Torso, "Left Hip")
local Neck = waitForChild(Torso, "Neck")
local Humanoid = waitForChild(Figure, "Humanoid")
local pose = "Standing"

local toolAnim = "None"
local toolAnimTime = 0

local jumpMaxLimbVelocity = 0.75

-- functions

function onRunning(speed)
	if speed>0 then
		pose = "Running"
	else
		pose = "Standing"
	end
end

function onDied()
	pose = "Dead"
end

function onJumping()
	pose = "Jumping"
end

function onClimbing()
	pose = "Climbing"
end

function onGettingUp()
	pose = "GettingUp"
end

function onFreeFall()
	pose = "FreeFall"
end

function onFallingDown()
	pose = "FallingDown"
end

function onSeated()
	pose = "Seated"
end

function onPlatformStanding()
	pose = "PlatformStanding"
end

function onSwimming(speed)
	if speed>0 then
		pose = "Running"
	else
		pose = "Standing"
	end
end

function moveJump()
	RightShoulder.MaxVelocity = jumpMaxLimbVelocity
	LeftShoulder.MaxVelocity = jumpMaxLimbVelocity
  RightShoulder:SetDesiredAngle(3.14)
	LeftShoulder:SetDesiredAngle(-3.14)
	RightHip:SetDesiredAngle(0)
	LeftHip:SetDesiredAngle(0)
end


-- same as jump for now

function moveFreeFall()
	RightShoulder.MaxVelocity = jumpMaxLimbVelocity
	LeftShoulder.MaxVelocity = jumpMaxLimbVelocity
	RightShoulder:SetDesiredAngle(3.14)
	LeftShoulder:SetDesiredAngle(-3.14)
	RightHip:SetDesiredAngle(0)
	LeftHip:SetDesiredAngle(0)
end

function moveSit()
	RightShoulder.MaxVelocity = 0.15
	LeftShoulder.MaxVelocity = 0.15
	RightShoulder:SetDesiredAngle(3.14 /2)
	LeftShoulder:SetDesiredAngle(-3.14 /2)
	RightHip:SetDesiredAngle(3.14 /2)
	LeftHip:SetDesiredAngle(-3.14 /2)
end

function getTool()	
	for _, kid in ipairs(Figure:GetChildren()) do
		if kid.className == "Tool" then return kid end
	end
	return nil
end

function getToolAnim(tool)
	for _, c in ipairs(tool:GetChildren()) do
		if c.Name == "toolanim" and c.className == "StringValue" then
			return c
		end
	end
	return nil
end

function animateTool()
	
	if (toolAnim == "None") then
		RightShoulder:SetDesiredAngle(1.57)
		return
	end

	if (toolAnim == "Slash") then
		RightShoulder.MaxVelocity = 0.5
		RightShoulder:SetDesiredAngle(0)
		return
	end

	if (toolAnim == "Lunge") then
		RightShoulder.MaxVelocity = 0.5
		LeftShoulder.MaxVelocity = 0.5
		RightHip.MaxVelocity = 0.5
		LeftHip.MaxVelocity = 0.5
		RightShoulder:SetDesiredAngle(1.57)
		LeftShoulder:SetDesiredAngle(1.0)
		RightHip:SetDesiredAngle(1.57)
		LeftHip:SetDesiredAngle(1.0)
		return
	end
end

function move(time)
	local amplitude
	local frequency
  
	if (pose == "Jumping") then
		moveJump()
		return
	end

	if (pose == "FreeFall") then
		moveFreeFall()
		return
	end
 
	if (pose == "Seated") then
		moveSit()
		return
	end

	local climbFudge = 0
	
	if (pose == "Running") then
    if (RightShoulder.CurrentAngle > 1.5 or RightShoulder.CurrentAngle < -1.5) then
			RightShoulder.MaxVelocity = jumpMaxLimbVelocity
		else			
			RightShoulder.MaxVelocity = 0.15
		end
		if (LeftShoulder.CurrentAngle > 1.5 or LeftShoulder.CurrentAngle < -1.5) then
			LeftShoulder.MaxVelocity = jumpMaxLimbVelocity
		else			
			LeftShoulder.MaxVelocity = 0.15
		end
		amplitude = 1
		frequency = 9
	elseif (pose == "Climbing") then
		RightShoulder.MaxVelocity = 0.5 
		LeftShoulder.MaxVelocity = 0.5
		amplitude = 1
		frequency = 9
		climbFudge = 3.14
	else
		amplitude = 0.1
		frequency = 1
	end

	desiredAngle = amplitude * math.sin(time*frequency)

	RightShoulder:SetDesiredAngle(desiredAngle + climbFudge)
	LeftShoulder:SetDesiredAngle(desiredAngle - climbFudge)
	RightHip:SetDesiredAngle(-desiredAngle)
	LeftHip:SetDesiredAngle(-desiredAngle)


	local tool = getTool()

	if tool then
	
		animStringValueObject = getToolAnim(tool)

		if animStringValueObject then
			toolAnim = animStringValueObject.Value
			-- message recieved, delete StringValue
			animStringValueObject.Parent = nil
			toolAnimTime = time + .3
		end

		if time > toolAnimTime then
			toolAnimTime = 0
			toolAnim = "None"
		end

		animateTool()

		
	else
		toolAnim = "None"
		toolAnimTime = 0
	end
end


-- connect events

Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)
Humanoid.Jumping:connect(onJumping)
Humanoid.Climbing:connect(onClimbing)
Humanoid.GettingUp:connect(onGettingUp)
Humanoid.FreeFalling:connect(onFreeFall)
Humanoid.FallingDown:connect(onFallingDown)
Humanoid.Seated:connect(onSeated)
Humanoid.PlatformStanding:connect(onPlatformStanding)
Humanoid.Swimming:connect(onSwimming)
-- main program

local runService = game:service("RunService");

while Figure.Parent~=nil do
	local _, time = wait(0.1)
	move(time)
end


end
}
local ScriptIndex = 0
local Scripts,ModuleScripts,ModuleCache = {},{},{}
local _require = require
function require(obj,...)
	local index = ModuleScripts[obj]
	if not index then
		local a,b = pcall(_require,obj,...)
		return not a and error(b,2) or b
	end
	
	local res = ModuleCache[index]
	if res then return res end
	res = ScriptFunctions[index](obj,require)
	if res==nil then error("Module code did not return exactly one value",2) end
	ModuleCache[index] = res
	return res
end
local function Script(obj,ismodule)
	ScriptIndex = ScriptIndex + 1
	local t = ismodule and ModuleScripts or Scripts
	t[obj] = ScriptIndex
end

function RunScripts()
	for script,index in pairs(Scripts) do
		coroutine.wrap(ScriptFunctions[index])(script,require)
	end
end


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


local Objects = Decode('AABYIQVNb2RlbCEETmFtZSEQTWlycm9yTWFuQXJtb3JlZCELUHJpbWFyeVBhcnQhCldvcmxkUGl2b3QEUlNUIQRQYXJ0IQRIZWFkIQpCcmlja0NvbG9yB+wDIQZDRnJhbWUEEFVWIQVDb2xvcgb/AAAhCFBvc2l0aW9uCiL9GMMbAJBA+oIPQyELUmVmbGVjdGFuY2UD'
..'AAAAQDMz0z8hBFNpemUKAAAAQAAAgD8AAIA/IQpUb3BTdXJmYWNlAwAAAAAAAAAAIQtTcGVjaWFsTWVzaCEFU2NhbGUKAACgPwAAoD8AAKA/IQVEZWNhbCELQXJtb3JlZEZhY2UhBkNvbG9yMwYAAAAhB1RleHR1cmUhFnJieGFzc2V0aWQ6Ly8xMzg0Mzc5NDQhBVRv'
..'cnNvBCRTVCELTGVmdFN1cmZhY2UDAAAAAAAAAEAKIP0YwxUAQED4gg9DIQxSaWdodFN1cmZhY2UKAAAAQAAAAEAAAIA/IQhMZWZ0IEFybQQrU1QhCkNhbkNvbGxpZGUCCiB9GsMVAEBA+IIPQwoAAIA/AAAAQAAAgD8hCVJpZ2h0IEFybQQvU1QKIH0XwxUAQED4gg9D'
..'IQhMZWZ0IExlZyENQm90dG9tU3VyZmFjZQQzU1QKIH0ZwyoAgD/4gg9DIQlSaWdodCBMZWcENlNUCiB9GMMqAIA/+IIPQyEISHVtYW5vaWQhE0Rpc3BsYXlEaXN0YW5jZVR5cGUhBkhlYWx0aAMAAAAAAADwfyEVSGVhbHRoRGlzcGxheURpc3RhbmNlIRFIZWFsdGhE'
..'aXNwbGF5VHlwZSEJTWF4SGVhbHRoIRNOYW1lRGlzcGxheURpc3RhbmNlIRBIdW1hbm9pZFJvb3RQYXJ0IQhBbmNob3JlZCIhDFRyYW5zcGFyZW5jeQMAAAAAAADwPyEQUmlzaW5nU3VuU2FtdXJhaQRGV1gKMP0Yw8EeoECwqA9DCvr//z8CAABAAQAAQAozM3M/AACA'
..'P6RwfT8hBk1lc2hJZCEoaHR0cDovL3d3dy5yb2Jsb3guY29tL2Fzc2V0Lz9pZD04NDM4NTQzMyEITWVzaFR5cGUDAAAAAAAAFEAhDldlbGRDb25zdHJhaW50IQVQYXJ0MCEFUGFydDEhC0xvY2FsU2NyaXB0IQdBbmltYXRlChBZncQ3FL3DPPduxAoAAIA/gAkAqAAA'
..'AAAKgAkAqAAAgD8AAAAACgAAgD/gALApAADAqwrgALApAACAP5QCcJUKAACAP7D/HykAAACrCrD/HykAAIA/EAJAlDUBAAIAAgMFBgcBCAACCAkKCwwNDg8QERITFBUWFwIBABgZGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwd'
..'Hh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwd'
..'Hh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwd'
..'Hh8aAgMAAhscHR4fGgIDAAIbHB0eHxoCAwACGxwdHh8aAgMAAhscHR4fBwEJAAIgCQoLIQ0OIiMPJBESJSMTJgcBCAACJwkKCygpKg0ODysREhMsBwEIAAItCQoLLikqDQ4PLxESEywHAQkAAjAxFgkKCzIpKg0ODzMREhMsBwEJAAI0MRYJCgs1KSoNDg82ERITLDcB'
..'BgA4Izk6OxY8Iz06PhYHAQkAAj9AQTEWCyEpKg8kEyYVFkJDBwEJAAJEMRYJCgtFDQ4PRhESE0cVFhcyAwAYSElKS0xNMgAAUAEBAAJRAwEEMTROMjRPAg==')
for _,obj in pairs(Objects) do
	obj.Parent = script
end
task.wait()
owner.Character = script:FindFirstChildWhichIsA("Model")
task.wait()
RunScripts()
