.qp.require["qml"]   
                                                                                                                                                
\l ../quant.q / Originally from gordon baker gbkr.com
\l ../stats.q
\l rng.q
\l bls.q / Analytical solutions

\d .mc

//////////// Different algos to create a simulation path ////////////////
path:()!()
path[`euler_s]:{ .qml.nicdf .rng.uniformRN[] }

/ Euler method on logS
path[`euler_logS]:{[x; steps; algo] / algo: bm_fast, inverse
    spot:x[`spot]; drift:x[`rate]-x[`divYld]; vola:x[`vola]; matur:x[`matur]; deltat:matur%steps;
    RNs:.rng.vec_gaussianRN[algo] steps;
    d_logS:(deltat* drift-0.5*vola*vola)+ (vola* sqrt deltat)*RNs;
    :spot* exp sum d_logS
    }

/ Repeat function N times
create_vecS:()!()
create_vecS[1]:{[stk;simu; algo_RN;algo_path]
	helper:{[x; nSteps; algo_RN; algo_path; unused] path[algo_path][x;nSteps;algo_RN] }; 
    :helper[stk;simu[`nSteps]; algo_RN; algo_path; ] each simu[`nPaths]#0.0
    }

// version 2 no longer developed
create_vecS[2]:{[stk; algo_RN; algo_path;N] helper:{[x;algo_RN;algo_path;unused] path[algo_path][x;algo_RN] }; 
    vec:helper[stk;algo_RN;algo_path;]\[N;0.0];
    :1_vec
    }

// vector of call prices
get_vecC:{[vecS; strike] vecC:{[S; K] max (S-K;0.0)}[;strike] each vecS }
get_vecP:{[vecS; strike] vecP:{[S; K] max (K-S;0.0)}[;strike] each vecS }

/////////////// Testing /////////////////////
runTest:0b
if [not runTest; ]

0N! `
`$"Start of Testing:"

stk:(``spot`strike`matur`rate`divYld`vola)!(::;50.0;50.0;1.0;0.065;0.025;0.7)
simu:(`nSteps`nPaths)!(12, `long$1e6)

algo_RN:`inverse

\t vecS:create_vecS[1][stk; simu; algo_RN; `euler_logS]
/ vecS:create_vecS[2][...] method 1 and 2 have the same speed

// Get vector of call prices and put
vecC:get_vecC[ vecS; stk[`strike] ]
vecP:get_vecP[ vecS; stk[`strike] ]

vecC:vecC * exp neg stk[`rate]*stk[`matur] / discounting
vecP:vecP * exp neg stk[`rate]*stk[`matur]

0N! `
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
