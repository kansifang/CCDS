<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --fbkang 2005-7-26 
		Tester:
		Describe: --��Ŀ������Ϣ
		Input Param:
			ProjectNo��--��ǰ��Ŀ���
			
		Output Param:
			ProjectNo��--��ǰ��Ŀ���

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ŀ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//--���sql���
	String sProjectType="",sTempSaveFlag="";//--��Ŀ����
	String sTempletNo = "ProjectInfo";//--ģ������
	ASResultSet rs=null;
	//��������������Ŀ���
	String sProjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	String sObjectNo     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	//���ҳ�����	

	//�����Ŀ����
	sSql = "select ProjectType,TempSaveFlag  from PROJECT_INFO where ProjectNo='"+sProjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		
	   sProjectType =DataConvert.toString(rs.getString("ProjectType"));//--��Ŀ����
	   sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag"));//--��Ŀ����
	}
	rs.getStatement().close(); 
	if(sProjectType == null ) sProjectType = "";
	if(sTempSaveFlag == null ) sTempSaveFlag = "";
	
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter="  ColAttribute like '%"+sProjectType+"%'";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.setHTMLStyle("InputOrgName","style={width=250px}");
	//�Զ�������Ŀ�ʱ������(%)
	doTemp.setHTMLStyle("PlanTotalCast,ProjectCapital"," onchange=parent.getCapitalScale() ");
	//���üƻ���Ͷ��(Ԫ)��Χ
	doTemp.appendHTMLStyle("PlanTotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ƻ���Ͷ��(Ԫ)������ڵ���0��\" ");
	//���ù̶��ʲ�Ͷ��(Ԫ)��Χ
	doTemp.appendHTMLStyle("CapitalAssertsCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶��ʲ�Ͷ��(Ԫ)������ڵ���0��\" ");
	//�����̵������ʽ�(Ԫ)��Χ
	doTemp.appendHTMLStyle("Fund"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̵������ʽ�(Ԫ)������ڵ���0��\" ");
	//������Ŀ�ʱ���(Ԫ)��Χ
	doTemp.appendHTMLStyle("ProjectCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ�ʱ���(Ԫ)������ڵ���0��\" ");
	//�����ܽ���������Χ
	doTemp.appendHTMLStyle("ConstructTimes"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ܽ�������������ڵ���0��\" ");
	//���ò�Ǩ��������(Ԫ)��Χ
	doTemp.appendHTMLStyle("Sum1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ǩ��������(Ԫ)������ڵ���0��\" ");
	//�����������׷���(Ԫ)��Χ
	doTemp.appendHTMLStyle("Sum2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������׷���(Ԫ)������ڵ���0��\" ");
	//��������ֱ�ӳ��óɱ�Ͷ��(Ԫ)��Χ
	doTemp.appendHTMLStyle("Sum3"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ֱ�ӳ��óɱ�Ͷ��(Ԫ)������ڵ���0��\" ");
	//����Ŀǰ�ܱ����ؼ۸�(Ԫ)��Χ
	doTemp.appendHTMLStyle("Sum4"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ŀǰ�ܱ����ؼ۸�(Ԫ)������ڵ���0��\" ");
	//�������ؿ�����ĿԤ�����ۼ۸�(Ԫ)��Χ
	doTemp.appendHTMLStyle("Sum5"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ؿ�����ĿԤ�����ۼ۸�(Ԫ)������ڵ���0��\" ");
	//����Ŀǰ���ش��������������ع����ֵ(Ԫ)��Χ
	doTemp.appendHTMLStyle("Sum6"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ŀǰ���ش��������������ع����ֵ(Ԫ)������ڵ���0��\" ");
	//�������ؿ�����Ŀ���д���(Ԫ)��Χ
	doTemp.appendHTMLStyle("Sum7"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ؿ�����Ŀ���д���(Ԫ)������ڵ���0��\" ");
	//����Ŀǰӵ����������(Ԫ)��Χ
	doTemp.appendHTMLStyle("Sum8"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ŀǰӵ����������(Ԫ)������ڵ���0��\" ");
	//����Ŀǰӵ�����ع������ۼ�ֵ(Ԫ)��Χ
	doTemp.appendHTMLStyle("Sum9"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ŀǰӵ�����ع������ۼ�ֵ(Ԫ)������ڵ���0��\" ");
	//����ռ�����(ƽ����)��Χ
	doTemp.appendHTMLStyle("HoldArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ռ�����(ƽ����)������ڵ���0��\" ");
	//�����ܽ������(ƽ����)��Χ
	doTemp.appendHTMLStyle("BuildArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ܽ������(ƽ����)������ڵ���0��\" ");
	//����������λ�����䷿�����(ƽ����)��Χ
	doTemp.appendHTMLStyle("CoDistribute"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������λ�����䷿�����(ƽ����)������ڵ���0��\" ");
	//���û������(ƽ����)��Χ
	doTemp.appendHTMLStyle("RebuildArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(ƽ����)������ڵ���0��\" ");
	//������Ӫ���(ƽ����)��Χ
	doTemp.appendHTMLStyle("HomeArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ӫ���(ƽ����)������ڵ���0��\" ");
	//����סլ���(ƽ����)��Χ
	doTemp.appendHTMLStyle("HouseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"סլ���(ƽ����)������ڵ���0��\" ");
	//�����������(ƽ����)��Χ
	doTemp.appendHTMLStyle("EmporiumArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(ƽ����)������ڵ���0��\" ");
	//����д�ּ����(ƽ����)��Χ
	doTemp.appendHTMLStyle("ScriptoriumArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"д�ּ����(ƽ����)������ڵ���0��\" ");
	//���ó������(ƽ����)��Χ
	doTemp.appendHTMLStyle("CarportArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(ƽ����)������ڵ���0��\" ");
	//�����������(ƽ����)��Χ
	doTemp.appendHTMLStyle("OtherArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(ƽ����)������ڵ���0��\" ");
	//�����ܵؼ�(Ԫ)��Χ
	doTemp.appendHTMLStyle("TotalLandValue"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ܵؼ�(Ԫ)������ڵ���0��\" ");
	//������Ŀ�ݻ���(%)��Χ
	doTemp.appendHTMLStyle("DimensionRadio"," myvalid=\"parseFloat(myobj.value,10)>=0  \" mymsg=\"��Ŀ�ݻ���(%)���ڵ���0!\" ");
	//������Ŀ�̻���(%)��Χ
	doTemp.appendHTMLStyle("VirescenceRadio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��Ŀ�̻���(%)�ķ�ΧΪ[0,100]\" ");
	//���üƻ���Ͷ��(Ԫ)��Χ
	doTemp.appendHTMLStyle("PlanTotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ƻ���Ͷ��(Ԫ)������ڵ���0��\" ");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����setEvent
	//���ò���͸����¼�
    dwTemp.setEvent("AfterUpdate","!ProjectManage.AddProjectRelative(#ProjectNo,"+sObjectType+",#ObjectNo)");
   
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo);
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
		{sTempSaveFlag.equals("2")?"false":"true","","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()",sResourcesPath}
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
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;	
		if(bIsInsert){
			beforeInsert();
		}
		setItemValue(0,getRow(),'TempSaveFlag',"2");//�ݴ��־��1���ǣ�2����
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
		
	/*~[Describe=������Ŀ�ʱ������;InputParam=��;OutPutParam=��;]~*/
	function getCapitalScale()
	{
		//�ƻ���Ͷ��(Ԫ)
		sPlanTotalCast = getItemValue(0,getRow(),"PlanTotalCast");//--�ƻ���Ͷ��
		if(typeof(sPlanTotalCast) == "undefined" || sPlanTotalCast.length == 0)
			sPlanTotalCast=1;
		
		//��Ŀ�ʱ���(Ԫ)
		sProjectCapital = getItemValue(0,getRow(),"ProjectCapital");//--��Ŀ�ʱ���
		if(typeof(sProjectCapital) == "undefined" || sProjectCapital.length == 0)
			sProjectCapital=0;
		
		//��Ŀ�ʱ������������
		sProjectCapitalScale = Math.round(sProjectCapital/sPlanTotalCast*100);//--��Ŀ�ʽ����
		if(sProjectCapitalScale >= 0){
		   setItemValue(0,getRow(),"CapitalScale",sProjectCapitalScale);
		 }
		 else{//������Ϊ0
		   setItemValue(0,getRow(),"CapitalScale",0);
		 }

	}
	
	/*~[Describe=ѡ�������ҵ����;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{

		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");		
	}
	
	function saveRecordTemp()
	{
		//0����ʾ��һ��dw
		setNoCheckRequired(0);  //���������б���������
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�2����
		as_save("myiframe0");   //���ݴ�
		setNeedCheckRequired(0);//����ٽ����������û���	
	}


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ProjectNo","<%=sProjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"TempSaveFlag","1");//�Ƿ��־��1���ǣ�2����
		
			bIsInsert = true;
		}
    }
    
    /*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//��鿪�����ںͼƻ��������ڵ���Ч��
		sBeginBuildDate = getItemValue(0,getRow(),"BeginBuildDate");//--��ʼ����
		sExpectCompleteDate = getItemValue(0,getRow(),"ExpectCompleteDate");//--�ƻ���������
		if(typeof(sBeginBuildDate) != "undefined" && sBeginBuildDate != "" && 
		typeof(sExpectCompleteDate) != "undefined" && sExpectCompleteDate != "")
		{
			if(sExpectCompleteDate <= sBeginBuildDate)
			{
				alert(getBusinessMessage('153'));//�ƻ��������ڱ������ڿ������ڣ�
				return false;
			}
		}
		
		//��鿪�����ںͿ������ڵ���Ч��
		sExpectProductDate = getItemValue(0,getRow(),"ExpectProductDate");//--��������
		if(typeof(sBeginBuildDate) != "undefined" && sBeginBuildDate != "" && 
		typeof(sExpectProductDate) != "undefined" && sExpectProductDate != "")
		{
			if(sExpectProductDate <= sBeginBuildDate)
			{
				alert(getBusinessMessage('154'));//�������ڱ������ڿ������ڣ�
				return false;
			}
		}
		
		//У��������λ��֯���������Ƿ���ϱ������
		sCopartnerID = getItemValue(0,getRow(),"CopartnerID");//--������λ��֯��������
		if(typeof(sCopartnerID) != "undefined" && sCopartnerID != "" )
		{
			if(!CheckORG(sCopartnerID))
			{
				alert(getBusinessMessage('102'));//��֯������������						
				return false;
			}
		}
		
		return true;
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
