io.stdout:setvbuf('no') -- je sait plus ou gt mais problem de : mort, toute ligne, ca lague a Mort ;)
love.window.setMode(600,600)
Smode = 1
timer = 0 
plateau = {}
plateau.nbligne = 6
plateau.nbcolonne = 7
w = 600 / plateau.nbcolonne
h = 600 / plateau.nbligne
require("FuGrEtTa")

love.graphics.setNewFont(20)
plateau.peutOnPrint = nil
plateau.inanim = false
plateau.animCurrenty = 1
function plateau.anim()
  local mx = math.ceil(love.mouse.getX()/w)
  local ii = 0
 while plateau.table[mx][plateau.nbligne-ii] ~= 0 and ii < plateau.nbligne  do
    ii = ii + 1 
  end
  
  if ii < plateau.nbligne then
    
    if Smode == 1 then
      love.graphics.setColor(1,0,0)
    elseif Smode == 2 then
      love.graphics.setColor(1,1,0)
    end
    love.graphics.circle("fill",(mx-0.5)*w,(plateau.animCurrenty-0.5)*h,35,1000)

    if plateau.animCurrenty >= #plateau.table[1]-ii then 
      plateau.inanim = false 
      addJeton(mx)
      timer = 0 
      plateau.animCurrenty = 1
    end 
    
  end
end 
plateau.table = {}
function plateau.set()
  for i = 1,plateau.nbcolonne do
    plateau.table[i] = {}
    for j = 1,plateau.nbligne do
      plateau.table[i][j] = 0 
    end
  end
end

function plateau.show()
  for i = 1,plateau.nbcolonne do
    love.graphics.setColor(0,0,0.5)
    if math.ceil(love.mouse.getX()/w) == i then
      love.graphics.setColor(0,0,1)
    end
    love.graphics.rectangle("fill",(i-1)*w,0,w,love.graphics.getHeight())
    for j = 1,plateau.nbligne do
      love.graphics.setColor(1,1,1)
      love.graphics.rectangle("line",(i-1)*w,(j-1)*h,w,h)
      if plateau.table[i][j] == 0 then 
        love.graphics.setColor(1,1,1)
      elseif plateau.table[i][j] == 1 then
        love.graphics.setColor(1,0,0)
      elseif plateau.table[i][j] == 2 then
        love.graphics.setColor(1,1,0)
      end
      love.graphics.circle("fill",(i-0.5)*w,(j-0.5)*h,35,1000)
    end
  end 
end

sourie = {}
sourie.img = love.graphics.newImage("image/red.png")
sourie.w = sourie.img:getWidth()/2
sourie.h = sourie.img:getHeight()
sourie.quad = love.graphics.newQuad(sourie.w*0,0,sourie.w,sourie.h,sourie.img:getWidth(),sourie.img:getHeight())
function sourie.cimg()
  if Smode == 1 then
    sourie.img = love.graphics.newImage("image/red.png")
  elseif Smode == 2 then
    sourie.img = love.graphics.newImage("image/jaune.png")
  end
end
love.mouse.setVisible(false)


plateau.set()

function loose(plateau, nb)
  local laSinteListe = {}
  for i = 1, #plateau.table do
    for j = 1,#plateau.table[i]-nb+1 do
      for k = 1,nb do
        laSinteListe[#laSinteListe+1] = plateau.table[i][j+k-1]
      end 
      
      if laSinteListe[1] ==  1 and lineEgual(laSinteListe)  then
        return "rouge" 
      elseif laSinteListe[1] ==  2 and lineEgual(laSinteListe)  then
        return "jaune"
      end 
      laSinteListe = {}
    end 
  end 
  
  for i = 1, #plateau.table-nb+1 do
    for j = 1,#plateau.table[i] do
      for k = 1,nb do
        laSinteListe[#laSinteListe+1] = plateau.table[i+k-1][j]
      end 
      if laSinteListe[1] ==  1 and lineEgual(laSinteListe)  then
        return "rouge" 
      elseif laSinteListe[1] ==  2 and lineEgual(laSinteListe)  then
        return "jaune"
      end 
      laSinteListe = {}
    end 
  end 
  
  for i = 1, #plateau.table-nb+1 do
    for j = 1,#plateau.table[i]-nb+1 do
      for k = 1,nb do
        laSinteListe[#laSinteListe+1] = plateau.table[i+k-1][j+k-1]
      end 
      if laSinteListe[1] ==  1 and lineEgual(laSinteListe)  then
        return "rouge" 
      elseif laSinteListe[1] ==  2 and lineEgual(laSinteListe)  then
        return "jaune"
      end 
      laSinteListe = {}
    end 
  end 
  
  
  for i = nb, #plateau.table do
    for j = 1,#plateau.table[i]-nb+1 do
      for k = 0,nb-1 do
        laSinteListe[#laSinteListe+1] = plateau.table[i-k][j+k]
      end 
      if laSinteListe[1] ==  1 and lineEgual(laSinteListe)  then
        return "rouge" 
      elseif laSinteListe[1] ==  2 and lineEgual(laSinteListe)  then
        return "jaune"
      end 
      laSinteListe = {}
    end 
  end 
  
  local avalibleSpot = {}
  --print(tbprint(plateau))
  for i = 1, #plateau.table do
    --print("ok")
    for j = 1,#plateau.table[i] do
      if plateau.table[i][j] == 0 then
        avalibleSpot[#avalibleSpot+1] = {i,j}
      end
    end 
  end
  
  if #avalibleSpot == 0 then
    return "personne"
  end 
  
  
  return nil
end 

function love.update (dt)
  timer = timer + dt
  
--  if plateau.inanim and timer > 0.1 then 
--    plateau.animCurrenty = plateau.animCurrenty + 1
--    timer = 0 
--  end
end 

function love.draw()
  sourie.cimg()
  plateau.show()
--  if plateau.inanim then
  --plateau.anim()
--  end
  
  love.graphics.draw(sourie.img, sourie.quad,love.mouse.getX(),love.mouse.getY(),0,0.1,0.1,sourie.w/3,0)
  
  if type(plateau.peutOnPrint) ~= "nil" then
    love.graphics.setColor(1,0,1,1)
    love.graphics.print("et c'est une victoire pour ".. plateau.peutOnPrint.." !!!!!!", 10,30,0,1,1)
  end 
end



function love.mousepressed(x,y)
  local mx = math.ceil(x/w)
  --print (mx)
  --plateau.inanim = true
  addJeton(mx)
  if type(loose(plateau, 4)) ~= "nil" then
    plateau.peutOnPrint = loose(plateau, 4)
  end 
end

function addJeton(mx)
  local ii
  if Smode == 1 then
    ii = 0
    while plateau.table[mx][plateau.nbligne-ii] ~= 0 and ii < plateau.nbligne do
      ii = ii + 1 
      
    end
    plateau.table[mx][plateau.nbligne-ii] = 1 
    
    if ii < plateau.nbligne then
      Smode = 2
    end
  else 
    ii = 0
    while plateau.table[mx][plateau.nbligne-ii] ~= 0 and ii < plateau.nbligne  do
      ii = ii + 1 
    end
    plateau.table[mx][plateau.nbligne-ii] = 2
    
    if ii < plateau.nbligne then
      Smode = 1
    end
  end
end

function love.keypressed(key)
  if key == "r" then 
    Smode = 1
    plateau.table = {}
    plateau.set()
    plateau.peutOnPrint = nil
  end
end