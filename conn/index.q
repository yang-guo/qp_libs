\d .conn
poprev:@[get;`.z.po;()];
pcprev:@[get;`.z.pc;()];
h:();
rp:{if[.z.w in h[;0];h[h[;0]?.z.w;2]:x]}
po:{$[x in h[;0];h[h[;0]?x;5]:.z.P;h,::(,)(x;"."sv($)"i"$0x0 vs .z.a;0;.z.u;y;.z.P;0Np)];neg[x]({neg[.z.w](`.conn.rp;system"p")};0);}
.z.po:{po[x;0b];poprev x}
.z.pc:{if[x in h[;0];h[n:h[;0]?x;6]:.z.P;if[h[n;4];"Do something with reconnect here"]];pcprev x}

o:{[hp;ar]if[0<h:@[hopen;hp;-1];neg[h]({neg[.z.w](`.conn.po;x;y)};h;ar)]}
c:{[h]@[hclose;h;::];.z.pc h}
\d .