\d .nlp
lev:{m:(#)x;n:(#)y;t:(n+1;m+1)#0;t[0]:til m+1;t[;0]:til n+1;last last{[x;y;m;n;t;i]{[x;y;t;i;j]t[i;j]:$[y[i-1]=x[j-1];t[i-1;j-1];min(t[i-1;j-1]+1;min(t[i;j-1]+1;t[i-1;j]+1))];t}[x;y;;i]/[t;1+til m]}[x;y;m;n]/[t;1+til n]}
levd:{1-lev[x;y]%max((#)x;(#)y)}
levt:{mat:{m:count x;n:count y;mat:(n+1;m+1)#0;mat[0]:til m+1;mat[;0]:til n+1;
    {[x;y;m;n;mat;i]{[x;y;mat;i;j]mat[i;j]:$[y[i-1]=x[j-1];mat[i-1;j-1];min(mat[i-1;j-1]+1;min(mat[i;j-1]+1;mat[i-1;j]+1))];mat}[x;y;;i]/[mat;1+til m]}[x;y;m;n]/[mat;1+til n]
 }[x;y];flip (`nm,`$'"E",y)!((,)"E",x),mat}

\d .