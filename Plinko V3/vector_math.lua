----------------------------------------
-- Define the class attributes
----------------------------------------

VectorMath = {}

----------------------------------------
-- Define the class methods
----------------------------------------

function VectorMath.Length(vec)
    return math.sqrt(vec.x * vec.x + vec.y * vec.y)
end

function VectorMath.Distance(a, b)
    local dx = b.x - a.x
    local dy = b.y - a.y

    return math.sqrt(dx * dx + dy * dy)
end

function VectorMath.Normalize(vec)
    local len = VectorMath.Length(vec)
    if len == 0 or len ~= len then -- guard NaN
        return Vector2D.new(0,0)
    end
    return Vector2D.new(vec.x / len, vec.y / len)
end

function VectorMath.Dot(a, b)
    return (a.x * b.x) + (a.y * b.y)
end

----------------------------------------
-- Define the class constructor
----------------------------------------

function VectorMath.new()
    local instance =  setmetatable({}, VectorMath)
    VectorMath.__index = VectorMath
    return  instance
end