local PlsDonateId = 8737602449
local WaitingPlaceId = 14195425876
local function tp()
    local suc =
        pcall(
        function()
            game:GetService("TeleportService"):Teleport(
                if game.PlaceId == PlsDonateId then WaitingPlaceId elseif game.PlaceId == WaitingPlaceId then PlsDonateId
            )
        end
    )
    if not suc then
        tp()
    end
end

tp()
