local t = {}

function t.load()
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()

    -- https://love2d.org/wiki/love.graphics.setFont

    require("button_helper")
    t.back_button = helpers.makeButton(725, 15, 60, 30, 6, "BACK")

    bgr3 = love.graphics.newImage("images/rulesBgr.jpg")
    bgr3W = bgr3:getWidth()
    bgr3H = bgr3:getHeight()
end

function t.update(dt)
end

function t.mousepressed(mouse_x, mouse_y, num, touched, pressed) -- function to detect when a mouse is pressed
    if (mouse_x > t.back_button.x and mouse_x < (t.back_button.x + t.back_button.w)) and
        (mouse_y > t.back_button.y and mouse_y < (t.back_button.y + t.back_button.h)) then
        gameState = 1
        step:play()
    end
end

function t.draw()
    love.graphics.draw(bgr3, W / bgr3W, H / bgr3H, 0, .6, .56)
    love.graphics.print(
        "BEAT THE DEALER BY: \n \n   - Drawing a hand value that is higher than the dealer’s hand value \n   - The dealer drawing a hand value that goes over 21. \n   - Drawing a hand value of 21 on your first two cards, when the \n     dealer does not. \n \n \n \n LOSE TO THE DEALER BY: \n \n   - Your hand value exceeds 21.\n   - The dealers hand has a greater value than yours at the end of \n     the round",
        W / 4, H / 4 + 20)

    t.back_button.draw()
end

return t

