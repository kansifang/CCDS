<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2011/06、15
		Tester:
		Content: 合并解除aciton
		Input Param:                                                           
			ContractNo:目标合同号
			ObjectNoArray:原合同组
			Flag:AddContract 借据增加,delete 借据删除
		Output param:                                                          
			        
		History Log: 
	 */
	%>
<%/*~END~*/%>




<html>
<head>
<title>补登完成校验 </title>
</head>


<%
	//定义变量
	ASResultSet rs = null;

	
	String sSql="";
	String sArtificialNo="";
	
	
	//目标合同流水号、被合并的合同流水号及数量
	String sContractNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ContractNo"));
	String sObjectNoArray =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNoArray"));
	String sFlag =    DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag"));
	
//---------------------------计算被合并合同的金额总和-----------------------------------------
	String sNewContractNo[]=sObjectNoArray.split(",");
	if("AddContract".equals(sFlag))//合并
	{
        for (int i=0;i<sNewContractNo.length;i++)
        {
        	
	       	//更新借据表，将原合同号更新为目标合同号
	       	sSql="UPDATE BUSINESS_DUEBILL SET RelativeSerialNo2='"+sContractNo+"' where RelativeSerialNo2='" + sNewContractNo[i] + "'";
      		Sqlca.executeSQL(sSql);
      		
      		//更新合同表，将被合并合同的合并标志置为已合并
      		sSql="UPDATE BUSINESS_CONTRACT SET ReinforceFlag='030', DeleteFlag='01' where SerialNo='" + sNewContractNo[i] + "'";
      		Sqlca.executeSQL(sSql);
        }
	}
	
	if("DeleteContract".equals(sFlag))//解除合并
	{
		 for (int i=0;i<sNewContractNo.length;i++)
	     {
	        	
		       	//更新借据表，将原合同号更新为目标合同号
		       	sSql="UPDATE BUSINESS_DUEBILL SET RelativeSerialNo2='"+sNewContractNo[i]+"' where Serialno='" + sNewContractNo[i] + "'";
	      		Sqlca.executeSQL(sSql);
	      		
	      		//更新合同表，将被合并合同的合并标志置为未合并
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