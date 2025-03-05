----------------------------------------
-- Define the class attributes
----------------------------------------

Collisions = {}
Collisions.__index = Collisions


----------------------------------------
-- Define the class methods
----------------------------------------

function Collisions.IntersectCircles(centarA, radiusA, centarB, radiusB)

    local distance = VectorMath.Distance(centarA, centarB)
    local radii = radiusA + radiusB
    if distance >= radii then
        return false
    end

    local normal = VectorMath.Normalize(centarB - centarA)
    local depth = radii - distance

    return true, normal, depth
end

----------------------------------------
-- Class Description 
----------------------------------------

-- Class responsible for handeling math behind a collisions of given bodies 
