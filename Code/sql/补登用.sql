--��EXCEL��ת��ΪDAT���ݣ��Ȱ������з����ָ�Ϊ�գ�ʱҪ��TABת��Ϊ|���ѿո�ת��Ϊ��,��#DIV/0!ת��Ϊ��
select colheader,colname,coleditsource from dataobject_library where dono='ContractInfo0040' and colvisible='1' order by colindex;

--����������Ҫ����BC.ManageUserID

--���º�ͬ�пͻ���
update business_contract set customerid = (select customerid from customer_info where mfcustomerid =business_contract.customerid fetch first row only) 
where reinforceflag='010' 
and serialno in  (select serialno  from customer_info,business_contract where mfcustomerid =business_contract.customerid ) ;

update business_contract set customerid = '' where reinforceflag='010' and customerid=mfcustomerid and customerid not like '2010%';

select customerid,(select customerid from customer_info where mfcustomerid =business_contract.customerid fetch first row only) 
from   business_contract where reinforceflag='010' 
and serialno in  (select serialno  from customer_info,business_contract where mfcustomerid =business_contract.customerid ) ;

--ɾ�����ú�ͬ
update business_contract set reinforceflag = '040'  where balance+interestbalance1+interestbalance2=0 and reinforceflag='010';

--���º�ͬ�鵵����
update business_contract set pigeonholedate = '2010/04/22' where reinforceflag is not null;

--��CI�пͻ���Ϣ������CUSTOMER_BELONG�� �Ѳ���
insert into customer_belong(customerid,orgid,userid,belongattribute) select customerid,'1','2','3' from customer_info where customerid='20091368'

--����applytype ���շ���ʹ��
update business_contract set applytype='IndependentApply' where applytype is null and reinforceflag is not null and ManageUserID='TJ8701';