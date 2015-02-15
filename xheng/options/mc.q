.qp.require["qml"]   
                                                                                                                                                
\l ../quant.q / Originally from gordon baker gbkr.com
\l ../stat.q
\l rng.q
\l bls.q / Analytical solutions

\d .mc

//////////// Different algos to create a simulation path ////////////////
path:()!()

// Euler method on logS
path[`1path]:{[x; steps; algo] / algo: bm_fast, inverse
    spot:x[`spot]; drift:x[`rate]-x[`divYld]; vola:x[`vola]; matur:x[`matur]; 
    deltat:matur%steps; RNs:.rng.vec_gaussianRN[algo] steps;
    d_logS:(deltat* drift-0.5*vola*vola)+ (vola* sqrt deltat)* RNs;
    :spot* exp sum d_logS
	}

path[`1time]:{[x; nPaths; algo] / algo: bm_fast, inverse
    spot:x[`spot]; drift:x[`rate]-x[`divYld]; vola:x[`vola]; matur:x[`matur]; 
    deltat:matur%nPaths; RNs:.rng.vec_gaussianRN[algo] nPaths;
    d_logS:(deltat* drift-0.5*vola*vola)+ (vola* sqrt deltat)* RNs
	}

path[`heston]:{[x; nSteps; algo] spot:x[`spot]; drift:x[`rate]-x[`divYld]; vola:x[`vola]; 
	matur:x[`matur]; deltat:x[`deltat];
	mu:stk[`mu]; kappa:x[`kappa]; theta:x[`theta]; gamma:x[`gamma]; rho:x[`rho];
    RNs:(2;0N)#.rng.vec_gaussianRN[algo] 2*nSteps;
    RNs:x[`chol] mmu RNs; // choleski 
    iStep:0;
    while[iStep < nSteps; mu_new:max (mu;0); spot*:(1.0+ drift*deltat)+ (sqrt mu_new* deltat)* RNs[0;iStep]; mu+:(deltat* kappa* theta-mu_new)+ gamma*(sqrt mu_new *deltat)*RNs[1;iStep]; iStep+:1];
    :spot }
	
/ Repeat function N times
create_vecS:()!()
create_vecS[`1path]:{[stk; simu] algo_RN:simu[`algo_RN];
	:path[`1path][stk; simu[`nSteps];] each simu[`nPaths]#algo_RN }

create_vecS[`1time]:{[stk; simu] algo_RN:simu[`algo_RN]; 
	vec_logS:sum path[`1time][stk; simu[`nPaths]; ] each simu[`nSteps]#algo_RN;
	:stk[`spot]* exp vec_logS }

create_vecS[`heston]:{[stk; simu] algo_RN:simu[`algo_RN];
	:path[`heston][stk; simu[`nSteps];] each simu[`nPaths]#algo_RN }

// call prices and put prices	
get_vecC:{[vecS; strike] vecC:{[S; K] max (S-K;0.0)}[; strike] each vecS }
get_vecP:{[vecS; strike] vecP:{[S; K] max (K-S;0.0)}[; strike] each vecS }

/////////////// Testing /////////////////////
test_bigbls:{ [runTest] if [not runTest; :`$"mc.q: test_bigbls not run"];
	0N! `$"mc.q: start test_bigbls: ";
	stk:(`spot`strike`matur`rate`divYld`vola)!(50.0;50.0;1.0;0.065;0.025;0.7); 
	simu:(``nSteps`nPaths`algo_RN)!(::; 12;`long$1e6; `inverse);
	
	vecS:()!();
	vecS[`1path]:create_vecS[`1path][stk; simu]; / .rng.vec_gaussianRN[ simu[`algo_RN]] simu[`nSteps] * simu[`nPaths]; / 30% time of create_vecS[0]
	/ vecS[1]:create_vecS[1][stk; simu];

	/ 0N! avg vecS[0]; 0N! avg vecS[1];
    
	/ Get vectors of call and put prices
	/ TODO: vecS[0] is good. vecS[1] seems wrong
	vecC:get_vecC[ vecS[`1path]; stk[`strike] ];
	vecP:get_vecP[ vecS[`1path]; stk[`strike] ];

	vecC:vecC * exp neg stk[`rate]*stk[`matur]; / discounting
	vecP:vecP * exp neg stk[`rate]*stk[`matur];

	0N! `$"call price and std error:"; 0N! avg vecC; 0N! .stat.stderr vecC;
	0N! `$"Put price and std error:"; 0N! avg vecP; 0N! .stat.stderr vecP;

	/ From bls formula
	extra:.bls.bls[`d] stk; stk:stk,extra; 
	0N! `$"Analytical formula"; 0N! `$"call and put prices:"; stk[`sign]:.bls.bls[`sign] `call; 0N! .bls.bls[`price] stk;
	stk[`sign]:.bls.bls[`sign] `put; 0N! .bls.bls[`price] stk; }

test_heston:{ [runTest] if [not runTest; :`$"mc.q: test_heston not run"];
	0N! `$"mc.q: start test_heston: ";
	stk:(`spot`strike`matur`rate`divYld)!(100.0;105;0.5;0.06;0.02);
	stk,:(`mu`kappa`theta`gamma`rho)!(0.04; 0.5; 0.0625; 0.3; 0.5); 
	simu:(``nSteps`nPaths`algo_RN)!(::; 10; `long$1e6; `inverse);
	stk[`deltat]:stk[`matur] % simu[`nSteps];
	stk[`chol]:((1.0;0.0);(stk[`rho];sqrt 1- stk[`rho]*stk[`rho]));
	
	vecS:create_vecS[`heston][stk; simu];
	vecC:get_vecC[ vecS; stk[`strike] ];
	vecC:vecC * exp neg stk[`rate]*stk[`matur]; / discounting
	0N! `$"call price and std error:"; 0N! avg vecC; 0N! .stat.stderr vecC;
	}

test_bigbls[ 0b ] / 1b or 0b
\t test_heston[ 1b ]

\d . / End of program
