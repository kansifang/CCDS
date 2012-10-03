“总行风险管理部”改为“总行授信管理部:

update role_info set rolename = replace(rolename,'风险','授信') where rolename like '%总行%风险管理部%';
select * from role_info where rolename like '%总行%风险管理部%';

update flow_model set phasename = replace(phasename,'风险','授信') where phasename like '%总行%风险管理部%';
select * from flow_model where phasename like '%总行%风险管理部%';

update flow_object set phasename = replace(phasename,'风险','授信') where phasename like '%总行%风险管理部%';
select * from flow_object where phasename like '%总行%风险管理部%';

update flow_task set phasename = replace(phasename,'风险','授信') where phasename like '%总行%风险管理部%';
select *  from flow_task where phasename like '%总行%风险管理部%';


“总行授信审查部”改为“总行授信审批部”:

update role_info set rolename = replace(rolename,'查','批') where rolename like '%总行%授信审查部%';
select * from role_info where rolename like '%总行%授信审查部%';

update flow_model set phasename = replace(phasename,'查','批') where phasename like '%总行%授信审查部%';
select * from flow_model where phasename like '%总行%授信审查部%';

update flow_task set phasename = replace(phasename,'查','批')   where phasename like '%总行%授信审查部%';
select * from flow_task where phasename like '%总行%授信审查部%';

update flow_object set phasename = replace(phasename,'查','批')   where phasename like '%总行%授信审查部%';
select * from flow_object where phasename like '%总行%授信审查部%';