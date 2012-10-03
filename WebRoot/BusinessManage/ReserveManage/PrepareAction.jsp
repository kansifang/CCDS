<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xhwang1  2007-10-15
 * Tester:
 *
 * Content: ��ֵ׼������
 * Input Param:
 *           UpdateFlag: 0-�����弶����
 *                       1-�����������¼
 *                       2-�����ֵ׼��
 *                       3-����
 *                       4-���·��Ŵ���������Ʊ�־
 * Output param:
 *           ReturnValue: 00-���³ɹ�
 *                        01������ʧ��
 *                        02-������û���������ڻ���·�
 *                        03-��δ��¼��¼
 *                        04-�弶����û�з���
 *         
 * History Log: 
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>

<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String sDuebillNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DuebillNo"));//��ݱ��
	String sUpdateFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UpdateFlag"));//���±�־
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));//����·�
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));//�����˺�
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));//�������
	String sAuditStatFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuditStatFlag"));//��Ʊ�־
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));//�ֽ���Ԥ�⼶��
	if(sAuditStatFlag == null) sAuditStatFlag = "";
	if(sGrade == null) sGrade = "04";
	String sSql="";
	String sReturnValue="";
	if(sDuebillNo==null) sDuebillNo = "";
	if(sUpdateFlag==null) sUpdateFlag = "";
	if(sAccountMonth==null) sAccountMonth="";
	if(sLoanAccount==null) sLoanAccount="";
	if(sOrgID==null) sOrgID="";
	String sClassifyResult="";
	String sPreMonth="";
	//String AFiveClassify="";//�����弶����������ƿھ���
	//String LAFiveClassify="";//�����弶����������ƿھ���
	//String MFiveClassify="";//�����弶������������ھ���
	//String LMFiveClassify="";//�����弶������������ھ���
	String sReinforceFlag="";//�Ƿ񲹵Ǳ�־
    int iCount=0;
    ASResultSet rs=null;
    String sFlag1="";
    String sFlag2="";
    String sFlag3="";
    String sSerialNo="";

	try{
	    if(sUpdateFlag.equals("0")){//�����弶����		    
		    //ȡ����������
	  		String stemp = "select lastAccountMonth from reserve_para where accountMonth = '" + sAccountMonth + "'";
	  		ASResultSet r1 = Sqlca.getASResultSet(stemp);
	  		if(r1.next()){
	  		   sPreMonth = r1.getString(1)==null ? "" : r1.getString(1);
	  		}
	  		r1.getStatement().close();
	  		
	  		if(sPreMonth.equals("")){
	  		   sReturnValue = "02";//������û���������ڻ���·�
	  		}
		    
		    //��ѯ�弶������
		    String sSelSql = " select ObjectNo,Result4 from classify_record "+
		   		    " where AccountMonth='"+sAccountMonth+"' ";
		    rs = Sqlca.getASResultSet(sSelSql);
		   	System.out.println(sSelSql);
		   	while(rs.next()){
		   		sClassifyResult=rs.getString("Result4");
		   		sSerialNo=rs.getString("ObjectNo");
		   		if(sClassifyResult==null) sClassifyResult="";
		   		if(sSerialNo==null) sSerialNo="";

			     //���弶����ת��Ϊ��ֵ׼��ϵͳ���弶����
			    com.amarsoft.ReserveManage.CreditInfo ci = new com.amarsoft.ReserveManage.CreditInfo(Sqlca);
				sClassifyResult = ci.getReserveFiveClassify(sClassifyResult);
				System.out.println("ClassifyResult="+sClassifyResult);
		   		 
		   		 //���¹�˾��������ݿ�
	    	   sSql = " update Reserve_Total set MFiveClassify='"+sClassifyResult+"' " + 
	    	          ", AFiveClassify = '" + sClassifyResult+"' " + //�������弶�����ʼΪ�����弶����
	    	         " where  AccountMonth='"+sAccountMonth+"' and DueBillNo='"+sSerialNo+"'";
    		   Sqlca.executeSQL(sSql);
           }
		   rs.getStatement().close();
		   
		   /**�޸ı��ڵ�����弶������������Ϊ��
		   *  1��������¹���ھ��弶�������������ƿھ��弶���࣬������ƿھ��弶������ڱ��¹���ھ��弶����
		   *  2��������¹���ھ��弶���಻����������ƿھ��弶���࣬������ƿھ��弶�������������ƿھ��弶����
		   */
			     
		    //��ȡ���ڵ���ƿھ��弶����
           sSql="select LoanAccount,AFiveClassify From Reserve_total " + 
               " where AccountMonth= '"+sPreMonth+"' and AFiveClassify <> MFiveClassify";
		   System.out.println("test="+sSql);
		   rs = Sqlca.getASResultSet(sSql);
		   while(rs.next()){
		  	 String stempLoanAccount = rs.getString("LoanAccount");
		     String sLastAFiveClassify = rs.getString("AFiveClassify");
			 sSql = " update Reserve_Total set AFiveClassify='"+sLastAFiveClassify+"' where  AccountMonth='"+sAccountMonth+"' and LoanAccount='"+stempLoanAccount+"' ";
			 Sqlca.executeSQL(sSql);
		   }
		   sReturnValue="00";
	       rs.getStatement().close();
	    }else if(sUpdateFlag.equals("1")){//�����������¼
	        boolean bExist = false;
	  		String stemp = "select count(*) from reserve_para where accountMonth = '" + sAccountMonth + "'";
	  		ASResultSet r1 = Sqlca.getASResultSet(stemp);
	  		if(r1.next()){
	  		   if(r1.getInt(1)>0){
	  		        bExist = true;
	  		   }
	  		}
	  		r1.getStatement().close();
	  		
	  		if(bExist){
	  		   sReturnValue = "02";//�ü�¼�Ѵ���
	  		}else{
	  		    stemp = "insert into reserve_para (accountMonth) values ('" + sAccountMonth + "')";
	  		    Sqlca.executeSQL(stemp);
	  		    sReturnValue = "00";
	  		}
	    }else if(sUpdateFlag.equals("2")){//�����ֵ׼��
	      //���ֽ���Ԥ�⼶������������
	      Sqlca.executeSQL("UPDATE reserve_para set Grade = '" + sGrade + "' where AccountMonth='"+sAccountMonth+"'");
          //���ݲ�ѯ����ѭ�����¼�ֵ׼��
          System.out.println(sAccountMonth+"++++++++++++++++++++++++++++++++++++++++++"+sLoanAccount);
         // com.amarsoft.ReserveManage.BatchReserveInfo bri = new com.amarsoft.ReserveManage.BatchReserveInfo(Sqlca);
		  //bri.isUpdate(sAccountMonth,sLoanAccount);
		  sSql = "select AccountMonth, LoanAccount,ManageStatFlag,BusinessFlag from Reserve_Total where AccountMonth='"+sAccountMonth+"' "
		  +" and LoanAccount ='"+sLoanAccount+"' order by AccountMonth";
		  rs = Sqlca.getASResultSet(sSql);
		  String sManageStatFlag;
		  String sBusinessFlag;
		  while(rs.next()){
			   	sAccountMonth=rs.getString("AccountMonth");
			    sLoanAccount=rs.getString("LoanAccount");
			    sManageStatFlag=rs.getString("ManageStatFlag");
			    sBusinessFlag=rs.getString("BusinessFlag");
			    if(sAccountMonth==null)sAccountMonth="";
			    if(sLoanAccount==null)sLoanAccount="";
			    if(sManageStatFlag==null)sManageStatFlag="";
			    if(sBusinessFlag==null)sBusinessFlag="";
			    System.out.println(sAccountMonth+ "=============================================================="+sLoanAccount);
		        //���¼�ֵ׼������
		   	    com.amarsoft.ReserveManage.BatchReserveInfo bri = new com.amarsoft.ReserveManage.BatchReserveInfo(Sqlca);
		    	bri.runCalculateData(sAccountMonth,sLoanAccount,sManageStatFlag,sBusinessFlag);
		   }
		   
		   rs.getStatement().close();
	       sReturnValue = "00";
	    }else if(sUpdateFlag.equals("3")){//��������
	       boolean bPubFlag = true;
		   sSql="select count(*) from Reserve_Total " + 
		      " where AccountMonth='"+sAccountMonth+"'" +
		      " and ReinforceFlag = '01'";//δ�������
	       rs = Sqlca.getASResultSet(sSql);
	       if(rs.next()){
	          if(rs.getInt(1)>0){
	           bPubFlag = false;
	           sReturnValue = "03";//��δ������ɵļ�¼�����ܷ���
	          }
	       }
	       rs.getStatement().close();
	       if(bPubFlag){
			 sSql="select count(*) from Reserve_Total " + 
			      " where AccountMonth='"+sAccountMonth+"'" +
			      " and  (MFiveClassify is null or AFiveClassify is null)";//�弶����û�з������
			 rs = Sqlca.getASResultSet(sSql);
		     if(rs.next()){
		        if(rs.getInt(1)>0){
		           bPubFlag = false;
		           sReturnValue = "04";//�弶����û�з�����ɣ����ܷ���
		        }
		     }
		     rs.getStatement().close();
	       }
	       if(bPubFlag){
			    sSql = " update Reserve_Total set PubFlag='01' where AccountMonth='"+sAccountMonth+"'";
				Sqlca.executeSQL(sSql);
			    System.out.println(sSql);
				sReturnValue="00";
		   }
        }else if(sUpdateFlag.equals("4")){//���·��Ŵ���������Ʊ�־
           sSql = "update Reserve_Total set AuditStatFlag = '" + sAuditStatFlag + "'" + 
                  " where NonCreditTransferFlag = '1' and AccountMonth='"+sAccountMonth+"'";
           Sqlca.executeSQL(sSql);
		   sReturnValue="00";
        }
    }catch(Exception ex){
	   sReturnValue = "01";
	   ex.printStackTrace();
	   System.out.println(ex.getMessage());
	}
%>
<script language=javascript>
    self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>