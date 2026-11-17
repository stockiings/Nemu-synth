--[[
This is a sound synthesis program for effects and music, writen
primarily in lua.

Logic will be made in lua. for now, actual sound generation will be
handled by python.

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

function synth(frequency, duration, sampling_rate)
    if duration == nil then duration = 1.5 end
    if sampling_rate= nil then sampling_rate = 44100 end
    local frames = duration * sampling_rate
    local times = linespace(0, duration, frames, false)
    local arr = {} -- math.cos(2*math.pi*frequency*linespace(0, duration, frames))
                   -- apparently you cant  use cos on an array. :Sob:
                            
    for i = 1, #times do
        arr[i] = math.cos(2*math.pi*frequency*times[i])
    end
    
    return arr
end

keylist = '123456789quertyuioasdfgjklzxcvbnm,.'
local notes_file, err = io.open("noteslist.txt", "r") -- opens the noteslist text file
local file_contents = file:read("*a")
local note_list = []

for line in io.open(noteslist.txt", "r") do -- splits the text file into a list line by line
    note_list[#lines+1] = line
end

local keymod = '0-='
local notes = {} -- dictionary to store samples

-- alleyoop
return arr
