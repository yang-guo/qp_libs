#ifndef IBSTRUCTURES_H
#define IBSTRUCTURES_H

#include "common.h"

//Object that gets passed around for connections
typedef struct {
	int m_fd;
	int m_clientId;
	int m_connected;
	int m_serverVersion;
	const char* m_outBuffer;
	unsigned int m_outBuffer_sz;
	const char* m_inBuffer;
	unsigned int m_inBuffer_sz;
} IBConnection;

#endif