#include <sys/queue.h>
#include <curl/curl.h>
#include <stdlib.h>
#include <memory.h>
#include <pthread.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include "k.h"

static size_t http_response_callback(char *d, size_t n, size_t l,void *p);
static K http_message_callback(int fd);

//*******************************************
// Request Functions
//*******************************************
//Data structure passed to CURLs to get data
struct request {
	//http parts
	char *url;
	char *payload;
	struct curl_slist *header_list;
	char *data;
	size_t data_size;
	char error_buffer[CURL_ERROR_SIZE];
	K callback;
	LIST_ENTRY(request) pointers;
};
static LIST_HEAD(requests_head, request) requests_head;

static void http_init_request() {
	LIST_INIT(&requests_head);
}

static struct request *http_add_request(K callback, char *url,
	char *payload, struct curl_slist* headers) {
	
	struct request *new_request = malloc(sizeof(struct request));
	//load up parameters, check if some exist
	r1(callback);
	new_request->callback = callback;
	new_request->url = url;
	new_request->payload = (payload) ? payload : NULL;
	new_request->header_list = (headers) ? headers : NULL;
	
	new_request->data = NULL;
	new_request->data_size = 0;

	LIST_INSERT_HEAD(&requests_head, new_request, pointers);
	return new_request;
}

static void http_remove_request(struct request *req) {
	LIST_REMOVE(req, pointers);
	free(req->url);
	free(req->payload);
	curl_slist_free_all(req->header_list);
	free(req->data);
	//free(req->callback);
	//r0(req->callback);
}

//*******************************************
// CURL Functions
//*******************************************
//Initializes a curl into the multihandle
static void http_init_curl(CURLM *curl_m, struct request *req) {
	CURL* c = curl_easy_init();

	curl_easy_setopt(c, CURLOPT_URL, req->url);
	curl_easy_setopt(c, CURLOPT_FOLLOWLOCATION, 1L);
	curl_easy_setopt(c, CURLOPT_HEADER, 0L);
	curl_easy_setopt(c, CURLOPT_SSL_VERIFYPEER, 0L);
	curl_easy_setopt(c, CURLOPT_SSL_VERIFYHOST, 0L);
	curl_easy_setopt(c, CURLOPT_WRITEFUNCTION, http_response_callback);
	curl_easy_setopt(c, CURLOPT_WRITEDATA, req);
	curl_easy_setopt(c, CURLOPT_PRIVATE, req);
	curl_easy_setopt(c, CURLOPT_ERRORBUFFER, req->error_buffer);

	if(req->payload) {
		curl_easy_setopt(c, CURLOPT_POST, 1L);
		curl_easy_setopt(c, CURLOPT_POSTFIELDS,req->payload);
		curl_easy_setopt(c, CURLOPT_POSTFIELDSIZE, strlen(req->payload));		
	}
	if(req->header_list) {
		curl_easy_setopt(c, CURLOPT_HTTPHEADER, req->header_list);
	}

	curl_multi_add_handle(curl_m, c);
}

static void http_remove_curl(CURLM *curl_m, CURL* curl) {
	curl_multi_remove_handle(curl_m, curl);
	curl_easy_cleanup(curl);
}

//*******************************************
// Callbacks
//*******************************************
//Callback when http returns data via curl
static size_t http_response_callback(char *d, size_t n, size_t l,void *p) {
	struct request *req = (struct request*) p;
	int new_size = req->data_size + (n * l);
	req->data = realloc(req->data, new_size);
	memcpy(req->data + req->data_size, d, n * l);
	req->data_size = new_size;
	return n * l;
}

static K http_message_callback(int fd) {
	int num_read;
	struct request *req;

	//Read the request that has been triggered and write back
	num_read = read(fd, &req, sizeof(struct request *));
	K data = knk(1,kpn(req->data,req->data_size));
	K result = dot(req->callback,data);
	r0(data);

	//We are done with the request, so we need to clean up
	http_remove_request(req);

	return result;
}

//*******************************************
// Request Loop
//*******************************************
int http_input_fd[2];
int http_output_fd[2];
pthread_t http_loop_thread;
int http_initialized = 0;

static void *http_request_loop(void *args) {
	fd_set read_set, write_set, error_set;
	struct timeval timeout;
	int rc, curls_running, msgs_in_queue, maxfd;
	CURLMsg* msg;
	struct request* req;

	curl_global_init(CURL_GLOBAL_ALL);
	CURLM *curl_multi = curl_multi_init();
	curl_multi_perform(curl_multi, &curls_running);

	//Main request loop
	while(1) {
		FD_ZERO(&read_set);

		//Get file handles - maybe handle fdset failure
		rc = curl_multi_fdset(curl_multi, &read_set, &write_set, &error_set, &maxfd);
		maxfd = (maxfd > http_input_fd[0]) ? maxfd : http_input_fd[0];


		FD_SET(http_input_fd[0], &read_set);

  		//define the timeout
  		timeout.tv_sec = 0;
  		timeout.tv_usec = 10000;		

  		rc = select(maxfd + 1, &read_set, NULL, NULL, &timeout);

  		switch(rc){
  			case -1:
  				break;
  			case 0:
  			default:
  				if(FD_ISSET(http_input_fd[0], &read_set)) {
  					int num_read = read(http_input_fd[0], &req, sizeof(struct request *));
  					http_init_curl(curl_multi, req);
  				} else {
  					while((msg = curl_multi_info_read(curl_multi, &msgs_in_queue))) {
  						if(msg->msg == CURLMSG_DONE) {
  							//Reading for writing back in main thread
  							CURL *curl = msg->easy_handle;
  							curl_easy_getinfo(curl, CURLINFO_PRIVATE, &req);
  							rc = write(http_output_fd[1], &req, sizeof(struct request *));
  						} else {
  							//OTHER SHIT (ERROR)
  						}
  					}
  					
  				}

  				curl_multi_perform(curl_multi, &curls_running);
  				break;
  		}
	}
}

//*******************************************
// Public Functions
//*******************************************
K postAsync(K callback, K url, K payload, K headers) {
	//Type checks - maybe build these into macross
	//if(callback->t != KC) return krr("type");
	if(url->t != KC) return krr("type");
	if(payload && payload->t != KC) return krr("type");
	if(headers && headers->t != KC) return krr("type");

	//Initialization
	if(!http_initialized){
		if(pipe(http_input_fd)) return krr("pipe");
		if(pipe(http_output_fd)) return krr("pipe");
		http_init_request();

		sd1(http_output_fd[0], http_message_callback);
		pthread_create(&http_loop_thread, NULL, http_request_loop, NULL);
		http_initialized = 1;
	}

	//parse data to create a new request
	//char *request_callback = malloc(sizeof(char) * (callback->n + 1));
	//strncpy(request_callback, kC(callback), callback->n);
	//request_callback[callback->n] = '\0';

	char *request_url = malloc(sizeof(char) * (url->n + 1));
	strncpy(request_url, kC(url), url->n);
	request_url[url->n] = '\0';

	char *request_payload = NULL;
	if(payload && payload->n) {
		char *request_payload = malloc(sizeof(char) * (payload->n + 1));
		strncpy(request_payload, kC(url), payload->n);
		request_payload[payload->n] = '\0';
	}

	//TODO: change this as this does way too may copies for no reason
	struct curl_slist *request_headers = NULL;
	if(headers && !headers->t) {
		for(int i = 0; i < headers->n; ++i) {
			char *str =  malloc(sizeof(char) * (kK(headers)[i]->n + 1));
			strncpy(str, kC(kK(headers)[i]), kK(headers)[i]->n);
			str[kK(headers)[i]->n] = '\0';
			request_headers = curl_slist_append(request_headers, str);
			free(str);
		}
	}

	struct request *new_request = 
			http_add_request(callback,
							request_url,
							request_payload,
							request_headers);
	int rc = write(http_input_fd[1], &new_request, sizeof(struct request *));
	return (K) 0;
}
K getAsync(K callback, K url) { R postAsync(callback, url, NULL, NULL); }