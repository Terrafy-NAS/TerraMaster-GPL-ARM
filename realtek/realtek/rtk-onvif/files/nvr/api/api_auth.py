from nvr_root import * 
from nvr_system import *

# --------------------------------------------------------------------------
# Authentication (NOT Implement yet)
# --------------------------------------------------------------------------
class API_AUTH_PRELOGIN(NVR_Root):
    def __init__(self):
        name = 'api_auth_prelogin'
        path = '/api/auth/prelogin/'
        methods = ['GET']        
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self, param):
        data = {}
        data[sys._getframe().f_code.co_name] = 'NO Implement Yet'
        return json.dumps(data)    

class API_AUTH_LOGIN(NVR_Root):
    def __init__(self):
        name = 'api_auth_login'
        path = '/api/auth/login/'
        methods = ['POST']        
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def post(self, param):
        data = {}
        data[sys._getframe().f_code.co_name] = 'NO Implement Yet'
        return json.dumps(data)


class API_AUTH_LOGOUT(NVR_Root):
    def __init__(self):
        name = 'api_auth_logout'
        path = '/api/auth/logout/'
        methods = ['DELETE']        
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def delete(self, param):
        data = {}
        data[sys._getframe().f_code.co_name] = 'NO Implement Yet'
        return json.dumps(data)

    
# --- Authentication ---
api_auth_prelogin = API_AUTH_PRELOGIN()
api_registration(api_auth_prelogin)

api_auth_login = API_AUTH_LOGIN()
api_registration(api_auth_login)

api_auth_logout = API_AUTH_LOGOUT()
api_registration(api_auth_logout)

