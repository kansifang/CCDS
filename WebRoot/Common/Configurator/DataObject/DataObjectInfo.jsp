<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: �������Ϣ����
		Input Param:
                    DoNo��      ���ݶ�����
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));

	if(sDoNo==null) sDoNo="";

	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders={
			{"DONO","DO���"},
			{"DONAME","DO����"},
			{"DODESCRIBE","DO����"},
			{"DOTYPE","DO���"},
			{"DOARGUMENTS","DO����"},
			{"DOATTRIBUTE","DO����"},
			{"DOUPDATETABLE","����Ŀ���"},
			{"DOUPDATEWHERE","���·�ʽ"},
			{"DOFROMCLAUSE","DOFrom�Ӿ�"},
			{"DOWHERECLAUSE","DOWhere�Ӿ�"},
			{"DOGROUPCLAUSE","DOGroup�Ӿ�"},
			{"DOORDERCLAUSE","DOOrder�Ӿ�"},
			{"REMARK","��ע"},
			{"DOCLASS","����"},
			{"MODIFYAUDITTABLE","�޸���Ʊ�"},
			{"MODIFYMODECRITERIA","�޸��������"},
			{"DELETEAUDITTABLE","ɾ����Ʊ�"},
			{"DELETEMODECRITERIA","ɾ���������"},
			{"ISINUSE","��Ч"},
		};

	sSql = "Select "+
			"DONO,"+
			"DONAME,"+
			"DODESCRIBE,"+
			"DOTYPE,"+
			"DOARGUMENTS,"+
			"DOATTRIBUTE,"+
			"DOUPDATETABLE,"+
			"DOUPDATEWHERE,"+
			"DOFROMCLAUSE,"+
			"DOWHERECLAUSE,"+
			"DOGROUPCLAUSE,"+
			"DOORDERCLAUSE,"+
			"REMARK,"+
			"DOCLASS,"+
			"MODIFYAUDITTABLE,"+
			"MODIFYMODECRITERIA,"+
			"DELETEAUDITTABLE,"+
			"DELETEMODECRITERIA,"+
			"ISINUSE "+
			"From DATAOBJECT_CATALOG Where DoNo = '"+sDoNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="DATAOBJECT_CATALOG";
	doTemp.setKey("DONO",true);
	doTemp.setHeader(sHeaders);

	doTemp.setDDDWCode("DOTYPE","DOType");
	doTemp.setDDDWCode("DOUPDATEWHERE","DoUpdateWhere");
	doTemp.setDDDWCode("DOCLASS","DOClass");
	doTemp.setDDDWCode("ISINUSE","IsInUse");

	doTemp.setHTMLStyle("DONAME"," style={width:150px} ");
	doTemp.setHTMLStyle("DONO"," style={width:120px} ");
	doTemp.setHTMLStyle("DODESCRIBE,DOWHERECLAUSE,DOGROUPCLAUSE,DOORDERCLAUSE"," style={width:600px} ");

	doTemp.setEditStyle("REMARK","3");
	doTemp.setHTMLStyle("REMARK"," style={height:100px;width:600px;overflow:scroll} ");
 
 	doTemp.setRequired("DONO",true);
	if (sDoNo.equals("") || sDoNo.equals("null")) 
	{
 	  	doTemp.setRequired("DONO",true);
		doTemp.setReadOnly("DONO",false);
 	  	
	}else{
		doTemp.setRequired("DONO",false);
		doTemp.setReadOnly("DONO",true);
	}
	//filter��������
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateDOUpdateTime("+StringFunction.getTodayNow()+","+CurUser.UserID+","+sDoNo+")");

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
	    as_save("myiframe0","");
	}
    
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
            setItemValue(0,0,"DOCLASS","10");
            setItemValue(0,0,"ISINUSE","1");
            
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
