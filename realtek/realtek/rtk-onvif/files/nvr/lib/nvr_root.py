from bottle import Bottle
from bottle import route, run, template
from bottle import request, response
from bottle import post, get, put, delete

from nvr_system import *

# ------------------------------------------------------------------------
# NVR API Root Class
# Based on bottole.py (Python RESTFul API Framework)
#--------------------------------------------------------------------------
class NVR_Root():    
    def __init__(self, name, path, methods):
        self.name = name
        self.path = path
        self.methods = methods
        # print methods
        
        self.func = {}
        for x in methods:
            #print x
            if x == "POST":
                self.func[x] = self.post
            elif x == "GET":
                self.func[x] = self.get
            elif x == "PUT":
                self.func[x] = self.put
            elif x == "DELETE":
                self.func[x] = self.delete
            else:
                conitue
        
    def handler(self, **param):
        # print request.method
        # print param
        
        # login check here , call nvr_system function
        
        #how to set API as guest, admin only, ...

        if request.method in self.methods:
            # print request.method
            # print self.methods
            # print self.func[request.method]
            return self.func[request.method](**param)
        else:
            data = {'erro':'method - %s is not defined in %s' % (request.method, name)}
            return json.dumps(data)
        
    def post(self, **param):
        data = {'error':'%s of %s only has default function (It should be overridden)' % (request.method, self.name)}
        # print data
        return json.dumps(data)
        
    def get(self, **param):
        data = {'error':'%s of %s only has default function (It should be overridden)' % (request.method, self.name)}
        # print data
        return json.dumps(data)

    def put(self, **param):
        data = {'error':'%s of %s only has default function (It should be overridden)' % (request.method, self.name)}
        # print data
        return json.dumps(data)

    def delete(self, **param):
        data = {'error':'%s of %s only has default function (It should be overridden)' % (request.method, self.name)}
        # print data
        return json.dumps(data)
