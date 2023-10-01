-- Creates a __type metamethod.  __type metamethod should return a string that represents the type of the table the metatable is assigned to.

if true then

   local temp = type

   function type(ob)

      if getmetatable(ob) == nil or getmetatable(ob).__type == nil then

         return temp(ob)

      end

      return getmetatable(ob).__type(ob)

   end

end



function math.dot(v1,v2)

   local sum = 0

   local min = v1

   local max = v2

   if #v1 > #v2 then

      min = v2

      max = v1

   end

   for i,c in pairs(min) do

      sum = sum + c*max[i]

   end

   return sum

end



math.vector = {}

math.vectormt = {

   __call = function(t,comps)

      comps = comps and comps or {}

      local inner = 0

      local inner2 = 0

      local len = 0

      for i,v in pairs(comps) do

         inner = inner + v^2

         inner2 = inner2 + v

         len = len + 1

      end



      local tab = {

         _components = comps,

         _properties = {

            mag = inner^0.5,

            smag = inner2,

            len = len,

         }

      }

      while type(tab._properties.mag) == "vector" do

         tab._properties.mag = tab._properties.mag.mag

         tab._properties.smag = tab._properties.smag.smag

      end

      setmetatable(tab,math.vectormt)

      return tab

   end,



   __tostring = function(t)

      if #t == 0 then

         return "<>"

      end

      local s = "<"

      for i, c in pairs(t) do

         s = s..tostring(c)..","

      end

      s = s:sub(1,#s-1)..">"

      return s

   end,



   __type = function(t)

      return "vector"

   end,



   __len = function(t)

      --return #t._components

      return t._properties.len

   end,







   __newindex = function(t,i,v)

      t._components[i] = v

      local inner = 0

      local inner2 = 0

      local len = 0

      for i,v in pairs(t._components) do

         inner = inner + v^2

         inner2 = inner2 + v

         len = len + 1

      end

      t._properties.mag = math.sqrt(inner)

      t._properties.smag = inner2

      t._properties.len = len

   end,



   __index = function(t,i)

      if t._properties[i] ~= nil then

         return t._properties[i]

      end

      if i == "mag" or i == "magnitude" then

         return t._properties.mag

      elseif i == "smag" or i == "scalarMagnitude" then

         return t._properties.smag

      elseif i == "unit" then

         return t/t.mag

      elseif i == "table" then

         return t._components

      end

      if t._components[i] == nil then

         return 0

      end

      return t._components[i]

   end,



   __pairs = function(t)

      return pairs(t._components)

   end,



   __ipairs = function(t)

      return ipairs(t._components)

   end,







   __unm = function(t)

      local negv = math.vector()

      for i,c in pairs(t) do

         negv[i] = -c

      end

      return negv

   end,



   __add = function(v1,v2)

      if type(v1)..type(v2) == "vectorvector" then

         local sumv = math.vector()

         for i,c in pairs(v1) do

            sumv[i] = c+v2[i]

         end

         for i,c in pairs(v2) do

            if sumv[i] == 0 then

               sumv[i] = v1[i]+c

            end

         end

         return sumv

      elseif v1 == 0 then

         return v2

      elseif v2 == 0 then

         return v1

      end

   end,



   __sub = function(v1,v2)

      return v1+(-v2)

   end,



   __eq = function(v1,v2)

      --Think if this checks all cases

      if #v1 ~= #v2 or v1.mag ~= v2.mag then

         return false

      end

      for i,c in pairs(v1) do

         if c ~= v2[i] then

            return false

         end

      end

      return true

   end,



   __mul = function(q1,q2)

      --Make Mathematical conversion class

      local function types(typ)

         return typ=="number" and 0 or typ=="vector" and 1 or -1

      end

      if types(type(q1))+types(type(q2)) < 1 then

         print(type(q2))

         return nil

      end



      local scaledv = math.vector()

      if type(q1) == "number" then

         for i,v in pairs(q2) do

            scaledv[i] = v*q1

         end

      elseif type(q2) == "number" then

         for i,v in pairs(q1) do

            scaledv[i] = v*q2

         end

      else

         --Vector multiplication

         --scaledv = math.dot(q1,q2)

         for i,v in pairs(q1) do

            scaledv[i] = v*q2[i]

         end

      end

      return scaledv

   end,



   __pow = function(t,n)

      local result = math.vector()

      for i,v in pairs(t) do

         result[i] = v^n

      end

      return result

   end,



   __div = function(q1,q2)

      if type(q1) == "number" then

         local result = math.vector()

         for i,v in pairs(q2) do

            result[i] = q1/v

         end

         return result

      end

      return q1*(1/q2)

   end,

}

setmetatable(math.vector,math.vectormt)
