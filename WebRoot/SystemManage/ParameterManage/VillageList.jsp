<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zrli
		Tester:
		Describe: ��������
		Input Param:
	              --sComponentName:�������
		Output Param:
		
		HistoryLog: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//--���sql���
	String sComponentName;//--�������
	String sArgumentType;
	String sArgumentType1="";
	String PG_CONTENT_TITLE;
	//���ҳ�����	
	
	//����������	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
	sArgumentType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ArgumentType"));
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";	
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = { 		
								{"SerialNo","�������"},		                   
			                    {"RegionalismName","���������"},
			                    {"FinanceBelongName","��������"}
			               };   				   		
		   		
	sSql = " select SerialNo,RegionalismName,getOrgName(FinanceBelong) as FinanceBelongName from VILLAGE_INFO "+	            
		   " where ";
	String sWhereClause = "";
	if(CurOrg.OrgLevel.equals("0"))
		sWhereClause = " 1=1";
	else
		sWhereClause = " FinanceBelong in (Select BelongOrgID from Org_Belong where OrgID = '"+CurOrg.OrgID+"')";
	sSql += sWhereClause;
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "VILLAGE_INFO";
	//��������
	doTemp.setKey("SerialNo",true);
	//�����ֶεĲ��ɼ�
	//doTemp.setVisible("",false);
	doTemp.setHTMLStyle("RegionalismName"," style={width:250px} ");
	
	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","RegionalismName","");
	
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
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
		   {((CurUser.hasRole("097"))?"false":"true"),"","Button","����","����","my_add()",sResourcesPath},
		   {((CurUser.hasRole("097"))?"false":"true"),"","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		   {"true","","Button","����","�鿴����","viewAndEdit()",sResourcesPath}
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
	function my_add()
	{ 	
	    sArgumentType="<%=sArgumentType%>";
	    OpenPage("/SystemManage/ParameterManage/VillageInfo.jsp?ArgumentType="+sArgumentType,"_self","");
	}	                                                                                                                                                                                                                                                                                                                                                 

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}	

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sArgumentModel = getItemValue(0,getRow(),"ArgumentModel");
		sFlag = "Info";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/SystemManage/ParameterManage/VillageInfo.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag+"&ArgumentModel="+sArgumentModel, "_self","");
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