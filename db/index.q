\d .db
convertschema:{[d](+){$[upper[x]=x:(*)x;();x$()]}'[d]}
validate:{[d]
    k:(!)d;{[k;x]if[(~)x in k;'`$"NO_",(($)x),"_GIVEN"]}[k]'[`name`location`tables];
    {{if[(~)z in(!)y;'`$(($)x),"_MISSING_",($)z]}[x;y]'[`type`schema];
    if[(~)(`$y`type)in`flat`splayed`partitioned`segmented;'`$(($)x),"_TYPE_NOT_VALID"];}'[(!)n;n:d`tables];d}

\d .