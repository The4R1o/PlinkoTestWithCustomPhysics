require("collisions")
----------------------------------------
-- Define the class attributes
----------------------------------------

World = {

    minBodySize = 0.01 * 0.01,
    maxBodySize = 64.0 * 64.0,

    minDensity = 0.5,
    maxDensity = 21.4,

    gravity = Vector2D.new(0,3),

    activeBodyList = {},
}

----------------------------------------
-- Define the class methods
----------------------------------------

function World.AddBody(_body)                       -- Adding the body to  the list of all physics bodies
    table.insert(World.activeBodyList, _body) 
end

function  World.RemoveBody(_index)                  -- Removing the body from the list of all physics bodies
    table.remove(World.activeBodyList,_index)
end
  
function World:GetBody(_index)                      -- Adding the body to  the list of all physics bodies       
    if _index < 0 or _index > #World.activeBodyList then 
        return nil
    end
    
    return World.activeBodyList[_index]
end
  

function World.ResolveCollision(_bodyA, _bodyB, _normal, _depth) -- Resolving the collisions between 2 bodies 
    
    local _relativeVelocity = _bodyB.linearVelocity - _bodyA.linearVelocity

    --Objects are already moving apart so we don't need to resolve collisons any further
    if VectorMath.Dot(_relativeVelocity, _normal) > 0 then
        return
    end
    --[[ This formula was taken from the article  "http://www.chrishecker.com/Rigid_Body_Dynamics "]]
    local e = math.min(_bodyA.restitution, _bodyB.restitution)

    local j = - (1 + e) * VectorMath.Dot(_relativeVelocity, _normal)
    j = j / (_bodyA.inversMass + _bodyB.inversMass)
    
    local impulse = _normal * j 
    
    _bodyA.linearVelocity = _bodyA.linearVelocity - impulse * _bodyA.inversMass
    _bodyB.linearVelocity = _bodyB.linearVelocity + impulse * _bodyB.inversMass
end
  
  -- Iterations:
  -- How many sub checks should there be withing on dt call, reduces the performances increases precision of collisions  
function World.Step(stepTime, iterations)

    for it = 0, iterations do

        -- Physics Step --
        for i = 1, #World.activeBodyList do
        World.activeBodyList[i]:Step(stepTime, World.gravity)
        end

        -- Collision Step, Naive or Broute Force approach --                                       
        for i = 1, #World.activeBodyList - 1 do

            local bodyA = World.activeBodyList[i]

            for j= i + 1, #World.activeBodyList do

                local bodyB = World.activeBodyList[j]


                collBool, normal, depth = Collisions.IntersectCircles(bodyA.position, bodyA.radius, bodyB.position, bodyB.radius)

                if collBool then
                    if bodyA.isStatic then
                        bodyB:Move(normal * depth)
                    elseif bodyB.isStatic then
                        bodyA:Move(normal * depth *-1)  
                    else               
                        bodyA:Move(normal * depth * -0.5) 
                        bodyB:Move(normal * depth * 0.5)
                    end
    
                    World.ResolveCollision(bodyA, bodyB, normal, depth)
                end
                
            end
        end
    end
end

----------------------------------------
-- Define the class constructor
----------------------------------------

function World:new()
    local instance =  setmetatable({}, World)
    World.__index = World
    return  instance
end
----------------------------------------
-- Class Description 
----------------------------------------

-- Main class responsible for updating all physics bodies and their behavior in scene (position, collisons etc.)
