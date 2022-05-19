-- make sure path is in the lua search path
local path = "/opt/cartesi/share/lua/5.3/?.lua"
if not string.find(package.path, path, 1, true) then
    package.path = package.path .. ";" .. path
end
-- make sure cpath is in the c search path
local cpath = "/opt/cartesi/lib/lua/5.3/?.so"
if not string.find(package.cpath, cpath, 1, true) then
    package.cpath = package.cpath .. ";" .. cpath
end
