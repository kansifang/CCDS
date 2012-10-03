db2 export to cr.del of del select BC.SerialNo as SerialNo,getBusinessName(BC.BusinessType) as BusinessTypeName,BC.CustomerName as CustomerName,BC.Balance as Balance,BC.overduedays,getItemname('VouchType',BC.vouchtype),(select getitemname('CreditLevel',CreditLevel) from ent_info where customerid=BC.customerid),(select getitemname('CreditLevel',CreditLevel) from ind_info where customerid=BC.customerid),getItemName('ClassifyResult',CR.Result1) as Result1Name,CR.resultopinion1,(select getitemname('IndRPRType',IndRPRType) from ind_info where customerid = BC.customerid) from CLASSIFY_RECORD CR LEFT OUTER JOIN BUSINESS_CONTRACT BC  ON  BC.SerialNo=CR.ObjectNo and CR.ObjectType='BusinessContract' and CR.AccountMonth='2010/06'


select * from flow_opinion where objecttype ='ClassifyApply' and objectno = 'CR2010062500000059'
select * from user_role where roleid = '027';
delete from Flow_opinion where objecttype ='ClassifyApply' ;
delete from Flow_Task where objecttype ='ClassifyApply' ;
delete from flow_object where objecttype ='ClassifyApply' ;
delete from classify_record  ;