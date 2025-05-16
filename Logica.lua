-- Logic.lua - Módulo experto en Lua 5.4 para hasheo y gestión de archivos
package.path = package.path .. ";./lua_modules/?.lua"
local sha = require("sha2")

-- Tabla que agrupa todas las funciones de lógica
local Logica = {}

-- Abre un archivo en modo binario y devuelve el handle
function Logica:abrir_archivo(ruta)
    local archivo, err = io.open(ruta, "rb")
    assert(archivo, "No se puede leer el archivo: " .. tostring(err))
    return archivo
end

-- Obtiene el nombre base (sin extensión) de una ruta
function Logica:obtener_nombre(ruta)
    local nombre = ruta:match("([^/\\]+)%%.%\w+$") or "archivo_desconocido"
    return nombre
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

-- Escribe los resultados de hash en el archivo y cierra el handle
function Logica:editar_archivo(handle, nombre_original, digests, output_path)
    handle:write("Archivo original: ", nombre_original, "\n")
    handle:write("MD5: ",        digests.md5,  "\n")
    handle:write("SHA2-256: ",   digests.sha2, "\n")
    handle:write("SHA3-256: ",   digests.sha3)
    handle:close()
    print("Archivo de resumen creado en: " .. output_path)
end

-- Función principal: orquesta el proceso completo de hasheo y guardado
function Logica:hashear_archivo(ruta)
    -- Abrir y procesar el archivo
    local archivo = self:abrir_archivo(ruta)
    local nombre_base = self:obtener_nombre(ruta)

    local hasher2  = sha.sha256()
    local hasher3  = sha.sha3_256()
    local hasherMD5 = sha.md5()
    for chunk in function() return archivo:read(4096) end do
        hasher2(chunk)
        hasher3(chunk)
        hasherMD5(chunk)
    end
    archivo:close()

    -- Obtener los valores hexadecimales
    local digests = {
        md5  = hasherMD5(),
        sha2 = hasher2(),
        sha3 = hasher3()
    }

    -- Generar nombre de salida y abrir archivo de resultados
    local nombre_output = self:nombre_nuevo(nombre_base)
    local escritorio     = self:ruta_escritorio()
    local handle, fullpath = self:crear_archivo(escritorio, nombre_output)

    -- Escribir y cerrar
    self:editar_archivo(handle, nombre_base, digests, fullpath)
end

return Logica

