<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:	ljtao 2008/12/08
			Tester:
			Content: ������Ȩ�б�
			Input Param:
			sObjectType:Special/Normal -- ������Ȩ/һ����Ȩ
			sAuthorType:1/2/3 -- ������Ȩ/������Ȩ/֧����Ȩ
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
		String PG_TITLE = "������Ȩ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sAuthorType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sObjectType == null) sObjectType = "";
	if(sAuthorType == null) sAuthorType = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
					{"SerialNo","��ˮ��"},
		                    {"FinalOrgName","�������"},
		                    {"FinalRoleName","������Ա"},
		                    {"AcceptBillRight","��ǩ�ж�����Ȩ"},
		                    {"ImpawnRight","����ȫ��ж�����Ȩ"},
		                    {"Attribute4","����ȫ��ж�����Ȩ"},
		                    {"Attribute5","ȫ�������Ȩ"},
		                    {"Attribute1","�������������Ȩ"},
		                    {"Attribute2","ѭ����������Ȩ"},
		                    {"Attribute3","�ش������������Ȩ"},
		                    {"InputOrgName","�Ǽǻ���"},
		                    {"InputUserName","�Ǽ���"},
		                    {"InputDate","�Ǽ�����"}
	               };	
	sSql = " select SerialNo,ObjectType,AuthorType, " +
		   " getOrgName(FinalOrg) as FinalOrgName,getRoleName(FinalRole) as FinalRoleName, " +
		   " getItemName('HaveNot',AcceptBillRight) as AcceptBillRight,"+
		   " getItemName('HaveNot',ImpawnRight) as ImpawnRight, "+
		   " getItemName('HaveNot',Attribute4) as Attribute4, "+
		   " getItemName('HaveNot',Attribute5) as Attribute5, "+
		   " getItemName('HaveNot',Attribute1) as Attribute1, "+
		   " getItemName('HaveNot',Attribute2) as Attribute2, "+
		   " getItemName('HaveNot',Attribute3) as Attribute3, "+
		   " getOrgName(InputOrgID) as InputOrgName, "+
		   " getUserName(InputUserID) as InputUserName,InputDate from USER_AUTHORIZATION "+
	       " where ObjectType= '"+sObjectType+"' and AuthorType='"+sAuthorType+"' order by FinalRole";
		   
	//����DataObject				
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б����͸��±���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "USER_AUTHORIZATION"; 
	
    //���ùؼ��ֶ�	
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("ObjectType,AuthorType,FinalRole,AcceptBillRight,Attribute2",false);
	
	if(sAuthorType.equals("1"))
		doTemp.setVisible("FinalOrgName",false);
    //���ɲ�ѯ����	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	
	//����ASDataWindow����
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//����ΪGrid���
	dwTemp.Style="1";
	//����Ϊֻ��
	dwTemp.ReadOnly = "1";
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	//out.println(doTemp.SourceSql); //������仰����datawindow
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}		
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

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/UserAuthManage/UserSpecialInfo.jsp?ObjectType=<%=sObjectType%>&Type=<%=sAuthorType%>","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenPage("/Common/Configurator/UserAuthManage/UserSpecialInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&Type=<%=sAuthorType%>","_self","");
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
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
