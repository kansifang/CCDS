<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: slliu  2005-02-23 
		Tester:
		Content: �������У��
		Input Param:                                                           
    			   
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
	double sBusinessSum=0.00;
	double sClassifySum1=0.00;
	double sClassifySum2=0.00;
	double sClassifySum3=0.00;
	double sClassifySum4=0.00;
	double sClassifySum5=0.00;
	
	double sPutOutSum=0.00;
	double sActualPutOutSum=0.00;
	double sBalance=0.00;
	double sNormalBalance=0.00;
	double sOverdueBalance=0.00;
	double sDullBalance=0.00;
	double sBadBalance=0.00;
	double sInterestBalance1=0.00;
	double sInterestBalance2=0.00;
	
	double sShiftBalance=0.00;
	double sFineBalance1=0.00;
	double sFineBalance2=0.00;
	double sTABalance=0.00;
	double sTAInterestBalance=0.00;
	
	String sSql="";
	String sArtificialNo="";
	
	
	//Ŀ���ͬ��ˮ�š����ϲ��ĺ�ͬ��ˮ�ż�����
	String sContractNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ContractNo"));
	String sObjectNoArray =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNoArray"));
	
//---------------------------���㱻�ϲ���ͬ�Ľ���ܺ�-----------------------------------------
	String sNewContractNo[]=sObjectNoArray.split(",");
	
        for (int i=0;i<sNewContractNo.length;i++)
        {
        	
        	sSql = " select BusinessSum,ClassifySum1,ClassifySum2,ClassifySum3,ClassifySum4,ClassifySum5,"+
        		" PutOutSum,ActualPutOutSum,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
        		" InterestBalance1,InterestBalance2,ShiftBalance,FineBalance1,FineBalance2,TABalance,TAInterestBalance "+
        		
	               " from BUSINESS_CONTRACT where SerialNo='"+sNewContractNo[i]+"' ";
	     
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sBusinessSum = sBusinessSum + rs.getDouble("BusinessSum");
			sClassifySum1 = sClassifySum1 + rs.getDouble("ClassifySum1");
			sClassifySum2 = sClassifySum2 + rs.getDouble("ClassifySum2");
			sClassifySum3 = sClassifySum3 + rs.getDouble("ClassifySum3");
			sClassifySum4 = sClassifySum4 + rs.getDouble("ClassifySum4");
			sClassifySum5 = sClassifySum5 + rs.getDouble("ClassifySum5");
			
			sPutOutSum = sPutOutSum + rs.getDouble("PutOutSum");
			sActualPutOutSum = sActualPutOutSum + rs.getDouble("ActualPutOutSum");
			sBalance = sBalance + rs.getDouble("Balance");
			sNormalBalance = sNormalBalance + rs.getDouble("NormalBalance");
			sOverdueBalance = sOverdueBalance + rs.getDouble("OverdueBalance");
			sDullBalance = sDullBalance + rs.getDouble("DullBalance");
			sBadBalance = sBadBalance + rs.getDouble("BadBalance");
			sInterestBalance1 = sInterestBalance1 + rs.getDouble("InterestBalance1");
			sInterestBalance2 = sInterestBalance2 + rs.getDouble("InterestBalance2");
			
			sShiftBalance = sShiftBalance + rs.getDouble("ShiftBalance");
			sFineBalance1 = sFineBalance1 + rs.getDouble("FineBalance1");
			sFineBalance2 = sFineBalance2 + rs.getDouble("FineBalance2");
			sTABalance = sTABalance + rs.getDouble("TABalance");
			sTAInterestBalance = sTAInterestBalance + rs.getDouble("TAInterestBalance");
			
	       	}
	       	rs.getStatement().close();
	       	
		
		//���Ŀ���ͬ��ˮ�Ŷ�Ӧ���ֹ����      	
	       	sSql = " select ArtificialNo "+
        	         " from BUSINESS_CONTRACT where SerialNo='"+sContractNo+"' ";
	     
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sArtificialNo = rs.getString("ArtificialNo");
	     	}
	       	rs.getStatement().close();
	       	
	       	//���½�ݱ���ԭ��ͬ�Ÿ���ΪĿ���ͬ��
	       	sSql="UPDATE BUSINESS_DUEBILL SET RelativeSerialNo2='"+sContractNo+"' where RelativeSerialNo2='" + sNewContractNo[i] + "'";
      		Sqlca.executeSQL(sSql);
      		
      		//���º�ͬ�������ϲ���ͬ�ĺϲ���־��Ϊ�Ѻϲ�
      		sSql="UPDATE BUSINESS_CONTRACT SET ReinforceFlag='030', DeleteFlag='01',RelativeSerialNo='"+sArtificialNo+"' where SerialNo='" + sNewContractNo[i] + "'";
      		Sqlca.executeSQL(sSql);
        }
        
        java.text.DecimalFormat df = new java.text.DecimalFormat("#.00");

	//���º�ͬ�������ϲ���ͬ�Ľ���ܺͼӵ�Ŀ���ͬ��
	sSql="UPDATE BUSINESS_CONTRACT SET BusinessSum = BusinessSum+" +df.format(sBusinessSum)+ ","+
		" ClassifySum1 = ClassifySum1+" +df.format(sClassifySum1)+ ","+
		" ClassifySum2 = ClassifySum2+" +df.format(sClassifySum2)+ ","+
		" ClassifySum3 = ClassifySum3+" +df.format(sClassifySum3)+ ","+
		" ClassifySum4 = ClassifySum4+" +df.format(sClassifySum4)+ ","+
		" ClassifySum5 = ClassifySum5+" +df.format(sClassifySum5)+ ","+
		
		" PutOutSum = PutOutSum+" +df.format(sPutOutSum)+ ","+
		" ActualPutOutSum = ActualPutOutSum+" +df.format(sActualPutOutSum)+ ","+
		" Balance = Balance+" +df.format(sBalance)+ ","+
		" NormalBalance = NormalBalance+" +df.format(sNormalBalance)+ ","+
		" OverdueBalance = OverdueBalance+" +df.format(sOverdueBalance)+ ","+
		" DullBalance =" +df.format(sDullBalance)+ ","+
		" BadBalance = DullBalance+" +df.format(sBadBalance)+ ","+
		" InterestBalance1 = InterestBalance1+" +df.format(sInterestBalance1)+ ","+
		" InterestBalance2 = InterestBalance2+" +df.format(sInterestBalance2)+ ","+
		
		" ShiftBalance = ShiftBalance+" +df.format(sShiftBalance)+ ","+
		" FineBalance1 = FineBalance1+" +df.format(sFineBalance1)+ ","+
		" FineBalance2 = FineBalance2+" +df.format(sFineBalance2)+ ","+
		" TABalance = TABalance+" +df.format(sTABalance)+ ","+
		" TAInterestBalance = TAInterestBalance+" +df.format(sTAInterestBalance)+ " "+
		
		" where SerialNo='" + sContractNo + "'";
	
	Sqlca.executeSQL(sSql);
%>



</html>

<script language=javascript>
	self.returnValue="true";
    	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>