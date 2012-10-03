select ba.Serialno as ������ˮ��,ba.customerID as �ͻ����,ba.customername as �ͻ�����, getBusinessName(ba.BusinessType) as ҵ��Ʒ�� ,
getItemname('Currency',ba.BusinessCurrency) as ����,ba.BusinessSum as ������,ba.TermMonth as ��������,fo1.phasename as ����״̬,
fo.businessSum  as ������׼���, fo.Termmonth as ��׼����,fo.Businessrate as ��׼����,ba.BailRate as ��֤�����,
getItemName('VouchType',ba.VouchType) as ��Ҫ������ʽ,fo1.flowName  as ��������,getusername(ba.InputUserID) as ������,
getorgName(ba.InputOrgID) as �������,getUserName(fo.InputUser) as ������,getorgName(fo.Inputorg) as ��������,
(select left(endtime,10) from flow_task where objectno=ba.serialno and phaseno in ('1000','8000') and objecttype='CreditApply') as ����ͨ��ʱ��,
getitemname('OccurType',ba.occurtype) as ��������
from business_Apply ba, flow_opinion fo,flow_object fo1 where fo1.ObjectNO=ba.Serialno and fo1.objecttype='CreditApply'  and  fo.ObjectNO=ba.Serialno and fo.objecttype='CreditApply'  
 and fo.serialno=(select max(Relativeserialno) from flow_task ft where ft.ObjectNo=ba.serialno and ft.Objecttype='CreditApply'); 


 
//������Ա��ɫ��
select ui.userid as �û����,ui.username as �û�����,getorgname(ui.BelongOrg) as ��������,
getItemName('DepartMent',ui.DepartMent) as ��������,getItemName('IsInUse',ui.Status) as ״̬,ri.rolename as ��ɫ����
 from user_info ui,user_role ur,role_info ri 
 where ui.userid=ur.userid and ur.roleid=ri.roleid
 order by ui.userid,ui.BelongOrg,ui.DepartMent desc;
 
//�������˽�ݲ�ѯ
 select BD.SerialNo as �����ˮ��,BD.RelativeSerialNo2 as ��ͬ��ˮ��,BD.CustomerID as �ͻ���� ,BD.CustomerName as �ͻ�����,getBusinessName(BD.BusinessType) as ҵ��Ʒ��,  getItemName('Currency',BD.BusinessCurrency) as ����,
BD.Balance as ���,BD.ActualBusinessRate as ִ��������(��),  BD.InterEstBalance1 as ����ǷϢ,BD.InterEstBalance2 as ����ǷϢ,BD.NormalBalance as �������,
BD.OverdueBalance as �������,BD.DullBalance as �������,BD.BadBalance as �������,  BD.PutOutDate as �����ʼ��,BD.Maturity as ��ݵ�����,getItemName('VouchType',BC.VouchType) as ��Ҫ������ʽ, 
getOrgName(BC.ManageOrgID) as �ܻ�����,getUserName(BC.ManageUserID) as �ܻ���,getOrgName(BD.MfOrgID) as ���˻���
from BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT  
where BT.TypeNo = BD.BusinessType and BT.Attribute1 = '2'  and BD.RelativeSerialNo2 = BC.SerialNo and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '100%')

//����̨�˱���δ����ҵ��
select SerialNo as ��ͬ��ˮ��,CustomerName as �ͻ�����,getBusinessName(BusinessType) as ҵ��Ʒ��, 
getItemName('OccurType',OccurType) as ��������, getItemName('Currency',BusinessCurrency) as ����, BusinessSum as ��ͬ���,
nvl(Balance,0) as ���,NormalBalance as �������,OverdueBalance as �������,DullBalance as �������,BadBalance as �������,
BailAccount,nvl(BailSum,0) as BailSum, case when (Balance-nvl(BailSum,0))<0 then 0 else (Balance-nvl(BailSum,0)) end as ClearSum, 
nvl(InterestBalance1,0) as ����ǷϢ���,nvl(InterestBalance2,0) as ����ǷϢ���, 
FineBalance1 as ���ڷ�Ϣ���,FineBalance2 as ��Ϣ���,BusinessRate as ����,PutOutDate as ��ʼ����,Maturity as ��������, 
getItemName('VouchType',VouchType) as ������ʽ, getItemName('ClassifyResult',ClassifyResult) as ���ڷ����϶����, 
 getUserName(ManageUserID) as �ͻ�����,getOrgName(OperateOrgID) as �������  
from BUSINESS_CONTRACT  
where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '100%')  and Balance >= 0 and BusinessType like '1%' 
and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null) order by CustomerName

//�����Ե��������ڱ����ͳ�Ʊ�
select GC.GuarantorName as �����Ե�����������,BC.customername as ��������ҵ����,(select getItemName('Scope',Scope) from ent_info where customerid=BC.customerid) as ��������ҵ����,
BC.balance as �������������,bc.putoutdate as �������,bc.maturity as �������,getItemName('ClassifyResult',bc.classifyresult) as �弶��ֽ��
 from GUARANTY_CONTRACT GC, CONTRACT_RELATIVE CR, BUSINESS_CONTRACT BC  
where CR.SerialNo = BC.SerialNo  
and CR.ObjectNo=GC.SerialNo
and CR.ObjectType='GuarantyContract' 
and GC.ContractStatus = '020' 
and GC.GuarantorName in (
'������Ż�ͨͶ�ʵ������޹�˾',
'�к��Ŵﵣ�����޹�˾',
'��򱱳��Ƽ�԰����С��ҵ���õ�������',
'���ݳ�Ͷ�ʵ������޹�˾',
'���̩��С��ҵ���õ�������',
'����д����С��ҵ�����������ι�˾',
'���̩Ͷ�ʵ����������ι�˾',
'������ϴ�ҵͶ�ʵ������޹�˾',
'���ӱ�����С��ҵ���õ�������',
'����ֶ��µ����ɷ����޹�˾',
'��ˮ�����Ͷ�ʵ������޹�˾',
'�������С��ó��ҵ���ʵ�������',
'�������С��ҵ���õ��������������',
'���Ӫ��Ͷ�ʵ������޹�˾',
'������ڵ������޹�˾',
'����о�������ũ�彨�赣����������',
'�������������ũ�彨�赣����������',
'��������������罨�����õ�������',
'�����Ͷ�ʵ������޹�˾',
'���������Ͷ�ʵ������޹�˾',
'����л���Ͷ�ʵ������޹�˾',
'�����������ŵ������޹�˾'
);

//����ס�����Ҵ���ͳ�Ʊ�2011-11
select * from 
(
select ba.Serialno as ������ˮ��,
getorgName(ba.InputOrgID) as �������,ba.customername as �ͻ�����,getBusinessName(ba.BusinessType) as ҵ��Ʒ��,fo.RateFloat as ���ʸ���ֵ,
fo.Businessrate as ��׼����,fo.businessSum/10000  as ������׼����Ԫ��, fo.Termmonth as ��׼����,
(select left(endtime,10) from flow_task where objectno=ba.serialno and phaseno ='1000' and objecttype='CreditApply') as ����ͨ��ʱ��,
(select left(endtime,10) from flow_task where objectno=ba.serialno and phaseno='0020' and objecttype='CreditApproveApply') as ����ʱ��,
getUserName(fo.InputUser) as ����������
from business_Apply ba, flow_opinion fo,flow_object fo1 

where fo1.ObjectNO=ba.Serialno and fo1.objecttype='CreditApply'  and  fo.ObjectNO=ba.Serialno and fo.objecttype='CreditApply'  
 and fo.serialno=(select max(Relativeserialno) from flow_task ft where ft.ObjectNo=ba.serialno and ft.Objecttype='CreditApply')
 and ba.businesstype in ('1110010','1110020','1110025','1110027')
)

where ����ͨ��ʱ��>='2011/11/01' and ����ͨ��ʱ��<='2011/11/30' order by �������
; 

//ȡ��ˢ�µĿͻ��б�
select 
   EI.CustomerID,EI.EnterpriseName,getItemName('CertType',CI.CertType) as CertTypeName,
   CI.CertID,getItemName('IndustryName',IndustryName) as IndustryName,EI.EmployeeNumber,
   EI.SellSum,EI.TotalAssets,getItemName('Scope',EI.scope) as Scope,
   getItemName('EntScale',EI.LockEntScale) as LockEntScale  
from ENT_INFO EI,CUSTOMER_INFO CI   
where CI.CustomerType like '01%'  and CI.CustomerType<>'0107'  and CI.CustomerID = EI.CustomerID and 
     (EI.lockentscale = '02' or EI.lockentscale is null or EI.lockentscale = '') and
     ci.customerid in (select customerid from business_contract union select guarantorid from guaranty_contract where ContractStatus = '020')

//�����������ص���Ϣϵͳ��������
select 
bc.serialno as ��ͬ��ˮ��,
getbusinessname(businesstype) as ҵ��Ʒ��,
bc.putoutdate as ��ͬ��ʼ��,
bc.maturity as ��ͬ������,
bc.businesssum as ��ͬ���,
bc.balance as �����,
bc.interestbalance1 as ����ǷϢ,
bc.interestbalance2 as ����ǷϢ,
getItemName('AdjustRateType',AdjustRateType) as ���ʵ�����ʽ,
getItemName('RateFloatType',RateFloatType) as ���ʸ�����ʽ ,
RateFloat as ���ʸ���ֵ,
bc.BusinessRate ִ������,
bc.customername as ��ҵ����,
gc.serialno as ������ͬ��ˮ��,
gc.GuarantorName as ����������,
getItemName('GuarantyType',GC.GuarantyType) as ��������,
gc.GuarantyValue as �����˽��
from business_contract bc,CONTRACT_RELATIVE CR,guaranty_contract gc
where bc.serialno=cr.serialno
and gc.serialno=cr.objectno
and CR.ObjectType='GuarantyContract' 
and (bc.businesstype like '10%' or bc.businesstype like '20%' or bc.businesstype='3010')
order by bc.serialno,businesstype

