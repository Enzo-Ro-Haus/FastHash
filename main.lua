_G.love = require("love")
local boton = require("./Botones")
local logica = require("./Logica")



local botonera = {
   menu_state={}
  }
  
function love.mousepressed(x,y,button, istouch, presses)
  if button == 1 then
    for index in pairs(botonera.menu_state) do
      botonera.menu_state[index]:checkPressed(x, y)
    end
  end
end


local function hasheo(archivo)
  hashear_archivo(archivo)
end

local function copiar()
  
end

local function borrar()

end

local function salir()
  love.event.quit()
end

-- Carga la informacion que se carga al crearse la ventana
function love.load()
  love.graphics.setBackgroundColor(0.063, 0.051, 0.137)
  
  love.graphics.rectangle("line", 20, 20, 660, 300)
   love.graphics.setColor(0.792, 0.012, 0.278)
   
  botonera.menu_state.hashear = boton("Hashear", nil, nil, 70, 40)
  botonera.menu_state.copiar = boton("Copiar", nil, nil, 70, 40)
  botonera.menu_state.borrar = boton("Borrar", nil, nil, 70, 40)
  botonera.menu_state.salir = boton("Salir", love.event.quit, nil, 70, 40)
  
end

-- Carga aquelllo que se ejecuta/actializa cada 60fps
function love.update(dt) -- dt data time tiempo de un frame, entre este y el anterio
end

-- Modifica los assets que se ven en la pantalla
function love.draw()
  -- type, x, y, w, h-- R G B
  love.graphics.setColor(0.792, 0.012, 0.278)
  love.graphics.rectangle("line", 20, 20, 660, 300)
  
  botonera.menu_state.hashear:draw(20, 340, 10, 10)
  botonera.menu_state.copiar:draw(110, 340, 10, 10)
  botonera.menu_state.borrar:draw(200, 340, 10, 10)
  botonera.menu_state.salir:draw(610, 340, 10, 10)
  
end