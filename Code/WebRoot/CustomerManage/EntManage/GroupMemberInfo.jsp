<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-11-29
		Tester:
		Describe: �������ų�Ա��Ϣ;
		Input Param:
			CustomerID����ǰ�ͻ����
			RelativeID�������ͻ���֯��������
			Relationship��������ϵ
		Output Param:
			CustomerID����ǰ�ͻ����

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ų�Ա��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//���ҳ�����
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {
							{"CustomerName","�������ų�Ա����"},
							{"CertType","�������ų�Ա֤������"},
							{"CertID","�������ų�Ա֤������"},
							{"RelationShip","��Ա����"},
							//{"Whethen1","�Ƿ�ɹ�����"},
							//{"Whethen1","�Ƿ��и����"},
							//{"Whethen2","�Ƿ��и����"},
							//{"Whethen3","�Ƿ��и����"},
							//{"Whethen4","�Ƿ��и����"},
							{"Whethen5","�Ƿ��и����"},
							{"Whethen6","�Ƿ��и����"},
							{"Whethen7","�Ƿ��и����"},
							{"Whethen8","�Ƿ��и����"},
							{"Whethen9","�Ƿ��и����"},
							{"Whethen10","�Ƿ��и����"},
							{"Remark","��ע"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"}
						   };

	String sSql =	" select CustomerName,CustomerID,RelativeID,LoanCardNo, " +
					" CertType,CertID,RelationShip," +
					" Whethen5,Whethen6,Whethen7,Whethen8,Whethen9,Whethen10,Remark," +
					" InputOrgId,getOrgName(InputOrgId) as OrgName,"+
					" InputUserId,getUserName(InputUserId) as UserName,InputDate,UpdateDate "+
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' " +
					" and RelativeID='"+sRelativeID+"' " +
					" and RelationShip ='"+sRelationShip+"'" ;

	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ,���±���,��ֵ,������,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	doTemp.setRequired("RelationShip,CustomerName,CertType,CertID",true);
	doTemp.setVisible("CustomerID,RelativeID,LoanCardNo,InputUserId,InputOrgId,Whethen1",false);
	doTemp.setUpdateable("UserName,OrgName",false);

	//�����ֶθ�ʽ
	doTemp.setEditStyle("Remark","3");
	doTemp.setLimit("Remark",200);
	doTemp.setHTMLStyle("Remark","style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");	
	//ע��,����HTMLStyle������ReadOnly������ReadOnly������
	doTemp.setHTMLStyle("UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setReadOnly("CustomerName,CertType,CertID,OrgName,UserName,InputDate,UpdateDate",true);
	//doTemp.setUnit("Whethen2","��Ȩ�ϻ��߾�Ӫ������ֱ�ӻ��ӿ�����������ҵ���˻���������ҵ���˿��Ƶ� ");
	//doTemp.setUnit("Whethen3","��ͬ������������ҵ���������Ƶ� ");
	//doTemp.setUnit("Whethen4","��ҪͶ���߸��ˡ��ؼ�������Ա�������ϵ���еļ�ͥ��Ա��ֱͬ�ӿ��ƻ��ӿ��Ƶ� ");
	doTemp.setUnit("Whethen5","��������������ϵ�����ܲ������ʼ۸�ԭ��ת���ʲ���������ҵ������ΪӦ��ͬ��ҵ�ͻ��������Ź���� ");
	doTemp.setUnit("Whethen6","ͨ��������Ͷ����֮���Э�飬ӵ����һ��50%���ϵı��Ȩ ");
	doTemp.setUnit("Whethen7","���ݹ�˾�³̻�Э�飬��Ȩ������һ������;�Ӫ���� ");
	doTemp.setUnit("Whethen8","��Ȩ������һ�����»������Ȩ�������Ķ�����Ա ");
	doTemp.setUnit("Whethen9","����һ�����»�����ƻ���ռ50%���ϱ��Ȩ ");
	doTemp.setUnit("Whethen10","���ſͻ��ϲ����� ");
	//����������
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CertType' and ItemNo like 'Ent%'");
	doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='RelationShip' and ItemNo like '04%' and length(ItemNo)>2 ");
	doTemp.setDDDWCode("Whethen5","YesNo");
	doTemp.setDDDWCode("Whethen6","YesNo");
	doTemp.setDDDWCode("Whethen7","YesNo");
	doTemp.setDDDWCode("Whethen8","YesNo");
	doTemp.setDDDWCode("Whethen9","YesNo");
	doTemp.setDDDWCode("Whethen10","YesNo");

	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input class=\"inputdate\" type=button value=... onclick=parent.selectCustomer()>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID",true);
	}

	//�������ݴ���
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform��ʽ

	//���ò���͸����¼������������͸���
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,#LoanCardNo,#InputUserId)+!CustomerManage.AddGroupInfo(#CustomerID,#RelativeID,#InputUserId)");
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
		if(bIsInsert){
			//����ǰ���м��,���ͨ�����������,���������ʾ
		    if (!ValidityCheck()) return;
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
		OpenPage("/CustomerManage/EntManage/GroupMemberList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");
		var sRelationShip   = getItemValue(0,getRow(),"RelationShip");
		OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		sCustomerID = "<%=sCustomerID%>";
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������		
		setObjectValue("SelectDisRelativeMember","CustomerID,"+sCustomerID,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
	}

	
	/*~[Describe=�õ��ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID   = getItemValue(0,getRow(),"CertID");//--֤������
        
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
	        //��ÿͻ�����
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//���ÿͻ����
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"RelativeID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
						//���ô�����
						if(my_array2[n] == "loancardno") 
						{
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			}  
		}
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
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
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
		}
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//���֤������Ƿ���ϱ������
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//--֤������
		
		if(typeof(sCertType) != "undefined" && sCertType != "" )
		{
			//�ж���֯��������Ϸ���
			if(sCertType =='Ent01')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if(!CheckORG(sCertID))
					{
						alert(getBusinessMessage('102'));//��֯������������						
						return false;
					}
				}
			}				
				
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if (!CheckLisince(sCertID))
					{
						alert(getBusinessMessage('156'));//���֤��������				
						return false;
					}
				}
			}
		}
		
		//���¼��Ŀͻ��Ƿ�Ϊ�䱾��
		sCustomerID   = getItemValue(0,0,"CustomerID");	//�ͻ����
		sRelationShip   = getItemValue(0,0,"RelationShip");//--�����ͻ�����		
		var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
		if (typeof(sMessage)=="undefined" || sMessage.length==0) {
			return false;
		}		
		setItemValue(0,0,"RelativeID",sMessage);
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