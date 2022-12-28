import json

from config import NVR_HOME

import sys
sys.path.append(NVR_HOME + '/lib/onvif')
from onvif import ONVIFCamera

def ipcam_onvif_getprofiles(ip, port, user, passwd):
    # Get Profiles
    # print user
    # print passwd

    data = {}
    try :
        mycam = ONVIFCamera(ip, port, user, passwd, NVR_HOME+'/lib/onvif/wsdl/')
        media_service = mycam.create_media_service()
        profiles = mycam.media.GetProfiles()
        print "*******************"
        print profiles
        print "*******************"

        data['profiles'] = []
        for x in profiles:
            data['profiles'].append(x['Name'])
    except Exception as e:
        print str(e)
        data['error'] = str(e)

    return data #json.dumps(data)


def ipcam_onvif_getstreamuri(ip, port, user, passwd, profile):

    # Get StreamUri
    data = {}
    try :
        mycam = ONVIFCamera(ip, port, user, passwd, NVR_HOME+'/lib/onvif/wsdl/')
        media_service = mycam.create_media_service()
        #StreamUri = mycam.media.GetStreamUri("{'StreamSetup':{'Stream':'RTP-Unicast','Transport':{'Protocol':'UDP'}},'ProfileToken':'profile1'}")
        params = {} #"{'StreamSetup':{'Stream':'RTP-Unicast','Transport':{'Protocol':'UDP'}},'ProfileToken':'profile1'}"
        params['StreamSetup'] = {}
        params['StreamSetup']['Stream'] = 'RTP-Unicast'
        params['StreamSetup']['Transport'] = {}
        params['StreamSetup']['Transport']['Protocol'] = 'UDP'
        params['ProfileToken'] = profile #'profile1'
        StreamUri = mycam.media.GetStreamUri(params)
        data['streamuri'] = StreamUri.Uri
        print "My camera's Stream URI : %s" % (StreamUri.Uri)
    except Exception as e:
        print str(e)
        data['error'] = str(e)

    return data #json.dumps(data)


if __name__ == "__main__":

    mycam = ONVIFCamera('192.168.0.168', 80, 'admin', '123456', NVR_HOME+'/lib/onvif/wsdl/')

    # Get Hostname
    resp = mycam.devicemgmt.GetHostname()
    print 'My camera`s hostname: ' + str(resp.Name)

    # Get system date and time
    dt = mycam.devicemgmt.GetSystemDateAndTime()
    tz = dt.TimeZone
    year = dt.UTCDateTime.Date.Year
    hour = dt.UTCDateTime.Time.Hour
    minute = dt.UTCDateTime.Time.Minute
    second = dt.UTCDateTime.Time.Second
    print "My camera's date and time : %s %s %s:%s:%s" % (tz.TZ, year, hour, minute, second)

    # # Get Capabilities
    # cap = mycam.devicemgmt.GetCapabilities()
    # print "My camera's capability : %s " % (cap)


    # Get Users
    users = mycam.devicemgmt.GetUsers()
    print "My camera's users : %s " % (users)
    print

    media_service = mycam.create_media_service()
    # Get Profiles
    profiles = mycam.media.GetProfiles()
    #print "My camera's Profiles : %s \n" % (profiles)
    print "All profiles :"
    for x in profiles:
        #print x
        print x['Name']
    print

    # Get StreamUri
    #StreamUri = mycam.media.GetStreamUri("{'StreamSetup':{'Stream':'RTP-Unicast','Transport':{'Protocol':'UDP'}},'ProfileToken':'profile1'}")
    params = {} #"{'StreamSetup':{'Stream':'RTP-Unicast','Transport':{'Protocol':'UDP'}},'ProfileToken':'profile1'}"
    params['StreamSetup'] = {}
    params['StreamSetup']['Stream'] = 'RTP-Unicast'
    params['StreamSetup']['Transport'] = {}
    params['StreamSetup']['Transport']['Protocol'] = 'UDP'
    params['ProfileToken'] = 'profile1'
    StreamUri = mycam.media.GetStreamUri(params)
    print "My camera's Stream URI : %s" % (StreamUri.Uri)
