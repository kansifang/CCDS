<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cwliu 2004-12-09
		Tester:
		Describe: Ӫ����Ϣ����
		Input Param:
		
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ӫ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����
	
	//����������
	String sCatalogID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//�ǹ�����Ա��Ȩ�� add by zrli 
	if(!(CurUser.hasRole("086")||CurUser.hasRole("286")||CurUser.hasRole("486"))){
		CurComp.setAttribute("RightType","ReadOnly");
	}
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	String sHeaders[][] = {     {"ID","��Ϣ���"},
	                            {"Title","����"},
	                            {"Demo","����"},
				                {"Source","��Դ"},
				                {"Author","������"},
				                {"CreateDate","��������"},
				                {"ModifiedDate","�޸�����"},
				                {"Hits","�������"},
				                {"Replies","�ظ�����"},
				                {"KnowledgeType","����"}
	                      };
			      		
	String  sSql =  " select KO.ID,CatalogID,Attribute1,"+
					" getItemName('KnowledgeType',Attribute1) as KnowledgeType," +
					" Title,Demo,Source,Author,CreateDate,ModifiedDate,Hits,Replies " +
					" from KNOWLEDGE_CATALOG KC,KNOWLEDGE_OBJECT KO" +
					" where KC.ID=KO.ID and KO.ObjectID='"+sCatalogID+"'  ";


	//��sSql�������ݴ������

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="KNOWLEDGE_CATALOG";
	
	doTemp.setKey("ID",true);
	doTemp.setVisible("ID,CatalogID,Attribute1,Attribute2,Replies,Hits",false);
	
	doTemp.setType("Hits,Replies","Number");
	doTemp.setCheckFormat("Hits,Replies","5");	
	doTemp.setHTMLStyle("CreateDate,ModifiedDate"," style={width:80px} ");
	doTemp.setHTMLStyle("Hits,Replies,KnowledgeType"," style={width:50px} ");
	doTemp.setAlign("KnowledgeType","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//ɾ��������Ϣ
	//dwTemp.setEvent("AfterDelete","!CustomerManage.ɾ����������(#SerialNo)");


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{((CurUser.hasRole("099")||CurUser.hasRole("098")||CurUser.hasRole("097"))?"false":"true"),"","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{((CurUser.hasRole("099")||CurUser.hasRole("098")||CurUser.hasRole("097"))?"false":"true"),"","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{((CurUser.hasRole("099")||CurUser.hasRole("098")||CurUser.hasRole("097"))?"false":"true"),"","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{((CurUser.hasRole("099")||CurUser.hasRole("098")||CurUser.hasRole("097"))?"false":"true"),"","Button","�鿴��������","�鿴��������","viewFile()",sResourcesPath},	
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
		OpenPage("/InfoManage/BBS/KnowledgeInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sID=getItemValue(0,getRow(),"ID");
		if (typeof(sID)=="undefined" || sID.length==0)
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
		sID=getItemValue(0,getRow(),"ID");
		if (typeof(sID)=="undefined" || sID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		OpenPage("/InfoManage/BBS/KnowledgeInfo.jsp?ID="+sID,"_self","");
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
    function viewFile(sBoardNo)
    {
   		sID = getItemValue(0,getRow(),"ID");
    	if (typeof(sID)=="undefined" || sID.length==0)
    	{        
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;         
    	}
    	else{
        	popComp("BoardView","/SystemManage/SynthesisManage/BoardView.jsp","BoardNo="+sID,"","");
        	reloadSelf();
        }	
    }
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
