<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.are.util.SpecialTools" %>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:ljma   2011-02-24
			Tester:
			Content: ���������Ϣ
			Input Param:
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "ҵ��������Ϣҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";
	//����������

	//���ҳ�����	
	String sIndustryType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryType"));
	if(sIndustryType==null) sIndustryType="";
	String sScope =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope"));
	if(sScope==null) sScope="";
%>
<%
	/*~END~*/
%>

<%
	String sHeaders[][] = { 
	{"IndustryType","������ҵ"},
	{"IndustryTypeName","������ҵ"},
	{"Scope","��ҵ��ģ"},
	{"EmployeeNumberMin","��ҵ�������ޣ�����"},
	{"EmployeeNumberMax","��ҵ��������"},
	{"SaleSumMin","���۶����ޣ���������Ԫ��"},
	{"SaleSumMax","���۶����ޣ���Ԫ��"},
	{"AssetSumMin","�ʲ��ܶ����ޣ���������Ԫ��"},
	{"AssetSumMax","�ʲ��ܶ����ޣ���Ԫ��"},
	{"InputUserName","�Ǽ���Ա"},
	{"InputOrgName","�Ǽǻ���"},
	{"InputDate","�Ǽ�����"},
	{"UpdateUserName","������Ա"},
	{"UpdateOrgName","���»���"},
	{"UpdateDate","��������"}
	
		};
	sSql = " select IndustryType,getItemName('IndustryType',nvl(IndustryType,'')) as IndustryTypeName,Scope,"+
		  " EmployeeNumberMin,EmployeeNumberMax, "+ 
		  " SaleSumMin,SaleSumMax, "+
		  " AssetSumMin,AssetSumMax, "+
		  " InputUserID,getUserName(InputUserID) as InputUserName, "+
		  " InputOrgID,getOrgName(InputOrgID) as InputOrgName,"+
		  "	InputDate, "+
		  " UpdateUserID,getUserName(UpdateUserID) as UpdateUserName, "+
		  " UpdateOrgID,getOrgName(UpdateOrgID) as UpdateOrgName,"+
		  " UpdateDate "+
		  " from ENT_SCOPE_STANDARD where IndustryType='"+sIndustryType+"' and Scope='"+sScope+"'";
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		//ͨ����ʾģ�����ASDataObject����doTemp
		//����DataObject				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);

		//���ø��±�������
		doTemp.UpdateTable="ENT_SCOPE_STANDARD";
		doTemp.setKey("IndustryType,Scope",true);

		//���ñ�����
		doTemp.setRequired("Scope,IndustryType,EmployeeNumberMin,EmployeeNumberMax,SaleSumMin,SaleSumMax,AssetSumMin,AssetSumMax",true);
		doTemp.setUpdateable("IndustryTypeName,InputUserName,InputOrgName,UpdateUserName,UpdateOrgName",false);
		
		//���ò��ɼ�
		doTemp.setVisible("SerialNo,IndustryType,InputUserID,InputOrgID,UpdateUserID,UpdateOrgID",false);
		//���������б�
	    doTemp.setDDDWCode("Scope","Scope");
		//����ѡ����ͼ
		doTemp.setUnit("IndustryTypeName","<input class=\"inputdate\" value=\"...\" type=button value=.. onclick=parent.getIndustryType()>");
		//����ֻ����
		doTemp.setReadOnly("IndustryTypeName,InputOrgName,InputUserName,InputDate,UpdateDate,UpdateUserName,UpdateOrgName",true); 
		//���ÿ��
		//doTemp.setEditStyle("OrgName,OrgID,BusinessType,BusinessTypeName,OccurType,OccurTypeName","3");
		//���ø�ʽ����Ӧ��ʾģ���еĸ�ʽ1���ַ�����2���֣���С������3�����ڣ�4��ʱ�䣬5����������
		doTemp.setCheckFormat("EmployeeNumberMin,EmployeeNumberMax","5");
		doTemp.setCheckFormat("SaleSumMin,SaleSumMax,AssetSumMin,AssetSumMax","2");
		doTemp.setCheckFormat("InputDate,UpdateDate","3");
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		//session.setAttribute(dwTemp.Name,dwTemp);
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
%>
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
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//������ؼ��
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		var sScope = getItemValue(0,getRow(),"Scope");
		var bIsHaveInserted =RunMethod("BusinessManage","CheckIndustryAndScope",sIndustryType+","+sScope);
		if(bIsHaveInserted=='exist'){
			alert("�˹�����ҵ�˹�ģ�Ѵ��ڣ�");
			return;
		}else if(bIsHaveInserted=='ldifferent'){
			alert("��˹�����ҵ�����β�һ�µĹ�����ҵ�Ѵ��ڣ�");
			return;
		}
		as_save("myiframe0");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/EntScoptStandardList.jsp","_self","");
	}

	

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateOrgID","<%=CurUser.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=(��ѡ)����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
    function AddBusinessType(){
    	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	var sReturn =  PopPage("/SystemManage/CreditTypeLimit/AddBusinessType.jsp?SerialNo="+sSerialNo,"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin");       	
		var temp = "";
		var sBusinessTypeValue = "";
		var sBusinessTypeName = "";
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_none_")
		{
			sBusinessTypeInfo = sReturn.split('@');
			for(i=0;i<sBusinessTypeInfo.length-1;i=i+2){
				sBusinessTypeValue=sBusinessTypeValue+sBusinessTypeInfo[i]+";" ;
			}
			for(i=1;i<sBusinessTypeInfo.length-1;i=i+2){
				sBusinessTypeName = sBusinessTypeName + sBusinessTypeInfo[i]+";"
			}
			setItemValue(0,getRow(),"BusinessType",sBusinessTypeValue);
			setItemValue(0,getRow(),"BusinessTypeName",sBusinessTypeName);				
		}
    }


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	/*~[Describe=����������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{

		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelectNew.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo.search("OK") >0){
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
		}else{
			if(sIndustryTypeInfo == "NO")
			{
				setItemValue(0,getRow(),"IndustryType","");
				setItemValue(0,getRow(),"IndustryTypeName","");
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
				sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
	
				sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelectNew.jsp?IndustryTypeValue="+sIndustryTypeValue+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
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
		}
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ENT_SCOPE_STANDARD";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	//var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
