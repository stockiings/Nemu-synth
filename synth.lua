--[[
This is a sound synthesis program for effects and
music, writen primarily in lua.

Logic will be made in lua. for now, actual sound
generation/playback will be handled by python.

maybe eventually,sound generation will be handled 
by lua.

Wikepedia saved my life for the math behind
wave generation.

Author: Antigreentea/Stockiings
Date: 11/17/26
]]

-- Helper function written by google AI emulating Numpy's "Linespace" function
function linespace(start_value, stop_value, num, endpoint)
    -- default endpoint to true, matching numpys default behavior
    if endpoint == nil then endpoint = true end
    
    local result = {}
    if num <= 0 then return result end
    if num == 1 then
        result[1] = start_value
        return result
    end
    
    -- calculate the step size, based based on whether or not the endpoint is included
    local div = endpoint and (num-1) or num
    local step = (stop_value - start_value) / div
    
    for i = 0, num -1 do
       result[i+1] = start_value + (i*step) 
    end
    
    return result
end

-- sample rate: How many vaulues you need to define for a second of sound
local sampling_rate = 44100 -- default value for pygame mixer
local frequency = 440       -- [Hz]
local duration = 1.5        -- seconds


-- note types of waves: sin, square, triangle, sawtooth, noise.
-- wave inputs: 1 - sin, 2 - square, 3 - triangle, 4 - sawtooth, 5 - noise
-- base function for sin wave inspired from code by FunFET. Thanks for the tutorial.

-- square wave can be generated using floor function indirectly
-- through x(t) = (-1)^floor(2ft)
-- where t is time, f and f is frequency

-- sawtooth wave can be considered an extreme case of an asymetric triangle wave
-- sawtooth can be constructed using additive synthesis
-- 
function synth(wave, frequency, duration, sampling_rate)
    if duration == nil then duration = 1.5 end
    if sampling_rate == nil then sampling_rate = 44100 end
    if wave == nil then return end
    local frames = duration * sampling_rate
    local times = linespace(0, duration, frames, false)
    local arr = {} -- math.cos(2*math.pi*frequency*linespace(0, duration, frames))
                   -- apparently you cant  use cos on an array. :Sob:
                   
    if wave == 1 then           -- SIN
        for i = 1, #times do
            arr[i] = math.cos(2*math.pi*frequency*times[i])
        end
    elseif wave == 2 then      -- SQUARE
        for i = 1, #times do
            arr[i] = (-1)^math.floor(2*frequency*times[i])
        end
    elseif wave == 3 then      -- TRIANGLE (holy shit this math is asssss)
        for i = 1, #times do
            arr[i] = 2 * math.abs(2*(frequency * times[i] - math.floor(frequency*times[i] +0.5))) -1
        end
    elseif wave == 4  then      -- SAWTOOTH
        for i = 1, #times do
            arr[i] =  times - math.floor(times)
        end
    end
    
    return arr
end

arr = synth(2, 440, 1.5, sampling_rate)

-- alleyoop
if arr == nil then
    return 'Generation error. Arr is empty'
else
    return arr
end
