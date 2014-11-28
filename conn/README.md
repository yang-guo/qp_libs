## Description

Hooks into .z.pc and .z.po for better connection handling.  Previous .z.pc and .z.po will be called if they exist after 
.conn's called are done

## Dependencies

* timer

## Documentation

All functions are under the namespace .conn

There are two main functions
* _o[handle;autoreconnect]_ Will try to open the handle, and will autoreconnect if told to do so 
* _c[id]_ Tries to close id and also delete it from the list

The parameters are
* handle(_s_) handle (`:SERVER:PORT[:USER][:PASSWORD])
* autoreconnect(_b_) flag to set autoreconnection
* id(_j_) handle id

## Examples

```q
hid:.conn.o[`:localhost:1555;1b] //opens localhost:1555 and sets auto-reconnect to on
.conn.c[hid] //closes hid
```