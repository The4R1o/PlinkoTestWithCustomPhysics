----------------------------------------
-- Define the class and attributes
----------------------------------------

Vector2D = {}

----------------------------------------
-- Define the class methods
----------------------------------------

Vector2D.__add = function(v1,v2)
    return Vector2D.new(v1.x + v2.x, v1.y + v2.y)
end

Vector2D.__sub = function(v1,v2)
    return Vector2D.new(v1.x - v2.x, v1.y - v2.y)
end

Vector2D.__mul = function(v, s)
    return Vector2D.new(v.x * s, v.y * s)
end

Vector2D.__div = function(v1, s)
    return Vector2D.new(v1.x / s, v1.y / s)
end

Vector2D.__eq = function(v1, v2)
    return v1.x > v2.x and v1.y > v2.y
end

----------------------------------------
-- Define the class constructor
----------------------------------------

function Vector2D.new(_x, _y)

    local instance =  setmetatable({}, Vector2D)
    Vector2D.__index = Vector2D

    instance.x = _x
    instance.y = _y
    
    return  instance
end

----------------------------------------
-- Class Description 
----------------------------------------

 -- Class i made to easly make 2D Vectors and some of the basic operations between them
-- Wasn't sure if there was any similar class out there so i made my own.
   
