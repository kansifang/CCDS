--从EXCEL中转换为DAT数据：先把数据中非数字改为空，时要把TAB转化为|，把空格转化为空,把#DIV/0!转化为空
select colheader,colname,coleditsource from dataobject_library where dono='ContractInfo0040' and colvisible='1' order by colindex;

--批量结束后要更新BC.ManageUserID

--更新合同中客户号
update business_contract set customerid = (select customerid from customer_info where mfcustomerid =business_contract.customerid fetch first row only) 
where reinforceflag='010' 
and serialno in  (select serialno  from customer_info,business_contract where mfcustomerid =business_contract.customerid ) ;

update business_contract set customerid = '' where reinforceflag='010' and customerid=mfcustomerid and customerid not like '2010%';

select customerid,(select customerid from customer_info where mfcustomerid =business_contract.customerid fetch first row only) 
from   business_contract where reinforceflag='010' 
and serialno in  (select serialno  from customer_info,business_contract where mfcustomerid =business_contract.customerid ) ;

--删除无用合同
update business_contract set reinforceflag = '040'  where balance+interestbalance1+interestbalance2=0 and reinforceflag='010';

--更新合同归档日期
update business_contract set pigeonholedate = '2010/04/22' where reinforceflag is not null;

--将CI中客户信息更新至CUSTOMER_BELONG中 已不用
insert into customer_belong(customerid,orgid,userid,belongattribute) select customerid,'1','2','3' from customer_info where customerid='20091368'

--更新applytype 风险分类使用
update business_contract set applytype='IndependentApply' where applytype is null and reinforceflag is not null and ManageUserID='TJ8701';