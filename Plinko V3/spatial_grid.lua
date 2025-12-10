----------------------------------------
-- Define the class and attributes
----------------------------------------

SpatialGrid = {
    cellSize = 50,      
    cells = {},       
    width = 0,
    height = 0
}

----------------------------------------
-- Define the class methods
----------------------------------------

function SpatialGrid.new(worldWidth, worldHeight, cellSize)
    local instance = setmetatable({}, SpatialGrid)
    SpatialGrid.__index = SpatialGrid
    
    instance.cellSize = cellSize
    instance.width = worldWidth
    instance.height = worldHeight
    instance.cells = {}
    
    return instance
end

function SpatialGrid:Insert(body)
    local cellX = math.floor(body.position.x / self.cellSize)
    local cellY = math.floor(body.position.y / self.cellSize)
    local key = cellX .. "," .. cellY
    
    if not self.cells[key] then
        self.cells[key] = {}
    end
    table.insert(self.cells[key], body)
end

function SpatialGrid:GetNearby(body)
    local cellX = math.floor(body.position.x / self.cellSize)
    local cellY = math.floor(body.position.y / self.cellSize)
    
    local nearby = {}
    -- check this cell and 8 neighbors
    for dx = -1, 1 do
        for dy = -1, 1 do
            local key = (cellX + dx) .. "," .. (cellY + dy)
            if self.cells[key] then
                for _, otherBody in ipairs(self.cells[key]) do
                    table.insert(nearby, otherBody)
                end
            end
        end
    end
    return nearby
end

function SpatialGrid:Clear()
    self.cells = {}
end