<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.8
		Tester:
		Content: �ò�����ɱ�־
		Input Param:
			                SerialNo:������ˮ��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>���ͻ���Ϣ</title>
<%
	String sSql;
	String sSql1;
	String sSerialNo="";	
	ASResultSet rs = null;
	int sCount=0;

	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	
	//���ǲ˵���־sFlag=Y��ʾ�Ӳ����ʲ����ǽ��룬�����ʾ���Ŵ����ǽ���
	String sFlag = DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag"));
	if(sFlag==null) sFlag="";
	
	//���Ǳ�־sReinforceFlag��ʾ�Ӳ�ͬ���б����
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)request.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";
	
	//�ٴβ��Ǳ�־
	String sSecondFlag = DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag1"));
	if(sSecondFlag==null) sSecondFlag="";	
	
	
	
	if(sFlag.equals("Y")) //�����ʲ����벹��
	{
		if(sSecondFlag.equals("")) //�������
		 {
			if(sReinforceFlag.equals("010")) //��������ҵ��
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '020',RecoveryOrgID='"+CurOrg.OrgID+"' where SerialNo = '"+sSerialNo+"'";
			}else
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '120',RecoveryOrgID='"+CurOrg.OrgID+"' where SerialNo = '"+sSerialNo+"'";

			}

			Sqlca.executeSQL(sSql);
		
%>			
			<script language=javascript>
				self.returnValue = "succeed";
				self.close();
			</script>
<%
		 }
		 else	//�ٴβ���
		 {
		 	
		 	sSql1 = " select count(*) from business_contract where SerialNo = '"+sSerialNo+"' and (RecoveryUserID is not null)";
		 	rs = Sqlca.getASResultSet(sSql1); 
   			if(rs.next())
   			sCount = rs.getInt(1);
			rs.getStatement().close();
		 	
		 	if(sCount<=0)
		 	{
			 	
			 	if(sReinforceFlag.equals("020")) //�������ҵ��
				{
					sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '010',RecoveryOrgID=null where SerialNo = '"+sSerialNo+"'";
				}else
				{
					sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '110',RecoveryOrgID=null where SerialNo = '"+sSerialNo+"'";
	
				}
				
				Sqlca.executeSQL(sSql);
%>			
				<script language=javascript>
					self.returnValue = "true";
					self.close();
				</script>
<%				
			}else
			{
%>			
				<script language=javascript>
					self.returnValue = "false";
					self.close();
				</script>
<%		
			}
		 }
	}else
	{
		if(sSecondFlag.equals("")) //�������
		{
			
			if(sReinforceFlag.equals("010")) //�貹��ҵ��
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '020' where SerialNo = '"+sSerialNo+"'";
			}else   //����ҵ��
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '120' where SerialNo = '"+sSerialNo+"'";

			}
			
			Sqlca.executeSQL(sSql);
			
%>			
			<script language=javascript>
				self.returnValue = "succeed";
				self.close();
			</script>
<%
		}else	//�ٴβ���
		{
			
			if(sReinforceFlag.equals("020")) //����ҵ��
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '010' where SerialNo = '"+sSerialNo+"'";
			}else	//����ҵ��
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '110' where SerialNo = '"+sSerialNo+"'";

			}
			Sqlca.executeSQL(sSql);
%>			
			<script language=javascript>
				self.returnValue = "true";
				self.close();
			</script>
<%
		}
	}		
%>

<%@ include file="/IncludeEnd.jsp"%>