# Global Setting
from config import * # will add NVR_HOME+'/lib' and NVR_HOME+'/api'  to path

from bottle import Bottle
from bottle import route, run, template
from bottle import request, response
from bottle import post, get, put, delete

import os

# Global Setting
from config import * # will add NVR_HOME+'/lib' and NVR_HOME+'/api'  to path


# ------------------------------------------------------------------------
# Libray for API developers
#--------------------------------------------------------------------------
def api_registration(api_object):
    if api_object:
        # print api_object.name
        # print api_object.path
        # print api_object.methods
        # print api_object.handler    
        api_meta_array.append({'path':api_object.path, 'method':api_object.methods, 'handler':api_object.handler})

def get_json_data(): # only for POST/PUT/DELETE, NOT FOR GET
        # parse input data
        array_data = []
        json_data = {}
        
        print request.body.read()
        try:
            json_data = request.json
            print json_data
            json_data = json.dumps(json_data) #single quote problme, json MUST be double quote
            array_data = json.loads(json_data)
            print array_data
        except:
            array_data['error'] = {'erro':'JSON data to array fail (%s)' % (request.body.read())}

        return array_data #json.dumps(data)

