#!/usr/bin/env python

from config import NVR_HOME

import sys
sys.path.append(NVR_HOME+'/lib/WSDiscovery')
from WSDiscovery import *
    
import re
import json

def ipcam_ws_discovery():
    wsd = WSDiscovery()
    wsd.start()
#    result = wsd.searchServices(timeout=10)
    result = wsd.searchServices()
    wsd.stop()

    data = {}
    data['ip_list'] = []
    for service in result:
        for x in service.getXAddrs():
#        for x in ['https://1.1.1.1/onvif/', 'http://2.2.2.2/onvif/']:
            ip = re.findall("^http[s]{0,1}://(.*)/onvif/.*", x)
            if ip:
                data['ip_list'].append(ip[0])
    #print json.dumps(data)
    return data #json.dumps(data)    

if __name__ == "__main__":
    result = ipcam_ws_discovery() #find_onvif_ip_cam()
    print result
