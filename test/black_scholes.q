/ quant.q is required. It is originally from gordon baker gbkr.com

\l quant.q / \l hidden here

///////////////////////////////////////////////////////
\d .bls / \d is hidden

phi:{exp[ neg (x xexp 2)%2f] % .quant.SQRT2PI}

bls:()!() / dict to contain all bls related formulas
bls[`d]:{ d1:(log[x[`spot]%x[`strike]] + x[`matur]*x[`rate]+0.5*x[`vola] xexp 2) %x[`vola] * sqrt x[`matur];
    d2:d1-x[`vola] *sqrt x[`matur];
    sig:`float$x[`direct]=`call; / a trick to merge put and call formulas into one
    /sig:neg 1f-2f*`float$(x[`direct]=`call); 
    (`d1`d2`sig)!(d1;d2;sig)
    }

/ Black Scholes formula
/ x keys: spot, strike, matur, rate, vola, 
/         direct, d1, d2, sig
bls[`bls]:{ 
    x[`sig] * (x[`spot]*.quant.cdf[`gauss] x[`sig]*x[`d1]) - x[`strike]*exp[neg x[`rate]*x[`matur]] *.quant.cdf[`gauss] x[`sig]*x[`d2]
    }

/ Greeks
/bls[`delta]:{ x[`sig]*.quant.cdf[`gauss] x[`sig]*x[`d1]}
/bls[`gamma]:{ :phi[x[`d1]] % x[`spot]*x[`vola]*sqrt x[`matur]] }
/bls[`thetaa]:{nd2:x[`strike]*x[`rate] *.quant.cdf[`gauss] x[`sig]*x[`d2];
/    nd1:%[neg x[`vola]*x[`spot]*phi x[`d1];2f*sqrt x[`matur]];
/    :nd1+x[`sig]*nd2*exp neg x[`matur] 
/    }

///////////////////////////////////////////////////////

msft:(``spot`strike`matur`rate`vola)!(::;30.0;30.0;1.0;0.05;0.20) // :: a trick to make mixed-type dict
msft[`direct]:`call / call or put

extra:bls[`d] msft
msft:msft,extra

c:bls[`bls] msft



\d . / End of program
