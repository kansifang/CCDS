<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zrli 2009-8-20
		Tester:
		Content: ������Ȩ�����б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ȩ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//��ȡ�������
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "";
	//��ȡҳ�����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "OrgAuthList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //���ӹ�����	
	doTemp.setColumnAttribute("OrgID,BusinessType,RoleID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sOrgID);
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
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}, 
		{"true","","Button","����������Ȩ(����ʹ��)","����������Ȩ","batchUpdate()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        OpenPage("/SystemManage/GeneralSetup/OrgAuthInfo.jsp","_self","");            
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sOrgID = getItemValue(0,getRow(),"OrgID");
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(sOrgID)=="undefined" || sOrgID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		OpenPage("/SystemManage/GeneralSetup/OrgAuthInfo.jsp?CurOrgID="+sOrgID+"&SerialNo="+sSerialNo,"_self","");        
	}
    
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID) == "undefined" || sOrgID.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	/*~[Describe=����������Ȩ��Ϣ;InputParam=��;OutPutParam=��;]~*/	
	function batchUpdate(){
		var sAttribute1 = PopPage("/SystemManage/GeneralSetup/SelectGeneral.jsp?rand="+randomNumber(),"","dialogWidth=70;dialogHeight=36;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
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