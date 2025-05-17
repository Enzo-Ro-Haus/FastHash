local love = require "love"
local suit = require "suit"
local logica = require("./Logica")

local defaultPrompt = "--- ARRASTRE AQUI EL ARCHIVO/CARPETA QUE DESEE HASHEAR AUTOMATICAMENTE ---\n\nAviso: Los hash se mostrarán en pantalla y en un archivo txt en su Escritorio\n\nBotones:\n\n\t- Copiar: Copia los mensajes en el portapapeles.\n\n\t- Borrar: Borra los mensajes en pantalla.\n\n\t- Salir: Cierra el programa.\n\n\nHaseito by Enzo Rosso Hausberger"
local missingPrompt = "Debe ingresar un archivo o directorio"

local dropZone = {
    x = 20, y = 20, w = 660, h = 250,
    text= defaultPrompt
  }


-- Carga la informacion que se carga al crearse la ventana
function love.load()
  font = love.graphics.newFont(14)
  love.graphics.setFont(font)
  cwd = love.filesystem.getWorkingDirectory()
  
  love.graphics.setBackgroundColor(0.063, 0.051, 0.137)
  
end


function love.filedropped(file)
  local ruta = file:getFilename()
  dropZone.text = ruta
  
  if dropZone.text ~= defaultPrompt 
    and dropZone.text ~= missingPrompt
    and not string.find(dropZone.text:lower(), "\n") then
      local hasheos = logica:hashear_archivo(dropZone.text)
      dropZone.text = hasheos
    else
      dropZone.text = missingPrompt
    end
end

function love.directorydropped(path)
  dropZone.text = path
  
    if dropZone.text ~= defaultPrompt 
    and dropZone.text ~= missingPrompt
    and not string.find(dropZone.text:lower(), "\n") then
      local hasheos = logica:hashear_archivo(dropZone.text)
      dropZone.text = hasheos
    else
      dropZone.text = missingPrompt
    end
end


-- Carga aquelllo que se ejecuta/actializa cada 60fps
function love.update(dt) -- dt data time tiempo de un frame, entre este y el anterio
  suit.layout:reset(20, 280, 30, 50)
  
  local btn2 = suit.Button("Copiar", suit.layout:col(80, 30))
  local btn3 = suit.Button("Borrar", suit.layout:col(80, 30))
  
  local extraOffset = 325
  suit.layout:col(extraOffset, 0)
  local btn4 = suit.Button("Salir", suit.layout:col(80, 30))
  
  if btn2.hit then
    if dropZone.text ~= defaultPrompt and dropZone.text ~= missingPrompt then
      love.system.setClipboardText(dropZone.text)
       dropZone.text = "Texto copiado al portapapeles"
    else
      dropZone.text = missingPrompt
    end
  end
  
  if btn3.hit then
     dropZone.text = defaultPrompt
  end
  
  if btn4.hit then
    love.event.quit()
  end
  
  
end

-- Modifica los assets que se ven en la pantalla
function love.draw()
  -- type, x, y, w, h-- R G B
  --love.graphics.setColor(0.792, 0.012, 0.278)
  --love.graphics.rectangle("line", 20, 20, 660, 30)
  love.graphics.setColor(0.102, 0.047, 0.118)
  love.graphics.rectangle("fill", dropZone.x, dropZone.y, dropZone.w, dropZone.h)
  
  love.graphics.setColor(0.792, 0.012, 0.278)
  love.graphics.rectangle("line", dropZone.x, dropZone.y, dropZone.w, dropZone.h)

  local paddingX = 10
  local paddingY = 10

love.graphics.printf(
  dropZone.text,
  dropZone.x + paddingX,           -- un poco de espacio desde el borde izquierdo
  dropZone.y + paddingY,           -- un poco de espacio desde el borde superior
  dropZone.w - 2 * paddingX,       -- ancho ajustado por padding
  "left"
)
  suit.draw()
end