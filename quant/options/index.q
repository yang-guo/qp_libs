.qp.require["../index.q"]
\d .options
n:.quant.gauss.cdf;np:.quant.gauss.pdf;
phi:{(exp(-)(x xexp 2)%2f)%sqrt pi2}
/black scholes
bs.d:{[c;f;k;t;v]d1:((log f%k)+0.5*t*v*v)%v*st:sqrt t;d2:d1-v*st;(d1;d2)}
bs.val:{[c;s;k;t;r;d;v]f:s*exp t*r-d;d:bs.d[c;f;k;t;v];$[c=`c;(exp(-)r*t)*(n[d 0]*f)-n[d 1]*k;(exp(-)r*t)*(k*n[(-)d 1])-f*n[(-)d 0]]}
bs.delta:{[c;s;k;t;r;d;v]f:s*exp t*r-d;d:bs.d[c;f;k;t;v];$[c=`c;n[d 0];n[d 0]-1]}
bs.gamma:{[c;s;k;t;r;d;v]f:s*exp t*r-d;d:bs.d[c;f;k;t;v];np[d 0]%f*(exp(-)r*t)*v*sqrt t}
bs.vega:{[c;s;k;t;r;d;v]f:s*exp t*r-d;d:bs.d[c;f;k;t;v];f*(exp(-)r*t)*np[d 0]*sqrt t}
bs.theta:{[c;s;k;t;r;d;v]f:s*exp t*r-d;d:bs.d[c;f;k;t;v];(((-)f*(exp(-)r*t))*np[d 0]*v%2*sqrt t)+$[c=`c;(-)n[d 1]*r*k*exp(-)r*t;n[(-)d 1]*r*k*exp(-)r*t]}
bs.rho:{[c;s;k;t;r;d;v]f:s*exp t*r-d;d:bs.d[c;f;k;t;v];$[c=`c;n[d 1]*k*t*exp(-)r*t;(-)n[(-)d 1]*k*t*exp(-)r*t]}
/binomial
/bin.val:{[c;s;k;t;r;d;v;n]dt:t%n;b:avg exp dt*(0f;v*v)+((-)r;r);pu:b+sqrt(-)1-b*b;pd:(%)pu;p:((-)pd-exp r*dt)%pu-pd;q:1-p;}
bin.val:{[c;s;k;t;r;d;v;n]dt:t%n;pu:exp v*sqrt dt;pd:(%)pu;p:((exp dt*r-d)-pd)%pu-pd;S:s*pu xexp{(|)x+(-)(|)x}0,1+(!)n;{[p;r;dt;V]((p*-1_V)+(1-p)*1_V)*exp(-)r*dt}[p;r;dt]/[n;$[c=`c;max(0;S-k);max(0,k-S)]]}
\d .