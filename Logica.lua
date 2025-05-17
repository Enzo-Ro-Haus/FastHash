-- Logic.lua - Módulo experto en Lua 5.4 para hasheo y gestión de archivos
package.path = package.path .. ";./lua_modules/?.lua"
local sha = require("sha2")
local lfs = require("lfs")

-- Tabla que agrupa todas las funciones de lógica
local Logica = {}

-- Función interna: procesa un archivo abierto en modo binario
local function process_file(archivo, hasher2, hasher3, hasherMD5, hasher4)
    for chunk in function() return archivo:read(4096) end do
        hasher2(chunk)
        hasher3(chunk)
        hasherMD5(chunk)
        hasher4(chunk)
    end
    archivo:close()
end

-- Recorre recursivamente un directorio y alimenta los hashers
local function process_directory(path, hasher2, hasher3, hasherMD5, hasher4)
    for entry in lfs.dir(path) do
        if entry ~= "." and entry ~= ".." then
            local full = path .. "/" .. entry
            local attr = lfs.attributes(full)
            if attr and attr.mode == "file" then
                local f = io.open(full, "rb")
                assert(f, "No se puede leer el archivo: " .. full)
                process_file(f, hasher2, hasher3, hasherMD5, hasher4)
            elseif attr and attr.mode == "directory" then
                process_directory(full, hasher2, hasher3, hasherMD5, hasher4)
            end
        end
    end
end

-- Obtiene el nombre base (sin extensión) de una ruta (solo último componente)
function Logica:obtener_nombre(ruta)
    local nombre = ruta:match("([^/\\]+)$") or "entrada_desconocida"
    return nombre:gsub("%.%w+$", "")
end

-- Genera el nombre de salida con timestamp
function Logica:nombre_nuevo(nombre_base)
    local fecha = os.date("%Y-%m-%d-%H-%M-%S")
    return ("Hasheito_%s_%s.txt"):format(nombre_base, fecha)
end

-- Determina la ruta al Escritorio según el SO
function Logica:ruta_escritorio()
    local sep = package.config:sub(1,1)
    local is_windows = (sep == "\\")
    if is_windows then
        local home = os.getenv("USERPROFILE") or ((os.getenv("HOMEDRIVE") or "") .. (os.getenv("HOMEPATH") or ""))
        return home .. "\\Desktop\\"
    else
        local p = io.popen('xdg-user-dir DESKTOP 2>/dev/null')
        local path = p and p:read('*l') or nil
        if p then p:close() end
        if path and path ~= '' then
            return path .. "/"
        end
        return (os.getenv("XDG_DESKTOP_DIR") or os.getenv("HOME") .. "/Desktop") .. "/"
    end
end

-- Crea y devuelve un handle para el archivo de resultados, junto con la ruta completa
function Logica:crear_archivo(dir, nombre)
    local fullpath = dir .. nombre
    local f, err = io.open(fullpath, "w")
    assert(f, "No se pudo crear el archivo: " .. tostring(err))
    return f, fullpath
end

-- Función principal: orquesta el proceso completo de hasheo y guardado
function Logica:hashear_archivo(ruta)
    -- Inicializar los hashers
    local hasher2   = sha.sha256()
    local hasher3   = sha.sha3_256()
    local hasherMD5 = sha.md5()
    local blake3 = sha.blake3()

    -- Procesar según tipo de entrada
    local attr = lfs.attributes(ruta)
    if not attr then
        error("Ruta no encontrada: " .. ruta)
    end
    if attr.mode == "file" then
        local archivo = io.open(ruta, "rb")
        assert(archivo, "No se puede leer el archivo: " .. ruta)
        process_file(archivo, hasher2, hasher3, hasherMD5, blake3)
    elseif attr.mode == "directory" then
        process_directory(ruta, hasher2, hasher3, hasherMD5, blake3)
    else
        error("Tipo no soportado: " .. ruta)
    end

    -- Obtener los valores hexadecimales
    local digests = {
        md5  = hasherMD5(),
        sha2 = hasher2(),
        sha3 = hasher3(),
        bla3 = blake3()
    }

    -- Preparar archivo de salida
    local nombre_base = self:obtener_nombre(ruta)
    local nombre_output = self:nombre_nuevo(nombre_base)
    local escritorio     = self:ruta_escritorio()
    local handle, fullpath = self:crear_archivo(escritorio, nombre_output)

    -- Escribir resultados
    handle:write("Ruta: ", ruta, "\n")
    handle:write("MD5: ",        digests.md5,  "\n")
    handle:write("SHA2-256: ",   digests.sha2, "\n")
    handle:write("SHA3-256: ",   digests.sha3, "\n")
    handle:write("Blake3: ",   digests.bla3, "\n")
    handle:close()

    -- Retornar resumen
    return string.format(
        "Ruta original: %s\n\nMD5:\n%s\n\nSHA2-256:\n%s\n\nSHA3-256:\n%s\n\nBlake3:\n%s",
        ruta, digests.md5, digests.sha2, digests.sha3, digests.bla3
    )
end

return Logica


