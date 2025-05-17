-- Configuracion de proyecto
function love.conf(t) -- variable que pasamos nosotros
  t.version = "11.5"
  t.console = true
  t.gammacorrect = true
 --t.indentity = donde se guardan los archivos de guardad
 t.window.title = "Hasheito"
 t.window.width = 700
 t.window.height = 320
 t.window.resizable = false
 t.window.borderless = false
end