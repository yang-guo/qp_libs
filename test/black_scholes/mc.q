.qp.require["qml"]   
                                                                                                                                                
\l ../quant.q / Originally from gordon baker gbkr.com
\l ../stats.q
\l rng.q
\l bls.q / Analytical solutions

\d .mc

//////////// Different algos to create a simulation path ////////////////
path:()!()
path[`euler_s]:{ .qml.nicdf .rng.uniformRN[] }

/ Euler method on logS, Tevalla hw 3
path[`euler_logS]:{[x;algo] / algo: bm_fast, inverse
    spot:x[`spot]; drift:x[`rate]-x[`divYld]; vola:x[`vola]; matur:x[`matur];
    steps:x[`steps]; deltat: matur%steps;
    RNs:.rng.vec_gaussianRN[algo] steps;
    delta_logS:(deltat* drift-0.5*vola*vola)+ (vola* sqrt deltat)*RNs;
    :spot* exp sum delta_logS
    }

/ Repeat function N times
create_vecS:{[stk;algoRN;algo_path;N] helper:{[x;algoRN;algo_path;unused] path[algo_path][x;algoRN] }; 
    :helper[stk;algoRN;algo_path;] each N#0.0
    }

/////////////// Testing /////////////////////
if [1=0;\]

0N! `
`$"Start of Testing:"

stk:(``spot`strike`matur`rate`divYld`vola)!(::;50.0;50.0;1.0;0.065;0.025;0.7)
stk[`steps]:12

nPaths:`long$1e7
algoRN:`inverse

\t vecS:create_vecS[stk;algoRN;`euler_logS; nPaths]
/ \t gaussianRN[`inverse]\[stk[`steps]*nPaths; 0] / test: as slow as the above command -> not a speed improvement
/ TODO: need a fast generator of random numbers

vecC:(count vecS)#0.0
vecP:(count vecS)#0.0

n:0
\t while [n< count vecC; vecC[n]:max (vecS[n]- stk[`strike];0.0); n+:1]
n:0
while [n< count vecP; vecP[n]:max (stk[`strike]-vecS[n];0.0); n+:1]

0N! `
`$"Euler with logS:"
`$"call price and std error:"
avg vecC
.stats.stderr vecC

`$"Put price and std error:"
avg vecP
.stats.stderr vecP

/ From bls formula
extra:.bls.bls[`d] stk;
stk:stk,extra
stk[`sign]:.bls.bls[`sign] `call

0N! `
`$"Analytical formula"
`$"call price and put price:"
.bls.bls[`price] stk
stk[`sign]:.bls.bls[`sign] `put
.bls.bls[`price] stk



\d . / End of program
