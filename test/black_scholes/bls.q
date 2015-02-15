.qp.require["qml"]                                                                                                                                                        
\l ../quant.q / quant.q required. originally from gordon baker gbkr.com
\d .bls / \d is hidden

phi:{ exp[ neg (x xexp 2)%2f] % .quant.SQRT2PI }

bls:()!() / dict to contain all bls related formulas
bls[`d]:{ d1:(log[x[`spot]%x[`strike]] + x[`matur]*x[`rate]+0.5*x[`vola] xexp 2) %x[`vola] * sqrt x[`matur];
    d2:d1-x[`vola] *sqrt x[`matur];
    (`d1`d2)!(d1;d2)
    }

bls[`sign]:{ [direct] $[direct=`call;sign:1f; direct=`put;sign:-1f]; / a trick to merge put and call formulas into one
    :sign
    }

/ Black Scholes formula
/ x: spot, strike, matur, rate, vola, 
/    d1, d2, sign
bls[`bls]:{ term1:x[`sign] * (x[`spot]*.qml.ncdf x[`sign]*x[`d1]); 
    term2:x[`sign]* neg x[`strike]*exp[neg x[`rate]*x[`matur]] *.qml.ncdf x[`sign]*x[`d2];
    :term1+term2 }

/ Greeks
bls[`delta]:{ x[`sign]*.qml.ncdf x[`sign]*x[`d1]}
bls[`gamma]:{ :phi[x[`d1]] % x[`spot]*x[`vola]*sqrt x[`matur] }
bls[`theta]:{ term2:neg x[`sign]* x[`strike]*x[`rate] * (exp neg x[`rate]*x[`matur]) *.qml.ncdf x[`sign]*x[`d2];
    term1:%[neg x[`vola]*x[`spot]*phi x[`d1];2f*sqrt x[`matur]];
    term3:x[`sign]* 0f* x[`spot]*.qml.ncdf x[`sign]*x[`d1];
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
msft:(`spot`strike`matur`rate`div`vola)!(30.0;30.0;1.0;0.05;0.0;0.20)

extra:bls[`d] msft;
msft:msft,extra
msft[`sign]:bls[`sign] `call

if [1=1; 0N! `$"call price:"; bls[`bls] msft;
    0N! `$"delta:"; bls[`delta] msft;
    0N! `$"gamma:"; bls[`gamma] msft;
    0N! `$"theta:"; bls[`theta] msft;

    msft[`sign]:bls[`sign] `put;
    0N! `; 
    0N! `$"put price:"; bls[`bls] msft;
    0N! `$"delta:"; bls[`delta] msft;
    0N! `$"gamma:"; bls[`gamma] msft;
    0N! `$"theta:"; bls[`theta] msft]

\d . / End of program
