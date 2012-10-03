select ba.Serialno as 申请流水号,ba.customerID as 客户编号,ba.customername as 客户名称, getBusinessName(ba.BusinessType) as 业务品种 ,
getItemname('Currency',ba.BusinessCurrency) as 币种,ba.BusinessSum as 申请金额,ba.TermMonth as 申请期限,fo1.phasename as 审批状态,
fo.businessSum  as 审批批准金额, fo.Termmonth as 批准期限,fo.Businessrate as 批准利率,ba.BailRate as 保证金比例,
getItemName('VouchType',ba.VouchType) as 主要担保方式,fo1.flowName  as 审批流程,getusername(ba.InputUserID) as 经办人,
getorgName(ba.InputOrgID) as 经办机构,getUserName(fo.InputUser) as 审批人,getorgName(fo.Inputorg) as 审批机构,
(select left(endtime,10) from flow_task where objectno=ba.serialno and phaseno in ('1000','8000') and objecttype='CreditApply') as 审批通过时间,
getitemname('OccurType',ba.occurtype) as 发生类型
from business_Apply ba, flow_opinion fo,flow_object fo1 where fo1.ObjectNO=ba.Serialno and fo1.objecttype='CreditApply'  and  fo.ObjectNO=ba.Serialno and fo.objecttype='CreditApply'  
 and fo.serialno=(select max(Relativeserialno) from flow_task ft where ft.ObjectNo=ba.serialno and ft.Objecttype='CreditApply'); 


 
//导出人员角色表
select ui.userid as 用户编号,ui.username as 用户名称,getorgname(ui.BelongOrg) as 所属机构,
getItemName('DepartMent',ui.DepartMent) as 所属部门,getItemName('IsInUse',ui.Status) as 状态,ri.rolename as 角色名称
 from user_info ui,user_role ur,role_info ri 
 where ui.userid=ur.userid and ur.roleid=ri.roleid
 order by ui.userid,ui.BelongOrg,ui.DepartMent desc;
 
//导出个人借据查询
 select BD.SerialNo as 借据流水号,BD.RelativeSerialNo2 as 合同流水号,BD.CustomerID as 客户编号 ,BD.CustomerName as 客户名称,getBusinessName(BD.BusinessType) as 业务品种,  getItemName('Currency',BD.BusinessCurrency) as 币种,
BD.Balance as 余额,BD.ActualBusinessRate as 执行月利率(‰),  BD.InterEstBalance1 as 表内欠息,BD.InterEstBalance2 as 表外欠息,BD.NormalBalance as 正常余额,
BD.OverdueBalance as 逾期余额,BD.DullBalance as 呆滞余额,BD.BadBalance as 呆账余额,  BD.PutOutDate as 借据起始日,BD.Maturity as 借据到期日,getItemName('VouchType',BC.VouchType) as 主要担保方式, 
getOrgName(BC.ManageOrgID) as 管户机构,getUserName(BC.ManageUserID) as 管户人,getOrgName(BD.MfOrgID) as 出账机构
from BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT  
where BT.TypeNo = BD.BusinessType and BT.Attribute1 = '2'  and BD.RelativeSerialNo2 = BC.SerialNo and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '100%')

//授信台账表内未结清业务
select SerialNo as 合同流水号,CustomerName as 客户名称,getBusinessName(BusinessType) as 业务品种, 
getItemName('OccurType',OccurType) as 发生类型, getItemName('Currency',BusinessCurrency) as 币种, BusinessSum as 合同金额,
nvl(Balance,0) as 余额,NormalBalance as 正常余额,OverdueBalance as 逾期余额,DullBalance as 呆滞余额,BadBalance as 呆帐余额,
BailAccount,nvl(BailSum,0) as BailSum, case when (Balance-nvl(BailSum,0))<0 then 0 else (Balance-nvl(BailSum,0)) end as ClearSum, 
nvl(InterestBalance1,0) as 表内欠息余额,nvl(InterestBalance2,0) as 表外欠息余额, 
FineBalance1 as 逾期罚息余额,FineBalance2 as 复息余额,BusinessRate as 利率,PutOutDate as 起始日期,Maturity as 到期日期, 
getItemName('VouchType',VouchType) as 担保方式, getItemName('ClassifyResult',ClassifyResult) as 当期分类认定结果, 
 getUserName(ManageUserID) as 客户经理,getOrgName(OperateOrgID) as 经办机构  
from BUSINESS_CONTRACT  
where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '100%')  and Balance >= 0 and BusinessType like '1%' 
and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null) order by CustomerName

//融资性担保机构在保情况统计表
select GC.GuarantorName as 融资性担保机构名称,BC.customername as 被担保企业名称,(select getItemName('Scope',Scope) from ent_info where customerid=BC.customerid) as 被担保企业类型,
BC.balance as 被担保贷款余额,bc.putoutdate as 贷款发放日,bc.maturity as 贷款到期日,getItemName('ClassifyResult',bc.classifyresult) as 五级清分结果
 from GUARANTY_CONTRACT GC, CONTRACT_RELATIVE CR, BUSINESS_CONTRACT BC  
where CR.SerialNo = BC.SerialNo  
and CR.ObjectNo=GC.SerialNo
and CR.ObjectType='GuarantyContract' 
and GC.ContractStatus = '020' 
and GC.GuarantorName in (
'天津中信汇通投资担保有限公司',
'中海信达担保有限公司',
'天津北辰科技园区中小企业信用担保中心',
'天津惠辰投资担保有限公司',
'天津泰达小企业信用担保中心',
'天津市大港中小企业担保有限责任公司',
'天津海泰投资担保有限责任公司',
'天津联合创业投资担保有限公司',
'天津河北区中小企业信用担保中心',
'天津沃尔德担保股份有限公司',
'金水（天津）投资担保有限公司',
'天津市中小外贸企业融资担保中心',
'天津市中小企业信用担保基金管理中心',
'天津营信投资担保有限公司',
'天津联众担保有限公司',
'天津市静海县新农村建设担保服务中心',
'天津市宁河县新农村建设担保服务中心',
'天津市武清区城乡建设信用担保中心',
'天津华正投资担保有限公司',
'天津日升昌投资担保有限公司',
'天津市汇青投资担保有限公司',
'天津市赛达恒信担保有限公司'
);

//个人住房按揭贷款统计表2011-11
select * from 
(
select ba.Serialno as 申请流水号,
getorgName(ba.InputOrgID) as 经办机构,ba.customername as 客户名称,getBusinessName(ba.BusinessType) as 业务品种,fo.RateFloat as 利率浮动值,
fo.Businessrate as 批准利率,fo.businessSum/10000  as 审批批准金额（万元）, fo.Termmonth as 批准期限,
(select left(endtime,10) from flow_task where objectno=ba.serialno and phaseno ='1000' and objecttype='CreditApply') as 审批通过时间,
(select left(endtime,10) from flow_task where objectno=ba.serialno and phaseno='0020' and objecttype='CreditApproveApply') as 批复时间,
getUserName(fo.InputUser) as 最终审批人
from business_Apply ba, flow_opinion fo,flow_object fo1 

where fo1.ObjectNO=ba.Serialno and fo1.objecttype='CreditApply'  and  fo.ObjectNO=ba.Serialno and fo.objecttype='CreditApply'  
 and fo.serialno=(select max(Relativeserialno) from flow_task ft where ft.ObjectNo=ba.serialno and ft.Objecttype='CreditApply')
 and ba.businesstype in ('1110010','1110020','1110025','1110027')
)

where 审批通过时间>='2011/11/01' and 审批通过时间<='2011/11/30' order by 经办机构
; 

//取待刷新的客户列表
select 
   EI.CustomerID,EI.EnterpriseName,getItemName('CertType',CI.CertType) as CertTypeName,
   CI.CertID,getItemName('IndustryName',IndustryName) as IndustryName,EI.EmployeeNumber,
   EI.SellSum,EI.TotalAssets,getItemName('Scope',EI.scope) as Scope,
   getItemName('EntScale',EI.LockEntScale) as LockEntScale  
from ENT_INFO EI,CUSTOMER_INFO CI   
where CI.CustomerType like '01%'  and CI.CustomerType<>'0107'  and CI.CustomerID = EI.CustomerID and 
     (EI.lockentscale = '02' or EI.lockentscale is null or EI.lockentscale = '') and
     ci.customerid in (select customerid from business_contract union select guarantorid from guaranty_contract where ContractStatus = '020')

//导出与人行重点信息系统报送数据
select 
bc.serialno as 合同流水号,
getbusinessname(businesstype) as 业务品种,
bc.putoutdate as 合同起始日,
bc.maturity as 合同到期日,
bc.businesssum as 合同金额,
bc.balance as 总余额,
bc.interestbalance1 as 表内欠息,
bc.interestbalance2 as 表外欠息,
getItemName('AdjustRateType',AdjustRateType) as 利率调整方式,
getItemName('RateFloatType',RateFloatType) as 利率浮动方式 ,
RateFloat as 利率浮动值,
bc.BusinessRate 执行利率,
bc.customername as 企业姓名,
gc.serialno as 担保合同流水号,
gc.GuarantorName as 担保人名称,
getItemName('GuarantyType',GC.GuarantyType) as 担保类型,
gc.GuarantyValue as 担保人金额
from business_contract bc,CONTRACT_RELATIVE CR,guaranty_contract gc
where bc.serialno=cr.serialno
and gc.serialno=cr.objectno
and CR.ObjectType='GuarantyContract' 
and (bc.businesstype like '10%' or bc.businesstype like '20%' or bc.businesstype='3010')
order by bc.serialno,businesstype

