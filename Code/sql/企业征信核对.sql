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

//������ҵ��
select 
getorgname(bc.manageorgid) as ҵ��������,
ei.EnterpriseName as ���������,
ei.loancardno as �������,
bc.serialno as �����ͬ���,
bd.serialno as ��ݱ��,
getitemname('Currency',bc.businesscurrency) as ����,
bc.businesssum as ��ͬ���,
bd.balance as ������,
bd.putoutdate as ���ſ�����,
bd.actualmaturity as �ſ������,
(select case when count(*)>0 then '��' else '��' end from business_extension where business_extension.relativeserialno=bd.serialno) as չ�ڱ�־,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '��' else '��'  end as ������־
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

//ó��������ҵ��  ��ͬ�����ս����ڵĲ��ϱ�
select 
getorgname(bc.manageorgid) as ҵ��������,
ei.EnterpriseName as ���������,
ei.loancardno as �������,
bc.serialno as ����Э����,
bd.serialno as ����ҵ����,
getitemname('Currency',bc.businesscurrency) as ����,
bc.businesssum as ����Э����,
bd.balance as �������,
bd.putoutdate as ����ҵ��������,
bd.actualmaturity as ����ҵ���������,
(select case when count(*)>0 then '��' else '��' end from business_extension where business_extension.relativeserialno=bd.serialno) as չ�ڱ�־,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '��' else '��'  end as ������־
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

//������ҵ��  ��ͬ�����ս����ڵĲ��ϱ�
select 
getorgname(bc.manageorgid) as ҵ��������,
ei.EnterpriseName as ���������,
ei.loancardno as �������,
bd.serialno as ҵ����,
getitemname('Currency',bc.businesscurrency) as ����,
bd.businesssum as �������,
bd.balance as �������,
bd.putoutdate as ������������,
(case when BD.ACTUALMATURITY is null or BD.ACTUALMATURITY = ''  then BD.Maturity else  BD.ACTUALMATURITY end)  as ����������,
//(select case when count(*)>0 then '��' else '��' end from business_extension where business_extension.relativeserialno=bd.serialno) as չ�ڱ�־,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '��' else '��'  end as ������־
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

//�жһ�Ʊ
select 
getorgname(bc.manageorgid) as ҵ��������,
ei.EnterpriseName as ��Ʊ������,
ei.loancardno as �������,
bd.serialno as ҵ����,
getitemname('Currency',bc.businesscurrency) as ����,
bd.businesssum as ��Ʊ���,
bd.putoutdate as ��Ʊ�ж���,
(case when BD.ACTUALMATURITY is null or BD.ACTUALMATURITY = ''  then BD.Maturity else  BD.ACTUALMATURITY end) as ��Ʊ������,
//(select case when count(*)>0 then '��' else '��' end from business_extension where business_extension.relativeserialno=bd.serialno) as չ�ڱ�־,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '��' else '��'  end as ������־
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

//����֤
select 
getorgname(bc.manageorgid) as ҵ��������,
ei.EnterpriseName as ���������,
ei.loancardno as �������,
bd.serialno as ҵ����,
getitemname('Currency',bc.businesscurrency) as ��֤����,
bd.BusinessSum as ��֤���,
bd.balance as ����֤���,
bd.putoutdate as ��֤����,
(case when BD.ACTUALMATURITY is null or BD.ACTUALMATURITY = ''  then BD.Maturity else  BD.ACTUALMATURITY end)  as ����֤��Ч��,
//(select case when count(*)>0 then '��' else '��' end from business_extension where business_extension.relativeserialno=bd.serialno) as չ�ڱ�־,
case when bc.vouchtype<>'005' and bc.vouchtype<>'' and bc.vouchtype is not  null then '��' else '��'  end as ������־
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

//ǷϢ
select
'���ũ����������' as ҵ��������,
ei.EnterpriseName as ǷϢ��ҵ����,
ei.loancardno as �������,
 '����' as ǷϢ����,
getitemname('Currency',bd.BusinessCurrency) as  ����,
sum(BD.InterestBalance3) as  ǷϢ���
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
'���ũ����������' as ҵ��������,
ei.EnterpriseName as ǷϢ��ҵ����,
ei.loancardno as �������,
 '����' as ǷϢ����,
getitemname('Currency',bd.BusinessCurrency) as  ����,
sum(BD.InterestBalance2) as  ǷϢ���
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
 
//��������  �����ڴ��ں˶�����
select
getorgname(bc.manageorgid) as ҵ��������,
ei.EnterpriseName as ���������,
ei.loancardno as �������,
bc.serialno as ����Э�����,
getitemname('Currency',bc.businesscurrency) as ����,
bc.businesssum as ���Ŷ��,
bc.putoutdate as ������Ч����,
bc.maturity as ������ֹ����
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

//���ڱ�֤����
select
getorgname(bc.manageorgid) as ҵ��������,
ltrim(rtrim(GC.GuarantorName)) as ��֤������,
coalesce(getloancardno(GC.guarantorid),'') as ��֤�˴������,
bc.customername as ��������ҵ����,
coalesce(getloancardno(bc.customerid),'') as ��������ҵ�������,
bc.serialno as ����ͬ���,
GC.SerialNo as ��֤��ͬ���,
getitemname('Currency',GC.GuarantyCurrency) as ����,
gc.GUARANTYVALUE as ��֤���
from GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC,ENT_INFO EI,BUSINESS_TYPE BT
where BC.SerialNo = CR.SerialNo
and CR.ObjectNo = GC.SerialNo
and EI.CustomerID = BC.CustomerID
and BT.TypeNO = BC.BusinessType
and CR.ObjectType = 'GuarantyContract'
and GC.GuarantyType like '010%' //������ʽ��010010=��֤,010040=��֤��}
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

//���Ᵽ֤����
select
getorgname(bc.manageorgid) as ҵ��������,
ltrim(rtrim(GC.GuarantorName)) as ��֤������,
coalesce(getloancardno(GC.guarantorid),'') as ��֤�˴������,
bc.customername as ��������ҵ����,
coalesce(getloancardno(bc.customerid),'') as ��������ҵ�������,
bd.serialno as ����ͬ���,
GC.SerialNo as ��֤��ͬ���,
getitemname('Currency',GC.GuarantyCurrency) as ����,
gc.GUARANTYVALUE as ��֤���
from GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC,BUSINESS_DUEBILL BD,ENT_INFO EI,BUSINESS_TYPE BT
where BC.SerialNo = CR.SerialNo
and CR.ObjectNo = GC.SerialNo
and bd.relativeserialno2=bc.serialno
and EI.CustomerID = BC.CustomerID
and BT.TypeNO = BC.BusinessType
and CR.ObjectType = 'GuarantyContract'
and GC.GuarantyType like '010%' //������ʽ��010010=��֤,010040=��֤��}
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

//���ڵ�Ѻ����
select
getorgname(bc.manageorgid) as ҵ��������,
ltrim(rtrim(GC.GuarantorName)) as ��Ѻ������,
coalesce(getloancardno(GC.guarantorid),'') as ��Ѻ�˴������,
bc.customername as ��������ҵ����,
coalesce(getloancardno(bc.customerid),'') as ��������ҵ�������,
BC.SerialNo as ����ͬ���,
GC.SerialNo as ��Ѻ��ͬ���,
getitemname('Currency',GC.GuarantyCurrency) as ����,
gi.AboutSum2 as ��Ѻ���
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

//�����Ѻ����
select
getorgname(bc.manageorgid) as ҵ��������,
ltrim(rtrim(GC.GuarantorName)) as ��Ѻ������,
coalesce(getloancardno(GC.guarantorid),'') as ��Ѻ�˴������,
bc.customername as ��������ҵ����,
coalesce(getloancardno(bc.customerid),'') as ��������ҵ�������,
Bd.SerialNo as ����ͬ���,
GC.SerialNo as ��Ѻ��ͬ���,
getitemname('Currency',GC.GuarantyCurrency) as ����,
gi.AboutSum2 as ��Ѻ���
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

//������Ѻ����
select
getorgname(bc.manageorgid) as ҵ��������,
ltrim(rtrim(GC.GuarantorName)) as ����������,
coalesce(getloancardno(GC.guarantorid),'') as �����˴������,
bc.customername as ��������ҵ����,
coalesce(getloancardno(bc.customerid),'') as ��������ҵ�������,
BC.SerialNo as ����ͬ���,
GC.SerialNo as ��Ѻ��ͬ���,
getitemname('Currency',GC.GuarantyCurrency) as ����,
gi.confirmvalue as  ��Ѻ���
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

//������Ѻ����
select
getorgname(bc.manageorgid) as ҵ��������,
ltrim(rtrim(GC.GuarantorName)) as ����������,
coalesce(getloancardno(GC.guarantorid),'') as �����˴������,
bc.customername as ��������ҵ����,
coalesce(getloancardno(bc.customerid),'') as ��������ҵ�������,
Bd.SerialNo as ����ͬ���,
GC.SerialNo as ��Ѻ��ͬ���,
getitemname('Currency',GC.GuarantyCurrency) as ����,
gi.confirmvalue as  ��Ѻ���
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


//������Ϣ
select 
getorgname(bc.manageorgid) as ҵ��������,
bc.serialno as ��ͬ����,
bd.serialno as ��ݱ���,
ei.loancardno as �������,
case when BW.BusinessDesc = '6100' then '�������' else '�����ջ�' end as ���ʽ,
BW.OccurDate as ��������,
sum(BW.ActualCreditSum) as ������
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