\d .quant
/pi const
pi:acos -1;pi2:sqrt 2*pi;spi2:sqrt 2*pi;ipi:(%)pi;ispi:(%)sqrt pi;ispi2:(%)sqrt 2*pi;is2:(%)sqrt 2;
/hyperoblic functions
sinh:{0.5*(exp x)-exp(-)x};cosh:{0.5*(exp x)+exp(-)x};tanh:{(e-1)%(e:exp 2*x)+1}
/gamma functions
LANCZOS: 0.99999999999980993 676.5203681218851 -1259.1392167224028 771.32342877765313 -176.61502916214059 12.507343278686905 -0.13857109526572012 9.9843695780195716e-6 1.5056327351493116e-7
gamma:{{$[x=0;0w;x<0.5;pi%(sin pi*x)*.z.s 1-x;spi2*(t xexp x-0.5)*(exp(-)t:x+6.5)*sum LANCZOS%1,x+til 8]}each x}
/erf
ERF:{(0.5+x)%(1+x)*1.5+x}til 42;
erf:{{n:x<0;x:abs x;r:$[x>0;1&(2*x*ispi)*1+sum(*\)((-)x*x)*ERF;0f];$[n;(-)r;r]}each x}
/standard distributions
gauss.cdf:{{$[x<0;1-.z.s abs x;0.5*1+erf x*is2]}each x};gauss.pdf:{(exp(-)0.5*x*x)*ispi2}
laplace.cdf:{0.5*1+(signum x)*1-exp(-)abs x};laplace.pdf:{0.5*exp(-)abs x}
logistic.cdf:{(%)1+exp(-)x};logistic.pdf:{e%d*d:1+e:exp(-)x}
student1.cdf:{0.5*ipi*atan x};student1.pdf:{(%)pi*1+x*x}
student2.cdf:{0.5*1+x%sqrt 2+x*x};student2.pdf:{(%)(2+x*x)xexp 1.5}
\d .