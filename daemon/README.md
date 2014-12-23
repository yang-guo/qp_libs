## Description

Daemonizes a q process

## Documentation

All functions are under the namespace .daemon.  Note: Daemon must be called before any threads are created otherwise the process will become a zombie.

There is only one function
* _daemonize[]_ daemonizes the current process

## Examples

```q
.daemon.daemonize[] //will daemonize the process