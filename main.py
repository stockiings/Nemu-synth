import subprocess, sys

try:
    from lupa import LuaRuntime
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "lupa"])
    from lupa import LuaRuntime

import sys, pygame as pg, os
import numpy as np
import wave


# os.environ['SDL_AUDIODRIVER'] = 'dummy'
os.environ['SDL_AUDIODRIVER'] = 'dsp'

def make_sound():
    pg.init()
    pg.mixer.init(frequency=44100, size=-16, channels=2)
    
    
    lua = LuaRuntime(unpack_returned_tuples=True)
    with open("synth.lua", "r") as f:
        lua_arr = lua.execute(f.read()) # Slam dunk! (ideally)
        
    if lua_arr == 'Generation error. Arr is empty':
        print(lua_arr)
        return
    
    # convert lua table to floats
    float_arr = np.array(list(lua_arr.values()), dtype=np.float32)
    sound_array = np.asarray([32767 * float_arr, 32767 * float_arr]).T.astype(np.int16)
    sound.play()
    option=0
    while True:
        option = int(input("Would you like to save this wave? (1) Yes | (2) No | (3) Play again:  "))
        if option == 1:
            file_name = input("Filename: ")
            with wave.open(str(file_name) + ".wav", "wb") as wav_file:
                wav_file.setnchannels(2)    # 2 channels (Stero)
                wav_file.setsampwidth(2)    # 2 bytes per sample, 16 bit
                wav_file.setframerate(44100)# same sample rate as  everywhere else.
                wav_file.writeframes(sound_array.tobytes())
            print("Sound creation finished")
            break
        elif option == 2:
            break
        elif option == 3:
            sound.play()
# ===================================================================
    
make_sound()
