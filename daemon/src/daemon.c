#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include "k.h"

K daemonize(K x) {
	pid_t pid=0;
	
	if((pid = fork())<0){R krr("fork");}else if(pid>0){exit(0);}
	if (setsid()<0){exit(1);} //or should we return krr
	signal(SIGHUP,SIG_IGN);
	if((pid = fork())<0){exit(1);}else if(pid>0){exit(0);}
	if(chdir("/")<0){exit(1);}
	umask(0);
	close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);
    if(open("/dev/null",O_RDONLY)==-1){exit(1);}
    if(open("/dev/null",O_WRONLY) == -1){exit(1);}
    if(open("/dev/null",O_RDWR) == -1){exit(1);}
	R(K)0;	
}