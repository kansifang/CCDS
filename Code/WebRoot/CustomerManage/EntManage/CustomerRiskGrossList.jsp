<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/03
		Tester:
		Describe: ���ŷ��������б�;
		Input Param:
			--CustomerID����ǰ�ͻ����
		Output Param:
			--SerialNo:��ˮ��
			--ObjectNo����ǰ�ͻ����
			--ObjectType����������
			--EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ŷ��������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����	
	
	//����������	����ǰ�ͻ�����,��������
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sCustomerID == null) sCustomerID = "";
	if(sObjectType == null) sObjectType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = {
							  {"AccountMonth","�·�"},
					          {"EvaluateScore","���ŷ�������"},
					          {"OrgName","���㵥λ"},
					          {"UserName","����ͻ�����"}						    
			         	};   		   		
	
	String sSql =	" select ObjectType,ObjectNo,SerialNo,AccountMonth, "+
					" EvaluateScore,OrgID,getOrgName(OrgID) as OrgName, "+
					" UserID,getUserName(UserID) as UserName "+
					" from EVALUATE_RECORD " + 
				    " where ObjectType='RiskGross' and ObjectNo='"+ sCustomerID + "' ";	


    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);	 //Ϊ�����ɾ��
	//���ò��ɼ���
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,OrgID,UserID",false);	    
	doTemp.setAlign("RelationName","2");
	doTemp.setType("EvaluateScore","Number");
	doTemp.setCheckFormat("EvaluateScore","2");
	doTemp.setAlign("EvaluateScore","3");
    doTemp.setHTMLStyle("OrgName","style={width:200px}");	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","����","�������ŷ�������","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴���ŷ�����������","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ�����ŷ�������","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sObjectType = "RiskGross";
		sObjectNo = "<%=sCustomerID%>";	
		sAccountMonth = "<%=StringFunction.getToday().substring(0,7)%>"
		sReturn = RunMethod("CustomerManage","getRiskGross",sObjectType+","+sObjectNo+","+sAccountMonth);
		if(typeof(sReturn) != "undefined" && sReturn != "") {
			OpenPage("/CustomerManage/EntManage/CustomerRiskGrossInfo.jsp?SerialNo="+sReturn+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&EditRight=02", "_self","");
		}
		else{
			OpenPage("/CustomerManage/EntManage/CustomerRiskGrossInfo.jsp?EditRight=02","_self","");
		}	
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");//--�û�����
		sCustomerID = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}	
    	}else
        	alert(getHtmlMessage('3'));	
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sUserID=getItemValue(0,getRow(),"UserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/CustomerRiskGrossInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&EditRight="+sEditRight, "_self","");
		}
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
