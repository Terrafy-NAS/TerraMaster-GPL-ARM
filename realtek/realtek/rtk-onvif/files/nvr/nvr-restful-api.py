# # Global Setting
from config import * # will add NVR_HOME+'/lib' and NVR_HOME+'/api'  to path

# IP cam management data structure
# /etc/nvr.json

# from nvr_system import *
# from nvr_root import *

# nvr ui
from bottle import static_file
#@route('/nvrui/<filename:re:.*\.mp4)>')
def send_mp4(filename):
    #data = []
    #with open(NVR_HOME+'/recording/'+filename,'rb') as f:
    #    from io import BytesIO
    #    video_buf = BytesIO(f.read())
    #    video_buf.seek(0)
    #    data = video_buf.read()
    #    response.set_header('Content-type','application/octet-stream')
    #print "streaminig..."
    #return data
    #print request.environ
    #print filename
    #if os.path.isfile(NVR_HOME+'/recording'+filename): 
    #    fp = file(NVR_HOME+'/recording'+filename) 
    #    with open(NVR_HOME+'/recording/'+filename,'rb') as fp:
    #        if 'wsgi.file_wrapper' in request.environ: 
    #            print "wsgi.file_wrapper"
    #            return request.environ['wsgi.file_wrapper'](fp) 
    #        else: 
    #            print "no file wrapper"
    #            f = fp.read() 
    #            fp.close() 
    #            return f 
    # response.set_header('Connection', 'keep-alive')
    # return static_file(filename, root=NVR_HOME+'/recording', download=filename, mimetype='video/mp4') #'application/octet-stream')
    return static_file(filename, root=NVR_HOME+'/recording', mimetype='video/mp4') #'application/octet-stream')

#@route('/nvrui/<filename:re:.*\.avi)>')
def send_avi(filename):
    # data = []
    # with open(NVR_HOME+'/recording/'+filename,'rb') as f:
    #     from io import BytesIO
    #     video_buf = BytesIO(f.read())
    #     video_buf.seek(0)
    #     data = video_buf.read()
    #     response.set_header('Content-type','application/octet-stream')
    # print "streaminig..."
    # return data
    # response.set_header('Connection', 'keep-alive')
    return static_file(filename, root=NVR_HOME+'/recording', mimetype='video/avi') #'application/octet-stream')


#@route('/nvrui/<filename:re:.*\.gif>')
def send_gif(filename):
    return static_file(filename, root=NVR_HOME+'/nvrui', mimetype='image/gif')

#@route('/nvrui/<filename:re:.*\.css>')
def send_css(filename):
    return static_file(filename, root=NVR_HOME+'/nvrui', mimetype='text/css')

#@route('/nvrui/<filename:re:.*\.js>')
def send_js(filename):
    return static_file(filename, root=NVR_HOME+'/nvrui', mimetype='text/javascript')

#@route('/nvrui/<filename:re:.*\.html>')
def send_html(filename):
    return static_file(filename, root=NVR_HOME+'/nvrui', mimetype='text/html')

#@route('/upload/<filename:re:.*>')
"""
nvrui/upload.html
<html>
<head>
<title>
Uploading a file for Transcoding Demo
</title>
</head>
<body>
<form action="/upload" method="post" enctype="multipart/form-data">
  Select a file: <input type="file" name="upload" />
  <input type="submit" value="Start upload" />
</form>
</body>
</html>
"""
def upload_binary(filename):
    upload = request.files.get('image') # this name MUST be 'image' for app
    name, ext = os.path.splitext(upload.filename)
    print "base name : %s, extension: %s" % (name, ext)

    save_path = "%s/upload" % (NVR_HOME)
    if not os.path.exists(save_path):
        os.makedirs(save_path)

    file_path = "%s/%s" % (save_path, upload.filename)
    with open(file_path, 'wb') as output_file:
        output_file.write(upload.file.read())
    return "%s successfully saved to %s" % (upload.filename, save_path)

#@route('/nvrui/<filename:re:.*\.mp4)>')
def upload_dl_mp4(filename):
    # data = []
    # with open(NVR_HOME+'/recording/'+filename,'rb') as f:
    #     from io import BytesIO
    #     video_buf = BytesIO(f.read())
    #     video_buf.seek(0)
    #     data = video_buf.read()
    #     response.set_header('Content-type','application/octet-stream')
    # print "streaminig..."
    # return data
    # response.set_header('Connection', 'keep-alive')
    print filename
    return static_file(filename, root=NVR_HOME+'/upload') #'application/octet-stream')


if __name__ == '__main__':
    # Initialize Bottle framework
    app = Bottle()

    # Load all API into Bottle framework
    from api_info import * # API_INFO
    from api_auth import * # API_AUTH_PRELOGIN, API_AUTH_LOGIN, API_AUTH_LOGOUT
    from api_ipcam import * # API_IPCAM_DISCOVERY, API_IPCAM_STREAMURI, API_IPCAM_LIST, API_IPCAM_LIST_N

    # nvr ui
    the_path  = '/recording/<filename:re:.*\.mp4>'
    the_methods = ['GET']
    the_handler = send_mp4
    app.route(the_path, the_methods, the_handler)

    the_path  = '/recording/<filename:re:.*\.avi>'
    the_methods = ['GET']
    the_handler = send_avi
    app.route(the_path, the_methods, the_handler)

    the_path  = '/nvrui/<filename:re:.*\.gif>'
    the_methods = ['GET']
    the_handler = send_gif
    app.route(the_path, the_methods, the_handler)

    the_path  = '/nvrui/<filename:re:.*\.css>'
    the_methods = ['GET']
    the_handler = send_css
    app.route(the_path, the_methods, the_handler)


    the_path  = '/nvrui/<filename:re:.*\.js>'
    the_methods = ['GET']
    the_handler = send_js
    app.route(the_path, the_methods, the_handler)

    the_path  = '/nvrui/<filename:re:.*\.html>'
    the_methods = ['GET']
    the_handler = send_html
    app.route(the_path, the_methods, the_handler)

    # upload and download- for transcodeing demo purpose
    the_path  = '/api/upload/<filename:re:.*>'
    the_methods = ['POST']
    the_handler = upload_binary
    app.route(the_path, the_methods, the_handler)

    the_path  = '/api/upload/<filename:re:.*>'
    the_methods = ['GET']
    the_handler = upload_dl_mp4
    app.route(the_path, the_methods, the_handler)

    #import socket  
    #timeout = 10 # make ipcam discovery fail - time-out
    #socket.setdefaulttimeout(timeout)


    # Enable the API onto Bottle framework
    for x in api_meta_array:
        # print x['path'], x['method'], x['handler']
        app.route(x['path'], x['method'], x['handler'])

    # # Start the RESTFul API service (single threading)
    # run(app, host='0.0.0.0', port=18080)

    # Start the RESTFul API service (multiple threading)
    # from bottle import CherryPyServer
    # run(app, host='0.0.0.0', port=18080, server=CherryPyServer)

    #from rocket import CherryPyWSGIServer
    #server = CherryPyWSGIServer([('0.0.0.0',18080),('127.0.0.1', 18080)], app)
    #server.start()

    # Another Server Running mode with Apache/Lighttpd
    # WSGI server
    # run(app, host='0.0.0.0', port=18080)
    with open('/var/run/nvr.pid','w') as fd:
        fd.write(str(os.getpid()))
    from flup.server.fcgi import WSGIServer
    options = { 'bindAddress': '/var/run/nvr.sock', 'umask': 0000 }
    WSGIServer(app, **options).run()

    # Fast CGI Server
    # import flup
    # run(app, server='flup', host='0.0.0.0', port=18080)
