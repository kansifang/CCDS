<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   zywei 2005-11-28
			Tester:
			Content: ��ѯ�б���Ϣ����
			Input Param:
	               SelName����ѯ�б�����
	 		Output param:
			                
			History Log: 
		zywei 2007/10/11 ����Attribute4Ϊ�Ƿ���ݼ���������ѯ�����������������ѯ�������Ӧ�ӳ�
	           
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
	
	//���ҳ�����	
	String sSelName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	if(sSelName == null) sSelName = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
		{"SelName","��ѯ����"},
		{"SelDescribe","��ѯ˵��"},
		{"SelType","��ѯ����"},
		{"SelTableName","��ѯ����"},
		{"SelPrimaryKey","����"},
		{"SelBrowseMode","չ�ַ�ʽ"},
		{"SelArgs","����"},
		{"SelHideField","������"},				
		{"SelCode","��ѯʵ�ִ���"},
		{"SelFieldName","�б���ʾ����"},
		{"SelFieldDisp","�б���ʾ���"},
		{"SelReturnValue","������"},
		{"SelFilterField","������"},
		{"MutilOrSingle","ѡ��ģʽ"},
		{"Attribute1","��ʾ�ֶζ��뷽ʽ"},
		{"Attribute2","��ʾ�ֶ�����"},
		{"Attribute3","��ʾ�ֶμ��ģʽ"},
		{"Attribute4","�Ƿ���ݼ���������ѯ"},
		{"IsInUse","�Ƿ���Ч"},
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

	String sSql = 	" Select SelName,SelDescribe,SelType,SelTableName,SelPrimaryKey,SelBrowseMode, "+
			" SelArgs,SelHideField,SelCode,SelFieldName,SelFieldDisp,SelReturnValue, "+
			" SelFilterField,MutilOrSingle,Attribute1,Attribute2,Attribute3,Attribute4,IsInUse,Remark,getUserName(InputUser) as InputUserName, "+
			" InputUser,InputOrg,getOrgName(InputOrg) as InputOrgName,InputTime,UpdateUser, "+
			" getUserName(UpdateUser) as UpdateUserName,UpdateTime "+
			" From SELECT_CATALOG " +
			" Where SelName = '" + sSelName +"' ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="SELECT_CATALOG";
	doTemp.setKey("SelName",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setDDDWCode("IsInUse","IsInUse");
	doTemp.setDDDWCode("Attribute4","YesNo");
	doTemp.setHTMLStyle("SelDescribe,SelArgs,SelFieldName,SelReturnValue,Attribute1,Attribute2,Attribute3"," style={width:400px} ");
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setEditStyle("SelCode,Remark","3");
	doTemp.setHTMLStyle("SelCode,Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",120);
	doTemp.setReadOnly("SelType,SelBrowseMode,MutilOrSingle,InputUserName,InputOrgName,UpdateUserName,InputTime,UpdateTime",true);
 	doTemp.setRequired("SelName,SelDescribe,SelTableName,SelPrimaryKey,SelCode,SelFieldName,SelReturnValue,IsInUse",true);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
  			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSelName);
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
			{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
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
    var sCurClassName=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn();");        
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
		OpenPage("/Common/Configurator/SelectManage/GridSelectList.jsp","_self","");
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{	       
		OpenPage("/Common/Configurator/SelectManage/GridSelectInfo.jsp","_self","");
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
			setItemValue(0,0,"SelType","Sql");
			setItemValue(0,0,"SelBrowseMode","Grid");
			setItemValue(0,0,"MutilOrSingle","Single");
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