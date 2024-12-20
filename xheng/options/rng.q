.qp.require["qml"]   
                                                                                                                                                
\l ../quant.q / Originally from gordon baker gbkr.com
\l ../stat.q
\d .rng

///////////// Random Number Generations //////////////////////////
/ Single RNs
uniformRN:{[] (1?1f)[0] }

gaussianRN:()!()
haveNextGaussianRN:0;
nextGaussianRN:0f;
gaussianRN[`bm_fast]:{
    / Box-Muller takes two uniform(0,1) RNs and produces 2 standard normal RNs. Only 1 of them is returned, 
    / We only have to compute them every other time. We cache the second random number
    compute:1;
    if [haveNextGaussianRN; compute:0; result:nextGaussianRN; haveNextGaussianRN::0];
    if [compute; w:1f; 
        while [w>=1f; x1:(2f*uniformRN[])- 1f; x2:(2f*uniformRN[])- 1f; w:(x1*x1)+ x2*x2]; 
        w:sqrt (-2f* log w) % w;
        y1:x1*w;
        y2:x2*w;
        nextGaussianRN::y2;
        haveNextGaussianRN::1;
        result:y1
        ];
        :result
    }

gaussianRN[`bm_slow]:{ r:last {p:-1+ (2?2.0); xx::p 0; sum p*p}\[1<;2];
    :xx* sqrt ((-2.0 * log r) % r) }

gaussianRN[`inverse]:{ .qml.nicdf uniformRN[] } / inversion method

/ a vector of RNs
vec_gaussianRN:()!()
vec_gaussianRN[`inverse]:{[N] .qml.nicdf N?1f }
vec_gaussianRN[`bm_fast]:{[N] vec:gaussianRN each N#`bm_fast }

/ a matrix of RNs
/ mat_gaussianRN:{[algo,nRows,nCols] all_RNs:vec_gaussianRN[algo] nRows*nCols;
/   :(nRows;0N)#all_RNs }

/////////////// Testing /////////////////////
test:{[runTest] if[ not runTest; :`$"rnq.q test is not run"];
    N:`long$100; inver:vec_gaussianRN[`inverse] N; bm:vec_gaussianRN[`bm_fast] N;
    0N! `$"Inverse method"; 0N! avg inver; 0N! .stat.stderr inver;
    0N! `; 0N! `$"BM method"; 0N! avg bm; 0N! .stat.stderr bm;
    }

runTest:0b
test[ runTest]

\d . / End of program