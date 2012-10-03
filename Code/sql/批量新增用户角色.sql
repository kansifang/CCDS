insert into user_role(UserID,roleid,status,grantor,begintime) 
select distinct userid,'0G3','1','system','2010/06/25' from User_role  where roleid!='0G3' and userid in(select userid from user_role where roleid in('410') and status='1')
