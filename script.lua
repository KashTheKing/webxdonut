-- Spinning Donut by Andrew Li
-- Ported from donut.c - https://www.a1k0n.net/2011/07/20/donut-math.html

local ThetaSpacing = 0.07
local PhiSpacing = 0.02

local a, ba = 0, 0

local MainStr = {'.',',','-','~',':',';','=','!','*','#','$','@'}

local textLabel = get("donutTextArea")
local fpsInput = get("fpsInput")

local frameRate = (1/60)*1000
local fpsDebounce = false

local makeDonut

local function setFrameRate(input)
    frameRate = (1/input)*1000
end

fpsInput.on_input(function()
    if fpsDebounce then return end

    local content = fpsInput.get_content()
    
    local number = tonumber(content)

    if number ~= nil then
        local clamp = math.clamp(number, 1, 60)
        setFrameRate(clamp)
    else
        setFrameRate(60)
    end

    print("New framerate: ".. frameRate)
end)

local function renderDonut()
    local z = {}
    local b = {}

    for l = 1, 1760 do
        z[l] = 0
        b[l] = " "
    end

    local j = 0
    while j < 6.28 do
        j = j + ThetaSpacing
        local i = 0
        while i < 6.28 do
            i = i + PhiSpacing

            local c = math.sin(i)
            local l = math.cos(i)
            local d = math.cos(j)
            local f = math.sin(j)
            local e = math.sin(a)
            local g = math.cos(a)
            local h = d + 2
            local D = 1 / (c * h * e + f * g + 5)
            local m = math.cos(ba)
            local n = math.sin(ba)
            local t = c * h * g - f * e

            local x = math.floor(40 + 30 * D * (l * h * m - t * n))
            local y = math.floor(12 + 15 * D * (l * h * n + t * m))
            local o = x + 80 * y
            local N = math.floor(8 * ((f * e - c * d * g) * m - c * d * e - f * g - l * d * n))

            if 22 > y and y > 0 and 80 > x and x > 0 and D > z[o + 1] then
                z[o + 1] = D
                b[o + 1] = N > 0 and MainStr[N + 1] or "."
            end
        end
    end

    local output = ""
    for l = 1, 1760 do
        output = output .. b[l]
        if l % 80 == 0 then
            output = output .. "\n"
        end
    end
    textLabel.set_content("\n\n\n\n"..output.."\n\n\n\n")
end

function makeDonut()
    renderDonut()
    a = a + 0.04
    ba = ba + 0.02

    set_timeout(makeDonut, frameRate)
end

makeDonut()