<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��Ʒ��������
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ʒ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//-���sql���
	String sSortNo = ""; //--������
	
	//����������	,��Ʒ���
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if(sTypeNo == null) sTypeNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders = {
							{"TypeNo","��Ʒ���"},
							{"SortNo","������"},
							{"TypeName","��Ʒ����"},
							{"IsInUse","�Ƿ���Ч"},
							{"ApplyDetailNo","������ʾģ��"},
							{"ApproveDetailNo","�������������ʾģ��"},
							{"ContractDetailNo","��ͬ��ʾģ��"},
							{"DisplayTemplet","������ʾģ��"},
							{"SubtypeCode","�ſ�֪ͨ��"},
							{"InfoSet","��Ϣ����"},							
							{"TypesortNo","�Ƿ���������"},
							{"Attribute1","�Թ�/��˽"},
							{"Attribute2","��ҵ��Ʒ�ַ���"},
							{"Attribute3","�Ƿ����ҵ��"},
							{"Attribute4","����ҵ���Ƿ����"},
							{"Attribute5","�����Ƿ����"},
							{"Attribute6","�ǲ����Ƿ����"},
							{"Attribute7","���۲���"},
							{"Attribute8","��Ч���˲���"},
							{"Attribute9","��������"},
							{"Attribute10","����ı���"},	
							{"Attribute11","�ر��ĵ�����"},
							{"Attribute12","ȱʡ�߷��յ�"},
							{"Attribute13","����13"},
							{"Attribute14","����14"},
							{"Attribute15","����15"},
							{"Attribute16","����16"},
							{"Attribute17","����17"},
							{"Attribute18","����18"},
							{"Attribute19","����19"},
							{"Attribute20","����20"},
							{"Attribute21","����21"},
							{"Attribute22","����22"},
							{"Attribute23","�Ŵ�ҵ������"},
							{"Attribute24","����ҵ������"},
							{"Attribute25Name","��������/����ҵ������"},
							{"Remark","��ע"},
							{"InputUserName","�Ǽ���"},
							{"InputUser","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputOrg","�Ǽǻ���"},
							{"InputTime","�Ǽ�ʱ��"},
							{"UpdateUserName","������"},
							{"UpdateUser","������"},
							{"UpdateTime","����ʱ��"}
		                 };
	sSql =  " select TypeNo,SortNo,TypeName,IsInUse,ApplyDetailNo,ApproveDetailNo, "+
			" ContractDetailNo,DisplayTemplet,SubtypeCode,Attribute9,TypesortNo,InfoSet, "+
			" Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6, "+
			" Attribute7,Attribute8,Attribute10,Attribute11,Attribute12, "+
			" Attribute13,Attribute14,Attribute15,Attribute16,Attribute17,Attribute18, "+
			" Attribute19,Attribute20,Attribute21,Attribute22,Attribute23,Attribute24, "+
			" Attribute25,getItemName('FinancingType',Attribute25) as Attribute25Name, "+
			" Remark,InputUser,getUserName(InputUser) as InputUserName,InputOrg, "+
			" getOrgName(InputOrg) as InputOrgName,InputTime,UpdateUser, "+
			" getUserName(UpdateUser) as UpdateUserName,UpdateTime "+
		    " from BUSINESS_TYPE "+
		    " where TypeNo = '"+sTypeNo+"'";
		    
    //����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//�����޸ı���
	doTemp.UpdateTable = "BUSINESS_TYPE";
	//��������
	doTemp.setKey("TypeNo",true);
    //���ñ�����
 	doTemp.setRequired("TypeNo,SortNo,TypeName",true);
 	//�����Ʒ��Ų�Ϊ�գ��������޸�
 	if(!sTypeNo.equals(""))
 		doTemp.setReadOnly("TypeNo",true);
    //��������datawindows
	doTemp.setDDDWCode("IsInUse","IsInUse");	
	doTemp.setDDDWCode("Attribute1","EntInd");
	doTemp.setDDDWCode("SubtypeCode","PutOutNotice");
	doTemp.setDDDWCode("TypesortNo,Attribute3,Attribute4,Attribute5,Attribute6","YesNo");	
    doTemp.setDDDWCode("Attribute23","CreditType");
    doTemp.setDDDWCode("Attribute24","LoanType");
    doTemp.setDDDWCode("Attribute2","GeneralBusinessType");
    doTemp.setDDDWSql("Attribute9","select FlowNo,FlowName from FLOW_CATALOG where aaenabled='1' ");
    
    //�����еĿ��
	doTemp.setEditStyle("Remark","3");
	doTemp.setEditStyle("Attribute9","2");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
 	doTemp.setLimit("Remark",120);
 	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	//����ֻ����
	doTemp.setReadOnly("InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	//���ò��ɼ���
	doTemp.setVisible("TypesortNo,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8,Attribute11,Attribute12",false);
	doTemp.setVisible("Attribute23,Attribute24,Attribute25Name",false);
	doTemp.setVisible("InfoSet,InputUser,InputOrg,UpdateUser",false);
	doTemp.setVisible("Attribute13,Attribute14,Attribute15,Attribute16,Attribute17,Attribute18,Attribute19",false);
	doTemp.setVisible("Attribute20,Attribute21,Attribute22,Attribute25",false);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);
	//���ò����޸���    	
	doTemp.setUpdateable("Attribute25Name,InputUserName,InputOrgName,UpdateUserName",false);
	doTemp.setUnit("Attribute25Name"," <input type=button class=inputdate value=.. onclick=parent.selectFinancingType()>");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndBack()",sResourcesPath},
			{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		
	    as_save("myiframe0","doReturn('Y');");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
 		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","newRecord()");      
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"TypeNo");
	    parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
	        OpenComp("ProductTypeInfo","/Common/Configurator/CreditPolicy/ProductTypeInfo.jsp","","_self","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	/*~[Describe=������������/����ҵ������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectFinancingType()
	{
		sParaString = "CodeNo"+",FinancingType";		
		setObjectValue("SelectCode",sParaString,"@Attribute25@0@Attribute25Name@1",0,0,"");
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
