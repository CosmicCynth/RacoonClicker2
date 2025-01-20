function love.load()
    --Tables & font
    scene = "mainMenu"
    sceneTxt = "Menu"
    sceneTable = {}
    sceneTable.mainMenu = {}
    sceneTable.budget = {}
    sceneTable.burgerMenu = {}
    sceneTable.settings = {}
    sceneTable.profil = {}
    sceneTable.budget.flere = {}

    font = love.graphics.newFont("font/workSans.ttf",25.5)
    love.graphics.setFont(font)

    --Forside
    sceneTable.mainMenu.sprite = love.graphics.newImage("sprite/Forside.png")

    sceneTable.mainMenu.burgerMenu = {}
    sceneTable.mainMenu.burgerMenu.x = 16
    sceneTable.mainMenu.burgerMenu.y = 16
    sceneTable.mainMenu.burgerMenu.radius = 32

    --Drop down menu
    sceneTable.burgerMenu.sprite = love.graphics.newImage("sprite/BurgerMenu.png")

    sceneTable.burgerMenu.burgerKnap = {}
    sceneTable.burgerMenu.burgerKnap.x = 16
    sceneTable.burgerMenu.burgerKnap.y = 16
    sceneTable.burgerMenu.burgerKnap.radius = 32

    sceneTable.burgerMenu.budgetKnap = {}
    sceneTable.burgerMenu.budgetKnap.x = 20
    sceneTable.burgerMenu.budgetKnap.y = 200
    sceneTable.burgerMenu.budgetKnap.radius = 20

    
    --Budget
    sceneTable.budget.sprite = love.graphics.newImage("sprite/Budget.png")

    sceneTable.budget.burgerKnap = {}
    sceneTable.budget.burgerKnap.x = 16
    sceneTable.budget.burgerKnap.y = 16
    sceneTable.budget.burgerKnap.radius = 32
    --Stuff

    --Timer
    timer = 0
    maxTimer = 10
end

function love.update(dt)
    timer = timer + 1 
    if timer > maxTimer then
        timer = maxTimer
    end

end

function love.draw()
    love.graphics.setColor(255,255,255,nil)
    if scene == "mainMenu" then
        love.graphics.circle("fill",sceneTable.mainMenu.burgerMenu.x,sceneTable.mainMenu.burgerMenu.y,sceneTable.mainMenu.burgerMenu.radius)
        love.graphics.draw(sceneTable.mainMenu.sprite,0,0)
    elseif scene == "burgerMenu" then
        love.graphics.circle("fill",sceneTable.burgerMenu.burgerKnap.x,sceneTable.burgerMenu.burgerKnap.y,sceneTable.burgerMenu.burgerKnap.radius)
        love.graphics.circle("fill",sceneTable.burgerMenu.budgetKnap.x,sceneTable.burgerMenu.budgetKnap.y,sceneTable.burgerMenu.budgetKnap.radius)
        love.graphics.draw(sceneTable.burgerMenu.sprite,0,0)
    elseif scene == "budget" then
        love.graphics.circle("fill",sceneTable.budget.burgerKnap.x,sceneTable.budget.burgerKnap.y,sceneTable.budget.burgerKnap.radius)
        love.graphics.draw(sceneTable.budget.sprite,0,0)
    elseif scene == "budgetCalc" then
        love.graphics.rectangle("fill",32,16,200,400)
    end

    --love.graphics.setColor(0,0,0,nil)
    --love.graphics.print("Scene: "..sceneTxt.." timer: "..timer)
end


function love.mousereleased(x,y,button)
    if button == 1 then
        local mouseToTarget = ""
        local mouseToTarget1 = ""
        if scene == "mainMenu" then
            mouseToTarget = distanceBetween(x,y,sceneTable.mainMenu.burgerMenu.x,sceneTable.mainMenu.burgerMenu.y) 
            if mouseToTarget < sceneTable.mainMenu.burgerMenu.radius and timer >= maxTimer then
                timer = 0
                sceneTxt = "Burger Menu"
                scene = "burgerMenu"
            end
        end

        if scene == "burgerMenu" then
            mouseToTarget = distanceBetween(x,y,sceneTable.burgerMenu.burgerKnap.x,sceneTable.burgerMenu.burgerKnap.y)
            mouseToTarget1 = distanceBetween(x,y,sceneTable.burgerMenu.budgetKnap.x,sceneTable.burgerMenu.budgetKnap.y)
            if mouseToTarget < sceneTable.burgerMenu.burgerKnap.radius and timer >= maxTimer then
                timer = 0
                sceneTxt = "Menu"
                scene = "mainMenu"
            elseif mouseToTarget1 < sceneTable.burgerMenu.budgetKnap.radius and timer >= maxTimer then
                timer = 0
                sceneTxt = "Budget Menu"
                scene = "budget"
            end
        end

        if scene == "budget" then
            mouseToTarget = distanceBetween(x,y,sceneTable.budget.burgerKnap.x,sceneTable.budget.burgerKnap.y)
            if mouseToTarget < sceneTable.budget.burgerKnap.radius and timer >= maxTimer then
                timer = 0
                sceneTxt = "Burger Menu"
                scene = "burgerMenu"
            end
        end


    end
end

function distanceBetween(x1,y1,x2,y2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end