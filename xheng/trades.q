/ q-sql example from chapter 8 of q for mortals

instrument:([sym:`symbol$()] 
 name:`symbol$(); industry:`symbol$())

trade:([] sym:`instrument$(); date:`date$(); time:`time$(); quant:`int$(); px:`float$() )

`instrument insert (`ibm; `$"international business machine"; `$"computer services")
`instrument insert (`msft; `microsoft; `software)
`instrument insert (`g; `google; `internet)

filltrade:{[tname;s;p;n]
    // tname: table name
    // s: sym, p: price, n: item count
    sc:n#s; / sym column
    dc:2007.01.01+n?31;
    tc:n?24:00:00.000;
    qc:10*n?1000;
    pc:0.01*floor (0.9*p)+n?0.2*p*:100;
    tname insert (sc;dc;tc;qc;pc)
    }

filltrade[`trade; `ibm; 115; 10000]
filltrade[`trade; `msft; 30; 5000]
filltrade[`trade; `g; 540; 12000]

`date`time xasc `trade

select count i by sym from trade

select totq:sum quant, avgq:avg quant by sym from trade where sym in `ibm`msft`g
select vwap:quant wavg px by date,sym from trade where date<2007.01.03
select hi:max px, lo:min px by date, time.minute from trade where sym=`msft, date<2007.01.03

select 
