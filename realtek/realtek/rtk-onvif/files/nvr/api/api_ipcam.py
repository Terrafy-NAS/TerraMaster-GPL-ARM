from nvr_root import *
from nvr_system import *

# --------------------------------------------------------------------------
# ONVIF IP Camera List Management
# --------------------------------------------------------------------------
#import sys
#sys.path.append(NVR_HOME+'/lib')
from ipcam_ws_discovery import ipcam_ws_discovery

class API_IPCAM_DISCOVERY(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_discovery'
        path = '/api/ipcam/discovery/'
        methods = ['GET']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self):
        print "begin"
        data = ipcam_ws_discovery()
        #data['1'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
        #data['2'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
        print json.dumps(data)
        return data #json.dumps(data)


from ipcam_onvif_getstreamuri import ipcam_onvif_getprofiles
class API_IPCAM_PROFILES(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_profiles'
        path = '/api/ipcam/profiles/<param_ip:re:.*>/'
        methods = ['GET']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self, param_ip):
        #print param_ip
        ip = param_ip
        port = ONVIF_PORT
        user = 'admin'
        passwd = '123456'

        data = {}
        data = ipcam_onvif_getprofiles(ip, port, user, passwd)
        #data['1'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
        #data['2'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
        # print json.dumps(data)
        print data

        return json.dumps(data)

from ipcam_onvif_getstreamuri import ipcam_onvif_getstreamuri
class API_IPCAM_STREAMURI(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_streamuri'
        path = '/api/ipcam/streamuri/<param_ip:re:.*>/<param_profile:re:.*>/'
        methods = ['GET']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self, param_ip, param_profile):
        print param_ip
        print param_profile

        ip = param_ip
        profile = param_profile
        port = ONVIF_PORT
        user = 'admin'
        passwd = '123456'

        data = {}
        data = ipcam_onvif_getstreamuri(ip, port, user, passwd, profile)
        #data['1'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
        #data['2'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
        # print json.dumps(data)
        print data

        return json.dumps(data)

class API_IPCAM_ALLSTREAMURI(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_allstreamuri'
        path = '/api/ipcam/allstreamuri/<param_ip:re:.*>/'
        methods = ['GET']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self, param_ip):

        user = ''
        passwd = ''
        if request.query['user']:
            user = request.query['user']
        if request.query['passwd']:
            passwd = request.query['passwd']
        print 'user=%s, passwd=%s' % (user, passwd)

        port = ONVIF_PORT
        ip = param_ip
        print ip
        all_profile = ipcam_onvif_getprofiles(ip, port, user, passwd)
        print all_profile

        data = {}
        if 'profiles' in all_profile.keys():
            for x_profile in all_profile['profiles']:
                profile = x_profile
                streamuri = ipcam_onvif_getstreamuri(ip, port, user, passwd, profile)
                data[profile] = streamuri['streamuri']

        #data['1'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
        #data['2'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
        # print json.dumps(data)
        print data

        return json.dumps(data)

# class API_IPCAM_ALLSTREAMURI(NVR_Root):
#     def __init__(self):
#         name = 'api_ipcam_allstreamuri'
#         path = '/api/ipcam/allstreamuri/'
#         methods = ['GET']
#         NVR_Root.__init__(self, name, path, methods)
#
#     # library of this class
#
#     # overridden methods (only valid for post/get/put/delete)
#     def get(self):
#
#         user = ''
#         passwd = ''
#         if request.cookies.user:
#             user = request.cookies.user
#         if request.cookies.passwd:
#             passwd = request.cookies.passwd
#         print 'user=%s, passwd=%s' % (user, passwd)
#
#         data = {}
#         all_ip = ipcam_ws_discovery()
#         print all_ip
#         print all_ip['ip_list']
#
#         port = ONVIF_PORT
#         #user = 'admin'
#         #passwd = '123456'
#         if 'ip_list' in all_ip.keys():
#             for x_ip in all_ip['ip_list']:
#                 ip = x_ip
#                 print ip
#                 all_profile = ipcam_onvif_getprofiles(ip, port, user, passwd)
#                 print all_profile
#
#                 data[ip] = {}
#                 if 'profiles' in all_profile.keys():
#                     for x_profile in all_profile['profiles']:
#                         profile = x_profile
#                         streamuri = ipcam_onvif_getstreamuri(ip, port, user, passwd, profile)
#                         data[ip][profile] = streamuri
#
#         #data['1'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
#         #data['2'] = {'name':'camera 1', 'ip':'192.168.0.168','port':43794,'user':'admin','passwd':'123456'}
#         # print json.dumps(data)
#         print data
#
#         return json.dumps(data)


def genIPCAM_LIST():
    data = {}
    for x in range(1, N_WAY+1):
        data[str(x)] = {}
        data[str(x)] ['name'] = ''
        data[str(x)] ['user'] = ''
        data[str(x)] ['passwd'] = ''
        data[str(x)] ['streamuri'] = ''
    return data

class API_IPCAM_LIST(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_list'
        path = '/api/ipcam/list/'
        methods = ['GET']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self):
        data = {}
        if os.path.isfile(NVR_IPCAM_LIST):
            with open(NVR_IPCAM_LIST,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                except:
                    data['error'] = '%s is not json format' % (NVR_IPCAM_LIST)
        else:
            data = genIPCAM_LIST()
            with open(NVR_IPCAM_LIST,'w') as fp:
                json.dump(data, fp)#dump() for output file, not dumps

        return json.dumps(data)


class API_IPCAM_LIST_N(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_list_n'
        path = '/api/ipcam/list/<param:int>/'
        methods = ['POST','GET','PUT','DELETE']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def post(self, param):
        print 'post'
        print param

        data = {}

        if param > N_WAY or param <= 0:
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        # get json data
        input_data = []
        json_data = get_json_data()
        print json_data

        # check data which MUST have 'name', 'user', 'passwd' and 'streamuri'
        formal_param = set(['name', 'user', 'passwd', 'streamuri'])
        input_param = set(json_data.keys())
        if input_param == formal_param:
            print "json_data correct"
        else:
            print "json_data wrong"
            str_tmp = ''
            if len(input_param) > len(formal_param):
                diff = input_param.difference(formal_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s should not in input json data' % (str_tmp)
            else:
                diff = formal_param.difference(input_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s not found in input json data' % (str_tmp)

            return json.dumps(data)

        print json_data
        json_data = json.dumps(json_data) #single quote problme, json MUST be double quote
        input_data = json.loads(json_data)

        if os.path.isfile(NVR_IPCAM_LIST):
            with open(NVR_IPCAM_LIST,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    # print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_LIST()
        else:
            data = genIPCAM_LIST()

        print data

        data[str(param)] = input_data
        print data
        with open(NVR_IPCAM_LIST,'w') as fp:
            try:
                json.dump(data, fp)
                print data
                print "json.dump"
            except:
                data['error'] = '%s fail to write' % (NVR_IPCAM_LIST)

        # print json.dumps(data)
        return json.dumps({"status":"OK"})


    def get(self, param):
        print 'get'
        print param

        data = {}
        if param > N_WAY or param <= 0:
            data = {}
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        if param > N_WAY or param <= 0:
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        if os.path.isfile(NVR_IPCAM_LIST):
            with open(NVR_IPCAM_LIST,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    # print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_LIST()
        else:
            data = genIPCAM_LIST()

        print data[str(param)]

        # print json.dumps(data[str(param)])
        return json.dumps(data[str(param)])


    def put(self, param):
        print 'put'
        print param

        data = {}

        if param > N_WAY or param <= 0:
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        # get json data
        input_data = []
        json_data = get_json_data()
        print json_data

        # check data which MUST have 'name', 'user', 'passwd' and 'streamuri'
        formal_param = set(['name', 'user', 'passwd', 'streamuri'])
        print json_data
        if json_data: #!!!!!Bill
            input_param = set(json_data.keys())
        if input_param == formal_param:
            print "json_data correct"
        else:
            print "json_data wrong"
            str_tmp = ''
            if len(input_param) > len(formal_param):
                diff = input_param.difference(formal_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s should not in input json data' % (str_tmp)
            else:
                diff = formal_param.difference(input_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s not found in input json data' % (str_tmp)

            return json.dumps(data)

        print json_data
        json_data = json.dumps(json_data) #single quote problme, json MUST be double quote
        input_data = json.loads(json_data)

        if os.path.isfile(NVR_IPCAM_LIST):
            with open(NVR_IPCAM_LIST,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    # print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_LIST()
        else:
            data = genIPCAM_LIST()

        print data

        data[str(param)] = input_data
        print data
        with open(NVR_IPCAM_LIST,'w') as fp:
            try:
                json.dump(data, fp)
                print data
                print "json.dump"
            except:
                data['error'] = '%s fail to write' % (NVR_IPCAM_LIST)

        # print json.dumps(data)
        return json.dumps(data)

    def delete(self, param):
        print 'delete'
        print param

        data = {}

        if param > N_WAY or param <= 0:
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        # get json data
        input_data = []
        json_data = get_json_data()
        print json_data

        # check data which MUST have 'name', 'user', 'passwd' and 'streamuri'
        formal_param = set(['name', 'user', 'passwd', 'streamuri'])
        input_param = set(json_data.keys())
        if input_param == formal_param:
            print "json_data correct"
        else:
            print "json_data wrong"
            str_tmp = ''
            if len(input_param) > len(formal_param):
                diff = input_param.difference(formal_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s should not in input json data' % (str_tmp)
            else:
                diff = formal_param.difference(input_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s not found in input json data' % (str_tmp)

            return json.dumps(data)

        print json_data
        json_data = json.dumps(json_data) #single quote problme, json MUST be double quote
        input_data = json.loads(json_data)

        if os.path.isfile(NVR_IPCAM_LIST):
            with open(NVR_IPCAM_LIST,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    # print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_LIST()
        else:
            data = genIPCAM_LIST()

        print data

        formal_param = set(['name', 'user', 'passwd', 'streamuri'])
        for x in formal_param:
            data[str(param)][x] = ''

        print "***"
        print data
        with open(NVR_IPCAM_LIST,'w') as fp:
            try:
                json.dump(data, fp)
                print data
                print "json.dump"
            except:
                data['error'] = '%s fail to write' % (NVR_IPCAM_LIST)

        # print json.dumps(data)
        return json.dumps({"status":"OK"})
def genIPCAM_OUTPUT():
    data = {}
    for x in range(1, N_WAY+1):
        data[str(x)] = {}
        data[str(x)] ['streaming'] = ''
        data[str(x)] ['streaming']['enable'] = 'n'
        data[str(x)] ['streaming']['streamuri'] = ''
        data[str(x)] ['recording'] = ''
        data[str(x)] ['playback'] = ''
    return data

class API_IPCAM_OUTPUT(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_output'
        path = '/api/ipcam/output/'
        methods = ['GET']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self):
        data = {}
        if os.path.isfile(NVR_IPCAM_OUTPUT):
            with open(NVR_IPCAM_OUTPUT,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                except:
                    data['error'] = '%s is not json format' % (NVR_IPCAM_OUTPUT)
        else:
            data = genIPCAM_OUTPUT()
            with open(NVR_IPCAM_OUTPUT,'w') as fp:
                json.dump(data, fp)#dump() for output file, not dumps

        return json.dumps(data)



class API_IPCAM_OUTPUT_N(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_output_n'
        path = '/api/ipcam/output/<param:int>/'
        methods = ['POST','GET','PUT','DELETE']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def post(self, param):
        print 'post'
        print param

        data = {}

        if param > N_WAY or param <= 0:
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        # get json data
        input_data = []
        json_data = get_json_data()
        print json_data

        # check data which MUST have 'name', 'user', 'passwd' and 'streamuri'
        formal_param = set(['streaming', 'recording', 'playback'])
        input_param = set(json_data.keys())
        if input_param == formal_param:
            print "json_data correct"
        else:
            print "json_data wrong"
            str_tmp = ''
            if len(input_param) > len(formal_param):
                diff = input_param.difference(formal_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s should not in input json data' % (str_tmp)
            else:
                diff = formal_param.difference(input_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s not found in input json data' % (str_tmp)

            return json.dumps(data)

        print json_data
        json_data = json.dumps(json_data) #single quote problme, json MUST be double quote
        input_data = json.loads(json_data)

        if os.path.isfile(NVR_IPCAM_OUTPUT):
            with open(NVR_IPCAM_OUTPUT,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    # print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_OUTPUT()
        else:
            data = genIPCAM_OUTPUT()

        print data

        data[str(param)] = input_data
        print data
        with open(NVR_IPCAM_OUTPUT,'w') as fp:
            try:
                json.dump(data, fp)
                print data
                print "json.dump"
            except:
                data['error'] = '%s fail to write' % (NVR_IPCAM_OUTPUT)

        # print json.dumps(data)
        return json.dumps({"status":"OK"})


    def get(self, param):
        print 'get'
        print param

        data = {}
        if param > N_WAY or param <= 0:
            data = {}
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        if param > N_WAY or param <= 0:
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        if os.path.isfile(NVR_IPCAM_OUTPUT):
            with open(NVR_IPCAM_OUTPUT,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_OUTPUT()
                    print "except"
        else:
            data = genIPCAM_OUTPUT()
            print "else"

        print data[str(param)]

        # print json.dumps(data[str(param)])
        return json.dumps(data[str(param)])


    def put(self, param):
        print 'put'
        print param

        data = {}

        if param > N_WAY or param <= 0:
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        # get json data
        input_data = []
        json_data = get_json_data()
        print json_data

        # check data which MUST have 'name', 'user', 'passwd' and 'streamuri'
        formal_param = set(['streaming', 'recording', 'playback'])
        input_param = set(json_data.keys())
        if input_param == formal_param:
            print "json_data correct"
        else:
            print "json_data wrong"
            str_tmp = ''
            if len(input_param) > len(formal_param):
                diff = input_param.difference(formal_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s should not in input json data' % (str_tmp)
            else:
                diff = formal_param.difference(input_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s not found in input json data' % (str_tmp)

            return json.dumps(data)

        print json_data
        json_data = json.dumps(json_data) #single quote problme, json MUST be double quote
        input_data = json.loads(json_data)

        if os.path.isfile(NVR_IPCAM_OUTPUT):
            with open(NVR_IPCAM_OUTPUT,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    # print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_OUTPUT()
        else:
            data = genIPCAM_OUTPUT()

        print data

        data[str(param)] = input_data
        print data
        with open(NVR_IPCAM_OUTPUT,'w') as fp:
            try:
                json.dump(data, fp)
                print data
                print "json.dump"
            except:
                data['error'] = '%s fail to write' % (NVR_IPCAM_OUTPUT)

        # print json.dumps(data)
        return json.dumps(data)

    def delete(self, param):
        print 'delete'
        print param

        data = {}

        if param > N_WAY or param <= 0:
            data['param'] = '%d is not valid' % (param)
            return json.dumps(data)

        # get json data
        input_data = []
        json_data = get_json_data()
        print json_data

        # check data which MUST have 'name', 'user', 'passwd' and 'streamuri'
        formal_param = set(['streaming', 'recording', 'playback'])
        input_param = set(json_data.keys())
        if input_param == formal_param:
            print "json_data correct"
        else:
            print "json_data wrong"
            str_tmp = ''
            if len(input_param) > len(formal_param):
                diff = input_param.difference(formal_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s should not in input json data' % (str_tmp)
            else:
                diff = formal_param.difference(input_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s not found in input json data' % (str_tmp)

            return json.dumps(data)

        print json_data
        json_data = json.dumps(json_data) #single quote problme, json MUST be double quote
        input_data = json.loads(json_data)

        if os.path.isfile(NVR_IPCAM_OUTPUT):
            with open(NVR_IPCAM_OUTPUT,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    # print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_OUTPUT()
        else:
            data = genIPCAM_OUTPUT()

        print data

        formal_param = set(['streaming', 'recording', 'playback'])
        for x in formal_param:
            data[str(param)][x] = ''

        print "***"
        print data
        with open(NVR_IPCAM_OUTPUT,'w') as fp:
            try:
                json.dump(data, fp)
                print data
                print "json.dump"
            except:
                data['error'] = '%s fail to write' % (NVR_IPCAM_OUTPUT)

        # print json.dumps(data)
        return json.dumps({"status":"OK"})

def genIPCAM_CONFIG():
    data = {}
    data['channel'] = N_WAY
    data['streaming_base_port'] = STREAMING_BASE_PORT
    data['platform'] = '119/1295'
    data['model'] = 'NVR'
    data['fw'] = '1.0.0'
    data['nvr'] = '0.1'
    return data

class API_IPCAM_CHN_PORT(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_chn_port'
        path = '/api/ipcam/chn_port/'
        methods = ['GET','PUT']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self, param):
        print 'get'
        print param

        data = {}

        if os.path.isfile(NVR_CONFIG):
            with open(NVR_CONFIG,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    # print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_CONFIG()
        else:
            data = genIPCAM_CONFIG()

        print data

        # print json.dumps(data[str(param)])
        return json.dumps(data)


    def put(self, param):
        print 'put'
        print param

        data = {}

        # get json data
        input_data = []
        json_data = get_json_data()
        print json_data

        # check data which MUST have 'name', 'user', 'passwd' and 'streamuri'
        formal_param = set(['channel', 'streaming_base_port'])
        input_param = set(json_data.keys())
        if input_param == formal_param:
            print "json_data correct"
        else:
            print "json_data wrong"
            str_tmp = ''
            if len(input_param) > len(formal_param):
                diff = input_param.difference(formal_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s should not in input json data' % (str_tmp)
            else:
                diff = formal_param.difference(input_param)
                str_tmp = '('
                for x in diff:
                    str_tmp = str_tmp + '%s ' % (x)
                str_tmp = str_tmp + ')'
                print str_tmp
                data['error'] = '%s not found in input json data' % (str_tmp)

            return json.dumps(data)

        print json_data
        json_data = json.dumps(json_data) #single quote problme, json MUST be double quote
        input_data = json.loads(json_data)

        if os.path.isfile(NVR_CONFIG):
            with open(NVR_CONFIG,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    # print data
                    # print data['ipcam_list']
                    # print data['ipcam_list']['1']
                    # print data['ipcam_list']['2']
                    # print data['ipcam_list']['3']
                    # print data['ipcam_list']['4']
                except:
                    data = genIPCAM_CONFIG()
        else:
            data = genIPCAM_CONFIG()

        print data

        data['streaming_base_port'] = input_data['streaming_base_port']
        print data
        with open(NVR_CONFIG,'w') as fp:
            try:
                json.dump(data, fp)
                print data
                print "json.dump"
            except:
                data['error'] = '%s fail to write' % (NVR_CONFIG)

        # print json.dumps(data)
        return json.dumps(data)

import time
class API_IPCAM_STREAMING(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_streaming'
        path = '/api/ipcam/streaming/'
        methods = ['GET','PUT','DELETE']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self):
        print 'get'

        data = {}
        data['service'] = ''

        import commands
        output = commands.getoutput('ps -A')
        if 'live555' in output:
            data['service'] = 'running'
        else:
            data['service'] = 'stop'

        print data

        return json.dumps(data)

    def put(self):
        data = {};
        data['status'] = ''

        #stop server
        self.delete()
        # time.sleep(5)
        # start streaming server
        if os.path.isfile(NVR_IPCAM_LIST):
            with open(NVR_IPCAM_LIST,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                except:
                    print '%s content corrupted' % (NVR_IPCAM_LIST)
                    data['status'] = 'fail.'
                    return data

                print data
                server = 'live555ProxyServer'
                param = '-v -p %d' % (STREAMING_PORT)
                print data['1']
                print data['2']
                print len(data)
                ip_cam_streamuri = ''
                for x in range(1, len(data)+1): #must ordered
                    print data[str(x)]
                    ip_cam_streamuri = '%s %s' % (ip_cam_streamuri, data[str(x)]['streamuri'])

                cmd = '%s %s %s &' % (server, param, ip_cam_streamuri) # push to background runnning or will fork N python processes
                print cmd

                os.system(cmd)

                # f = os.fork()
                #
                # if f == 0: # child process
                #     os.system(cmd)
                #     # print data['ipcam_list']
                #     # print data['ipcam_list']['1']
                #     # print data['ipcam_list']['2']
                #     # print data['ipcam_list']['3']
                #     # print data['ipcam_list']['4']
                #     # exit(0)
                # else :
                #     print 'successful'
                #     data['status'] = 'successful'

                # except:
                #     print '%s content corrupted' % (NVR_IPCAM_LIST)
                #     data['status'] = 'fail.'

                return data #json.dumps(data)

    def delete(self):
        data = {}
        data['status'] = ''
        # stop streaming server
        cmd = 'killall -9 %s' % ('live555ProxyServer')

        try:
            os.system(cmd)
        except:
            pass

        # f = os.fork()
        # if f == 0: # child process
        #     try:
        #         os.system(cmd)
        #     except:
        #         pass
        #     exit(0)
        # else :
        #     print 'successful'
        #     data['status'] = 'successful'

        print 'successful'
        data['status'] = 'successful'

        print '%s DELETE' % ('live555ProxyServer')
        # print json.dumps(data)
        return data #json.dumps(data)


class API_IPCAM_RECORDING(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_recording'
        path = '/api/ipcam/recording/'
        methods = ['GET','PUT','DELETE']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # Receiving streamed data (signal with "kill -HUP 9918" or "kill -USR1 9918" to terminate)...

    # overridden methods (only valid for post/get/put/delete)
    def get(self):
        print 'get'

        data = {}
        data['service'] = ''

        import commands
        output = commands.getoutput('ps -A')
        if 'openRTSP' in output:
            data['service'] = 'running'
        else:
            data['service'] = 'stop'

        print data

        return json.dumps(data)

    def put(self):
        data = {};
        data['status'] = ''

        #stop server
        self.delete()
        time.sleep(3) #(15)
        # start streaming server
        if os.path.isfile(NVR_IPCAM_LIST):
            with open(NVR_IPCAM_LIST,'r') as fp:
                try:
                    data = json.load(fp)#load(...) from input file, not loads()
                    print data
                    server = 'openRTSP' #'%s/lib/openRTSP' % (NVR_HOME) # openRTSP cannot assign path
                    print len(data)
                    ip_cam_record = ''
                    for x in range(1, len(data)+1): #must ordered
                        print data[str(x)]['name']
                        import datetime
                        time_prefix = datetime.datetime.fromtimestamp(int(time.time())).strftime('%Y-%m-%d-%H-%M-%S')
                        print time_prefix
                        # prefix = '%s/%d_%s_%s_recording_' % (RECORDING_PATH, x, time_prefix, data[str(x)]['name']) #.encode('ascii', 'ignore'))
                        prefix = '%s/%d_%s_' % (RECORDING_PATH, x, time_prefix) #.encode('ascii', 'ignore')), too long for app client vlc play- shorten it
                        print prefix
                        #param = '-i -H -w 1280 -h 720 -f 30 -P %d -F \"%s\"' % (RECORDING_SIZE, prefix) #.avi
                        param = '-4 -H -w 1280 -h 720 -f 30 -P %d -F \"%s\" -b 10000000 -B 10000000' % (RECORDING_SIZE, prefix) #.mp4 -H:QuickTime 'hint track'??, seem better, no .avi index rebuild problem

                        #param = '-i -w 1280 -h 720 -P %d -F \"%s\"' % (RECORDING_SIZE, prefix)
                        print param
                        ip_cam_record = data[str(x)]['streamuri'] #'rtsp://127.0.0.1:%d/proxyStream-%d' % (STREAMING_PORT, x)
                        print ip_cam_record
                        cmd = '%s %s %s &' % (server, param, ip_cam_record)# push to background runnning or will fork N python processes
                        print cmd

                        os.system(cmd)

                        # f = os.fork()
                        # if f == 0: # child process
                        #     os.system(cmd)
                        #     # print data['ipcam_list']
                        #     # print data['ipcam_list']['1']
                        #     # print data['ipcam_list']['2']
                        #     # print data['ipcam_list']['3']
                        #     # print data['ipcam_list']['4']
                        #     exit(0)
                        # else :
                        #     print 'successful'
                        #     data['status'] = 'successful'
                except:
                    print '%s content corrupted' % (NVR_IPCAM_LIST)
                    data['status'] = 'fail.'

        return data #json.dumps(data)

    def delete(self):
        data = {}
        data['status'] = ''
        # stop streaming server
        cmd = 'killall -9 %s' % ('openRTSP')

        os.system(cmd)

        # f = os.fork()
        #
        # if f == 0: # child process
        #     os.system(cmd)
        #     exit(0)
        # else :
        #     print 'successful'
        #     data['status'] = 'successful'


        print '%s DELETE' % ('openRTSP')

        data['status'] = 'successful'
        # print json.dumps(data)
        return data #json.dumps(data)


class API_IPCAM_RECORDING_FILELIST(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_recording_filelist'
        path = '/api/ipcam/recording/filelist/'
        methods = ['GET']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    # overridden methods (only valid for post/get/put/delete)
    def get(self):
        data = {}
        path = NVR_HOME + '/recording'
        data['filelist'] = [f for f in os.listdir(path) if f.endswith('.mp4')]
        return json.dumps(data)


class API_IPCAM_RECORDING_FILELIST_N(NVR_Root):
    def __init__(self):
        name = 'api_ipcam_recording_filelist_n'
        path = '/api/ipcam/recording/filelist/<param:int>/'
        methods = ['GET']
        NVR_Root.__init__(self, name, path, methods)

    # library of this class

    def get(self, param):

        data = {}
        if param > N_WAY or param <= 0:
            data['param'] = '%d is not valid' % (param)
        else:
            path = NVR_HOME + '/recording'
            data['filelist'] = [f for f in os.listdir(path) if f.startswith(str(param)) and f.endswith('.mp4') ]
        return json.dumps(data)


# API registration
# --- IP Camera ---
api_ipcam_discovery = API_IPCAM_DISCOVERY()
api_registration(api_ipcam_discovery)

api_ipcam_profiles = API_IPCAM_PROFILES()
api_registration(api_ipcam_profiles)

api_ipcam_streamuri = API_IPCAM_STREAMURI()
api_registration(api_ipcam_streamuri)

api_ipcam_allstreamuri = API_IPCAM_ALLSTREAMURI()
api_registration(api_ipcam_allstreamuri)

api_ipcam_list = API_IPCAM_LIST()
api_registration(api_ipcam_list)

api_ipcam_list_n = API_IPCAM_LIST_N()
api_registration(api_ipcam_list_n)

api_ipcam_output = API_IPCAM_OUTPUT()
api_registration(api_ipcam_output)

api_ipcam_output_n = API_IPCAM_OUTPUT_N()
api_registration(api_ipcam_output_n)

api_ipcam_chn_port = API_IPCAM_CHN_PORT()
api_registration(api_ipcam_chn_port)

api_ipcam_streaming = API_IPCAM_STREAMING()
api_registration(api_ipcam_streaming)

api_ipcam_recording = API_IPCAM_RECORDING()
api_registration(api_ipcam_recording)

api_ipcam_recording_filelist = API_IPCAM_RECORDING_FILELIST()
api_registration(api_ipcam_recording_filelist)

api_ipcam_recording_filelist_n = API_IPCAM_RECORDING_FILELIST_N()
api_registration(api_ipcam_recording_filelist_n)
