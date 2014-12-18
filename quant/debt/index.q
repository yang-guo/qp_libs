\d .debt
ann.pv:{[pmt;int;n]pmt*(1-(1+int)xexp(-)n)%int}
ann.pmt:{[pv;int;n](int*pv)%1-(1+int)xexp(-)n}
ann.int:{[pv;pmt;n]{[pv;pmt;n;int]int-((pv*int)-pmt*(1-(1+int)xexp(-)n))%(pv+pmt*n*(1+int)xexp(-)n+1)}[pv;pmt;n]/[0.05]}
ann.n:{[pv;pmt;int]log[(%)1-(pv*int)%pmt]%log[1+int]}
ann.loanschedule:{[pv;pmt;int;n](+)`l`p`i!(+){[i;p;v]ip:v[0]*i;(v[0]-pp;pp:p-ip;ip)}[int;pmt]\[n;(pv;0;0)]}
\d .