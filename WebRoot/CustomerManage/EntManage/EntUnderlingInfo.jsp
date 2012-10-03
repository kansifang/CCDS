<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --xhyong 2009/08/13
		Tester:
		Describe: --��Ҫ������ҵ����;
		Input Param:
			CustomerID��--��ǰ�ͻ����
			RelativeID��--�����ͻ���֯��������
			Relationship��--������ϵ	
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��		
		Output Param:

		HistoryLog:			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ҫ������ҵ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
     String sSql = "";
     
	//����������,�ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//���ҳ������������ͻ����롢������ϵ���༭Ȩ��
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	if(sCustomerScale == null) sCustomerScale = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {		
								{"CustomerName","��ҵ����"},
								{"InvestmentProp","�عɱ���(%)"},
								{"InvestmentSum","ע���ʱ�"},
								{"Describe","��Ҫ��Ӫ��Χ"},
								{"Remark","��ע"},
								{"OrgName","�������"},
								{"UserName","������"},
								{"InputDate","��������"},
								{"UpdateDate","��������"}
						  };

	      sSql =	" select CustomerID,RelativeID,CustomerName, "+
					" RelationShip,InvestmentProp,InvestmentSum,Describe,Remark, "+
					" InputUserId,getUserName(InputUserId) as UserName,InputOrgId, "+
					" getOrgName(InputOrgId) as OrgName,InputDate,UpdateDate "+
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' " +
					" and RelativeID='"+sRelativeID+"' " +
					" and RelationShip='"+sRelationShip+"' " ;

	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ,���±���,��ֵ,������,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	//�����޸ĵı�
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//��������
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
    //�����޸ĵ���
	doTemp.setRequired("CustomerName,InvestmentProp",true);   //Ӧ������Ҫ�޸�
	//�����в��ɼ�
	doTemp.setVisible("CustomerID,RelativeID,RelationShip,InputUserId,InputOrgId",false);
	//���ò����޸ĵ���
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setLimit("Remark",200);
	//�����ֶθ�ʽ
	doTemp.setType("InvestmentSum,InvestmentProp","Number");
	doTemp.setCheckFormat("InvestmentProp","2");
	doTemp.setAlign("InvestmentSum��InvestmentProp","3");
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	//ע��,����HTMLStyle������ReadOnly������ReadOnly������ 
	doTemp.setHTMLStyle("Describe"," style={width:200px}");
	doTemp.setHTMLStyle("UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);
	
	//������������Դ
	doTemp.setDDDWCode("CertType","CertType");

	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input type=button class=inputdate value=.. onclick=parent.selectCustomer()><font color=red>(�����ѡ)</font>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
	
	//����ʵ��Ͷ�ʽ��(Ԫ)��Χ
	doTemp.appendHTMLStyle("InvestmentSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ע���ʱ�������ڵ���0��\" ");
	//���ó��ʱ���(%)��Χ
    doTemp.appendHTMLStyle("InvestmentProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�عɱ���(%)�ķ�ΧΪ[0,100]\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//���ò���͸����¼������������͸���
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,#LoanCardNo,#InputUserId)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");
  
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{(sEditRight.equals("02")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;	
		if(bIsInsert){
			//����ǰ���м��,���ͨ�����������,���������ʾ
		    if (!RelativeCheck()) return;
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntUnderlingList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		var sRelationShip   = getItemValue(0,getRow(),"RelationShip");//--������ϵ
		OpenPage("/CustomerManage/EntManage/EntUnderlingInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
	    //���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������			
		setObjectValue("SelectOwner","","@RelativeID@0@CustomerName@1",0,0,"");	    
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");//--��ǰ����
		setItemValue(0,0,"UpdateDate",sDay);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"RelationShip","5601");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{		
		//���֤������Ƿ���ϱ������
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//֤������
		
		
		//���¼��Ŀͻ��Ƿ�Ϊ�䱾��
		sCustomerID   = getItemValue(0,0,"CustomerID");	//�ͻ����
		sRelativeID   = getItemValue(0,0,"RelativeID");//--�����ͻ�����
		if (typeof(sRelativeID) != "undefined" && sRelativeID != '')
		{
			if(sCustomerID == sRelativeID)	
			{
				alert(getBusinessMessage('141'));//¼��Ŀͻ�����Ϊ�䱾��
				return false;
			}
		}
		
		return true;
	}

	/*~[Describe=������ϵ����ǰ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function RelativeCheck()
	{			
		sCustomerID   = getItemValue(0,0,"CustomerID");//--�ͻ�����		
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//֤������		
		sRelationShip = getItemValue(0,0,"RelationShip");//--������ϵ
		if (typeof(sRelationShip) != "undefined" && sRelationShip != '')
		{			
			var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sMessage)=="undefined" || sMessage.length==0) {
				return false;	
			}	
			setItemValue(0,0,"RelativeID",sMessage);
		}
		return true;
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
