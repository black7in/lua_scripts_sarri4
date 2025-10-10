function formatString(str, ...)
    local args = {...}
    local i = 0
    local result = str:gsub("{}", function()
        i = i + 1
        return tostring(args[i] or "{}")
    end)
    return result
end
