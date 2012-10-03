<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xhwang1  2007-10-15
 * Tester:
 *
 * Content: 减值准备更新
 * Input Param:
 *           UpdateFlag: 0-更新五级分类
 *                       1-新增参数表记录
 *                       2-计提减值准备
 *                       3-发布
 *                       4-更新非信贷类贷款的审计标志
 * Output param:
 *           ReturnValue: 00-更新成功
 *                        01－更新失败
 *                        02-参数表没有设置上期会计月份
 *                        03-有未补录记录
 *                        04-五级分类没有分完
 *         
 * History Log: 
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>

<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String sDuebillNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DuebillNo"));//借据编号
	String sUpdateFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UpdateFlag"));//更新标志
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));//会计月份
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));//贷款账号
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));//机构编号
	String sAuditStatFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuditStatFlag"));//审计标志
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));//现金流预测级别
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
	//String AFiveClassify="";//本月五级分类结果（审计口径）
	//String LAFiveClassify="";//上月五级分类结果（审计口径）
	//String MFiveClassify="";//本月五级分类结果（管理口径）
	//String LMFiveClassify="";//上月五级分类结果（管理口径）
	String sReinforceFlag="";//是否补登标志
    int iCount=0;
    ASResultSet rs=null;
    String sFlag1="";
    String sFlag2="";
    String sFlag3="";
    String sSerialNo="";

	try{
	    if(sUpdateFlag.equals("0")){//更新五级分类		    
		    //取得上月日期
	  		String stemp = "select lastAccountMonth from reserve_para where accountMonth = '" + sAccountMonth + "'";
	  		ASResultSet r1 = Sqlca.getASResultSet(stemp);
	  		if(r1.next()){
	  		   sPreMonth = r1.getString(1)==null ? "" : r1.getString(1);
	  		}
	  		r1.getStatement().close();
	  		
	  		if(sPreMonth.equals("")){
	  		   sReturnValue = "02";//参数表没有设置上期会计月份
	  		}
		    
		    //查询五级分类结果
		    String sSelSql = " select ObjectNo,Result4 from classify_record "+
		   		    " where AccountMonth='"+sAccountMonth+"' ";
		    rs = Sqlca.getASResultSet(sSelSql);
		   	System.out.println(sSelSql);
		   	while(rs.next()){
		   		sClassifyResult=rs.getString("Result4");
		   		sSerialNo=rs.getString("ObjectNo");
		   		if(sClassifyResult==null) sClassifyResult="";
		   		if(sSerialNo==null) sSerialNo="";

			     //将五级分类转换为减值准备系统的五级分类
			    com.amarsoft.ReserveManage.CreditInfo ci = new com.amarsoft.ReserveManage.CreditInfo(Sqlca);
				sClassifyResult = ci.getReserveFiveClassify(sClassifyResult);
				System.out.println("ClassifyResult="+sClassifyResult);
		   		 
		   		 //更新公司类贷款数据库
	    	   sSql = " update Reserve_Total set MFiveClassify='"+sClassifyResult+"' " + 
	    	          ", AFiveClassify = '" + sClassifyResult+"' " + //审计类的五级分类初始为管理五级分类
	    	         " where  AccountMonth='"+sAccountMonth+"' and DueBillNo='"+sSerialNo+"'";
    		   Sqlca.executeSQL(sSql);
           }
		   rs.getStatement().close();
		   
		   /**修改本期的审计五级分类结果，规则为：
		   *  1、如果上月管理口径五级分类等于上月审计口径五级分类，则本月审计口径五级分类等于本月管理口径五级分类
		   *  2、如果上月管理口径五级分类不等于上月审计口径五级分类，则本月审计口径五级分类等于上月审计口径五级分类
		   */
			     
		    //获取上期的审计口径五级分类
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
	    }else if(sUpdateFlag.equals("1")){//新增参数表记录
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
	  		   sReturnValue = "02";//该记录已存在
	  		}else{
	  		    stemp = "insert into reserve_para (accountMonth) values ('" + sAccountMonth + "')";
	  		    Sqlca.executeSQL(stemp);
	  		    sReturnValue = "00";
	  		}
	    }else if(sUpdateFlag.equals("2")){//计提减值准备
	      //将现金流预测级别存入参数表中
	      Sqlca.executeSQL("UPDATE reserve_para set Grade = '" + sGrade + "' where AccountMonth='"+sAccountMonth+"'");
          //根据查询条件循环更新减值准备
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
		        //更新减值准备方法
		   	    com.amarsoft.ReserveManage.BatchReserveInfo bri = new com.amarsoft.ReserveManage.BatchReserveInfo(Sqlca);
		    	bri.runCalculateData(sAccountMonth,sLoanAccount,sManageStatFlag,sBusinessFlag);
		   }
		   
		   rs.getStatement().close();
	       sReturnValue = "00";
	    }else if(sUpdateFlag.equals("3")){//发布数据
	       boolean bPubFlag = true;
		   sSql="select count(*) from Reserve_Total " + 
		      " where AccountMonth='"+sAccountMonth+"'" +
		      " and ReinforceFlag = '01'";//未补登完成
	       rs = Sqlca.getASResultSet(sSql);
	       if(rs.next()){
	          if(rs.getInt(1)>0){
	           bPubFlag = false;
	           sReturnValue = "03";//有未补登完成的记录，不能发布
	          }
	       }
	       rs.getStatement().close();
	       if(bPubFlag){
			 sSql="select count(*) from Reserve_Total " + 
			      " where AccountMonth='"+sAccountMonth+"'" +
			      " and  (MFiveClassify is null or AFiveClassify is null)";//五级分类没有分类完成
			 rs = Sqlca.getASResultSet(sSql);
		     if(rs.next()){
		        if(rs.getInt(1)>0){
		           bPubFlag = false;
		           sReturnValue = "04";//五级分类没有分类完成，不能发布
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
        }else if(sUpdateFlag.equals("4")){//更新非信贷类贷款的审计标志
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