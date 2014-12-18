.qp.require["qml"]
\d .stats
treg.linear:{[t;y;X;opt]treg.chk[y;X];opt:treg.opt opt;X:X,();linreg[t y;(t X),$[opt`int;(,)((#)t)#1.;()]]}
treg.ridge:{[t;y;X;opt]treg.chk[y;X];opt:treg.opt opt;X:X,();n:$[opt`int;1;0]+(#)X;linreg[(t y),n#0.;((t X),$[opt`int;(,)((#)t)#1.;()]),'.qml.diag[n#sqrt opt`lambda]]}
treg.log:{[t;y;X;opt]treg.chk[y;X];opt:treg.opt opt;X:X,();logreg[t y;(t X),$[opt`int;(,)((#)t)#1.;()]]}
treg.lasso:{[t;y;X;opt]treg.chk[y;X];opt:treg.opt opt;X:X,();lasso[t y;(t X),$[opt`int;(,)((#)t)#1.;()];opt`lambda]}

treg.dft:`int`lambda!(1b;0.)
treg.opt:{[opt]if[99h<>(@)opt;:treg.dft];opt,raze {[opt;k](k,())!(,)$[k in(!)opt;opt k;treg.dft k]}[opt]'[(!)treg.dft]}
treg.chk:{[y;X]if[(0<(@)y)|(11h<>abs(@)y)|(11h<>abs(@)X);'`type];}

lasso:{[y;X;l]
    if[any[null y:"f"$y]|any{any null x}'[X:"f"$X];'`nulls];
    if[$[0=m:count X;1;m>n:count X:flip X];'`length];
    e:y-X$b:last{[y;X;m;n;l;ib]i:ib[0];b:ib[1];b[i]:{[b;l]$[(b>0)&(l<abs b);b-l;(b<0)&(l<abs b);b+l;0.]}[X[i]$y-(b _i)$(X _i);n*l]%X[i]$X[i];((i+1)mod m;b)}[y;(+)X;m;n;l]/[150;(0;m#0.)];
    Z:.qml.minv[flip[X]mmu X];linregtests ``X`y`S`b`e`n`m`df!(::;X;y;Z*mmu[e;e]%n-m;b;e;n;m;n-m)};

logreg:{[y;X]
    if[any[null y:"f"$y]|any{any null x}'[X:"f"$X];'`nulls];
    if[$[0=m:count X;1;m>n:count X:flip X];'`length];
    e:y-X mmu b:{[y;X;b]p:{(%)1+exp(-)x$y}[X;b];b+inv[((p*1-p)*/:flip[X])$X]$flip[X]$y-p}[y;X]/[10;m#0.];
    Z:.qml.minv[flip[X]mmu X];linregtests ``X`y`S`b`e`n`m`df!(::;X;y;Z*mmu[e;e]%n-m;b;e;n;m;n-m)};

linreg:{[y;X]
    if[any[null y:"f"$y]|any{any null x}'[X:"f"$X];'`nulls];
    if[$[0=m:count X;1;m>n:count X:flip X];'`length];
    e:y-X mmu b:(Z:.qml.minv[flip[X]mmu X])mmu flip[X]mmu y;
    linregtests ``X`y`S`b`e`n`m`df!(::;X;y;Z*mmu[e;e]%n-m;b;e;n;m;n-m)};

linregtests:{[R]
    tstat:R[`b]%se:sqrt R[`S]@'til count R`S;
    fstat:(R[`df]*rss-tss:{x mmu x}R[`y]-+/[R`y]%R`n)%(1-R`m)*rss:e mmu e:R`e;
    R,`se`tstat`tpval`rss`tss`r2`r2adj`fstat`fpval!(se;tstat;
        2*1-R[`df] .qml.stcdf/:abs tstat;rss;tss;1-rss%tss;
        1-(rss*-1+R`n)%tss*R`df;fstat;1-.qml.fcdf[-1+R`m;R`df;fstat])};

neweywest:{[R;lags]
    L:$[lags>=0;lags;1|"i"$sqrt sqrt R`n];
    S:flip[X]mmu X:(R`X)*R`e;
    if[L>0;S:S+(+/)((L-til L)%1+L)*
        {[X;l]flip[X]+X:flip[l _X]mmu neg[l]_X}[X]'[1+til L]];
    linregtests R,enlist[`S]!enlist(Z mmu S)mmu Z:.qml.minv flip[R`X]mmu R`X};

\d .