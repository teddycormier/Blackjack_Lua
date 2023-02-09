local t = {}

function t.load()
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()

    -- https://love2d.org/wiki/love.graphics.setFont
    require("button_helper")
    t.back_button = helpers.makeButton(725, 15, 60, 30, 6, "BACK")

    bgr4 = love.graphics.newImage("images/creditsBgr.jpg")
    bgr4W = bgr4:getWidth()
    bgr4H = bgr4:getHeight()

    credit_image = love.graphics.newImage("images/credits.png")
end

function t.update(dt)
end

function t.mousepressed(mouse_x, mouse_y, num, touched, pressed) -- function to detect when a mouse is pressed
    if (mouse_x > t.back_button.x and mouse_x < (t.back_button.x + t.back_button.w)) and
        (mouse_y > t.back_button.y and mouse_y < (t.back_button.y + t.back_button.h)) then
        gameState = 0
        step:play()
    end
end

function t.draw()
    love.graphics.draw(bgr4, W / bgr4W - 150, H / bgr4H, 0, .6, .65)
    love.graphics.draw(credit_image, W/3 - 10, H/4, 0, .2, .2)
    love.graphics.setColor(1,1,1)
    t.back_button.draw()
end

return t

