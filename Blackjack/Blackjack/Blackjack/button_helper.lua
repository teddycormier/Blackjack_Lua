helpers = {}

function helpers.makeButton(x, y, w, h, textSpace, text, fn)
    local t = {}
    t.x = x
    t.y = y
    t.w = w
    t.h = h
    t.text = text
    t.onClickedFn = fn
    t.textSpace = textSpace

    function t.draw()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", t.x, t.y, t.w, t.h, 7)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(t.text, t.x, t.y + t.textSpace, t.w, "center")
    end

    return t
end
