<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content: ������Ȩ����ҳ��
			Input Param:
			
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
		String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";
	//����������

	//���ҳ�����	
	String sPolicyID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PolicyID",10));
	String sAuthID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthID",10));
	//����ֵת��Ϊ���ַ���
	if(sPolicyID == null) sPolicyID = "";
	if(sAuthID == null) sAuthID = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders = {														
					{"PolicyName","��Ȩ����"},
					{"FlowName","����"},
					{"PhaseName","�׶�"},							
					{"ObjectType","��������"},
					{"ObjectNo","������"},
					{"OrgName","��������"},
					{"UserName","������Ա"},
				  };
	//ͨ����ʾģ�����ASDataObject����doTemp
	sSql = 	" select getPolicyName(PolicyID) as PolicyName,FlowNo, "+
	" getFlowName(FlowNo) as FlowName,PhaseNo, "+
	" getPhaseName(FlowNo,PhaseNo) as PhaseName, "+
	" '' as ObjectType,'' as ObjectNo,getOrgName(OrgID) as OrgName, "+
	" OrgID,'' as UserName,'' as UserID "+
	" from AA_AUTHPOINT "+
	" where AuthID='"+sAuthID+"' "+
	" and PolicyID='"+sPolicyID+"' ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_AUTHPOINT";
	doTemp.setKey("AuthID,PolicyID",true);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ�	
	doTemp.setVisible("FlowNo,PhaseNo,OrgID,UserID",false);
	doTemp.setUnit("ObjectType","�����磺���룭CreditApply���������������ApproveApply����ͬ��BusinessContract��......��");
	doTemp.setUnit("ObjectNo","�����磺������ˮ�ţ��������������ˮ�ţ���ͬ��ˮ�ţ�......��");
	doTemp.setUnit("UserName"," <input type=button value=.. onclick=parent.selectUser()>");
	doTemp.setReadOnly("PolicyName,FlowName,PhaseName,",true);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
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
			{"true","","Button","����","����","testAuthPoint()",sResourcesPath},
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
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function testAuthPoint()
    {
    	var sObjectType = getItemValue(0,0,"ObjectType");
    	var sObjectNo = getItemValue(0,0,"ObjectNo");
    	var sFlowNo = getItemValue(0,0,"FlowNo");
    	var sPhaseNo = getItemValue(0,0,"PhaseNo");
    	var sOrgID = getItemValue(0,0,"OrgID");
    	var sUserID = getItemValue(0,0,"UserID");
    	if(sObjectType == "" || sObjectNo == ""){
    		alert("����ָ��һ�ʲ���ҵ��");
    		return;
    	}
    	PopPage("/Common/Configurator/AAManage/AAPointTestAction.jsp?AuthID=<%=sAuthID%>&PolicyID=<%=sPolicyID%>&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&OrgID="+sOrgID+"&UserID="+sUserID,"","");
    }
    
    /*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser()
	{
		var sOrgID = getItemValue(0,0,"OrgID");
		//���ؿͻ��������Ϣ���û����롢�û�����	
		sParaString = "BelongOrg"+","+sOrgID;
		setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");	
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>

	<script language=javascript>
		
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
