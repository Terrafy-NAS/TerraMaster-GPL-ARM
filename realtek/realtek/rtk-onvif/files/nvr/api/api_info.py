from nvr_root import *
from nvr_system import *

# ------------------------------------------------------------------------
# Infomation
#--------------------------------------------------------------------------
class API_INFO(NVR_Root):
    def __init__(self):
        name = 'api_info'
        path = '/api/info/<param:re:(|platform|model|fw|nvr)>'
        methods = ['GET']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class
    def genIPCAM_INFO():
        data = {}
        data['platform'] = '119x/129x'
        data['model'] = 'NVR'
        data['fw'] = '2016.08.05'
        data['nvr'] = 'v0.1'
        data['channel'] = N_WAY

    def get_info(self):
        data = {}
        if os.path.isfile(NVR_CONFIG):
            with open(NVR_CONFIG,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                except:
                    data['error'] = '%s is not json format' % (NVR_CONFIG)
        else:
            data = genIPCAM_LIST()
            with open(NVR_CONFIG,'w') as fp:
                json.dump(data, fp)#dump() for output file, not dumps
        return data

    # overridden methods (only valid for post/get/put/delete)
    def get(self, param):
        data = {}
        info = self.get_info()
        if param in info.keys():
            data[param] = info[param]
        else:
            data = info
        #  print json.dumps(data)
        return json.dumps(data)


# API registration
# --- Information ---
api_info = API_INFO()
api_registration(api_info)
