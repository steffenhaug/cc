-- branch mining


-- CONFIG --
local depth = 16

function is_valuable(blockname)
   if blockname == "minecraft:iron_ore" or
      blockname == "minecraft:coal_ore" or
      blockname == "minecraft:gold_ore" or
      blockname == "minecraft:redstone_ore" or
      blockname == "minecraft:diamond_ore"
   then
      return true
   else 
      return false
   end
end


-- dig functions that deals with gravel dy
-- repeatedly calling turtle.dig() and friends
-- until it returns false.

function dig_persistently()
   while turtle.dig() do end
end

function dig_up_persistently()
   while turtle.digUp() do end
end

function dig_down_persistently()
   while turtle.dig() do end
end

function branch_step_forward()
   dig_persistently()
   turtle.forward()
   branch()
   turtle.back()
end

function branch_step_up()
   dig_up_persistently()
   turtle.up()
   branch()
   turtle.down()
end

function branch_step_down()
   dig_down_persistently()
   turtle.down()
   branch()
   turtle.up()
end

-- Core --
-- these functions comprise the core
-- of the algorithm. The strategy is
-- simple:
--
--   for every direction:
--     if the block in front is valuable:
--       break the block.
--       move in the direction.
--       call the algorithm. (Recursive step!)
--       move back.

function branch_forward()
   local succ, data = turtle.inspect()
   if is_valuable(data.name) then
      branch_step_forward()
   end
end

function branch_left()
   turtle.turnLeft()
   local succ, data = turtle.inspect()
   if is_valuable(data.name) then
      branch_step_forward()
   end
   turtle.turnRight()
end

function branch_right()
   turtle.turnRight()
   local succ, data = turtle.inspect()
   if is_valuable(data.name) then
      branch_step_forward()
   end
   turtle.turnLeft()
end

function branch_up()
   local succ, data = turtle.inspectUp()
   if is_valuable(data.name) then
      branch_step_up()
   end
end

function branch_down()
   local succ, data = turtle.inspectDown()
   if is_valuable(data.name) then
      branch_step_down()
   end
end

-- try to branch in all directions
function branch()
   branch_forward()
   branch_up()
   branch_down()
   branch_left()
   branch_right()
end

-- mine one branch
function mine_branch(length)
   -- dig a branch with the given length,
   -- and, for each step, call the
   -- recursive algorithm
   for i = 1, length do
      dig_persistently()
      turtle.forward()
      -- run the algorithm, minus forward,
      -- because we will move forward next
      -- iteration anyways.
      branch_up()
      branch_down()
      branch_left()
      branch_right()
   end
   -- turn around
   turtle.turnLeft()
   turtle.turnLeft()
   -- dig back (this is in case something
   -- stupid has happened, like someone
   -- placing a block in the way or whatever)
   for i = 1, length do
      dig_persistently()
      turtle.forward()
   end
end