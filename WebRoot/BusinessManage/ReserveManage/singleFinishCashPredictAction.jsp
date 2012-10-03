<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-16
 * Tester:
 *
 * Content: ����ֽ���Ԥ���ύ
 * Input Param:
 * 		  �����ˮ�ţ�	SerialNo
 * 		 
 * 		  ����·ݣ�	AccountMonth
 * Output param:
 *        sReturnValue :
 *             00-�ɹ�
 *             01-ʧ��
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=gb2312"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow_open
	//��ѯ����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType == null) sType = "";
	String sSql="",sSql1="",sSql2="",updFieldDate="", updFieldUser = "", sLoanAccount="", sAccountMonth="";
	String sFromResultField = "", sToResultField = "",sFromResultField1="",sToResultField1="",sFromResultField2="",sToResultField2="";
	String updFieldDate1="",updFieldUser1="",updFieldDate2="",updFieldUser2="";
	ASResultSet rs1=null;
  	String sReturnValue="";
  	String sGrade = "", sNextGrade = "";
  	
  	//��ȡ�Ŵ�Ա����
  	String sSqljjw="select SortNo from Org_Info where OrgID = '"+CurOrg.OrgID+"' ";
	String sSortNo = Sqlca.getString(sSqljjw);
	String sSqljjw2 = "select OrgLevel from ORG_INFO where SortNo = '"+sSortNo+"' ";
	String sOrgLevel = Sqlca.getString(sSqljjw2);
 	if(sOrgLevel == null) sOrgLevel = "";
 	System.out.println("-----------------------------------"+sOrgLevel);
  	//��ȡ����ż�����·�
  	String stemp = "select LoanAccount, AccountMonth from reserve_record where serialno = '" + sSerialNo + "'";
  	ASResultSet rsTemp = Sqlca.getASResultSet(stemp);
    if(rsTemp.next()){
        sLoanAccount = rsTemp.getString("LoanAccount")==null ? "" :rsTemp.getString("LoanAccount");
        sAccountMonth = rsTemp.getString("AccountMonth")==null ? "" :rsTemp.getString("AccountMonth");
    }
    rsTemp.getStatement().close();
  
    if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")){//¼����Ա 
    	if("6".equals(sOrgLevel))
    	{ 	
       		updFieldDate = "FinishDate1";
       		updFieldUser = "UserID1";
       		sFromResultField = "Result1";
       		sToResultField = "Result2";
       	}
       	else if("3".equals(sOrgLevel))
       	{
       		updFieldDate = "FinishDate1";
       		updFieldUser = "UserID1";
       		sFromResultField = "Result1";
       		sToResultField = "Result2";
       		updFieldDate1 = "FinishDate2";
       		updFieldUser1 = "UserID2";
       		sFromResultField1 = "Result2";
       		sToResultField1 = "Result3";
       	}
       	else if("0".equals(sOrgLevel))
       	{
       		updFieldDate = "FinishDate1";
       		updFieldUser = "UserID1";
       		sFromResultField = "Result1";
       		sToResultField = "Result2";
       		updFieldDate1 = "FinishDate2";
       		updFieldUser1 = "UserID2";
       		sFromResultField1 = "Result2";
       		sToResultField1 = "Result3";
       		updFieldDate2 = "FinishDate3";
       		updFieldUser2 = "UserID3";
       		sFromResultField2 = "Result3";
       		sToResultField2 = "Result4";
       	}
     }
//    System.out.println("sType:"+sType);
     //����¼����Ա�п�����֧�л���е��϶���Ա����ô����ֱ�Ӹ��±������finishdate��userid��result,����Ҫһ��һ��������
     if(sType.equals("Confirm")){
	     if(CurUser.hasRole("601")){//�϶���Ա
	       updFieldDate = "FinishDate2";
	       updFieldUser = "UserID2";
	       sFromResultField = "Result2";
	       sToResultField = "Result3";
	     }else if(CurUser.hasRole("602")){
	       updFieldDate = "FinishDate3";
	       updFieldUser = "UserID3";
	       sFromResultField = "Result3";
	       sToResultField = "Result4";
	     }else if(CurUser.hasRole("603")){
	       updFieldDate = "FinishDate4";
	       updFieldUser = "UserID4";
	       sFromResultField = "Result4";
	       sToResultField = "MResult";
	     }
     }
	boolean bOldCommit = false;
	try{
	    //�����ύ��־
	    bOldCommit = Sqlca.conn.getAutoCommit();
	    Sqlca.conn.setAutoCommit(false);
	    if(sType.equals("Audit")){
	       sSql = "update RESERVE_RECORD set AFinishDate = '" + StringFunction.getToday() + "', AUserID = '" + CurUser.UserID + "'" + 
	              " where SerialNo = '"+ sSerialNo + "'";
	       Sqlca.executeSQL(sSql);    
		}else if(sType.equals("Confirm"))
		{
			sSql = "update RESERVE_RECORD  set " + updFieldDate + " = '" + StringFunction.getToday() + "', " +
	  		        	updFieldUser + " ='" + CurUser.UserID + "' where 1=1 "+ //modify by ycsunȥ������"', " +  sToResultField + " = " + sFromResultField +  �¼�������̳��ϼ����
					   " and SerialNo ='"+sSerialNo+"'";
		    Sqlca.executeSQL(sSql);
		    if(updFieldDate.equals("FinishDate1")){
		       sGrade ="01";
		       sNextGrade = "02";
		    }
		    if(updFieldDate.equals("FinishDate2")){
		       sGrade ="02";
		       sNextGrade = "03";
		    }
		    if(updFieldDate.equals("FinishDate3")){
		       sGrade ="03";
		       sNextGrade = "04";
		    }
		    if(updFieldDate.equals("FinishDate4")){
		       sGrade ="04";
		       sNextGrade = "05";
		    }
		}else{//�Ŵ�Ա����
			if("6".equals(sOrgLevel))
			{
	  			sSql = "update RESERVE_RECORD  set " + updFieldDate + " = '" + StringFunction.getToday() + "', " +
	  		        	updFieldUser + " ='" + CurUser.UserID + "' where 1=1 "+ //modify by ycsunȥ������"', " +  sToResultField + " = " + sFromResultField +  �¼�������̳��ϼ����
					   " and SerialNo ='"+sSerialNo+"'";
		    	Sqlca.executeSQL(sSql);
		    	sGrade ="01";
		        sNextGrade = "02";
		    }
		    else if("3".equals(sOrgLevel))
		    {
		    	sSql = "update RESERVE_RECORD  set " + updFieldDate + " = '" + StringFunction.getToday() + "', " +
	  		        	updFieldUser + " ='" + CurUser.UserID + "' where 1=1 "+ //modify by ycsunȥ������"', " +  sToResultField + " = " + sFromResultField +  �¼�������̳��ϼ����
					   " and SerialNo ='"+sSerialNo+"'";
		    	Sqlca.executeSQL(sSql);
		    	sSql1 = "update RESERVE_RECORD  set " + updFieldDate1 + " = '" + StringFunction.getToday() + "', " +
	  		        	updFieldUser1 + " ='" + CurUser.UserID + "' where 1=1 "+ //modify by ycsunȥ������"', " +  sToResultField + " = " + sFromResultField +  �¼�������̳��ϼ����
					   " and SerialNo ='"+sSerialNo+"'";
		    	Sqlca.executeSQL(sSql1);
		    	sGrade ="01";
		        sNextGrade = "03";
		    }
		    else if("0".equals(sOrgLevel))
		    {
		    	sSql = "update RESERVE_RECORD  set " + updFieldDate + " = '" + StringFunction.getToday() + "', " +
	  		        	updFieldUser + " ='" + CurUser.UserID + "' where 1=1 "+ //modify by ycsunȥ������"', " +  sToResultField + " = " + sFromResultField +  �¼�������̳��ϼ����
					   " and SerialNo ='"+sSerialNo+"'";
		    	Sqlca.executeSQL(sSql);
		    	sSql1 = "update RESERVE_RECORD  set " + updFieldDate1 + " = '" + StringFunction.getToday() + "', " +
	  		        	updFieldUser1 + " ='" + CurUser.UserID + "' where 1=1 "+ //modify by ycsunȥ������"', " +  sToResultField + " = " + sFromResultField +  �¼�������̳��ϼ����
					   " and SerialNo ='"+sSerialNo+"'";
		    	Sqlca.executeSQL(sSql1);
		    	sSql2 = "update RESERVE_RECORD  set " + updFieldDate2 + " = '" + StringFunction.getToday() + "', " +
	  		        	updFieldUser2 + " ='" + CurUser.UserID + "' where 1=1 "+ //modify by ycsunȥ������"', " +  sToResultField + " = " + sFromResultField +  �¼�������̳��ϼ����
					   " and SerialNo ='"+sSerialNo+"'";
		    	Sqlca.executeSQL(sSql2);
		    	sGrade ="01";
		        sNextGrade = "04";
		    }
		    System.out.println("------------------------------------------------"+2);
		    
		    //������һ��Ԥ���ֽ���
		 } 
		 String insSql = "insert into  reserve_predictdata (LoanAccount,AccountMonth, ReturnDate, Grade, ObjectNo, PredictInterest, " + 
		                        " PredictCapital,Reason,GuarantyValue,GuarantyReason,EnsureValue,EnsureReason, " + 
		                        " DueSum, Discount, DiscountValue) "  + 
		                        " select LoanAccount,AccountMonth, ReturnDate, '" + sNextGrade + "', ObjectNo, PredictInterest, " + 
		                        " PredictCapital,Reason,GuarantyValue,GuarantyReason,EnsureValue,EnsureReason, " + 
		                        " DueSum, Discount, DiscountValue " + 
		                        " from reserve_predictdata where LoanAccount = '" + sLoanAccount + "'" + 
		                        " and AccountMonth = '" + sAccountMonth + "'" + //modify by ycsun 2008/11/08 �ֽ���Ҫָ���ڴ�
		                        " and Grade = '" + sGrade + "'";
		    Sqlca.executeSQL(insSql);
		    System.out.println("------------------------------------------------"+3);
		    if(updFieldDate.equals("AFinishDate")){//����϶�Ա
		        //����ʧʶ���ڼ����Reserve_Loss����
		        String s1 = "select count(*) from reserve_loss where LoanAccount = '" + sLoanAccount + "'";
		        ASResultSet r1 = Sqlca.getASResultSet(s1);
		        if(r1.next()){
		           if(r1.getInt(1) == 0){//Reserve_Loss���в����ڣ��������
		               String s2 = "insert into reserve_loss (LoanAccount, ObjectNo,CustomerOrgCode, CustomerName, BeginDate,ConfirmDate," + 
		                             " TermDay, Describes, SaveFlag, AmendFlag, SubmitFlag, InputDate, Inputuserid, OperateOrgid) " + 
		                             " select LoanAccount, ObjectNo, OrgCode, CustomerName, BeginDate,ConfirmDate, " + 
		                             " TermDay, Describes, '1', '0', '01', '" + StringFunction.getToday() + "', Manageuserid,statorgid " + 
		                             " from reserve_record  where LoanAccount = '" + sLoanAccount + "'" ;
		               Sqlca.executeSQL(s2);
		           }
		        }
		        r1.getStatement().close();
		 }
	    Sqlca.conn.commit();
	    Sqlca.conn.setAutoCommit(bOldCommit);
		sReturnValue="00";
	}catch(Exception e){
	    Sqlca.conn.rollback();
	    Sqlca.conn.setAutoCommit(bOldCommit);
		sReturnValue = "01";
		System.out.println(e.toString());
    }
%>
<script language=javascript>
	self.returnValue="<%=sReturnValue%>";
	self.close();   
</script>
<%@ include file="/IncludeEnd.jsp"%>
