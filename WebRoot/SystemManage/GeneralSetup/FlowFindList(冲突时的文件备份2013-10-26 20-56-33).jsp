<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: ndeng 2005-04-23
			Tester:
			Describe: ���������ѯ
			Input Param:
		
			Output Param:
		
		
			HistoryLog:
		 */
	%>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "���������ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
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
	
	//����������
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
    if(sFlowNo == null) sFlowNo = "";
    String sMainTable=sFlowNo.equals("ApproveFlow")?"Business_Approve":sFlowNo.equals("PutOutFlow")?"Business_PutOut":"Business_Apply";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = 	{
					   {"SerialNo","������ˮ��"},
					   {"ObjectNo","ҵ����ˮ��"},
					   {"FlowNo","���̺�"},
                               {"FlowName","��������"},
                               {"PhaseNo","���̽׶κ�"},
                               {"PhaseName","���̽׶�����"},
                               {"UserID","�����˺�"}, 
                               {"UserName","������"},                              
                               {"OrgName","�������"},
                               {"BeginTime","��ʼ����"},
                               {"EndTime","��ֹ����"},
                               {"PhaseOpinion1","�ύ���"},
                               {"PhaseAction","��һ�׶�������"},
                               {"CustomerID","�ͻ���"},
                               {"CustomerName","�ͻ�����"},
                               {"OperateOrgName","�������"},
                               {"OperateUserID","�����˺�"},
                               {"OperateUserName","������"},
					};

	
	String sSql = " select BX.CustomerID,BX.CustomerName,"+
		  " FT.SerialNo,FT.ObjectType,FT.ObjectNo,FT.FlowNo,FT.FlowName,FT.PhaseNo,FT.PhaseName, "+
                  " FT.UserID,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime,FT.PhaseOpinion1,FT.PhaseAction,"+
                  " getOrgName(BX.OperateOrgID) as OperateOrgName,BX.OperateUserID,getUserName(BX.OperateUserID) as OperateUserName"+
                  " from Flow_Task FT,"+sMainTable+" BX"+
		  " where FT.ObjectNo=BX.SerialNo"+
		  " and BX.OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "FLOW_TASK";
	doTemp.setKey("SerialNo",true);	 //Ϊ�����ɾ��
	//�����ֶβ��ɼ���
	doTemp.setVisible("ObjectType",false);
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");
	//���ò�ѯ����
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","CustomerID","");
	doTemp.setFilter(Sqlca,"3","CustomerName","");
	doTemp.setFilter(Sqlca,"4","OperateUserName","");
	doTemp.setFilter(Sqlca,"5","PhaseNo","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"6","PhaseName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"7","UserName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"8","OrgName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
    doTemp.parseFilterData(request,iPostChange);   
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //������������
    //doTemp.OrderClause = " group by ObjectNo ";
   	doTemp.OrderClause = " order by FT.ObjectNo desc,FT.SerialNo asc ";
    doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
    if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and FT.FlowNo = '"+sFlowNo+"'";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","��ǰ�׶���Ϣ","����","viewAndEdit1()",sResourcesPath},
			{"true","","Button","ҵ������","ҵ������","viewAndEdit2()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
			{"Business_Apply".equals(sMainTable)?"true":"false","","Button","����������Ϣ","����","viewApprove()",sResourcesPath},
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
	/*~[Describe=�鿴���޸�����(flow_task);InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		//��ȡ�������ͺͶ�����
		var sTaskNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("FlowFindInfo","/SystemManage/GeneralSetup/FlowFindInfo.jsp","TaskNo="+sTaskNo);
		}
		reloadSelf();	
	}
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
        		as_del('myiframe0');
        		as_save('myiframe0'); 
    		}
		}
	}
	/*~[Describe=�鿴���޸ĵ�ǰ�׶����飨flow_object��;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit1()
	{
		//��ȡ�������ͺͶ�����
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("FlowObjectFindInfo","/SystemManage/GeneralSetup/FlowObjectFindInfo.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}
		reloadSelf();
	}
	/*~[Describe=�鿴���޸�ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
		//��ȡ�������ͺͶ�����
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenObject(sObjectType,sObjectNo,"002");
		}
	}
	/*~[Describe=�鿴����ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewApprove()
	{
		//��ȡ�������ͺͶ�����
		var sBASerialNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sBASerialNo)=="undefined" || sBASerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("ApproveQueryList","/InfoManage/QuickSearch/ApproveQueryList.jsp","BASerialNo="+sBASerialNo);
		}
		reloadSelf();
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>


	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
