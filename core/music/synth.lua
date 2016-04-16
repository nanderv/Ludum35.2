local synth = {}
function synth.triangle(freq)
    local phase = 0
    return function()
        phase = ((phase + 1/rate)*freq)%2-1
        return phase
    end
end
