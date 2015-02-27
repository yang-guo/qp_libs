
\d .stats

variance:{[x] n:count x; avg_x:avg x; (sum (x-avg_x)* x-avg_x) % (n-1.0) } / variance and standard deviation
stdev:{ sqrt variance x }
stderr:{ stdev[x] % sqrt count x}