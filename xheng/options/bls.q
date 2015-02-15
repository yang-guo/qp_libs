.qp.require["qml"]                                                                                                                                                        
\l ../quant.q / quant.q required. originally from gordon baker gbkr.com
\d .bls / \d is hidden

phi:{ exp[ neg (x xexp 2)%2f] % .quant.SQRT2PI }

bls:()!() / dict to contain all bls related formulas
bls[`d]:{ spot:x[`spot]; strike:x[`strike]; matur:x[`matur]; vola:x[`vola]; rate:x[`rate]; divYld:x[`divYld];
    fwdpx:spot* exp (rate- divYld)* matur;
    d1:((log fwdpx % strike)+ 0.5* matur* vola xexp 2) % vola * sqrt matur;
    (`d1`d2)!(d1;d1-vola* sqrt matur)
    }

bls[`sign]:{[direct] $[direct=`call; sign:1f; direct=`put; sign:-1f; `$"invalid input"]; / a trick to merge put and call formulas into one
    :sign }

/ Black Scholes formula
/ x: spot, strike, matur, rate, vola, 
/    d1, d2, sign
bls[`price]:{ spot:x[`spot]; strike:x[`strike]; matur:x[`matur]; vola:x[`vola]; rate:x[`rate]; divYld:x[`divYld]; 
    d1:x[`d1]; d2:x[`d2]; sign: x[`sign];
    fwdpx:spot* exp (rate- divYld)* matur;
    :sign* (exp neg rate* matur)* (fwdpx* .qml.ncdf sign* d1)- strike* .qml.ncdf sign*d2 
    }

/ Greeks
bls[`delta]:{ x[`sign]* (exp neg x[`divYld]* x[`matur])* .qml.ncdf x[`sign]* x[`d1]}
bls[`gamma]:{ (exp neg x[`divYld]* x[`matur])* (phi x[`d1]) % x[`spot]* x[`vola]* sqrt x[`matur] }
bls[`theta]:{ spot:x[`spot]; strike:x[`strike]; matur:x[`matur]; vola:x[`vola]; rate:x[`rate]; divYld:x[`divYld];
    d1:x[`d1]; d2:x[`d2]; sign: x[`sign];
    divDisc:exp neg divYld* matur;
    term2:neg sign* strike*rate*(exp neg rate*matur)* .qml.ncdf sign*d2;
    term1:neg divDisc * (vola*spot* phi d1) % 2f* sqrt matur;
    term3:sign* divYld * spot* divDisc* .qml.ncdf sign*d1;
    :term1+term2+term3 
    }

bls[`vega]:{ :phi[x[`d1]]* x[`spot]* sqrt x[`matur] }
bls[`rho]:{ :x[`strike]*x[`matur]*exp[neg x[`rate] *x[`matur] ] *.qml.ncdf x[`sign]* x[`d2]  };

/bls[`98]:{ a:update num:til count x from x; impl:select from a where type_=`impl; 
/    nimpl:select from a where not type_=`impl; t:$[0=count nimpl; nimpl; flip flip[nimpl],'bls[`d] nimpl];
/    g:$[0=count t; nimpl; t group t`type_]
/    nimpl:$[0=count t;nimpl; raze key [g] {p:bls[x] y; update p from y}' value g];
/    impl:update p:.bls.bls each impl from impl;
/    :exec p from `num xasc nimpl,impl
/    }

///////////////////////////////////////////////////////
// Testing
if [1=0; msft:(``spot`strike`matur`rate`divYld`vola)!(::;30.0;30.0;1.0;0.05;0.02;0.20); 
    extra:bls[`d] msft;
    msft:msft,extra;
    msft[`sign]:bls[`sign] `call;

    0N! `$"call price:"; 0N! bls[`price] msft;
    0N! `$"delta:"; 0N! bls[`delta] msft;
    0N! `$"gamma:"; 0N! bls[`gamma] msft;
    0N! `$"theta:"; 0N! bls[`theta] msft;
    
    msft[`sign]:bls[`sign] `put;
    0N! `; 
    0N! `$"put price:"; 0N! bls[`price] msft;
    0N! `$"delta:"; 0N! bls[`delta] msft;
    0N! `$"gamma:"; 0N! bls[`gamma] msft;
    0N! `$"theta:"; 0N! bls[`theta] msft]

\d . / End of program
