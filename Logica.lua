package.path = package.path .. ";./lua_modules/?.lua"
local sha = require("sha2")

-- Obtengo la ruta del archivo a leer
local ruta = arg[1]
local archivo, err = io.open(ruta, "rb")
if not archivo then error("No se puede leer el archivo" .. err)
end

-- Definimos el tamanio a leer
local tamanio_chunk = 4096

-- Llamamos a las funciones de nuestra libreria de hasheo
local hasher2 = sha.sha256()
local hasher3 = sha.sha3_256()
local hasherMD5 = sha.md5()

for parte in function() return archivo:read(tamanio_chunk)
end do
  hasher2(parte)
  hasher3(parte)
  hasherMD5(parte)
end

-- Cerramos el archivo
archivo:close()

local digest_hex5 = hasherMD5()
local digest_hex2 = hasher2()
local digest_hex3 = hasher3()

-- Creamos el nombre del archivo nuevo
local nombre = ruta:match("([^/\\]+)%.%w+$") or "archivo_desconocido"
local fecha = os.date("%Y-%m-%d-%H-%M")
local nombre_final = ("fasthash_%s_%s.txt"):format(nombre, fecha)

-- Determinamos el os y obtenemos la ruta al escritorio
local sep = package.config:sub(1,1)
local is_windows = (sep == "\\")
local desktop_path
if is_windows then
    -- Windows: usar USERPROFILE o HOMEDRIVE+HOMEPATH
    local home = os.getenv("USERPROFILE")
    if not home then
        home = (os.getenv("HOMEDRIVE") or "") .. (os.getenv("HOMEPATH") or "")
    end
    desktop_path = home .. "\\Desktop"
else
    -- Linux/Unix: primero intento xdg-user-dir
    local p = io.popen('xdg-user-dir DESKTOP 2>/dev/null')
    if p then
        desktop_path = p:read('*l')
        p:close()
    end
    -- Fallback a XDG_DESKTOP_DIR o $HOME/Desktop
    if not desktop_path or desktop_path == '' then
        desktop_path = os.getenv("XDG_DESKTOP_DIR") or (os.getenv("HOME") .. "/Desktop")
    end
end

-- Ruta final donde escribir el resultado
local ruta_resultado = desktop_path .. (is_windows and "\\" or "/")


-- Creamos el archivo con su nombre y en la ruta especificada
local resultado, err2 = io.open(ruta_resultado .. nombre_final, "w")
if not resultado then
    error("No se pudo crear el archivo: " .. err2)
end


-- Escribimos los retornos
resultado:write("Archivo original: ", nombre, "\n")
resultado:write("MD5: ", digest_hex5, "\n")
resultado:write("SHA2-256: ", digest_hex2, "\n")
resultado:write("SHA3-256: ", digest_hex3)

-- Cerramos el archivo
resultado:close()

print("Archivo de resumen creado en: " .. ruta_resultado .. nombre_final)