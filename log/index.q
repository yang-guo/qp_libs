\d .log
h:();
o:{[f]if[0<id:@[hopen;f;-1];h,::id];id}
c:{[id]if[id in h;@[hclose;h;::];h::h except id]}
w:{[id;msg]if[(id in h)&(10h=(@)msg);@[neg id;msg;::]]}
\d .