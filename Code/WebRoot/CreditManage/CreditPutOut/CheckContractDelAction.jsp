<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:      ndeng 2005.02.02
 * Tester:
 *
 * Content: 检查合同是否能删除
 * Input Param:
 *			ObjectNo:合同流水号
                
 * Output param:
 * History Log: zywei 2006/08/12  
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<% 
    //定义变量
    String sRight = "",sReturnValue = "",sSql = "",sFinishDate = "";
    String sPigeonholeDate = "",sManageUserID = "",sBusinessType = "";
    String sReinforceFlag = "",sRelativeSerialNo = "";
    int iCount = 0;
    ASResultSet rs = null;
    
    //获取组件参数    
    
    //获取页面参数：合同流水号
    String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	//获取合同的终结日期、归档日期、管户人、业务品种信息
	sSql = 	" select FinishDate,PigeonholeDate,ManageUserID,BusinessType,ReinforceFlag,RelativeSerialNo "+
			" from BUSINESS_CONTRACT "+
			" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getResultSet(sSql);
    if(rs.next())
    {
        sFinishDate = rs.getString("FinishDate");
        sPigeonholeDate = rs.getString("PigeonholeDate");
        sManageUserID = rs.getString("ManageUserID");
        sBusinessType = rs.getString("BusinessType");
        sReinforceFlag = rs.getString("ReinforceFlag");
        sRelativeSerialNo = rs.getString("RelativeSerialNo");
        //将空值转化为空字符串
        if(sFinishDate == null) sFinishDate = "";
        if(sPigeonholeDate == null) sPigeonholeDate = "";
        if(sManageUserID == null) sManageUserID = "";
        if(sBusinessType == null) sBusinessType = "";
        if(sReinforceFlag == null) sReinforceFlag = "";
        if(sRelativeSerialNo == null) sRelativeSerialNo = "";
    }
    rs.getStatement().close();
    
    if(sReinforceFlag.equals("")) //新增的合同
    {
	    if(sFinishDate.equals("")) //未终结
	    {
	    	if(sPigeonholeDate.equals("")) //未完成放贷
	    	{
	    		if(sBusinessType.substring(0,1).equals("3")) //授信额度
	    		{
	    			//检查该授信额度是否被其他业务占用过
	    			sSql = 	" select count(SerialNo) "+
	    					" from BUSINESS_APPLY where "+
	    					" CreditAggreement = '"+sObjectNo+"' ";
	    			rs = Sqlca.getASResultSet(sSql);
		    		if(rs.next())
		    			iCount = rs.getInt(1);
		    		rs.getStatement().close();
		    		
		    		if(iCount > 0) //授信额度已被占用
		    		{
		    			 sReturnValue = "Use";
		    		}else
		    		{
		    			if(!sManageUserID.equals(CurUser.UserID)) //其他信贷人员管户
		    			{
		    				sReturnValue = "Other";
		    			}
		    		} 
	    		}else
	    		{
		    		//检查该合同是否存在放款信息
		    		sSql = 	" select count(SerialNo) "+
		    				" from BUSINESS_PUTOUT "+
		    				" where ContractSerialNo = '"+sObjectNo+"' ";
		    		rs = Sqlca.getASResultSet(sSql);
		    		if(rs.next())
		    			iCount = rs.getInt(1);
		    		rs.getStatement().close();
		    			
		    		if(iCount <= 0) //还未出帐
		    		{
		    			if(!sManageUserID.equals(CurUser.UserID)) //其他信贷人员管户
		    			{
		    				sReturnValue = "Other";
		    			}
		    		}else //已出帐
		    		{
		    			sReturnValue = "PutOut";
		    		}
		    	}
	    	}else //已完成放贷
	    	{
	    		sReturnValue = "Pigeonhole";
	    	}
	    }else //已终结
	    {
	    	sReturnValue = "Finish";
	    }
	}else //待补登或完成补登
	{
		sReturnValue = "Reinforce";
	}
	//如果取消成功那么就更新BA表中是否已登记合同标志 added by zrli 
	if(sReturnValue.equals("")){
		sSql =  " update BUSINESS_APPLY set ContractExsitFlag = null where SerialNo = '"+sRelativeSerialNo+"' ";
		Sqlca.executeSQL(sSql);	
	}
%>
<script language=javascript> 

    self.returnValue="<%=sReturnValue%>";
    self.close();
</script>		
<%@ include file="/IncludeEnd.jsp"%>