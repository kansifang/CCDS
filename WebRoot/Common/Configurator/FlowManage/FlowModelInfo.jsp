<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    ������Ϣ����
			Input Param:
	                    FlowNo��    ���̱��
	                    PhaseNo��   �׶α��
	 		Output param:
			                
			History Log: 
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";
	
	//����������	
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
    if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders={
	{"FlowNo","���̱��"},
	{"PhaseNo","�׶κ�"},
	{"PhaseType","�׶�����"},
	{"PhaseName","�׶�����"},
	{"PhaseDescribe","�׶�����"},
	{"PhaseAttribute","�׶�����"},
	{"PreScript","ǰ��ִ��Script1"},
	{"InitScript","��سа���Script"},
	{"ChoiceDescribe","�������"},
	{"ChoiceScript","�������Script"},
	{"ActionDescribe","��������"},
	{"ActionScript","��������Script"},
	{"PostScript","�����׶�Scripit"},
	{"Attribute1","��ǰ�������ܰ�ť"},
	{"Attribute2","����ɹ������ܰ�ť"},
	{"Attribute3","����鿴Ȩ�޷�ʽ"},
	{"Attribute4","���Ȩ�޽׶�"},
	{"Attribute5","�鿴��Ȩ��ɫ"},
	{"Attribute6","���鿴�Լ�ǩ���������Ӧ�Ľ׶�"},
	{"Attribute7","��ͼ"},
	{"Attribute8","ǩ��������ID"},
	{"Attribute9","����9"},
	{"Attribute10","����10"},
	{"AAEnabled","�Ƿ�������Ȩ"},
	{"AApointInitScript","������Ȩ��ʼ��"},
	{"AApointComp","������Ȩ���ID"},
	{"AApointCompUrl","������Ȩ���URL"}
		};

	sSql = "Select "+
	"FlowNo,"+
	"PhaseNo,"+
	"PhaseType,"+
	"PhaseName,"+
	"PhaseDescribe,"+
	"PhaseAttribute,"+
	"PreScript,"+
	"InitScript,"+
	"ChoiceDescribe,"+
	"ChoiceScript,"+
	"ActionDescribe,"+
	"ActionScript,"+
	"PostScript,"+
	"Attribute1,"+
	"Attribute2,"+
	"Attribute3,"+
	"Attribute4,"+
	"Attribute5,"+
	"Attribute6, "+
	"Attribute7, "+
	"Attribute8, "+
	"Attribute9, "+
	"Attribute10, "+
	"AAEnabled, "+
	"AApointInitScript, "+
	"AApointComp, "+
	"AApointCompUrl "+
	"From FLOW_MODEL "+
	"where FlowNo='"+sFlowNo+"' "+
	"And PhaseNo = '"+sPhaseNo+"'";	
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_MODEL";
	doTemp.setKey("FlowNo,PhaseNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("PhaseNo"," style={width:60px} ");
	doTemp.setHTMLStyle("PhaseName"," style={width:100px} ");

	sSql = " select ItemNo,ItemName from CODE_LIBRARY where IsInUse='1' and CodeNo in (select trim(ItemDescribe) from CODE_LIBRARY where CodeNo='ApplyType' and trim(ItemNo) in (select FlowType from FLOW_CATALOG where FlowNo='"+sFlowNo+"'))";
	doTemp.setDDDWSql("PhaseType",sSql);
	doTemp.setDDDWCode("Attribute3","OpinionViwRightType");
	doTemp.setDDDWCode("AAEnabled","YesNo");

	doTemp.setRequired("PhaseNo,PhaseType",true);   //������
	//���ù��ø�ʽ

	doTemp.setEditStyle("PreScript,InitScript,ChoiceDescribe,ChoiceScript,ActionDescribe,ActionScript,PostScript,Attribute1,Attribute2,Attribute4,Attribute5,Attribute6","3");
	doTemp.setHTMLStyle("PreScript,InitScript,ChoiceDescribe,ChoiceScript,ActionDescribe,ActionScript,PostScript,Attribute1,Attribute2,Attribute4,Attribute5,Attribute6"," style={width:600px;height:100px;overflow:auto} style={width=600px;height=100px;overflow:scroll}");

	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sPhaseNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
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
			{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
			{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
    
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
        as_save("myiframe0","doReturn('Y');");
        
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
        as_save("myiframe0","newRecord()");
        
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FlowNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        OpenComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+sFlowNo,"_self","");
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			if ("<%=sFlowNo%>" !="") 
			{
				setItemValue(0,0,"FlowNo","<%=sFlowNo%>");
			}
			bIsInsert = true;
		}
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
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
