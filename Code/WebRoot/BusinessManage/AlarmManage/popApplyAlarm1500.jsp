<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-12-24
 * Tester:
 *
 * Content: 
 *        ���״�����Ѻ���
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ���ʽ��ţ�����ʾ�ַ���
 * History Log:
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//�������
	String sResult="";
	String sTip="У��ͨ����";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");			
	ASResultSet rs = null,rs1 = null;
	String sOperateOrgID ="",sCustomerID="",sApplySerialNo="",sSql="",sSql1="",sSql2 ="",sBusinessType="";
	double iNum =0.0;
	//��ò���
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$ģ�ͱ��δָ����";
		else{
		    sCustomerID = altsce.getArgValue("CustomerID");	//�ͻ����
		    sApplySerialNo = altsce.getArgValue("SerialNo");//ҵ��������
		    sBusinessType = altsce.getArgValue("BusinessType");//ҵ��Ʒ��
		    
		    double dBusinessSum=0.0,dGuarantyContractTotalSum =0.0,dGuarantyContractSum=0.0,dGuarantyTotalSum=0.0,dBailSum =0.0,dYCBailSum=0.0;
		    String sGuarantyContractNo = "",sGuarantyType="";
		    sSql ="select NVL(BusinessSum*getERate(BusinessCurrency,'01',ERateDate),0) as BusinessSum, NVL(BailSum*getERate(BusinessCurrency,'01',ERateDate),0) as BailSum from Business_Apply where SerialNo='"+sApplySerialNo+"'";
		    rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	dBusinessSum = rs.getDouble(1);
		    	dBailSum = rs.getDouble(2);
		    }
		    rs.getStatement().close();
		    if(sBusinessType.equals("3010"))//��˾�ۺ������µ����гжһ�Ʊ
		    {
		    	sSql ="select nvl((LineSum1*getERate(Currency,'01',ERateDate)),0)*nvl(BailRatio,0)/100  from CL_INFO  where ApplySerialNo ='"+sApplySerialNo+"' and  ParentLineID is not null and ParentLineID<>'' and BusinessType='2010'";
		    	rs = Sqlca.getASResultSet(sSql);
			    if(rs.next())
			    {
			    	dYCBailSum = rs.getDouble(1);
			    }
			    rs.getStatement().close();
		    }
		    
		    sSql = "select  BR.ObjectNo as GuarantyContractNo from BUSINESS_APPLY BA,APPLY_RELATIVE BR where BA.SerialNo = BR.SerialNo and  BR.ObjectType ='GuarantyContract' and BR.SerialNo='"+sApplySerialNo+"'";
		    rs = Sqlca.getASResultSet(sSql);
		    while(rs.next())
		    {
		    	sGuarantyContractNo = rs.getString("GuarantyContractNo");//������ͬ��
		    	sSql1 = "select NVL(GuarantyValue*getERate(GuarantyCurrency,'01',''),0) as GuarantyContractSum,GuarantyType from GUARANTY_CONTRACT where SerialNo='"+sGuarantyContractNo+"'";
		    	rs1=Sqlca.getASResultSet(sSql1);
		    	if(rs1.next())
		    	{
		    		dGuarantyContractSum = rs1.getDouble("GuarantyContractSum");//������ͬ�ܽ��
		    		sGuarantyType = rs1.getString("GuarantyType");//������ͬ����
		    		System.out.println("dGuarantyContractSum:"+dGuarantyContractSum);
		    		if(sGuarantyType == null) sGuarantyType ="";
		    		if("060".equals(sGuarantyType))
		    		{
		    			sSql2 = " select Sum(NVL(GI.ConfirmValue*getERate(GI.EvalCurrency,'01',''),0)) as GuarantyTotalSum from Guaranty_Info GI,Guaranty_Relative GR "+
		    					" where GR.GuarantyID = GI.GuarantyID and GR.ObjectType='CreditApply' and GR.ContractNo = '"+sGuarantyContractNo+"' ";
		    			dGuarantyTotalSum = Sqlca.getDouble(sSql2).doubleValue();//��Ѻ���ͬ��ѺƷ�ܽ�
		    			if(dGuarantyTotalSum<dGuarantyContractSum){
		    				sbTips.append("��Ѻ����������Ѻ���ܽ��["+DataConvert.toMoney(dGuarantyTotalSum)+"Ԫ]��ӦС����Ѻ��ͬ�����ܽ��["+DataConvert.toMoney(dGuarantyContractSum)+"Ԫ]!"+"\r\n");
		    			}
		    			
		    		}
		    		dGuarantyContractTotalSum = dGuarantyContractTotalSum+dGuarantyContractSum;//�����ܽ��֮��
		    	}
		    	rs1.getStatement().close();
		    }
		    
		    rs.getStatement().close();
		    if(dGuarantyContractTotalSum < (dBusinessSum-dBailSum-dYCBailSum)){
		    	sbTips.append("�����ܽ��["+DataConvert.toMoney(dGuarantyContractTotalSum)+"Ԫ]��ӦС�ڣ�������-��֤��["+DataConvert.toMoney(dBusinessSum-dBailSum-dYCBailSum)+"Ԫ]!"+"\r\n");
		    }
		}
		if( sbTips.length() > 0 )
		{
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
			sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
		}
		//��¼��־
		//���ݷ��ؽ�����жϳɹ���񣬲�����DealMethod�ж��Ƿ���
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
