--[[
   /usr/lib/lua/luci/controller/apiapp.lua
   Browse to: /cgi-bin/luci/;stok=.../apiappp/{API List}
   {API List} :
    get_info, get_m2muid,
    handle_ls,
    upload, upload.htm, download
    fw_check, fw_upgrade
    usb_check
    init_check
    reg_stok
    set_psw

    last update 2017/10/26

    This code is based on LuCI under Apache License, Version 2.0.
    http://luci.subsignal.org/trac/wiki/License
    http://www.apache.org/licenses/LICENSE-2.0
    Copyright (C) Realtek Semiconductor Corp. All rights reserved.
--]]
--[[

v0.9.3-u2 : bug fix

  1. reg_stok only check if 8117 is initialized
     (api_init() will check both if 8117 is initilaized and if stok is registered)
  2. code refactory on _init_check and stok check

---

v0.9.3-u1 : bug fix

  1.add is_dir checking before handle_ls

  2.make more checking on the form parameter - path of handle_ls and upload

  3.except init_check and set_psw, all APIs need initialized

  4.re-organize code (library of upload was moved to library area)

v0.9.3
  1.IB and OOB check for new EHCI driver
    if IB then no access to USB
    (cat /proc/rtl8117-ehci/ehci_enabled ==> 0 in OOB, 1 in IB)
    upload, download, upload.htm, handle_ls, fw_upgrade

  2.fw_check bug fixed for version.txt with empty line

  3.fw_check add BuildDate checking

  4.fw_upgrade : add the option - '-n' to sysupgrade command

  5.RealWoW URL
    change from
    local g_img_url = 'http://realwow.realtek.com/rtl8117/rtl8117-factory.img'
    to
    local g_img_url = 'http://realwow.realtek.com/rtl8117/openwrt-rtl8117-factory-bootcode.img


v0.9.2
  1.add multiple user API
  2.add handle_mkg_img_urlAPI
  3.modify upload API to save file in a given sub directory
  4.modify upload API to rename file if the given file is already existen
  5.code refactory for using luci.* code as much as possible
    (1) use luci.http.protocol.mime.to_mime() , unknow ext will be application/octet-stream, NOT application/unknown


  error cases
     USB flash not mounted
     file not exist (download)
     file exist (upload)
     path not exist (upload)
     path exist (mkdir)

]]

module("luci.controller.apiapp", package.seeall)

function index()
  -- define parent node as the alias of apiapp.apiapp.htm
  page = entry({"apiapp"},
               alias("apiapp", "apiapp.htm"), "API App")
  page.dependent = false

  page = entry({"apiapp","get_info"},    call("get_info"))
  page = entry({"apiapp","get_m2muid"},  call("get_m2muid"))

  page = entry({"apiapp","handle_ls"},   call("handle_ls"))

  page = entry({"apiapp","upload"},      call("upload"))
  page = entry({"apiapp","upload.htm"},  call("upload_htm"))
  page = entry({"apiapp","download"},    call("download"))

  page = entry({"apiapp","fw_check"},    call("fw_check"))
  page = entry({"apiapp","fw_upgrade"},  call("fw_upgrade"))

  page = entry({"apiapp","usb_check"},   call("usb_check"))

  page = entry({"apiapp","init_check"},  call("init_check"))
  page = entry({"apiapp","reg_stok"},    call("reg_stok"))
  page = entry({"apiapp","set_psw"},     call("set_psw"))

  page = entry({"apiapp","test"},  call("test"))
  page = entry({"apiapp","getuid"},      call("getuid"))

end

-----------------------------------------------------------------------
-- global g_img_urls {begin}
-----------------------------------------------------------------------
local g_api_version = "v0.9.3-u2"
local g_home = '/mnt/sda1/home/'
local g_buffer_size = 2^13 -- good buffer size (8K)
local g_usb_mt = '/mnt/sda1' -- usb mount point
local g_local_ver_file = '/etc/version.txt'
local g_ver_url = 'http://realwow.realtek.com/rtl8117/version.txt'
local g_default_fw = '/tmp/firmware.img'
local g_img_url = 'http://realwow.realtek.com/rtl8117/openwrt-rtl8117-factory-bootcode.img'
local init_file = "/etc/initialized"
local stok_appuid_map = '/tmp/stok_appuid.map'
local fileuid_map = '/tmp/fileuid.map'


ERR_WAR_MSG = {
  [0] = 'OK',
  [-1] = 'FAIL',
}
-----------------------------------------------------------------------
-- global g_img_urls {end}
-----------------------------------------------------------------------


-----------------------------------------------------------------------
-- library {begin}
-----------------------------------------------------------------------
--[[
  {"version":"THE_VERSION",
   "code":STATUS_CODE,
   "message":"STATUS_MESSAGE",
   "data":[]
  }
--]]
function response_mock()
   local data = {}
   data['version'] = g_api_version
   data['code'] = 0
   data['message'] = 'OK'
   data['data'] = {}
   return data
end

-- Extract extension from a filename and return corresponding mime-type
-- or "application/octet-stream" if the extension is unknown.
function get_mime(ext)
   require "luci.http.protocol.mime"
   return luci.http.protocol.mime.to_mime(ext)
end

--[[
The cmd ONLY return the first result.
If you need more that one result, merge all result into the first result.
--]]
function shell_cmd(cmd)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen(cmd)
    for x in pfile:lines() do
        -- print(x)
        t = x
    end
    pfile:close()
    return t
end

--[[
root@OpenWrt:/www/cgi-bin# cat /proc/uptime
8979.39 8201.91
--]]
function sec2DHMS(sec)
   local days, hours, minutes, seconds
   if sec <= 0 then
      days, hours, minutes, seconds = 0, 0, 0, 0
   else
      days = math.floor(sec / (60*60*24))
      sec = sec % (60*60*24)
      hours = math.floor(sec / (60*60))
      sec = sec % (60*60)
      minutes = math.floor(sec / 60)
      seconds = math.floor(sec % 60)
   end

      return days, hours, minutes, seconds
end

--[[
g_img_url file structure :
name=value
like :
FWVER=1.0.1508
KERNEL=4.4.18-g387e391fd59e-dirty
OpenWrt=gd577f398
U-Boot=2016.11-g4f850a533a-dirty  <--optional, only for fw with u-boot
BuildDate=2017-07-20

return array[k]=v
--]]
function read_config(config_file)
  require "lfs"
  local data = {}
  if lfs.attributes(config_file) then
    local file = io.open(config_file, "r")
    if file then
       for x in file:lines() do
         if x then
            k,v = x:match('(.*)=(.*)')
            if k then data[k] = v end
         end
       end
     file:close()
    end
  end

  return data
end

--[[
root@OpenWrt:/# cat /etc/version.txt
FWVER=1.0.1508
KERNEL=4.4.18-g387e391fd59e-dirty
OpenWrt=gd577f398
U-Boot=2016.11-g4f850a533a-dirty  <--optional, only for fw with u-boot
BuildDate=2017-07-20

FWVER = [0-9]+.[0-9]+.[0-9]+
         major    minor    sn(git commit #)
--]]

-- return major, minor, sn
function get_local_fw_ver()
  local major = 0
  local minor = 0
  local sn = 0
  local year = 0
  local month = 0
  local day = 0

  data = read_config(g_local_ver_file)
  if data['FWVER'] then
    major, minor, sn = data['FWVER']:match('([0-9]+)\.([0-9]+)\.([0-9]+)')
  end

  if data['BuildDate'] then
    year, month, day = data['BuildDate']:match('([0-9]+)\-([0-9]+)\-([0-9]+)')
  end

  return major, minor, sn, year, month, day
end

-- return major, minor, sn
function get_remote_fw_ver()
  local major = 0
  local minor = 0
  local sn = 0
  local year = 0
  local month = 0
  local day = 0
  local data = {}

  -- read remote version.txt
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('wget -q -O - ' .. g_ver_url)
  for x in pfile:lines() do
      if x then
         k,v = x:match('(.*)=(.*)')
         if k then data[k] = v end
      end
  end
  pfile:close()

  if data['FWVER'] then
    major, minor, sn = data['FWVER']:match('([0-9]+)\.([0-9]+)\.([0-9]+)')
  end

  if data['BuildDate'] then
    year, month, day = data['BuildDate']:match('([0-9]+)\-([0-9]+)\-([0-9]+)')
  end

  return major, minor, sn, year, month, day
end

function fw_is_new(l_major, l_minor, l_sn, l_year, l_month, l_day, r_major, r_minor, r_sn, r_year, r_month, r_day)
   local result = 'no'

   if (r_major > l_major) then
       result = 'yes'
   end
   if (r_major == l_major) and (r_minor > l_minor) then
       result = 'yes'
   end
   if (r_major == l_major) and (r_minor == l_minor) and (r_sn > l_sn)  then
       result = 'yes'
   end

   if (r_major == l_major) and (r_minor == l_minor) and (r_sn == l_sn)  then
       if (r_year > l_year) then
          result = 'yes'
       end
       if (r_year == l_year) and (r_month > l_month) then
           result = 'yes'
       end
       if (r_year == l_year) and (r_month == l_month) and (r_day > l_day)  then
           result = 'yes'
       end
   end

   return result
end

function upgrade_test_ok()
    local i, t, popen = 0, {}, io.popen

    -- check the image - download ok?, checksum ok?
    os.remove(g_default_fw) -- clear the previous firmware
    -- the result of 'sysupgrade -T ' .. g_img_url CANNOT be merged into the first result
    local pfile = popen('sysupgrade -T ' .. g_img_url) -- '-T' test mode

    local ok = true
    for x in pfile:lines() do
        --print("*** " .. x)
        if x:match('Image check \'platform_check_image\' failed') then
           ok = false
        end
    end

    pfile:close()

    return ok
end

function upgrade_run()
    -- if the image is ok , upgrade it
   r = shell_cmd('sysupgrade -n ' .. g_img_url)
   -- print(r)
end

--[[
   if g_usb_mt(/mnt/sda1) is mounted with a USB flash then return true
   else return false
--]]
function sda_is_mounted()
    local mounted = false

    -- root@OpenWrt:/mnt/sda1# mount | grep '/mnt/sda1'
    -- /dev/sdb1 on /mnt/sda1 type vfat (rw,relatime,fmask=0000,dmask=0000,allow_utime=
    -- 0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro)
    r = shell_cmd('mount')
    -- print(r)
    if r:match(g_usb_mt) then mounted = true end

    return mounted
end

-- Remove file name from fileid.map --
function del_fileid(filename, fileid)
        --  Read the file
        local f = io.open(filename, "r")
        local content = f:read("*all")
        f:close()
 
        -- Edit the string
        local pat = string.match(content,"\n(.*="..fileid.."\n)")--"CFBC1DA9-F9D6-44AF-8847-88A653354CCA/IMG_0544.MOV=371670401362.55\n"
        
        local begin_addr, end_addr = 0, 0
        while begin_addr do
            begin_addr, end_addr = string.find(pat,"\n\n",end_addr)
            if end_addr == nil then break end
            pat = string.sub(pat,end_addr)
        end

        if pat then
                -- process the escap symbol for pat.gsub function
                pat = pat.gsub(pat, "%-", "%%-") -- escape symbole is '%', "-" must be "%-" and escape escap symbole is "%%-"
                content = string.gsub(content, pat, "")
 
                -- Write back to the same file
                local f = io.open(filename, "w")
                f:write(content)
                f:close()
        end
end

-- Check if file exists --
function _isfile(file)
   local f=io.open(file,"r")
   if f ~= nil then
      io.close(f)
      return true
   else
      return false
   end
end

-- Check if folder exists --
function _isdir(path)
   require 'lfs'
   if lfs.attributes(path:gsub("\\$",""),"mode") == "directory" then
      return true
   else
      return false
   end
end

function append_config(config_file, k,v)
  local mode = ""
  if _isfile(config_file) then
     mode = "a"
  else
     mode = "w"
  end

  require "lfs"
  local file = io.open(config_file, mode)
  file:write(k..'='..v..'\n')
  file:close()
end

-- There is at lease 0.1 second between two function calls of this function
-- or the two result will be the same!!! (seed precision limitation)
function gen_random_filename()
   math.randomseed(os.time()*10^3 + os.clock()*10^3) --time())
   return tostring(math.random()*10^12)
end

-- check if filename_org exist
-- or it will append _N to the file name
function check_filename(path, filename_org)
  local fn = filename_org
  local ext = fn:match("^.+%.(.+)$")
  local name = fn:match("(.+)%..+")
  local counter = 1
  local changed = false

  while _isfile(path..fn) do
      require "nixio.fs"
      fn = string.format("%s-%d.%s", name, counter, ext)
      counter = counter + 1
      changed = true
  end
  return fn, changed
end

-- the mapping of stok and appuid is stored at /tmp/stok_appuid.map
-- the appuid is the user's home directory name under /mnt/sda1/home
function get_user_home(stok)
  local subdir = ''
  if stok then
    local data = read_config(stok_appuid_map)
    if data[stok] then subdir = data[stok] end
  end
  return subdir
end

function get_stok()
   require "nixio"
   http_headers = nixio.getenv()
   param = http_headers['REQUEST_URI']
   stok = ";stok=" .. param:match(";stok=(.*)/apiapp")
   return stok
end

function  _init_check(show_error)
   if show_error == nil then show_error = true end
   -- check if the file existen
   if _isfile(init_file) then
      return true
   else
      if show_error then
        local result = response_mock()
        luci.http.prepare_content('application/json')
        result['code'] = -1
        result['message'] = 'system not initialized'
        luci.http.write_json(result)
    end

      return false
   end
end

function _stok_check(show_error)
   if show_error == nil then show_error = true end
   -- check if the stok is registered
   if get_user_home(get_stok()) ~= '' then
      return true
   else
      if show_error then
        local result = response_mock()
        luci.http.prepare_content('application/json')
        result['code'] = -1
        result['message'] = get_stok()..' not registered.'
        luci.http.write_json(result)
      end

      return false
   end
end


function api_init(show_error)
   if show_error == nil then show_error = true end

   if _init_check(show_error) and _stok_check(show_error) then
       return true
   else
       return false
   end

end

function isIB() -- return true for IB, return false for OOB
   local mode
   mode = shell_cmd('cat /proc/rtl8117-ehci/ehci_enabled') -- 0 for OOB, 1 for IB
   if mode == '0' then
      return false
   else
      return true
   end
end

-----------------------------------------------------------------------
-- library {end}
-----------------------------------------------------------------------


function test()
   luci.http.prepare_content('text/plain')

   --luci.http.write('test\ntest')
   --luci.http.write(get_mime('txt') .. '\n')
   --luci.http.write(get_mime('pdf') .. '\n')
   --luci.http.write(get_mime('jpeg') .. '\n')
   --luci.http.write(get_mime('jpg') .. '\n')
   --luci.http.write(get_mime('gif') .. '\n')
   --luci.http.write(get_mime('png') .. '\n')

   --luci.http.write(get_mime('tiff') .. '\n')
   --luci.http.write(get_mime('zip') .. '\n')
   --luci.http.write(get_mime('gzip') .. '\n')
   --luci.http.write(get_mime('html') .. '\n')
   --luci.http.write(get_mime('htm') .. '\n')
   --luci.http.write(get_mime('mpeg') .. '\n')

   --luci.http.write(get_mime('mp4') .. '\n')
   --luci.http.write(get_mime('avi') .. '\n')
   --luci.http.write(get_mime('exe') .. '\n')
   --luci.http.write(get_mime('js') .. '\n')
   --luci.http.write('\n')
--[[
  ['txt']  = 'text/plain',
  ['pdf']  = 'application/pdf',
  ['jpeg'] = 'image/jpeg',
  ['jpg']  = 'image/jpeg',
  ['gif']  = 'image/gif',
  ['png']  = 'image/png',
  ['tiff'] = 'image/tiff',
  ['zip']  = 'application/zip',
  ['gzip'] = 'application/gzip',
  ['html'] = 'text/html',
  ['htm']  = 'text/html',
  ['mpeg'] = 'video/mpeg',
  ['mp4']  = 'video/mp4',
  ['avi']  = 'video/avi',
  ['exe']  = 'application/plain',
  ['js']   = 'application/javascript',
--]]

   --require "luci.sys"
   --luci.http.write(luci.sys.uptime() .. '\n\n')


   --require "luci.sys" -- not works
   --luci.http.write(luci.sys.user.getpasswd('root') .. '\n')

   --require "luci.fs"
   --luci.http.write(luci.fs.isfile('/etc/config/uhttpd') .. '\n')

   --for i=1,100 do
   --      print(gen_random_filename())

      --os.execute("sleep 1")
   --      local ntime = os.clock() + 0.1
   --      repeat until os.clock() > ntime
   --   end

   --if  get_user_home(get_stok()) == '' then
   --   print(get_stok() .. ' not reg. \n')
   --else
   --   print(get_user_home(get_stok()))
   --end

   --fn = check_filename('/mnt/sda1/home/usertest/','1.jpg')
   --print(fn)

   --luci.http.write('IB==1, OOB==0\n')
   --if (isIB()) then
   --   luci.http.write('IB\n')
   -- else
   --   luci.http.write('OOB\n')
   -- end


end

-----------------------------------------------------------------------
-- API {begin}
-----------------------------------------------------------------------
--[[
   json data format {"cpu_usage":12,"mem_usage":{"total":27,"free":12,"buffered":88},"disk_usage":9.8,"uptime":{"days":0,"hours":2,"minutes":0,"seconds":23}}
-]]
function get_info()
   if not api_init() then return end

   local result = response_mock()

   -- usage_cpu
   -- root@OpenWrt:/www/cgi-bin# top -bn1
   -- Mem: 25812K used, 2088K free, 440K shrd, 2268K buff, 14524K cached
   -- CPU:   9% usr   0% sys   0% nic  90% idle   0% io   0% irq   0% sirq
   -- Load average: 1.31 0.66 0.31 1/64 17803
   -- ...
   r = shell_cmd('top -bn1 | grep "CPU" -m 1| awk \'{print 100-$8}\' | sed -e \'s/%//g\'')
   -- print(r)
   result['data']['cpu_usage'] = r

   -- usage_memory
   -- root@OpenWrt:/www/cgi-bin# free -m
   --              total         used         free       shared      buffers
   -- Mem:         27900        25480         2420          440         2360
   -- -/+ buffers:              23120         4780
   -- Swap:            0            0            0
   r = shell_cmd('free -k | awk \'NR==2{printf \"%s %s %s\", $2,$4,$6}\'')
   -- print(r)
   r1,r2,r3 = r:match("(.*) (.*) (.*)")
   result['data']['mem_usage'] = {}
   result['data']['mem_usage']['total']  = r1
   result['data']['mem_usage']['free']   = r2
   result['data']['mem_usage']['buffer'] = r3

   -- usage_disk
   -- OpenWrt:/www/cgi-bin# df /mnt/sda1
   -- Filesystem           1K-blocks      Used Available Use% Mounted on
   -- /dev/sda1             14789088     56880  13957912   0% /mnt/sda1
   r = shell_cmd('df '..g_usb_mt..' | sed -e \'1d;s/%//g\' | awk \'{print $5}\'')
   -- print(r)
   result['data']['disk_usage'] = r

   -- uptime
   -- root@OpenWrt:/www/cgi-bin# cat /proc/uptime
   -- 8979.39 8201.91
   r = shell_cmd('cat /proc/uptime | awk \'{print $1}\'')
   t1,t2,t3,t4 = sec2DHMS(math.floor(tonumber(r)))
   -- print(r_uptime[1],r_uptime[2],r_uptime[3],r_uptime[4])
   result['data']['uptime'] = {}
   result['data']['uptime']['days']    = t1
   result['data']['uptime']['hours']   = t2
   result['data']['uptime']['minutes'] = t3
   result['data']['uptime']['seconds'] = t4

   -- get_ip
   -- root@OpenWrt:/www/cgi-bin# ifconfig eth0 | awk '/inet /{sub(/[^0-9]*/,""); print $1}'
   -- 192.168.0.9
   r = shell_cmd('ifconfig eth0 | awk \'/inet /{sub(/[^0-9]*/,\"\"); print $1}\'')
   -- print(r)
   result['data']['ip'] = r


   data = read_config(g_local_ver_file)
   if data['FWVER'] then
      result['data']['fw_version'] = data['FWVER']
   end
   if data['KERNEL'] then
      result['data']['kernel_version'] = data['KERNEL']
   end

   luci.http.prepare_content('application/json')
   luci.http.write_json(result)
end


--[[
   json data format
   {"m2muid":"AWX5X28PGRQPMVFEVJV7"}
--]]
function get_m2muid()
   if not api_init() then return end

   local result = response_mock()

   -- root@OpenWrt:/www/cgi-bin# cat /proc/uptime
   -- 8979.39 8201.91
   -- root@OpenWrt:/# /usr/sbin/fw_printenv | grep m2muid
   -- m2muid=testuidtest
   -- root@OpenWrt:/# /usr/sbin/fw_printenv | grep m2muid | awk -F "=" '{print $2}'
   -- testuidtest
   m2muid = shell_cmd('/usr/sbin/fw_printenv | grep m2muid | awk -F "=" \'{print $2}\'')

   if m2muid == nil then m2muid='' end
   result['data']['m2muid'] = m2muid

   luci.http.prepare_content('application/json')
   luci.http.write_json(result)

end


function handle_ls()
   if not api_init() then return end
   if isIB() then return end -- IB mode do nothing

   io.stdout.setvbuf(io.stdout,'full')

   require "nixio"
   require "lfs"

   http_headers = nixio.getenv()
   --[[
   -- print http headers
   for k,v in pairs(http_headers) do
     luci.http.write(k .. ':'.. v .. '\n<br>')
   end
   --]]

   param = http_headers['QUERY_STRING']
   path = param:match("path=(.*)")
   if path == nil or path == "" then path = '/' end

--   luci.http.write(param)
--   luci.http.write(path)

   --g_home = '/mnt/sda1/home/'
   local result = response_mock()

   phy_path = g_home ..get_user_home(get_stok()) .. '/'.. path -- path must ends with '/' -- aaa/
   result['data']['items'] = {}

   if _isdir(phy_path) then -- isdir check()
      for file in lfs.dir(phy_path) do
          if file ~= "." and file ~= ".." then
              local f = phy_path..file
              local attr = lfs.attributes (f)
              assert (type(attr) == "table")

              local item = {}
              item['name'] = file
              item['type'] = attr.mode
              item['permissions'] = attr.permissions
              if attr.mode == "file" then
                  item['mime'] = get_mime(file:match("^.+%.(.+)$"))
                  item['size'] = attr.size
                  item['atime'] = attr.access
                  item['mtime'] = attr.modification
                  item['ctime'] = attr.change
              end

              table.insert(result['data']['items'], item)
          end
      end
   else
     result['code'] = -1
     result['message'] = get_user_home(get_stok()) .. '/'.. path .. ' not exist'
   end

   luci.http.prepare_content('application/json')
   luci.http.write_json(result)

end


-- two-steps upload
-- step one : upload to home with a random file name (unique)
-- step two : move the file from home to its target path
--            if the target file exist, then rename it (backup machine)
function upload()
--   if not api_init() then return end
--   if isIB() then return end -- IB mode do nothing

   require "nixio"

   http_headers = nixio.getenv()

   local fp, path, filename, random_filename
   luci.http.setfilehandler(
      function(meta, chunk, eof) -- meta.file : the filename, meta.name : <input type=\"file\" name=\"upload\>  (upload)
         if not fp then
            filename = meta.file
            random_filename = gen_random_filename()
            param = http_headers['RANGE']

            if param:match("^(0)\-.*") == nil then
               append = true
            else
               append = false
            end

            if append == true then
               local data = read_config(fileuid_map)
               random_filename = data[get_user_home(get_stok())..'/'..filename]

               if random_filename then
                   phy_path = g_home .. random_filename
               end

               fp = io.open(phy_path, "a") -- append to random_filename
            else
               --fp = io.open(g_home .. random_filename, "w")
               append_config(fileuid_map, '\n'..get_user_home(get_stok())..'/'..filename, random_filename)
               fp = io.open(g_home .. random_filename, "w")
            end
         end

         if chunk then
            fp:write(chunk)
         end

         if eof then
            fp:close()
         end
      end
   )

   -- app will NOT send formvalue("upload_file") for the summit input
   -- so DO NOT check the form value
   local upload = luci.http.formvalue("upload")
   local result = response_mock()
   luci.http.prepare_content('application/json')
   if upload and #upload > 0 then
      path = luci.http.formvalue("path")
      if path == nil or path == "" then path = './' end
      if not path:match("(.*)\/") then path = path .. '/' end
      result['data']['path'] = path

      -- create the user directory if the directory not exist
      os.execute('mkdir -p ' .. g_home .. get_user_home(get_stok()) .. '/' .. path)
      --need to check if g_home .. get_user_home(get_stok()) .. '/' ..path .. filename exist
      filename, changed = check_filename(g_home .. get_user_home(get_stok()) .. '/' ..path, filename)
      os.rename(g_home .. random_filename, g_home .. get_user_home(get_stok()) .. '/' ..path .. filename)
      
      del_fileid( fileuid_map, random_filename )

      if changed then
         result['data']['new_filename'] = filename
      end
   else
      result['code'] = -1
      result['message'] = "ERR: upload fail"
   end
   luci.http.write_json(result)

end


function upload_htm()
   if not api_init() then return end
   if isIB() then return end -- IB mode do nothing

  luci.http.prepare_content("text/html")
  luci.http.write("<h1>upload test page</h1>")
  luci.http.write("<form action=\"upload\" method=\"post\" enctype=\"multipart/form-data\">")
  luci.http.write("<input type=\"file\" name=\"upload\" /><br>")
  luci.http.write("path<input type=\"text\" name=\"path\" /><br>")
  luci.http.write("<input type=\"submit\" name=\"upload_file\" value=\"submit\" />")
  luci.http.write("</form>")
end


function download()
   if not api_init() then return end
   if isIB() then return end -- IB mode do nothing

   require "nixio"
   require "lfs"

   http_headers = nixio.getenv()
   --[[
   -- print http headers
   for k,v in pairs(http_headers) do
     print(k, v)
   end
   --]]


   param = http_headers['QUERY_STRING']
   target = param:match("target=(.*)")

   if target == nil then
      local result = response_mock()
      luci.http.prepare_content('application/json')
      result['code'] = -1
      result['message'] = 'parameter - target not found'
      luci.http.write_json(result)
      return -1
   end

   path_filename = target
   phy_path_filename = g_home .. get_user_home(get_stok()) .. '/' .. path_filename

   if lfs.attributes(phy_path_filename) == nil then
      local result = response_mock()
      luci.http.prepare_content('application/json')
      result['code'] = -1
      result['message'] = target .. ' not exist'
      luci.http.write_json(result)
      return -1
   end

   local file_size = lfs.attributes(phy_path_filename,"size")
   local the_mime = get_mime(phy_path_filename:match("^.+%.(.+)$"))

   luci.http.header("Content-Disposition","attachment; filename=\"" .. target .."\"")
   luci.http.prepare_content(the_mime)

   -- HTTP file output
   local size = g_buffer_size -- good buffer size (8K)
   local file = io.open(phy_path_filename,"rb")
   while true do
      local block
      block = file:read(size)
      if not block then break end
      luci.http.write(block)
   end
   file:close()

end


function fw_check()
   if not api_init() then return end

   l_major, l_minor, l_sn, l_year, l_month, l_day = get_local_fw_ver()
   r_major, r_minor, r_sn, r_year, r_month, r_day= get_remote_fw_ver()

   local result = response_mock()
   result['data']['new_fw'] = fw_is_new(l_major, l_minor, l_sn, l_year, l_month, l_day, r_major, r_minor, r_sn, r_year, r_month, r_day)

   luci.http.prepare_content('application/json')

   result['data']['local_ver'] = string.format('%d.%d.%d (%d-%d-%d)', l_major, l_minor, l_sn, l_year, l_month, l_day)
   result['data']['remote_ver'] = string.format('%d.%d.%d (%d-%d-%d)', r_major, r_minor, r_sn, r_year, r_month, r_day)
   luci.http.write_json(result)

end


function fw_upgrade()
   if not api_init() then return end
   if isIB() then return end -- IB mode do nothing

  local result = response_mock()
   luci.http.prepare_content('application/json')

   l_major, l_minor, l_sn, l_year, l_month, l_day = get_local_fw_ver()
   r_major, r_minor, r_sn, r_year, r_month, r_day= get_remote_fw_ver()
   if fw_is_new(l_major, l_minor, l_sn, l_year, l_month, l_day, r_major, r_minor, r_sn, r_year, r_month, r_day) == 'yes' then
        if upgrade_test_ok() then
            luci.http.write_json(result)
            upgrade_run() -- it will reboot system after the upgrade is finished
        else
            result['code'] = -1
            result['message'] = 'Image check \'platform_check_image\' failed'
            luci.http.write_json(result)
        end
   else
      result['code'] = -1
      result['message'] = 'no new firmware avaliable'
      luci.http.write_json(result)
   end

end


function usb_check()
   if not api_init() then return end

   local result = response_mock()
   result['data']['mounted'] = sda_is_mounted()
   luci.http.prepare_content('application/json')
   luci.http.write_json(result)

end


function  init_check()
   local result = response_mock()
   result['data']['initialized'] = _init_check(false) -- not show the error in _init_check()

   luci.http.prepare_content('application/json')
   luci.http.write_json(result)
end


function reg_stok()
   if not _init_check() then return end

   require "nixio"
   http_headers = nixio.getenv()
   param = http_headers['REQUEST_URI']
   appuid = param:match("appuid=(.*)")
   stok = get_stok() --";stok=" .. param:match(";stok=(.*)/apiapp")

   local result = response_mock()
   if appuid then
      result['data']['appuid'] = appuid
      result['data']['stok'] = stok
      local data = read_config(stok_appuid_map)
      if data[stok] == nil then
         append_config(stok_appuid_map, stok, appuid)
         -- create the user directory if the directory not exist
         os.execute('mkdir -p ' .. g_home .. appuid)
      else
         result['code'] = -1
         result['message'] = 'appuid is registered with ' .. data[stok]
      end
   else
      result['code'] = -1
      result['message'] = 'appuid not given'
   end

   luci.http.prepare_content('application/json')
   luci.http.write_json(result)
end


function set_psw()
   local result = response_mock()

   if _init_check(false) then  -- not show the error in _init_check()
      result['code'] = -1
      result['message'] = 'system is initialized'
   else
    require "nixio"
    http_headers = nixio.getenv()
    param = http_headers['QUERY_STRING']
    psw = param:match("psw=(.*)")
    if psw then
       require "luci.sys"
       luci.sys.user.setpasswd('root', psw)

      -- create the initialized file (tag file)
      os.execute('touch ' .. init_file)
    else
       result['code'] = -1
       result['message'] = 'password not given'
    end
   end

   luci.http.prepare_content('application/json')
   luci.http.write_json(result)
end

function getuid()
   local result = response_mock()
   require "nixio"

   local random_filename
   http_headers = nixio.getenv()

--[[
   for k,v in pairs(http_headers) do
     r = shell_cmd('echo '..k..':'..v..' >> /tmp/res.txt')
   end
--]]
   param = http_headers['REQUEST_URI']
   filename = param:match("filename=(.*)")

   user_home = get_user_home(get_stok())

   local data = read_config(fileuid_map)
   if data[user_home..'/'..filename] then 

       local data = read_config(fileuid_map)
       random_filename = data[user_home..'/'..filename]
       if random_filename then
           phy_path = g_home .. random_filename
       end

       require "lfs"
       local attr = lfs.attributes (phy_path)
       assert (type(attr) == "table")
       range = attr.size
   else
       range = 0
       random_filename = 'none'
   end

   result['data']['range'] = range
   result['data']['random_filename'] = random_filename
  
   luci.http.prepare_content('application/json')
   luci.http.write_json(result)
end

-----------------------------------------------------------------------
-- API {end}
-----------------------------------------------------------------------
