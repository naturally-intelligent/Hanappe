module(..., package.seeall)

local KEY_A = string.byte('a')
local KEY_S = string.byte('s')

function onCreate(params)
    scrollView = ScrollView()
    scrollView:setScene(scene)
    
    textLabel = TextLabel()
    text = ""
    for i = 1, 100 do
        text = text .. "message" .. i .. "\n"
    end
    textLabel:setString(test)
    textLabel:setSize(320, 100 * 24)
    scrollView:addChild(textLabel)
    
end

function onStart()
end

function onKeyDown(e)
end
