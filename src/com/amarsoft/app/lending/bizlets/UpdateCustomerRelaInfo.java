package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;

public class UpdateCustomerRelaInfo extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception
	 {		
        //自动获得传入的参数值		
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sFromUserID   = (String)this.getAttribute("FromUserID");
		String sToUserID   = (String)this.getAttribute("ToUserID");
		
        //将空值转化成空字符串		
		if(sCustomerID == null) sCustomerID = "";
		if(sFromUserID == null) sFromUserID = "";
		if(sToUserID == null) sToUserID = "";
		
		
		//定义变量	
        ASUser CurUser = null;
        String sCustomerType = "";
        String sFromOrgID = "";
        String sToUserName = "",sToOrgID = "",sToOrgName = "";
        String sUpdateDate = "",sUpdateTime = "";
        
        //获取转移前的机构代码和机构名称
        CurUser = new ASUser(sFromUserID,Sqlca);
        sFromOrgID = CurUser.OrgID;
        
        //获取转移前的机构代码和机构名称
        CurUser = new ASUser(sToUserID,Sqlca);
        sToUserName = CurUser.UserName;
        sToOrgID = CurUser.OrgID;
        sToOrgName = CurUser.BelongOrgName;
       
        //获取变更日期
        sUpdateDate = StringFunction.getToday();
        sUpdateTime = StringFunction.getTodayNow();
		//获取客户类型
        sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
		if (sCustomerType == null) sCustomerType = "";
		
		
		//****************公共（包括集团）*****************
		//更新客户权限
		UpdateCustomerBelong(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //更新客户概况
		UpdateCustomerInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,Sqlca);
        //更新企业客户关联成员（客户高管、法人代表家族成员、股东情况、对外股权投资情况、其他关联方情况）
		//更新个人配偶及家庭成员情况、个人投资企业情况
		UpdateCustomerRelative(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //更新企业客户在其他金融机构涉诉信息和客户大事记
		//个人大事记
		UpdateCustomerMemo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //更新公司客户文档信息
		//个人客户提供相关资料
		UpdateDocLibrary(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToUserName,sToOrgID,sToOrgName,sUpdateTime,Sqlca);
        //更新股票信息
		UpdateCustomerStock(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //更新持有债券信息
		UpdateCustomerBond(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //更新纳税信息
		UpdateCustomerTaxPaying(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //更新无形资产信息
		UpdateImaAsserts(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);	
        //更新其他金融机构业务活动
		UpdateCustomerOActivity(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //更新客户情况分析
		//个人情况分析
		UpdateCustomerAnarecord(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
		
		
		if(sCustomerType.substring(0,2).equals("01")){  //公司客户			
	        //更新企业客户表
			UpdateEntInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新股票表
			UpdateEntIPO(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新债券表
			UpdateEntBondIssue(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新房地产资质情况
			UpdateEntRealtyAuth(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新进出口贸易
			UpdateEntranceAuth(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新特许经营行业和相关认证信息
			UpdateEntAuth(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新参与项目情况
			UpdateProjectInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新财务报表
			UpdateCustomerFSRecord(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,sUpdateTime,Sqlca);
	        //更新应收应付帐款信息
			UpdateEntFOA(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新更新存货信息
			UpdateEntInventory(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新固定资产信息
			UpdateEntFixedAsserts(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);	
	        //更新现金流预测
			UpdateCashRecord(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,Sqlca);
	        //更新客户信用等级评估
			UpdateEvaluateRecordEnt(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //更新风险预警信号评估和最高授信限额参考
			UpdateRiskSignal(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	    }	
			
		if(sCustomerType.substring(0,2).equals("03")) 	//个人客户
		{
	        //个人概况表
			UpdateIndInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //个人学业履历
			UpdateIndEducation(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //个人工作履历
			UpdateIndResume(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //社会保险、财产保险、人寿保险
			UpdateIndSi(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //房屋资产情况
			UpdateCustomerRealty(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //车辆资产情况
			UpdateCustomerVehicle(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //其他资产信息
			UpdateIndOasset(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //其他负债信息
			UpdateIndOdebt(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //个人信用等级评估信息
			UpdateEvaluateRecordInd(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,Sqlca);
		}	

		return "1";
				
	 }
	
	private void UpdateCustomerBelong(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca) 
		throws Exception
	{
		//变量定义
	    String sBelongAttribute1 = "",sBelongAttribute2 = "",sBelongAttribute3 = "",sBelongAttribute4 = "";
	    String sNewBelongAttribute1 = "",sNewBelongAttribute2 = "",sNewBelongAttribute3 = "",sNewBelongAttribute4 = "";
	    String sSql = "";
	    ASResultSet rs = null;	
	    
	    //将原用户对该客户的权限取出。
		sSql =  " select BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4 "+
                " from CUSTOMER_BELONG " +
            	" where CustomerID = '"+sCustomerID+"' "+
            	" and OrgID = '"+sFromOrgID+"' "+
            	" and UserID = '"+sFromUserID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
		    sBelongAttribute1 = DataConvert.toString(rs.getString("BelongAttribute1"));
		    sBelongAttribute2 = DataConvert.toString(rs.getString("BelongAttribute2"));
		    sBelongAttribute3 = DataConvert.toString(rs.getString("BelongAttribute3"));
		    sBelongAttribute4 = DataConvert.toString(rs.getString("BelongAttribute4"));
		}
	    rs.getStatement().close();
		
		//将目标用户对该客户的权限取出。
		sSql =  " select BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4 "+
	        	" from CUSTOMER_BELONG " +
	        	" where CustomerID = '"+sCustomerID+"' "+
	        	" and OrgID = '"+sToOrgID+"' "+
	        	" and UserID = '"+sToUserID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
		    sNewBelongAttribute1 = DataConvert.toString(rs.getString("BelongAttribute1"));
		    sNewBelongAttribute2 = DataConvert.toString(rs.getString("BelongAttribute2"));
		    sNewBelongAttribute3 = DataConvert.toString(rs.getString("BelongAttribute3"));
		    sNewBelongAttribute4 = DataConvert.toString(rs.getString("BelongAttribute4"));
	
            //取业务主办权、信息维护权和业务办理权的更高权限
            if(Integer.parseInt(sBelongAttribute1) > Integer.parseInt(sNewBelongAttribute1) && sNewBelongAttribute1 != "")
                sBelongAttribute1 = sNewBelongAttribute1;
            if(Integer.parseInt(sBelongAttribute2) > Integer.parseInt(sNewBelongAttribute2) && sNewBelongAttribute2 != "")
                sBelongAttribute2 = sNewBelongAttribute2;
            if(Integer.parseInt(sBelongAttribute3) > Integer.parseInt(sNewBelongAttribute3) && sNewBelongAttribute3 != "")
                sBelongAttribute3 = sNewBelongAttribute3;
            if(Integer.parseInt(sBelongAttribute4) > Integer.parseInt(sNewBelongAttribute4) && sNewBelongAttribute4 != "")
                sBelongAttribute4 = sNewBelongAttribute4;
        }
        rs.getStatement().close();
           		
        //如果数据库中存在与要插入的数据相同的记录，则首先删除原来的记录，再进行插入新纪录。
        sSql =   " delete from CUSTOMER_BELONG where CustomerID='"+sCustomerID+"' and OrgID='"+sToOrgID+"' and UserID='"+sToUserID+"' ";
        Sqlca.executeSQL(sSql);
        
        //将当前用户的权限更新并把用户改为目标用户
        sSql =  " update CUSTOMER_BELONG set "+
        		" UserID = '"+ sToUserID + "', "+
        		" OrgID = '"+ sToOrgID +"', " +
                " BelongAttribute1 = '"+ sBelongAttribute1 +"'," +
                " BelongAttribute2 = '"+ sBelongAttribute2 +"'," +
                " BelongAttribute3 = '"+ sBelongAttribute3 +"'," +
                " BelongAttribute4 = '"+ sBelongAttribute4 +"', " +
                " UpdateDate = '"+sUpdateDate+"' "+
                " where CustomerID = '"+ sCustomerID +"' "+
                " and OrgID = '"+ sFromOrgID +"' "+
                " and UserID = '"+ sFromUserID +"' ";
        Sqlca.executeSQL(sSql);
	}
	
	 //更新客户概况
	 private void UpdateCustomerInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_INFO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"' " +
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //更新企业客户表
	 private void UpdateEntInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_INFO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update ENT_INFO set "+
		 		" UpdateUserID = '"+sToUserID+"', "+
		 		" UpdateOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UpdateUserID = '"+sFromUserID+"' "+
		 		" and UpdateOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
	 }
	 
	 //更新客户关联成员（客户高管、法人代表家族成员、股东情况、对外股权投资情况、其他关联方情况）
	 private void UpdateCustomerRelative(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_RELATIVE set "+
		 		" InputUserID='"+sToUserID+"', "+
		 		" InputOrgID='"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //更新股票表
	 private void UpdateEntIPO(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_IPO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //更新债券表
	 private void UpdateEntBondIssue(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_BONDISSUE set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 }
	 
     //更新房地产资质情况
	 private void UpdateEntRealtyAuth(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_REALTYAUTH set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //	更新进出口贸易
	 private void UpdateEntranceAuth(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_ENTRANCEAUTH set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 	 	 
	 //更新特许经营行业和相关认证信息
	 private void UpdateEntAuth(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_AUTH set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 	 
	 //更新客户在其他金融机构涉诉信息和客户大事记
	 private void UpdateCustomerMemo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_MEMO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //更新参与项目情况
	 private void UpdateProjectInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 //更新项目概况
		 String sSql = "";
		 sSql = " update PROJECT_INFO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo = '"+sCustomerID+"') "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	
		 
		 //更新项目资金来源		
		 sSql = " update PROJECT_FUNDS set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo = '"+sCustomerID+"') "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	
		 
		 //更新项目进展情况		
		 sSql = " update PROJECT_PROGRESS set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo = '"+sCustomerID+"') "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	
		 
		 //更新项目投资概算		 
		 sSql = " update PROJECT_BUDGET set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo = '"+sCustomerID+"') "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
	 } 
	 
     //更新文档信息
	 private void UpdateDocLibrary(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToUserName,String sToOrgID,String sToOrgName,String sUpdateTime,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 //更新文档基本信息
		 sSql = " update DOC_LIBRARY set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" UserName = '"+sToUserName+"', "+
		 		" OrgID = '"+sToOrgID+"', " +
		 		" OrgName = '"+sToOrgName+"', " +
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update DOC_LIBRARY set "+
		 		" InputUser = '"+sToUserID+"', "+	 		
		 		" InputOrg = '"+sToOrgID+"', " +	 		
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and InputUser = '"+sFromUserID+"' "+
		 		" and InputOrg = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update DOC_LIBRARY set "+
		 		" UpdateUser = '"+sToUserID+"', "+	 		 				
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and UpdateUser = '"+sFromUserID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 //更新文档附件信息
		 sSql = " update DOC_ATTACHMENT set "+
		 		" InputUser = '"+sToUserID+"', "+		 		
		 		" InputOrg = '"+sToOrgID+"', " +		 		
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and InputUser = '"+sFromUserID+"' "+
		 		" and InputOrg = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update DOC_ATTACHMENT set "+
		 		" UpdateUser = '"+sToUserID+"', "+	 		 				
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and UpdateUser = '"+sFromUserID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
	 } 
	 
     //更新财务报表
	 private void UpdateCustomerFSRecord(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,String sUpdateTime,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_FSRECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update REPORT_RECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"', " +
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" where ObjectType = 'CustomerFS' " +
		 		" and ObjectNo = '"+sCustomerID+"' "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
	 } 
	 
	 
     //	更新应收应付帐款信息
	 private void UpdateEntFOA(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_FOA set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //	更新存货信息
	 private void UpdateEntInventory(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_INVENTORY set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //	更新固定资产信息
	 private void UpdateEntFixedAsserts(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_FIXEDASSETS set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //更新无形资产信息
	 private void UpdateImaAsserts(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_IMASSET set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //更新持有股票信息
	 private void UpdateCustomerStock(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_STOCK set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //更新持有债券信息
	 private void UpdateCustomerBond(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_BOND set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //更新纳税信息
	 private void UpdateCustomerTaxPaying(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_TAXPAYING set "+
		  		" InputUserID = '"+sToUserID+"', "+
		  		" InputOrgID = '"+sToOrgID+"', " +
		  		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //更新其他金融机构业务活动
	 private void UpdateCustomerOActivity(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_OACTIVITY set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //更新现金流预测
	 private void UpdateCashRecord(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CASHFLOW_RECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"' " +
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //更新客户情况分析
	 private void UpdateCustomerAnarecord(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_ANARECORD set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	
		 
		 sSql = " update CUSTOMER_ANARECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
	 } 
	 
     //更新客户信用等级评估(010)和最高授信限额参考(080)
	 private void UpdateEvaluateRecordEnt(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToUserName,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 { 
		 String sSql = "";
		 sSql = " update EVALUATE_RECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '010' or ModelType = '080') "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID = '"+sToUserID+"', "+
		 		" CognOrgID = '"+sToOrgID+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '010' or ModelType = '080') "+
		 		" and CognUserID = '"+sFromUserID+"' "+
		 		" and CognOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID2 = '"+sToUserID+"', "+
		 		" CognUserName2 = '"+sToUserName+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '010' or ModelType = '080') "+
		 		" and CognUserID2 = '"+sFromUserID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID3 = '"+sToUserID+"', "+
		 		" CognUserName3 = '"+sToUserName+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType='010') "+
		 		" and CognUserID3 = '"+sFromUserID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID4 = '"+sToUserID+"', "+
		 		" CognUserName4 = '"+sToUserName+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType='010') "+
		 		" and CognUserID4 = '"+sFromUserID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
	 } 
	 
	 //更新风险预警信号评估
	 private void UpdateRiskSignal(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update RISK_SIGNAL set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = 'Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update RISKSIGNAL_OPINION set "+
		 		" CheckUser = '"+sToUserID+"', "+
		 		" CheckOrg = '"+sToOrgID+"' " +		 		
		 		" where ObjectNo in (select SerialNo from RISK_SIGNAL where ObjectType = 'Customer' and ObjectNo = '"+sCustomerID+"') "+
		 		" and CheckUser = '"+sFromUserID+"' "+
		 		" and CheckOrg = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update RISKSIGNAL_OPINION set "+
		 		" NextCheckUser = '"+sToUserID+"' "+			 		
		 		" where ObjectNo in (select SerialNo from RISK_SIGNAL where ObjectType = 'Customer' and ObjectNo = '"+sCustomerID+"') "+
		 		" and NextCheckUser = '"+sFromUserID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
	 } 
	 	 
	 
	 //******************个人相关*******************	 
	 //个人概况表
	 private void UpdateIndInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_INFO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update IND_INFO set "+
		 		" UpdateUserID = '"+sToUserID+"', "+
		 		" UpdateOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UpdateUserID = '"+sFromUserID+"' "+
		 		" and UpdateOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
	 } 
	 	 
	 //个人配偶及家庭成员情况（和公司类公用UpdateCustomerRelative）
	 	 
     //个人学业履历
	 private void UpdateIndEducation(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_EDUCATION set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //个人工作履历
	 private void UpdateIndResume(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_RESUME set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     
	 //	个人大事记(同公司类公用UpdateCustomerMemo)
	 
	 //个人提供相关资料(同公司类公用UpdateDocLibrary)
	 
	 //社会保险、财产保险、人寿保险
	 private void UpdateIndSi(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_SI set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //房屋资产情况
	 private void UpdateCustomerRealty(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_REALTY set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //车辆资产情况
	 private void UpdateCustomerVehicle(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_VEHICLE set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //持有股票信息（同公司类公用UpdateCustomerStock）
	 
     //持有债券信息（同公司类公用UpdateCustomerBond）
	 
	 //投资企业情况（同公司类公用UpdateCustomerRelative）
	 
     //纳税信息（同公司公用UpdateCustomerTaxPaying）
	 
     //无形资产信息（同公司公用UpdateImaAsserts）
	 
     //其他资产信息
	 private void UpdateIndOasset(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_OASSET set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	
	 }
	 
	 //其他负债信息
	 private void UpdateIndOdebt(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_ODEBT set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);	
	 }
	 
	 
	 //个人信用等级评估信息
	 private void UpdateEvaluateRecordInd(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 { 
		 String sSql = "";
		 sSql = " update EVALUATE_RECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '015') "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //执行删除语句
		 Sqlca.executeSQL(sSql);
	 } 
	 
	 
	 //在其他金融机构业务活动（同公司公用UpdateCustomerOActivity）
	 
	 //个人情况分析(同公司公用UpdateCustomerAnarecord)
	 
	 	 
	 //***********************集团客户***************************	 
	 //集团概况（同UpdateCustomerInfo）
	 
	 //集团成员（同UpdateCustomerRelative）
	 
}
