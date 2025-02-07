local width,height = love.graphics.getDimensions()
love.math.setRandomSeed(love.timer.getTime())
local font = love.graphics.newFont("fonts/font.ttf",17)
local titelFont = love.graphics.newFont("fonts/font.ttf",30)
--Suit
local slider = {value = 1, min = 0, max = 1}
local checkbox = {checked = false, text = "Hide Helpers?"}
love.graphics.setFont(font)

local suit = require"libaries/suit"

function love.load()
    scene = "MainMenu"

    player = {}
    player.clicks = 0
    player.cooncoins = 0
    player.amount = 1
    player.multi = 1 
    player.helperToys = 1
    player.hacks = 0
    player.scracoon = 0

    player.helpers = {}
    player.helpers.amount = 0

    player.hardhelpers = {}
    player.hardhelpers.amount = 0

    player.queenhelpers = {}
    player.queenhelpers.amount = 0 
    
    player.cryptohelpers = {}
    player.cryptohelpers.amount = 0

    player.amountPrice = 5
    player.clickCooldownPrice = 300
    player.helperPrice = 20
    player.hardHelperPrice = 2000
    player.multiPrice  = 125000
    player.queenPrice = 1000000
    player.helperToysPrice = 50000
    player.cryptohelperPrice = 10000000
    player.hackPrice = 100
    player.scracoonPrice = 999


    player.moods = {}
    player.moods.mood = "basic" 
    player.moods.basic = love.graphics.newImage("images/goofyface.png")
    player.moods.cute = love.graphics.newImage("images/cuteracoon.png")
    player.moods.cursed = love.graphics.newImage("images/cursedracoon.png")
    player.moods.rich = love.graphics.newImage("images/richracoon.png")
    player.moods.greedy = love.graphics.newImage("images/greedyracoon.png")

    --Sfx
    clickSFX = love.audio.newSource("sounds/clickSFX.wav","static")
    helperPaySFX = love.audio.newSource("sounds/Chaching.wav","static")
    upgradeSFX = love.audio.newSource("sounds/upgradeSFX.wav","static")
    cryptoSFX = love.audio.newSource("sounds/cryptoChahing.wav","static")
    saveNloadSFX = love.audio.newSource("sounds/saveNloadSFX.wav","static")

    --Shop & misc
    shop = "clicks"

    --Timers

    --Click timer
    cTimer = 0
    CMTimer = 20

    --Upgrade timer
    uTimer = 0
    uMtimer = 17

    --Helper timer
    hTimer = 0
    hMTimer = 30

    qHTimer = 0
    qHMTimer = 174

    cHTimer = 0
    cHMTimer = 156

    --Endgame Timers
    eGTimer = 0
    eGMTimer = 200

    --Mood timer
    mTimer = 0
    mMTimer = 300


    --Background
    background = love.graphics.newImage("images/background.png")
    sBackground = love.graphics.newImage("images/Settingsbackground.png")

    sTimer = 0
    sMTimer = 60

end

function love.update(dt)
    --Scene timer
    sTimer = sTimer + 1
    if sTimer >= sMTimer then
        sTimer = sMTimer
    end
    
    if love.keyboard.isDown("escape") and sTimer >= sMTimer and scene == "game" then
        sTimer = 0
        scene = "MainMenu"
    end

    if love.keyboard.isDown("escape") and sTimer >= sMTimer and scene == "MainMenu" then
        love.event.quit()
    end

    if love.keyboard.isDown("escape") and sTimer >= sMTimer and scene == "settings" then
        sTimer = 0
        scene = "MainMenu"
    end

    if scene == "game" then
        --Timers
        cTimer = cTimer + 1 
        if cTimer >= CMTimer then
            cTimer = CMTimer
        end

        uTimer = uTimer + 1 
        if uTimer >= uMtimer then
            uTimer = uMtimer
        end

        hTimer = hTimer + 1
        if hTimer >= hMTimer then
            hTimer = hMTimer
        end

        mTimer = mTimer + 1
        if mTimer >= mMTimer then
            mTimer = 0
            moodPicker(love.math.random(1,5))
        end

        eGTimer = eGTimer + 1
        if eGTimer >= eGMTimer then
            eGTimer = eGMTimer
        end

        if eGTimer >= eGMTimer and player.scracoon >= 1 then
            eGTimer = 0
            helperPaySFX:play()
            player.clicks = player.clicks + 25000 * player.multi
            player.cooncoins = player.cooncoins + 3 + (player.cryptohelpers.amount / 2)
        end
        
    
        if hTimer >= hMTimer and player.helpers.amount >= 1 then
            hTimer = 0
            helperPaySFX:play()
            player.clicks = player.clicks + 0.70 * (player.helpers.amount * player.multi * player.amount) * player.helperToys
            if player.hardhelpers.amount >= 1 then
                player.clicks = player.clicks + player.hardhelpers.amount * 17 * player.multi * player.amount * player.helperToys
            end
        end

        cHTimer = cHTimer + 1
        if cHTimer >= cHMTimer then
            cHTimer = cHMTimer
        end

        if cHTimer >= cHMTimer and player.cryptohelpers.amount >= 1 then
            cHTimer = 0
            cryptoSFX:play()
            player.cooncoins = player.cooncoins + player.cryptohelpers.amount
        end


        qHTimer = qHTimer + 1

        if qHTimer >= qHMTimer then
            qHTimer = qHMTimer
        end

        if qHTimer >= qHMTimer and player.queenhelpers.amount >= 1 then
            qHTimer = 0
            helperPaySFX:play()
            player.clicks = player.clicks + 35 * (player.queenhelpers.amount * player.multi * player.amount) * player.helperToys
        end

        if love.keyboard.isDown("w") and uTimer >= uMtimer and player.clicks >= player.amountPrice then
            upgradeAmount()
        end

        if love.keyboard.isDown("q") and uTimer >= uMtimer and player.clicks >= player.clickCooldownPrice then
            upgradeCTimer()
        end

        if love.keyboard.isDown("e") and uTimer >= uMtimer and player.clicks >= player.helperPrice then
            upgradeHelper()
        end

        if love.keyboard.isDown("r") and uTimer >= uMtimer and player.clicks >= player.hardHelperPrice then
            upgradeHardHelper()
        end

        if love.keyboard.isDown("t") and uTimer >= uMtimer and player.clicks >= player.multiPrice then
            upgradeMulti()
        end

        if love.keyboard.isDown("y") and uTimer >= uMtimer and player.clicks >= player.queenPrice then
            upgradeQueenHelper()
        end

        if love.keyboard.isDown("u") and uTimer >= uMtimer and player.clicks >= player.helperToysPrice then
            upgradeHelperToys()
        end

        if love.keyboard.isDown("i") and uTimer >= uMtimer and player.clicks >= player.cryptohelperPrice then
            upgradeCryptoRacoon()
        end

        if love.keyboard.isDown("o") and uTimer >= uMtimer and player.cooncoins >= player.hackPrice then
            upgradeHack()
        end

        if love.keyboard.isDown("p") and uTimer >= uMtimer and player.cooncoins >= player.scracoonPrice then
            upgradeScracoon()
        end

        if suit.Button("Save", 200,30).hit and uTimer >= uMtimer then
            saveNloadSFX:play()
            saveData()
        end

        if suit.Button("Load", 245,30).hit and uTimer >= uMtimer then
            saveNloadSFX:play()
            loadData()
        end

        if suit.Button("Clicks shop",0,395).hit and uTimer >= uMtimer then
            shop = "clicks"
        end

        if suit.Button("Coon shop",110,395).hit and uTimer >= uMtimer then
            shop = "coon"
        end

    end

    if scene == "MainMenu" then
        if suit.Button("Play Racoon clicker 2!",width/2-110,height-500).hit then
            scene = "game"
        end

        if suit.Button("Settings",width/2-55,height-460).hit then
            scene = "settings"
        end
    end

    if scene == "settings" then
        suit.Slider(slider, 100,100,160, 20)
        suit.Checkbox(checkbox,255,175,32,32)
    end

    love.audio.setVolume(slider.value)
end

function love.draw()
    if scene == "game" then
        love.graphics.setFont(font)
        love.graphics.draw(background)

        if checkbox.checked == false then
            for i, helper in ipairs(player.helpers) do
                love.graphics.draw(helper.sprite,helper.x,helper.y)
            end

            for i, hardhelper in ipairs(player.hardhelpers) do
                love.graphics.draw(hardhelper.sprite,hardhelper.x,hardhelper.y)
            end

            for i, queenhelper in ipairs(player.queenhelpers) do
                love.graphics.draw(queenhelper.sprite,queenhelper.x,queenhelper.y)
            end

            for i, cryptohelper in ipairs(player.cryptohelpers) do
                love.graphics.draw(cryptohelper.sprite,cryptohelper.x,cryptohelper.y)
            end
        end

        love.graphics.setFont(font)
        love.graphics.setColor(0,0,0)
        love.graphics.print("Stats! \nMoney: "..formatNumber(player.clicks).."$\nCoon Coins: "..formatNumber(player.cooncoins).."$\nAmount level: "..player.amount.."\nCooldown: "..CMTimer.."\nHelper level: "..player.helpers.amount.."\nHard working\nhelper level: "..player.hardhelpers.amount.."\nMultiplier level: "..player.multi.."\nQueen level: "..player.queenhelpers.amount.."\nHelper toys level: "..(player.helperToys-1).."\nCrypto helper level: "..player.cryptohelpers.amount.."\nHacks on mainframe: "..player.hacks.."\nScracoon level: "..player.scracoon)
        
        if shop == "clicks" then
            love.graphics.print("Upgrade prices! \nAmount price: "..formatNumber(player.amountPrice).."$ Press W to buy\nCooldown price: "..formatNumber(player.clickCooldownPrice).."$ Press Q to buy\nHelper price: "..formatNumber(player.helperPrice).."$ Press E to buy\nHard working helper price: "..formatNumber(player.hardHelperPrice).."$ Press R to buy\nMultiplier price: "..formatNumber(player.multiPrice).."$ Press T to buy".."\nQueen price: "..formatNumber(player.queenPrice).."$ Press Y to buy".."\nHelper toys price: "..formatNumber(player.helperToysPrice).."$ Press U to buy".."\nCrypto helper price: "..formatNumber(player.cryptohelperPrice).."$ Press I to buy",0,578-20*8)
            love.graphics.setColor(1,1,1)
        elseif shop == "coon" then
            love.graphics.print("Upgrade prices!\nHack mainframe price: "..formatNumber(player.hackPrice).." Coon coins Press O to buy\nScracoon price: "..formatNumber(player.scracoonPrice).." Coon coins Press P to buy",0,578-20*8)
            love.graphics.setColor(1,1,1)
        end


        if player.moods.mood == "basic" then
            love.graphics.draw(player.moods.basic,width/2,height/2,nil,nil,nil,117,113)
        elseif player.moods.mood == "cute" then
            love.graphics.draw(player.moods.cute,width/2,height/2,nil,nil,nil,112.5,112.5)
        elseif player.moods.mood == "cursed" then
            love.graphics.draw(player.moods.cursed,width/2,height/2,nil,nil,nil,91,135)
        elseif player.moods.mood == "rich" then
            love.graphics.draw(player.moods.rich,width/2,height/2,nil,nil,nil,151,161)
        elseif player.moods.mood == "greedy" then
            love.graphics.draw(player.moods.greedy,width/2,height/2,nil,nil,nil,135,124.5)
        end
    end

    if scene == "MainMenu" then
        love.graphics.setFont(titelFont)
        love.graphics.print("RACOON CLICKER 2!",width/2-160,50)
        love.graphics.setFont(font)
        love.graphics.print("Made by CosmicCynth",width/2-117,height-32)
    end

    if scene == "settings" then
        love.graphics.draw(sBackground)
        love.graphics.print("Audio level",135,80)
        love.graphics.print(slider.value, 270,100)
        love.graphics.print("Hide Helpers?",100,180)
    end

    suit.draw()
end

function love.mousepressed(x,y,button)
    if scene == "game" then
        if button == 1 and cTimer >= CMTimer then
            clickSFX:play()
            if player.moods.mood == "basic" then
                player.clicks = player.clicks + player.amount * player.multi 
                cTimer = 0
            elseif player.moods.mood == "cute" then
                player.clicks = player.clicks + player.amount * player.multi * 1.222
                cTimer = 0
            elseif player.moods.mood == "cursed" then
                player.clicks = player.clicks + player.amount * 2
                cTimer = 0
            elseif player.moods.mood == "rich" then
                player.clicks = player.clicks + player.amount * player.multi * 1.75 + 1.5
                cTimer = 0
            elseif player.moods.mood == "greedy" then
                player.clicks = player.clicks + player.amount * player.multi * 0.85
                cTimer = 0
            end
        end
    end
end 

--Functions!

function upgradeAmount()
    upgradeSFX:play()
    uTimer = 0
    player.amount = player.amount + 1
    player.clicks = player.clicks - player.amountPrice
    player.amountPrice = player.amountPrice * 1.33
end

function upgradeCTimer()
    upgradeSFX:play()
    uTimer = 0
    CMTimer = CMTimer / 2
    player.clicks = player.clicks - player.clickCooldownPrice
    player.clickCooldownPrice = player.clickCooldownPrice * 1.22
end


function upgradeHelper()
    upgradeSFX:play()
    uTimer = 0
    player.helpers.amount = player.helpers.amount + 1
    spawnHelper(sprite, love.math.random(200,700), love.math.random(0,350))
    player.clicks = player.clicks - player.helperPrice
    player.helperPrice = player.helperPrice * 1.25
end

function upgradeHardHelper()
    upgradeSFX:play()
    uTimer = 0
    player.hardhelpers.amount = player.hardhelpers.amount + 1
    spawnHardHelper(sprite,love.math.random(200,700), love.math.random(0,350))
    player.clicks = player.clicks - player.hardHelperPrice
    player.hardHelperPrice = player.hardHelperPrice * 1.5
end

function upgradeMulti()
    upgradeSFX:play()
    uTimer = 0
    player.multi = player.multi + 1
    player.clicks = player.clicks - player.multiPrice
    player.multiPrice = player.multiPrice * 3
end

function upgradeQueenHelper()
    upgradeSFX:play()
    uTimer = 0
    player.queenhelpers.amount = player.queenhelpers.amount + 1
    spawnQueenHelper(sprite,love.math.random(200,700), love.math.random(0,350))
    player.clicks = player.clicks - player.queenPrice
    player.queenPrice = player.queenPrice * 1.25
end

function upgradeHelperToys()
    upgradeSFX:play()
    uTimer = 0 
    player.helperToys = player.helperToys + 1
    player.clicks = player.clicks - player.helperToysPrice
    player.helperToysPrice = player.helperToysPrice * 1.5
end

function upgradeCryptoRacoon()
    upgradeSFX:play()
    uTimer = 0
    player.cryptohelpers.amount = player.cryptohelpers.amount + 1
    spawnCryptoHelper(sprite,love.math.random(200,700),love.math.random(0,350))
    player.clicks = player.clicks - player.cryptohelperPrice
    player.cryptohelperPrice = player.cryptohelperPrice * 1.25
end

function upgradeHack()
    upgradeSFX:play()
    uTimer = 0
    player.amount = player.amount + 21
    player.multi = player.multi + 2
    player.helperToys = player.helperToys + 3
    player.cooncoins = player.cooncoins - player.hackPrice
    player.hackPrice = player.hackPrice * 1.25 + 20 
    player.hacks = player.hacks + 1
end

function upgradeScracoon()
    upgradeSFX:play()
    uTimer = 0
    player.scracoon = player.scracoon + 1
    player.cooncoins = player.cooncoins - player.scracoonPrice
    player.scracoonPrice = player.scracoonPrice * 1.25
end

function spawnCryptoHelper(sprite,x,y)
    cryptoHelper = {}
    cryptoHelper.sprite = love.graphics.newImage("images/cryptoracoon.png")
    cryptoHelper.x = x
    cryptoHelper.y = y
    table.insert(player.cryptohelpers,cryptoHelper)
end

function spawnQueenHelper(sprite,x,y)
    queenHelper = {}
    queenHelper.sprite = love.graphics.newImage("images/queenracoon.png")
    queenHelper.x = x
    queenHelper.y = y
    table.insert(player.queenhelpers,queenHelper)
end

function spawnHelper(sprite,x,y)
    basicHelper = {}
    basicHelper.sprite = love.graphics.newImage("images/helperracoon.png")
    basicHelper.x = x
    basicHelper.y = y
    table.insert(player.helpers,basicHelper)
end

function spawnHardHelper(sprite,x,y)
    hardHelper = {}
    hardHelper.sprite = love.graphics.newImage("images/hardworkingracoon.png")
    hardHelper.x = x
    hardHelper.y = y
    table.insert(player.hardhelpers,hardHelper)
end



function moodPicker(value)
    if value == 1 then
        player.moods.mood = "basic"
    elseif value == 2 then
        player.moods.mood = "cute"
    elseif value == 3 then
        player.moods.mood = "cursed"
    elseif value == 4 then
        player.moods.mood = "rich"
    elseif value == 5 then
        player.moods.mood = "greedy"
    end
end

function saveData()
    local data = {
        money = player.clicks,
        coonMoney = player.cooncoins,
        amountlevel = player.amount,
        helpersnumber =  player.helpers.amount,
        multilevel = player.multi,
        helperToysLevel = player.helperToys,
        hacksLevel = player.hacks,
        hardHelpersNumber = player.hardhelpers.amount,
        queenhelperNumber = player.queenhelpers.amount,
        cryotohelpersNumber = player.cryptohelpers.amount,
        amountlevelprice = player.amountPrice,
        helpersnumberprice = player.helperPrice,
        multilevelprice = player.multiPrice,
        helpersToysLevelprice = player.helperToysPrice,
        hacksLevelprice = player.hackPrice,
        hardHelpersNumberprice = player.hardHelperPrice,
        queenhelperNumberprice = player.queenPrice,
        cryptohelpersNumberLevel = player.cryptohelperPrice,
        scracoonNumberLevel = player.scracoon,
        scracoonNumberPrice = player.scracoonPrice,
        audiolevel = slider.value
    }

    local jsonString = love.filesystem.write("savegame.txt", love.data.encode("string", "base64", table.concat({data.money, data.coonMoney, data.amountlevel,data.helpersnumber,data.multilevel,data.helperToysLevel,data.hacksLevel,data.hardHelpersNumber,data.queenhelperNumber,data.cryotohelpersNumber,data.amountlevelprice,data.helpersnumberprice,data.multilevelprice,data.helpersToysLevelprice,data.hacksLevelprice,data.hardHelpersNumberprice,data.queenhelperNumberprice,data.cryptohelpersNumberLevel,data.scracoonNumberLevel,data.scracoonNumberPrice,data.audiolevel}, ",")))
end

function loadData()
    if love.filesystem.getInfo("savegame.txt") then
        local contents = love.filesystem.read("savegame.txt") 
        local decodedString = love.data.decode("string", "base64", contents)
        local dataParts = {}

        for value in decodedString:gmatch("([^,]+)") do
            table.insert(dataParts, value)
        end

        player.clicks = tonumber(dataParts[1]) or 0
        player.cooncoins = tonumber(dataParts[2]) or 0
        player.amount = tonumber(dataParts[3]) or 0
        player.helpers.amount = tonumber(dataParts[4]) or 0
        player.multi = tonumber(dataParts[5]) or 0
        player.helperToys = tonumber(dataParts[6]) or 0
        player.hacks = tonumber(dataParts[7]) or 0
        player.hardhelpers.amount = tonumber(dataParts[8]) or 0
        player.queenhelpers.amount = tonumber(dataParts[9]) or 0
        player.cryptohelpers.amount = tonumber(dataParts[10]) or 0
        player.amountprice = tonumber(dataParts[11]) or 0
        player.helperPrice = tonumber(dataParts[12]) or 0
        player.multiPrice = tonumber(dataParts[13]) or 0
        player.helperToysPrice = tonumber(dataParts[14]) or 0
        player.hackPrice =  tonumber(dataParts[15]) or 0
        player.hardHelperPrice = tonumber(dataParts[16]) or 0
        player.queenPrice = tonumber(dataParts[17]) or 0
        player.cryptohelperPrice = tonumber(dataParts[18]) or 0
        player.scracoon = tonumber(dataParts[19]) or 0
        player.scracoonPrice = tonumber(dataParts[20]) or 0
        slider.value = tonumber(dataParts[21]) or 0
        return true
    else
        return false
    end
end

function formatNumber(n)
    if n >= 1e9 then
        return string.format("%.1fB", n / 1e9)  -- Billions
    elseif n >= 1e6 then
        return string.format("%.1fM", n / 1e6)  -- Millions
    elseif n >= 1e3 then
        return string.format("%.1fK", n / 1e3)  -- Thousands
    else
        return tostring(math.floor(n))  -- No formatting needed
    end
end
