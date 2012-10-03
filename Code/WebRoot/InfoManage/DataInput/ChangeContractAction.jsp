<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: slliu  2005-02-23 
		Tester:
		Content: 变更借据关联合同
		Input Param:                                                           
    			   
		Output param:                                                          
			        
		History Log: 
	 */
	%>
<%/*~END~*/%>




<html>
<head>
<title>变更借据关联合同 </title>
</head>


<%
	//定义变量
	ASResultSet rs = null;
	double sBusinessSum=0.00;		
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
	
	
	//原合同流水号、新合同流水号及借据号
	String sOldContractNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("OldContractNo"));
	String sContractNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ContractNo"));
	String sDueBillNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("DueBillNo"));

	//---------------------------获得借据的金额及相关余额-----------------------------------------
    //更新借据表，将原合同号更新为目标合同号
   	sSql="UPDATE BUSINESS_DUEBILL SET RelativeSerialNo2='"+sContractNo+"' where RelativeSerialNo2='" + sOldContractNo + "' and SerialNo='"+sDueBillNo+"' ";
	Sqlca.executeSQL(sSql);
	
	//根据合同下的借据重新计算原合同的相关金额
	sSql = 	" select sum(BusinessSum) as BusinessSum,sum(Balance) as Balance,sum(NormalBalance) as NormalBalance,"+
			" sum(OverdueBalance) as OverdueBalance,sum(DullBalance) as DullBalance,sum(BadBalance) as BadBalance,"+
			" sum(InterestBalance1) as InterestBalance1,sum(InterestBalance2) as InterestBalance2,"+
			" sum(FineBalance1) as FineBalance1,sum(FineBalance2) as FineBalance2,sum(TABalance) as TABalance, "+
			" sum(TAInterestBalance) as TAInterestBalance"+
			" from BUSINESS_DUEBILL where RelativeSerialNo2='"+sOldContractNo+"' ";
	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		
		sBusinessSum =rs.getDouble("BusinessSum");
		sBalance = rs.getDouble("Balance");		
		sNormalBalance = rs.getDouble("NormalBalance");
		sOverdueBalance =  rs.getDouble("OverdueBalance");
		sDullBalance =  rs.getDouble("DullBalance");
		sBadBalance = rs.getDouble("BadBalance");
		sInterestBalance1 = rs.getDouble("InterestBalance1");
		sInterestBalance2 = rs.getDouble("InterestBalance2");		
		sFineBalance1 = rs.getDouble("FineBalance1");
		sFineBalance2 = rs.getDouble("FineBalance2");
		sTABalance = rs.getDouble("TABalance");
		sTAInterestBalance = rs.getDouble("TAInterestBalance");		
   	}
   			
    java.text.DecimalFormat df = new java.text.DecimalFormat("#.00");
	
	//更新原合同的相关信息
	sSql="UPDATE BUSINESS_CONTRACT SET "+
	    //"BusinessSum =" +df.format(sBusinessSum)+ ","+
		" Balance = " +df.format(sBalance)+ ","+
		" NormalBalance = " +df.format(sNormalBalance)+ ","+
		" OverdueBalance = " +df.format(sOverdueBalance)+ ","+
		" DullBalance =" +df.format(sDullBalance)+ ","+
		" BadBalance =" +df.format(sBadBalance)+ ","+
		" InterestBalance1 =" +df.format(sInterestBalance1)+ ","+
		" InterestBalance2 =" +df.format(sInterestBalance2)+ ","+		
		" FineBalance1 =" +df.format(sFineBalance1)+ ","+
		" FineBalance2 =" +df.format(sFineBalance2)+ ","+
		" TABalance = " +df.format(sTABalance)+ ","+
		" TAInterestBalance = " +df.format(sTAInterestBalance)+ " "+		
		" where SerialNo='" + sOldContractNo + "'";
	Sqlca.executeSQL(sSql);
	rs.getStatement().close();
      	
	//根据合同下的借据重新计算新合同的相关金额
	sSql = 	" select sum(BusinessSum) as BusinessSum,sum(Balance) as Balance,sum(NormalBalance) as NormalBalance,"+
			" sum(OverdueBalance) as OverdueBalance,sum(DullBalance) as DullBalance,sum(BadBalance) as BadBalance,"+
			" sum(InterestBalance1) as InterestBalance1,sum(InterestBalance2) as InterestBalance2,"+
			" sum(FineBalance1) as FineBalance1,sum(FineBalance2) as FineBalance2,sum(TABalance) as TABalance, "+
			" sum(TAInterestBalance) as TAInterestBalance"+
	        " from BUSINESS_DUEBILL where RelativeSerialNo2='"+sContractNo+"' ";
	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sBusinessSum =rs.getDouble("BusinessSum");
		sBalance = rs.getDouble("Balance");		
		sNormalBalance = rs.getDouble("NormalBalance");
		sOverdueBalance =  rs.getDouble("OverdueBalance");
		sDullBalance =  rs.getDouble("DullBalance");
		sBadBalance = rs.getDouble("BadBalance");
		sInterestBalance1 = rs.getDouble("InterestBalance1");
		sInterestBalance2 = rs.getDouble("InterestBalance2");
		sFineBalance1 = rs.getDouble("FineBalance1");
		sFineBalance2 = rs.getDouble("FineBalance2");
		sTABalance = rs.getDouble("TABalance");
		sTAInterestBalance = rs.getDouble("TAInterestBalance");		
    }
       
	//更新新合同的相关信息
	sSql=	" UPDATE BUSINESS_CONTRACT SET "+
	        //"BusinessSum =" +df.format(sBusinessSum)+ ","+
			" Balance = " +df.format(sBalance)+ ","+
			" NormalBalance = " +df.format(sNormalBalance)+ ","+
			" OverdueBalance = " +df.format(sOverdueBalance)+ ","+
			" DullBalance =" +df.format(sDullBalance)+ ","+
			" BadBalance =" +df.format(sBadBalance)+ ","+
			" InterestBalance1 =" +df.format(sInterestBalance1)+ ","+
			" InterestBalance2 =" +df.format(sInterestBalance2)+ ","+
			" FineBalance1 =" +df.format(sFineBalance1)+ ","+
			" FineBalance2 =" +df.format(sFineBalance2)+ ","+
			" TABalance = " +df.format(sTABalance)+ ","+
			" TAInterestBalance = " +df.format(sTAInterestBalance)+ ", "+
			" DeleteFlag=null "+
			" where SerialNo='" + sContractNo + "'";
	Sqlca.executeSQL(sSql);
	rs.getStatement().close();
	
%>



</html>

<script language=javascript>
	self.returnValue="true";
    	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>