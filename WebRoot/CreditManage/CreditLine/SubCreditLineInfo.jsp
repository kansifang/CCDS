<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content: ��ȷ��������Ϣҳ��
		Input Param:
			ParentLineID����ȱ��
			LineID����ȷ�����
		Output param:
		History Log: lpzhang 2009-8-26 �ؼ�ҳ��

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ȷ��������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	String sBusinessType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	String sCLBusinessType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CLBusinessType"));//��ȷ���ҵ��Ʒ��
	if(sParentLineID == null) sParentLineID = "";
	if(sSubLineID == null) sSubLineID = "";
	if(sBusinessType == null) sBusinessType = "";
	if(sCLBusinessType == null) sCLBusinessType = "";
	ASResultSet rs= null;
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		
	String sSql="";
	//���ݶ�ȱ�Ż�ȡ�ͻ���źͿͻ�����,������ˮ�š��������������ˮ�š���ͬ��ˮ�š�������ͺͶ������
	String sCustomerID = "",sCustomerName = "";
	String sApplySerialNo = "",sApproveSerialNo = "",sContractSerialNo = "",sCLTypeID = "",sCLTypeName = "";
	
	sSql = 	" select CustomerID,CustomerName,ApplySerialNo,ApproveSerialNo,BCSerialNo,CLTypeID,CLTypeName "+
			" from CL_INFO where "+
			" LineID = '"+sParentLineID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sApplySerialNo = rs.getString("ApplySerialNo");
		sApproveSerialNo = rs.getString("ApproveSerialNo");
		sContractSerialNo = rs.getString("BCSerialNo");
		sCLTypeID = rs.getString("CLTypeID");
		sCLTypeName = rs.getString("CLTypeName");
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sApplySerialNo == null) sApplySerialNo = "";
		if(sApproveSerialNo == null) sApproveSerialNo = "";
		if(sContractSerialNo == null) sContractSerialNo = "";
		if(sCLTypeID == null) sCLTypeID = "";
		if(sCLTypeName == null) sCLTypeName = "";
	}
	rs.getStatement().close();
	
	String sSmallEntFlag = Sqlca.getString("Select SmallEntFlag from ENT_INFO where CustomerID = '"+sCustomerID+"'");
	if(sSmallEntFlag == null) sSmallEntFlag = "";
	//������ʾ����				
	String[][] sHeaders = {					
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"BusinessTypeName","ҵ��Ʒ��"},
					{"Rotative","�Ƿ�ѭ��"},
					{"TermMonth","����(��)"},
					{"Currency","����"},
					{"BailRatio","��֤�����"},		
					{"LineSum1","��߶�Ƚ��"},
					{"LineSum2","�����޶�"},
					{"InputOrgName","�Ǽǻ���"},
					{"InputUserName","�Ǽ���"},
					{"InputTime","�Ǽ�����"},
					{"UpdateTime","��������"}	,	
					{"RateFloatCondition","���ʸ���˵��"},	
					{"PdgRatioCondition","����Ҫ��"},	
					{"Purpose","��;"},	
					{"DirectionName","��ҵͶ��"},	
					{"GetSource","��ʽ��˵��"},	
					{"PaySource","���ʽ��˵��"},
					{"BaseRateType","��׼��������"},
					{"BaseRate","��׼������(%)"},
					{"RateFloatType","��������"},
					{"RateFloat","���ʸ���ֵ"},
					{"BusinessRate","ִ��������(��)"},
					{"PdgRatio","�������ʡ�"},
					{"PdgPayMethod","������֧����ʽ"},
					{"PdgSum","�����ѽ��"},
					};
	
	 sSql = 	" select ParentLineID,LineID,CustomerID,CustomerName,BusinessType, "+
				" getBusinessName(BusinessType) as BusinessTypeName,Currency,"+
				" LineSum1,LineSum2,TermMonth,"+
				" BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,BailRatio,Rotative, "+
				" PdgRatio,PdgPayMethod,PdgSum,"+
				" RateFloatCondition,PdgRatioCondition,Purpose,Direction,getItemName('IndustryType',Direction) as DirectionName,"+
				" GetSource,PaySource,"+
				" GetOrgName(InputOrg) as InputOrgName,InputOrg,InputUser,GetUserName(InputUser) as InputUserName,InputTime, "+
				" UpdateTime,CLTypeID,CLTypeName,ApplySerialNo,ApproveSerialNo,BCSerialNo "+
				" from CL_INFO "+
				" Where LineID = '"+sSubLineID+"' "+
				" and ParentLineID = '"+sParentLineID+"' ";	
	 
	if(sBusinessType.equals("3015"))//ͬҵ
	 {
		sSql = 	" select ParentLineID,LineID,CustomerID,CustomerName,BusinessType, "+
				" getBusinessName(BusinessType) as BusinessTypeName,Currency,"+
				" InputOrg,InputUser,GetUserName(InputUser) as InputUserName,InputTime, "+
				" UpdateTime,CLTypeID,CLTypeName,ApplySerialNo,ApproveSerialNo,BCSerialNo "+
				" from CL_INFO "+
				" Where LineID = '"+sSubLineID+"' "+
				" and ParentLineID = '"+sParentLineID+"' ";	
	 }else if(sBusinessType.equals("3050") || sBusinessType.equals("3060")) //����С�飬���ù�ͬ��
	 {
		 sSql = " select ParentLineID,LineID,CustomerID,CustomerName,MemberID, "+
				" MemberName,Currency,"+
				" LineSum1,LineSum2,TermMonth,Rotative,GetOrgName(InputOrg) as InputOrgName, "+
				" InputOrg,InputUser,GetUserName(InputUser) as InputUserName,InputTime, "+
				" UpdateTime,CLTypeID,CLTypeName,ApplySerialNo,ApproveSerialNo,BCSerialNo "+
				" from CL_INFO "+
				" Where LineID = '"+sSubLineID+"' "+
				" and ParentLineID = '"+sParentLineID+"' ";	
	 }
					
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("Rotative","YesNo");
	
	//���ò��ɼ�����
	doTemp.setVisible("Direction,RateFloatCondition,PdgRatioCondition,ParentLineID,MemberID,LineID,BusinessType,InputUser,LineSum2,InputOrg,CLTypeID,CLTypeName,ApplySerialNo,ApproveSerialNo,BCSerialNo",false);
	//����ֻ������
	doTemp.setReadOnly("BaseRateType,BaseRate,BusinessRate,DirectionName,CustomerID,CustomerName,MemberName,InputUserName,InputOrgName,InputTime,UpdateTime,BusinessTypeName",true);
	//���ñ�����
	doTemp.setRequired("PaySource,GetSource,DirectionName,Purpose,BusinessTypeName,Currency,Rotative,LineSum1,TermMonth",true);
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setDDDWCode("BaseRateType","BaseRateType");
	doTemp.setDDDWCode("RateFloatType","RateFloatType");
	doTemp.setDDDWCode("PdgPayMethod","ChargeType");
	if(sBusinessType.equals("3050"))
	{
		doTemp.setHeader("CustomerName","����С������");
		doTemp.setHeader("MemberName","��Ա����");
		doTemp.setRequired("MemberName",true);
		doTemp.setRequired("BusinessTypeName",false);
	}
	if(sBusinessType.equals("3060"))
	{
		doTemp.setHeader("CustomerName","���ù�ͬ������");
		doTemp.setHeader("MemberName","��Ա����");
		doTemp.setRequired("MemberName",true);
		doTemp.setRequired("BusinessTypeName",false);
	}
	
	//���ò��ɸ�������
	doTemp.setUpdateable("InputUserName,InputOrgName,BusinessTypeName,DirectionName",false);
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");
	doTemp.setHTMLStyle("RateFloatCondition"," style={height:100px;width:400px} ");
	doTemp.setHTMLStyle("PdgRatioCondition","style={height:100px;width:400px}");
	doTemp.setHTMLStyle("Purpose","style={height:100px;width:400px}");
	doTemp.setHTMLStyle("GetSource","style={height:100px;width:400px}");
	doTemp.setHTMLStyle("PaySource","style={height:100px;width:400px}");
	//���ø�ʽ
	doTemp.setType("PdgSum,PdgRatio,RateFloat,BaseRate,BusinessRate,LineSum1,LineSum2,BailRatio,TermMonth","Number");
	doTemp.setCheckFormat("TermMonth","5");
	doTemp.setCheckFormat("BusinessRate,BaseRate","16");
	doTemp.setUnit("BailRatio","%");	
	doTemp.setHTMLStyle("InputUserName,InputTime,UpdateTime"," style={width:80px;} ");
	 if(sBusinessType.equals("3015"))//ͬҵ
		doTemp.setUnit("BusinessTypeName","<input type=button value=\"...\" onClick=parent.SelectCode()>");
	else if(sBusinessType.equals("3010")){//��˾
		if("1".equals(sSmallEntFlag)){
			doTemp.setUnit("BusinessTypeName","<input type=button value=\"...\" onClick=parent.SelectSMEBusinessType()>");
		}
		else{
			doTemp.setUnit("BusinessTypeName","<input type=button value=\"...\" onClick=parent.SelectEntBusinessType()>");
	 	}
	 	doTemp.setUnit("DirectionName","<input type=button value=\"...\" onClick=parent.getIndustryType()>");
	}else if(sBusinessType.equals("3040"))//����
	{
		doTemp.setUnit("BusinessTypeName","<input type=button value=\"...\" onClick=parent.SelectIndBusinessType()>");
		doTemp.setUnit("DirectionName","<input type=button value=\"...\" onClick=parent.getIndustryType()>");
	}
	 if(sBusinessType.equals("3050"))//����
	{
		 doTemp.setUnit("MemberName","<input type=button value=\"...\" onClick=parent.SelectLBMember()>");
	}
	if(sBusinessType.equals("3060"))//���ù�ͬ��
	{
		doTemp.setUnit("MemberName","<input type=button value=\"...\" onClick=parent.SelectXYMember()>");
	}
	//��Ա���ҵ�������ѽ��Ϊ���޸�
	if(sCLBusinessType.startsWith("2030")||sCLBusinessType.startsWith("2040"))
	{
		doTemp.setReadOnly("PdgSum",false);
	}else{
		doTemp.setReadOnly("PdgSum",true);
	}
	//�Ǳ���ҵ�����ñ�֤�����ֻ��
	if(sCLBusinessType.startsWith("2") ){
		doTemp.setReadOnly("BailRatio",false);
	}else{
		doTemp.setReadOnly("BailRatio",true);
	}
	//����ҵ��Ʒ�������Ƿ������
	if(sCLBusinessType.startsWith("1") || sCLBusinessType.equals("2070") || sCLBusinessType.equals("2110040"))
	{
		doTemp.setRequired("BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate",true);
	}else if(!sCLBusinessType.equals("")){
		doTemp.setRequired("PdgRatio,PdgPayMethod,PdgSum",true);
	}	
	//��ȡ����
	doTemp.setUnit("PdgSum","<input class=\"inputdate\" value=\"��ȡֵ\" type=button onClick=parent.getpdgsum1()>");
	//�����Զ���ȡ��׼����
	doTemp.appendHTMLStyle("TermMonth","onBlur=\"javascript:parent.getBaseRateType()\" ");
	//���û�ȡִ������
	doTemp.appendHTMLStyle("RateFloatType,RateFloat","onBlur=\"javascript:parent.getBusinessRateInfo()\" ");
	//���������޶Χ
	doTemp.appendHTMLStyle("LineSum1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����޶������ڵ���0��\" ");
	//���ó����޶Χ
	doTemp.appendHTMLStyle("LineSum2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����޶������ڵ���0��\" ");
	//������ͱ�֤�����(%)��Χ
    doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��ͱ�֤�����(%)�ķ�ΧΪ[0,100]\" ");
    doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
    doTemp.appendHTMLStyle("PdgRatio"," onChange=\"javascript:parent.getpdgsum1()\" ");
    
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","���ص���ȷ����б�","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{		
		if(vI_all("myiframe0"))
		{	
			//¼��������Ч�Լ��
			if (!ValidityCheck()) return;
			getBaseRateType();
			if(bIsInsert){
				beforeInsert();
			}
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
			
		}
		
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditLine/SubCreditLineList.jsp?ParentLineID=<%=sParentLineID%>","_self","");
	}	
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sCurDate = PopPage("/Common/ToolsB/GetDay.jsp","","");		
		setItemValue(0,0,"UpdateTime",sCurDate);
		if("<%=sBusinessType%>"=="3010"||"<%=sBusinessType%>"=="3040")
		{
			sCLBusinessType =  getItemValue(0,0,"BusinessType");
			if(sCLBusinessType.substring(0,4) != "2030" && sCLBusinessType.substring(0,4) != "2040" )//����
			{
				getpdgsum1();
			}
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{	
		if(CheckSubCreditLine()) return true;
		else return false;
	}
	/*~[Describe=ѡ����ҵͶ�򣨹�����ҵ���ͣ�;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"Direction");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"Direction",sIndustryTypeValue);
			setItemValue(0,getRow(),"DirectionName",sIndustryTypeName);				
		}
	}
	
	/*~[Describe=�����޶�ͳ����޶���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function CheckSubCreditLine()
	{
		sParentLineID = "<%=sParentLineID%>";
		sSubLineID = getItemValue(0,getRow(),"LineID");//��ʾȡ��ǰҳ���LineID��Ϊ�������ݣ�����ֻȡ�̶�ֵ��Ҫȥ�仯��ֵ
		sLineSum1 = getItemValue(0,0,"LineSum1");//ȡ��ǰֵ
		sLineSum2 = getItemValue(0,0,"LineSum2");//ȡ��ǰֵ
		sBailRatio = getItemValue(0,0,"BailRatio");//ȡ��ǰֵ
		sTermMonth = getItemValue(0,0,"TermMonth");//ȡ��ǰֵ
		sCurrency = getItemValue(0,0,"Currency");//ȡ������
		sBusinessType = getItemValue(0,0,"BusinessType");//ȡ��ҵ��Ʒ��
		sMemberID = getItemValue(0,0,"MemberID");//��ԱID
		//���ȡ�������޶�Ϊ��ʱ�����Զ���λ��0.00
		if (typeof(sLineSum1)=="undefined" || sLineSum1.length==0)
		{
			sLineSum1 = 0.00;
			setItemValue(0,0,"LineSum1","0.00");
		}
		//���ȡ�������޶�Ϊ��ʱ�����Զ���λ��0.00
		if (typeof(sLineSum2)=="undefined" || sLineSum2.length==0)
		{
			sLineSum2 = 0.00;
			setItemValue(0,0,"LineSum2","0.00");	
		}
		//�ò�Ʒ�Ƿ��Ѿ�����
		iCount = 0;
		sBusinessType1 = "<%=sBusinessType%>";
		if(sBusinessType1=="3050" || sBusinessType1=="3060"){
			iCount = RunMethod("CreditLine","getLineTypeCount1",sMemberID+","+sParentLineID+","+sSubLineID);
			if(iCount>0)
			{
				alert("�ÿͻ��Ѿ������ȣ������ٽ��з��䣡");
				return false;
			}
		}
		else{
			iCount = RunMethod("CreditLine","getLineTypeCount",sBusinessType+","+sParentLineID+","+sSubLineID);
			if(iCount>0)
			{
				alert("��ҵ��Ʒ���Ѿ������ȣ������ٽ��з��䣡");
				return false;
			}
		}	
		sReturn = RunMethod("CreditLine","CheckCreditLine",sParentLineID+","+sSubLineID+","+sLineSum1+","+sLineSum2+","+sTermMonth+","+sCurrency);
		if(sReturn == "10")	
		{
			alert("�����޶�ܴ��������޶�������");
			return false;					
		}
		if(sReturn == "01")	
		{
			alert("�����޶�ܳ������Ŷ���ܶ�������");
			return false;					
		}
		if(sReturn == "11")	
		{
			alert("�����޶�ܴ��������޶�����޶�Ҳ���ܳ������Ŷ���ܶ�����!");
			return false;					
		}
		if(sReturn == "00")	
		{
			return true;					
		}
		if(sReturn == "12")	
		{
			alert("��ȷ������޲��ܴ����ܶ�����ޣ������!");
			return false;					
		}
		return false;
	}

	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function SelectEntBusinessType(){
		setObjectValue("SelectEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
		CheckSubCL();
	}
	
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function SelectSMEBusinessType(){
		setObjectValue("SelectSMEBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
		CheckSubCL();
	}	
	
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function SelectIndBusinessType(){
		setObjectValue("SelectCLIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
		CheckSubCL();		
	}
	/*~[Describe=��֤��ȷ��䲻���ظ�ҵ��Ʒ�ַ���;InputParam=��;OutPutParam=��;]~*/
	function CheckSubCL(){
		sBusinessType = getItemValue(0,0,"BusinessType");//ȡ��ҵ��Ʒ��
		sParentLineID = getItemValue(0,0,"ParentLineID");
		sLineID = getItemValue(0,0,"LineID");
		dReturn = RunMethod("CreditLine","CheckSubCL",sParentLineID+","+sBusinessType+","+sLineID);
		if(dReturn>0){
			alert("��ҵ��Ʒ���Ѿ������ȣ�������ѡ��ҵ��Ʒ�֣�");
			setItemValue(0,0,"BusinessType","");
			setItemValue(0,0,"BusinessTypeName","");
		}
		if("<%=sBusinessType%>" == "3040"){
			dReturn = RunMethod("CreditLine","CheckSubCL1",sParentLineID+","+sBusinessType+","+sLineID);
			if(dReturn>0){
				sBusinessTypeName = getItemValue(0,0,"BusinessTypeName");//ȡ��ҵ��Ʒ��
				alert("�ø��������ѷ�����"+sBusinessTypeName+"���ܷ��������ҵ��Ʒ�֣�");
				setItemValue(0,0,"BusinessType","");
				setItemValue(0,0,"BusinessTypeName","");
			}
		}
		if("<%=sBusinessType%>" == "3010"){
			dReturn = RunMethod("CreditLine","CheckSubCL",sParentLineID+","+sBusinessType+","+sLineID);
			sBusinessType = getItemValue(0,0,"BusinessType");
			//if("2010" == sBusinessType ||"2050030" == sBusinessType ){
			if(sBusinessType.substring(0,1)=="2" ){
				setItemRequired(0,0,"BailRatio",true);
	    	    getASObject(0,0,"BailRatio").style.background ="#ffffff";	
	    	    getASObject(0,0,"BailRatio").removeAttribute("readOnly");
			}else{
				setItemRequired(0,0,"BailRatio",false);
				getASObject(0,0,"BailRatio").style.background ="#efefef";
				getASObject(0,0,"BailRatio").setAttribute("readOnly","true");
				setItemValue(0,0,"BailRatio","");
			}
			if(sBusinessType.substring(0,4)=="2030" || sBusinessType.substring(0,4)=="2040"){
	    	    getASObject(0,0,"PdgSum").style.background ="#ffffff";
	    	    getASObject(0,0,"PdgSum").removeAttribute("readOnly");
			}else{
				getASObject(0,0,"PdgSum").style.background ="#efefef";
				getASObject(0,0,"PdgSum").setAttribute("readOnly","true");
				setItemValue(0,0,"PdgSum","");
			}
			//����Ҫ�������ί�д���Ҫ���������������Ϣ,����Ҫ�����������������Ϣ
			if(sBusinessType.substring(0,1)=="1" || "2070" == sBusinessType || "2110040" == sBusinessType)
			{
				setItemRequired(0,0,"BaseRateType",true);
				setItemRequired(0,0,"BaseRate",true);
				setItemRequired(0,0,"RateFloatType",true);
				setItemRequired(0,0,"RateFloat",true);
				setItemRequired(0,0,"BusinessRate",true);
	    	    setItemRequired(0,0,"PdgRatio",false);
	    	    setItemRequired(0,0,"PdgPayMethod",false);
	    	    setItemRequired(0,0,"PdgSum",false);
				setItemValue(0,0,"PdgRatio","");
				setItemValue(0,0,"PdgPayMethod","");
				setItemValue(0,0,"PdgSum","");
			}else{
			 	setItemRequired(0,0,"PdgRatio",true);
	    	    setItemRequired(0,0,"PdgPayMethod",true);
	    	    setItemRequired(0,0,"PdgSum",true);
				setItemRequired(0,0,"BaseRateType",false);
				setItemRequired(0,0,"BaseRate",false);
				setItemRequired(0,0,"RateFloatType",false);
				setItemRequired(0,0,"RateFloat",false);
				setItemRequired(0,0,"BusinessRate",false);
				setItemValue(0,0,"BaseRateType","");
				setItemValue(0,0,"BaseRate","");
				setItemValue(0,0,"RateFloatType","");
				setItemValue(0,0,"RateFloat","");
				setItemValue(0,0,"BusinessRate","");
			}
		}
	}	
	/*~[Describe=����������Աѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function SelectLBMember(){
		sCustomerID = getItemValue(0,0,"CustomerID");
		sParaString = "CustomerID"+","+sCustomerID;
		setObjectValue("SelectLBMember",sParaString,"@MemberID@0@MemberName@1",0,0,"");
		
	}
	/*~[Describe=�������ù�ͬ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function SelectXYMember(){
		sCustomerID = getItemValue(0,0,"CustomerID");
		sParaString = "CustomerID"+","+sCustomerID;
		setObjectValue("SelectXYMember",sParaString,"@MemberID@0@MemberName@1",0,0,"");
		
	}
	/*~[Describe=����ͬҵ�ͻ�ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function SelectCode(){
		setObjectValue("SelectCode","CodeNo,BusinessTypeTY","@BusinessType@0@BusinessTypeName@1",0,0,"");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ParentLineID","<%=sParentLineID%>");	
			setItemValue(0,0,"ApplySerialNo","<%=sApplySerialNo%>");
			setItemValue(0,0,"ApproveSerialNo","<%=sApproveSerialNo%>");
			setItemValue(0,0,"BCSerialNo","<%=sContractSerialNo%>");			
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");	
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"CLTypeID","<%=sCLTypeID%>");	
			setItemValue(0,0,"CLTypeName","<%=sCLTypeName%>");									
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Rotative","2");
			setItemValue(0,0,"Currency","01");
			bIsInsert = true;	
			if("<%=sBusinessType%>" == "3040"){
				setItemValue(0,0,"Rotative","1");
			}		
		}	
		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CL_INFO";//����
		var sColumnName = "LineID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	//ȡ�û�׼������
	function selectBaseRateType(){
		sCurDate = "<%=StringFunction.getToday()%>"
		sParaString = "CurDate"+","+sCurDate;
	    sReturn = setObjectValue("selectBaseRateType",sParaString,"@BaseRateType@0@BaseRate@1",0,0,"");
		getBusinessRate("M");
	}
	//�Զ���ȡ�������� 2009-12-24 
	function getBaseRateType(){
		 var sBusinessType = <%=sBusinessType%>
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBusinessCurrency = getItemValue(0,getRow(),"Currency");//����
		 sBaseRateID = "";
		 if(sBusinessCurrency=="01"){//�����
			 if(dTermMonth <= 6){
			 	sBaseRateID = "10010";
			 }else if(dTermMonth > 6 && dTermMonth <= 12){
			 	sBaseRateID = "10020";
			 }else if(dTermMonth > 12 && dTermMonth <= 36){
			 	sBaseRateID = "10040";
			 }else if(dTermMonth > 36 && dTermMonth <= 60){
			 	sBaseRateID = "10050";
			 }else{
			 	sBaseRateID = "10030";
			 }
		 }else{//���
			 if(dTermDay < 7 && dTermMonth==0){
			 	sBaseRateID = "20010";//��ҹ
			 }else if(dTermDay < 14 && dTermMonth==0){
			 	sBaseRateID = "20020";//һ��
			 }else if(dTermMonth==0 ){
			 	sBaseRateID = "20030";//����
			 }else if(dTermMonth <3){
			 	sBaseRateID = "20040";//һ����
			 }else if(dTermMonth <6){
			 	sBaseRateID = "20050";//������
			 }else if(dTermMonth <12){
			 	sBaseRateID = "20060";//������
			 }else{
			 	sBaseRateID = "20070";//ʮ������
			 }
		}
		 setItemValue(0,0,"BaseRateType",sBaseRateID);
		 
		 //sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
		 sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    }  
		getBusinessRate("M");
	}
	
	
	function getBusinessRateInfo()
	{
		getBusinessRate("M")
	}
	
	/*~[Describe=���ݻ�׼���ʡ����ʸ�����ʽ�����ʸ���ֵ����ִ����(��)����;InputParam=��;OutPutParam=��;]~*/
	function getBusinessRate(sFlag)
	{
		//ҵ������
		sBusinessType = "<%=sBusinessType%>";
		//��׼����
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//���ʸ�����ʽ
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//���ʸ���ֵ
		dRateFloat = getItemValue(0,getRow(),"RateFloat");
		var dBusinessRate = "";
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 )
		{			
			if(sRateFloatType=="0")	//�����ٷֱ�
			{
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
				if(sFlag == 'M') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else	//1:��������
			{
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				if(sFlag == 'M') //ִ��������
					dBusinessRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
			}
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,0,"BusinessRate",dBusinessRate);
		}else
		{
			setItemValue(0,0,"BusinessRate","");
		}
		if(sBusinessType == "1020010" || sBusinessType == "1020020")
		{
			dBusinessRate = parseFloat(dBaseRate)/1.2;
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,0,"BusinessRate",dBusinessRate);
		}
	}
	
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum1()
	{
	    dBusinessSum = getItemValue(0,getRow(),"LineSum1"); //��ȡ������
	    if(parseFloat(dBusinessSum) >= 0)
	    {
			dPdgRatio = getItemValue(0,getRow(),"PdgRatio");//��ȡ�����ѱ���
	    	if(parseFloat(dPdgRatio) >= 0)
	    	{
	    		sBusinessCurrency = getItemValue(0,getRow(),"Currency");		
	    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
	    		if(typeof(sFeeCurrency) == "undefined" || sFeeCurrency == "" ){
		        	sFeeCurrency = "01";
		        }
	        	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
		    	dPdgRatio = roundOff(dPdgRatio,2);
			    dPdgSum = (parseFloat(dBusinessSum)*dErateRatio)*parseFloat(dPdgRatio)/1000;
			    dPdgSum = roundOff(dPdgSum,2);
			    if(dPdgSum<300 && ("<%=sBusinessType%>" == "2050030" || "<%=sBusinessType%>" == "2050010"))
					dPdgSum = 300.00;	
			    setItemValue(0,getRow(),"PdgSum",dPdgSum);
			}
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();	
			
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
