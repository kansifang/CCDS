<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: 
			Input Param:
	                    RoleID��    �������
	                    ItemNo��    ��Ŀ��ţ������ǲ����룩
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
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	
	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sHeaders[][] = {     
						{"ApplyType","��������"},
						{"ObjectType","��������"},
	                            {"ObjectNo","ҵ����ˮ��"},
	                            {"FlowNo","���̺�"},
	                            {"FlowName","������"}, 
	                            {"PhaseType","�׶�����"},
                                {"PhaseNo","�׶κ�"},
                                {"PhaseName","�׶���"},
                                {"OrgID","�������"},
	                            {"OrgName","�������"},
	                            {"UserID","������"},
	                            {"UserName","������"},
	                            {"InputDate","��������"}
					};    	  		   		
	
	
	sSql = " select ApplyType,ObjectType,ObjectNo,FlowNo,FlowName,"+
	  " PhaseType,PhaseNo,PhaseName,"+
              " OrgID,OrgName,UserID,UserName,InputDate"+
              " from Flow_Object " +
              " where ObjectType='"+sObjectType+"'"+
              " and ObjectNo = '"+sObjectNo+"'";
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "Flow_Object";
	doTemp.setKey("ObjectType,ObjectNo",true);	 //Ϊ�����ɾ��

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
			{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�","doReturn()",sResourcesPath}
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
    var sCurRoleID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
       as_save("myiframe0","");
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(){
		//sObjectNo = getItemValue(0,getRow(),"RoleID");
		//parent Ϊ OpenCompDialog.jsp �����кܶ෽������
        //parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.sObjectInfo = "OK";
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
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
            setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
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
