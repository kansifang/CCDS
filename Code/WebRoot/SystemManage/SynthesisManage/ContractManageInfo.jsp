<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  hlzhang 2011-10-28
		Tester:
		Content: ҵ�������Ϣ
		Input Param:
				 ObjectType����������
				 ObjectNo��������
		Output param:
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�����������������������Ӧ����������SQL��䡢��Ʒ���͡��ͻ����롢��ʾ����
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "";
	//�����������ѯ��������ʾģ�����ơ��������͡��������͡��ݴ��־������ҵ������Ķ��������ˮ
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sBAAgreement = "",sRelativeSerialNo = "";
	//����������ͻ�����,�ͻ���Ϣ����,��ҵͶ��
	String sCustomerType = "",sApproveDate="";
	//���������չ�ڴ��������»��ɴ��������ɽ��´�����ծ���������
	int dOldTermMonth=0,dOldTermDay=0;
	//�����������ѯ�����
	ASResultSet rs = null;
	
	//���ҳ�����	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%	
	//���ݶ������ʹӶ������Ͷ�����в�ѯ����Ӧ�����������
	sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sMainTable = DataConvert.toString(rs.getString("ObjectTable"));
		sRelativeTable = DataConvert.toString(rs.getString("RelativeTable"));
				
		//����ֵת���ɿ��ַ���
		if(sMainTable == null) sMainTable = "";
		if(sRelativeTable == null) sRelativeTable = "";		
	}
	rs.getStatement().close(); 
	
	//��ҵ����л��ҵ��Ʒ��
	sSql = "select CustomerID,BAAgreement,ApplyType,RelativeSerialNo,CustomerID,BusinessType,OccurType,TempSaveFlag,ApproveDate from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBAAgreement = DataConvert.toString(rs.getString("BAAgreement"));
		sApplyType = DataConvert.toString(rs.getString("ApplyType"));
		sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
		sOccurType = DataConvert.toString(rs.getString("OccurType"));
		sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag")); 
		sApproveDate = DataConvert.toString(rs.getString("ApproveDate")); 
		
		//����ֵת���ɿ��ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sBAAgreement == null) sBAAgreement = "";
		if(sApplyType == null) sApplyType = "";
		if(sRelativeSerialNo == null) sRelativeSerialNo = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sTempSaveFlag == null) sTempSaveFlag = "";
		if(sApproveDate == null) sApproveDate = "";
	
	}
	rs.getStatement().close(); 
	System.out.println("sApproveDate:"+sApproveDate);
	
	sSql= "select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerType = rs.getString("CustomerType");
		if(sCustomerType == null) sCustomerType = "";
	}
	rs.getStatement().close(); 

	//���ҵ��Ʒ��Ϊ��,����ʾ���������ʽ����
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//չ��ȡԭ����ͬ�����¡���
	if(sOccurType.equals("015"))
	{
		//��ȡչ�ں�ͬ��/��ݣ� ��ͬ��
		//sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //���պ�ͬ
		String sContractNo = "";
		sSql = 	" select relativeserialno2 "+ 
				//" from BUSINESS_CONTRACT "+ //���պ�ͬ
				" from BUSINESS_DUEBILL "+ //���ս��
				" where SerialNo in (select ObjectNo "+
				" from "+sRelativeTable+" "+
				//" where ObjectType = 'BusinessContract' "+ //���պ�ͬ
				" where ObjectType = 'BusinessDueBill' "+ //���ս��
				" and SerialNo = '"+sObjectNo+"') ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			sContractNo= rs.getString("relativeserialno2");	
			//����ֵת���ɿ��ַ���					
			if(sContractNo == null) sContractNo = "";
		}
		rs.getStatement().close(); 		
		sSql = "select TermMonth,TermDay from BUSINESS_CONTRACT where SerialNo = '"+sContractNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			dOldTermMonth = rs.getInt("TermMonth");
			dOldTermDay = rs.getInt("TermDay");
		}
		rs.getStatement().close();
	}
	
	//���ݲ�Ʒ���ʹӲ�Ʒ��Ϣ��BUSINESS_TYPE�л����ʾģ������
	//��������Ϊչ�ڣ���Ҫ����չ����Ϣģ��
	if(sOccurType.equals("015"))
	{
		sDisplayTemplet = "ContractInfo0000"; //��ͬ����					
	}else
	{
		sFieldName = "ContractDetailNo"; //��ͬ����
		sSql = " select "+sFieldName+" as DisplayTemplet from BUSINESS_TYPE where TypeNo = '"+sBusinessType+"' ";
		sDisplayTemplet = Sqlca.getString(sSql);
	
		//����ͬһģ���ڲ�ͬ�׶���ʾ��ͬ������	
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //��ͬ����
			sColAttribute = " ColAttribute like '%"+sObjectType+"%' ";
	}
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,sColAttribute,Sqlca);
	
	//���ø��±���������
	doTemp.UpdateTable = sMainTable;
	doTemp.setKey("SerialNo",true);
	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��׼�����ʱ�����ڵ���0,С�ڵ���100��\" ");

	if(sBusinessType.equals("1110010")|| sBusinessType.equals("1110020") || sBusinessType.equals("1110030") || sBusinessType.equals("1110040")||sBusinessType.equals("1110025") )
	{
		doTemp.appendHTMLStyle("ThirdPartyZIP3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"������������ʱ�����ڵ���0,С�ڵ���1000��\" ");
		doTemp.appendHTMLStyle("ThirdPartyZIP2"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���Ҵ������������ڵ���0,С�ڵ���100��\" ");
		doTemp.appendHTMLStyle("ThirdPartyAdd1"," myvalid=\"parseFloat(myobj.value,10)>=0  \" mymsg=\"�׸���������ڵ���0 \" ");		
	}
	
	if( sBusinessType.equals("1110027"))
	{
		doTemp.appendHTMLStyle("ThirdPartyID3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���Ҵ������������ڵ���0,С�ڵ���100��\" ");
		doTemp.appendHTMLStyle("ThirdPartyID2"," myvalid=\"parseFloat(myobj.value,10)>=0  \" mymsg=\"�׸���������ڵ���0 \" ");
	}
	if( sBusinessType.equals("1080070"))
	{
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤��֤�����������ڵ���0,С�ڵ���100��\" ");
	}
	//������ѧ����
	if( sBusinessType.equals("1110150"))
	{
		doTemp.appendHTMLStyle("ThirdPartyID1"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��Ϣ����������ڵ���0,С�ڵ���100��\" ");
	}
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����������ڵ���0,С�ڵ���100��\" ");
	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������ʱ�����ڵ���0,С�ڵ���1000��\" ");
	
	//ũ����������
	if(sBusinessType.equals("1150020"))
	{
		doTemp.setVisible("BailRatio,BailSum",true);
		doTemp.setRequired("BailRatio",true);
	}
	if(sBusinessType.equals("3010")){
		doTemp.setVisible("BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,SelfUseFlag",true);
		doTemp.setRequired("RateFloatType,RateFloat,BusinessRate,SelfUseFlag",true);
	}
	
	doTemp.appendHTMLStyle("VouchCorpFlag","onBlur=\"javascript:parent.setVouchAggreement()\" ");
	
	doTemp.setReadOnly("PdgSum",true);

	if(sOccurType.equals("015"))
		doTemp.setCheckFormat("TotalSum,BusinessSum","2");
	
	//�������ʸ�ʽ,����С����6λ
	doTemp.setCheckFormat("BusinessRate,OldBusinessRate,OverdueRate,TARate","16");

	//�����������ͬ��������ʾҪ�صĲ�ͬ����
	if(sApplyType.equals("DependentApply")){//�������ҵ��
		doTemp.setVisible("CreditAggreement",true);
		if(sCustomerType.startsWith("03")){
			doTemp.setReadOnly("CycleFlag",true);  
		}
	}
	
	//------��ͬ�Ǽ�-----------
	if(sObjectType.equals("BusinessContract"))
	{
		doTemp.setReadOnly("BusinessCurrency",true);
		doTemp.setUnit("VouchTypeName","");
	}
	
	if(sObjectType.equals("BusinessContract"))
	{
		doTemp.setUnit("VouchTypeName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectVouchType()>");
		doTemp.setUpdateable("VouchTypeName",false);
		doTemp.setReadOnly("",false);
		doTemp.setReadOnly("SerialNo,CustomerID,CustomerName,BusinessTypeName,OccurDate,PutOutOrgName",true);
		doTemp.setRequired("",false);
	}
	
%>
<%@include file="/CreditManage/CreditApply/CheckBusinessDataValidity.jsp"%>	
<%
	//����DataWindow����	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "0"; 
	
	//ֻ��ҵ��Ʒ���Ƕ��ʱ��Ҫ����CL_Info
	if(sBusinessType.startsWith("30") && !sBusinessType.equals("3020"))
	{
		if("ReinforceContract".equals(sObjectType))
		{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo(BusinessContract,#SerialNo,#BusinessSum,#BusinessCurrency,#LimitationTerm,#BeginDate,#PutOutDate,#Maturity,#UseTerm,#TermMonth)");
		}else{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo("+sObjectType+",#SerialNo,#BusinessSum,#BusinessCurrency,#LimitationTerm,#BeginDate,#PutOutDate,#Maturity,#UseTerm,#TermMonth)");
		}
		
	}
	
	if(sBusinessType.equals("3020"))
	{
		if("ReinforceContract".equals(sObjectType))
		{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateEntAgreementInfo(#SerialNo,BusinessContract)");
		}else{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateEntAgreementInfo(#SerialNo,"+sObjectType+")");
		}
	}
	
	dwTemp.setEvent("AfterUpdate","!BusinessManage.DeleteBusinessContractBak(#SerialNo,BusinessContract)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
				{"true","","Button","�ر�","�رյ�ǰҳ��","closeSelf()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(confirm("��ȷ�Ͻ��Ժ�ͬ������Ϣ���޸���ȷ��������ȷ������ť��")){
		
			if(vI_all("myiframe0"))
			{
				beforeUpdate();	
				
				//ҵ������ʱ����ǰ��ͬ��¼���뵽BC_B���ݱ���
				sBCBSerialNo = initSerialNo();
				sObjectNo = getItemValue(0,getRow(),"SerialNo");
				sReturn = RunMethod("BusinessManage","AddBusinessContractBak",sBCBSerialNo+","+sObjectNo+","+"<%=CurOrg.OrgID%>"+","+"<%=CurUser.UserID%>"+",BusinessContract");
				if(sReturn == 1){
					as_save("myiframe0");
				}else{
					alert("������ʷ����ʧ�ܣ�");
					return;
				}	
				
			}
		}
	}
	
	/*~[Describe=�ر�;InputParam=��;OutPutParam=��;]~*/
	function closeSelf()
	{
		self.close();  //�رյ�ǰҳ��

	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{	

	}
	
	/*~[Describe=�������Ŷ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditLine()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}
		//���Ҹÿͻ�����Ч����Э��
		sParaString = "CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
		setObjectValue("SelectCLContract",sParaString,"@CreditAggreement@0",0,0,"");
	}
			
	/*~[Describe=ѡ����Ҫ������ʽ;InputParam=��;OutPutParam=��;]~*/
	function selectVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	/*~[Describe=ѡ�񳨿ڲ��ַ�������ʽ;InputParam=��;OutPutParam=��;]~*/
	function selectOpenVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchFlag@0@VouchFlagName@1",0,0,"");		
	}
	
	//��Ѻ����Ѻ����
	function selectVouchType1() {
		ssBusinessType = "<%=sBusinessType%>";
		sParaString = "CodeNo"+","+"VouchType";
		if(ssBusinessType == "1140110")
		setObjectValue("SelectImpawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");
		else 
		setObjectValue("SelectPawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");	
			
	}
	
	//��֤����
	function selectVouchType2() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectAssureCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	//��Ѻ��Ѻ����
	function selectVouchType3() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectPawnImpawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	/*~[Describe=����������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(sType)
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.OrgID%>";
		if(sType == "OperateUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0,"");		
		if(sType == "ManageUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@ManageUserID@0@ManageUserName@1@ManageOrgID@2@ManageOrgName@3",0,0,"");	
		if(sType == "RecoveryUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@RecoveryUserID@0@RecoveryUserName@1@RecoveryOrgID@2@RecoveryOrgName@3",0,0,"");			
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrg(sType)
	{		
		if(sType == "StatOrg")
			setObjectValue("SelectAllOrg","","@StatOrgID@0@StatOrgName@1",0,0,"");		
	}
	
	/*~[Describe=������������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAssureType()
	{		
		sParaString = "CodeNo"+","+"AssureType";
		setObjectValue("SelectCode",sParaString,"@SafeGuardType@0@SafeGuardTypeName@1",0,0,"");		
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
	
	/*~[Describe=�����Զ���С��λ����������,����objectΪ�������ֵ,����decimalΪ����С��λ��;InputParam=��������������λ��;OutPutParam=��������������;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
    	
	}
	
	/*~[Describe=���ݻ�׼���ʡ����ʸ�����ʽ�����ʸ���ֵ����ִ����(��)����;InputParam=��;OutPutParam=��;]~*/
	function getBusinessRate(sFlag)
	{
		//�ֹ�¼��
	}
	
	/*~[Describe=����������Ϣ��ʵ�����ֽ��;InputParam=��;OutPutParam=��;]~*/
	function getDiscountInterest()
	{
		//�ֹ�¼��
	}
	
	/*~[Describe=��������Ӧ��������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function getBargainorInterest()
	{
		//�ֹ�¼��
	}
	
	/*~[Describe=������������;InputParam=��;OutPutParam=��;]~*/
	function getOverdueRate()
	{
		//�ֹ�¼��
	}
	
	/*~[Describe=��ռ/Ų������InputParam=��;OutPutParam=��;]~*/
	function getTARate()
	{
		//�ֹ�¼��
	}
	
	/*~[Describe=���Ŵ����С����д���ݶ�ռ�ȡ�����;InputParam=��;OutPutParam=��;]~*/	
	function setBusinessProp()
	{
	    //�ֹ�¼��
    }
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum()
	{
	    //�ֹ�¼��
	}
	
	/*~[Describe=���������Ѽ�����������;InputParam=��;OutPutParam=��;]~*/
	function getPdgRatio()
	{
	    //�ֹ�¼��
	}
	
	/*~[Describe=���"��"�����Ƿ�Ϸ�;InputParam=��;OutPutParam=��;]~*/
	function getTermDay()
	{
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    sBusinessType = "<%=sBusinessType%>";
	    if(parseInt(dTermDay) > 30 )
	    {
	    	if(!(sBusinessType=="2050030") && !(sBusinessType=="2020"))
	        alert("��(��)����С�ڵ���30��");
	    }
	}
	
	/*~[Describe=�����׸��������׸�����;InputParam=��;OutPutParam=��;]~*/
	function getThirdPartyRatio()
	{
	    //�ֹ�¼��
	}
	
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum()
	{
	    //�ֹ�¼��  
	}
	
	/*~[Describe=���ݱ�֤������㱣֤�����;InputParam=��;OutPutParam=��;]~*/
	function getBailRatio()
	{
	    //�ֹ�¼��
	}
	
	/*--------------------- add by zwhu -----------------*/
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum1()
	{
	    //�ֹ�¼��
	}
	
	/*~[Describe=���������Ѽ�����������;InputParam=��;OutPutParam=��;]~*/
	function getPdgRatio1()
	{
	    //�ֹ�¼��
	}
	
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum1()
	{	
	    //�ֹ�¼��	    
	}	
	
	/*~[Describe=���ݱ�֤������㱣֤�����;InputParam=��;OutPutParam=��;]~*/
	function getBailRatio1()
	{
	    //�ֹ�¼��
	}
	
	
	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		//�ֹ�¼��
	}
	//�����������
	function CreditColumnCheck(sColumnName,sCheckType)
	{
		sCheckWord = getItemValue(0,getRow(),sColumnName);
		if(typeof(sCheckWord) != "undefined" && sCheckWord != "")	
		{
			if(!CheckTypeScript(sCheckWord,sCheckType))	
			{
				alert("�������Ͳ���ȷ�����������룡");
				setItemValue(0,getRow(),sColumnName,"");
				return false;
			}
			return true;
		}
	}
	//����Ƿ��Ǹ�����
	function isDigit(s)
	{
		var patrn=/^(-?\d+)(\.\d+)?$/;
		if (!patrn.exec(s)) 
		{
			alert(s+"���ݸ�ʽ����");
			return false;
		}
		return true;
	}
	//���Ҹÿͻ��ĵ���Э��
	function VouchAgreement()
	{
		sParaString = "";//
		sReturn = selectObjectValue("SelectVouchAgreement",sParaString,"",0,0,"");
		if( sReturn=="_CLEAR_" ){
			setItemValue(0,0,"VouchAggreement","");
			setItemValue(0,0,"VouchCorpName","");
			return;
		}else if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined"){
		 	return;
		}else{
			sReturn= sReturn.split('@');
			sSerialNo = sReturn[0];
			sCustomerName = sReturn[1];
			sPutOutDate = sReturn[2];
			sMaturity = sReturn[3];
			if("<%=StringFunction.getToday()%>" < sPutOutDate || sMaturity < "<%=StringFunction.getToday()%>")
			{
				alert("����������Э����Ч���⣬��������ñ�Э�飡");
				return;
			}
			setItemValue(0,0,"VouchAggreement",sSerialNo);
			setItemValue(0,0,"VouchCorpName",sCustomerName);
		}
	}
	
	//���ҹ��̻�е������Э��
	function DealerAgreement()
	{
		sParaString = "";		
	    sReturn = setObjectValue("SelectDealerAgreement",sParaString,"",0,0,"");
	    if(sReturn == sReturn=="_CLEAR_" ){
	    	setItemValue(0,0,"ConstructContractNo","");
			setItemValue(0,0,"TradeName","");
			setItemValue(0,0,"CropName","");
			return;
	    }
	    else if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined"){
	    	return;
	    }else{
			sReturn= sReturn.split('@');
			sSerialNo = sReturn[0];
			sTradeName = sReturn[1];
			sCustomerName = sReturn[2];
			sPutOutDate = sReturn[3];
			sMaturity = sReturn[4];
			if("<%=StringFunction.getToday()%>" < sPutOutDate || sMaturity < "<%=StringFunction.getToday()%>")
			{
				//add by xhyong ���ӳ�ʼ���������Ա���ݲ��ǲ���Ҫ����
				if(sObjectType != "ReinforceContract"){
					alert("����������Э����Ч���⣬��������ñ�Э�飡");
					return;
				}
			}
			setItemValue(0,0,"ConstructContractNo",sSerialNo);
			setItemValue(0,0,"TradeName",sTradeName);
			setItemValue(0,0,"CropName",sCustomerName);
		}
	}
	//���ҿ�����¥���Э��
	function selectProjectCoop()
	{
		sParaString = "";		
	    sReturn = setObjectValue("selectProjectCoop",sParaString,"",0,0,"");
	    if(sReturn=="_CLEAR_" ){
	    	setItemValue(0,0,"BuildAgreement","");
			setItemValue(0,0,"ThirdParty3","");
	    }else if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined"){
	    	return;
	    }else{
	    	sReturn= sReturn.split('@');
			sSerialNo = sReturn[0];
			sCustomerName = sReturn[1];
			sPutOutDate = sReturn[2];
			sMaturity = sReturn[3];
			if("<%=StringFunction.getToday()%>" < sPutOutDate || sMaturity < "<%=StringFunction.getToday()%>")
			{
				alert("����������Э����Ч���⣬��������ñ�Э�飡");
				return;
			}
			setItemValue(0,0,"BuildAgreement",sSerialNo);
			setItemValue(0,0,"ThirdParty3",sCustomerName);
		}
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
		 //�ֹ�¼��
	}
	
	//�Զ���ȡ�������������� 2011/08/17 
	function getAFBaseRateType(){
		//�ֹ�¼��
	}
	//��֤����Ӫ����ҵ��Ѻ����ҵ���еĳ�����
	function verifyRentRatio(){
		//�ֹ�¼��
	}
	//��֤������һ�֡�������������ҵ���еĴ��������
	function getBusinessProp(){
		//�ֹ�¼��
	}
	
	//�Ƿ��е�����˾����������Э�����
	function setVouchAggreement(){
		//�ֹ�¼��
	}
	
	/*~~~~~~~~~~~~~~~~~~ѡ����ũ�������~~~~~~~~~~~~~~~~~~~*/
	function selectInvolveAgriculture(){
		sCustomerType = "<%=sCustomerType%>";
		if(sCustomerType.substring(0,3) == "03"){
			sParaString = "CodeNo"+","+"AgriLoanClassify1"+","+"ItemAttribute"+","+"1";
			setObjectValue("SelectInvolveAgriculture",sParaString,"@AgriLoanClassify@0@AgriLoanClassifyName@1",0,0,"");
		}else{
			sParaString = "CodeNo"+","+"AgriLoanClassify1"+","+"ItemAttribute"+","+"2";
			setObjectValue("SelectInvolveAgriculture",sParaString,"@AgriLoanClassify@0@AgriLoanClassifyName@1",0,0,"");
		}
	}
	//��ͬ�׶Σ����»�ȡ��׼���� added by zrli 2010-10-20
	function getNewBaseRate(){
		//�ֹ�¼��
	}
	
	function setRequiredAndUpdate(BailRatio,VouchFlagName)
	{
		//�ֹ�¼��
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT_BAK";//����
		var sColumnName = "BCSerialNo";//�ֶ���
		var sPrefix = "BCB";//ǰ׺
       
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sBCBSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//����ˮ�ŷ���
		return sBCBSerialNo;
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
