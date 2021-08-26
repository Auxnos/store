-- Converted using Mokiros's Model to Script Version 3
-- Converted string size: 2596 characters

local ScriptFunctions = {
function(script,require)

local head = script.Parent
local sound = head:findFirstChild("Sound")


function onTouched(part)
	local h = part.Parent:findFirstChild("Humanoid")
	if h~=nil then
sound:play()

	end
end

script.Parent.Touched:connect(onTouched)

end,
function(script,require)
			local soundIds = {150185006,150184965,150185025}
local sounds = {}
for i=1,#soundIds do
	local s = Instance.new("Sound")
	s.SoundId = "http://www.roblox.com/asset/?id=" .. soundIds[i]
	s.Volume = 1
	s.Parent = script.Parent
	sounds[#sounds + 1] = s
end
fpor = game.Workspace.FindPartOnRay
seen_dist = 200
function canSee(subject,viewer)
	if (not subject) or (not viewer) then return false end
	local sh = subject:findFirstChild("Death")
	local vh = viewer:findFirstChild("Head")
	if (not sh) or (not vh) then return false end
	local vec = sh.Position - vh.Position
	local isInFOV = (vec:Dot(vh.CFrame.lookVector) > 0)
	if (isInFOV) and (vec.magnitude < seen_dist) then
		local ray = Ray.new(vh.Position,vec.unit*200)
		local por = fpor(workspace,ray,viewer,false)
		return (por == nil) or (por:IsDescendantOf(subject))
	end
	return false
end
function canSee2(subject,viewer)
	if (not subject) or (not viewer) then return false end
	local sh = subject:findFirstChild("Death")
	local vh = viewer:findFirstChild("Head")
	if (not sh) or (not vh) then return false end
	local vec = sh.Position - vh.Position
	if (vec.magnitude < seen_dist) then
		local ray = Ray.new(vh.Position,vec.unit*200)
		local por = fpor(workspace,ray,viewer,false)
		return (por == nil) or (por:IsDescendantOf(subject))
	end
	return false
end

function stick(x, y)
	weld = Instance.new("Weld") 
	weld.Part0 = x
	weld.Part1 = y
	local HitPos = x.Position
	local CJ = CFrame.new(HitPos) 
	local C0 = x.CFrame:inverse() *CJ 
	local C1 = y.CFrame:inverse() * CJ 
	weld.C0 = C0 
	weld.C1 = C1 
	weld.Parent = x
	x.Anchored = false
	y.Anchored = false
	
end
stick(script.Parent, script.Parent.Parent.Phys)
function stick2(x, y)
	weld = Instance.new("Weld") 
	weld.Part0 = x
	weld.Part1 = y
	local HitPos = x.Position
	local CJ = CFrame.new(HitPos) 
	local C0 = x.CFrame:inverse() *CJ 
	local C1 = y.CFrame:inverse() * CJ 
	weld.C0 = C0 
	weld.C1 = C1 
	weld.Parent = x
	x.Anchored = false
	y.Anchored = false
end
stick(script.Parent, script.Parent.Parent.Phys4)
function stick2(x, y)
	weld = Instance.new("Weld") 
	weld.Part0 = x
	weld.Part1 = y
	local HitPos = x.Position
	local CJ = CFrame.new(HitPos) 
	local C0 = x.CFrame:inverse() *CJ 
	local C1 = y.CFrame:inverse() * CJ 
	weld.C0 = C0 
	weld.C1 = C1 
	weld.Parent = x
	x.Anchored = false
	y.Anchored = false
end
stick(script.Parent, script.Parent.Parent.Phys5)
stick(script.Parent, script.Parent.Face)
function stick2(x, y)
	weld = Instance.new("Weld") 
	weld.Part0 = x
	weld.Part1 = y
	local HitPos = x.Position
	local CJ = CFrame.new(HitPos) 
	local C0 = x.CFrame:inverse() *CJ 
	local C1 = y.CFrame:inverse() * CJ 
	weld.C0 = C0 
	weld.C1 = C1 
	weld.Parent = x
	x.Anchored = false
	y.Anchored = false
end

stick(script.Parent, script.Parent.Parent.Phys3)
function stick2(x, y)
	weld = Instance.new("Weld") 
	weld.Part0 = x
	weld.Part1 = y
	local HitPos = x.Position
	local CJ = CFrame.new(HitPos) 
	local C0 = x.CFrame:inverse() *CJ 
	local C1 = y.CFrame:inverse() * CJ 
	weld.C0 = C0 
	weld.C1 = C1 
	weld.Parent = x
	x.Anchored = false
	y.Anchored = false
end
stick2(script.Parent, script.Parent.Parent.Phys2)
while true do
	local minmag = nil
	local minply = nil
	local mindir = nil
	local beingwatched = false
	players = game:GetService("Players"):GetChildren()
	for i=1,#players do
		char = players[i].Character
		if char then
			local foundhead = char:FindFirstChild("Head")
			local foundHumanoidRootPart = char:FindFirstChild("HumanoidRootPart")
			local foundhum = char:FindFirstChild("Humanoid")
			if foundhead and foundHumanoidRootPart and foundhum and foundhum.Health > 0 then
				local sub = (script.Parent.CFrame.p - foundhead.CFrame.p)
				local dir = sub.unit
				local mag = sub.magnitude
				if not minmag or minmag > mag then
					minmag = mag
					minply = char:FindFirstChild("HumanoidRootPart")
					mindir = dir
					if canSee(script.Parent.Parent, char) then beingwatched = true end
				end
			end
		end
	end

	if minply and not beingwatched and canSee2(script.Parent.Parent, minply.Parent) then
		if minmag and minmag <= 200 then
			local unit = (script.Parent.Position-minply.Position).unit
			unit = Vector3.new(unit.X,0,unit.Z)
			script.Parent.CFrame = CFrame.new(script.Parent.Position + (unit*-15), Vector3.new(minply.Position.X, script.Parent.Position.Y, minply.Position.Z))
			script.Parent.CFrame = script.Parent.CFrame * CFrame.Angles(0,math.rad(180),0)
			script.Parent.Slide:Play()
			wait(0.000001)
			if minmag < 10 and minply.Parent:FindFirstChild("Humanoid") and minply.Parent.Humanoid.Health > 0 and not beingwatched then
				script.Parent.CFrame = CFrame.new(script.Parent.Position, Vector3.new(minply.Position.X, script.Parent.Position.Y, minply.Position.Z))
				minply.Parent:BreakJoints()
				script.Parent.Kill:Play()
			end
		end
	end
	wait(.000001)
	script.Parent.Slide:Pause()
	wait(.000001)
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


local function DecodeUnion(Values,Flags,Parse,data)
	local m = Instance.new("Folder")
	m.Name = "UnionCache ["..tostring(math.random(1,9999)).."]"
	m.Archivable = false
	m.Parent = game:GetService("ServerStorage")
	local Union,Subtract = {},{}
	if not data then
		data = Parse('B')
	end
	local ByteLength = (data % 4) + 1
	local Length = Parse('I'..ByteLength)
	local ValueFMT = ('I'..Flags[1])
	for i = 1,Length do
		local data = Parse('B')
		local part
		local isNegate = bit32.band(data,0b10000000) > 0
		local isUnion =  bit32.band(data,0b01000000) > 0
		if isUnion then
			part = DecodeUnion(Values,Flags,Parse,data)
		else
			local isMesh = data % 2 == 1
			local ClassName = Values[Parse(ValueFMT)]
			part = Instance.new(ClassName)
			part.Size = Values[Parse(ValueFMT)]
			part.Position = Values[Parse(ValueFMT)]
			part.Orientation = Values[Parse(ValueFMT)]
			if isMesh then
				local mesh = Instance.new("SpecialMesh")
				mesh.MeshType = Values[Parse(ValueFMT)]
				mesh.Scale = Values[Parse(ValueFMT)]
				mesh.Offset = Values[Parse(ValueFMT)]
				mesh.Parent = part
			end
		end
		part.Parent = m
		table.insert(isNegate and Subtract or Union,part)
	end
	local first = table.remove(Union,1)
	if #Union>0 then
		first = first:UnionAsync(Union)
	end
	if #Subtract>0 then
		first = first:SubtractAsync(Subtract)
	end
	m:Destroy()
	return first
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


local Objects = Decode('AACLIQVNb2RlbCEETmFtZSEHU0NQLTE3MyEKV29ybGRQaXZvdAR9fn8hDlVuaW9uT3BlcmF0aW9uIQRQaHlzIQhBbmNob3JlZCIhCkJyaWNrQ29sb3IHwAAhBkNGcmFtZQQVgIEhBUNvbG9yBmlAKCEITWF0ZXJpYWwDAAAAAACAiUAhC09yaWVudGF0aW9uCgAAAAAA'
..'ALRCXI/6wCEIUG9zaXRpb24KmLf+QaTVZEFfuDpAIQhSb3RhdGlvbgpcj/rAAAC0QgAAAAAhBFNpemUKOSrvP1+OvUD/KaA/IQxUcmFuc3BhcmVuY3kDAAAAAAAA8D8hBFBhcnQKK8ZOP4TLBUCto1M/CrLA/kEkV19BsgFgQAMAAAAAAAAIQAoAAIA/AACAPwAAgD8K'
..'AAAAAAAAAAAAAAAACnRvrkBtzOc+kgPIQAp9e/1BukMxQYhoMUAKAAAAAAAAtEIAAAAAAwAAAAAAABhACuGynj8tL0tA+N2EPwqCxf5BKvZ6QUx5NkAK9uehP4c3YECxko4/CrC1/kEfOWlBD3xDQAoAAAAAAAC0QpqZmcEKzy49QNXNIj/J8vc+Cl/JAELLHERBizI/'
..'QAoUro/AUjiwQlK4iMIKZtI6QNXNIj/J8vc+CubQ+0EUMERB0o8/QAoAAJhASOGxQjMzicIhBVBoeXMyBxUABDaCgwbEKBwKAAAAAAAAtEJ7FDZBChzA/kE7xo9BAW41QAp7FDZBAAC0QgAAAAAKqu31P0RHDkAVPqw/Cu4ipT/i/28/FT6sPwoZwP5BWKmQQR4VMEAK'
..'CIHXPzzIEUAkq6o/CsKy/kE5qY9Bgdc6QAoAAAAAAAC0QqRw30EKHRjLP/noCkAkq6o/CvHF/kGqHJBBRSQrQAoAAAAAAAC0QuF6lD8hBVBoeXMzBwYEBEaEhQb/zJkKexQiQY9CgULNzKJBCnz2AUI7+YFBYYsEQAq4HrVBcT17QgAAAAAKDGryP9kpij+vScw+Ctts'
..'sD89i/Q+XfObPgqOYAJCi4eAQZVi4j8K7yEBQsjRgEGZJxxACnsUIkGPQoFCXI/WwQp/wQE/PYv0Pq1JzD4KBTsDQs+mgUEjZLE/IQVQaHlzNARShocKexQiwY/C5kLNzKJBCjbx+UFN54FBoIwEQAopXB3DMzN7QgAANMMKvw/5Qf1ygEEyyuI/CiGN+0E8vYBBvVoc'
..'QAp7FCLBj8LmQlyP1sEK/Gf3Qd2UgUEZaLE/IQVQaHlzNSENQm90dG9tU3VyZmFjZQMAAAAAAAAAAARcfn8KVq/8QTgtYEGfcjpACgsNcED14rFA0/dPQCEKVG9wU3VyZmFjZSELU3BlY2lhbE1lc2ghCE1lc2hUeXBlIQhNZXNoUGFydCEFRGVhdGgEZIiJClZq/UGN'
..'xnBBoOI5QCELUmVmbGVjdGFuY2UKrBz6P0oM/kA3iRlAAwAAAADgeoS/IQZNZXNoSWQhF3JieGFzc2V0aWQ6Ly8xMDAyNzMyMjc3IQhNZXNoU2l6ZQo6Aa9ACD2xQfCn1kAhCVRleHR1cmVJRCEXcmJ4YXNzZXRpZDovLzEwMDI3MDAwNDMhBVNvdW5kIQVTbGlkZSEG'
..'TG9vcGVkIQdTb3VuZElkISlodHRwOi8vd3d3LnJvYmxveC5jb20vYXNzZXQvP2lkPTE0OTI5MzY1NiEERmFjZQR1iosK5+39Qc7WjEFf0xtACnsUzj+PwrU/0MxMPiEES2lsbCEpaHR0cDovL3d3dy5yb2Jsb3guY29tL2Fzc2V0Lz9pZD0xNDkyOTM2NDUhBlZvbHVt'
..'ZSEWcmJ4YXNzZXRpZDovLzE1MDE4NDk2NSEGU2NyaXB0IQZDbG9zZXIKVa/8QeqjckGASzlACjTYhLgKLQC0AACAvwpTY9owAACAP14VALQKapODuK+EC77dnH2/Coi7ELfdnH0/r4QLvgrNE4K4WxFKPlr3er8KDmhRN1r3ej9bEUo+Cgb96T7dTq8+tCdSvwrnC+A3'
..'SEVsP9QZxT4KRQnqvqBNrz7KI1K/Ck7cgDcwRWw/ThjFPgoAAIA/iOepszMQg7gKe7mwMwAAgD/z6g+zCgAAgD8lXdkwMxCDuAp0adswAACAPx4hqa4OAQACAAIDBAUGQAIBHB0eEx8gIUACgRwiIyQlICFABAEcJickHyAhARwoKSofICEBHCssLR8gIQEcLi8wHyAh'
..'AQsAAgcICQoLDA0ODxAREhMUFRYXGBkaGwZAAgEcOTo1HyAhQAIBHDs8PR8gIQEcPj9AHyAhAQsAAjEICQoyDDMONBAREjUUNhY3GDgaGwZAAwEcSUpFHyAhARxJS0wfICEBHE1ORR8gIQELAAJBCAkKQgxDDkQQERJFFEYWRxhIGhsGQAMBHElUUR8gIQEcSVVWHyAh'
..'ARxNV1EfICEBCwACTwgJCkIMUA5EEBESURRSFlMYSBobHAENAAJYCAlZWgoLDFsODxAREiQUXBYkGF1eWhobXwYBAGAlYQEJAAJiDGMUZGUbGGYaZ2hpamtsbW4IAwACb3AJcXIcCAYAAnMICQx0FHUYdhobbggDAAJ3cXh5G24IAgBxenkbewgBAAJ8ewgAAAA=')
for _,obj in pairs(Objects) do
	obj.Parent = script or workspace
end

RunScripts()
