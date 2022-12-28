/*
jQuery v1.11.1 | (c) 2005, 2014 jQuery Foundation, Inc. | jquery.org/license
(MIT License)

jquery.rest.js is Copyright © 2014 Jaime Pillora dev@jpillora.com under MIT License
https://github.com/jpillora/jquery.rest

jQuery BlockUI Plugin is Copyright © 2007-2013 M. Alsup. under MiT and GPL License
https://github.com/malsup/blockui/

NVR UI is developed by Realtek @ 2016
Realtek All rights reserved.
*/
var CHN = 4; //default is 4 channel
function info_show(){
	var client = new $.RestClient('/api/');
	client.add('info');

	client.info.read().done(
	  function (data){
		//alert('I have data: ' + data.fw + data.nvr + data.platform + data.model);
		if (data.channel)
            CHN = data.channel;
		var str = '';
		str = '<table border="0">';
		str = str + '<tr><td><b>Platform:</b></td><td><b> ' + data.platform + '</b></td></tr>';
		str = str + '<tr><td><b>Product Model:</b></td><td><b>  ' + data.model + '</b></td></tr>';
		str = str + '<tr><td><b>Firmware Version:</b></td><td><b>  ' + data.fw + '</b></td></tr>';
		str = str + '<tr><td><b>NVR Version:</b></td><td><b>  ' +  data.nvr + '</b></td></tr>';
		str = str + '<tr><td><b>Channel:</b></td><td><b>  ' + data.channel + '</b></td></tr>';
		str = str + '</table>';
		 //$('#showInfo').append(str); // add new content
	 $('#showInfo').html(str); // update old content
		}
	);
}

//cannot update the changed-password et. all
function btn_list_update(no) {
	//alert(data_b64);
	////alert($('#ipcam_name_' + no).val());
	var data = new Object();
	data.name = $('#ipcam_name_' + no).val();
	data.user = $('#ipcam_user_' + no).val();
	data.passwd = $('#ipcam_passwd_' + no).val();
	data.streamuri = $('#ipcam_streamuri_' + no).val();
  ////alert(data.streamuri);
   // WaitToCompleteUI('start');
	var client = new $.RestClient('/api/');

	client.add('ipcam', {stringifyData: true}); //Important --> to enable send data as json format

	client.ipcam.update('list/' + no, data);
    alert('data is updated');
    //WaitToCompleteUI('stop');
};

function ipcamlist_show(){
	var client = new $.RestClient('/api/');

	client.add('ipcam', {stringifyData: true}); //Important --> to enable send data as json format
	//client.ipcam.add('list');

	client.ipcam.read('list').done(
	  function (data){
		var str = '';
		str = '<table border="1"><tr><th>no</th><th>name</th><th>user</th><th>password</th><th>streamuri</th><th></th></tr>';

		for (var x in data) {
		  str = str + '<tr>';
		  str = str + '<td>' + x + '</td>';
		  str = str + '<td><input id="ipcam_name_'+ x + '" value="' + data[x].name + '" size="' + data[x].name.length + '"/></td>';
		  //str = str + '<td><input name="ipcam_name_1" value="ipcam1"/></td>';
		  str = str + '<td><input id="ipcam_user_'+ x + '" value="' + data[x].user + '" size="' + data[x].user.length + '"/></td>';
		  //str = str + '<td><b>' + data[x].user + '</b></td>';
		  str = str + '<td><input id="ipcam_passwd_'+ x + '" value="' + data[x].passwd + '" size="' + data[x].passwd.length + '"/></td>';
		  //str = str + '<td><b>' + data[x].passwd + '</b></td>';
		  str = str + '<td><input id="ipcam_streamuri_'+ x + '" value="' + data[x].streamuri + '" size="' + data[x].streamuri.length + '"/></td>';
	  //alert(data[x].name.length);
		  //str = str + '<td><b>' + data[x].streamuri + '</b></td>';
	  //alert(s); //atob(JSON.stringify(data[x])));
	  //alert(btoa(s));
		  str = str + '<td><input type="button" id="btn_list_update" onclick="btn_list_update(' + x + ')" value="Update" />';
		  str = str + '</tr>';
		}
		str = str + '</table>';
		 //$('#showIPCamList').append(str); //add new content
	 $('#showIPCamList').html(str); //update old content
	   //alert('list refresh done');
	  }
	);
//	alert('IP Camera List shown');
}

function ipcam_discovery(){
	var client = new $.RestClient('/api/');

    WaitToCompleteUI('start');

	client.add('ipcam', {stringifyData: true}); //Important --> to enable send data as json format

	client.ipcam.read('discovery').done(
	  function (data){
	  str = '<table border="1"> <tr><th>IP address</th><th>user</th><th>password</th><th></th><th>StreamUri</th></tr>';
	  for (var x in data.ip_list) {
		var default_user = 'admin', default_passwd = '123456';
		str = str + '<tr>';
		str = str + '<td>' + data.ip_list[x] + '</td>';
		  user_id = 'ipcam_discovery_user'+ x;
			password_id = 'ipcam_discovery_passwd'+ x ;
			str = str + '<td><input id="' + user_id + '" value="' + default_user + '" size="' + default_user.length + '"/></td>';
			str = str + '<td><input id="' + password_id + '" value="' + default_passwd + '" size="' + default_passwd.length + '"/></td>';
			str = str + '<td><input type="button" id="btn_getprofiles'+ x + '" onclick="btn_getallstreamuri(' + x + ',\'' + data.ip_list[x] + '\',' + user_id + ',' + password_id + ')" value="GetAllStreamUri" />';
		str = str + '<td><div id="showStreamUri_' + x + '"></td>';
		str = str + '</tr>';
	  }
	  str = str + '</table>';
	   //$('#showIPCamFound').append(str); // add new content
	   $('#showIPCamFound').html(str); // update old content
	   ////alert('output refresh done');
        WaitToCompleteUI('stop');
    }
	);
};

function btn_setipcam(dst_id, data_id, user_id, password_id) {

   ipcam_no = $(dst_id).val();
   streamuri = $(data_id).val();
   user = $(user_id).val();
   password = $(password_id).val();

/*		alert(ipcam_no);
		alert(streamuri);
		alert(user+":"+password);
*/
	  $('#ipcam_user_'+ ipcam_no).val(user);
	  $('#ipcam_passwd_'+ ipcam_no).val(password);
	  $('#ipcam_streamuri_'+ ipcam_no).val(streamuri);

}


function btn_getallstreamuri(no, ip, user_id, password_id) {

/*   alert(no);
   alert(ip);
   alert(user_id.id);
   alert(password_id.id);
*/
	var client = new $.RestClient('/api/');

    WaitToCompleteUI('start');

	client.add('ipcam', {stringifyData: true}); //Important --> to enable send data as json format

	user = $(user_id).val();
	password = $(password_id).val();
	//default user/password
	if (!user)
	   user = 'admin';
	if (!password)
	   password = '123456';
	//alert(user+":"+password);

  client.ipcam.read('allstreamuri/'+ip, {"user":user, "passwd":password}).done(
	  function (data){
		str = '<table border="1">';
		for (var x in data) {
		  str = str + '<tr>';
			streamuri_id = 'setipcam_' + Math.round(new Date().getTime() + (Math.random() * 100));//generate a unique id
		  str = str + '<td><input id="' + streamuri_id + '" value="' + data[x] + '" size="' + data[x].length +'"/></td>';

			target_id = 'setipcam_' + Math.round(new Date().getTime() + (Math.random() * 100));//generate a unique id
			str = str + '<td><input type="button" id="btn_' + target_id + '" onclick="btn_setipcam(' + target_id + ',' + streamuri_id + ',' + user_id.id + ',' + password_id.id + ')" value="Copy to" />';

			str_select = '<select id="'  + target_id + '">';
			for (var i=1; i<=CHN; i++){
				str_select = str_select + '<option value=' + i + '>no.' + i + '</option>';
			}
			str_select = str_select + '</select>';
		  str = str + '<td>' + str_select + '</td>';

		  str = str + '</tr>';
		}
		str = str + '</table>';
		 //$('#showIPCamStreamUri').append(str); // add new content
		 $('#showStreamUri_' + no).html(str); // update old content
		////alert('getallstreamuri' + data + 'done');
        WaitToCompleteUI('stop');
	  }
	  );
};


function ipcam_streaming(op) {
 // alert('ipcam_streaming '+op);
//	//alert(data);
	var client = new $.RestClient('/api/');

	client.add('ipcam', {stringifyData: true}); //Important --> to enable send data as json format

	if (op=='start'){
			client.ipcam.update('streaming').done(
	  function (data){
				alert('streaming start');
			}
	  );
	}
	else if (op == 'stop') {
			client.ipcam.destroy('streaming').done(
	  function (data){
				alert('streaming stop');
			}
			);
	}
	else
	{
		alert(op + ' is not a valid operation');
	}

};

function ipcam_recording(op){
  //alert('ipcam_recording '+op);
 // alert('ipcam_streaming '+op);
//	//alert(data);
	var client = new $.RestClient('/api/');

	client.add('ipcam', {stringifyData: true}); //Important --> to enable send data as json format

	if (op=='start'){
			client.ipcam.update('recording').done(
	  function (data){
				alert('recording start');
			}
	  );
	}
	else if (op == 'stop') {
			client.ipcam.destroy('recording').done(
	  function (data){
				alert('recording stop');
			}
			);
	}
	else
	{
		alert(op + ' is not a valid operation');
	}
};


function ipcam_playback(op){
  alert('ipcam_playback '+ op + ' under construction');
};

function WaitToCompleteUI(op){

	if (op=='start'){
        $.blockUI({
        message: '<table><tr><td valign="middle" style="height:50px" class="main"><img src="img/working.gif" /> Please Wait...</td></tr></table>',
        css: {
        width: '250px',
        height: '150px'
        }
        });
	}
	else if (op == 'stop') {
        $.unblockUI();
	}
	else
	{
		alert(op + ' is not a valid operation');
	}
}

function checkStreamingService(){
	var client = new $.RestClient('/api/');
	client.add('ipcam');

	client.ipcam.read('streaming').done(
	  function (data){
		//alert('I have data: ' + data.fw + data.nvr + data.platform + data.model);
        status = 'stop';
		if (data.service)
            status = data.service;
		var str = '';
		str = '<table border="0">';
		str = str + '<tr><td><b>Status:</b></td><td><b> ' + status + '</b></td></tr>';
		str = str + '</table>';
		 //$('#showInfo').append(str); // add new content
	 $('#statusStreaming').html(str); // update old content
		}
	);
}
function checkRecordingService(){
	var client = new $.RestClient('/api/');
	client.add('ipcam');

	client.ipcam.read('recording').done(
	  function (data){
		//alert('I have data: ' + data.fw + data.nvr + data.platform + data.model);
        status = 'stop';
		if (data.service)
            status = data.service;
		var str = '';
		str = '<table border="0">';
		str = str + '<tr><td><b>Status:</b></td><td><b> ' + status + '</b></td></tr>';
		str = str + '</table>';
		 //$('#showInfo').append(str); // add new content
	 $('#statusRecording').html(str); // update old content
		}
	);
}

//Initial functions
	info_show();
	ipcamlist_show();
    checkStreamingService();
    checkRecordingService();

// schedule to check service status
    setInterval(checkStreamingService, 3000);
    setInterval(checkRecordingService, 3000);
