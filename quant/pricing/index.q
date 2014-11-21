\d .pricing
vwap:{[p;s;v]{[p;s;v;l](sum p[l]*n)%sum n:{$[x>=y;z;z+x-y]}[v]'[(+\)s;s]@l}[p;s;v]where -1_1b,v>(+\)s}
\d .