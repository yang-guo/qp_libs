\d .timer
i:0;t:();nxt:{id:i;i+::1;id};nt:{[s;fn;int]id:nxt 0;t,::(,)(id;fn;int;int;s);id}
add:{[fn;int]nt[0b;fn;int]};once:{[fn;int]nt[1b;fn;int]};rm:{[id]t::t _t[;0]?id;id}
.z.ts:{if[0=count t;:0];t::.[t;(::;3);-;100];id:(&:)tr:t[::;3]<=0;if[0=count id;:0];.[t;(id;1);@;::];t::.[t;(id;3);:;t[id;2]];t::t (&:)not tr&t[;4]}
\t 100
\d .