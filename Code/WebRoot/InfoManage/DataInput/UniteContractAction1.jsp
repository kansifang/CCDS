<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2011/06��15
		Tester:
		Content: �ϲ����aciton
		Input Param:                                                           
			ContractNo:Ŀ���ͬ��
			ObjectNoArray:ԭ��ͬ��
			Flag:AddContract �������,delete ���ɾ��
		Output param:                                                          
			        
		History Log: 
	 */
	%>
<%/*~END~*/%>




<html>
<head>
<title>�������У�� </title>
</head>


<%
	//�������
	ASResultSet rs = null;

	
	String sSql="";
	String sArtificialNo="";
	
	
	//Ŀ���ͬ��ˮ�š����ϲ��ĺ�ͬ��ˮ�ż�����
	String sContractNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ContractNo"));
	String sObjectNoArray =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNoArray"));
	String sFlag =    DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag"));
	
//---------------------------���㱻�ϲ���ͬ�Ľ���ܺ�-----------------------------------------
	String sNewContractNo[]=sObjectNoArray.split(",");
	if("AddContract".equals(sFlag))//�ϲ�
	{
        for (int i=0;i<sNewContractNo.length;i++)
        {
        	
	       	//���½�ݱ���ԭ��ͬ�Ÿ���ΪĿ���ͬ��
	       	sSql="UPDATE BUSINESS_DUEBILL SET RelativeSerialNo2='"+sContractNo+"' where RelativeSerialNo2='" + sNewContractNo[i] + "'";
      		Sqlca.executeSQL(sSql);
      		
      		//���º�ͬ�������ϲ���ͬ�ĺϲ���־��Ϊ�Ѻϲ�
      		sSql="UPDATE BUSINESS_CONTRACT SET ReinforceFlag='030', DeleteFlag='01' where SerialNo='" + sNewContractNo[i] + "'";
      		Sqlca.executeSQL(sSql);
        }
	}
	
	if("DeleteContract".equals(sFlag))//����ϲ�
	{
		 for (int i=0;i<sNewContractNo.length;i++)
	     {
	        	
		       	//���½�ݱ���ԭ��ͬ�Ÿ���ΪĿ���ͬ��
		       	sSql="UPDATE BUSINESS_DUEBILL SET RelativeSerialNo2='"+sNewContractNo[i]+"' where Serialno='" + sNewContractNo[i] + "'";
	      		Sqlca.executeSQL(sSql);
	      		
	      		//���º�ͬ�������ϲ���ͬ�ĺϲ���־��Ϊδ�ϲ�
	      		sSql="UPDATE BUSINESS_CONTRACT SET ReinforceFlag='010',DeleteFlag=null  where SerialNo='" + sNewContractNo[i] + "'";
	      		Sqlca.executeSQL(sSql);
	      }
	}
        

%>



</html>

<script language=javascript>
	self.returnValue="true";
    	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>