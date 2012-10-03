非正常：
SELECT "B4DTALIBT"."LNSFMMACT".ACCT , "B4DTALIBT"."LNSFMSACT".SBJCOD, "B4DTALIBT"."LNSFMSACT".ACTFLG,  
"B4DTALIBT"."LNSFMSACT".CURBAL FROM 
"B4DTALIBT"."LNSFMMACT" , "B4DTALIBT"."LNSFMSACT" WHERE ACCND      
in('01','02','03','04') and "B4DTALIBT"."LNSFMMACT".ACCT= "B4DTALIBT"."LNSFMSACT".FMACCT ;
正常：
SELECT * froM LNSFMMACT WHERE ACCND in('01')

LNSFMSACT表中的账户标志：
 02: 逾期     03: 呆滞      04: 呆帐          
 11: 表内应收 12: 待核销应收 13: 逾期应收     
 21: 表外利息 22: 表外复息                    
 31: 核销本金 32: 核销利息  33: 核销其它利息  
 34: 表内 180 转表外  

                        