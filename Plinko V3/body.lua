require("aabb")

----------------------------------------
-- Define the class attributes
----------------------------------------
Body = {

    position = Vector2D.new(0,0),
    mass = 0,
    inversMass = 0,
    density = 0,
    restitution = 0,
    area = 0,
    isStatic = false,
    radius = 10,

    force = Vector2D.new(0,0),
    linearVelocity = Vector2D.new(0,0),

    aabb = AABB.new(0,0,0,0)
}

----------------------------------------
-- Define the class methods
----------------------------------------

function Body:CreateCircle(_radius, _position, _density, _restitution, _isStatic)

    local _area = _radius * _radius * math.pi
    if _area > World.maxBodySize then
        debug.error("Area is to big!")
        return nil
    end
    if _area < World.minBodySize then
        debug.error("Area is too small!")
        return nil
    end

    if _density < World.minDensity then
        debug.error("Density is to small!")
        return nil
    end

    if _density > World.maxDensity then
        debug.error("Density is to big!")
        return nil
    end
    
    local _body = Body.new(_position, _radius, _isStatic,_density, _restitution)

    _body.mass = _area * _density

    if not _isStatic then
        self.inversMass = 1 / self.mass

    else
        self.inversMass = 0
    end


    return _body
end

function Body:Move( _amount )
    self.position = self.position + _amount
end

-- USED FOR INITIAL TESTING OF BODY COLLISIONS --
-- function Body:AddForce( _vector )
--      self.force = _vector
-- end


function Body:GetAABB()                         -- Calculating AABB of circles

    local minX = self.position.x - self.radius
    local minY = self.position.y - self.radius
    local maxX = self.position.x + self.radius
    local maxY = self.position.y + self.radius

    self.aabb = AABB.new(minX,minY,maxX,maxY)
    return self.aabb
end

function Body:Step( _time, _gravity)            -- Calculating body position and velocity in given frame (dt)

    if self.isStatic then 
        return 
    end

    self.linearVelocity = self.linearVelocity + _gravity * _time

    self.position = self.position + self.linearVelocity  * _time

end

----------------------------------------
-- Define the class constructor
----------------------------------------

function Body.new(position,radius, isStatic,density, restitution)

    local instance =  setmetatable({}, Body)
    Body.__index = Body

    instance.position = position
    instance.radius = radius
    instance.isStatic = isStatic
    instance.density = density
    instance.restitution = restitution
    
    return instance
end

----------------------------------------
-- Class Description 
----------------------------------------
-- This is the main physics body class (aka Rigidbody2D) it stores all the functionalities one body can have.
