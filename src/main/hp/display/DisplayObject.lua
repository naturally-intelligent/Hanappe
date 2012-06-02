local class = require("hp/lang/class")
local table = require("hp/lang/table")
local MOAIPropUtil = require("hp/util/MOAIPropUtil")

--------------------------------------------------------------------------------
-- 描画オブジェクトの基底クラスです.<br>
-- MOAIPropを拡張して、便利な関数を追加します.
-- @class table
-- @name DisplayObject
--------------------------------------------------------------------------------
local M = class(MOAIPropUtil)

M.MOAI_CLASS = MOAIProp

--------------------------------------------------------------------------------
-- コンストラクタです.
-- self.MOAI_CLASSのインスタンスを生成します.
--------------------------------------------------------------------------------
function M:new(...)
    local obj = self.MOAI_CLASS.new()
    table.copy(self, obj)

    if obj.init then
        obj:init(...)
    end

    obj.new = nil
    obj.init = nil
    
    return obj
end

--------------------------------------------------------------------------------
-- パラメータテーブルの値を元に、各setter関数の引数にセットしてコールします.
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.left then
        self:setLeft(params.left)
    end
    if params.top then
        self:setTop(params.top)
    end
    if params.layer then
        self:setLayer(params.layer)
    end
end

--------------------------------------------------------------------------------
-- レイヤーを設定します.
--------------------------------------------------------------------------------
function M:setLayer(layer)
    if self.layer == layer then
        return
    end

    if self.layer then
        self.layer:removeProp(self)
    end

    self.layer = layer

    if self.layer then
        layer:insertProp(self)
    end
end

--------------------------------------------------------------------------------
-- If the object will collide with the screen, it returns true.<br>
-- TODO:If you are rotating, it will not work.
-- @param object MOAIProp object
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestObject(prop)
    local worldX, worldY = prop:getWorldLoc()
    local x, y = prop:getLoc()
    local diffX, diffY = worldX - x, worldY - y

    local left, top = MOAIPropUtil.getLeft(prop) + diffX, MOAIPropUtil.getTop(prop) + diffY
    local right, bottom = MOAIPropUtil.getRight(prop) + diffX, MOAIPropUtil.getBottom(prop) + diffY
    
    if self:inside(left, top, 0) then
        return true
    end
    if self:inside(right, bottom, 0) then
        return true
    end
    if self:inside(left, bottom, 0) then
        return true
    end
    if self:inside(right, bottom, 0) then
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- If the object will collide with the screen, it returns true.<br>
-- @param screenX x of screen
-- @param screenY y of screen
-- @param screenZ (option)z of screen
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestScreen(screenX, screenY, screenZ)
    assert(self.layer)
    
    screenZ = screenZ or 0
    
    local worldX, worldY, worldZ = self.layer:wndToWorld(screenX, screenY, screenZ)
    return self:inside(worldX, worldY, worldZ)
end

--------------------------------------------------------------------------------
-- If the object will collide with the world, it returns true.<br>
-- @param worldX world x of layer
-- @param worldY world y of layer
-- @param worldZ (option)world z of layer
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestWorld(worldX, worldY, worldZ)
    worldZ = worldZ or 0
    return self:inside(worldX, worldY, worldZ)
end

return M