<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: ҳ����Ϣ����
		Input Param:
                    PageID��    ������
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	ASResultSet rs=null;
	
	//����������	
	String sPageID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PageID"));
	String sCompID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CompID",10));
	if(sPageID==null) sPageID="";
	if(sCompID==null) sCompID="";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	rs = Sqlca.getASResultSet("select Distinct CompID from REG_COMP_Page where PageID='"+sPageID+"' ");
	if(rs.next())
	{
		sCompID = rs.getString(1);
	}
	rs.getStatement().close();

	String[][] sHeaders = {
		{"PageID","ҳ��ID"},
		{"PageName","ҳ������"},
		{"CompID","���ID"},
		{"PageURL","ҳ��URL"},
		{"DONO","DONO"},
		{"JSPMODEL","JSPMODEL"},
		{"Remark","��ע"},
		{"InputUserName","������"},
		{"InputUser","������"},
		{"InputOrgName","�������"},
		{"InputOrg","�������"},
		{"InputTime","����ʱ��"},
		{"UpdateUserName","������"},
		{"UpdateUser","������"},
		{"UpdateTime","����ʱ��"}
	};
	sSql = "select "+
			"PageID,"+
			"PageName,"+
			"PageURL,"+
			"DoNo,"+
			"JspModel,"+
			"Remark,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputUser,"+
			"getOrgName(InputOrg) as InputOrgName,"+
			"InputOrg,"+
			"InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateUser,"+
			"UpdateTime "+
			"from REG_PAGE_DEF where PageID='" +sPageID+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "REG_PAGE_DEF";
	doTemp.setKey("PageID",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setDDDWCode("JSPMODEL","JSPModel");
	doTemp.setRequired("PageName,CompID",true);

	doTemp.setHTMLStyle("PageID,PageURL,PageName,"," style={width:600px} ");

	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:600px;overflow:scroll} ");
 	doTemp.setLimit("Remark",400);
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputTime,UpdateTime,InputUserName,InputOrgName,UpdateUserName",true);
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
	doTemp.setVisible("DoNo,JspModel,InputUser,UpdateUser,InputOrg",false);

	if(sCompID!=null) doTemp.setDefaultValue("CompID",sCompID);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	if(sCompID!=null && !sCompID.equals("")) dwTemp.setEvent("AfterInsert","!Configurator.InsertCompPage(#PageID,"+sCompID+")");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPageID);
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","ҳ������","ҳ������","generateJspPage()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurPageID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn('Y');");        
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"PageID");
        	parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    function getApp()
    {
        sReturn=popComp("DBConnSelect","/Common/ToolsA/PublicSelect.jsp","TempletNo=SelectDBConn","dialogWidth:320px;dialogHeight:320px;resizable:yes;scrollbars:no");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0 && sReturn!='_NONE_') 
        {
            sReturnValues = sReturn.split("@");
            setItemValue(0,0,"DBConnectionID",sReturnValues[0]);
        
        }
    }
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function initRow()
	{
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
	setItemValue(0,0,"CompID","<%=sCompID%>");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	function generateJspPage()
	{
		sPageID = getItemValue(0,getRow(),"PageID");
		sCompID = getItemValue(0,getRow(),"CompID");
        	if(typeof(sPageID)=="undefined" || sPageID.length==0 || typeof(sCompID)=="undefined" || sCompID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
		sServerRoot = PopPage("/GetServerRootPath.jsp","","");
		sReturn = PopPage("/Common/Configurator/PageManage/GenerateJspPage.jsp?PageID="+sPageID+"&CompID="+sCompID+"&ServerRootPath="+sServerRoot,"","");
		if(sReturn=="succeeded"){
			alert("�ɹ�����ҳ�棡");
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
