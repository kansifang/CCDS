<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --�ɶ����;
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
	String PG_TITLE = "�ʱ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sSql = "";
	ASResultSet rs = null;
	double dPaiclUpCapital = 0.00;//ʵ���ʱ�
	
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
	sSql = "select PaiclUpCapital from ENT_INFO where CustomerID='"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		dPaiclUpCapital = rs.getDouble("PaiclUpCapital");
	}
	rs.getStatement().close();
	
	String sHeaders[][] = {		
								{"CustomerName","�ɶ�����"},
								{"CertType","�ͻ�֤������"},
								{"CertID","֤������"},
								{"FictitiousPerson","���˴�������"},
								{"LoanCardNo","�ɶ�������"},
								{"RelationShip","���ʷ�ʽ"},
								{"CurrencyType","���ʱ���"},
								{"OughtSum","Ӧ���ʽ��"},
								{"InvestmentSum","ʵ��Ͷ�ʽ��"},
								{"InvestmentProp","���ʱ���"},
								{"InvestmentStatus","���ʵ�λ"},
								{"InvestDate","Ͷ������"},
								{"EffStatus","�Ƿ���Ч"},
								{"Remark","��ע"},
								{"OrgName","�Ǽǻ���"},
								{"UserName","�Ǽ���"},
								{"InputDate","�Ǽ�����"},
								{"UpdateDate","��������"}
						  };

	      sSql =	" select CustomerID,RelativeID,CertType,CertID,CustomerName, "+
					" LoanCardNo,FictitiousPerson,RelationShip,CurrencyType,OughtSum, "+
					" InvestmentSum,InvestmentProp,InvestmentStatus,InvestDate,EffStatus,Remark, "+
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
	doTemp.setKey("CustomerID,RelativeID,CustomerName,RelationShip",true);
    //�����޸ĵ���
	doTemp.setRequired("CustomerName,RelationShip,CertType,CertID,CurrencyType,OughtSum,InvestmentSum,EffStatus",true);   //Ӧ������Ҫ�޸�
	//�����в��ɼ�
	doTemp.setVisible("CustomerID,RelativeID,InputUserId,InputOrgId",false);
	//���ò����޸ĵ���
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setUnit("InvestYield","Ԫ");
	doTemp.setUnit("OughtSum,InvestmentSum","��Ԫ");
	doTemp.setUnit("InvestmentProp","%");
	doTemp.setLimit("Remark",200);
	//�����ֶθ�ʽ
	doTemp.setType("OughtSum,InvestmentSum,InvestmentProp","Number");
	doTemp.setCheckFormat("InvestmentProp","2");
	doTemp.setAlign("OughtSum,InvestmentSum��InvestmentProp","3");
	doTemp.setCheckFormat("InvestDate","3");
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	//ע��,����HTMLStyle������ReadOnly������ReadOnly������
	doTemp.setHTMLStyle("UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setReadOnly("OrgName,InvestmentProp,UserName,InputDate,UpdateDate",true);
	
	//������������Դ
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RelationShip' and ItemNo like '52%' and length(ItemNo)>2 ");
	doTemp.setDDDWCode("CurrencyType","Currency");
	doTemp.setDDDWCode("EffStatus","EffStatus");
	doTemp.setDDDWCode("InvestmentStatus","InvestmentStatus");
	
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
	doTemp.appendHTMLStyle("OughtSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ӧ���ʽ�������ڵ���0��\" ");
	//����ʵ��Ͷ�ʽ��(Ԫ)��Χ
	doTemp.appendHTMLStyle("InvestmentSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ʵ��Ͷ�ʽ�������ڵ���0��\" ");
	doTemp.appendHTMLStyle("InvestmentSum"," onChange=\"javascript:parent.getInvestmentProp()\" mymsg=\"ʵ��Ͷ�ʽ�������ڵ���0��\" ");
	//���ó��ʱ���(%)��Χ
   // doTemp.appendHTMLStyle("InvestmentProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʱ����ķ�ΧΪ[0,100]\" ");
	
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
			{"true","","Button","����","�����ʱ�����","newRecord()",sResourcesPath},
			{(sEditRight.equals("02")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","�ɶ���Ϣ����","�鿴�ɶ���Ϣ����","viewOwnerInfo()",sResourcesPath},
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
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	//add by wlu 2009-02-19
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?EditRight=02","_self","");
	}	

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
	
	/*~[Describe=���عɶ���Ϣ����ҳ��;InputParam=��;OutPutParam=��;]~*/
	//add by wlu 2009-02-19
	function viewOwnerInfo()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		if(typeof(sRelativeID) == "undefined" || sRelativeID == "")
		{
			alert("�Բ�����ѡ��һλ�ɶ���");
			return;
		}		
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sRelativeID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }

        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];
        sReturnValue2 = sReturnValue[1];
        sReturnValue3 = sReturnValue[2];
                        
        if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2")
        {    		
    		openObject("Customer",sRelativeID+"&<%=sCustomerScale%>","001");
    		//reloadSelf();
		}else
		{
		    alert("�Բ�����û�в鿴�ÿͻ���Ȩ�ޣ����ߴ˿ͻ���ϵͳ�ڿͻ���");//�Բ�����û�в鿴�ÿͻ���Ȩ�ޣ�
		}
	}
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntOwnerList.jsp?","_self","");
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
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
	    //���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������			
		setObjectValue("SelectOwner","","@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");	    
	}
	
	/*~[Describe=�Զ���ó��ʱ���;InputParam=��;OutPutParam=��;]~*/
	function getInvestmentProp()
	{
		dInvestmentSum = getItemValue(0,getRow(),"InvestmentSum");//ʵ�ʳ��ʽ��
		dPaiclUpCapital =  "<%=dPaiclUpCapital%>";//ʵ���ʱ�
		if(dPaiclUpCapital!=0.0)
		{
			dInvestmentProp=(dInvestmentSum/dPaiclUpCapital)*100;
			setItemValue(0,getRow(),"InvestmentProp",roundOff(dInvestmentProp,2));
		}
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
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
			setItemValue(0,0,"CurrencyType","01");
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{		
		//���֤������Ƿ���ϱ������
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//֤������
		
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
		
		//У��ɶ�������
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//�ɶ�������	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			if(!CheckLoanCardID(sLoanCardNo))
			{
				alert(getBusinessMessage('230'));//�ɶ�����������							
				return false;
			}
			
			//����ɶ�������Ψһ��
			sCustomerName = getItemValue(0,getRow(),"CustomerName");//�ͻ�����	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerName+","+sLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('231'));//�ùɶ��������ѱ������ͻ�ռ�ã�							
				return false;
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
		
		//У��ɶ��ĳ��ʱ���(%)֮���Ƿ񳬹�100%
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--����ͻ�����
		sInvestmentSum = getItemValue(0,getRow(),"InvestmentSum");//--���ʱ���(%)
		if(typeof(sInvestmentSum) != "undefined" && sInvestmentSum != "" )
		{
			sStockSum = RunMethod("CustomerManage","CalculateStock",sCustomerID+","+sRelativeID);
			if(typeof(sStockSum) == "undefined" && sStockSum == "") sStockSum = 0;
			sTotalStockSum = parseFloat(sStockSum) + parseFloat(sInvestmentSum);
			if(sTotalStockSum > "<%=dPaiclUpCapital%>")
			{
				alert("���йɶ��ĳ��ʽ��֮�Ͳ��ܳ���ʵ���ʱ�");//���йɶ��ĳ��ʱ���(%)֮�Ͳ��ܳ���100%��
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
		sRelationShip   = getItemValue(0,0,"RelationShip");//--������ϵ
		sRelativeID   = getItemValue(0,0,"RelativeID");//--�����ͻ�����
		sCertType  = getItemValue(0,0,"CertType");//--֤������
		sCertID  = getItemValue(0,0,"CertID");//--֤������
		//��ѯϵͳ���Ƿ���ڸ�֤������֤�������Ӧ�Ŀͻ����򷵻�CustomerID��������CustomerID
		if (typeof(sRelationShip) != "undefined" && sRelationShip != '')
		{			
			var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sMessage)!="undefined" && sMessage.length!=0) {
				sRelativeID=sMessage;
			}	
		}
		//����Ƿ�¼���ظ�¼����Ϣ
		if(typeof(sRelativeID) != "undefined" && sRelativeID.length!=0)
		{
			setItemValue(0,getRow(),"RelativeID",sRelativeID);
		}
		sPara = "1,Customer_Relative,String@CustomerID@"+sCustomerID+
					"@String@CertType@"+sCertType+"@String@CertID@"+sCertID+"@String@RelationShip@"+sRelationShip;
		sReturn=RunMethod("PublicMethod","GetColValue",sPara);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			alert("�ùɶ��Ѿ�¼��,��ѡ�������ɶ�!");//�ùɶ��Ѿ�¼��,��ѡ�������ɶ�!				
			return false;
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
