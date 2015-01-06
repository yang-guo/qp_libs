\d .db
convertschema:{[d](+){$[upper[x]=x:(*)x;();x$()]}'[d]}
validate:{[s]k:(!)s;{[k;x]if[(~)x in k;'`$"NO_",(($)x),"_GIVEN"]}[k]'[`name`location`tables];
    {{if[(~)z in(!)y;'`$(($)x),"_MISSING_",($)z]}[x;y]'[`type`schema];
    if[(~)(`$y`type)in`flat`splayed`partitioned`segmented;'`$(($)x),"_TYPE_NOT_VALID"];}'[(!)n;n:s`tables];s}
create:{[s]s:validate[s];s[`tables]:{x[`table]:convertschema x`schema;x}'[s`tables];
    {d:x[y;`table];.[y;();:;$[`partitioned=`$x[y;`type];(+)((*)(!)x[y;`schema])_(+)d;d]]}[s`tables]'[(!)s`tables]}
.db.save:{[s;t;p]s:validate[s];b:`$":",(s`location),"/",(s`name);tp:`$s[`tables;t;`type];$[tp=`flat;save` sv b,t;tp=`splayed;(` sv b,t,`)set .Q.en[b](.)t;tp=`partitioned;.Q.dpft[b;p;(*)1_(!)s[`tables;t;`schema];t];""]}

\d .