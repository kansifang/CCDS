select count(*) from business_contract where PigeonholeDate = '2010/06/04' and  serialno in (select relativeserialno2 from business_duebill ) and businessType not in ('1110010','1110020' ,'1140060' ,'1140010' ,'1140020' ,'1140110'  ,'2110010','1140025','1110025');