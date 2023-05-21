--[[

	SSSSSSSSSSSS	EEEEEEEEEEEEE	NNNN	 NN		TTTTTTTTTTTTTT	IIIIIIIIIIIIII		NNNN	 NN		EEEEEEEEEEEEE		LL
	SS				EE				NN NN	 NN		     TTT			  II			NN NN	 NN		EE					LL
	SS				EE				NN  NN	 NN		     TTT			  II			NN  NN	 NN		EE					LL
	SSSSSSSSSSSS	EEEEEEEEEEEEE	NN   NN	 NN		     TTT			  II			NN   NN	 NN		EEEEEEEEEEEEE		LL
			  SS	EE				NN   NN	 NN		     TTT			  II			NN   NN	 NN		EE					LL
			  SS	EE				NN    NN NN		     TTT			  II	    	NN    NN NN		EE					LL
	SSSSSSSSSSSS	EEEEEEEEEEEEE	NN     NNNN		     TTT		IIIIIIIIIIIIII		NN     NNNN		EEEEEEEEEEEEE		LLLLLLLLLLLLLL

	Advanced Roblox Anti - Exploit.
	Detect cheaters that want to ruin the fun for free.
	Made by Moonzy | @HiRobloxDown on Roblox.
	
	Your Anti-Cheat Version: 1.0.1b2 HTOFIX

]]

--// Anticheat - Main Configuration
local anticheatLagBack = true
local anticheatDebug = true

--// Anticheat - Checks
local fly_Check_A = true
local fly_Check_B = true
local fly_Check_C = true
local fly_Check_D = true
local fly_Check_E = true
local fly_Check_F = true
local speed_Check_A = true
local speed_Check_B = true
local speed_Check_C = true
local speed_Check_D = true
local jump_Check_A = true
local jump_Check_B = true
local jump_Check_C = true
local jump_Check_D = true
local jump_Check_E = true
local jump_Check_F = true
local jump_Check_G = true
local jump_Check_H = true
local jump_Check_I = true
local jump_Check_J = true
local jump_Check_K = true
local jump_Check_L = true
local jump_Check_M = true
local improbable_Check_A = true
local improbable_Check_B = true
local teleport_Check_A = true
local teleport_Check_B = true

--// Anticheat - Check Configuration
local fly_Check_A_Maximum_Air_Time = 2.15

local fly_Check_B_Maximum_Air_Time = 2.15

local fly_Check_C_Maximum_Air_Time = 2.15

local fly_Check_F_Maximum_Air_Time = 1.35
local fly_Check_F_Maximum_Air_Speed = 25

local fly_Check_E_Maximum_Air_Time = 0.85
local fly_Check_E_Maximum_Air_Speed = 15

local speed_Check_A_Maximum_Velocity = 36

local speed_Check_B_Maximum_Velocity = 17
local speed_Check_B_Minimum_Velocity = 15

local speed_Check_C_Maximum_Threshold = 10

local speed_Check_D_Maximum_Velocity = 43

local jump_Check_A_Maximum_Height = 60

local jump_Check_B_Maximum_Height = 51
local jump_Check_B_Minimum_Height = 49

local jump_Check_C_Maximum_Height = 8
local jump_Check_C_Minimum_Height = 7

local jump_Check_D_Maximum_Height = 50

local jump_Check_E_Maximum_Height = 75

local jump_Check_F_Maximum_Threshold = 3

local jump_Check_G_Maximum_Height = 8
local jump_Check_G_Minimum_Height = 7

local jump_Check_H_Maximum_Strafe = 145

local jump_Check_I_Maximum_Time = 0.2

local jump_Check_J_Maximum_Height = 8
local jump_Check_J_Minimum_Height = 7

local jump_Check_K_Maximum_Height = 8

local jump_Check_L_Maximum_Height = 65

local jump_Check_M_Maximum_Height = 60

local teleport_Check_A_Maximum_Distance_Velocity = 75

local teleport_Check_B_Maximum_Distance_Velocity = 80




--// MAIN ANTICHEAT, DONT TOUCH UNLESS YOU KNOW WHAT YOU ARE DOING, THE ANTICHEAT MAY BREAK.

local players = game:GetService('Players')
local function raycastOnFloor(root)
	if not root.Parent.Humanoid then else
		local humanoid = root.Parent.Humanoid
		local x = RaycastParams.new()
		x.FilterType = Enum.RaycastFilterType.Blacklist
		x.FilterDescendantsInstances = {root.Parent}

		local touchingPart = false
		local numRaycasts = 20
		local radius = 1.5
		local stepSize = math.pi * 2 / numRaycasts
		local origin = root.Position - Vector3.new(0, 0.1, 0)
		for i = 1, numRaycasts do
			local angle = i * stepSize
			local dir = Vector3.new(radius * math.cos(angle), 0, radius * math.sin(angle))
			local raycast = workspace:Raycast(origin + dir, Vector3.new(0, -3.5, 0), x)
			if raycast and raycast.Instance then
				touchingPart = true
				break
			end
		end

		return touchingPart
	end
end

local function notOnFloorAir(root)
	if not root.Parent.Humanoid then else
		local humanoid = root.Parent.Humanoid
		local material = humanoid.FloorMaterial
		local timeOnAir = 0

		if material == Enum.Material.Air then
			timeOnAir = timeOnAir + 0.015
		else
			timeOnAir = 0
		end

		return timeOnAir
	end
end

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait();
		local root = character:WaitForChild('HumanoidRootPart');
		local humanoid = character.Humanoid
		local lastPosition = root.Position
		local lastTime = tick()
		local lastTouchedFloor = tick()
		local lastTouchedFloorB = tick()
		local lastJumpTime = 0
		local jumpCount = 0
		local lastGroundPos = root.Position
		local tpamultiply = 0
		
		--// Fly Check A
		task.spawn(function()
			while player do
				task.wait()
				if raycastOnFloor(root) then
					lastTouchedFloor = tick()
				end

				local timeSinceFloor = tick() - lastTouchedFloor
				local verticalMovement = root.Velocity.Y
				local humanoidState = humanoid:GetState()

				if timeSinceFloor >= fly_Check_A_Maximum_Air_Time and humanoidState ~= Enum.HumanoidStateType.Landed then
					if humanoid then
						if humanoid.Health > 0 then
							if verticalMovement <= 0 then
								if verticalMovement >= -15 and verticalMovement <= 15 then
									if anticheatLagBack then
										root.Position = lastPosition
										task.wait(0.1)
									end
									if anticheatDebug then
										warn('SENTINEL CHEAT DETECTION: Failed Flight A | ' .. math.round(timeSinceFloor) + math.round(0.1,0.9))
									end
								end
							end
						end
					end
				end
			end
		end)
		
		--// Fly Check B
		task.spawn(function()
			local timeOnAir = 0

			while player do
				task.wait()

				local currentAirTime = notOnFloorAir(root)
				timeOnAir = timeOnAir + currentAirTime
				local verticalMovement = root.Velocity.Y

				if timeOnAir >= fly_Check_B_Maximum_Air_Time then
					if humanoid then 
						if humanoid.Health > 0 then
							if verticalMovement <= 0 then
								if verticalMovement >= -15 and verticalMovement <= 15 then
									if anticheatLagBack then
										root.Position = lastPosition
										task.wait(0.1);
									end
									if anticheatDebug then
										warn('SENTINEL CHEAT DETECTION: Failed Flight B | ' .. math.round(timeOnAir) + math.round(0.1,0.9))
									end
								end
							end
						end
					end
				end

				if currentAirTime == 0 then
					timeOnAir = 0
					lastTouchedFloorB = tick()
				end
			end
		end)
		
		--// Fly Check C
		task.spawn(function()
			while player do
				task.wait()
				if raycastOnFloor(root) then
					lastTouchedFloor = tick()
				end

				local timeSinceFloor = tick() - lastTouchedFloor
				local verticalMovement = root.Velocity.Y
				local humanoidState = humanoid:GetState()

				if timeSinceFloor >= fly_Check_C_Maximum_Air_Time and humanoidState ~= Enum.HumanoidStateType.Landed then
					if humanoid then
						if humanoid.Health > 0 then
							if verticalMovement >= 0 then
								if verticalMovement >= 2 and verticalMovement <= 25 then
									if anticheatLagBack then
										root.Position = lastPosition
										task.wait(0.1)
									end
									if anticheatDebug then
										warn('SENTINEL CHEAT DETECTION: Failed Flight C | ' .. math.round(timeSinceFloor) + math.round(0.1,0.9))
									end
								end
							end
						end
					end
				end
			end
		end)
		
		--// Fly Check D
		task.spawn(function()
			local timeOnAir = 0

			while player do
				task.wait()

				local currentAirTime = notOnFloorAir(root)
				timeOnAir = timeOnAir + currentAirTime
				local verticalMovement = root.Velocity.Y

				if timeOnAir >= fly_Check_A_Maximum_Air_Time then
					if humanoid then
						if humanoid.Health > 0 then
							if verticalMovement >= 0 then
								if verticalMovement >= 2 and verticalMovement <= 25 then
									if anticheatLagBack then
										root.Position = lastPosition
										task.wait(0.1);
									end
									if anticheatDebug then
										warn('SENTINEL CHEAT DETECTION: Failed Flight D | ' .. math.round(timeOnAir) + math.round(0.1,0.9))
									end
								end
							end
						end
					end
				end

				if currentAirTime == 0 then
					timeOnAir = 0
					lastTouchedFloorB = tick()
				end
			end
		end)
		
		--// Fly Check E
		task.spawn(function()
			while player do
				task.wait()
				if raycastOnFloor(root) then
					lastTouchedFloor = tick()
				end

				local timeSinceFloor = tick() - lastTouchedFloor
				local timeTaken = tick() - lastTime
				local verticalMovement = root.Velocity.Y
				local humanoidState = humanoid:GetState()
				local horizontalDistanceMoved = math.sqrt((root.Position.X - lastPosition.X) ^ 2 + (root.Position.Z - lastPosition.Z) ^ 2)
				local horizontalSpeed = horizontalDistanceMoved / timeTaken

				if timeSinceFloor >= fly_Check_E_Maximum_Air_Time then
					if verticalMovement <= 0 then
						if verticalMovement >= -20 and verticalMovement <= 45 and horizontalSpeed >= fly_Check_E_Maximum_Air_Speed then
							if anticheatLagBack then
								root.Position = lastPosition
								task.wait(0.1)
							end
							if anticheatDebug then
								warn('SENTINEL CHEAT DETECTION: Failed Flight E | ' .. math.round(timeSinceFloor) + math.round(0.1,0.9))
							end
						end
					end
				end
			end
		end)
		
		--// Fly Check F
		task.spawn(function()
			while player do
				task.wait()
				if raycastOnFloor(root) then
					lastTouchedFloor = tick()
				end

				local timeSinceFloor = tick() - lastTouchedFloor
				local timeTaken = tick() - lastTime
				local verticalMovement = root.Velocity.Y
				local humanoidState = humanoid:GetState()
				local horizontalDistanceMoved = math.sqrt((root.Position.X - lastPosition.X) ^ 2 + (root.Position.Z - lastPosition.Z) ^ 2)
				local horizontalSpeed = horizontalDistanceMoved / timeTaken

				if timeSinceFloor >= fly_Check_F_Maximum_Air_Time then
					if verticalMovement >= 0 then
						if verticalMovement >= 5 and verticalMovement <= 25 and horizontalSpeed >= fly_Check_F_Maximum_Air_Speed then
							if anticheatLagBack then
								root.Position = lastPosition
								task.wait(0.1)
							end
							if anticheatDebug then
								warn('SENTINEL CHEAT DETECTION: Failed Flight F | ' .. math.round(timeSinceFloor) + math.round(0.1,0.9))
							end
						end
					end
				end
			end
		end)
		
		--// Speed A
		task.spawn(function()
			local a = 0
			while player do
				task.wait(0.07)
				local timeTaken = tick() - lastTime
				local horizontalDistanceMoved = math.sqrt((root.Position.X - lastPosition.X) ^ 2 + (root.Position.Z - lastPosition.Z) ^ 2)
				local horizontalSpeed = horizontalDistanceMoved / timeTaken
				local material = humanoid.FloorMaterial
				
				if material ~= Enum.Material.Air then
					if horizontalSpeed >= speed_Check_A_Maximum_Velocity then
						if anticheatLagBack then
							if a == 1 then
								lastPosition = root.Position
							else
								root.Position = lastPosition
								a = 1
								task.wait(0.25)
								a = 0
							end
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Speed A | ' .. math.round(horizontalSpeed) + math.round(0.1,0.9))
						end
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Speed B
		task.spawn(function()
			while player do
				task.wait(0.11)
				local speedVelocity = humanoid.WalkSpeed
				local humanoidState = humanoid:GetState()

				if speedVelocity >= speed_Check_B_Maximum_Velocity or speedVelocity <= speed_Check_B_Minimum_Velocity then
					if anticheatLagBack then
						root.Position = lastPosition
						root.Position = lastPosition
						root.Position = lastPosition
					end
					if anticheatDebug then
						warn('SENTINEL CHEAT DETECTION: Failed Speed B | ' .. math.round(speedVelocity) + math.round(0.1,0.9))
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Speed C
		task.spawn(function()
			while player do
				task.wait(0.51)
				local verticalMovement = math.abs(root.Velocity.Y)
				local humanoidState = humanoid:GetState()

				if humanoidState == Enum.HumanoidStateType.Jumping then
					local jumpDistance = (lastGroundPos - root.Position).Magnitude
					if jumpDistance > speed_Check_C_Maximum_Threshold then
						if anticheatLagBack then
							root.Position = lastPosition
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Speed C | ' .. math.round(jumpDistance) + math.round(0.1,0.9))
						end	
					end
				elseif humanoidState == Enum.HumanoidStateType.Landed then
					lastGroundPos = root.Position
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Speed D
		task.spawn(function()
			while player do
				task.wait(0.055)
				local timeTaken = tick() - lastTime
				local horizontalDistanceMoved = math.sqrt((root.Position.X - lastPosition.X) ^ 2 + (root.Position.Z - lastPosition.Z) ^ 2)
				local horizontalSpeed = horizontalDistanceMoved / timeTaken
				local material = humanoid.FloorMaterial

				if horizontalSpeed >= speed_Check_D_Maximum_Velocity and material == Enum.Material.Air then
					if anticheatLagBack then
						root.Position = lastPosition
					end
					if anticheatDebug then
						warn('SENTINEL CHEAT DETECTION: Failed Speed D | ' .. math.round(horizontalSpeed) + math.round(0.1,0.9))
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement A
		task.spawn(function()
			while player do
				task.wait(0.25);
				local verticalMovement = math.abs(root.Velocity.Y)
				local upwardMovement = math.max(0, root.Velocity.Y)
				local humanoidState = humanoid:GetState()

				if verticalMovement >= jump_Check_A_Maximum_Height and upwardMovement >= jump_Check_A_Maximum_Height then
					if anticheatDebug then
						warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement A | ' .. math.round(verticalMovement) + math.round(0.1,0.9))
					end	
					if anticheatLagBack then
						for i = 1, 120 do
							root.Position = lastPosition
							task.wait();
						end
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement B
		task.spawn(function()
			while player do
				task.wait(0.25);
				local jumpVelocity = humanoid.JumpPower
				local humanoidState = humanoid:GetState()

				if jumpVelocity >= jump_Check_B_Maximum_Height or jumpVelocity <= jump_Check_B_Minimum_Height then
					if humanoidState == Enum.HumanoidStateType.Jumping then
						if anticheatLagBack then
							for i = 1, 120 do
								root.Position = lastPosition
							end
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement B | ' .. math.round(jumpVelocity) + math.round(0.1,0.9))
						end	
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement C
		task.spawn(function()
			while player do
				task.wait(0.25);
				local jumpVelocity = humanoid.JumpHeight
				local humanoidState = humanoid:GetState()

				if jumpVelocity >= jump_Check_C_Maximum_Height or jumpVelocity <= jump_Check_C_Minimum_Height then
					if humanoidState == Enum.HumanoidStateType.Jumping then
						if anticheatLagBack then
							for i = 1, 120 do
								root.Position = lastPosition
							end
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement C | ' .. math.round(jumpVelocity) + math.round(0.1,0.9))
						end	
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement D
		task.spawn(function()
			while player do
				task.wait(0.25);

				local jumpVelocity = humanoid.JumpHeight
				local humanoidState = humanoid:GetState()
				local velocity = root.Velocity
				if humanoidState == Enum.HumanoidStateType.Jumping and jumpVelocity > jump_Check_D_Maximum_Height then
					if anticheatLagBack then
						for i = 1, 120 do
							root.Position = lastPosition
						end
					end
					if anticheatDebug then
						warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement D | ' .. math.round(jumpVelocity) + math.round(0.1,0.9))
					end	
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement E
		task.spawn(function()
			while player do
				task.wait(0.25);

				local jumpVelocity = humanoid.JumpHeight
				local humanoidState = humanoid:GetState()
				local velocity = root.Velocity

				if velocity.Y > jump_Check_E_Maximum_Height and humanoidState ~= Enum.HumanoidStateType.Jumping then
					if anticheatDebug then
						warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement E | ' .. velocity.Y + math.round(0.1,0.9))
					end	
					if anticheatLagBack then
						for i = 1, 120 do
							root.Position = lastPosition
							task.wait();
						end
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement F
		task.spawn(function()
			while player do
				task.wait(0.25);
				local jumpVelocity = humanoid.JumpHeight
				local humanoidState = humanoid:GetState()

				if humanoidState == Enum.HumanoidStateType.Jumping then
					local currentTime = tick()
					local timeSinceLastJump = currentTime - lastJumpTime
					if timeSinceLastJump < 0.2 then
						jumpCount = jumpCount + 1
						if jumpCount >= jump_Check_F_Maximum_Threshold then
							if anticheatLagBack then
								for i = 1, 120 do
									root.Position = lastPosition
								end
							end
							if anticheatDebug then
								warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement F | ' .. math.round(jumpCount) + math.round(0.1,0.9))
							end	
							jumpCount = 0
						end
					else
						jumpCount = 0
					end
					lastJumpTime = currentTime
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement G
		task.spawn(function()
			while player do
				task.wait(0.25);
				local jumpVelocity = humanoid.JumpHeight
				local humanoidState = humanoid:GetState()

				if jumpVelocity >= jump_Check_G_Maximum_Height or jumpVelocity <= jump_Check_G_Minimum_Height then
					if humanoidState == Enum.HumanoidStateType.Jumping then
						if anticheatLagBack then
							for i = 1, 120 do
								root.Position = lastPosition
							end
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement G | ' .. math.round(jumpVelocity) + math.round(0.1,0.9))
						end	
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement H
		task.spawn(function()
			local lastVelocity = Vector3.new(0,0,0)
			while player do
				task.wait(0.25);
				local currentVelocity = root.Velocity
				local currentFloorMaterial = humanoid.FloorMaterial
				local currentHumanoidState = humanoid:GetState()

				if currentFloorMaterial == Enum.Material.Air and currentHumanoidState == Enum.HumanoidStateType.Jumping or currentHumanoidState == Enum.HumanoidStateType.Freefall then
					local velocityChange = currentVelocity - lastVelocity
					if velocityChange.Magnitude > jump_Check_H_Maximum_Strafe then
						if currentHumanoidState == Enum.HumanoidStateType.Seated or currentHumanoidState == Enum.HumanoidStateType.Ragdoll then return end
						if anticheatLagBack then
							for i = 1, 120 do
								root.Position = lastPosition
							end
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement H | ' .. math.round(velocityChange.Magnitude) + math.round(0.1,0.9))
						end	
					end
				end
				lastVelocity = currentVelocity
			end
		end)
		
		--// Jump Movement I
		task.spawn(function()
			local lastJumpTick = 0

			while player do
				task.wait(0.25);
				local jumpVelocity = humanoid.JumpHeight
				local humanoidState = humanoid:GetState()
				local currentTick = tick()

				if humanoidState == Enum.HumanoidStateType.Jumping then
					local jumpDelay = currentTick - lastJumpTick
					if jumpDelay < jump_Check_I_Maximum_Time then
						if anticheatLagBack then
							for i = 1, 120 do
								root.Position = lastPosition
							end
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement G | ' .. math.round(jumpDelay) + math.round(0.1,0.9))
						end	
					end
					lastJumpTick = currentTick
				end

				lastPosition = root.Position
				lastTime = currentTick
			end
		end)
		
		--// Jump Movement J
		task.spawn(function()
			local lastJumpTick = 0

			while player do
				task.wait(0.5)
				local jumpVelocity = humanoid.JumpHeight
				local humanoidState = humanoid:GetState()
				local currentTick = tick()

				if jumpVelocity >= jump_Check_J_Maximum_Height or jumpVelocity <= jump_Check_J_Minimum_Height then
					if humanoidState == Enum.HumanoidStateType.Jumping then
						if anticheatLagBack then
							for i = 1, 120 do
								root.Position = lastPosition
							end
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement J | ' .. math.round(jumpVelocity) + math.round(0.1,0.9))
						end	
					end
				end

				lastPosition = root.Position
				lastTime = currentTick
			end
		end)
		
		--// Jump Movement K
		task.spawn(function()
			while player do
				task.wait(0.25);
				local jumpVelocity = humanoid.JumpHeight

				if jumpVelocity > jump_Check_K_Maximum_Height then
					if humanoid.WalkSpeed < 1 then
						if anticheatLagBack then
							for i = 1, 120 do
								root.Position = lastPosition
							end
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement K | ' .. math.round(jumpVelocity) + math.round(0.1,0.9))
						end	
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement L
		task.spawn(function()
			while player do
				task.wait(0.25);

				local verticalMovement = math.abs(root.Velocity.Y)
				local humanoidState = humanoid:GetState()

				if verticalMovement >= jump_Check_L_Maximum_Height and root.Velocity.Y >= 0 then
					if anticheatDebug then
						warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement L | ' .. math.round(verticalMovement) + math.round(0.1,0.9))
					end	
					if anticheatLagBack then
						for i = 1, 120 do
							root.Position = lastPosition
							task.wait();
						end
					end
				elseif humanoidState == Enum.HumanoidStateType.Landed then
					lastGroundPos = root.Position
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Jump Movement M
		task.spawn(function()
			while player do
				task.wait(0.25);
				local timeTaken = tick() - lastTime
				local horizontalDistanceMoved = math.sqrt((root.Position.X - lastPosition.X) ^ 2 + (root.Position.Z - lastPosition.Z) ^ 2)
				local horizontalSpeed = horizontalDistanceMoved / timeTaken
				local humanoidState = humanoid:GetState()

				if horizontalSpeed >= jump_Check_M_Maximum_Height then
					if humanoidState == Enum.HumanoidStateType.Jumping or humanoidState == Enum.HumanoidStateType.Freefall then
						if anticheatLagBack then
							for i = 1, 120 do
								root.Position = lastPosition
							end
						end
						if anticheatDebug then
							warn('SENTINEL CHEAT DETECTION: Failed Vertical Movement M | ' .. math.round(horizontalSpeed) + math.round(0.1,0.9))
						end	
					end
				end

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Improbable A
		task.spawn(function()
			while player do
				task.wait(0.05);
				if humanoid.Health > 100 or humanoid.Health < 0 then
					if anticheatLagBack then
						player:Kick('UNK :: 1038 - Pong Response && 23 - 1093');
					end
				end
			end
		end)
		
		--// Improbable B
		task.spawn(function()
			while player do
				task.wait(0.05);
				if humanoid.MaxHealth > 100 or humanoid.MaxHealth < 0 then
					if anticheatLagBack then
						player:Kick('UNK :: 1039 - Pong Response && 32 - 1291');
					end
				end
			end
		end)
		
		--// Teleport Check A
		task.spawn(function()
			local a = 0
			while player do
				task.wait(0.25)
				tpamultiply = tpamultiply + 1
				local timeTaken = tick() - lastTime
				local horizontalDistanceMoved = math.sqrt((root.Position.X - lastPosition.X) ^ 2 + (root.Position.Z - lastPosition.Z) ^ 2)
				local horizontalSpeed = horizontalDistanceMoved / timeTaken
				
				if horizontalSpeed >= teleport_Check_A_Maximum_Distance_Velocity then
					if anticheatLagBack then
						if a == 1 then return end
						root.Position = lastPosition
						a = 1
						task.wait(0.15)
						a = 0
					end
					if anticheatDebug then
						warn('SENTINEL CHEAT DETECTION: Failed Teleport A | ' .. math.round(horizontalSpeed) + math.round(0.1,0.9))
					end
				end
				task.wait()

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
		
		--// Teleport Check B
		task.spawn(function()
			while player do
				task.wait(0.25)
				tpamultiply = tpamultiply + 1
				local timeTaken = tick() - lastTime
				local horizontalDistanceMoved = math.sqrt((root.Position.X - lastPosition.X) ^ 2 + (root.Position.Z - lastPosition.Z) ^ 2)
				local horizontalSpeed = horizontalDistanceMoved / timeTaken
				local verticalMovement = root.Velocity.Y

				if root.Position ~= lastPosition then
					if root.Velocity.Magnitude > teleport_Check_B_Maximum_Distance_Velocity then
						if verticalMovement <= 0 then
							if verticalMovement >= -15 and verticalMovement <= 15 then
								if anticheatLagBack then
									root.Position = lastPosition
								end
								if anticheatDebug then
									warn('SENTINEL CHEAT DETECTION: Failed Teleport B | ' .. math.round(horizontalSpeed) + math.round(0.1,0.9))
								end
							end
						end
					end
				end
				task.wait()

				lastPosition = root.Position
				lastTime = tick()
			end
		end)
	end)
end)
