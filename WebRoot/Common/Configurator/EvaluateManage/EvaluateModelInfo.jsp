<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    ����ģ������
			Input Param:
	                    ModelNo��    �����¼���
	                    ItemNo��   �׶α��
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
		String PG_TITLE = "����ģ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
    if(sModelNo==null) sModelNo="";
	if(sItemNo==null) sItemNo="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
					{"ModelNo","��������"},
					{"ItemNo","��Ŀ���"},
					{"DisplayNo","��ʾ���"},
					{"ItemName","��Ŀ����"},
					{"ItemAttribute","��Ŀ����"},
					{"ValueMethod","ȡֵ����"},
					{"ValueCode","ȡֵ����"},
					{"ValueType","ֵ����"},
					{"EvaluateMethod","��������"},
					{"Coefficient","ϵ��"},
					{"Remark","��ע"},
	       		   };  

	sSql = " Select  "+
		"ModelNo,"+
		"ItemNo,"+
		"DisplayNo,"+
		"ItemName,"+
		"ItemAttribute,"+
		"ValueMethod,"+
		"ValueCode,"+
		"ValueType,"+
		"EvaluateMethod,"+
		"Coefficient,"+
		"Remark "+
		"From EVALUATE_MODEL Where ModelNo = '"+sModelNo+"' And ItemNo = '"+sItemNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="EVALUATE_MODEL";
	doTemp.setKey("ModelNo,ItemNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setReadOnly("ModelNo",true);
	doTemp.setVisible("ModelNo",false);
	
	doTemp.setHTMLStyle("ItemNo,DisplayNo,ValueType,Coefficient"," style={width:60px} ");
	doTemp.setHTMLStyle("ItemName"," style={width:200px} ");
	doTemp.setHTMLStyle("ItemAttribute"," style={width:160px} ");
	doTemp.setHTMLStyle("ValueCode"," style={width:160px} ");
	doTemp.setEditStyle("ValueMethod,EvaluateMethod,Remark","3");
	doTemp.setHTMLStyle("ValueMethod"," style={height:150px;width:600px;overflow:scroll} ");
	doTemp.setHTMLStyle("EvaluateMethod,Remark"," style={height:100px;width:600px;overflow:scroll} ");

	//����С����ʾ״̬,
	doTemp.setAlign("Coefficient","3");
	doTemp.setType("Coefficient","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("Coefficient","2");
	
	doTemp.setUnit("ValueCode"," <input type=button class=inputdate value=... onclick=parent.SelectCode(\"ALL\")>");
	doTemp.setUnit("ValueType","�����磺Number��String��");

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
			{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
			// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
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
    var sCurModelNo=""; //��¼��ǰ��ѡ���еĴ����

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
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        OpenComp("EvaluateModelInfo","/Common/Configurator/EvaluateManage/EvaluateModelInfo.jsp","ModelNo="+sModelNo,"_self","");
	}

	function SelectCode(sType)
	{		
		if(sType == "ALL")
		{			
			setObjectValue("SelectAllCode","","@ValueCode@1",0,0,"");			
		}	
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
            if ("<%=sModelNo%>" !="") 
            {
                setItemValue(0,0,"ModelNo","<%=sModelNo%>");
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
