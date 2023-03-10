#include <stdio.h>     
#include <sys/socket.h> 
#include <arpa/inet.h>  
#include <stdlib.h>     
#include <string.h>    
#include <unistd.h>     
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctype.h>
#include "CWVendorPayloads.h"

#include "wumLib.h"

#define SA const struct sockaddr
#define BUF_SIZE 1024

int Readn(int fd, void *ptr, size_t nbytes);
int Writen(int fd, void *ptr, size_t nbytes);
void readWTPInfo(int acserver, struct WTPInfo *WTPInfo, int pos);

#define WUM_INIT_REQ_MSG(msg, size) do { msg.payload_len = 0; msg.payload=malloc(size); } while(0);
#define WUM_DESTROY_MSG(msg)  do { if (msg.payload) free(msg.payload); } while(0);

int Read32(int fd, int *ptr);
int Write32(int fd, void *ptr);
int WUMSendMessage(int acserver, wum_req_t msg);
int WUMReceiveMessageHeader(int acserver, wum_resp_t *msg);
int WUMReceiveMessage(int acserver, wum_resp_t *msg);
char WUMPayloadRetrieve8(wum_resp_t *resp);
void WUMPayloadStore8(wum_req_t *req, char c);
void WUMPayloadStore32(wum_req_t *req, int i);
void WUMPayloadStoreRawBytes(wum_req_t *req, const void *buf, int size);

#define MIN(a,b) (a < b) ? (a) : (b)

int ACServerConnect(char *address, int port)
{
	int sockfd, ret;
	struct sockaddr_in servaddr;
	
	if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		perror("socket error:");
		exit(1);
	}

	bzero(&servaddr, sizeof (struct sockaddr_in));
	servaddr.sin_family = AF_INET;
	servaddr.sin_port = htons(port);
	inet_pton(AF_INET, address, &servaddr.sin_addr);

	if (connect(sockfd, (SA*) &servaddr, sizeof(servaddr)) < 0) {
		perror("connect error:");
		exit(1);
	}

	if (Read32(sockfd, &ret) != 4) {
		exit(1);
	}

	if (ret == -1) {
		fprintf(stderr, "The AC Server's Client Queue Is Currently Full.\n");
		exit(1);
	} else if (ret != 1) {
		fprintf(stderr, "Something Wrong Happened While Connecting To The AC Server.\n");
		exit(1);
	}	

	return sockfd;
}

void ACServerDisconnect(int acserver)
{
	char msg = QUIT_MSG;
	if (Writen(acserver, &msg, 1) != 1) {
		fprintf(stderr, "Error while sending QUIT message.\n");
	}
	
	if (close(acserver) < 0) {
		perror("close error:");
	}
}

struct WTPInfo *ACServerWTPList(int acserver, int *nWTPs) 
{
	char msg = LIST_WTPS_MSG;
	int activeWTPs, i;
	struct WTPInfo *WTPList;

	if (Writen(acserver, &msg, 1) != 1) {
		fprintf(stderr, "Error while sending LIST message.\n");
		return NULL;
	}

	if (Read32(acserver, &activeWTPs) != 4) {
		fprintf(stderr, "Error while receiving WTP Number.\n");
		return NULL;
	}

	if ((WTPList = malloc(activeWTPs*sizeof(struct WTPInfo))) == NULL) {
		perror("malloc error");
		return NULL;
	}

	for (i = 0; i < activeWTPs; i++) {
		readWTPInfo(acserver, WTPList, i);
	}

	*nWTPs = activeWTPs; 
	return WTPList;
}

CWRtkStationValues *ACServerStationsList(int acserver, int wtp_id, int *nStations) 
{
	char msg[3];
	int activeStations;
	CWRtkStationValues *StationList;
	
	msg[0]= LIST_WTP_INFO_MSG;
	msg[1]= MSG_ELEMENT_TYPE_LIST_STATION;	
	msg[2]= wtp_id;
	if (Writen(acserver, &msg, 3) != 3) {
		fprintf(stderr, "Error while sending STATION LIST message.\n");
		return NULL;
	}

#ifdef KM_BY_AC
	if (Read32(acserver, &activeStations) != 4) {
		fprintf(stderr, "Error while receiving Station Number.\n");
		return NULL;
	}

	if (activeStations) {
		if ((StationList = malloc(activeStations*sizeof(CWRtkStationValues))) == NULL) {
			perror("malloc error");
			return NULL;
		}
		Readn(acserver, StationList, activeStations*sizeof(CWRtkStationValues));
	} else {
		return NULL;
	}
#else
	wum_resp_t resp;
	
	if (WUMReceiveMessage(acserver, &resp) != SUCCESS) {
		fprintf(stderr, "%s Error while reading response message\n", __FUNCTION__);
		return NULL;
	}

	if (resp.resultCode != CW_PROTOCOL_SUCCESS) {
		printf("%s\n", resp.payload);
		return NULL;
	}
	activeStations = *(int *)resp.payload;
	StationList = (CWRtkStationValues *)(resp.payload+sizeof(int));	

	WUM_DESTROY_MSG(resp);
#endif
	*nStations = activeStations; 
	return StationList;

}

void readWTPInfo(int acserver, struct WTPInfo *WTPInfo, int pos)
{
	int nameLen;

	if (Read32(acserver, &(WTPInfo[pos].wtpId)) != 4) {
		fprintf(stderr, "Error while reading wtp index.\n");
		goto err;
	}
	
	if (Read32(acserver, (int *)&(WTPInfo[pos].currentState)) != 4) {
		fprintf(stderr, "Error while reading wtp state.\n");
		goto err;
	}
	
	if (Read32(acserver, (int *)&(WTPInfo[pos].echoRequestCounter)) != 4) {
		fprintf(stderr, "Error while reading wtp echo req/resp count.\n");
		goto err;
	}
	
	if (Read32(acserver, (int *)&(WTPInfo[pos].lastEchoRequestTime)) != 4) {
		fprintf(stderr, "Error while reading wtp last echo req/resp time.\n");
		goto err;
	}
	
	if (Read32(acserver, &nameLen) != 4) {
		fprintf(stderr, "Error while reading wtp name len.\n");
		goto err;
	}

	if ((WTPInfo[pos].name = malloc(nameLen+1)) == NULL) {
		fprintf(stderr, "Malloc error\n");
		goto err;
	}

	if (Readn(acserver, WTPInfo[pos].name, nameLen) != nameLen) {
		fprintf(stderr, "Error while reading wtp name len.\n");
		goto err;
	}

	WTPInfo[pos].name[nameLen] = '\0';
	return;

err:
	ACServerDisconnect(acserver);
	exit(1);		
}

void freeWTPList(struct WTPInfo *wtpList, int nWTPs)
{
	int i;
	/* We do not free the first name, the default one */
	for (i = 0; i < nWTPs; i++) {
		free(wtpList[i].name);
	}
	free(wtpList);
}

int WUMGetWTPVersion(int acserver, int wtpId, struct version_info *v_info)
{
	wum_req_t msg;
	wum_resp_t resp;

	WUM_INIT_REQ_MSG(msg, 0);
	msg.cmd_msg = CONF_UPDATE_MSG;
	msg.msg_elem = MSG_ELEMENT_TYPE_VENDOR_WUM;
	msg.wtpId = wtpId;
	msg.wum_type = WTP_VERSION_REQUEST; 

	if (WUMSendMessage(acserver, msg) != 0) {
		fprintf(stderr, "Error while sending WUM message");
		return ERROR;
	}

	if (WUMReceiveMessage(acserver, &resp) != 0) {
		fprintf(stderr, "Error while reading response message");
		return ERROR;
	}

	resp.wum_type = WUMPayloadRetrieve8(&resp);
	if (resp.wum_type != WTP_VERSION_RESPONSE) {
		fprintf(stderr, "Received wrong response message!");
		return ERROR;
	}

	v_info->major = WUMPayloadRetrieve8(&resp);
	v_info->minor = WUMPayloadRetrieve8(&resp);
	v_info->revision = WUMPayloadRetrieve8(&resp); 
	
	return SUCCESS;
}

void StringToLower(char *str)
{
	for(; *str != '\0'; str++)
		*str = tolower(*str);
}

int WUMReadCupVersion(char *cup_pathname, struct version_info *update_v)
{
	int ret;
	char buf[BUF_SIZE];
	char *token;
	struct stat s_buf;
	FILE *cud=NULL;
	
	snprintf(buf, BUF_SIZE, "tar xzf %s -C /tmp update.cud", cup_pathname);
	
	ret = system(buf);
	
	if (ret != 0) return ERROR;
	
	cud = fopen("/tmp/update.cud", "r");
	if (cud == NULL) {
		fprintf(stderr, "Error while opening cud descriptor.\n");
		return ERROR;
	}
	
	while (fgets(buf, BUF_SIZE, cud) != NULL) {
        token = strtok(buf, " ");
		StringToLower(token);	
		if (strncmp(token, "version", 7) == 0) {
		    token = strtok(NULL, " ");
		    if (token == NULL) {
    	            fprintf(stderr, "Error while parsing update version.");
		    if(cud!=NULL)
		    {
		    		//printf("%s:%d####fclose(cud)!!!!",__FUNCTION__,__LINE__);
				fclose(cud);
		    }
    	            return ERROR;
		    }
		    
		    token = strtok(token, ".");
		    update_v->major = atoi(token);
		   	token = strtok(NULL, ".");
		    update_v->minor = atoi(token);	
		    token = strtok(NULL, ".");
		    update_v->revision = atoi(token);	 	
    	}
	}
	
	fclose(cud);
	remove("/tmp/update.cud");
	
	if (stat(cup_pathname, &s_buf) != 0) {
		fprintf(stderr, "Stat error!.\n");
		return ERROR;
	}
	
	update_v->size = s_buf.st_size;
	
	return SUCCESS;
}

int WUMSendCommitRequest(int acserver, int wtpId)
{
	wum_req_t msg;
	wum_resp_t resp;

	WUM_INIT_REQ_MSG(msg, 0);
	msg.cmd_msg = CONF_UPDATE_MSG;
	msg.msg_elem = MSG_ELEMENT_TYPE_VENDOR_WUM;
	msg.wtpId = wtpId;
	msg.wum_type = WTP_COMMIT_UPDATE; 

	if (WUMSendMessage(acserver, msg) != 0) {
		fprintf(stderr, "Error while sending WUM message");
		return ERROR;
	}

	if (WUMReceiveMessage(acserver, &resp) != 0) {
		fprintf(stderr, "Error while reading response message");
		return ERROR;
	}

	resp.wum_type = WUMPayloadRetrieve8(&resp);
	if (resp.wum_type != WTP_COMMIT_ACK) {
		fprintf(stderr, "Received wrong response message!");
		return ERROR;
	}
	
	return resp.resultCode;
}


int WUMSendCancelRequest(int acserver, int wtpId)
{
	wum_req_t msg;
	wum_resp_t resp;

	WUM_INIT_REQ_MSG(msg, 0);
	msg.cmd_msg = CONF_UPDATE_MSG;
	msg.msg_elem = MSG_ELEMENT_TYPE_VENDOR_WUM;
	msg.wtpId = wtpId;
	msg.wum_type = WTP_CANCEL_UPDATE_REQUEST; 

	if (WUMSendMessage(acserver, msg) != 0) {
		fprintf(stderr, "Error while sending WUM message");
		return ERROR;
	}

	if (WUMReceiveMessage(acserver, &resp) != 0) {
		fprintf(stderr, "Error while reading response message");
		return ERROR;
	}

	resp.wum_type = WUMPayloadRetrieve8(&resp);
	if (resp.wum_type != WTP_CANCEL_UPDATE_RESPONSE) {
		fprintf(stderr, "Received wrong response message!");
		return ERROR;
	}
	
	return resp.resultCode;
}

int WUMSendFragment(int acserver, int wtpId, void *buf, int size, int seq)
{
	wum_req_t msg;
	wum_resp_t resp;

	WUM_INIT_REQ_MSG(msg, size+2*sizeof(int));
	msg.cmd_msg = CONF_UPDATE_MSG;
	msg.msg_elem = MSG_ELEMENT_TYPE_VENDOR_WUM;
	msg.wtpId = wtpId;
	msg.wum_type = WTP_CUP_FRAGMENT; 

	WUMPayloadStore32(&msg, seq);	
	WUMPayloadStore32(&msg, size);
	WUMPayloadStoreRawBytes(&msg, buf, size);

	if (WUMSendMessage(acserver, msg) != 0) {
		fprintf(stderr, "Error while sending WUM message");
		return ERROR;
	}

	if (WUMReceiveMessage(acserver, &resp) != 0) {
		fprintf(stderr, "Error while reading response message");
		return ERROR;
	}

	resp.wum_type = WUMPayloadRetrieve8(&resp);
	if (resp.wum_type != WTP_CUP_ACK) {
		fprintf(stderr, "Received wrong response message!");
		return ERROR;
	}
	
	WUM_DESTROY_MSG(msg);
	return resp.resultCode;
}

int WUMUpdate(int acserver, int wtpId, void *cup_buf, struct version_info update_v)
{
	int i, left, toSend, sent;
	
	if (WUMSendUpdateRequest(acserver, wtpId, update_v)) {
		fprintf(stderr, "Update request failed for WTP: %d\n", wtpId);
		return ERROR;
	}
	
	/* Send update fragments */
	sent = 0;
	left = update_v.size;
	toSend = MIN(FRAGMENT_SIZE, left);
	for (i = 0; left > 0; i++) {
		if (WUMSendFragment(acserver, wtpId, cup_buf + sent, toSend, i)) {
			fprintf(stderr, "Error while sending fragment #%d\n", i);
			return ERROR;
		}
		left -= toSend;
		sent += toSend;
		toSend = MIN(FRAGMENT_SIZE, left);	
	} 
	
	if (WUMSendCommitRequest(acserver, wtpId)) {
		fprintf(stderr, "Update request failed for WTP: %d\n", wtpId);
		return ERROR;
	}	
	
	return SUCCESS;
}

int WUMSendUpdateRequest(int acserver, int wtpId, struct version_info update_v)
{
	wum_req_t msg;
	wum_resp_t resp;

	WUM_INIT_REQ_MSG(msg, 3 + sizeof(int));
	msg.cmd_msg = CONF_UPDATE_MSG;
	msg.msg_elem = MSG_ELEMENT_TYPE_VENDOR_WUM;
	msg.wtpId = wtpId;
	msg.wum_type = WTP_UPDATE_REQUEST; 	

	WUMPayloadStore8(&msg, update_v.major);
	WUMPayloadStore8(&msg, update_v.minor);
	WUMPayloadStore8(&msg, update_v.revision);
	WUMPayloadStore32(&msg, update_v.size);

	if (WUMSendMessage(acserver, msg) != 0) {
		fprintf(stderr, "Error while sending WUM message");
		return ERROR;
	}

	if (WUMReceiveMessage(acserver, &resp) != 0) {
		fprintf(stderr, "Error while reading response message");
		return ERROR;
	}
	
	WUM_DESTROY_MSG(msg)
	return resp.resultCode;

}

int WUMKickStation(int acserver, int wtpId, const unsigned char *mac)
{
	wum_req_t msg;
	wum_resp_t resp;
	int ret;

	WUM_INIT_REQ_MSG(msg, 6);
	msg.cmd_msg = CONF_UPDATE_MSG;
	msg.msg_elem = MSG_ELEMENT_TYPE_DEL_STATION;
	msg.wtpId = wtpId;
	msg.wum_type = WTP_UPDATE_REQUEST;	

	WUMPayloadStoreRawBytes(&msg, mac, 6);

	if (WUMSendMessage(acserver, msg) != SUCCESS) {
		fprintf(stderr, "%s Error while sending WUM message\n", __FUNCTION__);
		return ERROR;
	}
	WUM_DESTROY_MSG(msg);

	if (WUMReceiveMessage(acserver, &resp) != SUCCESS) {
		fprintf(stderr, "%s Error while reading response message\n", __FUNCTION__);
		return ERROR;
	}

	if (resp.payload) printf(resp.payload);
	ret = resp.resultCode;
	WUM_DESTROY_MSG(resp);
	return ret;

}

int WUMChangeImage(int acserver, int wtpId, const char *image_version)
{
	wum_req_t msg;
	wum_resp_t resp;
	int len;
	int ret;

	WUM_INIT_REQ_MSG(msg, strlen(image_version)+1);
	msg.cmd_msg = CONF_UPDATE_MSG;
	msg.msg_elem = MSG_ELEMENT_TYPE_IMAGE_ID;
	msg.wtpId = wtpId;
	msg.wum_type = WTP_UPDATE_REQUEST; 	// ignored

	len = strlen(image_version)+1;
	//length
	WUMPayloadStoreRawBytes(&msg, &len, sizeof(len));

	//image_version
	WUMPayloadStoreRawBytes(&msg, image_version, len);

	if (WUMSendMessage(acserver, msg) != SUCCESS) {
		fprintf(stderr, "%s Error while sending WUM message\n", __FUNCTION__);
		return ERROR;
	}
	WUM_DESTROY_MSG(msg);

	if (WUMReceiveMessage(acserver, &resp) != SUCCESS) {
		fprintf(stderr, "%s Error while reading response message\n", __FUNCTION__);
		return ERROR;
	}

	
	ret = resp.resultCode;
	if (resp.payload) printf(resp.payload);
	WUM_DESTROY_MSG(resp);

	return ret;

}


CWRtkSiteSurveyValues *WUMSiteSurvey(int acserver, int wtpId, int *nSite, char *msgBuf)
{

	char msg[3];
	wum_resp_t resp;
	CWRtkSiteSurveyValues *siteSurvey = NULL;

	msg[0]= LIST_WTP_INFO_MSG;
	msg[1]= MSG_ELEMENT_TYPE_LIST_SITE_SURVEY;	
	msg[2]= wtpId;
	if (Writen(acserver, &msg, 3) != 3) {
		fprintf(stderr, "Error while sending Site Survey message.\n");
		return NULL;
	}

	// ............................
	msgBuf[0] = '\0';
	if (WUMReceiveMessageHeader(acserver, &resp) != 0) {
		fprintf(stderr, "Error while reading response message\n");
		return NULL;
	}
	
	if (resp.resultCode != CW_PROTOCOL_SUCCESS) {
		if (Readn(acserver, msgBuf, resp.payload_len) < 0) {
			fprintf(stderr, "Error while reading message from WTP\n");
			return NULL;
		}
	} else {
		char n;
		int i; 
		int left_len = resp.payload_len;
		if (left_len < 1) {
			fprintf(stderr, "Error while reading site survey information from WTP(line: %d)\n", __LINE__);
			return NULL;
		}
		// to read nSite
		if ( Readn(acserver, &n, 1) < 0 ) {
			fprintf(stderr, "Error while reading site survey information from WTP(line: %d)\n", __LINE__);
			return NULL;
		}
		*nSite = n;
		left_len -= 1;

		// to read site survey
		if (n>0) {
			siteSurvey = calloc(n, sizeof(CWRtkSiteSurveyValues));
			for (i=0; i<n; i++) {
				// read site survey radioID & numBss
				if (left_len < 2){
					fprintf(stderr, "Error while reading site survey information from WTP(line: %d)\n", __LINE__);
					free(siteSurvey);
					return NULL;
				}
				if ( Readn(acserver, &siteSurvey[i].radioID, 1) <0 ) {
					fprintf(stderr, "Error while reading site survey information from WTP(line: %d)\n", __LINE__);
					free(siteSurvey);
					return NULL;
				}
				if ( Readn(acserver, &siteSurvey[i].numBss, 1) <0 ) {
					fprintf(stderr, "Error while reading site survey information from WTP(line: %d)\n", __LINE__);
					free(siteSurvey);
					return NULL;
				}
				left_len -= 2;

				// read bssInfo
				int bytes = siteSurvey[i].numBss * sizeof(rtk_bss_t);
				if (left_len < bytes){
					fprintf(stderr, "Error while reading site survey information from WTP(line: %d)\n", __LINE__);
					free(siteSurvey);
					return NULL;
				}
				if ( Readn(acserver, &siteSurvey[i].bssInfo, bytes) <0 ) {
					fprintf(stderr, "Error while reading site survey information from WTP(line: %d)\n", __LINE__);
					free(siteSurvey);
					return NULL;
				}
				left_len -= bytes;
			}
		}
		if (left_len != 0) {
			printf("Error: left_len!=0\n");
		}
	}
	
	//WUM_DESTROY_MSG(resp);
	return siteSurvey;
}

int wumUpdatePower(int acserver, int wtpId, unsigned char radioId, unsigned char power)
{
	wum_req_t msg;
	wum_resp_t resp;
	int ret;


	WUM_INIT_REQ_MSG(msg, 2);
	msg.cmd_msg = CONF_UPDATE_MSG;
	msg.msg_elem = MSG_ELEMENT_TYPE_UPD_POWER;
	msg.wtpId = wtpId;
	msg.wum_type = 0; // ignored

	WUMPayloadStoreRawBytes(&msg, &radioId, sizeof(radioId));
	WUMPayloadStoreRawBytes(&msg, &power, sizeof(power));

	if (WUMSendMessage(acserver, msg) != SUCCESS) {
		fprintf(stderr, "%s Error while sending WUM message\n", __FUNCTION__);
		return ERROR;
	}
	WUM_DESTROY_MSG(msg);

	if (WUMReceiveMessage(acserver, &resp) != SUCCESS) {
		fprintf(stderr, "%s Error while reading response message\n", __FUNCTION__);
		return ERROR;
	}

	if (resp.payload) printf(resp.payload);
	ret = resp.resultCode;
	WUM_DESTROY_MSG(resp);

	return ret;
}

int wumUpdateChannel(int acserver, int wtpId, unsigned char radioId, unsigned char channel)
{
	wum_req_t msg;
	wum_resp_t resp;
	int ret;

	WUM_INIT_REQ_MSG(msg, 2);
	msg.cmd_msg = CONF_UPDATE_MSG;
	msg.msg_elem = MSG_ELEMENT_TYPE_UPD_CHANNEL;
	msg.wtpId = wtpId;
	msg.wum_type = 0; // ignored

	WUMPayloadStoreRawBytes(&msg, &radioId, sizeof(radioId));
	WUMPayloadStoreRawBytes(&msg, &channel, sizeof(channel));

	if (WUMSendMessage(acserver, msg) != SUCCESS) {
		fprintf(stderr, "%s Error while sending WUM message\n", __FUNCTION__);
		return ERROR;
	}
	WUM_DESTROY_MSG(msg);

	if (WUMReceiveMessage(acserver, &resp) != SUCCESS) {
		fprintf(stderr, "%s Error while reading response message\n", __FUNCTION__);
		return ERROR;
	}

	if (resp.payload) printf(resp.payload);
	ret = resp.resultCode;
	WUM_DESTROY_MSG(resp);

	return ret;
}
int WUMSendMessage(int acserver, wum_req_t msg)
{
	/* Fix byte order issues */
	msg.wtpId = htonl(msg.wtpId);
	if (Writen(acserver, &msg, 7) != 7) {
		fprintf(stderr, "Error while sending CONF_UPDATE_MSG message.\n");
		return ERROR;
	}
	if (msg.payload_len > 0) {
		if (Writen(acserver, msg.payload, msg.payload_len) != msg.payload_len) {
			fprintf(stderr, "Error while sending CONF_UPDATE_MSG message.\n");
			return ERROR;
		}
	}
	
	return SUCCESS;
}
int WUMReceiveMessageHeader(int acserver, wum_resp_t *msg)
{
	msg->offset = 0;

	if (Read32(acserver, &(msg->wtpId)) != 4) {
		fprintf(stderr, "Error while reading wtpId.\n");
		return ERROR;
	}
	if (Read32(acserver, &(msg->resultCode)) != 4) {
		fprintf(stderr, "Error while reading result code.\n");
		return ERROR;
	}
	if (Read32(acserver, &(msg->payload_len)) != 4) {
		fprintf(stderr, "Error while reading payload length.\n");
		return ERROR;
	}
	return SUCCESS;
}

int WUMReceiveMessage(int acserver, wum_resp_t *msg)
{
	msg->offset = 0;
	if (Read32(acserver, &(msg->wtpId)) != 4) {
		fprintf(stderr, "Error while reading wtpId.\n");
		return ERROR;
	}
	if (Read32(acserver, &(msg->resultCode)) != 4) {
		fprintf(stderr, "Error while reading result code.\n");
		return ERROR;
	}
	if (Read32(acserver, &(msg->payload_len)) != 4) {
		fprintf(stderr, "Error while reading payload length.\n");
		return ERROR;
	}

	if (msg->payload_len > 0) {
		msg->payload = malloc(msg->payload_len);
		if (Readn(acserver, msg->payload, msg->payload_len) != msg->payload_len) {
			fprintf(stderr, "Error while reading payload.\n");
			return ERROR;
		}
	} else {
		msg->payload = NULL;
	}

	return SUCCESS;
}

char WUMPayloadRetrieve8(wum_resp_t *resp)
{
	return resp->payload[resp->offset++];
}

void WUMPayloadStore8(wum_req_t *req, char c)
{
	req->payload[req->payload_len++] = c;
}

void WUMPayloadStore32(wum_req_t *req, int i)
{
	i = htonl(i);
	memcpy(req->payload + req->payload_len, &i, 4);
	req->payload_len += 4;
}

void WUMPayloadStoreRawBytes(wum_req_t *req, const void *buf, int size)
{
	memcpy(req->payload + req->payload_len, buf, size);
	req->payload_len += size;
}

int					/* Read "n" bytes from a descriptor. */
readn(int fd, void *vptr, size_t n)
{
	size_t	nleft;
	ssize_t	nread;
	char	*ptr;

	ptr = vptr;
	nleft = n;
	while (nleft > 0) {
		if ( (nread = recv(fd, ptr, nleft, 0)) < 0) {
			if (errno == EINTR)
				nread = 0;		/* and call read() again */
			else
				return(-1);
		} else if (nread == 0)
			break;				/* EOF */

		nleft -= nread;
		ptr   += nread;
	}
	return(n - nleft);		/* return >= 0 */
}

int
Readn(int fd, void *ptr, size_t nbytes)
{
	int		n;

	if ( (n = readn(fd, ptr, nbytes)) < 0)
		perror("readn error");
	return(n);
}

int						/* Write "n" bytes to a descriptor. */
writen(int fd, const void *vptr, size_t n)
{
	size_t		nleft;
	ssize_t		nwritten;
	const char	*ptr;

	ptr = vptr;
	nleft = n;
	while (nleft > 0) {
		if ( (nwritten = send(fd, ptr, nleft, 0)) <= 0) {
			if (errno == EINTR)
				nwritten = 0;		/* and call write() again */
			else
				return(-1);			/* error */
		}

		nleft -= nwritten;
		ptr   += nwritten;
	}
	return(n);
}

int
Writen(int fd, void *ptr, size_t nbytes)
{
	int n;
	while ((n = writen(fd, ptr, nbytes)) < 0)
		perror("writen error");
	return n;
}

int Read32(int fd, int *ptr) 
{
	int ret;
	
	ret = Readn(fd, ptr, 4);
	
	*ptr = ntohl(*ptr);

	return ret;
}

int Write32(int fd, void *ptr)
{	return 0; }
