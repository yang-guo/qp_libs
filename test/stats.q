
\d .stats

variance:{[x] n:count x; 1.0% (n-1.0) * (avg x*x) - (avg x) * avg x } / variance and standard deviation
stdev:{ sqrt variance x }