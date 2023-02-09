local t = {}

function t.load()
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()
    love.window.setTitle("BLACKJACK")

    -- https://www.fontsquirrel.com/fonts/list/find_fonts?q%5Bterm%5D=&q%5Bsearch_check%5D=Y
    font2 = love.graphics.newFont("3dumb/3Dumb.ttf", 80)
    require("button_helper")
    t.start_button = helpers.makeButton(W / 2 - 50, H / 2 - 30, 100, 50, 16.5, "START")
    t.credits_button = helpers.makeButton(25, 550, 60, 30, 6, "CREDITS")

    bgr1 = love.graphics.newImage("images/introBgr.jpg")
    bgrW = bgr1:getWidth()
    bgrH = bgr1:getHeight()

    intro_timer = 0
    intro_alpha = 1
    intro_time_to_run = 3.5
    intro_tmp_bool = 1

end

function t.update(dt)
    intro_timer = intro_timer + dt

    if intro_tmp_bool == 1 then
        intro_alpha = intro_alpha - ((1 / intro_time_to_run) * dt)
        if intro_alpha <= 0 then
            intro_tmp_bool = 0
            intro_alpha = .02
        end
    end
    if intro_tmp_bool == 0 then
        intro_alpha = intro_alpha + ((1 / intro_time_to_run) * dt)
        if intro_alpha >= 1 then
            intro_tmp_bool = 1
            intro_alpha = 1
        end
    end
end

function t.mousepressed(mouse_x, mouse_y, num, touched, pressed) -- function to detect when a mouse is pressed
    if (mouse_x > t.start_button.x and mouse_x < (t.start_button.x + t.start_button.w)) and
        (mouse_y > t.start_button.y and mouse_y < (t.start_button.y + t.start_button.h)) then
        gameState = 1
        step:play()
    elseif (mouse_x > t.credits_button.x and mouse_x < (t.credits_button.x + t.credits_button.w)) and
        (mouse_y > t.credits_button.y and mouse_y < (t.credits_button.y + t.credits_button.h)) then
        gameState = 3
        step:play()
    end
end

function t.draw()
    love.graphics.draw(bgr1, W / bgrW - 250, H / bgrH, 0, .6, .56)
    love.graphics.setFont(font2)
    love.graphics.setColor(0, 0, 0, intro_alpha)
    love.graphics.print("BLACKJACK", W / 6 + 10, H / 5)
    love.graphics.setFont(font3)
    t.credits_button.draw()
    t.start_button.draw()
    love.graphics.setColor(1, 1, 1)
end

return t

