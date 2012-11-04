<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --�ͻ���Ϣ���
		Input Param:
			  CustomerType���ͻ�����
			  	��˾�ͻ���	
					0101��������ҵ��
					0102���Ƿ�����ҵ��
					0103�����幤�̻�����ϵͳ�ݲ��ã���
					0104����ҵ��λ��
					0105��������壻
					0106���������أ�
					0107�����ڻ�����
					0199��������
				�������ţ�
					0201��һ�༯�ţ�
					0202�����༯�ţ���ϵͳ�ݲ��ã���
				���˿ͻ���
					03�����˿ͻ�			  			                				
			  CustomerName���ͻ�����
			  CertType��֤������
			  CertID��֤������
			  ReturnStatus������״̬
			  CustomerID���ͻ���
		Output param:
		History Log: zywei 2005/09/10 �ؼ����
					 zywei 2005/12/27 ���Ӽ��ſͻ�������
					 zywei 2007/04/18 �����ݴ��־��ʼ��
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���ϢУ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>

<html>
<head>
<title>���ͻ���Ϣ</title>
<%  
    //���������sql���
	String sSql = "",sGroupType = "";
	
	//����������
	
    //���ҳ��������ͻ����͡��ͻ����ơ�֤�����͡�֤����š�����״̬���ͻ����
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));	
	String sCertType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));	
	String sReturnStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReturnStatus"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));	
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerScale"));	
   	//����ֵת��Ϊ���ַ���
   	if(sCustomerType == null) sCustomerType = "";   
   	if(sCustomerName == null) sCustomerName = "";
   	if(sCertType == null) sCertType = "";
   	if(sReturnStatus == null) sReturnStatus = "";
   	if(sCustomerID == null) sCustomerID = "";
   	if(sCustomerScale == null) sCustomerScale = "";
   	
   	//���ݿͻ��������ü��ſͻ�����
   	if(sCustomerType.equals("0201")) //һ�༯�ſͻ�
		sGroupType = "1";//һ�༯��
	else if(sCustomerType.equals("0202")) //���༯�ſͻ�
		sGroupType = "2";//���༯��
	else
		sGroupType = "0";//��һ�ͻ�
	//01Ϊ�޸ÿͻ� 
	if(sReturnStatus.equals("01"))
	{
	   //��ʼ����
 	   boolean bOld = Sqlca.conn.getAutoCommit(); 
	   try 
	   {		
			if(!bOld) Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(false);
					
			//��CI�����½���¼	
			if(sCustomerType.substring(0,2).equals("02")) //�������ſͻ�
			{
				//�ͻ���š��ͻ����ơ��ͻ����͡�֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ����ڡ���Դ����
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel) "+
					   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"',null,null,'"+CurOrg.OrgID+"', "+
					   " '"+CurUser.UserID+"','"+StringFunction.getToday()+"','1')";
				Sqlca.executeSQL(sSql);
			}else
			{
				//�ͻ���š��ͻ����ơ��ͻ����͡�֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ�����	����Դ����
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,CustomerScale) "+
					   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"','"+sCertType+"','"+sCertID+"','"+CurOrg.OrgID+"', "+
					   " '"+CurUser.UserID+"','"+StringFunction.getToday()+"','1','"+sCustomerScale+"')";
				Sqlca.executeSQL(sSql);
			}
				
			//��CB�����½���Ч��¼
			//�ͻ���š���Ȩ��������Ȩ�ˡ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ
			sSql = 	" insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3, "+
					" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				   	" values('"+sCustomerID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','1','1','1','1','1','"+CurOrg.OrgID+"', "+
				   	" '"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
				
			if(sCustomerType.substring(0,2).equals("01"))//��˾�ͻ�
			{
				String sOrgNature="";
				//if(sCustomerType!=null&&sCustomerType.length()>=2)sOrgNature=sCustomerType.substring(2);
				sOrgNature=sCustomerType;
				//֤������Ϊ��֯��������
				if(sCertType.equals("Ent01"))
				{
					//�ͻ���š���֯��������֤��š��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ��ݴ��־
					sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,TempSaveFlag) "+
						   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','"+sOrgNature+"','"+sGroupType+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"', "+
						   " '"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','1')";
					Sqlca.executeSQL(sSql);
				//֤������ΪӪҵִ��
				}else if(sCertType.equals("Ent02"))
				{
					//�ͻ���š�Ӫҵִ�պš��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ��ݴ��־
					sSql = " insert into ENT_INFO(CustomerID,LicenseNo,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,TempSaveFlag) "+
						   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','"+sOrgNature+"','"+sGroupType+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"', "+
						   " '"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','1')";
					Sqlca.executeSQL(sSql);
				
				}else
				{
					//�ͻ���š��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ��ݴ��־
					sSql = " insert into ENT_INFO(CustomerID,EnterpriseName,CorpID,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,TempSaveFlag) "+
						   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCertID+"','"+sOrgNature+"','"+sGroupType+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"', "+
						   " '"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','1')";
					Sqlca.executeSQL(sSql);
				}	
			}else if(sCustomerType.substring(0,2).equals("02")) //�������ſͻ�
			{				
				//�ͻ���š���֯�������루ϵͳ�Զ����⣬ͬ���ſͻ���ţ����ͻ����ơ��������ʡ��Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ����ſͻ����ࡢ�ݴ��־
				sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,GroupFlag,TempSaveFlag) "+
					   " values('"+sCustomerID+"','"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"', "+
					   " '"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+sGroupType+"','1')";
				Sqlca.executeSQL(sSql);		
			}else if(sCustomerType.substring(0,2).equals("03"))//���˿ͻ�
			{
				//�ͻ���š�������֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ����ڡ��������ڡ��ݴ��־
				sSql = " insert into IND_INFO(CustomerID,FullName,CertType,CertID,InputOrgID,InputUserID,InputDate,UpdateDate,TempSaveFlag) "+      //change by hldu 
					   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCertType+"','"+sCertID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"', "+
					   " '"+StringFunction.getToday()+"','"+StringFunction.getToday()+"','1')";														//change by hldu 
				Sqlca.executeSQL(sSql);
			}else if(sCustomerType.equals("0401")||sCustomerType.equals("0501"))//ũ������С��,���ù�ͬ��
			{
				//�ͻ���š���֯�������루ϵͳ�Զ����⣬ͬ���ſͻ���ţ����ͻ����ơ��������ʡ��Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ����ſͻ����ࡢ�ݴ��־
				sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,TempSaveFlag) "+
					   " values('"+sCustomerID+"','"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"', "+
					   " '"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','1')";
				Sqlca.executeSQL(sSql);	
			}
			
			//�����ύ�ɹ�
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bOld);
		} catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("������ʧ�ܣ�"+e.getMessage());
		}			
	//�ÿͻ�û�����κ��û�������Ч����
	}else if(sReturnStatus.equals("04"))
	{
		//����Դ������"2"���"1"
		sSql = 	" update CUSTOMER_INFO set Channel = '1' "+
				" where CustomerID = '"+sCustomerID+"' ";
		Sqlca.executeSQL(sSql);
		//������Ч����
		//�ͻ���š���Ȩ��������Ȩ�ˡ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ������Ȩ�ޣ�Ԥ�������Ǽǻ������Ǽ��ˡ��Ǽ����ڡ���������
		sSql = " insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
			   " values('"+sCustomerID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','1','1','1','1','1','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
		Sqlca.executeSQL(sSql);
	//�ÿͻ��������û�������Ч����
	}else if(sReturnStatus.equals("05"))
	{
		//������Ч����
		sSql = " insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
			   " values('"+sCustomerID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','2','1','2','2','2','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
		Sqlca.executeSQL(sSql);
	}
		
   
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "succeed";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>