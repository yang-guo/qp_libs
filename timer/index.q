\d .timer
i:0;t:();nxt:{id:i;i+::1;id};add:{[fn;int]id:nxt 0;t,::(,)(id;fn;int;int);id};rm:{[id]t::t _t[;0]?id;id}
.z.ts:{if[0=count t;:0];t::.[t;(::;3);-;100];id:(&:)t[::;3]<=0;if[0=count id;:0];.[t;(id;1);@;::];t::.[t;(id;3);:;t[id;2]];}
\t 100
\d .