select bd.serialno,bd.customerid,bd.customername,getbusinessname(bd.businesstype),bd.businesssum,bd.balance,bd.putoutdate,
bd.maturity,getorgname(bd.operateorgid),getitemname('VouchType',(select vouchtype from business_contract where serialno=bd.relativeserialno2)),
getItemName('GuarantyList',gi.GuarantyType),gi.GuarantyRate,gi.EvalNetValue,gi.AboutSum2
 from business_duebill bd left outer join guaranty_relative gr on gr.objectno=bd.relativeserialno2 
left outer join guaranty_info gi on gr.guarantyid=gi.guarantyid
where bd.balance>0  and getcustomertype(bd.customerid) like '01%';