<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="javax.servlet.jsp.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="javax.servlet.*" %>
<%@page import="com.amarsoft.*" %>
<%@page import="java.*" %>


<%
	//��ȡҳ�����
		String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
		String sObjectNo= DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
		String sCurFlowNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("FlowNo"));
		String sCurPhaseNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseNo"));
		String sBusinessType= DataConvert.toRealString(iPostChange,CurPage.getParameter("BusinessType"));
		String sPhaseType = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseType"));
		String sDrawingType = DataConvert.toRealString(iPostChange,CurPage.getParameter("DrawingType"));
		ASResultSet rs = null;
		String sManageDepartFlag="",sVouchTypeName="";
		String BarCode = "",ObjectTypeNo = "";//������ͽ׶α��
		String ApplySerialno = sObjectNo , sApproveRelativeSerialNO = "" ;//������ˮ�� \������ˮ��
		if("BusinessApplyList".equals(sPhaseType)){
	rs = Sqlca.getASResultSet("Select ManageDepartFlag,BusinessType from Business_Apply where serialno='"+sObjectNo+"' ");
	if(rs.next()){
		 sBusinessType = rs.getString("BusinessType");
		 sManageDepartFlag = rs.getString("ManageDepartFlag"); 
	 }
		}else if("BusinessPutOutList".equals(sPhaseType)){
	rs = Sqlca.getASResultSet("Select bc.RelativeSerialNO,bc.ManageDepartFlag,bc.BusinessType, bc.DrawingType from Business_Putout bp,business_contract bc where bp.Serialno='"+sObjectNo+"' and bp.contractserialno=bc.serialno ");
	if(rs.next()){
		sBusinessType = rs.getString("BusinessType");
		sManageDepartFlag = rs.getString("ManageDepartFlag");
		sApproveRelativeSerialNO = rs.getString("RelativeSerialNO");
		//sDrawingType = rs.getString("DrawingType");
	}
	ApplySerialno = Sqlca.getString("SELECT RelativeSerialNO FROM BUSINESS_APPROVE WHERE SERIALNO ='"+sApproveRelativeSerialNO+"'");  
		}
		rs.getStatement().close();
		if(sDrawingType == null) sDrawingType = "01";
		//����ֵת��Ϊ���ַ���
		if(sObjectType==null)sObjectType="";
		if(sObjectNo==null)sObjectNo="";
		if(sCurFlowNo==null)sCurFlowNo="";
		if(sCurPhaseNo==null)sCurPhaseNo="";
		
		String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
		boolean bRolePrivilege = false; //��Щ�׶��ܿ�
		boolean bPhasePrivilege = false;//
		boolean bPhaseMatch = false;//�жϵ�ǰ��������׶��Ƿ��ڶ�Ӧ����Ȩ�׶�
		
		//����2λС��
		NumberFormat nf = NumberFormat.getInstance();
		nf.setMinimumFractionDigits(2);
		nf.setMaximumFractionDigits(2);
		
		String sFlowNo = "";
		String sPhaseNo = "";
		String sSelfOpinionPhase = "";
		String sSelfOpinion = "";
		String sPhaseName = "";
		String sUserName = "";
		String sOrgName = "";
		String sBeginTime = "";
		String sEndTime = "";
		String data[]=new String[3];
		String time[]=new String[2];
		String sCustomerName = "",sCustomerID="", sBusinessTypeName = "";
		String sRateFloatTypeName = "";
		double dBusinessSum = 0.0;
		double dBaseRate = 0.0;
		double dRateFloat = 0.0;
		double dBusinessRate = 0.0;
		double dBailSum = 0.0;
		double dBailRatio = 0.0;
		double dPromisesFeeRatio = 0.0;
		double dPromisesFeeSum = 0.0;
		double dPdgRatio = 0.0;
		double dPdgSum = 0.0;
		int iTermYear = 0;
		int iTermMonth = 0;
		int iTermDay = 0;
		int iCountRecord=0;//�����жϼ�¼�Ƿ����������
		double dInsum=0.0;//
		
		String sBusinesssum2="";
		int[] starttime=new int[3];
		int[] endtime=new int[3];
		String sVouchTypename="";
		String sPurpose="";
		
		String sBusinesssum="";
		String sInputdate="";
		StringBuffer sTemp = new StringBuffer();
	if(sBusinessType.startsWith("3")&&"BusinessApplyList".equals(sPhaseType)){
		rs=Sqlca.getResultSet(" select customername,CustomerID,getbusinessname(businesstype) as businessname,businesssum, getorgname(inputorgid)"+
					  " as orgname,inputdate from Business_Approve where RelativeSerialno='"+sObjectNo+"'");
		 if(rs.next()){
	 sCustomerName=rs.getString("customername");
	 sCustomerID = rs.getString("CustomerID");
	 if(sCustomerName==null)sCustomerName="&nbsp;";
	 sBusinessTypeName=rs.getString("businessname");
	 if(sBusinessTypeName==null)sBusinessTypeName="&nbsp;";
	 sBusinesssum=nf.format(rs.getDouble("businesssum")/10000);
	 if(sBusinesssum==null)sBusinesssum="&nbsp;";
	 else sBusinesssum=sBusinesssum+"&nbsp;��Ԫ";
	 sOrgName=rs.getString("orgname");
	 if(sOrgName==null)sOrgName="&nbsp;";
	 sInputdate=rs.getString("inputdate");
	 if(sInputdate==null){sInputdate="&nbsp";}
	 else {
		   data=sInputdate.split("/");
		   data[0]=data[0]+"��";
		   data[1]=data[1]+"��";
		   data[2]=data[2]+"��";
	 }
		
	
	  
		sTemp.append("<div   align=center><font style='font-size: 24px; FONT-WEIGHT: bold'>�Ŵ�ҵ��������������</font></div>");
		sTemp.append("<table width='640' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'> ");
		sTemp.append("<tr >  ");
		sTemp.append("<td  ><font style='font-size: 14px; '> ");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;��&nbsp;��&nbsp;�ƣ�&nbsp;"+sCustomerName+"<br/>");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ҵ&nbsp;��&nbsp;��&nbsp;�ࣺ&nbsp;"+sBusinessTypeName+"<br/>  ");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�&nbsp;"+sBusinesssum+"<br/> "); 
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;��&nbsp;��&nbsp;λ��&nbsp;"+sOrgName+"<br/>  ");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;��&nbsp;��&nbsp;�ڣ�&nbsp;"+data[0]+data[1]+data[2]+"<br/></td></font> "); 
		sTemp.append("</tr>  ");
		sTemp.append("</table>  ");

		 
		 }
	}else if("001001".equals(sManageDepartFlag)&&"BusinessApplyList".equals(sPhaseType)){
		rs=Sqlca.getASResultSet(" select  bap.CustomerName,bap.CustomerID,bap.BusinessSum as BusinessSum1,getBusinessName(bap.BusinessType) as BusinessName,"+
		                " getOrgName(bap.inputorgid) as OrgName ,getItemName('VouchType',bap.VouchType) as VouchTypeName,bc.businesssum as"+
		                " businesssum2 ,gc.GuarantorName  from Business_Approve bap left join business_contract bc on bap.creditaggreement=bc.serialno "+
		                " ,apply_relative ar,guaranty_contract gc where bap.Relativeserialno=ar.serialno and objecttype='GuarantyContract' and ar.objectno=gc.serialno  "+
		                "  and bap.Relativeserialno='"+sObjectNo+"'");
		if(rs.next()){
	sCustomerName=rs.getString("CustomerName");
	sCustomerID = rs.getString("CustomerID");
	if(sCustomerName==null)sCustomerName="&nbsp;";
	
	 sBusinessTypeName=rs.getString("BusinessName");
	 if(sBusinessTypeName==null)sBusinessTypeName="&nbsp;";	 
	 sBusinesssum=DataConvert.toMoney(rs.getString("BusinessSum1"));
	 sBusinesssum2=DataConvert.toMoney(rs.getString("BusinessSum2"));
	 if(sBusinesssum2==null) sBusinesssum2 ="&nbsp;&nbsp;&nbsp;&nbsp;";
	 sOrgName=rs.getString("OrgName");
	 if(sOrgName==null)sOrgName="&nbsp;";
	 
	sVouchTypename=rs.getString("VouchTypeName");
	if(sVouchTypename==null)sVouchTypename="&nbsp;";
	
	String GuarantorName=rs.getString("GuarantorName");
	if(GuarantorName==null)GuarantorName="&nbsp;";
		
	sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>�������������</p></font> </div>");
	sTemp.append("<table width='640' style='font-size: 14px;' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' >����������</td>");
	sTemp.append("<td class='black' colspan=3>&nbsp;"+sCustomerName+" </td>");
	sTemp.append("<td class='black'>�������</td>");
	sTemp.append("<td class='black' >&nbsp;"+sOrgName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black'>�ۺ����Ŷ��</td>");
	sTemp.append("<td class='black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sBusinesssum2+" </td>");
	sTemp.append("<td class='black'>��ʹ�ö��</td>");
	sTemp.append("<td class='black'>&nbsp; </td>");
	sTemp.append("<td class='black'>ʣ����</td>");
	sTemp.append("<td class='black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black'  colspan=2>�����������Ž��</td>");
	sTemp.append("<td class='black'>&nbsp;"+sBusinesssum+" </td>");
	sTemp.append("<td class='black' colspan=2>��������Ʒ��</td>");
	sTemp.append("<td class='black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sBusinessTypeName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black'>������ʽ</td>");
	sTemp.append("<td class='black'  colspan=2>&nbsp; "+sVouchTypename+"</td>");
	sTemp.append("<td class='black'>������</td>");
	sTemp.append("<td class='black'  colspan=2>&nbsp;"+GuarantorName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");
		}

	}else if("001002".equals(sManageDepartFlag)&&"BusinessApplyList".equals(sPhaseType)){
		String sBaseRate = "";//��׼������
		String sBusinessRate = "";//ִ��������
		String sTermMonth = "";//����
		rs = Sqlca.getASResultSet(" select CustomerName,CustomerID,getOrgName(InputOrgID) as OrgName,"+
						  " getBusinessName(BusinessType) as BusinessTypeName,BusinessSum,TermMonth,"+
						  " getItemName('VouchType',VouchType) as VouchTypeName,InputDate,Purpose,BaseRate,BusinessRate,"+
						  " TermMonth from BUSINESS_Approve where RelativeSerialNo='"+sObjectNo+"'");
		if(rs.next()){
	sCustomerName=rs.getString("CustomerName");
	sCustomerID = rs.getString("CustomerID");
	if(sCustomerName==null)sCustomerName="&nbsp;";
	
	 sBusinessTypeName=rs.getString("BusinessTypeName");
	 if(sBusinessTypeName==null)sBusinessTypeName="&nbsp;";	 
	 sBusinesssum=DataConvert.toMoney(rs.getString("BusinessSum"));
	 if(sBusinesssum==null) sBusinesssum ="&nbsp;&nbsp;&nbsp;&nbsp;";
	 sOrgName=rs.getString("OrgName");
	 if(sOrgName==null)sOrgName="&nbsp;";
	  sBaseRate=rs.getString("BaseRate");
	 if(sBaseRate==null)sBaseRate="&nbsp;";
	  sBusinessRate=rs.getString("BusinessRate");
	 if(sBusinessRate==null)sBusinessRate="&nbsp;";
	 sTermMonth = rs.getString("TermMonth");
	 if(sTermMonth==null)sTermMonth="&nbsp;";
	sVouchTypename=rs.getString("VouchTypeName");
	if(sVouchTypename==null)sVouchTypename="&nbsp;";
		 
	sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>С��ҵ���������</p></font><br>");
	sTemp.append("���첿�ţ�&nbsp;"+sOrgName+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��λ�������Ԫ");
	sTemp.append("</div>");
	sTemp.append("<table width='640' style='font-size: 14px;' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' colspan = 6>�ͻ�ȫ�ƣ�");
	sTemp.append("&nbsp;"+sCustomerName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=center  class='black' colspan = 6><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black ' >������ſ�</font></td>");//<br>�����<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black'  align=center>ҵ��Ʒ��</td>");
	sTemp.append("<td class='black'  align=center>������� </td>");
	sTemp.append("<td class='black'  align=center>������ʽ </td>");
	sTemp.append("<td class='black'    align=center>���ޣ��£� </td>");
	sTemp.append("<td class='black'  align=center>����</td>");
	sTemp.append("<td class='black'  align=center>�������� </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' align=center>"+sBusinessTypeName+"&nbsp;</td>");
	sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBusinesssum)+"&nbsp; </td>");
	sTemp.append("<td class='black' align=center>"+sVouchTypename+"&nbsp;</td>");
	sTemp.append("<td class='black' align=center>"+sTermMonth+"&nbsp; </td>");
	sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBaseRate)+"&nbsp; </td>");
	sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBusinessRate)+"%&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");
		}

	}else if(("001004".equals(sManageDepartFlag) || "001003".equals(sManageDepartFlag))&&"BusinessApplyList".equals(sPhaseType)){
		String sTermMonth = "";//����
		rs = Sqlca.getASResultSet(" select CustomerName,CustomerID,getOrgName(InputOrgID) as OrgName,getBusinessName(BusinessType) as BusinessTypeName,"+
						  " BusinessSum,TermMonth,getItemName('VouchType',VouchType) as VouchTypeName,InputDate,Purpose,"+
						  " TermMonth from BUSINESS_Approve where RelativeSerialNo='"+sObjectNo+"'");
		if(rs.next())
		{			
	sCustomerName=rs.getString("CustomerName");
	if(sCustomerName==null)sCustomerName="&nbsp;";
	
	sCustomerID = rs.getString("CustomerID");
	sBusinesssum=nf.format(rs.getDouble("BusinessSum"));
	sOrgName = rs.getString("OrgName");
	iTermMonth=rs.getInt("TermMonth");
	sVouchTypename=rs.getString("VouchTypeName");
	if(sVouchTypename==null)sVouchTypename="&nbsp;";
	sTermMonth = rs.getString("TermMonth");
	if(sTermMonth==null)sTermMonth="&nbsp;";
	sBusinessTypeName=rs.getString("BusinessTypeName");
	if(sBusinessTypeName==null)sBusinessTypeName="&nbsp;";	 
	sBeginTime=rs.getString("InputDate");
	if(sBeginTime==null){sBeginTime="&nbsp;";}
	else{
		String data1[]=new String[3];
		data1=sBeginTime.split("/");
		starttime[0]=Integer.parseInt(data1[0]);
		starttime[1]=Integer.parseInt(data1[1]);
		starttime[2]=Integer.parseInt(data1[2]);
		
		int month=starttime[1]+iTermMonth;
		if(month<12){
			endtime[0]=starttime[0];
			endtime[1]=month;
			endtime[2]=starttime[2];				
		}else if(month==12){
			endtime[0]=starttime[0]+1;
			endtime[1]=1;
			endtime[2]=starttime[2];
		}else if(month>12){
			if(month%12==0){
				endtime[0]=starttime[0]+Integer.parseInt((month/12)+"");
				endtime[1]=1;
				endtime[2]=starttime[2];
			}else{
				endtime[0]=starttime[0]+Integer.parseInt((month/12)+"");
				endtime[1]=Integer.parseInt((month%12)+"");
				endtime[2]=starttime[2];
			}
		}
	}
	sPurpose=rs.getString("Purpose");
	if(sPurpose==null)sPurpose="&nbsp;";
	
	if("001004".equals(sManageDepartFlag)){
		sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>���˴������������</p></font> </div>");
	}else{
		sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>΢С�������������</p></font> </div>");
	}
	
	 
	
	sTemp.append("<table width='640' style='font-size: 14px;' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=center colspan = 4 class='black' ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black ' >��     ��     ��     ��     ��     ��</font></td>");//<br>�����<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' colspan = 1>����� </td>");
	sTemp.append("<td class='black' colspan = 3>&nbsp;"+sCustomerName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' >������ </td>");
	sTemp.append("<td class='black' >&nbsp;"+sBusinesssum+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ԫ </td>");
	sTemp.append("<td class='black' >�������� </td>");
	sTemp.append("<td class='black' >&nbsp;"+sTermMonth+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' >ҵ��Ʒ��</td>");
	sTemp.append("<td class='black' >&nbsp;"+sBusinessTypeName+" </td>");
	sTemp.append("<td class='black' >������ʽ</td>");
	sTemp.append("<td class='black' >&nbsp;"+sVouchTypename+" </td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");
		}
	}else 	if( "BusinessPutOutList".equals(sPhaseType)&&sDrawingType.equals("01")){//��ӡ�ſ���Ϣ add by jlwang 20130624
	 	System.out.println("BusinessPutOutList".equals(sPhaseType)&&sDrawingType.equals("01"));
		String sBaseRate = "";//��׼������
		String sBusinessRate = "";//ִ��������
		double dInUseSum = 0;//δ����
		double dContractSum = 0;//�Ѻ�׼��
		double dPromisesfeeSum = 0;//��ŵ�ѽ��
		double dPDGSum = 0;//�����ѽ��
		double dPDGRatio = 0;//��������
		rs = Sqlca.getASResultSet("select bp.CustomerName,bp.CustomerID,getOrgName(bp.InputOrgID) as OrgName,getBusinessName(bp.BusinessType) as BusinessTypeName,"
				+"bp.BusinessSum,bp.BaseRate,bp.BusinessRate,bp.BusinessSum,bp.PutOutDate,bp.Maturity,bp.ContractSum/10000 as ContractSum,"
				+"bp.PromisesfeeSum,bp.PDGSum,bp.PDGRatio,bp.BailSum,bp.BailRatio,"
				+"getItemName('VouchType',bc.VouchType) as VouchTypeName"
				+" from BUSINESS_PUTOUT bp,business_contract bc where bp.SerialNo='"+sObjectNo+"'"
				+" and bc.serialno=bp.contractserialno ");
		if(rs.next())
		{
			sCustomerName = rs.getString("CustomerName");
			if(sCustomerName == null) sCustomerName = " ";
			
			sCustomerID = rs.getString("CustomerID");
			
			sOrgName = rs.getString("OrgName");
			if(sOrgName == null) sOrgName = " ";
			
			sBusinessTypeName = rs.getString("BusinessTypeName");
			if(sBusinessTypeName == null) sBusinessTypeName = " ";
			
			dContractSum = rs.getDouble("ContractSum");
			dBusinessSum = rs.getDouble("BusinessSum")/10000;
			dBusinessSum = rs.getDouble("BusinessSum")/10000;
			dBailRatio = rs.getDouble("BailRatio")/100;
			dBailSum = dBailRatio*dBusinessSum;		
			dPromisesfeeSum = rs.getDouble("PromisesfeeSum");
			dPDGRatio = rs.getDouble("PDGRatio")*0.1;
			dPDGSum = dPDGRatio*dBusinessSum; 
			
			sBaseRate=rs.getString("BaseRate");
			if(sBaseRate.equals("0.000000") || sBaseRate == null) sBaseRate = Double.toString(dBailSum/dBusinessSum);
			sBusinessRate=rs.getString("BusinessRate");
			if(sBusinessRate.equals("0.000000") || sBusinessRate == null) sBusinessRate = Double.toString((dPromisesfeeSum+dPDGSum)/dBusinessSum);
			
			sBeginTime=rs.getString("PutOutDate");
			if(sBeginTime==null)sBeginTime=" ";
			 
			sEndTime=rs.getString("Maturity");
			if(sEndTime==null)sEndTime="&nbsp;";
			sVouchTypeName = rs.getString("VouchTypeName");
			if(sVouchTypeName==null) sVouchTypeName="&nbsp;";
			
			sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>�Ŵ�ҵ��ſ��׼������</font> ��ţ�<br/><br/>");
			sTemp.append("����������£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��λ���������Ԫ");
			sTemp.append("</div>");
			sTemp.append("<table width='640' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
			sTemp.append("<tr> <td class='black'  colspan=7>�ͻ�ȫ�ƣ�&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;&nbsp;</td></tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class='black' rowspan=2 align=center>ҵ��Ʒ��</td>");
			sTemp.append("<td class='black' rowspan=2 align=center>�����Ŷ�/���κ�׼�� </td>");
			sTemp.append("<td class='black' rowspan=2 align=center>������ʽ </td>");
			sTemp.append("<td class='black'  colspan=2  align=center>���� </td>");
			sTemp.append("<td class='black' rowspan=2 align=center>��׼������(��֤��%)</td>");
			sTemp.append("<td class='black' rowspan=2 align=center>ִ��������(������+��ŵ��%) </td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class='black' align=center>��ʼ��</td>");
			sTemp.append("<td class='black' align=center>������ </td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class='black' align=center>"+sBusinessTypeName+"&nbsp;</td>");
			sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(dContractSum)+"/"+DataConvert.toMoney(dBusinessSum)+"&nbsp; </td>");
			sTemp.append("<td class='black' align=center>"+sVouchTypeName+"&nbsp;</td>");
			sTemp.append("<td class='black' align=center>"+sBeginTime+"&nbsp; </td>");
			sTemp.append("<td class='black' align=center>"+sEndTime+"&nbsp;</td>");
			sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBaseRate)+"&nbsp; </td>");
			sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBusinessRate)+"&nbsp;</td>");
			sTemp.append("</tr>");
			
			}
		String scondition1 = "";
		String scondition2 = "";
		String scondition3 = "";
		String scondition4 = "";
		String scondition5 = "";
		String scondition6 = "";
		
		String sworkable1 = "";
		String sworkable2 = "";
		String sworkable3 = "";
		String sworkable4 = "";
		String sworkable5 = "";
		String sworkable6 = "";
		rs = Sqlca.getASResultSet("SELECT condition1,workable1,"
								 +"condition2,workable2,"
								 +"condition3,workable3,"
								 +"condition4,workable4,"
								 +"condition5,workable5,"
								 +"condition6,workable6"
								 +" FROM flow_task ft,flow_opinion fo where ft.serialno=fo.serialno and ft.objectno='"
								 +sObjectNo
								 +"' and ft.flowno='PutOutFlow'");
		if(rs.next()){
			scondition1 = rs.getString("condition1");
			if(scondition1 == null) scondition1 = " ";
			scondition2 = rs.getString("condition2");
			if(scondition2 == null) scondition2 = " ";
			scondition3 = rs.getString("condition3");
			if(scondition3 == null) scondition3 = " ";
			scondition4 = rs.getString("condition4");
			if(scondition4 == null) scondition4 = " ";
			scondition5 = rs.getString("condition5");
			if(scondition5 == null) scondition5 = " ";
			scondition6 = rs.getString("condition6");
			if(scondition6 == null) scondition6 = " ";
			
			sworkable1 = rs.getString("workable1");
			if(sworkable1 != null){
				if(sworkable1.equals("1")){ sworkable1 = "��";
				}else if(sworkable1.equals("2")){ sworkable1 = "��";
				}else { sworkable1 = " ";}
			}else { sworkable1 = " ";}
			
			sworkable2 = rs.getString("workable2");
			if(sworkable2 != null){
				if(sworkable2.equals("1")){ sworkable2 = "��";
				}else if(sworkable2.equals("2")){ sworkable2 = "��";
				}else { sworkable2 = " ";}
			}else { sworkable2 = " ";}
				
			sworkable3 = rs.getString("workable3");
			if(sworkable3 != null){
				if(sworkable3.equals("1")){ sworkable3 = "��";
				}else if(sworkable3.equals("2")){ sworkable3 = "��";
				}else { sworkable3 = " ";}
			}else { sworkable3= " ";}
				
			sworkable4 = rs.getString("workable4");
			if(sworkable4 != null){
				if(sworkable4.equals("1")){ sworkable4 = "��";
				}else if(sworkable4.equals("2")){ sworkable4 = "��";
				}else { sworkable4 = " ";}
			}else { sworkable4 = " ";}
				
			sworkable5 = rs.getString("workable5");
			if(sworkable5 != null){
				if(sworkable5.equals("1")){ sworkable5 = "��";
				}else if(sworkable5.equals("2")){ sworkable5 = "��";
				}else { sworkable5 = " ";}
			}else { sworkable5 = " ";}
				
			sworkable6 = rs.getString("workable6");
			if(sworkable6 != null){
				if(sworkable6.equals("1")){ sworkable6 = "��";
				}else if(sworkable6.equals("2")){ sworkable6 = "��";
				}else { sworkable6 = " ";}
			}else { sworkable6 = " ";}
		
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=center colspan=4>�������</td>");
			sTemp.append("<td class=td1 align=center colspan=3>��ʵ���</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition1 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable1 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition2 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable2 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition3 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable3 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition4 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable4 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition5 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable5 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition6 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable6 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("</table>");
			}
		} else if("BusinessPutOutList".equals(sPhaseType)&&sDrawingType.equals("02")){
			String sBaseRate = "";//��׼������
			String sBusinessRate = "";//ִ��������
			double dInUseSum = 0;//δ����
			double dContractSum = 0;//�Ѻ�׼��
			double dPromisesfeeSum = 0;//��ŵ�ѽ��
			double dPDGSum = 0;//�����ѽ��
			double dPDGRatio = 0;//��������
			rs = Sqlca.getASResultSet("select CustomerName,CustomerID,getOrgName(InputOrgID) as OrgName,getBusinessName(BusinessType) as BusinessTypeName,"
					+"GETUSDSUM(ContractSerialNo) as InUseSum,BaseRate,BusinessRate,BusinessSum,PutOutDate,Maturity,ContractSum/10000 as ContractSum,"
					+"PromisesfeeSum,PDGSum,PDGRatio,BailSum,BailRatio"
					+" from BUSINESS_PUTOUT where SerialNo='"+sObjectNo+"'");
			if(rs.next())
			{
				sCustomerName = rs.getString("CustomerName");
				if(sCustomerName == null) sCustomerName = " ";
				sCustomerID = rs.getString("CustomerID");
				sOrgName = rs.getString("OrgName");
				if(sOrgName == null) sOrgName = " ";
				
				sBusinessTypeName = rs.getString("BusinessTypeName");
				if(sBusinessTypeName == null) sBusinessTypeName = " ";
				
				dContractSum = rs.getDouble("ContractSum");
				dInUseSum = rs.getDouble("InUseSum")/10000;
				dBusinessSum = rs.getDouble("BusinessSum")/10000;
				dBailRatio = rs.getDouble("BailRatio")/100;
				dBailSum = dBailRatio*dBusinessSum;		
				dPromisesfeeSum = rs.getDouble("PromisesfeeSum");
				dPDGRatio = rs.getDouble("PDGRatio")*0.1;
				dPDGSum = dPDGRatio*dBusinessSum; 
				System.out.println(dBusinessSum);
				sBaseRate=rs.getString("BaseRate");
				if(sBaseRate.equals("0.000000") || sBaseRate == null) sBaseRate = Double.toString(dBailSum/dBusinessSum);
				sBusinessRate=rs.getString("BusinessRate");
				if(sBusinessRate.equals("0.000000") || sBusinessRate == null) sBusinessRate = Double.toString((dPromisesfeeSum+dPDGSum)/dBusinessSum);
				
				sBeginTime=rs.getString("PutOutDate");
				if(sBeginTime==null)sBeginTime=" ";
				 
				sEndTime=rs.getString("Maturity");
				if(sEndTime==null)sEndTime="&nbsp;";

		
				sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>���������</font> ��ţ�<br/><br/>");
				sTemp.append("����������£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��λ���������Ԫ");
				sTemp.append("</div>");
				sTemp.append("<table width='640' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
				sTemp.append("<tr> <td class='black'  colspan=7>�ͻ�ȫ�ƣ�&nbsp;&nbsp;"+sCustomerName +"&nbsp;&nbsp;&nbsp;</td></tr>");
				sTemp.append("<tr>");
				sTemp.append("<td class='black' rowspan=2 align=center>ҵ��Ʒ��</td>");
				sTemp.append("<td class='black' rowspan=2 align=center>�Ѻ�׼��/δ���� </td>");
				sTemp.append("<td class='black' rowspan=2 align=center>�������� </td>");
				sTemp.append("<td class='black'  colspan=2  align=center>���� </td>");
				sTemp.append("<td class='black' rowspan=2 align=center>��׼������(��֤��%)</td>");
				sTemp.append("<td class='black' rowspan=2 align=center>ִ��������(������+��ŵ��%) </td>");
				sTemp.append("</tr>");
				sTemp.append("<tr>");
				sTemp.append("<td class='black' align=center>��ʼ��</td>");
				sTemp.append("<td class='black' align=center>������ </td>");
				sTemp.append("</tr>");
				sTemp.append("<tr>");
				sTemp.append("<td class='black' align=center>"+sBusinessTypeName +"&nbsp;</td>");
				sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(dContractSum) +"/"+dInUseSum +"&nbsp; </td>");
				sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(dBusinessSum) +"&nbsp;</td>");
				sTemp.append("<td class='black' align=center>"+sBeginTime +"&nbsp; </td>");
				sTemp.append("<td class='black' align=center>"+sEndTime +"&nbsp;</td>");
				sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBaseRate) +"&nbsp; </td>");
				sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBusinessRate)+"&nbsp;</td>");
				sTemp.append("</tr>");
				
		String scondition1 = "";
		String scondition2 = "";
		String scondition3 = "";
		String scondition4 = "";
		String scondition5 = "";
		String scondition6 = "";
		
		String sworkable1 = "";
		String sworkable2 = "";
		String sworkable3 = "";
		String sworkable4 = "";
		String sworkable5 = "";
		String sworkable6 = "";
		
		String sphaseno = "";
		rs = Sqlca.getASResultSet("SELECT condition1,workable1,"
								 +"condition2,workable2,"
								 +"condition3,workable3,"
								 +"condition4,workable4,"
								 +"condition5,workable5,"
								 +"condition6,workable6 "
								 +" FROM flow_task ft,flow_opinion fo where ft.serialno=fo.serialno and ft.objectno='"
								 +sObjectNo
								 +"' and ft.flowno='PutOutFlow'");
		if(rs.next()){
			scondition1 = rs.getString("condition1");
			if(scondition1 == null) scondition1 = " ";
			scondition2 = rs.getString("condition2");
			if(scondition2 == null) scondition2 = " ";
			scondition3 = rs.getString("condition3");
			if(scondition3 == null) scondition3 = " ";
			scondition4 = rs.getString("condition4");
			if(scondition4 == null) scondition4 = " ";
			scondition5 = rs.getString("condition5");
			if(scondition5 == null) scondition5 = " ";
			scondition6 = rs.getString("condition6");
			if(scondition6 == null) scondition6 = " ";
			
			sworkable1 = rs.getString("workable1");
			if(sworkable1 != null){
				if(sworkable1.equals("1")){ sworkable1 = "��";
				}else if(sworkable1.equals("2")){ sworkable1 = "��";
				}else { sworkable1 = " ";}
			}else { sworkable1 = " ";}
			
			sworkable2 = rs.getString("workable2");
			if(sworkable2 != null){
				if(sworkable2.equals("1")){ sworkable2 = "��";
				}else if(sworkable2.equals("2")){ sworkable2 = "��";
				}else { sworkable2 = " ";}
			}else { sworkable2 = " ";}
				
			sworkable3 = rs.getString("workable3");
			if(sworkable3 != null){
				if(sworkable3.equals("1")){ sworkable3 = "��";
				}else if(sworkable3.equals("2")){ sworkable3 = "��";
				}else { sworkable3 = " ";}
			}else { sworkable3= " ";}
				
			sworkable4 = rs.getString("workable4");
			if(sworkable4 != null){
				if(sworkable4.equals("1")){ sworkable4 = "��";
				}else if(sworkable4.equals("2")){ sworkable4 = "��";
				}else { sworkable4 = " ";}
			}else { sworkable4 = " ";}
				
			sworkable5 = rs.getString("workable5");
			if(sworkable5 != null){
				if(sworkable5.equals("1")){ sworkable5 = "��";
				}else if(sworkable5.equals("2")){ sworkable5 = "��";
				}else { sworkable5 = " ";}
			}else { sworkable5 = " ";}
				
			sworkable6 = rs.getString("workable6");
			if(sworkable6 != null){
				if(sworkable6.equals("1")){ sworkable6 = "��";
				}else if(sworkable6.equals("2")){ sworkable6 = "��";
				}else { sworkable6 = " ";}
			}else { sworkable6 = " ";}
			
	
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=center colspan=5>�������</td>");
			sTemp.append("<td class=td1 align=center colspan=2>��ʵ���</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition1 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable1 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition2 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable2 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition3 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable3 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition4 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable4 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition5 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable5 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition6 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable6 +"&nbsp;</td>");
			sTemp.append("</tr>");
			}
			sTemp.append("</table>");

	}
	}
	
	rs.getStatement().close();
	 

	//������Ա��������� FLOW_OPINION �� ,�����Ҫ��ʾһЩ���������Ҫ�޸�ǩ����������������
	//FLOW_MODEL��ӵĶ�������鿴Ȩ�޵��жϣ�ͨ�� Attribute2,
	String str =" ";
	String  sum =Sqlca.getString("Select count(*) from flow_task F  where ObjectNo='"+sObjectNo+"'  and ObjectType='"+sObjectType+"' and phaseno='3000'");
	if(Integer.parseInt(sum)>0){
		str =" having phaseNo<>'3000'";
	}
	sSql =	"select FO.SerialNo,FO.objectNo,FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName,  "+
	       " FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate,"+
	       " FT.FlowNo,FT.PhaseNo,FT.PhaseName,"+
	       " FT.UserName,FT.OrgName,FT.PhaseAction,  FT.BeginTime,FT.EndTime,FT.PhaseChoice,FO.PhaseOpinion ,"+
	       " FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3"+
	       " from (select max(serialno) as serialno,phaseno from flow_task F  where ObjectNo='"+sObjectNo+"'  and ObjectType='"+sObjectType+"' and phasename not like '%�ַ�%' group by phaseno "+str+") tab1 left join "+
	       " FLOW_TASK FT  on tab1.Serialno=FT.SerialNo"+
	       " left join FLOW_OPINION FO on tab1.Serialno=FO.SerialNo "+
	       " where FO.PhaseOpinion is not null ";
	        if(sSelfOpinionPhase.equals(""))
		         sSql += " ORDER BY tab1.PhaseNo";
	       else
		         sSql += " and FT.PhaseNo <> '"+sSelfOpinionPhase+"' ORDER BY tab1.PhaseNo";
	       rs=Sqlca.getASResultSet(sSql);

	       sTemp.append("<table width='640' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");

	  String PhaseOpinion="";
        while (rs.next())
        {
        	
	sEndTime=DataConvert.toString(rs.getString("EndTime"));
	data=sEndTime.split("/");
	time=data[2].split("\\s+");

	if("0010".equals(rs.getString("PhaseNo"))&&Integer.parseInt(sum)>0){//��ȡ���µ��˻ز������Ͻ׶ε����
	PhaseOpinion =Sqlca.getString(" select fo.PhaseOpinion from flow_opinion fo,flow_task ft where ft.serialno=fo.serialno and ft.objectno ='"+rs.getString("objectNo")+"' and ft.phaseno='3000' and  ft.ObjectType='"+sObjectType+"' order by ft.SerialNo desc fetch first 1 rows only ");	
	}else{
		 PhaseOpinion =StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n");
	}		
	
   
	sTemp.append("	 <tr>");
	sTemp.append("        <td class='black' rowspan=2 width=80  height=90>"+DataConvert.toString(rs.getString("PhaseName")) +"</td>");
	sTemp.append("       <td  colspan=1  height=70>");
	sTemp.append("    \r\n&nbsp;&nbsp;�������"+ PhaseOpinion +" \r\n ");
	sTemp.append("                     "+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion1")).trim(),"\\r\\n","\r\n"));
	sTemp.append("                     "+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion2")).trim(),"\\r\\n","\r\n")); 
	sTemp.append("                     "+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion3")).trim(),"\\r\\n","\r\n")); 
	sTemp.append("       </td>");
	sTemp.append("      </tr>");
	sTemp.append("      <tr><td class='black'  height=40 align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ�֣�"+DataConvert.toString(rs.getString("UserName")) +"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+data[0] +"��&nbsp;&nbsp;"+data[1] +"��&nbsp;&nbsp;"+time[0] +"��&nbsp;&nbsp;"+time[1] +"</td></tr>");
    
      }
    rs.getStatement().close();
	sTemp.append("</table>");
	sTemp.append("");
	sTemp.append("<div id='PrintButton'>");
	sTemp.append("<table width='640' align='center'>");
	sTemp.append("<tr>");
	sTemp.append("<td align='center'>"+HTMLControls.generateButton("��ӡ", "�����嵥","javascript: my_Print()", sResourcesPath));
	sTemp.append("</td>");
	sTemp.append("<td align='center'>"+HTMLControls.generateButton("�ϴ�Ӱ��", "�ϴ�Ӱ��","javascript: upImage()", sResourcesPath));
	sTemp.append("</td>");
	sTemp.append("<td align='center'>"+HTMLControls.generateButton("����", "����","javascript: window.close()", sResourcesPath));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");
	sTemp.append("</div>");
	sTemp.append("</BODY>");
	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
	session.setAttribute(sPreviewContent,sTemp.toString());
	CurARC.setAttribute("PrintOpinion", sReportInfo);
	out.println(sReportInfo);
%>
<%
	/*~END~*/
%>
<script language="VBScript">
	dim hkey_root,hkey_path,hkey_key
	hkey_root="HKEY_CURRENT_USER"
	hkey_path="\Software\Microsoft\Internet Explorer\PageSetup"
	'//������ҳ��ӡ��ҳüҳ��Ϊ��
	function pagesetup_null()
	on error resume next
		Set RegWsh = CreateObject("WScript.Shell")
		hkey_key="\header" 
		RegWsh.RegWrite hkey_root+hkey_path+hkey_key,""
		hkey_key="\footer"
		RegWsh.RegWrite hkey_root+hkey_path+hkey_key,""
	
	end function
	'//������ҳ��ӡ��ҳüҳ��ΪĬ��ֵ
	function pagesetup_default()
		on error resume next
		Set RegWsh = CreateObject("WScript.Shell")
		hkey_key="\header" 
		RegWsh.RegWrite hkey_root+hkey_path+hkey_key,"&w&bҳ�룬&p/&P"
		hkey_key="\footer"
		RegWsh.RegWrite hkey_root+hkey_path+hkey_key,"&u&b&d"
	end function
</script>

	<script language="javascript">
		
		function my_Print()
		{
			pagesetup_null();
			beforePrint();
			//pagesetup_default();
			window.print();
			afterPrint();
		}
		function upImage(){
		
			OpenPage("/PublicInfo/ImageAction1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&PhaseType=<%=sPhaseType%>&ManageDepartFlag=<%=sManageDepartFlag%>&BusinessType=<%=sBusinessType%>&ApplySerialno=<%=ApplySerialno%>&OrgName=<%=sOrgName%>&Inputdate=<%=sInputdate%>&BusinessTypeName=<%=sBusinessTypeName%>&CustomerID=<%=sCustomerID%>&CustomerName=<%=sCustomerName%>&DrawingType=<%=sDrawingType%>", "_self","");	 
		
		}
		function my_Cancle()
		{
			self.close();
		}		
		
		function beforePrint()
		{
			document.all('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.all('PrintButton').style.display="";
		}
		
</script>
</HTML>

<%@ include file="/IncludeEnd.jsp"%>
