<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: �������Ϣ����
			Input Param:
	                    OrgID���������
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
	String sSql;
	String sSortNo; //������
	
	//����������	
	
	//���ҳ�����	
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "OrgInfo2";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    //�����ϼ�����ѡ��ʽ
    doTemp.setUnit("RelativeOrgName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getOrgName();\"> ");
	doTemp.setHTMLStyle("RelativeOrgName","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getOrgName()\" ");
	//��ʾ����Ų�����Ϊ������            add by xlsun  Date in 2013-07-31
	if(CurUser.hasRole("000")){
		doTemp.setVisible("SortNo",true);
		doTemp.setRequired("SortNo",true);
	}
	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//��ʱ���Σ������Ժ�ſ�����ֹ�����org_belong������ݶ�ʧ
	//if(!sOrgID.equals(""))//--added by wwhe 2006-11-22 for:�ſ�����
	//	dwTemp.ReadOnly = "1";
		
	
	//��������¼�
	dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#OrgLevel,#SortNo,#RelativeOrgID)");
	dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#OrgLevel,#SortNo,#RelativeOrgID)");
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sOrgID);
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
			{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","���ص��б����","doReturn()",sResourcesPath}		
			};
		
		//��ʱ���Σ������Ժ�ſ�����ֹ�����org_belong������ݶ�ʧ
		
		if(!sOrgID.equals(""))//--added by wwhe 2006-11-22 for:�ſ�����
		{
			sButtons[0][0]="true";
		}
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
    var sCurOrgID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var sOrgID = getItemValue(0,getRow(),"OrgID");
		var sReturn1 = RunMethod("SystemManage","CheckOrgID",sOrgID);
		if(sReturn1>0)
		{
			if(confirm("ȷʵҪ���»�����Ϣ��")){
			}else{
				return;
			}
		}
	    setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
        as_save("myiframe0","");
        
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
    	var sObjectNo = getItemValue(0,getRow(),"OrgID");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
    	parent.closeAndReturn();
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrgName()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
		
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0) 
        {
        	alert("�����������ţ�");
        	return;
        }
		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0) 
        {
        	alert("��ѡ�񼶱�");
        	return;
        }
		sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;		
		setObjectValue("SelectOrg2",sParaString,"@RelativeOrgID@0@RelativeOrgName@1",0,0,"");
		
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getAllOrgName(flag)
	{
		sParaString = "";		
		setObjectValue("SelectAllOrg",sParaString,"@ManageDepartOrgID"+flag+"@0@ManageDepartOrgID"+flag+"Name@1",0,0,"");
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
            setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
            setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            //setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
            //setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
            //setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
            //setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
