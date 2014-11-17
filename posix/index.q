\d .posix

const:946684800;
mult:{$[x=`s;1;x=`ms;1000;x=`us;1000000;x=`ns;1000000000]}
convert:{[typ;ptime]m:mult[typ];"p"$(ptime-const*m)*1000000000%m}
divi:{$[x=`s;1000000000;x=`ms;1000000;x=`us;1000;x=`ns;1]}
revert:{[typ;ts]d:divi[typ];ts:$[-12h=type ts;ts;"p"$ts];"j"$(("j"$ts)+1000000000*const)%d}

\d .