\d .http
if["l"<>(*)($).z.o;'`NIX_ONLY];
{x set (`$string[.z.o],"/http") 2:x,y}'[`init`getAsync`getAsynch`postAsync;1 2 3 4];
parsedict:{"&"sv"="sv/:string flip(key[x];value[x])}
pipe:{[sfn;ffn;d;r;e]$[(r=200)&(e=0);sfn d;ffn(r;e)]}
init[]
\d .