db2 "IMPORT FROM /dev/null OF DEL REPLACE INTO BUSINESS_CONTRACT"
db2 "IMPORT FROM /dev/null OF DEL REPLACE INTO BUSINESS_DUEBILL"
db2 "IMPORT FROM /dev/null OF DEL REPLACE INTO BUSINESS_EXTENSION"
db2 "IMPORT FROM /dev/null OF DEL REPLACE INTO ENT_INFO"
db2 "IMPORT FROM /dev/null OF DEL REPLACE INTO CONTRACT_RELATIVE"
db2 "IMPORT FROM /dev/null OF DEL REPLACE INTO GUARANTY_CONTRACT"
db2 "IMPORT FROM /dev/null OF DEL REPLACE INTO BUSINESS_WASTEBOOK"

db2 "import from ./tab65.ixf of ixf commitcount 10000 insert into BUSINESS_CONTRACT"
db2 "import from ./tab67.ixf of ixf commitcount 10000 insert into BUSINESS_DUEBILL"
db2 "import from ./tab68.ixf of ixf commitcount 10000 insert into BUSINESS_EXTENSION"
db2 "import from ./tab158.ixf of ixf commitcount 10000 insert into ENT_INFO"
db2 "import from ./tab110.ixf of ixf commitcount 10000 insert into CONTRACT_RELATIVE"
db2 "import from ./tab201.ixf of ixf commitcount 10000 insert into GUARANTY_CONTRACT"
db2 "import from ./tab74.ixf of ixf commitcount 10000 insert into BUSINESS_WASTEBOOK"

//贷款类业务
select 
getorgname(bc.manageorgid) as 业务发生机构,
ei.EnterpriseName as 借款人名称,
ei.loancardno as 贷款卡编码,
bc.serialno as 贷款合同编号,
bd.serialno as 借据编号,
getitemname('Currency',bc.businesscurrency) as 币种,
bc.businesssum as 合同金额,
bd.balance as 借据余额,
bd.putoutdate as 借款放款日期,
bd.actualmaturity as 放款到期日期,
(select case when count(*)>0 then '是' else '否' end from business_extension where business_extension.relativeserialno=bd.serialno) as 展期标志,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '是' else '否'  end as 担保标志
from business_duebill bd left join business_contract bc on bd.relativeserialno2=bc.serialno 
     left join ent_info ei on bd.customerid=ei.customerid 
     left join business_type bt on bd.businesstype=bt.typeno
where  
//BC.TempSaveFlag='2' 
//and BC.BusinessSum>0 
//and BC.OccurType is not null 
//and BC.OccurType not in ('015','') 
//and EI.TempSaveFlag='2' 
//and EI.OrgNature like '01%' 
//and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
//and 
BT.Attribute15 like '1%' 
//and (bc.finishdate is null or bc.finishdate='')

//贸易融资类业务  合同存在终结日期的不上报
select 
getorgname(bc.manageorgid) as 业务发生机构,
ei.EnterpriseName as 借款人名称,
ei.loancardno as 贷款卡编码,
bc.serialno as 融资协议编号,
bd.serialno as 融资业务编号,
getitemname('Currency',bc.businesscurrency) as 币种,
bc.businesssum as 融资协议金额,
bd.balance as 融资余额,
bd.putoutdate as 融资业务发生日期,
bd.actualmaturity as 融资业务结束日期,
(select case when count(*)>0 then '是' else '否' end from business_extension where business_extension.relativeserialno=bd.serialno) as 展期标志,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '是' else '否'  end as 担保标志
from business_duebill bd left join business_contract bc on bd.relativeserialno2=bc.serialno 
     left join ent_info ei on bd.customerid=ei.customerid 
     left join business_type bt on bd.businesstype=bt.typeno
where  
//BC.TempSaveFlag='2' 
//and BC.BusinessSum>0 
//and BC.OccurType is not null 
//and BC.OccurType not in ('015','') 
//and EI.TempSaveFlag='2' 
//and EI.OrgNature like '01%' 
//and EI.LoanCardNo is not null 
//and length(EI.LoanCardNo)>=16 
//and 
BT.Attribute15 like '4%' 
//and (bc.finishdate is null or bc.finishdate='') 

//保函类业务  合同存在终结日期的不上报
select 
getorgname(bc.manageorgid) as 业务发生机构,
ei.EnterpriseName as 借款人名称,
ei.loancardno as 贷款卡编码,
bd.serialno as 业务编号,
getitemname('Currency',bc.businesscurrency) as 币种,
bd.businesssum as 保函金额,
bd.balance as 保函余额,
bd.putoutdate as 保函开立日期,
(case when BD.ACTUALMATURITY is null or BD.ACTUALMATURITY = ''  then BD.Maturity else  BD.ACTUALMATURITY end)  as 保函到期日,
//(select case when count(*)>0 then '是' else '否' end from business_extension where business_extension.relativeserialno=bd.serialno) as 展期标志,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '是' else '否'  end as 担保标志
from business_duebill bd left join business_contract bc on bd.relativeserialno2=bc.serialno 
     left join ent_info ei on bd.customerid=ei.customerid 
     left join business_type bt on bd.businesstype=bt.typeno
where  
 EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
and 
BT.Attribute15 like '6%' 
//and (bc.finishdate is null or bc.finishdate='')
//

//承兑汇票
select 
getorgname(bc.manageorgid) as 业务发生机构,
ei.EnterpriseName as 出票人名称,
ei.loancardno as 贷款卡编码,
bd.serialno as 业务编号,
getitemname('Currency',bc.businesscurrency) as 币种,
bd.businesssum as 汇票金额,
bd.putoutdate as 汇票承兑日,
(case when BD.ACTUALMATURITY is null or BD.ACTUALMATURITY = ''  then BD.Maturity else  BD.ACTUALMATURITY end) as 汇票到期日,
//(select case when count(*)>0 then '是' else '否' end from business_extension where business_extension.relativeserialno=bd.serialno) as 展期标志,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '是' else '否'  end as 担保标志
from business_duebill bd left join business_contract bc on bd.relativeserialno2=bc.serialno 
     left join ent_info ei on bd.customerid=ei.customerid 
     left join business_type bt on bd.businesstype=bt.typeno
where  
 EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
and BD.PutoutDate <='2012/02/29'
and BD.BusinessSum > 0 
and 
BT.Attribute15 like '7%' 
//and (bc.finishdate is null or bc.finishdate='')

//信用证
select 
getorgname(bc.manageorgid) as 业务发生机构,
ei.EnterpriseName as 借款人名称,
ei.loancardno as 贷款卡编码,
bd.serialno as 业务编号,
getitemname('Currency',bc.businesscurrency) as 开证币种,
bd.BusinessSum as 开证金额,
bd.balance as 信用证余额,
bd.putoutdate as 开证日期,
(case when BD.ACTUALMATURITY is null or BD.ACTUALMATURITY = ''  then BD.Maturity else  BD.ACTUALMATURITY end)  as 信用证有效期,
//(select case when count(*)>0 then '是' else '否' end from business_extension where business_extension.relativeserialno=bd.serialno) as 展期标志,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '是' else '否'  end as 担保标志
from business_duebill bd left join business_contract bc on bd.relativeserialno2=bc.serialno 
     left join ent_info ei on bd.customerid=ei.customerid 
     left join business_type bt on bd.businesstype=bt.typeno
where  
//BC.TempSaveFlag='2' 
//and BC.BusinessSum>0 
//and BC.OccurType is not null 
//and BC.OccurType not in ('015','') 
//and EI.TempSaveFlag='2' 
//and EI.OrgNature like '01%' 
//and EI.LoanCardNo is not null 
//and length(EI.LoanCardNo)>=16 
//and 
BT.Attribute15 like '5%' 

//欠息
select
'天津农商银行总行' as 业务发生机构,
ei.EnterpriseName as 欠息企业名称,
ei.loancardno as 贷款卡编码,
 '表内' as 欠息类型,
getitemname('Currency',bd.BusinessCurrency) as  币种,
sum(BD.InterestBalance3) as  欠息余额
from BUSINESS_DUEBILL BD,ENT_INFO EI
where 
BD.CustomerID = EI.CustomerID
and ei.customerid is not null and ei.customerid<>''
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
group by ei.EnterpriseName,ei.loancardno,bd.BusinessCurrency
 having sum(InterestBalance3)>0  
union	
select
'天津农商银行总行' as 业务发生机构,
ei.EnterpriseName as 欠息企业名称,
ei.loancardno as 贷款卡编码,
 '表外' as 欠息类型,
getitemname('Currency',bd.BusinessCurrency) as  币种,
sum(BD.InterestBalance2) as  欠息余额
from BUSINESS_contract BD ,ENT_INFO EI 
where 
BD.CustomerID = EI.CustomerID 
and ei.customerid is not null and ei.customerid<>''
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
group by ei.EnterpriseName,ei.loancardno,bd.BusinessCurrency
 having sum(InterestBalance2)>0 
 
//公开授信  到日期大于核对日期
select
getorgname(bc.manageorgid) as 业务发生机构,
ei.EnterpriseName as 借款人名称,
ei.loancardno as 贷款卡编码,
bc.serialno as 授信协议号码,
getitemname('Currency',bc.businesscurrency) as 币种,
bc.businesssum as 授信额度,
bc.putoutdate as 授信生效日期,
bc.maturity as 授信终止日期
from BUSINESS_CONTRACT BC,BUSINESS_TYPE BT,ENT_INFO EI                        
where BC.BusinessType = BT.TypeNO
and BC.CustomerID = EI.CustomerID
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
and BT.Attribute15 like '8%'
and bc.inuseflag is not null
//and bc.maturity>='2012/02/29' and (bc.finishdate is null or bc.finishdate='')

//表内保证担保
select
getorgname(bc.manageorgid) as 业务发生机构,
ltrim(rtrim(GC.GuarantorName)) as 保证人名称,
coalesce(getloancardno(GC.guarantorid),'') as 保证人贷款卡编码,
bc.customername as 被担保企业名称,
coalesce(getloancardno(bc.customerid),'') as 被担保企业贷款卡编码,
bc.serialno as 主合同编号,
GC.SerialNo as 保证合同编号,
getitemname('Currency',GC.GuarantyCurrency) as 币种,
gc.GUARANTYVALUE as 保证金额
from GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC,ENT_INFO EI,BUSINESS_TYPE BT
where BC.SerialNo = CR.SerialNo
and CR.ObjectNo = GC.SerialNo
and EI.CustomerID = BC.CustomerID
and BT.TypeNO = BC.BusinessType
and CR.ObjectType = 'GuarantyContract'
and GC.GuarantyType like '010%' //担保方式：010010=保证,010040=保证金}
and GC.ContractStatus ='020'
and (BT.Attribute15 like '1%' or BT.Attribute15 like '4%')
and getloancardno (GC.guarantorid)<>''
and BC.TempSaveFlag='2' 
and BC.BusinessSum>0 
and BC.OccurType is not null 
and BC.OccurType not in ('015','') 
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
and gc.GUARANTYVALUE >0
and (bc.finishdate is null or bc.finishdate='');

//表外保证担保
select
getorgname(bc.manageorgid) as 业务发生机构,
ltrim(rtrim(GC.GuarantorName)) as 保证人名称,
coalesce(getloancardno(GC.guarantorid),'') as 保证人贷款卡编码,
bc.customername as 被担保企业名称,
coalesce(getloancardno(bc.customerid),'') as 被担保企业贷款卡编码,
bd.serialno as 主合同编号,
GC.SerialNo as 保证合同编号,
getitemname('Currency',GC.GuarantyCurrency) as 币种,
gc.GUARANTYVALUE as 保证金额
from GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC,BUSINESS_DUEBILL BD,ENT_INFO EI,BUSINESS_TYPE BT
where BC.SerialNo = CR.SerialNo
and CR.ObjectNo = GC.SerialNo
and bd.relativeserialno2=bc.serialno
and EI.CustomerID = BC.CustomerID
and BT.TypeNO = BC.BusinessType
and CR.ObjectType = 'GuarantyContract'
and GC.GuarantyType like '010%' //担保方式：010010=保证,010040=保证金}
and GC.ContractStatus ='020'
and (BT.Attribute15 like '2%' or BT.Attribute15 like '5%' or BT.Attribute15 like '6%' 
         or (BT.Attribute15 like '7%' and BD.PutoutDate <='2012/02/29' and BD.BusinessSum > 0 )
      )
and getloancardno (GC.guarantorid)<>''
//and BC.TempSaveFlag='2' 
//and BC.BusinessSum>0 
//and BC.OccurType is not null 
//and BC.OccurType not in ('015','') 
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
and gc.GUARANTYVALUE >0
and (bc.finishdate is null or bc.finishdate='');

//表内抵押担保
select
getorgname(bc.manageorgid) as 业务发生机构,
ltrim(rtrim(GC.GuarantorName)) as 抵押人名称,
coalesce(getloancardno(GC.guarantorid),'') as 抵押人贷款卡编码,
bc.customername as 被担保企业名称,
coalesce(getloancardno(bc.customerid),'') as 被担保企业贷款卡编码,
BC.SerialNo as 主合同编号,
GC.SerialNo as 抵押合同编号,
getitemname('Currency',GC.GuarantyCurrency) as 币种,
gi.AboutSum2 as 抵押金额
from GUARANTY_CONTRACT GC,GUARANTY_INFO GI,GUARANTY_RELATIVE GR,CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC,BUSINESS_TYPE BT,ENT_INFO EI					
where GR.GuarantyID = GI.GuarantyID
and BC.BusinessType = BT.TypeNO
and EI.CustomerID = BC.CustomerID
and BC.SerialNo = CR.SerialNo
and CR.ObjectNo = GC.SerialNo
and GR.ContractNo = GC.SerialNo
and getloancardno (GC.guarantorid)<>''
and CR.ObjectType = 'GuarantyContract'	
and GR.ObjectType = 'BusinessContract'							
and GC.GuarantyType = '050' 
and GC.ContractStatus = '020'
and (BT.Attribute15 like '1%' or BT.Attribute15 like '4%')
and BC.TempSaveFlag='2' 
and BC.BusinessSum>0 
and BC.OccurType is not null 
and BC.OccurType not in ('015','') 
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
and gc.GUARANTYVALUE >0
and (bc.finishdate is null or bc.finishdate='')

//表外抵押担保
select
getorgname(bc.manageorgid) as 业务发生机构,
ltrim(rtrim(GC.GuarantorName)) as 抵押人名称,
coalesce(getloancardno(GC.guarantorid),'') as 抵押人贷款卡编码,
bc.customername as 被担保企业名称,
coalesce(getloancardno(bc.customerid),'') as 被担保企业贷款卡编码,
Bd.SerialNo as 主合同编号,
GC.SerialNo as 抵押合同编号,
getitemname('Currency',GC.GuarantyCurrency) as 币种,
gi.AboutSum2 as 抵押金额
from GUARANTY_CONTRACT GC,GUARANTY_INFO GI,GUARANTY_RELATIVE GR,CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC,BUSINESS_DUEBILL BD,BUSINESS_TYPE BT,ENT_INFO EI					
where GR.GuarantyID = GI.GuarantyID
and BC.BusinessType = BT.TypeNO
and EI.CustomerID = BC.CustomerID
and bc.serialno=bd.RelativeSerialNo2
and BC.SerialNo = CR.SerialNo
and CR.ObjectNo = GC.SerialNo
and GR.ContractNo = GC.SerialNo
and getloancardno (GC.guarantorid)<>''
and CR.ObjectType = 'GuarantyContract'	
and GR.ObjectType = 'BusinessContract'							
and GC.GuarantyType = '050' 
and GC.ContractStatus = '020'
and (BT.Attribute15 like '2%' or BT.Attribute15 like '5%' or BT.Attribute15 like '6%' 
         or (BT.Attribute15 like '7%' and BD.PutoutDate <='2012/02/29' and BD.BusinessSum > 0 )
      )
//and BC.TempSaveFlag='2' 
//and BC.BusinessSum>0 
//and BC.OccurType is not null 
//and BC.OccurType not in ('015','') 
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
and gc.GUARANTYVALUE >0
and (bc.finishdate is null or bc.finishdate='');

//表内质押担保
select
getorgname(bc.manageorgid) as 业务发生机构,
ltrim(rtrim(GC.GuarantorName)) as 出质人名称,
coalesce(getloancardno(GC.guarantorid),'') as 出质人贷款卡编码,
bc.customername as 被担保企业名称,
coalesce(getloancardno(bc.customerid),'') as 被担保企业贷款卡编码,
BC.SerialNo as 主合同编号,
GC.SerialNo as 质押合同编号,
getitemname('Currency',GC.GuarantyCurrency) as 币种,
gi.confirmvalue as  质押金额
from GUARANTY_CONTRACT GC,GUARANTY_INFO GI,GUARANTY_RELATIVE GR,CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC,BUSINESS_TYPE BT,ENT_INFO EI					
where GR.GuarantyID = GI.GuarantyID
and BC.BusinessType = BT.TypeNO
and EI.CustomerID = BC.CustomerID
and BC.SerialNo = CR.SerialNo
and CR.ObjectNo = GC.SerialNo
and GR.ContractNo = GC.SerialNo
and getloancardno (GC.guarantorid)<>''
and CR.ObjectType = 'GuarantyContract'	
and GR.ObjectType = 'BusinessContract'							
and GC.GuarantyType = '060' 
and GC.ContractStatus = '020'
and (BT.Attribute15 like '1%' or BT.Attribute15 like '4%')
and BC.TempSaveFlag='2' 
and BC.BusinessSum>0 
and BC.OccurType is not null 
and BC.OccurType not in ('015','') 
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
and gc.GUARANTYVALUE >0
and (bc.finishdate is null or bc.finishdate='')

//表外质押担保
select
getorgname(bc.manageorgid) as 业务发生机构,
ltrim(rtrim(GC.GuarantorName)) as 出质人名称,
coalesce(getloancardno(GC.guarantorid),'') as 出质人贷款卡编码,
bc.customername as 被担保企业名称,
coalesce(getloancardno(bc.customerid),'') as 被担保企业贷款卡编码,
Bd.SerialNo as 主合同编号,
GC.SerialNo as 质押合同编号,
getitemname('Currency',GC.GuarantyCurrency) as 币种,
gi.confirmvalue as  质押金额
from GUARANTY_CONTRACT GC,GUARANTY_INFO GI,GUARANTY_RELATIVE GR,CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC,BUSINESS_DUEBILL BD,BUSINESS_TYPE BT,ENT_INFO EI					
where GR.GuarantyID = GI.GuarantyID
and BC.BusinessType = BT.TypeNO
and EI.CustomerID = BC.CustomerID
and bc.serialno=bd.RelativeSerialNo2
and BC.SerialNo = CR.SerialNo
and CR.ObjectNo = GC.SerialNo
and GR.ContractNo = GC.SerialNo
and getloancardno (GC.guarantorid)<>''
and CR.ObjectType = 'GuarantyContract'	
and GR.ObjectType = 'BusinessContract'							
and GC.GuarantyType = '060' 
and GC.ContractStatus = '020'
and (BT.Attribute15 like '2%' or BT.Attribute15 like '5%' or BT.Attribute15 like '6%' 
         or (BT.Attribute15 like '7%' and BD.PutoutDate <='2012/02/29' and BD.BusinessSum > 0 )
      )
//and BC.TempSaveFlag='2' 
//and BC.BusinessSum>0 
//and BC.OccurType is not null 
//and BC.OccurType not in ('015','') 
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
and gc.GUARANTYVALUE >0
and (bc.finishdate is null or bc.finishdate='');


//还款信息
select 
getorgname(bc.manageorgid) as 业务发生机构,
bc.serialno as 合同编码,
bd.serialno as 借据编码,
ei.loancardno as 贷款卡编码,
case when BW.BusinessDesc = '6100' then '核损核销' else '正常收回' end as 还款方式,
BW.OccurDate as 还款日期,
sum(BW.ActualCreditSum) as 还款金额
from BUSINESS_WASTEBOOK BW,BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC,ENT_INFO EI,BUSINESS_TYPE BT
where BW.RelativeSerialNo = BD.SerialNo
and BD.RelativeSerialNo2 = BC.SerialNo
and BD.CustomerID = EI.CustomerID
and BD.BusinessType = BT.TypeNO
and BT.Attribute15 like '1%'
and (BW.TransactionFlag='0' or BW.TransactionFlag='3')
and BW.ActualCreditSum <> 0  
and BW.OccurDirection='1' 
and BW.OccurSubject='0' 
and BC.TempSaveFlag='2' 
and BC.BusinessSum>0 
and BC.OccurType is not null 
and BC.OccurType not in ('015','') 
and EI.TempSaveFlag='2' 
and EI.OrgNature like '01%' 
and EI.LoanCardNo is not null 
and length(EI.LoanCardNo)>=16 
group by bd.serialno,bc.serialno,ei.loancardno,BW.Occurdate,BW.BusinessDesc,bc.manageorgid;