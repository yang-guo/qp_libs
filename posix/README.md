## Description

Functions to convert time to and from POSIX time

## Documentation

All functions are under the namespace .posix

There are two main functions
* _convert[type;posixtime]_ tries to convert the posix time to timestamp based on type
* _revert[type;timestamp]_ tries to revert a timestamp to posix time based on type

The parameters are
* type(_s_)
	* `s: seconds
	* `ms: milliseconds
	* `us: microseconds
	* `ns: nanoseconds
* posixtime(_j_) posix time
* timestamp(_p_) timestamp

## Examples

```q
ts:.posix.convert[`s;23124235353453] //converts from posix to a timestamp
.posix.revert[`s;ts] //reverts it back to the original posix value
```