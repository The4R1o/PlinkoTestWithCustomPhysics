----------------------------------------
-- Define the class attributes
----------------------------------------
AABB = {
    Max = Vector2D.new(0,0),
    Min = Vector2D.new(0,0)
}
----------------------------------------
-- Define the class methods
----------------------------------------
function AABB.new(minX, minY, maxX, maxY)

    local instance =  setmetatable({}, AABB)
    AABB.__index = AABB

    instance.Max = Vector2D.new(maxX, maxY)
    instance.Min = Vector2D.new(minX, minY)
    
    return  instance
end

----------------------------------------
-- Class Description 
----------------------------------------

-- Simple implementation of popular Axis Aligned Bounding Box
