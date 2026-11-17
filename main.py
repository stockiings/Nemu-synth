import subprocess, sys

try:
    from lupa import LuaRuntime
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "lupa"])
    from lupa import LuaRuntime

import sys, pygame as pg, os
import numpy as np
import wave

os.environ['SDL_AUDIODRIVER'] = 'dummy'

pg.mixer.init(frequency=44100, size=-16, channels=2)

pg.init()

lua = LuaRuntime(unpack_returned_tuples=True)
with open("synth.lua", "r") as f:
    lua_arr = lua.execute(f.read()) # Slam dunk! (ideally)

# convert lua table to floats
np.array(list(lua_arr.values()))
float_arr = np.array(list(lua_arr.values()), dtype=np.float32)
sound = np.asarray([32767 * float_arr, 32767 * float_arr]).T.astype(np.int16)
sound = pg.sndarray.make_sound(sound.copy())

sound.play() # play the sound

'''
with wave.open("output.wav", "wb") as wav_file:
    wav_file.setnchannels(2)    # 2 channels (Stero)
    wav_file.setsampwidth(2)    # 2 bytes per sample, 16 bit
    wav_file.setframerate(44100)# same sample rate as  everywhere else.
    wav_file.writeframes(sound.getraw())
    wav_file.writeframes(sound.get_raw())
print("Sound creation finished")
'''
