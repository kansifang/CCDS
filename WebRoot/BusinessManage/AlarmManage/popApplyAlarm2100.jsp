<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * Author: hldu  2012-06-08
 * Tester:
 * Content: 2100���������������Ϣ���         
 * Input Param:
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//�������
	String sSql = "";
    String sSql2 = "";
    String sSql3 = "";
	String sMassage = "" ;
    String sRelativeID = "";  
	String sResult="";
	String sTip="У��ͨ����";
	String sDealMethod="99";
	String sFullName = "";
	String sCustomerName = "";
	String sCount = "";
	ASResultSet rs2 = null;
	ASResultSet rs3 = null;
	ASResultSet rs = null;	
	String sOtherCustomerID = "";
	String sRelativeCustomerName = "";//���ɶ��ͻ�����
	StringBuffer sbTips = new StringBuffer("");		
	//��ò���
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";
	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");
		if( sModelNo.trim().length() == 0 )
			sResult = "10$ģ�ͱ��δָ����";
		else{
			//��ò���
			String sCustomerID = altsce.getArgValue("CustomerID");
			if(sCustomerID==null)sCustomerID="";
			String sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
			if(sCustomerType==null)sCustomerType="";						
			if( sCustomerType.substring(0,2).equals("01") )
            {	
				//��飺�ù�˾�����ɶ���������ҵ�����ɶ�Ϊͬһ��ҵ�����
				//ȡ��CUSTOMER_RELATIVE�е�ǰ�ͻ������ɶ�RelativeID,����
				sSql2 = "select Relativeid,CustomerName from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and InvestmentProp = (select MAX(InvestmentProp) from CUSTOMER_RELATIVE WHERE CustomerID = '"+sCustomerID+"' and RelationShip like '52%'  and length(RelationShip)>2 ) and  RelationShip like '52%'  and length(RelationShip)>2 ";
				rs2 = Sqlca.getResultSet(sSql2);
					
				while(rs2.next())
				{
					//ȡ��CUSTOMER_RELATIVE�����еĲ�������ǰ�ͻ������ɶ���sRelativeID
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
						    sbTips.append("���ÿͻ���������ҵ��һ��ɶ��Ƿ�Ϊͬһ��ҵ����˼�飺\r\n");
						    sbTips.append("�ÿͻ��ɶ���"+sCustomerName+"������ҵ��"+sFullName+"��Ϊ��һ��ɶ���\r\n");
						    sMassage = "0";
					    }
						rs.getStatement().close();	
					}
					rs3.getStatement().close();
				}		
				rs2.getStatement().close();	

				//��飺ʵ�ʿ�����Ϊͬһ��ҵ�����
                sSql =" select CustomerID,getCustomerName(CustomerID) as FullName,CustomerName from Customer_Relative where RelativeID in (select RelativeID from CUSTOMER_RELATIVE where RelationShip = '0109' and CustomerID = '"+sCustomerID+"') and CustomerID <> '"+sCustomerID+"' ";
                rs2 = Sqlca.getResultSet(sSql);
                if(rs2.next())
			    {
                    sFullName = rs2.getString("FullName");
                    sCustomerName = rs2.getString("CustomerName");
                    sbTips.append("��ʵ�ʿ����˼�飺\r\n");
                    sbTips.append("�ÿͻ�ʵ�ʿ����ˡ�"+sCustomerName+"��ҲΪ��"+sFullName+"��ʵ�ʿ����ˣ�\r\n");
                    sMassage = "0";
				}
                rs2.getStatement().close();

                //��飺������ҵ����50%���ϵ���ҵ����˳���20%���ϵĸ���
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
                            sbTips.append("���ɶ���������ҵ���������飺"+"\r\n");
                            sbTips.append("�ÿͻ��ɶ���"+sCustomerName+"������ҵ��"+sFullName+"�����ʳ���50%Ӧ�������ſͻ���"+"\r\n");
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
                            sbTips.append("���ɶ���������ҵ���������飺"+"\r\n");
                            sbTips.append("�ÿͻ��ɶ���"+sCustomerName+"������ҵ��"+sFullName+"�����ʳ���20%Ӧ�������ſͻ���"+"\r\n");
                            sMassage = "0";
                        }	
                        rs2.getStatement().close();
                    }	                 	 
                }
                rs.getStatement().close();
                
                //�����������3�ּ��
                if (sMassage.equals("0"))
                {
                    sCount = Sqlca.getString("select count(CustomerID) from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and RelationShip like '04%'  and length(RelationShip)>2 ");
                    if( sCount == null || Integer.parseInt(sCount) <= 0 )
                    {   
                    	sbTips.append("�����ſͻ�������ϵ��飺"+"\r\n");
                    	sbTips.append("���ڼ��ſͻ�������ϵӦ�������ſͻ���"+"\r\n");
                    }
                }                                     
            }  			
		}
			
		//���ò���
		//altsce.setArgValue("ApplyNo",sObjectNo);		
		//��¼��־
		//���ݷ��ؽ�����жϳɹ���񣬲�����DealMethod�ж��Ƿ���
		if( sbTips.length() > 0 ){
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
			sTip = SpecialTools.real2Amarsoft(sbTips.toString());
		}
		altsce.writeAlarmLog(sModelNo,sTip,sDealMethod,Sqlca);		
		//���÷���ֵ
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
