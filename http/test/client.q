.qp.require["http"]
.qp.require["timer"]

inc:0;outc:0;
.timer.add[{inc+::1;.http.getAsync[{outc+::1;xx::(x;y;z)};"http://localhost:8000"]};200]