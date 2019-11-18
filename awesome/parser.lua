
-- check if a file exists
function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end


function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    if inputstr == nil then return t; end
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function extract(line)
    local splitted = split(line, "=")
    if splitted[1] == nil or splitted[1] == nil then return nil end
    return splitted[1]:gsub("%s+", ""), splitted[2]:gsub("%s+", "")
end

function parse_file(file)
    local lines = {}
    for line in io.lines(file) do
        if not (line:sub(1,1) == "#") then
            line = split(line,"#")[1]
            local data, payload = extract(line)
            if not (data == nil) then
                lines[data] = payload
            end
        end
    end
    return lines
end

return function (file)
    if file_exists(file) then
     return parse_file(file)
    end
    return {}
end