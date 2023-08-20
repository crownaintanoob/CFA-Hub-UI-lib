if game.PlaceId ~= 8737602449 then
    return
end -- failed attempt at autoexec compatability below, feel free to try and fix it

if not game.IsLoaded then
    game.Loaded:Wait()
end
--wait(.5)

--writefile("MinimumDonation.txt",tostring(minimum))

for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    repeat
        wait()
    until v:FindFirstChild("leaderstats")
end

local GUIDs = {}
local maxPlayers = 0
local pagesToSearch = 100
function Search()
    local Http =
        game:GetService("HttpService"):JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor="
        )
    )
    for i = 1, pagesToSearch do
        for _, v in pairs(Http.data) do
            if v.playing ~= v.maxPlayers and v.id ~= game.JobId then
                maxPlayers = v.maxPlayers
                table.insert(GUIDs, {id = v.id, users = v.playing})
            end
        end
        print("Searched! i=", i)
        if Http.nextPageCursor ~= null then
            Http =
                game:GetService("HttpService"):JSONDecode(
                game:HttpGet(
                    "https://games.roblox.com/v1/games/" ..
                        game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. Http.nextPageCursor
                )
            )
        else
            break
        end
    end
end

local highest = {id = "", users = 0}
function findHighest()
    local suc =
        pcall(
        function()
            for i, v in ipairs(GUIDs) do
                if v.users > highest.users and not (v.users > (maxPlayers - 4)) then
                    highest = v
                end
            end
        end
    )

    if not suc then
        Search()
        findHighest()
    end
end

function tp()
    local suc =
        pcall(
        function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId,
                highest.id,
                game.Players.LocalPlayer
            )
        end
    )
    if not suc then
        Search()
        findHighest()
        tp()
    end
end

Search()
findHighest()
tp()
