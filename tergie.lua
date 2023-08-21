local function RunBot()
    print("Started execution attempt of Crown Bot.")
    if not workspace:WaitForChild("Map"):FindFirstChild("CrownBotCheckPermV") then
        print("Can execute, currently executing...")
        local MakeCheckPerm = Instance.new("BoolValue")
        MakeCheckPerm.Parent = workspace:WaitForChild("Map")
        MakeCheckPerm.Name = "CrownBotCheckPermV"
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local localP = Players.LocalPlayer
        repeat task.wait(.1) until localP and localP.Character and localP.Character:IsDescendantOf(workspace)
        task.wait(2)
        local raisedTemp = 0
        local JoinTime = tick()
        coroutine.wrap(function()
            local MinimumPlayersInGame = 7
            local MinsLast = 8
            while true do
                task.wait(MinsLast * 60)
                if raisedTemp == 0 or #Players:GetPlayers() < MinimumPlayersInGame or (tick() - JoinTime) >= (MinsLast * 60) then
                    -- Server Hop
                    print("Server Hopping!")
                    raisedTemp = 0
                    game:GetService("RunService"):Stop() -- Roblox crash bypass
                    if identifyexecutor() == "Fluxus" then
                        --[[Needed for fluxus atm]]queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/crownaintanoob/CFA-Hub-UI-lib/main/tergie.lua"))()')
                    end
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/crownaintanoob/CFA-Hub-UI-lib/main/serverhp.lua"))()
                else
                    raisedTemp = 0
                end
            end
        end)()
        local PlayersBeginningPos = {}
        
        local function BeginPlayerPos(plr)
            coroutine.wrap(function()
                plr.CharacterAdded:Connect(function(char)
                    repeat task.wait() until char
                    task.wait(3)
                    PlayersBeginningPos[plr.UserId] = char:WaitForChild("HumanoidRootPart").Position
                end)
                if Players:FindFirstChild(plr.Name) and plr.Character and plr.Character:IsDescendantOf(workspace) then
                    PlayersBeginningPos[plr.UserId] = plr.Character:WaitForChild("HumanoidRootPart").Position
                end
            end)()
        end

        local function SpeedUpPlayer(char)
            char:WaitForChild("Humanoid").WalkSpeed = 20
        end

        if localP.Character and localP.Character:IsDescendantOf(workspace) then
            SpeedUpPlayer(localP.Character)
        end

        localP.CharacterAdded:Connect(function(char)
            repeat task.wait() until char
            SpeedUpPlayer(char)
        end)

        local function SendMessageInChat(message : string)
            ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(--[[Message]]message, --[[Recipient(s)]]"All")
        end

        local donationsThanksList = {
            "Thank you so much for the donation!",
            "Thanks for the dono",
            "Thank u for the dono bro",
            "Thanks for the donation",
        }

        local oldDonation = localP:WaitForChild("leaderstats"):WaitForChild("Raised").Value
        localP:WaitForChild("leaderstats"):WaitForChild("Raised").Changed:Connect(function(newValue)
            local HowMuchDonatedAtOnce = newValue - oldDonation
            oldDonation = newValue
            task.wait(4)
            SendMessageInChat("Thanks for the donation!")
            raisedTemp = raisedTemp + HowMuchDonatedAtOnce
        end)
        -- Anti AFK
        local VirtualUser = game:GetService("VirtualUser")
        localP.Idled:Connect(
            function()
                VirtualUser:CaptureController()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end
        )

        -- Bypass Remotes
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remotes = replicatedStorage.Remotes
        local remotesModule = require(remotes)
        local remotesTable = {
            "Ban",
            "Unban",
            "Kick",
            "JoinUserServer",
            "DonatedChanged",
            "PreloadItems",
            "InvokeLoginRewards",
            "VR",
            "SetDonatedVisibility",
            "SetSettings",
            "GiftReceived",
            "RedeemCode",
            "ChangeMusic",
            "EditBoothModel",
            "NewPurchasedBooths",
            "UnclaimBooth",
            "LoginRewards",
            "GiftSentAlert",
            "PurchaseBoothStarted",
            "InsufficientGiftbux",
            "AlreadyOwned",
            "ChatDonationAlert",
            "PlayDonationSound",
            "GlobalDonationsDown",
            "AdminCommandResponse",
            "NotifyDonationParticipants",
            "NewGiftbuxBalance",
            "AmIAdmin",
            "GetAdminLogs",
            "CheckIfBanned",
            "CheckUserInGame",
            "GetDonated",
            "ClaimBooth",
            "GetWorldCupVote",
            "GiveMeLaunchDataPweez",
            "GetSettings",
            "UnclaimedDonations",
            "UnclaimedDonationCount",
            "RefreshItems",
            "GetOurTopDonated",
            "CheckFiltered",
            "UserInfo",
            "CurrentBooth",
            "PurchasedBooths",
            "ExclusiveBooths",
            "GiftbuxBalance",
            "OfflinePlayerLookup",
            "SetBoothText",
            "EditWheel",
            "FetchCreateLink",
            "CancelPromptPurchase"
        }
        local hashlib = require(replicatedStorage.Packages._Index["boatbomber_hashlib@1.0.0"].hashlib)

        local function hash(str)
            return hashlib.bin_to_base64(hashlib.hex_to_bin(hashlib.sha1(str .. game.JobId)))
        end

        -- Detouring so the remotes dont break
        remotesModule.Event = function(remote)
            return remotes:FindFirstChild(remote)
        end

        remotesModule.Function = function(remote)
            return remotes:FindFirstChild(remote)
        end

        for _, remote in next, remotesTable do
            local hashedName = hash(remote)
            local hashedRemote = remotes:FindFirstChild(hashedName)

            if hashedRemote then
                hashedRemote.Name = remote
            end
        end

        -- Functions Auto Farm
        local function GetBooth()
            local NoOwnerBooths = {}
            for _, boothInteractionPart in pairs(workspace:WaitForChild("BoothInteractions"):GetChildren()) do
                if boothInteractionPart.Name == "BoothInteraction" then
                    local OwnerBooth = boothInteractionPart:GetAttribute("BoothOwner")
                    if OwnerBooth == localP.UserId then
                        return {
                            ["BoothSlot"] = boothInteractionPart:GetAttribute("BoothSlot"),
                            ["BoothPart"] = boothInteractionPart,
                            ["HasBooth"] = true
                        }
                    else
                        if OwnerBooth == nil then
                            table.insert(
                                NoOwnerBooths,
                                {
                                    ["BoothSlot"] = boothInteractionPart:GetAttribute("BoothSlot"),
                                    ["BoothPart"] = boothInteractionPart
                                }
                            )
                        end
                    end
                end
            end

            -- No booth owned by localplayer
            if #NoOwnerBooths >= 1 then
                local EmptyBoothFoundRandom = NoOwnerBooths[math.random(1, #NoOwnerBooths)]
                EmptyBoothFoundRandom["HasBooth"] = false
                return EmptyBoothFoundRandom
            end
        end

        local ChattedPlrsFuncList = {}

        local function chattedFunc(plr, msg)
            if ChattedPlrsFuncList[plr.UserId] == nil then
                ChattedPlrsFuncList[plr.UserId] = {}
            end
            for indexGot, vObject in pairs(ChattedPlrsFuncList[plr.UserId]) do
                -- Delete message from table if the message is 4 or more seconds old
                if (tick() - vObject["TimeSent"]) >= 4 then
                    table.remove(ChattedPlrsFuncList[plr.UserId], indexGot)
                end
            end
            table.insert(ChattedPlrsFuncList[plr.UserId], {
                ["Msg"] = msg,
                ["TimeSent"] = tick(),
            })
        end

        for _, plrGotTemp in pairs(Players:GetPlayers()) do
            BeginPlayerPos(plrGotTemp)
            plrGotTemp.Chatted:Connect(function(msg)
                chattedFunc(plrGotTemp, msg)
            end)
        end

        Players.PlayerAdded:Connect(function(plrGot)
            BeginPlayerPos(plrGot)
            plrGot.Chatted:Connect(function(msg)
                chattedFunc(plrGot, msg)
            end)
        end)

        -- Must be lowercase
        local WhitelistedAgreeMessages = {
            "ok",
            "alright",
            "fine",
            "all right",
            "go",
            "stand",
            "ye", -- this will also work for other words, such as "yep", "yes"
            "sure",
            "ofcourse",
            "of course",
            "for sure",
        }

        -- Must be lowercase
        local ListDeclineMessages = {
            "sorry",
            "srry",
            "no",
            "nah",
        }

        local BegMessagesList = {
            ["FollowMePleaseMessages"] = {
                "follow me please",
                "can you please follow me",
                "come to my stand",
                "cmon follow me",
                "please follow me",
            },
            ["FollowMeToMyStand"] = {
                "follow me to my stand",
                "follow me, I'll show you my stand",
                "I'll show you my stand, follow me",
                "I'll show you my stand, come",
            }
        }

        local function IfSittingJumpThen()
            if localP.Character and localP.Character:IsDescendantOf(workspace) then
                if localP.Character:WaitForChild("Humanoid").Sit == true then
                    localP.Character:WaitForChild("Humanoid"):ChangeState(
                        Enum.HumanoidStateType.Jumping
                    )
                end
            end
        end

        local PathfindingService = game:GetService("PathfindingService")
        local RunService = game:GetService("RunService")
        local CurrentFailureHaveGoBack = 0
        local ShouldSkipFunc = false
        local latestFailureTime = 0
        local function MoveToDestinationAI(destination, plrToReach, idMode)
            local path = PathfindingService:CreatePath()
            if localP.Character and localP.Character:IsDescendantOf(workspace) then
                if idMode == 1 then
                    CurrentFailureHaveGoBack = 0
                    ShouldSkipFunc = false
                else
                    if ShouldSkipFunc == true then
                        ShouldSkipFunc = false
                        return
                    else
                        if CurrentFailureHaveGoBack >= 3 then
                            CurrentFailureHaveGoBack = 0
                            return "Failure Max"
                        end
                    end
                end
                local character = localP.Character
                local humanoid = character:WaitForChild("Humanoid")

                local waypoints
                local nextWaypointIndex
                local reachedConnection
                local blockedConnection
                
                if Players:FindFirstChild(plrToReach.Name) and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and localP.Character and localP.Character:IsDescendantOf(workspace) then
                    if (character:WaitForChild("HumanoidRootPart").Position - plrToReach.Character:WaitForChild("HumanoidRootPart").Position).Magnitude >= 165 then
                        ShouldSkipFunc = true
                        return
                    end
                else
                    ShouldSkipFunc = true
                    return
                end

                -- Compute the path
                local success, errorMessage =
                    pcall(
                    function()
                        path:ComputeAsync(character:WaitForChild("HumanoidRootPart").Position, destination)
                    end
                )

                if success and path.Status == Enum.PathStatus.Success then
                    -- Get the path waypoints
                    waypoints = path:GetWaypoints()

                    -- Detect if path becomes blocked
                    blockedConnection =
                        path.Blocked:Connect(
                        function(blockedWaypointIndex)
                            -- Check if the obstacle is further down the path
                            if blockedWaypointIndex >= nextWaypointIndex then
                                -- Stop detecting path blockage until path is re-computed
                                blockedConnection:Disconnect()
                                -- Call function to re-compute new path
                                print("path blocked")
                                if localP.Character and localP.Character:IsDescendantOf(workspace) then
                                    localP.Character:WaitForChild("HumanoidRootPart").CFrame += localP.Character:WaitForChild("HumanoidRootPart").CFrame.LookVector * 5
                                end
                            end
                        end
                    )

                    -- Initially move to second waypoint (first waypoint is path start; skip it)
                    nextWaypointIndex = 2
                    local lastMessageFollowMe = 0
                    for i, v in pairs(waypoints) do
                        if not Players:FindFirstChild(plrToReach.Name) then
                            print("PLAYER LEFT")
                            ShouldSkipFunc = true
                            break
                        end
                        if i > 1 then
                            local IsJumping = false
                            if waypoints[i].Action == Enum.PathWaypointAction.Jump then
                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                IsJumping = true
                            else
                                humanoid:MoveTo(waypoints[i].Position)
                            end
                            if IsJumping == false then
                                local SkippedAmount = 0
                                local PlayerDeclined = false
                                repeat
                                    task.wait(.1)
                                    SkippedAmount = SkippedAmount + 1
                                    IfSittingJumpThen()
                                    -- Check if plrToReach declined
                                    if ChattedPlrsFuncList[plrToReach.UserId] ~= nil then
                                        for _, vObjectMessages in pairs(ChattedPlrsFuncList[plrToReach.UserId]) do
                                            for _, msgGot in pairs(ListDeclineMessages) do
                                                if string.find(string.lower(vObjectMessages["Msg"]), msgGot) then
                                                    print("Player declined to go to your stand !")
                                                    PlayerDeclined = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                until idMode == 1 and plrToReach ~= nil and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and
                                    (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - destination).Magnitude >=
                                        50 or
                                    localP.Character and localP.Character:IsDescendantOf(workspace) and
                                        (localP.Character:WaitForChild("HumanoidRootPart").Position - waypoints[i].Position).Magnitude <=
                                            7 or
                                    SkippedAmount >= (2 * 10)
                                if PlayerDeclined then
                                    task.wait(2)
                                    ShouldSkipFunc = true
                                    break
                                end
                                if
                                    idMode == 1 and plrToReach ~= nil and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and
                                        (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - destination).Magnitude >=
                                            50
                                then
                                    break
                                end
                                local boothGet = GetBooth()
                                if boothGet ~= nil and boothGet["HasBooth"] then
                                    if boothGet["BoothPart"] then
                                        if plrToReach ~= nil and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and
                                        (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - boothGet["BoothPart"].Position).Magnitude <= 30 then
                                            if localP.Character and localP.Character:IsDescendantOf(workspace) then
                                                -- Cancel Humanoid MoveTo
                                                humanoid:MoveTo(localP.Character:WaitForChild("HumanoidRootPart").Position)
                                            end
                                            task.wait(5)
                                            SendMessageInChat(string.sub(string.lower(plrToReach.DisplayName), 1, math.random(4, 8)) .. ", donate please")
                                            local startWaitingTime = tick()
                                            local boothGet = GetBooth()
                                            if boothGet ~= nil and boothGet["HasBooth"] then
                                                if boothGet["BoothPart"] then
                                                    repeat task.wait(.1) until (tick() - startWaitingTime) >= 40 or Players:FindFirstChild(plrToReach.Name) and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - boothGet["BoothPart"].Position).Magnitude >= 80 or not Players:FindFirstChild(plrToReach.Name)
                                                end
                                            end
                                            ShouldSkipFunc = true
                                            break
                                        end
                                    end
                                end
                                if idMode == 2 and CurrentFailureHaveGoBack >= 1 and (tick() - lastMessageFollowMe) >= 8 and localP.Character and localP.Character:IsDescendantOf(workspace) and plrToReach ~= nil and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and
                                (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - localP.Character:WaitForChild("HumanoidRootPart").Position).Magnitude <= 7 then
                                    if localP.Character and localP.Character:IsDescendantOf(workspace) then
                                        -- Cancel Humanoid MoveTo
                                        humanoid:MoveTo(localP.Character:WaitForChild("HumanoidRootPart").Position)
                                    end
                                    task.wait(3)
                                    if localP.Character and localP.Character:IsDescendantOf(workspace) and plrToReach ~= nil and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and
                                    (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - localP.Character:WaitForChild("HumanoidRootPart").Position).Magnitude >= 150 then
                                        ShouldSkipFunc = true
                                        break
                                    end
                                    lastMessageFollowMe = tick()
                                    SendMessageInChat(string.sub(string.lower(plrToReach.DisplayName), 1, math.random(3, 5)) .. ", " .. BegMessagesList["FollowMePleaseMessages"][math.random(1, #BegMessagesList["FollowMePleaseMessages"])])
                                    task.wait(2)
                                    local boothGet = GetBooth()
                                    if boothGet ~= nil and boothGet["HasBooth"] then
                                        if boothGet["BoothPart"] then
                                            local moveToDestination = MoveToDestinationAI(boothGet["BoothPart"].Position, plrToReach, 3)
                                            if moveToDestination == "Failure Max" then
                                                ShouldSkipFunc = true
                                                break
                                            else
                                                -- Waits a bit before going away, so that the user can perhaps donate
                                                task.wait(8)
                                            end
                                        end
                                    end
                                end
                                if idMode == 2 and localP.Character and localP.Character:IsDescendantOf(workspace) and plrToReach ~= nil and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and
                                (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - localP.Character:WaitForChild("HumanoidRootPart").Position).Magnitude >=
                                    65 and (tick() - latestFailureTime) >= 1 then
                                        latestFailureTime = tick()
                                        print(CurrentFailureHaveGoBack, "ADDED CurrentFailureHaveGoBack")
                                        CurrentFailureHaveGoBack = CurrentFailureHaveGoBack + 1
                                        local moveToDestination = MoveToDestinationAI(plrToReach.Character:WaitForChild("HumanoidRootPart").Position, plrToReach, 2)
                                        if moveToDestination == "Failure Max" then
                                            ShouldSkipFunc = true
                                            break
                                        end
                                    end
                            end
                        end
                    end
                    if idMode == 1 then
                        if localP.Character and localP.Character:IsDescendantOf(workspace) then
                            -- Cancel Humanoid MoveTo
                            humanoid:MoveTo(localP.Character:WaitForChild("HumanoidRootPart").Position)
                        end
                        -- Give some time for the bot to "type" like a human
                        task.wait(5)
                        if Players:FindFirstChild(plrToReach.Name) and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - localP.Character:WaitForChild("HumanoidRootPart").Position).Magnitude <= 55 then
                            SendMessageInChat(string.sub(string.lower(plrToReach.DisplayName), 1, math.random(4, 8)) .. ", can you please donate to me ?")
                            local StartingTimeWait1 = tick()
                            local CanStopLoop1 = false
                            repeat
                                task.wait(.1)
                                if ChattedPlrsFuncList[plrToReach.UserId] ~= nil then
                                    for _, vObjectMessages in pairs(ChattedPlrsFuncList[plrToReach.UserId]) do
                                        for _, msgGot in pairs(WhitelistedAgreeMessages) do
                                            if string.find(string.lower(vObjectMessages["Msg"]), msgGot) then
                                                print("Player agreed to go to your stand !")
                                                CanStopLoop1 = true
                                                break
                                            end
                                        end
                                    end
                                end
                            until CanStopLoop1 or (tick() - StartingTimeWait1) >= 15 or not Players:FindFirstChild(plrToReach.Name) or Players:FindFirstChild(plrToReach.Name) and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - localP.Character:WaitForChild("HumanoidRootPart").Position).Magnitude >= 75
                            if not Players:FindFirstChild(plrToReach.Name) or Players:FindFirstChild(plrToReach.Name) and plrToReach.Character and plrToReach.Character:IsDescendantOf(workspace) and (plrToReach.Character:WaitForChild("HumanoidRootPart").Position - localP.Character:WaitForChild("HumanoidRootPart").Position).Magnitude >= 75 then
                                ShouldSkipFunc = true
                                return
                            end
                            if CanStopLoop1 then
                                -- Player has agreed to come to your stand, so waiting 3 seconds
                                task.wait(3)
                            end
                            SendMessageInChat(string.sub(string.lower(plrToReach.DisplayName), 1, math.random(4, 6)) .. ", " .. BegMessagesList["FollowMeToMyStand"][math.random(1, #BegMessagesList["FollowMeToMyStand"])])
                            local boothGet = GetBooth()
                            if boothGet ~= nil and boothGet["HasBooth"] then
                                if boothGet["BoothPart"] then
                                    MoveToDestinationAI(boothGet["BoothPart"].Position, plrToReach, 2)
                                    -- Waits a bit before going away, so that the user can perhaps donate
                                    task.wait(8)
                                end
                            end
                        else
                            ShouldSkipFunc = true
                            return
                        end
                    end
                end
            end
        end
        local function NoclipLoop()
            -- Noclip Loop
            coroutine.wrap(function()
                while true do
                    task.wait()
                    if localP.Character and localP.Character:IsDescendantOf(workspace) then
                        if localP.Character:WaitForChild("Humanoid"):GetState() ~= Enum.HumanoidStateType.Jumping then
                            local raycastParams = RaycastParams.new()
                            local ListPlayersChars = {}
                            for i,v in pairs(Players:GetPlayers()) do
                                if v.Character and v.Character:IsDescendantOf(workspace) then
                                    table.insert(ListPlayersChars, v.Character)
                                end
                            end
                            raycastParams.FilterDescendantsInstances = ListPlayersChars
                            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                            raycastParams.IgnoreWater = true
                            local rayCheck = workspace:Raycast(localP.Character:WaitForChild("HumanoidRootPart").Position, localP.Character:WaitForChild("HumanoidRootPart").CFrame.LookVector * 3, raycastParams)
                            if rayCheck then
                                localP.Character:WaitForChild("HumanoidRootPart").CFrame += localP.Character:WaitForChild("HumanoidRootPart").CFrame.LookVector * 5
                            end
                        end
                    end
                end
            end)()
        end
        NoclipLoop()
        -- UI
        local uilibrary =
            loadstring(game:HttpGet("https://raw.githubusercontent.com/crownaintanoob/CFA-Hub-UI-lib/main/source.lua"))()
        local WindowGot = uilibrary:CreateWindow("Crown UI", "PLS DONATE", true)

        local MainPage = WindowGot:CreatePage("Main")

        local Section1 = MainPage:CreateSection("Main Section")

        local AutoFarmToggle = true
        local LastPersonAskedMessage = nil
        Section1:CreateToggle(
            "Auto farm",
            {Toggled = true, Description = false},
            function(Value)
                AutoFarmToggle = Value
                while AutoFarmToggle do
                    task.wait(.1)
                    local boothGet = GetBooth()
                    if boothGet ~= nil and not boothGet["HasBooth"] then
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ClaimBooth"):InvokeServer --[[Booth Slot]](
                            boothGet["BoothSlot"]
                        )
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetBoothText"):FireServer --[[Booth Text]](
                            "Donate BRO!" --[[BoothModel Name]],
                            "booth"
                        )
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetDonatedVisibility"):FireServer(--[[Whether players can see our donated in leaderstats]]false) -- Anonymous mode for donated
                    else
                        -- Localplayer has a booth
                        local PlayersList = Players:GetPlayers()
                        local ListPlayersNotNearStand = {}
                        for _, vPlr in pairs(PlayersList) do
                            if vPlr.UserId ~= localP.UserId then
                                for _, boothInteractionPart in pairs(workspace:WaitForChild("BoothInteractions"):GetChildren()) do
                                    if boothInteractionPart.Name == "BoothInteraction" then
                                        local OwnerBooth = boothInteractionPart:GetAttribute("BoothOwner")
                                        if OwnerBooth == vPlr.UserId then
                                            if vPlr.Character and vPlr.Character:IsDescendantOf(workspace) then
                                                if (vPlr.Character:WaitForChild("HumanoidRootPart").Position - boothInteractionPart.Position).Magnitude >= 50 then
                                                    table.insert(ListPlayersNotNearStand, vPlr)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        local plrRandom
                        if #ListPlayersNotNearStand > 1 then
                            --print("Found player away from stand (1)")
                            plrRandom = ListPlayersNotNearStand[math.random(1, #ListPlayersNotNearStand)]
                        elseif #ListPlayersNotNearStand == 1 then
                            --print("Found player away from stand (2)")
                            plrRandom = ListPlayersNotNearStand[1]
                        elseif #ListPlayersNotNearStand <= 0 then
                            print("did not find a player away from their stand, so getting random player")
                            plrRandom = PlayersList[math.random(1, #PlayersList)]
                        end
                        if plrRandom.Character and plrRandom.Character:IsDescendantOf(workspace) and LastPersonAskedMessage ~= plrRandom then
                            if (plrRandom.Character:WaitForChild("HumanoidRootPart").Position - localP.Character:WaitForChild("HumanoidRootPart").Position).Magnitude <= 250 then
                                if PlayersBeginningPos[plrRandom.UserId] ~= nil and (PlayersBeginningPos[plrRandom.UserId] - plrRandom.Character:WaitForChild("HumanoidRootPart").Position).Magnitude >= 50 then
                                    LastPersonAskedMessage = plrRandom
                                    MoveToDestinationAI(plrRandom.Character:WaitForChild("HumanoidRootPart").Position, plrRandom, 1)
                                end
                            end
                        end
                    end
                end
            end
        )
    else
        warn("Alreadry executed the Crown Bot!")
    end
end

RunBot()
