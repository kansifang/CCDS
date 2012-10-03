select serialno,relativeserialno2,customerid,customername,getbusinessname(businesstype),getitemname('Currency',businesscurrency),balance,actualbusinessrate,interestbalance1,interestbalance2,
normalbalance,overduebalance,dullbalance,badbalance,putoutdate,maturity,overduedays,
(select getitemname('VouchType',vouchtype) from business_contract bc where bc.serialno=bd.relativeserialno2),
(select getorgname(manageorgid) from business_contract bc where bc.serialno=bd.relativeserialno2),
(select getusername(manageuserid) from business_contract bc where bc.serialno=bd.relativeserialno2)
 from business_duebill bd where balance>0;
 
 
 select serialno,customername,
getitemname('CustomerType',left(getcustomertype(customerid),2)),
getbusinessname(businesstype),getitemname('OccurType',occurtype),
getitemname('Currency',businesscurrency),businesssum,balance,
normalbalance,overduebalance,dullbalance,badbalance,
(case when AgriLoanClassify like '040%' then '否' else '是' end),
getItemName('AgriLoanClassify1',AgriLoanClassify),
getorgname(manageorgid),
getusername(manageuserid)

 from business_contract where balance>0;


---取流水
select bc.customerid,bc.customername,
getitemname('CustomerType',left(getcustomertype(bc.customerid),2)),BD.Serialno,
getitemname('OccurType',bc.occurtype),
getitemname('VouchType',bc.VouchType),
bc.putoutdate,bc.maturity,bc.businesssum,'',bc.balance,
getItemName('OccurDirection',bw.OccurDirection) as OccurDirectionName,
bw.OccurDate,bw.ActualDebitSum,bw.ActualCreditSum ,
getorgname(bc.manageorgid),
getusername(bc.manageuserid)

 from business_contract bc,business_wastebook bw,business_duebill bd where bc.serialno=bw.RelativeContractNo and bc.serialno=bd.relativeserialno2 and bc.balance>0 and bw.OccurSubject='0';

//select * from code_library where codeno ='AgriLoanClassify1';