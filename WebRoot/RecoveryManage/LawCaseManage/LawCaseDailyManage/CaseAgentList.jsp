<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: �����������б�
		Input Param:
				SerialNo:�������				      
		Output param:
				
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";	
	
	//������������������ˮ�ţ�	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectType.equals("BadBizApply"))
	{
		sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("LawCaseSerialNo"));
		if(sSerialNo == null) sSerialNo = "";
	}
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"ObjectNo","�������"},
							{"SerialNo","��¼��ˮ��"},							
							{"PersonName","����������"},
							{"TakePartPhaseName","����׶�"},					
							{"AgentTypeName","����������"},
							{"OrgName","�����������"},				
							{"CompetenceNo","�ʸ�֤���"},
							{"PersistNo","ִҵ֤���"},
							{"ContactTel","��ϵ�绰"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},					
							{"InputDate","�Ǽ�����"}							
						}; 
	
	//�Ӱ��������Ա��Ϣ��LAWCASE_PERSONS�а�����Ŷ�Ӧ����Ա��Ϣ
	sSql = 	" select ObjectType,ObjectNo,SerialNo,PersonName,TakePartPhase, "+
			" getItemName('TakePartPhase',TakePartPhase) as TakePartPhaseName,"+
		   	" AgentType,getItemName('PersonType1',AgentType) as AgentTypeName,"+
		  	" OrgName,CompetenceNo,PersistNo,ContactTel,InputUserID, "+
		  	" getUserName(InputUserID) as InputUserName, " +			  
		   	" InputOrgID,getOrgName(InputOrgID) as InputOrgName,InputDate " +
			" from LAWCASE_PERSONS " +
			" where PersonType='03' " +	//��Ա���01-���������ˡ�02-��Ժ����Ա��03-������
			" and ObjectNo = '"+sSerialNo+"' "+
			" order by InputDate desc " ;	//������ˮ��
			
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAWCASE_PERSONS";	
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);	 //���ùؼ���
	
	//����ѡ��˫�����п�
	doTemp.setHTMLStyle("PersonName,OrgName"," style={width:140px} ");
	doTemp.setHTMLStyle("CompetenceNo"," style={width:80px} ");
	doTemp.setHTMLStyle("PersistNo"," style={width:80px} ");
	doTemp.setHTMLStyle("InputUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");
	
	//���ù��ø�ʽ
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,AgentType,TakePartPhase,TakePartRole",false);	
	doTemp.setVisible("TakePartPhase,TakePartRoleName,InputUserID,InputOrgID",false);	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/CasePersonsInfo.jsp?ObjectNo=<%=sSerialNo%>&PersonType=03&SerialNo=","right","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ü�¼��ˮ�š��������
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/CasePersonsInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&PersonType=03","right","");
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
