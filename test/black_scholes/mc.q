.qp.require["qml"]                                                                                                                                                        
\l ../quant.q / quant.q required. originally from gordon baker gbkr.com
\d .mc / \d is hidden

.qp.require("qml")
\l bls.q
\d .mc

// RNG
uniformRN:{[] (1?1f)[0] }

/ standard normal
haveNextGaussianRN:0;
nextGaussianRN:0f;
gaussianRN:{ 
    // Box-Muller takes two uniform(0,1) RNs and produces 2 standard normal RNs. Only 1 of them is returned, 
    // We only have to compute them every other time. We cache the second random number
    compute:1;
    if [haveNextGaussianRN; compute:0; result:nextGaussianRN; haveNextGaussianRN::0];
    if [compute; w:1f; 
        while [w>=1f; x1:(2f*uniformRN[])- 1f; x2:(2f*uniformRN[])- 1f; w:(x1*x1)+ x2*x2]; 
        w:sqrt (-2f* log w) % w;
        y1:x1*w;
        y2:x2*w;
        nextGaussianRN::y2;
        haveNextGaussianRN::1;
        result:y1
        ];
        :result
    }

// Different algos to create a simulation path
S:()!()
S[`euler_s]:{}

/ Euler method on logS, Tevalla homework 3
S[`euler_logS]:{[x] spot:x[`spot]; drift:x[`rate]-x[`div]; vola:x[`vola]; matur:x[`matur];
    steps:x[`steps]; deltat: matur%steps;

    delta_logS:{[spot;drift;vola;deltat;step] (deltat* drift- vola*vola%2.0) + (vola* sqrt deltat)* gaussianRN[] };
    logS:sum delta_logS[spot;drift;vola;deltat] each steps#0.0;
    :spot* exp logS
    }

/ Repeat function N times
create_vecS:{[stk;algo;N] {[x;type_;onesample] S[type_] x } [stk;algo;] each N#0.0 
    }

///////////////////////////////////////////////////////
// Testing
stk:(``spot`strike`matur`rate`div`vola)!(::;30.0;30.0;1.0;0.05;0.0;0.20)
stk[`steps]:100

nPaths:10000
algo:`euler_logS
vecS:create_vecS[stk;`euler_logS;nPaths]

n:0
vecC:(count vecS)#0.0
while [n<count vecC; vecC[n]:max (vecS[n]-stk[`strike];0.0); n+:1]

0N! `
`$"Euler with logS:"
`$"call price:"
avg vecC

/ From bls formula
extra:.bls.bls[`d] stk;
stk:stk,extra
stk[`sign]:.bls.bls[`sign] `call

0N! `
`$"Analytical formula"
`$"call price:"
.bls.bls[`bls] stk
`$"delta:" 
.bls.bls[`delta] stk
`$"gamma:" 
.bls.bls[`gamma] stk
`$"theta:" 
.bls.bls[`theta] stk


\d . / End of program
