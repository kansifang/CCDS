<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    ����ģ����Ϣ����
			Input Param:
	                    FlowNo�����̱��
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
		String PG_TITLE = "����ģ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	if(sFlowNo==null) sFlowNo="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders={
	{"FlowNo","���̱��"},
	{"FlowName","��������"},
	{"FlowType","��������"},
	{"FlowDescribe","��������"},
	{"InitPhase","��ʼ�׶�"},
	{"AAEnabled","�Ƿ������Ȩ����"},
	{"AAPolicyName","��Ȩ����"}
		};

	sSql =  " select FlowNo,FlowName,FlowType,FlowDescribe,InitPhase, "+
	" AAEnabled,AAPolicy,getPolicyName(AAPolicy) as AAPolicyName "+
	" from FLOW_CATALOG where FlowNo = '"+sFlowNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_CATALOG";
	doTemp.setKey("FlowNo",true);
	doTemp.setHeader(sHeaders);
	//���ñ�����
	doTemp.setRequired("FlowNo,FlowName,FlowType",true);   
	//����������
	doTemp.setDDDWCode("AAEnabled","YesNo");
	doTemp.setDDDWCode("FlowType","ApplyType");
	//���ò��ɼ���
	doTemp.setVisible("AAPolicy",false);
	//���ò��ɸ���
	doTemp.setUpdateable("AAPolicyName",false);
	doTemp.setReadOnly("AAPolicyName",true);
	//���ø�ʽ	
	doTemp.setHTMLStyle("FlowName"," style={width:300px} ");	
	doTemp.setEditStyle("FlowDescribe","3");
	doTemp.setHTMLStyle("FlowDescribe","style={width=400px;height=150px;}");
   	//���õ���ʽѡ�񴰿�
	doTemp.setUnit("AAPolicyName","<input class=inputdate type=button value=\"...\" onClick=parent.getPolicyID()>");
	
	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = "";
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
			{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath}
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
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
    var sCurFlowNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
        sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1") //�Ƿ������Ȩ����
		{
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0)
			{
				alert("��ѡ����Ȩ������"); 
				return;
			}
		}else
		{
			//������д����Ȩ������Ϊ���ַ���
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
        as_save("myiframe0","");        
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
        sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1") //�Ƿ������Ȩ����
		{
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0)
			{
				alert("��ѡ����Ȩ������"); 
				return;
			}
		}else
		{
			//������д����Ȩ������Ϊ���ַ���
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
        as_save("myiframe0","newRecord()");        
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        OpenComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","_self","");
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	
	/*~[Describe=������Ȩ����ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function getPolicyID()
	{		
		setObjectValue("SelectPolicy","","@AAPolicy@0@AAPolicyName@1",0,0,"");			
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
		    bIsInsert = true;
		}
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
