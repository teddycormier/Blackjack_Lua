local t = {}

function t.load()
    game_timer = 0
    game_alpha = 1
    game_time_to_run = 1.3
    game_tmp_bool = 1

    -- table for uploaded images (# + card suit)
    cardImages = {}
    -- https://www.lua.org/pil/4.3.5.html
    for i, cardID in ipairs({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, "mini_heart", "mini_diamond", "mini_club",
                             "mini_spade", "card1", "card2", "card_face_down", "face_jack", "face_queen", "face_king"}) do
        cardImages[cardID] = love.graphics.newImage("images/" .. cardID .. ".png")
    end

    if playerWon == true then
        playerScore = playerScore + 1
    elseif dealerWon == true then
        dealerScore = dealerScore + 1
    end

    playerWon = false
    dealerWon = false

    W = love.graphics.getWidth()
    H = love.graphics.getHeight()

    require("button_helper")
    love.graphics.setColor(0, 0, 0)
    t.back_button = helpers.makeButton(15, 15, 60, 30, 6, "BACK")
    t.rules_button = helpers.makeButton(725, 15, 60, 30, 6, "RULES")
    t.stand_button = helpers.makeButton(700, 246, 60, 30, 6, "STAND")
    t.hit_button = helpers.makeButton(700, 289, 60, 30, 6, "HIT")
    t.dealers_score = helpers.makeButton(700, 120, 60, 60, 10, "LOSSES")
    t.players_score = helpers.makeButton(700, 395, 60, 60, 10, "WINS")
    t.background_for_dealers_total = helpers.makeButton(40, 60, 118, 22, 11, "")
    t.background_for_players_total = helpers.makeButton(40, 350, 118, 22, 11, "")

    eofRound = false

    function handTotal(hand)
        local total = 0
        local player_has_ace = false

        -- https://www.lua.org/pil/4.3.5.html
        for i, card in ipairs(hand) do
            if card.value > 10 then
                total = total + 10
            else
                total = total + card.value
            end

            if card.value == 1 then
                player_has_ace = true
            end
        end

        if player_has_ace and total <= 11 then
            total = total + 10
        end

        return total
    end

    -- make deck table
    deck = {}
    -- take all combinations of each suit and each value - insert them into the table
    -- https://www.lua.org/pil/4.3.5.html
    for i, suit in ipairs({"club", "diamond", "heart", "spade"}) do
        for value = 1, 13 do
            table.insert(deck, {
                suit = suit,
                value = value
            })
        end
    end

    function drawCard(hand)
        table.insert(hand, table.remove(deck, love.math.random(#deck)))
    end

    -- add two generated cards to the player hand at random - remove them from the deck
    playerHand = {}
    drawCard(playerHand)
    drawCard(playerHand)

    -- add two generated cards to the dealers hand at random - remove them from the deck
    dealerHand = {}
    drawCard(dealerHand)
    drawCard(dealerHand)

    bgr2 = love.graphics.newImage("images/bgr2.jpg")
    bgr2W = bgr2:getWidth()
    bgr2H = bgr2:getHeight()

    number = love.math.random(1, 2)

end

function t.update(dt)
    game_timer = game_timer + dt

    if game_tmp_bool == 1 then
        game_alpha = game_alpha - ((1 / game_time_to_run) * dt)
        if game_alpha <= 0 then
            game_tmp_bool = 0
            game_alpha = .02
        end
    end
    if game_tmp_bool == 0 then
        game_alpha = game_alpha + ((1 / game_time_to_run) * dt)
        if game_alpha >= 1 then
            game_tmp_bool = 1
            game_alpha = 1
        end
    end
end

function t.mousepressed(mouse_x, mouse_y, num, touched, pressed)
    if (mouse_x > t.rules_button.x and mouse_x < (t.rules_button.x + t.rules_button.w)) and
        (mouse_y > t.rules_button.y and mouse_y < (t.rules_button.y + t.rules_button.h)) then
        gameState = 2
        step:play()
    end
    if (mouse_x > t.back_button.x and mouse_x < (t.back_button.x + t.back_button.w)) and
        (mouse_y > t.back_button.y and mouse_y < (t.back_button.y + t.back_button.h)) then
        gameState = 0
        step:play()
    end
    if not eofRound then
        if (mouse_x > t.hit_button.x and mouse_x < (t.hit_button.x + t.hit_button.w)) and
            (mouse_y > t.hit_button.y and mouse_y < (t.hit_button.y + t.hit_button.h)) then
            step:play()
            drawCard(playerHand)
            if handTotal(playerHand) >= 21 then
                eofRound = true
            end
        elseif (mouse_x > t.stand_button.x and mouse_x < (t.stand_button.x + t.stand_button.w)) and
            (mouse_y > t.stand_button.y and mouse_y < (t.stand_button.y + t.stand_button.h)) then
            step:play()
            eofRound = true
        end
        if eofRound then
            while handTotal(dealerHand) < 17 do
                drawCard(dealerHand)
            end
            win:play()
        end
    else
        t.load()
    end
end

function t.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(bgr2, W / bgr2W, H / bgr2H, 0, .6, .56)
    t.dealers_score.draw()
    love.graphics.print(dealerScore, 725.5, 150)
    t.players_score.draw()
    love.graphics.print(playerScore, 727.5, 425)

    local function drawCard(card, x, y)
        local cardWidth = 100
        local cardHeight = 140

        love.graphics.setColor(1, 1, 1)
        if (number == 1) then
            love.graphics.draw(cardImages.card1, x, y, 0, 1, 1)
        else
            love.graphics.draw(cardImages.card2, x, y, 0, 1, 1)
        end

        if card.suit == "heart" or card.suit == "diamond" then
            love.graphics.setColor(.89, .06, .39)
        else
            love.graphics.setColor(.2, .2, .2)
        end

        -- draw the # and suit in the top let and bittom right of the card
        local function drawCorner(image, offsetX, offsetY)
            love.graphics.draw(image, x + offsetX, y + offsetY)
            -- https://love2d.org/wiki/love.graphics.draw [offset axis for upsidedown]
            love.graphics.draw(image, x + cardWidth - offsetX, y + cardHeight - offsetY, 0, -1)
        end

        drawCorner(cardImages[card.value], 5, 5)
        drawCorner(cardImages["mini_" .. card.suit], 5, 15)

        if card.value > 10 then
            local jackFace
            local queenFace
            local kingFace

            love.graphics.setColor(1, 1, 1)

            if card.value == 11 then
                jackFace = cardImages.face_jack
                love.graphics.draw(jackFace, x + 15.5, y + 15, 0, .16, .15)
            elseif card.value == 12 then
                queenFace = cardImages.face_queen
                love.graphics.draw(queenFace, x + 15.5, y + 14, 0, .175, .165)
            elseif card.value == 13 then
                kingFace = cardImages.face_king
                love.graphics.draw(kingFace, x + 15.5, y + 14.5, 0, .18, .17)
            end
        end
    end

    local cardSpacing = 120
    local marginX = 40

    for i, card in ipairs(dealerHand) do
        local dealerMarginY = 90;
        if not eofRound and i == 1 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(cardImages.card_face_down, marginX, dealerMarginY, 0, 1.95, 1.95)
        else
            drawCard(card, ((i - 1) * cardSpacing) + marginX, dealerMarginY)
        end
    end

    for i, card in ipairs(playerHand) do
        drawCard(card, ((i - 1) * cardSpacing) + marginX, 380)
    end

    t.background_for_dealers_total.draw()
    t.background_for_players_total.draw()
    love.graphics.setColor(1, 1, 1)

    if eofRound then
        love.graphics.print("Dealer Total ~ " .. handTotal(dealerHand), marginX + 5, 62)
    else
        love.graphics.print("Dealer Total ~ ?", marginX + 5, 62)
    end

    love.graphics.print("Player Total ~ " .. handTotal(playerHand), marginX + 5, 352)

    if eofRound then
        love.graphics.setColor(1, 1, 1, game_alpha)

        love.graphics.print("PRESS ANYWHERE ON THE SCREEN TO CONTINUE", W / 3 - 30, H / 2 - 25)

        if playerHand == 21 then
            love.graphics.print("PLAYER HIT BLACKJACK.", W / 3 + 33, H / 2 + 5)
            playerWon = true
        elseif handTotal(dealerHand) > 21 and handTotal(playerHand) <= 21 then
            love.graphics.print("DEALER BUSTED.", W / 3 + 75, H / 2 + 5)
            playerWon = true
        elseif handTotal(playerHand) > 21 and handTotal(dealerHand) <= 21 then
            love.graphics.print("PLAYER BUSTED.", W / 3 + 75, H / 2 + 5)
            dealerWon = true
        elseif handTotal(playerHand) <= 21 and handTotal(dealerHand) <= 21 and handTotal(playerHand) >
            handTotal(dealerHand) then
            love.graphics.print("PLAYER HAD A HIGHER TOTAL.", W / 3 + 27, H / 2 + 5)
            playerWon = true
        elseif handTotal(dealerHand) <= 21 and handTotal(playerHand) <= 21 and handTotal(dealerHand) >
            handTotal(playerHand) then
            love.graphics.print("DEALER HAD A HIGHER TOTAL.", W / 3 + 27, H / 2 + 5)
            dealerWon = true
        elseif handTotal(playerHand) > 21 and handTotal(dealerHand) > 21 then
            love.graphics.print("BOTH HANDS BUSTED.", W / 3 + 45, H / 2 + 5)
        elseif handTotal(playerHand) == handTotal(dealerHand) then
            love.graphics.print("DRAW.", W / 3 + 100, H / 2)
        end
    end

    love.graphics.setColor(1, 1, 1)
    t.back_button.draw()
    t.rules_button.draw()
    t.stand_button.draw()
    t.hit_button.draw()
end

return t

