function love.load()
    love.window.setTitle("BLACKJACK")
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()

    gameState = 0
    dealerScore = 0
    playerScore = 0
    main_timer = 0

    step = love.audio.newSource("sounds/step.wav", "static")
    win = love.audio.newSource("sounds/ching.mp3", "static")
    bgrMusic = love.audio.newSource("sounds/bgrMusic.mp3", "static")
    bgrMusic:setLooping(true)
    bgrMusic:setVolume(.15)
    bgrMusic:play()

    font3 = love.graphics.newFont("abhaya-libre/AbhayaLibre-Bold.ttf", 15)

    intro = require("intro")
    intro.load()
    game = require("game")
    game.load()
    rules = require("rules")
    rules.load()
    credits = require("credits")
    credits.load()

end

function love.update(dt)
    main_timer = main_timer + dt
    if (gameState == 0) then
        intro.update(dt)
    elseif (gameState == 1) then
        game.update(dt)
    elseif (gameState == 2) then
        rules.update(dt)
    elseif (gameState == 3) then
        credits.update(dt)
    end
end

function love.mousepressed(mouse_x, mouse_y, num, touched, pressed)
    if (gameState == 0) then
        intro.mousepressed(mouse_x, mouse_y, num, touched, pressed)
    elseif (gameState == 1) then
        game.mousepressed(mouse_x, mouse_y, num, touched, pressed)
    elseif (gameState == 2) then
        rules.mousepressed(mouse_x, mouse_y, num, touched, pressed)
    elseif (gameState == 3) then
        credits.mousepressed(mouse_x, mouse_y, num, touched, pressed)
    end
end

function love.draw()
    local minutes = math.floor(main_timer / 60)
    local seconds = math.floor(main_timer % 60)
    love.graphics.print(string.format("%02d:%02d", minutes, seconds), W / 2 - 16, 10)
    if (gameState == 0) then
        intro.draw()
    elseif (gameState == 1) then
        game.draw()
    elseif (gameState == 2) then
        rules.draw()
    elseif (gameState == 3) then
        credits.draw()
    end
end

