<%@	page contentType="text/html; charset=GBK"%>
<%@	include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: ����ճ�����;
		Input Param:
					sDealType��010��Ч�Ķ��ҵ��
						020ʵЧ�Ķ��ҵ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ճ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	
	//�������
	String sSql1="";
	String sCondition ="";

	//���ҳ�����
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	//out.println(sDealType+"@@@"+sReinforceFlag+"###"+sBusinessType);
	if (sReinforceFlag==null) sReinforceFlag="";
	//out.println(sBusinessType);
	if (sBusinessType == null) sBusinessType ="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","�����ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"ArtificialNo","�ı�Э����"},
							{"OtherAreaLoanName","���ŷ�ʽ"},
							{"OccurTypeName","��������"},
							{"Currency","����"},
							{"BusinessSum","���Э����(Ԫ)"},
							{"Balance","��ȿ��ý��(Ԫ)"},
							{"CreditFreezeFlag","����Ƿ񶳽�"},
							//{"VouchTypeName","��Ҫ������ʽ"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"OperateOrgName","�������"},
						  };
	String sSql =   " select SerialNo,CustomerName,CustomerID,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" ArtificialNo,"+
					" OtherAreaLoan,getItemName('CreditLineType',OtherAreaLoan) as OtherAreaLoanName,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('YesOrNo',CreditFreezeFlag) as CreditFreezeFlag,"+
					" BusinessSum,PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where InputUserID ='"+CurUser.UserID+"' and SerialNo like 'BC%' ";

	if(sDealType.equals("010"))  //modified by cli 2006-05-14 in Nanjing   ���ǲ��Ƕ�ȵ����
	{
		if (sReinforceFlag.equals("01"))
		{
			sSql1 =" and BusinessType = '"+sBusinessType+"' and (FinishDate ='' or FinishDate is null ) ";
		}
		else
		{
			sSql1 =" and BusinessType = '"+sBusinessType+"' and (FinishDate='' or FinishDate is null) and Maturity <> '' and Maturity is not null and days(current date) <= days(substr(maturity,1,4)||'-'||substr(maturity,6,2)||'-'||substr(maturity,9,2))";
		}
	}else if(sDealType.equals("020"))
	{
		sSql1 =" and BusinessType = '"+sBusinessType+"' and Maturity <> '' and Maturity is not null and ((FinishDate !='' and FinishDate is not null ) or days(current date) > days(substr(maturity,1,4)||'-'||substr(maturity,6,2)||'-'||substr(maturity,9,2)))";
	}
	sSql = sSql + sSql1;
	//out.println(:sSql);
	//out.println(sBusinessType+"@@@@@@@@@@@@"+sReinforceFlag+"##########"+sSql);

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="BUSINESS_CONTRACT";
	doTemp.setKeyFilter("SerialNo");
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("CreditFreezeFlag,CustomerID,BusinessType,OtherAreaLoan,OccurType,BusinessCurrency,VouchType,OperateOrgID,OtherAreaLoanName",false);
	doTemp.setVisible("OccurTypeName",false);
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName,BusinessTypeName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo,BusinessSum,Balance"," style={width:120px} ");
	doTemp.setHTMLStyle("OccurTypeName,OtherAreaLoanName"," style={width:60px} ");
	
    	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo,CustomerName,ArtificialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.setPageSize(15);
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(15);  //��������ҳ 2005/02/25 by ybhe

	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(BusinessContract,#SerialNo,DeleteBusiness)"); 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

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
	String sBtns = "";
	if(sDealType.equals("020"))
	{

			sBtns = "�������,�����ص��ͬ����,�弶����,����ת��,�������ʼ�,����Ѻ�����,������ͬ����,�ƽ���ȫ��";

	}
	else
	{
		if (sReinforceFlag.equals("01"))
		{
			sBtns = "�������,�������Ŷ��,ɾ��";
		}
		else
		{
			sBtns = "�������,�����ص��ͬ����,�弶����,��ֹ,����ת��,�������ʼ�,����Ѻ�����,������ͬ����,�ƽ���ȫ��,�ܻ��ƽ�";
		}
		
	}

	String sButtons[][] = {
		{(sBtns.indexOf("�������")>=0?"true":"false"),"","Button","�������","�������","viewAndEdit()",sResourcesPath},
		//{(sBtns.indexOf("�����ص��ͬ����")>=0?"true":"false"),"","Button","�����ص��ͬ����","�����ص��ͬ����","AddUserDefine()",sResourcesPath},
		//{(sBtns.indexOf("�弶����")>=0?"true":"false"),"","Button","�弶����","�弶����","Classify()",sResourcesPath},
		{(sBtns.indexOf("����")>=0?"true":"false"),"","Button","����","����","freeze()",sResourcesPath},
		{(sBtns.indexOf("�ⶳ")>=0?"true":"false"),"","Button","�ⶳ","�ⶳ","thaw()",sResourcesPath},
		{(sBtns.indexOf("�������Ŷ��")>=0?"true":"false"),"","Button","�������Ŷ��","�������Ŷ��","NewContract()",sResourcesPath},
		{(sBtns.indexOf("����ת��")>=0?"false":"false"),"","Button","����ת��","����ת��","CreditLineShift()",sResourcesPath},
		{(sBtns.indexOf("�������ʼ�")>=0?"true":"false"),"","Button","�������ʼ�","�������ʼ�","WorkRecord()",sResourcesPath},
		{(sBtns.indexOf("����Ѻ�����")>=0?"true":"false"),"","Button","����Ѻ�����","����Ѻ�����","Guaranty()",sResourcesPath},
		{(sBtns.indexOf("������ͬ����")>=0?"true":"false"),"","Button","������ͬ����","������ͬ����","Assure()",sResourcesPath},
		{(sBtns.indexOf("��ֹ")>=0?"true":"false"),"","Button","��ֹ","��ֹ","finished()",sResourcesPath},
		{(sBtns.indexOf("ɾ��")>=0?"true":"false"),"","Button","ɾ��","ɾ��","Delete()",sResourcesPath},
		
//		{(sBtns.indexOf("�ƽ���ȫ��")>=0?"true":"false"),"","Button","�ƽ���ȫ��","�������ʲ��ƽ���ȫ������","ShiftRMDepart()",sResourcesPath},
//		{(sBtns.indexOf("�ܻ��ƽ�")>=0?"true":"false"),"","Button","�ܻ��ƽ�","�ܻ������͹ܻ��˱��","doShift()",sResourcesPath}
	};
	/*
	String sButtons2[][] = {	{(sBtns.indexOf("����ת��")>=0?"false":"false"),"","Button","����ת��","����ת��","CreditLineShift()",sResourcesPath},
		{(sBtns.indexOf("�������ʼ�")>=0?"true":"false"),"","Button","�������ʼ�","�������ʼ�","WorkRecord()",sResourcesPath},
		{(sBtns.indexOf("����Ѻ�����")>=0?"true":"false"),"","Button","����Ѻ�����","����Ѻ�����","Guaranty()",sResourcesPath},
		{(sBtns.indexOf("������ͬ����")>=0?"true":"false"),"","Button","������ͬ����","������ͬ����","Assure()",sResourcesPath},
		{(sBtns.indexOf("�ƽ���ȫ��")>=0?"true":"false"),"","Button","�ƽ���ȫ��","�������ʲ��ƽ���ȫ������","ShiftRMDepart()",sResourcesPath},
		{(sBtns.indexOf("�ܻ��ƽ�")>=0?"true":"false"),"","Button","�ܻ��ƽ�","�ܻ������͹ܻ��˱��","doShift()",sResourcesPath}
		};
	CurPage.setAttribute("Buttons2",sButtons2);
	*/
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		/*
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		*/
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		openObject("ReinforceContract",sObjectNo,"001");
		reloadSelf();	
	}


	/*~[Describe=�������ʼ�;InputParam=��;OutPutParam=��;]~*/
	function WorkRecord()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","ComponentName=�������ʼ�&NoteType=BUSINESS_CONTRACT&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;]~*/
	function NewContract()
	{
		sCompID	 = "ReinforceCreation";
		sCompURL = "/InfoManage/DataInput/ReinforceCreationInfo.jsp";
		sReturn = popComp(sCompID,sCompURL,"BusinessType=<%=sBusinessType%>","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(!(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") )
		{
			sReturn = sReturn.split("@");
			var sObjectNo = sReturn[0];
			/*var sObjectType = "ReinforceContract";
			
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			*/
			openObject("ReinforceContract",sObjectNo,"001");			
		}
		else
		{
			return;
		}
		reloadSelf();
	}

	/*~[Describe=����ת��;InputParam=��;OutPutParam=��;]~*/
	function CreditLineShift()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			sShiftCreditLineNo = selectObjectInfo("BusinessContract","BusinessType=in ('9010')~CustomerID="+sCustomerID+"~Finished=N");
			if(typeof(sShiftCreditLineNo)=="undefined" || length(sShiftCreditLineNo)==0)
				return;
			sReturn = PopPage("/CreditManage/CreditCheck/ShiftCreditLineAction.jsp?SerialNo="+sSerialNo+"&ShiftCreditLineNo="+sShiftCreditLineNo,"","");
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('191'));
			}
			self.location.reload();
		}
	}

	/*~[Describe=�弶����;InputParam=��;OutPutParam=��;]~*/
	function Classify()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("ContractClassifyMain","/CreditManage/CreditCheck/ContractClassifyMain.jsp","ComponentName=�弶����&SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=�����ص��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function AddUserDefine()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		if(confirm(getBusinessMessage('433'))) 
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
		}
	}

	/*~[Describe=������;InputParam=��;OutPutParam=��;]~*/
	function freeze()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{       
			sReturn = PopPage("/CreditManage/CreditCheck/CreditFreezeAction.jsp?SerialNo="+sSerialNo+"&FreezeType=010","","");
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('191'));
			}
			self.location.reload();
		}
	}

	/*~[Describe=�ⶳ���;InputParam=��;OutPutParam=��;]~*/
	function thaw()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{       
			sReturn = PopPage("/CreditManage/CreditCheck/CreditFreezeAction.jsp?SerialNo="+sSerialNo+"&FreezeType=020","","");
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('191'));
			}
			self.location.reload();
		}
	}

	/*~[Describe=��ͬ�ս�;InputParam=��;OutPutParam=��;]~*/
	function finished()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{       
			OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function Delete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}   
		//�ö���Ƿ���Ч
	    var sColName = "serialno";
		var sTableName = "Business_contract";
		var sWhereClause = "String@SerialNo@"+sSerialNo+"@String@InUseFlag@01";
			
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			alert("�������Ч������ɾ����");
			return;
			
		}else
		{
			if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
			{
				as_del('myiframe0');
	            as_save('myiframe0');  //�������ɾ������Ҫ���ô����
				//reloadSelf();
			}
		}
	}

	
	/*~[Describe=������ͬ����;InputParam=��;OutPutParam=��;]~*/
	function Assure()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("AssureView","/CreditManage/CreditPutOut/AssureView.jsp","ComponentName=������ͬ����&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=����Ѻ�����;InputParam=��;OutPutParam=��;]~*/
	function Guaranty()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("GuarantyList","/CreditManage/CreditPutOut/GuarantyList.jsp","ComponentName=����Ѻ�����&ObjectType=BusinessContract&WhereType=020&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	/*~[Describe=�ƽ���ȫ����;InputParam=��;OutPutParam=��;]~*/
	function ShiftRMDepart()
	{
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{       
		
			var sTrace= PopPage("/RecoveryManage/Public/NPAShiftDialog.jsp","","dialogWidth=25;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		
			if(typeof(sTrace)!="undefined" && sTrace.length!=0)
			{
				
				var sTrace=sTrace.split("@");
				
				//����ƽ����͡���ȫ����
				var sShiftType = sTrace[0];
				var sTraceOrgID = sTrace[1];
				var sTraceOrgName = sTrace[2];
				
				if(typeof(sTraceOrgID)!="undefined" && sTraceOrgID.length!=0)
				{
					var sReturn = PopPage("/RecoveryManage/Public/NPAShiftAction.jsp?SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"&TraceOrgID="+sTraceOrgID+"","","");
					if(sReturn == "true") //ˢ��ҳ��
					{
						alert("�ò����ʲ��ɹ��ƽ�����"+sTraceOrgName+"��"); 
						self.location.reload();
					}
					else
					{
						alert("�ò����ʲ��Ѿ��ƽ��������ٴ��ƽ���"); 
						self.location.reload();
					}
				}
			}
	
		}
	}

	/*~[Describe=ҵ��ת��;InputParam=��;OutPutParam=��;]~*/
	function doShift()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    	{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    	}else
    	{
			sReturn = selectObjectInfo("User","OrgID=<%=CurOrg.OrgID%>");
			var sss = sReturn.split("@");
			sUserID = sss[0];
			sOrgID = sss[2];
			if(sReturn=="_CANCEL_" && typeof(sReturn)=="undefined") return;
			sReturn = PopPage("/SystemManage/GeneralSetup/ContractShiftAction.jsp?SerialNo="+sSerialNo+"&UserID="+sUserID+"&OrgID="+sOrgID,"","resizable=yes;dialogWidth=48;dialogHeight=30;center:yes;status:no;statusbar:no");
	    	if(sReturn=='true')  
	    	{
	    	    alert("ת�Ƴɹ���");
				self.location.reload();
	    	}
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

<%@	include file="/IncludeEnd.jsp"%>
