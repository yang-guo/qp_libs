/ quant.q is required. It is originally from gordon baker gbkr.com

\d .ql_impl / \d and \l hidden here
\l quant.q

/ finance
phi:{exp[ neg (x xexp 2)%2f] % .quant.SQRT2PI}

/black scholes formula
bls:()!()
bls[`d]:{d1:(log[x[`spot]%x[`strike]] + x[`matur]*x[`rate]+0.5*x[`vola] xexp 2) %x[`vola] * sqrt x[`matur];
    d2:d1-x[`vola] *sqrt x[`matur];
    sig:neg 1f-2f*`float$(x[`direct]=`call);
    (`d1`d2`sig!(d1;d2;sig))
    }

bls[`bls]:{ neg x[`sig]*(x[`strike]*exp[neg x[`rate]*x[`matur]] *.quant.cdf[`gauss] x[`sig]*x[`d2] )-x[`spot]*.quant.cdf[`gauss] x[`sig]*x[`d1] 
    }

/ greeks
bls[`delta]:{x[`sig]*.quant.cdf[`gauss] x[`sig]*x[`d1]}
bls[`thetaa]:{nd2:x[`strike]*x[`rate] *.quant.cdf[`gauss] x[`sig]*x[`d2];
    nd1:%[neg x[`vola]*x[`spot]*phi x[`d1];2f*sqrt x[`matur]];
    :nd1+x[`sig]*nd2*exp neg x[`matur] 
    }

bls[`98]:{ a:update num:til count x from x; impl:select from a where type_=`impl;
    nimpl:select from a where not type_=`impl;
    t:$[0=count nimpl;nimpl;flip flip[nimpl], 'bls[`d]nimpl];
    g:$[0=count t;nimpl;t group t`type_]; 
    nimpl:$[0=count t;nimpl;raze key [g] {[x;y] p:bls[x] y ; update p from y}' value g];
    impl:update p:.ql.bls each impl from impl;
    :exec p from `num xasc nimpl,impl
    }

bls[`impl]:{p:`type_ _ x;
    www:{[p;x] 1e-10< abs p[`price]-.ql.bls p,(`type_`vola)!(`bls;x)  } p;
    /ww:{[x] abs p[`price]-.ql.bls p,(`type_`vola)!(`bls;x)};
    {[p;x] x+(p[`price]-.ql.bls p,(`type_`vola)!(`bls;x))  % .ql.bls p,(`type_`vola)!(`vega;x) }[p]/[www;0.65]
    }

/ \d is hidden below
\d .
\d .ql
bls:{ :.ql_impl.bls[`$string type x] x 
    /xx:?[`impl =x`type_;{x};.ql_impl.bls[`dm] ][x] ;.ql_impl.bls[xx`type_] xx
    }

