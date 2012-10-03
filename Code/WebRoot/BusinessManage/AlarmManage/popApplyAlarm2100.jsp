<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * Author: hldu  2012-06-08
 * Tester:
 * Content: 2100－关联集团相关信息检查         
 * Input Param:
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义参数
	String sSql = "";
    String sSql2 = "";
    String sSql3 = "";
	String sMassage = "" ;
    String sRelativeID = "";  
	String sResult="";
	String sTip="校验通过！";
	String sDealMethod="99";
	String sFullName = "";
	String sCustomerName = "";
	String sCount = "";
	ASResultSet rs2 = null;
	ASResultSet rs3 = null;
	ASResultSet rs = null;	
	String sOtherCustomerID = "";
	String sRelativeCustomerName = "";//最大股东客户名称
	StringBuffer sbTips = new StringBuffer("");		
	//获得参数
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";
	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");
		if( sModelNo.trim().length() == 0 )
			sResult = "10$模型编号未指定！";
		else{
			//获得参数
			String sCustomerID = altsce.getArgValue("CustomerID");
			if(sCustomerID==null)sCustomerID="";
			String sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
			if(sCustomerType==null)sCustomerType="";						
			if( sCustomerType.substring(0,2).equals("01") )
            {	
				//检查：该公司的最大股东与其他企业的最大股东为同一企业或个人
				//取得CUSTOMER_RELATIVE中当前客户的最大股东RelativeID,名称
				sSql2 = "select Relativeid,CustomerName from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and InvestmentProp = (select MAX(InvestmentProp) from CUSTOMER_RELATIVE WHERE CustomerID = '"+sCustomerID+"' and RelationShip like '52%'  and length(RelationShip)>2 ) and  RelationShip like '52%'  and length(RelationShip)>2 ";
				rs2 = Sqlca.getResultSet(sSql2);
					
				while(rs2.next())
				{
					//取得CUSTOMER_RELATIVE中所有的不包含当前客户的最大股东是sRelativeID
					sRelativeID = rs2.getString("RelativeID");
					sRelativeCustomerName= rs2.getString("CustomerName");									
					sSql = "select CustomerID from CUSTOMER_RELATIVE where   RelativeID ='"+sRelativeID+"' and  RelationShip like '52%'  and length(RelationShip)>2 and CustomerID <> '"+sCustomerID+"' ";
					rs3=Sqlca.getResultSet(sSql);
					while (rs3.next())
					{   
						sOtherCustomerID=rs3.getString("CustomerID");
						sSql3 = "select getCustomerName(CustomerID) as FullName,CustomerName from CUSTOMER_RELATIVE where relativeid='"+sRelativeID+"' and CustomerID = '"+sOtherCustomerID+"' and InvestmentProp = (select MAX(InvestmentProp) from CUSTOMER_RELATIVE WHERE CustomerID = '"+sOtherCustomerID+"' and RelationShip like '52%'  and length(RelationShip)>2 ) and  RelationShip like '52%'  and length(RelationShip)>2 ";
						rs=Sqlca.getResultSet(sSql3);
						if(rs.next())
						{
							sFullName = rs.getString("FullName");
						    sCustomerName = rs.getString("CustomerName");
						    sbTips.append("！该客户与其他企业第一大股东是否为同一企业或个人检查：\r\n");
						    sbTips.append("该客户股东【"+sCustomerName+"】在企业【"+sFullName+"】为第一大股东；\r\n");
						    sMassage = "0";
					    }
						rs.getStatement().close();	
					}
					rs3.getStatement().close();
				}		
				rs2.getStatement().close();	

				//检查：实际控制人为同一企业或个人
                sSql =" select CustomerID,getCustomerName(CustomerID) as FullName,CustomerName from Customer_Relative where RelativeID in (select RelativeID from CUSTOMER_RELATIVE where RelationShip = '0109' and CustomerID = '"+sCustomerID+"') and CustomerID <> '"+sCustomerID+"' ";
                rs2 = Sqlca.getResultSet(sSql);
                if(rs2.next())
			    {
                    sFullName = rs2.getString("FullName");
                    sCustomerName = rs2.getString("CustomerName");
                    sbTips.append("！实际控制人检查：\r\n");
                    sbTips.append("该客户实际控制人【"+sCustomerName+"】也为【"+sFullName+"】实际控制人；\r\n");
                    sMassage = "0";
				}
                rs2.getStatement().close();

                //检查：其他企业出资50%以上的企业或个人出资20%以上的个人
                sSql = "select CustomerType from CUSTOMER_INFO Where CustomerID in (select RelativeID from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelationShip like '52%'  and length(RelationShip)>2)";
                sSql2 ="select CustomerID,getCustomerName(CustomerID) as FullName,CustomerName from Customer_Relative where RelativeID in  (select RelativeID from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelationShip like '52%'  and length(RelationShip)>2) and CustomerID <> '"+sCustomerID+"' " ;
                rs = Sqlca.getResultSet(sSql);
                if(rs.next())
                {
                    sCustomerType = rs.getString("CustomerType");
                    	 
                    if(sCustomerType.substring(0,2).equals("01"))
                    {
                    	sSql2 += " and InvestmentProp >= 50" ; 
                    	rs2 = Sqlca.getResultSet(sSql2);
                        if(rs2.next())
                        {
                        	sFullName = rs2.getString("FullName");
                            sCustomerName = rs2.getString("CustomerName");
                            sbTips.append("！股东在其他企业出资情况检查："+"\r\n");
                            sbTips.append("该客户股东【"+sCustomerName+"】在企业【"+sFullName+"】出资超过50%应关联集团客户；"+"\r\n");
                            sMassage = "0";
                        }
                        rs2.getStatement().close();
                    }
                    else if (sCustomerType.substring(0,2).equals("03") )
                    {
                    	sSql2 += " and InvestmentProp >= 20 " ;
                    	rs2 = Sqlca.getResultSet(sSql2);
                        if(rs2.next())
                        {
                        	sFullName = rs2.getString("FullName");
                            sCustomerName = rs2.getString("CustomerName");
                            sbTips.append("！股东在其他企业出资情况检查："+"\r\n");
                            sbTips.append("该客户股东【"+sCustomerName+"】在企业【"+sFullName+"】出资超过20%应关联集团客户；"+"\r\n");
                            sMassage = "0";
                        }	
                        rs2.getStatement().close();
                    }	                 	 
                }
                rs.getStatement().close();
                
                //如果存在以上3种检查
                if (sMassage.equals("0"))
                {
                    sCount = Sqlca.getString("select count(CustomerID) from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and RelationShip like '04%'  and length(RelationShip)>2 ");
                    if( sCount == null || Integer.parseInt(sCount) <= 0 )
                    {   
                    	sbTips.append("！集团客户关联关系检查："+"\r\n");
                    	sbTips.append("存在集团客户关联关系应关联集团客户；"+"\r\n");
                    }
                }                                     
            }  			
		}
			
		//设置参数
		//altsce.setArgValue("ApplyNo",sObjectNo);		
		//记录日志
		//根据返回结果，判断成功与否，并根据DealMethod判断是否处理
		if( sbTips.length() > 0 ){
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
			sTip = SpecialTools.real2Amarsoft(sbTips.toString());
		}
		altsce.writeAlarmLog(sModelNo,sTip,sDealMethod,Sqlca);		
		//设置返回值
		sResult = sDealMethod+"$"+sTip;		
	}catch(Exception ea){
		ea.printStackTrace();
		sResult="10$"+ea.getMessage();
	}
%>
<html>
<head>
</head>
<body onkeydown=mykd1 >
	<iframe name="myprint10" width=0% height=0% style="display:none" frameborder=1></iframe>
</body>
</html>

<script language=javascript >
	self.returnValue = "<%=sResult%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
