<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ���˴�������Ա�б�;
		Input Param:
			--CustomerID����ǰ�ͻ����
		Output Param:
			--CustomerID����ǰ�ͻ����
			--RelativeID�������ͻ����
			--Relationship��������ϵ
			--EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���˴�������Ա�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����	
	
	//����������	����ǰ�ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = {
							{"CertID","֤������"},
				            {"CustomerName","�����Ա����"},
				            {"RelationName","�����ϵ"},			
						    {"OrgName","�Ǽǻ���"},
						    {"UserName","�Ǽ���"}       						    
			         	  };   		   		
	
	String sSql =	" select CustomerID,RelativeID,RelationShip,CertID,CustomerName, "+
					" getItemName('RelationShip',RelationShip) as RelationName, "+
					" InputOrgId,getOrgName(InputOrgId) as OrgName, "+
					" InputUserId,getUserName(InputUserId) as UserName "+				
					" from CUSTOMER_RELATIVE "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and RelationShip like '06%' "+
					" and length(RelationShip)>2";	


    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);	 //Ϊ�����ɾ��
	doTemp.setAlign("RelationName,CertID,CustomerName,UserName","2");
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,RelativeID,RelationShip,InputUserId,InputOrgId",false);	    
	//ͨ�������ⲿ�洢�����õ����ֶ�
	doTemp.setUpdateable("UserName,RelationName,OrgName",false);   
	doTemp.setHTMLStyle("UserName,CustomerName,InputDate,UpdateDate"," style={width:80px} ");
    doTemp.setHTMLStyle("OrgName"," style={width:200px} ");    	
	//doTemp.setHTMLStyle("UserName"," style={width:200px}");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	//����setEvent
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
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
			{"true","","Button","����","������ż����ͥ��Ҫ��Ա","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴��ż����ͥ��Ҫ��Ա����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ż����ͥ��Ҫ��Ա","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntFamilyInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"InputUserId");//--�û�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
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
		sUserID=getItemValue(0,getRow(),"InputUserId");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		sRelationShip = getItemValue(0,getRow(),"RelationShip");
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/EntFamilyInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight="+sEditRight, "_self","");
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
