#ifndef IBCOMMON_H
#define IBCOMMON_H

#include <unistd.h>
#include <arpa/inet.h>
#include <errno.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <sys/fcntl.h>

typedef const char* IBString;

// helpers
// inline int SocketsInit() { return 1; };
// inline int SocketsDestroy() { return 1; };
inline int SocketClose(int sockfd) { return close( sockfd); };

inline int SetSocketNonBlocking(int sockfd) { 
	// get socket flags
	int flags = fcntl(sockfd, F_GETFL);
	if (flags == -1)
		return 0;

	// set non-blocking mode
	return ( fcntl(sockfd, F_SETFL, flags | O_NONBLOCK) == 0);
};

///////////////////////////////////////////////////////////
// helper macroses
#define DECODE_FIELD(x) if (!DecodeField(x, ptr, endPtr)) return 0;
#define DECODE_FIELD_MAX(x) if (!DecodeFieldMax(x, ptr, endPtr)) return 0;

#define ENCODE_FIELD(x) EncodeField(msg, x);
#define ENCODE_FIELD_MAX(x) EncodeFieldMax(msg, x);
///////////////////////////////////////////////////////////

#endif