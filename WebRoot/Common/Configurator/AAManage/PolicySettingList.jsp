
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/08/25
		Tester:
		Content: ��Ȩ�����б�ҳ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	
	//���ҳ�����	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
							{"PolicyID","����ID"},
							{"PolicyName","��������"},
							{"EffDate","��������"},
							{"EffStatus","��Ч״̬"},
							{"AjudicatorID","��Ȩ������ID"}
						  };
	sSql =  " select PolicyID,PolicyName,EffDate,getItemName('EffStatus',EffStatus) as EffStatus "+
			" from AA_POLICY Where 1 = 1 ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_POLICY";
	doTemp.setKey("PolicyID",true);
	doTemp.setHeader(sHeaders);
		
	doTemp.setColumnAttribute("PolicyName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1 = 1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	//out.println(doTemp.SourceSql); //������仰����datawindow
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
		{"true","","Button","����","�鿴/�޸�����","openWithObjectViewer()",sResourcesPath},
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{		
		popComp("PolicyCreationDialog","/Common/Configurator/AAManage/PolicyCreationInfo.jsp","","dialogwidth:550px;dialogheight:650px");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		//����ID   
	    sPolicyID = getItemValue(0,getRow(),"PolicyID");			
		if (typeof(sPolicyID) == "undefined" || sPolicyID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			sReturn=RunMethod("PublicMethod","GetColValue","AuthID,AA_AUTHPOINT,String@PolicyID@"+sPolicyID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert("��ѡ��Ȩ�����ѱ�ĳЩ��Ȩ�����ã�����ɾ����");
				return;
			}else
			{
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		//����ID  
		sPolicyID = getItemValue(0,getRow(),"PolicyID");		
		if (typeof(sPolicyID) == "undefined" || sPolicyID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		PopComp("EditPolicy","/Common/Configurator/AAManage/PolicySettingInfo.jsp","PolicyID="+sPolicyID,"");
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
