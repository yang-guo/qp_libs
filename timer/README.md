## Description

Overwrites .z.ts to become a timer based callback function

## Documentation

All functions are under the namespace .timer

There is only one function
* _add[callback;interval]_ add a job to the timer and returns jobid
* _once[callback;interval]_ add a job once to the timer and returns jobid
* _rm[id]_ remove a job by jobid from the timer

The parameters are
* callback(_fn[]_) executes when interval is hit
* interval(_j_) interval on trigger in milliseconds
* id(_j_) jobid to remove

## Examples

```q
id:.timer.add[{xx+::1};1000]; //increment xx by 1 ever 1000 milliseconds
.timer.rm[id]; //removes the counter
.timer.once[{xx::1};1000]; //resets the counter to 1 after 1000 milliseconds
```