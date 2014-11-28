.qp.require["timer"]
\d .conn
once:.timer.once;
poprev:@[get;`.z.po;()];pcprev:@[get;`.z.pc;()];
h:();i:1000;m:300000;
rp:{if[.z.w in h[;0];h[n:h[;0]?.z.w;2]:x;h[n;3]:`$":",h[n;1],":",($)x]}
po:{if[x in h[;0];:0];h,::(,)(x;"."sv($)"i"$0x0 vs .z.a;0;`;.z.u;y;.z.P;0Np);neg[x]({neg[.z.w](`.conn.rp;system"p")};0);}
.z.po:{po[x;0b];poprev x}
.z.pc:{if[x in h[;0];h[n:h[;0]?x;0 7]:(0N;.z.P);if[h[n;5];once[{[s;i;x]if[(0>.[o;(s;1b);-1])&(i<m);once[.z.s[s;2*i];i]];}[h[n;3];2*i];i]]];pcprev x}

o:{[hp;ar]if[0<h:@[hopen;hp;-1];neg[h]({neg[.z.w](`.conn.po;x;y)};h;ar)];h}
c:{[id]@[hclose;id:"i"$id;::];if[id in h[;0];h[h[;0]?id;5]:0b];.z.pc id}
\d .
