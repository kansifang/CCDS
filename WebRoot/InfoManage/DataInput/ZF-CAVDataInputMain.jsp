<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu  2005.03.25
		Tester12:
		Content: �����ʲ�����Ǽ�������
		Input Param:
		Output param:
		History Log: Changed by slliu 2005.03.02
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ�����Ǽ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����ʲ�����Ǽ�������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	ASResultSet rs1;
	ASResultSet rs;
	String sSql="";
	String sCurItemName="";
	//���ҳ�����	
	
    //����������	 
	 //���Ǳ�־sReinforceFlag��ʾ�Ӳ�ͬ���б����
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="010";	
	    
	
	if(sReinforceFlag.equals("010"))
	{
		sSql = "select count(*) from BUSINESS_CONTRACT where (BusinessType like '[1,2,5]%' or BusinessType is null or BusinessType ='') and ReinforceFlag = '010' and ManageOrgID ='"+CurOrg.OrgID+"' and (DeleteFlag =''  or  DeleteFlag is null) and FinishType like '060%' ";
		sCurItemName = "�貹���Ŵ�ҵ��";
	}
	
	if(sReinforceFlag.equals("020"))
	{
		sSql = "select count(*) from BUSINESS_CONTRACT where (BusinessType like '[1,2,5]%' or BusinessType is null or BusinessType ='') and ReinforceFlag = '020' and ManageOrgID ='"+CurOrg.OrgID+"' and (DeleteFlag =''  or  DeleteFlag is null) and FinishType like '060%'";
		sCurItemName = "��������Ŵ�ҵ��";
	}
	
		
	rs1=Sqlca.getASResultSet(sSql);
	rs1.next();
	sCurItemName+= "("+rs1.getInt(1)+")��";
	rs1.getStatement().close();	
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����ʲ�����Ǽ�������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	//String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CAVDataInputMain'";

	//tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	sSql = "select SortNo,ItemName,ItemNo,ItemDescribe from CODE_LIBRARY where CodeNo= 'CAVDataInputMain' Order By SortNo";
		
	rs=Sqlca.getASResultSet(sSql);
	
	String sSortNo="";
	String sItemName="";
	String sItemNo="";
	String sItemDescribe="";
	while(rs.next())
	{
		sSortNo = rs.getString("SortNo");
		sItemName = rs.getString("ItemName");
		sItemNo = rs.getString("ItemNo");
		sItemDescribe = rs.getString("ItemDescribe");
		if (sSortNo.equals("010"))	//�貹�Ǻ����ʲ�
		{
			sSql = "select count(*) from BUSINESS_CONTRACT where (BusinessType like '[1,2,5]%' or BusinessType is null or BusinessType ='') and ReinforceFlag = '010' and ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgId='"+CurOrg.OrgID+"') and (DeleteFlag =''  or  DeleteFlag is null) and FinishType like '060%' ";
						
			sItemName += "("+Sqlca.getString(sSql)+")��"; 
			tviTemp.insertPage(sSortNo,"root",sItemName,sItemNo,"",0);
		}else if (sSortNo.equals("020")) 	//������ɺ����ʲ�
		{
			sSql = "select count(*) from BUSINESS_CONTRACT where (BusinessType like '[1,2,5]%' or BusinessType is null or BusinessType ='') and ReinforceFlag = '020' and ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgId='"+CurOrg.OrgID+"') and (DeleteFlag =''  or  DeleteFlag is null) and FinishType like '060%' ";
			
			sItemName += "("+Sqlca.getString(sSql)+")��"; 
			tviTemp.insertPage(sSortNo,"root",sItemName,sItemNo,"",0);
		}
		
	}
	rs.getStatement().close();
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 

	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		//ItemNo=010�貹�Ǻ����ʲ���020������ɺ����ʲ�
		var sItemNo = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		
		if(sItemNo!="root")
		{
			if(typeof(sItemNo)!="undefined" && sItemNo.length > 0)
			{
				OpenComp("CAVInputCreditList","/InfoManage/DataInput/CAVInputCreditList.jsp","ComponentName="+sCurItemName+"&ReinforceFlag="+sItemNo,"right");
			}
			setTitle(getCurTVItem().name);
		}
	}



	//����������ı���
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script language="JavaScript">
		startMenu();
		expandNode('root');
		
		OpenComp("CAVInputCreditList","/InfoManage/DataInput/CAVInputCreditList.jsp","ComponentName=�貹���Ŵ�ҵ��&ReinforceFlag=<%=sReinforceFlag%>","right");
		setTitle("<%=sCurItemName%>");
	
		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
