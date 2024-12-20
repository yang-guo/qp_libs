#include <sys/queue.h>
#include <curl/curl.h>
#include <stdlib.h>
#include <memory.h>
#include <pthread.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include "k.h"

#define so(c,o,v) curl_easy_setopt(c,CURLOPT_##o,v)
#define gi(c,o,v) curl_easy_getinfo(c,CURLINFO_##o,v)
Z size_t rscb(S d,size_t n,size_t l,V* p);Z K rqcb(I fd);
typedef struct curl_slist* CL;Z pthread_t loop;Z I rqin[2],rqout[2],initd=0;

typedef struct RQS{S url;S pay;CL header;S data;size_t n;J rc;J ec;C error[CURL_ERROR_SIZE];K cb;LIST_ENTRY(RQS) p;}*RQ;
Z LIST_HEAD(RQH,RQS)RQH;Z V rqinit(){LIST_INIT(&RQH);}

Z RQ rqadd(K cb,S url,S pay,CL header){
	RQ rq=malloc(sizeof(struct RQS));
	r1(cb);rq->cb=cb;rq->url=url;rq->pay=pay?pay:NULL;rq->header=header?header:NULL;rq->data=NULL;rq->n=0;rq->rc=0;
	LIST_INSERT_HEAD(&RQH,rq,p);R rq;}
Z V rqrm(RQ rq){r0(rq->cb);free(rq->url);free(rq->pay);curl_slist_free_all(rq->header);free(rq->data);LIST_REMOVE(rq,p);free(rq);}

Z V curladd(CURLM* curlm,RQ rq){
	CURL* c=curl_easy_init();
	so(c,URL,rq->url);so(c,FOLLOWLOCATION,1L);so(c,HEADER,0L);so(c,SSL_VERIFYPEER,0L);so(c,SSL_VERIFYHOST,0L);
	so(c,WRITEFUNCTION,rscb);so(c,WRITEDATA,rq);so(c,PRIVATE,rq);so(c,ERRORBUFFER,rq->error);
	if(rq->pay){so(c,POST,1L);so(c,POSTFIELDS,rq->pay);so(c,POSTFIELDSIZE,strlen(rq->pay));}
	if(rq->header){so(c,HTTPHEADER,rq->header);}
	curl_multi_add_handle(curlm,c);}
Z V curlrm(CURLM* curlm,CURL* c){curl_multi_remove_handle(curlm,c);curl_easy_cleanup(c);}

Z size_t rscb(S d,size_t n,size_t l,V* p){
	RQ rq=(RQ)p;size_t sz=n*l;size_t nsz=rq->n+sz;
	rq->data=realloc(rq->data,nsz);memcpy(rq->data+rq->n,d,sz);rq->n=nsz;R sz;}

Z K rqcb(I fd){
	RQ rq;I n=read(fd,&rq,sizeof(RQ));K data=knk(3,kpn(rq->data,rq->n),kj(rq->rc),kj(rq->ec));
	K res=dot(rq->cb,data);r0(data);rqrm(rq);R res;} 

Z V* rqloop(V* args){
	fd_set rds,wrs,errs;struct timeval to;I nrun,queued,maxfd,rc;CURLMsg* msg;RQ rq;
	curl_global_init(CURL_GLOBAL_ALL);CURLM* curlm=curl_multi_init();curl_multi_perform(curlm,&nrun);
	while(1){
		FD_ZERO(&rds);FD_SET(rqin[0],&rds);
		rc=curl_multi_fdset(curlm,&rds,&wrs,&errs,&maxfd);maxfd=(maxfd>rqin[0])?maxfd:rqin[0];
		to.tv_sec=0;to.tv_usec=10000;rc=select(maxfd+1,&rds,NULL,NULL,&to);
		SW(rc){
			case -1: break;
			case 0: default:
				if(FD_ISSET(rqin[0],&rds)){I nread=read(rqin[0],&rq,sizeof(RQ));curladd(curlm,rq);}
				else{
					while((msg=curl_multi_info_read(curlm,&queued))){
						if(msg->msg==CURLMSG_DONE){CURL* c=msg->easy_handle;gi(c,PRIVATE,&rq);gi(c,RESPONSE_CODE,&rq->rc);
							rq->ec=msg->data.result;rc=write(rqout[1],&rq,sizeof(RQ));curlrm(curlm,c);}}}
				curl_multi_perform(curlm,&nrun);break;}}}

K init(K x){
	if(!initd){if(pipe(rqin))R krr("pipe");if(pipe(rqout))R krr("pipe");
	rqinit();sd1(rqout[0],rqcb);pthread_create(&loop,NULL,rqloop,NULL);initd=1;}R(K)0;}

K postAsync(K cb,K url,K pay,K header){
	if(url->t!=KC)R krr("type");if(pay&&pay->t!=KC)R krr("type");
	S rqpay=NULL;CL rqheader=NULL;
	S rqurl=malloc(sizeof(C)*(url->n+1));strncpy(rqurl,kC(url),url->n);rqurl[url->n]=0;
	if(pay&&pay->n){rqpay=malloc(sizeof(C)*(pay->n+1));strncpy(rqpay,kC(pay),pay->n);rqpay[pay->n]=0;}
	if(header&&!header->t){
		for(I i=0;i<header->n;++i){if(kK(header)[i]->t==KC){
			I sn=kK(header)[i]->n;S str=malloc(sizeof(char)*(sn+1));strncpy(str,kC(kK(header)[i]),sn);str[sn]=0;
			rqheader=curl_slist_append(rqheader,str);free(str);}}}
	RQ rq=rqadd(cb,rqurl,rqpay,rqheader);I rc=write(rqin[1],&rq,sizeof(RQ));R(K)0;}
K getAsync(K cb,K url){R postAsync(cb,url,NULL,NULL);}
K getAsynch(K cb,K url,K header){R postAsync(cb,url,NULL,header);}