local width,height = love.graphics.getDimensions()
love.math.setRandomSeed(love.timer.getTime())
font = love.graphics.newFont("fonts/font.ttf",17)

function love.load()
    player = {}
    player.clicks = 0
    player.amount = 1
    player.multi = 1

    player.helpers = {}
    player.helpers.amount = 0

    player.hardhelpers = {}
    player.hardhelpers.amount = 0


    player.amountPrice = 5
    player.clickCooldownPrice = 300
    player.helperPrice = 20
    player.hardHelperPrice = 2000

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

    --Mood timer
    mTimer = 0
    --mMTimer = 1200
    mMTimer = 240


    --Background
    background = love.graphics.newImage("images/background.png")

end

function love.update(dt)
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
 
    if hTimer >= hMTimer and player.helpers.amount >= 1 then
        hTimer = 0
        helperPaySFX:play()
        player.clicks = player.clicks + player.helpers.amount * player.multi * player.amount
        if player.hardhelpers.amount >= 1 then
            player.clicks = player.clicks + player.hardhelpers.amount * 20 * player.multi * player.amount
        end
    end

    if love.keyboard.isDown("w") and uTimer >= uMtimer then
        upgradeAmount()
    end

    if love.keyboard.isDown("q") and uTimer >= uMtimer then
        upgradeCTimer()
    end

    if love.keyboard.isDown("e") and uTimer >= uMtimer then
        upgradeHelper()
    end

    if love.keyboard.isDown("r") and uTimer >= uMtimer then
        upgradeHardHelper()
    end


end

function love.draw()
    love.graphics.draw(background)
    love.graphics.setFont(font)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Stats! \nMoney: "..math.floor(player.clicks).."$\nAmount level: "..player.amount.."\nCooldown: "..CMTimer.."\nHelper level: "..player.helpers.amount.."\nHard working helper level: "..player.hardhelpers.amount)

    
    love.graphics.print("Upgrade prices! \nAmount price: "..math.floor(player.amountPrice).."$\nCooldown price: "..math.floor(player.clickCooldownPrice).."$\nHelper price: "..math.floor(player.helperPrice).."$\nHard-working helper price: "..math.floor(player.hardHelperPrice).."$\n",0,578-20*4)
    love.graphics.setColor(1,1,1)
    for i, helper in ipairs(player.helpers) do
        love.graphics.draw(helper.sprite,helper.x,helper.y)
    end

    for i, hardhelper in ipairs(player.hardhelpers) do
        love.graphics.draw(hardhelper.sprite,hardhelper.x,hardhelper.y)
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

function love.mousepressed(x,y,button)
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

--Functions!

function upgradeAmount()
    upgradeSFX:play()
    uTimer = 0
    player.amount = player.amount + 1
    player.clicks = player.clicks - player.amountPrice
    player.amountPrice = player.amountPrice * 1.25
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
    spawnHelper(sprite, love.math.random(200,700), love.math.random(0,500))
    player.clicks = player.clicks - player.helperPrice
    player.helperPrice = player.helperPrice * 1.1
end

function upgradeHardHelper()
    upgradeSFX:play()
    uTimer = 0
    player.hardhelpers.amount = player.hardhelpers.amount + 1
    spawnHardHelper(sprite,love.math.random(200,700), love.math.random(0,500))
    player.clicks = player.clicks - player.hardHelperPrice
    player.hardHelperPrice = player.hardHelperPrice * 1.5
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


