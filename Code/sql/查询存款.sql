//其它存款
SELECT ACCT,CCNAME,BALE,BALEY,LSTDTE,LSTTXD
FROM "B4DTALIBT"."DPSFMACDC"
where acct like '903100100010012839%' and bale>0

//我的存款
SELECT ACCT,CCNAME,BALE,BALEY,LSTDTE,LSTTXD
FROM "B4DTALIBT"."DPSFMACDC"
where acct='9031001000100128390127'
