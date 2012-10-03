<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --�����ȨͶ����Ϣ;
		Input Param:
			CustomerID��--��ǰ�ͻ����
			RelativeID��--�����ͻ���֯��������
			Relationship��--������ϵ	
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��		
		Output Param:
			
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	��������ʽ				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ȨͶ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sSql="";//���sql���
	//�������������ͻ�����

	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//���ҳ������������ͻ����롢������ϵ���༭Ȩ��
	String sRelativeID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {
							{"CustomerName","Ͷ����ҵ����"},
							{"CertType","Ͷ����ҵ֤������"},
							{"CertID","Ͷ����ҵ֤������"},
							{"RelationShip","Ͷ�ʷ�ʽ"},
							{"FictitiousPerson","Ͷ����ҵ���˴�������"},
							{"LoanCardNo","Ͷ����ҵ������"},
							{"CurrencyType","���ʱ���"},
							{"OughtSum","Ӧ���ʽ��"},
							{"InvestmentSum","ʵ��Ͷ�ʽ��"},
							{"InvestmentProp","���ʱ���(%)"},
							{"InvestDate","Ͷ������"},
							{"InvestYield","��һ��Ͷ������"},
							{"EffStatus","�Ƿ���Ч"},
							{"Remark","��ע"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"}
						   };

	      sSql =	" select CustomerID,RelativeID,CertType,CertID,CustomerName,RelationShip, " +
					" FictitiousPerson,LoanCardNo,CurrencyType,OughtSum,InvestmentSum,InvestmentProp, "+
					" InvestDate,InvestYield,EffStatus,Remark,InputUserId,getUserName(InputUserId) as UserName, "+
					" InputOrgId,getOrgName(InputOrgId) as OrgName,InputDate,UpdateDate "+
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' " +
					" and RelativeID='"+sRelativeID+"' " +
					" and RelationShip ='"+sRelationShip+"'" ;

	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ø��±���
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//���ü�ֵ
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	//���ñ�����
	doTemp.setRequired("CustomerName,RelationShip,CertType,CertID,CurrencyType,OughtSum,InvestmentSum,EffStatus",true);   //Ӧ������Ҫ�޸�
	//���ÿɼ����ɼ�
	doTemp.setVisible("CustomerID,RelativeID,InputUserId,InputOrgId,Remark",false);
	//�����Ƿ�ɸ��µ���
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setUnit("OughtSum,InvestmentSum,InvestYield","Ԫ");
	//�����ֶθ�ʽ
	doTemp.setType("InvestYield,OughtSum,InvestmentSum,InvestmentProp","Number");
	doTemp.setCheckFormat("InvestYield,InvestmentProp","2");
	doTemp.setAlign("InvestmentSum,InvestmentProp","3");
	doTemp.setCheckFormat("InvestDate","3");
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");	
	doTemp.setHTMLStyle("Remark","style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("FictitiousPerson"," style={width:200px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	//ע��,����HTMLStyle������ReadOnly������ReadOnly������
	doTemp.setHTMLStyle("UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	//����������
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='RelationShip' and ItemNo like '02%' and length(ItemNo)>2");
	doTemp.setDDDWCode("CurrencyType","Currency");
	doTemp.setDDDWCode("EffStatus","EffStatus");
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from code_library where Codeno='CertType' and ItemNo like 'Ent%'and isInuse = '1'");
	
	//����Ĭ��ֵ
	doTemp.setDefaultValue("CurrencyType","01");

	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input type=button class=inputdate value=.. onclick=parent.selectCustomer()><font color=red>(�����ѡ)</font>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
        
    //����Ӧ���ʽ��(Ԫ)��Χ
	doTemp.appendHTMLStyle("OughtSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ӧ���ʽ��(Ԫ)������ڵ���0��\" ");
	//����ʵ��Ͷ�ʽ��(Ԫ)��Χ
	doTemp.appendHTMLStyle("InvestmentSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ʵ��Ͷ�ʽ��(Ԫ)������ڵ���0��\" ");
	//���ó��ʱ���(%)��Χ
    doTemp.appendHTMLStyle("InvestmentProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʱ���(%)�ķ�ΧΪ[0,100]\" ");
    //���õ�һ��Ͷ������(Ԫ)��Χ
	doTemp.appendHTMLStyle("InvestYield"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��һ��Ͷ������(Ԫ)������ڵ���0��\" ");
	
        
	//�������ݴ���
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform��ʽ
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
		OpenPage("/CustomerManage/IndManage/IndInvestList.jsp?","_self","");
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
		OpenPage("/CustomerManage/IndManage/IndInvestInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
	    //���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������		
		setObjectValue("SelectInvest","","@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
	}

	
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���źͿͻ�����;InputParam=��;OutPutParam=��;]~*/
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
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
		
		//У��Ͷ�������Ƿ���ڵ�ǰ����
		sInvestDate = getItemValue(0,0,"InvestDate");//Ͷ������
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����		
		if(typeof(sInvestDate) != "undefined" && sInvestDate != "" )
		{
			if(sInvestDate >= sToday)
			{		    
				alert(getBusinessMessage('137'));//Ͷ�����ڱ������ڵ�ǰ���ڣ�
				return false;		    
			}
		}
		
		//���Ͷ����ҵ�������Ƿ���ϱ������
		sLoanCardNo = getItemValue(0,0,"LoanCardNo");//Ͷ����ҵ������
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			//�ж�Ͷ����ҵ������
			if(!CheckLoanCardID(sLoanCardNo))
			{
				alert(getBusinessMessage('139'));//Ͷ����ҵ����������							
				return false;
			}
			
			//����Ͷ����ҵ������Ψһ��
			sCustomerName = getItemValue(0,getRow(),"CustomerName");//Ͷ����ҵ����	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerName+","+sLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('232'));//��Ͷ����ҵ�������ѱ������ͻ�ռ�ã�							
				return false;
			}
		}
		
		//У��ɶ��ĳ��ʱ���(%)֮���Ƿ񳬹�100%
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--����ͻ�����
		sInvestmentProp = getItemValue(0,getRow(),"InvestmentProp");//--���ʱ���(%)
		if(typeof(sInvestmentProp) != "undefined" && sInvestmentProp != "" )
		{
			sStockSum = RunMethod("CustomerManage","CalculateStock",sRelativeID+","+sCustomerID);
			sTotalStockSum = parseFloat(sStockSum) + parseFloat(sInvestmentProp);
			if(sTotalStockSum > 100)
			{
				alert("���ʱ������󣬵��¸���ҵ�����йɶ��ĳ��ʱ���(%)֮�ͳ���100%��");//
				return false;
			}
		}
		
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
		sCertID = getItemValue(0,0,"CertID");//--֤������				
		sRelationShip = getItemValue(0,0,"RelationShip");//--������ϵ
		if (typeof(sRelationShip)!="undefined" && sRelationShip!=0)
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
