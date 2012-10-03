  delete  from org_belong ;
  insert into Org_Belong (OrgID,BelongOrgID) select OrgID,OrgID from Org_Info ;
  insert into Org_Belong (OrgID,BelongOrgID) select RelativeOrgID,OrgID from Org_Info  where RelativeOrgID<>OrgID and RelativeOrgID <> '9900'; 
  insert into Org_Belong (OrgID,BelongOrgID) select (select RelativeOrgID from org_info where orgid= ooo.relativeOrgid ) ,OrgID from Org_Info ooo  where RelativeOrgID<>OrgID; 
