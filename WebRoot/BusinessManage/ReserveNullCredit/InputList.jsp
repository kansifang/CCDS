<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.12      
		Tester:	
		Content: �»��׼�򡪡����Ŵ�ҵ��_��ֵ׼��Ԥ��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŵ�ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//��� sql���
	
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	String sCondition1 = "";
	String sEqualCondition = "";
	String sRightCondi = "";
	String sEqualRightCondi = "";//����Ȩ�������Ĳ�������
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ�����ͻ���Ϣ������	
	String sHeaders[][] = {
				 {"SerialNo","���"},
	             {"AccountMonth","����·�"},
				 {"LoanAccount","��ݺ�"},
				 {"CustomerName","�ͻ�����"},
				 {"BusinessSum","�������"},
				 {"Balance","�������"},
				 {"Result1","�ܻ�Ա������"},
				 {"Result2","֧���϶����"},
				 {"Result3","�����϶����"},
				 {"Result4","�����϶����"},
				 {"MResult","���������϶����"},
				 {"AResult","����϶����"},
			};
	
	sSql = " select  SerialNo, LoanAccount, AccountMonth,  CustomerName,BusinessSum, Balance," + 
	       " Result1, Result2, Result3, Result4, MResult, AResult " +
	       " from Reserve_Record RR where RR.BusinessFlag = '3' ";
    String sSql2 = " union select 'unInput' as SerialNo, RN.AssetNo as AssetNo, RN.AccountMonth as AccountMonth,  RN.DebtorName as DebtorName, RN.AccountSum as AccountSum , RN.Balance as Balance, " + 
	                    " '' as Result1, '' as Result2, '' as Result3, '' as Result4, '' as MResult, '' as AResult from Reserve_Nocredit RN " + 
	                    " where not exists (select * from Reserve_Record RR where RR.LoanAccount = RN.AssetNo) "+
	                    " and RN.Manageuserid = '" + CurUser.UserID + "'" ; 
	                    
	  if(sAction.equals("UnFinished")){
	        if(CurUser.hasRole("601")){
			   	sRightCondi = " and (RR.FinishDate2 is null and RR.userid1 is not null)";
			   	sEqualRightCondi = " and (FinishDate2 is null and userid1 is not null)";
			}else if(CurUser.hasRole("602")){
			   	sRightCondi = " and (RR.FinishDate3 is null and RR.userid2 is not null)";
			   	sEqualRightCondi = " and (FinishDate3 is null and userid2 is not null)";
			}else if(CurUser.hasRole("603")){
			   	sRightCondi = " and (RR.FinishDate4 is null and RR.userid3 is not null)";
			   	sEqualRightCondi = " and (FinishDate4 is null and userid3 is not null)";
			}else if(CurUser.hasRole("604")){
				sRightCondi = " and (RR.MResult is not null and RR.MFinishdate is null and RR.UserID4 is not null)";
	        	sEqualRightCondi = " and (MResult is not null and MFinishdate is null and UserID4 is not null)"; 
			}
			else if(CurUser.hasRole("480")){
				sRightCondi = " and (RR.FinishDate1 is null and RR.Manageuserid = '" + CurUser.UserID + "')";
	        	sEqualRightCondi = " and (FinishDate1 is null and Manageuserid = '" + CurUser.UserID + "')"; 	        
			}     
     }else{
	        if(CurUser.hasRole("601")){
	           	sRightCondi = " and (RR.FinishDate2 is not null and RR.UserId2 = '" + CurUser.UserID + "')";
	           	sEqualRightCondi = " and (FinishDate2 is not null and RR.UserId2 = '" + CurUser.UserID + "')";
			}else if(CurUser.hasRole("602")){
	           	sRightCondi = " and (RR.FinishDate3 is not null and RR.UserId3 = '" + CurUser.UserID + "')";
	           	sEqualRightCondi = " and (FinishDate3 is not null and Manageuserid = '" + CurUser.UserID + "')";
			}else if(CurUser.hasRole("603")){
	           	sRightCondi = " and (RR.FinishDate4 is not null and RR.UserId4 = '" + CurUser.UserID + "')";
	           	sEqualRightCondi = " and (FinishDate4 is not null and Manageuserid = '" + CurUser.UserID + "')";
			}else if(CurUser.hasRole("480")){
			  	sRightCondi = " and (RR.FinishDate1 is not null and RR.Manageuserid = '" + CurUser.UserID + "')";
            	sEqualRightCondi = " and (FinishDate1 is not null and Manageuserid = '" + CurUser.UserID + "')";
			}
	}
	sSql = sSql + sRightCondi;         
	if(sAction.equals("Finished") && sType.equals("Input")){//�Ŵ�Ա
        sSql2 = sSql2 + " and 1=2";
        sSql = sSql + sSql2;
    }else if(sAction.equals("UnFinished") && sType.equals("Input"))
    {
    	sSql = sSql + sSql2;
    }
    //sSql = sSql + " order by ObjectNo desc";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record";
    doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
    doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
    //doTemp.setCheckFormat("AccountMonth","6");
	doTemp.setVisible("SerialNo",false);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(20); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("LoanAccount");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql); //����datawindow��Sql���÷���
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
		//6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"false","","Button","��ʧʶ��","��ʧʶ��","lossManage()",sResourcesPath},
			{"true","","Button","Ԥ���ֽ���ά��","Ԥ���ֽ���ά��","my_Input()",sResourcesPath},
			{"true","","Button","�����ύ","�����ύ","my_Singlefinish()",sResourcesPath},
			{"true","","Button","�����ύ","�����ύ","my_Finish()",sResourcesPath},
			{"true","","Button","���ʳ���","���ʳ���","my_SingleCancel()",sResourcesPath},
			{"true","","Button","��������","��������","my_Cancel()",sResourcesPath},
			{"true","","Button","ҵ������","ҵ������","viewAndEdit()",sResourcesPath}
		};
	if(CurUser.hasRole("480"))
	{
		sButtons[4][0] = "false";
	}	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	function lossManage()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sMClassifyResult = getItemValue(0,getRow(),"MClassifyResultName");
		sBalance = getItemValue(0,getRow(),"Balance");
		sPutoutDate = getItemValue(0,getRow(),"PutoutDate");
		sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
		sVouchType = getItemValue(0,getRow(),"VouchTypeName");

		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ����Ϣ");
			return;
		}
		PopComp("ReserveLossView","/BusinessManage/ReserveManage/ReserveLossView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&CustomerName="+sCustomerName+"&Balance="+sBalance+"&PutoutDate="+sPutoutDate+"&MaturityDate="+sMaturityDate+"&MClassifyResult="+sMClassifyResult,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	function my_Input(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if(typeof(sLoanAccount) == "undefined" || sLoanAccount==""){
			 alert("��ѡ��һ����Ϣ");
		     return;
		}
		sReturnValue = "";
 		if(sSerialNo == "unInput"){//�����δԤ��ļ�¼����Ԥ����в���ü�¼
 		   sReturnValue = PopComp("InsertAction","/BusinessManage/ReserveNullCredit/InsertAction.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth,"dialogWidth=20;dialogHeight=9;center:yes;status:no;statusbar:no");
 		   if(sReturnValue == "01"){
 		      alert("���ݿ����ʧ�ܣ��������Ա��ϵ");
 		      return;
 		   }
 		}
 		PopComp("CashPreView","/BusinessManage/ReserveNullCredit/CashPreView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&SerialNo="+sSerialNo+"&Grade=<%=sGrade%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
 		reloadSelf();
	}
	
	function my_Singlefinish(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ�������Ϣ��");
			return;
		}else
		{
				sReturn = "";
				if ("<%=CurUser.hasRole("601")%>"=="true")
				{
					sReturn="ȷ������ѡ��¼�ύ���������϶���";
				}
				else if("<%=CurUser.hasRole("602")%>"=="true")
				{
					sReturn="ȷ������ѡ��¼�ύ�����������϶���";
				}else if("<%=CurUser.hasRole("603")%>"=="true")
				{
					sReturn="ȷ������ѡ��¼�ύ�����������";
				}else if("<%=CurUser.hasRole("480")%>"=="true")
				{
					sReturn="ȷ������ѡ��¼�ύ��";				
			    }
				if(sSerialNo == "unInput"){
					alert("û��Ԥ���ֽ����������ύ");
					return;
				}else if(confirm(sReturn))
				{
					var sCondition="<%=sCondition1%>";
		 			sReturnValue = PopComp("CheckInAction","/BusinessManage/ReserveNullCredit/CheckInAction.jsp","SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"dialogWidth=40;dialogHeight=20;center:yes;status:no;statusbar:no");
			 		if(sReturnValue== "99"){
			 			alert("û��ͨ�������걸�Լ�飬�����ύ��");
						return;
					}
					reloadSelf();
					sReturn=PopComp("singleFinishCashPreAction","/BusinessManage/ReserveNullCredit/singleFinishCashPreAction.jsp","SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
					if (sReturn=="00")
					{
						alert("�����ύ�ɹ�");
						
					}else
					{
						alert("�����ύʧ��");
					}
					reloadSelf();
				}		
		}
	}
	
	//�����ύ
	function my_Finish(){
		iCount=getRowCount(0);
		alert(iCount);
		//return;
		var sReturn="";
		if (iCount>0)
		{			
			if (confirm("ȷ���ύ��"))
			{
				var sCondition="<%=sCondition1%>";
				/*
		 		sReturnValue = PopComp("CheckInAction","/BusinessManage/ReserveNullCredit/CheckInAction.jsp","Type=<%//=sType%>&rand="+randomNumber(),"dialogWidth=40;dialogHeight=20;center:yes;status:no;statusbar:no");
		 		if(sReturnValue == "01"){
				    alert("���ݿ������ݳ����������Ա��ϵ");
				    return;
				}
			 	if(sReturnValue== "99"){
			 	     alert("û��ͨ�������걸�Լ�飬�����ύ��");
				     return;
				}
				*/	
			 	sReturn=PopComp("FinishCashPreAction","/BusinessManage/ReserveNullCredit/FinishCashPreAction.jsp","Type=<%//=sType%>"+"&RightCondi=<%=sRightCondi%>"+"&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("�����ύ�ɹ�");
				}else	
				{
					alert("�����ύʧ��");
				}
				reloadSelf();
			}
		}else 
		{
		 	alert("û����Ҫ�ύ�ļ�¼");
		}
	}
	//���ʳ�������һ�׶�
	function my_SingleCancel()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ�������Ϣ��");
		}else
	    {
		
			if(confirm("ȷ������ѡ��¼��������һ����"))//ȷ����Ϣ���������
			{
				
				sReturn=PopComp("singleCanclePreAction","/BusinessManage/ReserveNullCredit/singleCanclePreAction.jsp","SerialNo="+sSerialNo+"&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("�����ɹ�");
				}else
				{
					alert("����ʧ��");
				}
				reloadSelf();
			}
		}
	}
	
	//ȫ������
	function my_Cancel()
	{
		var sReturn="";
		iCount=getRowCount(0);
		var sReturn="";
		if (iCount>0)
		{
			if (confirm("ȷ�������м�¼������"))//ȷ����Ϣ���������
			{
				var sCondition="<%=sCondition1%>";
			 	sReturn=PopComp("CancelCashPreAction","/BusinessManage/ReserveNullCredit/CancelCashPreAction.jsp","Type=<%=sType%>&BusinessFlag=1&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("�����ɹ�");
				}else
				{
					alert("����ʧ��");
				}
				reloadSelf();
			}
		}else 
		{
 			alert("û����Ҫ�����ļ�¼");
 		}
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sAssetNo = getItemValue(0,getRow(),"AssetNo");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataInfo","/BusinessManage/ReserveDataPrepare/ReserveDataInfo.jsp","AccountMonth="+sAccountMonth+"&AssetNo="+sAssetNo,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
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