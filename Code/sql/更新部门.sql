�����з��չ�������Ϊ���������Ź���:

update role_info set rolename = replace(rolename,'����','����') where rolename like '%����%���չ���%';
select * from role_info where rolename like '%����%���չ���%';

update flow_model set phasename = replace(phasename,'����','����') where phasename like '%����%���չ���%';
select * from flow_model where phasename like '%����%���չ���%';

update flow_object set phasename = replace(phasename,'����','����') where phasename like '%����%���չ���%';
select * from flow_object where phasename like '%����%���չ���%';

update flow_task set phasename = replace(phasename,'����','����') where phasename like '%����%���չ���%';
select *  from flow_task where phasename like '%����%���չ���%';


������������鲿����Ϊ������������������:

update role_info set rolename = replace(rolename,'��','��') where rolename like '%����%������鲿%';
select * from role_info where rolename like '%����%������鲿%';

update flow_model set phasename = replace(phasename,'��','��') where phasename like '%����%������鲿%';
select * from flow_model where phasename like '%����%������鲿%';

update flow_task set phasename = replace(phasename,'��','��')   where phasename like '%����%������鲿%';
select * from flow_task where phasename like '%����%������鲿%';

update flow_object set phasename = replace(phasename,'��','��')   where phasename like '%����%������鲿%';
select * from flow_object where phasename like '%����%������鲿%';