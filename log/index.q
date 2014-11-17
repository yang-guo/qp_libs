\d .log
h:0N;
new:{[logname] @[hsym[logname] set;();{[err] :0b}];1b};
open:{[logname] h::@[hopen;hsym logname;{:0N;}];h};
close:{if[not null h;@[hclose;h;{h::0N;:0b}];h::0N;];1b};
write:{[msg] if[not null h;h msg]};
read:{[logname] @[-11!;hsym logname;{:-1}]};
\d .