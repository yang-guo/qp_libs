\d .timer
id:0;
triggers:();
getNextId:{curid:id;id+::1;curid};
add:{[fn;interval] curid:getNextId[]; triggers,::enlist (curid;fn;interval;interval);curid};
remove:{[tid] triggers::triggers _triggers[;0]?tid;tid};
//orig:.z.ts;
.z.ts:{
	if[0=count triggers;:0];
	triggers::.[triggers;(::;3);-;100];
	execidx:where triggers[;3]<=0;
	if[0=count execidx;:0];
	.[triggers;(execidx;1);@;::]; //run functions that we have hit the time for
	triggers::.[triggers;(execidx;3);:;triggers[;2] execidx];
 };
\t 100

\d .