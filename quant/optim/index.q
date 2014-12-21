\d .optim
secant1d:{[fn;x0;x1]x2:x1-fn[x1]*(x1-x0)%(fn[x1]-fn[x0]);$[1e-8>abs x1-x2;x2;.z.s[fn;x1;x2]]}
newton1d:{[fn;dfn;x0]x1:x0-fn[x0]%dfn[x0];$[1e-8>abs x1-x2;x2;.z.s[fn;dfn;x1]]}
\d .