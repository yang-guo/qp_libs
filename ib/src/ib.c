#include "common.h"
#include "structures.h"
#include "const.h"

IBConnection* ib_create_connection() {
	IBConnection* ib;
	if((ib = malloc(sizeof *ib)) != NULL) {
		ib->m_fd = 0;
		ib->m_clientId = -1;
		ib->m_connected = 0;
		ib->m_serverVersion = 0;
		ib->m_outBuffer = malloc(sizeof(char) * 255); //TODO: change these if needed
		ib->m_outBuffer_sz = 0;
		ib->m_inBuffer = malloc(sizeof(char) * 255);
		ib->m_inBuffer_sz = 0;
	}
	return ib;
}

int ib_connect(IBConnection* ib, const char* host, unsigned int port, int clientId) {
	// reset errno
	errno = 0;

	//Check already connected
	if( ib->m_fd >= 0) {
		errno = EISCONN;
		//getWrapper()->error( NO_VALID_ID, ALREADY_CONNECTED.code(), ALREADY_CONNECTED.msg());
		return 0;
	}

	//create socket and check socket
	ib->m_fd = socket(AF_INET, SOCK_STREAM, 0);
	if( ib->m_fd < 0) {
		//getWrapper()->error( NO_VALID_ID, FAIL_CREATE_SOCK.code(), FAIL_CREATE_SOCK.msg());
		return 0;
	}

	// use local machine if no host passed in
	if ( !( host && *host)) {
		host = "127.0.0.1";
	}	

	//open a socket and tr to connect to the server
	struct sockaddr_in sa;
	memset( &sa, 0, sizeof(sa));
	sa.sin_family = AF_INET;
	sa.sin_port = htons( port);
	sa.sin_addr.s_addr = inet_addr( host);

	// try to connect
	if( (connect( ib->m_fd, (struct sockaddr *) &sa, sizeof( sa))) < 0) {
		// error connecting
		//getWrapper()->error( NO_VALID_ID, CONNECT_FAIL.code(), CONNECT_FAIL.msg());
		return 0;
	}	

	// set client id
	ib_set_client_id(ib,clientId);


}


/*
void EClientSocketBase::onConnectBase()
{
	// send client version
	std::ostringstream msg;
	ENCODE_FIELD( CLIENT_VERSION);
	bufferedSend( msg.str());
}*/

int ib_disconnect(IBConnction* ib) {
	if(ib->m_fd >= 0) SocketClose(ib->m_fd);
	ib->m_fd = -1;

	Empty(m_TwsTime);
	ib->m_serverVersion = 0;
	ib->m_connected = 0;
	ib->m_clientId = -1;

}

//Sets the client it into IBConnection
void ib_set_client_id(IBConnection* ib, int clientId) {
	ib->m_clientId = clientId;
}

int ib_cleanup_buffer(const char** buffer, int processed){
	/TODOs
	return;
}

int ib_send_buffered_data(IBConnection* ib) {
	if(ib->m_outBuffer_sz == 0) return 0;
	int nResult = ib_send(ib, ib->m_outBuffer, ib->m_outBuffer_sz);
	if(nResult <= 0) return nResult;
	ib_cleanup_buffer(ib->m_outBuffer, nResult);
	return nResult;
}

int ib_buffered_send(IBConnection* ib, const char* buf, size_t sz) {
	if (sz <= 0) return 0;
	if (ib->m_outBuffer_sz != 0){
		//m_outBuffer.insert( m_outBuffer.end(), buf, buf + sz);
		//TODO - wtf to do to reallocatebuffer
		return ib_send_buffered_data(ib);		
	}
}

int ib_send(IBConnection* ib, const char* buf,size_t sz) {
	if(sz <= 0) return 0;
	
	int nResult = send(ib, buf, sz, 0);

	if(nResult == -1 && !ib_handle_socket_error()) return -1;
	if(nResult <= 0) return 0;
	return nResult;
}

int ib_receive(IBConnection* ib, char* buf, size_t sz) {
	if(sz <= 0) return 0;
	
	int nResult = recv(ib->m_fd, buf, sz, 0);
	
	if( nResult == -1 && !ib_handle_socket_error()) return -1;
	if(nResult <= 0) return 0;
	return nResult;
}

int ib_handle_socket_error() {
	if(errno == 0) return 1;
	if(errno == EISCONN) return 1;
	if(errno == EWOULDBLOCK) return 0;
	if(errno == ECONNREFUSED){
		//getWrapper()->error( NO_VALID_ID, CONNECT_FAIL.code(), CONNECT_FAIL.msg());
	} else {
		//getWrapper()->error( NO_VALID_ID, SOCKET_EXCEPTION.code(), SOCKET_EXCEPTION.msg() + strerror(errno));
	}
	//reset errno
	errno = 0;

	return 0;
}
