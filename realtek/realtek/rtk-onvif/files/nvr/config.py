import sys
import json
sys.path.append('/usr/lib/python/site-packages')

NVR_HOME = '/usr/local/bin/nvr'
sys.path.append(NVR_HOME + '/lib')
sys.path.append(NVR_HOME + '/api')


NVR_CONFIG = '/etc/nvr/nvr.conf'
NVR_IPCAM_LIST = '/etc/nvr/ipcam_list.conf'
NVR_IPCAM_OUTPUT = '/etc/nvr/ipcam_output.conf'

N_WAY = 4 #default value
ONVIF_PORT = 80
STREAMING_PORT = 10000
RECORDING_SIZE = 60 # 1 minute #10*60 # 10 minutes
RECORDING_PATH = NVR_HOME + "/recording"
api_meta_array = []

# get the real channel in NVR_CONFIG
import os
if os.path.isfile(NVR_CONFIG):
    with open(NVR_CONFIG,'r') as fp:
        try:
            data = json.load(fp)#load(...) from input file, not loads()
            if 'channel' in data.keys():
                N_WAY = data['channel']
        except:
            pass

from nvr_system import *
from nvr_root import *

# MP Stage Job
# There should be channel, platform, model, fw, nvr defined in factory data.
# And also need code to extract the data shown above into NVR_CONFIG
