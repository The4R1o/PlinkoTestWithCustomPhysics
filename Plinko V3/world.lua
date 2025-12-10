require("collisions")
require("spatial_grid")
----------------------------------------
-- Define the class attributes
----------------------------------------

World = {

    minBodySize = 0.01 * 0.01,
    maxBodySize = 64.0 * 64.0,

    minDensity = 0.5,
    maxDensity = 21.4,
    gravity = Vector2D.new(0, 981),
    spatialGrid = SpatialGrid.new(1000, 1000, 12),
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
    if _index < 1 or _index > #World.activeBodyList then 
        return nil
    end
    
    return World.activeBodyList[_index]
end
  
function World.ResolveCollision(_bodyA, _bodyB, _normal, _depth) -- Resolving the collisions between 2 bodies 
    -- relative velocity
    local _relativeVelocity = _bodyB.linearVelocity - _bodyA.linearVelocity

    -- if separating, no impulse
    if VectorMath.Dot(_relativeVelocity, _normal) > 0 then
        return
    end

    local invMassA = _bodyA.inversMass or 0
    local invMassB = _bodyB.inversMass or 0
    local invMassSum = invMassA + invMassB

    -- positional correction to prevent sinking (mass weighted)
    local percent = 0.8      -- usually 20-80%
    local slop = 0.01        -- penetration allowance
    local correctionDepth = math.max(_depth - slop, 0)
    if correctionDepth > 0 and invMassSum > 0 then
        local correction = _normal * (correctionDepth / invMassSum * percent)
        -- move bodies by inverse-mass fraction
        if not _bodyA.isStatic then
            _bodyA:Move(correction * (-invMassA))
        end
        if not _bodyB.isStatic then
            _bodyB:Move(correction * invMassB)
        end
    end

    -- impulse resolution
    local e = math.min(_bodyA.restitution or 0, _bodyB.restitution or 0)
    local j = - (1 + e) * VectorMath.Dot(_relativeVelocity, _normal)

    if invMassSum == 0 then
        return
    end

    j = j / invMassSum
    local impulse = _normal * j

    if not _bodyA.isStatic then
        _bodyA.linearVelocity = _bodyA.linearVelocity - impulse * invMassA
    end
    if not _bodyB.isStatic then
        _bodyB.linearVelocity = _bodyB.linearVelocity + impulse * invMassB
    end
end

function World.Step(stepTime, iterations)

    if iterations <= 0 then iterations = 1 end
    local subStep = stepTime / iterations

    for it = 1, iterations do
        -- Physics Step --
        for i = 1, #World.activeBodyList do
            World.activeBodyList[i]:Step(subStep, World.gravity)
        end

        -- -- Collision Step, Naive or Brute Force approach --                                       
        -- for i = 1, #World.activeBodyList - 1 do

        --     local bodyA = World.activeBodyList[i]

        --     for j= i + 1, #World.activeBodyList do

        --         local bodyB = World.activeBodyList[j]

        --         if not  (bodyA.isStatic and bodyB.isStatic) then
        --             collBool, normal, depth = Collisions.IntersectCircles(bodyA.position, bodyA.radius, bodyB.position, bodyB.radius)

        --             if collBool then
        --                 World.ResolveCollision(bodyA, bodyB, normal, depth)
        --             end
        --         end
        --     end
        -- end

        World.spatialGrid:Clear()
        for i = 1, #World.activeBodyList do
            World.spatialGrid:Insert(World.activeBodyList[i])
        end

        for i = 1, #World.activeBodyList do
            local bodyA = World.activeBodyList[i]
            local nearby = World.spatialGrid:GetNearby(bodyA)
            
            for _, bodyB in ipairs(nearby) do
                if bodyA ~= bodyB then
                    collBool, normal, depth = Collisions.IntersectCircles(bodyA.position, bodyA.radius, bodyB.position, bodyB.radius)
                    if collBool then
                        World.ResolveCollision(bodyA, bodyB, normal, depth)
                    end
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
