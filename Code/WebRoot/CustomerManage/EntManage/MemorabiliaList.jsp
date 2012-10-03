<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --fbkang 2005-7-26 
		Tester:
		Describe: --�ͻ����¼�
		Input Param:
			CustomerID��--��ǰ�ͻ����
		Output Param:
			CustomerID��--��ǰ�ͻ����
			SerialNo:  --��ǰ��ˮ��
			EditRight: --�༭Ȩ��
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ����¼��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������


	//���ҳ�����	
	
	//����������	���ͻ�����
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%	
	String sHeaders[][] = { {"CustomerID","�ͻ����"},
	                        {"SerialNo","��ˮ��"},
				            {"OccurDate","��������"},
				            {"EventType","�¼�����"},
				            {"EventTypeName","�¼�����"},
							{"StateBeforeChange","���ǰ״̬"},
				            {"StateAfterChange","�����״̬"},
				            {"EventName","�¼�����"},
							{"EventDescribe","�¼�������ԭ��"},
						    {"OrgName","�Ǽǻ���"},
						    {"UserName","�Ǽ���"}
			      };   	
			      	   		
	String sSql =	" select CustomerID,SerialNo,OccurDate, getItemName('EventType',EventType) as EventTypeName," +
					" getItemName('EventType2',EventType) as EventName,EventDescribe,"+
					" InputOrgId,GetOrgName(InputOrgId) as OrgName ,"+
					" InputUserId,GetUserName(InputUserID) as UserName " +
					" from CUSTOMER_MEMO " +
					" where CustomerID = '"+sCustomerID+"' "+
					" and EventType <> 'LC' ";	
	
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//�����޸ı���
	doTemp.UpdateTable = "CUSTOMER_MEMO";
	//��������
	doTemp.setKey("CustomerID,SerialNo",true);	 //Ϊ�����ɾ��
	doTemp.setCheckFormat("OccurDate","3");
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,SerialNo,InputOrgId,InputUserId",false);
	doTemp.setVisible("StateBeforeChange,StateAfterChange,EventType,EventName",false);
	//ͨ�������ⲿ�洢�����õ����ֶ�
	//���ò����޸���
	doTemp.setUpdateable("UserName,OrgName,EventName",false);
	//�����п��   
	doTemp.setHTMLStyle("UserName,CustomerName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName,EventTypeName" ,"style={width:200px} ");	
	doTemp.setAlign("OccurDate,EventTypeName,EventName","2");
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
		{"true","","Button","����","�����ͻ����¼���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�ͻ����¼�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ͻ����¼���Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/MemorabiliaInfo.jsp?EditRight=02","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
	    sUserID=getItemValue(0,getRow(),"InputUserId");//--�û�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--�ͻ�����		
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
		}else alert(getHtmlMessage('3'));		
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sUserID=getItemValue(0,getRow(),"InputUserId");//--�û�����
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");//--�ͻ�����
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ǰ��ˮ����
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{       
			OpenPage("/CustomerManage/EntManage/MemorabiliaInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
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
