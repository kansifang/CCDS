<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.12      
		Tester:	
		Content: �»��׼�򡪡���˾ҵ��_��ֵ׼��Ԥ��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ֵ׼��Ԥ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>

<%
	//�������
	String sSql = "";//��� sql���
	
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	if(sAction == null) sAction = "";
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType == null) sType = "";
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	if(sGrade == null) sGrade = "";
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
	             {"AccountMonth1","����·�"},
				 {"LoanAccount","��ݺ�"},
				 {"ObjectNo","��ݺ�"},
				 {"Statorgid","�����������"},
				 {"StatOrgName","�����������"},
				 {"CustomerName","�ͻ�����"},
				 {"BusinessSum","������"},
				 {"Balance","�������"},
				 {"PutoutDate","������"},
				 {"MaturityDate","������"},
				 {"AuditRate","ʵ������(��)"},
				 {"VouchType","��Ҫ������ʽ"},
				 {"VouchTypeName","��Ҫ������ʽ"},
				 {"MClassifyResultName","�弶����"},
				 {"MClassifyResult","�弶����"},
				 {"AClassifyResultName","����弶����"},
				 {"AClassifyResult","����弶����"},
				 {"Result1","�ܻ�Ա������"},
				 {"Result2","֧��Ԥ����"},
				 {"Result3","����Ԥ����"},
				 {"Result4","�����϶����"},
				 {"MResult","���������϶����"},
				 {"AResult","����϶����"},
				 {"ManageOrgID","�ܻ�����"}
			};
	
	String sSql1 = "select  SerialNo, LoanAccount, AccountMonth, AccountMonth as AccountMonth1,getorgname(Statorgid) as StatOrgName, ObjectNo, CustomerName,BusinessSum, Balance," + 
	       " AuditRate,getItemName('MFiveClassify', MClassifyResult) as MClassifyResultName,MClassifyResult, "+
	       " getItemName('MFiveClassify', AClassifyResult) as AClassifyResultName,AClassifyResult, "+
	       " PutoutDate,MaturityDate,getItemName('VouchType', RR.VouchType) as VouchTypeName, "+
	       " Result1, Result2, Result3, Result4, MResult, AResult ,ManageOrgID " +
	       " from Reserve_Record RR where RR.BusinessFlag = '1' ";
    String sSql2 = " union select 'unInput' as SerialNo, RT.LoanAccount as LoanAccount, RT.AccountMonth as AccountMonth, AccountMonth as AccountMonth1, "+
    					" getorgname(RT.Statorgid) as StatOrgName, RT.DuebillNo as ObjectNo, RT.CustomerName as CustomerName, RT.BusinessSum as BusinessSum , RT.Balance as Balance, " + 
                        " RT.AuditRate as AuditRate,getItemName('MFiveClassify', RT.MFiveClassify) as MClassifyResultName, RT.MFiveClassify as MClassifyResult, " +
                        " getItemName('MFiveClassify', RT.AFiveClassify) as AClassifyResultName, RT.AFiveClassify as AClassifyResult, " +
	                    " RT.PutoutDate as PutoutDate,RT.Maturity as MaturityDate,getItemName('VouchType', RT.VouchType) as VouchTypeName , " + 
	                    " '' as Result1, '' as Result2, '' as Result3, '' as Result4, '' as MResult, '' as AResult ,RT.ManageOrgID as ManageOrgID from Reserve_Total RT " + 
	                    " where not exists (select * from Reserve_Record RR where RR.LoanAccount = RT.LoanAccount and RR.AccountMonth=RT.AccountMonth) "+
	                    " and getOrgSortNo(RT.Manageuserid) = getOrgSortNo('" + CurUser.UserID + "')" + 
	                    " and RT.ManageStatFlag = '2' " + //2-��ʼ���
	                    " and RT.BusinessFlag = '1' and (nvl(RT.MFiveClassify,'') <> '05' or nvl(RT.AFiveClassify,'') <> '05')" ;
	              
	  if(sAction.equals("UnFinished")){
	        if(CurUser.hasRole("601")){
			   	sRightCondi = " and (RR.FinishDate2 is null and RR.userid1 is not null )";//and getOrgSortNo(manageuserid)=getOrgSortNo('"+CurUser.UserID+"'))";
			}else if(CurUser.hasRole("602")){
			   	sRightCondi = " and (RR.FinishDate3 is null and RR.userid2 is not null )";//and substr(getOrgSortNo(manageuserid),1,6)=substr(getOrgSortNo('"+CurUser.UserID+"'),1,6))";
			}else if(CurUser.hasRole("603")){
			   	sRightCondi = " and (RR.FinishDate4 is null and RR.userid3 is not null)";
			}else if(CurUser.hasRole("604")){
				sRightCondi = " and (RR.MResult is not null and RR.MFinishdate is null and RR.UserID4 is not null)";
			}
			else if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")){
				sRightCondi = " and (RR.FinishDate1 is null and getOrgSortNo(RR.Manageuserid) = getOrgSortNo('" + CurUser.UserID + "'))";
			}     
     }else{
	        if(CurUser.hasRole("601")){
	           	sRightCondi = " and (RR.FinishDate2 is not null and RR.UserId2 = '" + CurUser.UserID + "' and getOrgSortNo(manageuserid)=getOrgSortNo('"+CurUser.UserID+"'))";
			}else if(CurUser.hasRole("602")){
	           	sRightCondi = " and (RR.FinishDate3 is not null and RR.UserId3 = '" + CurUser.UserID + "' and substr(getOrgSortNo(manageuserid),1,6)=substr(getOrgSortNo('"+CurUser.UserID+"'),1,6))";
			}else if(CurUser.hasRole("603")){
	           	sRightCondi = " and (RR.FinishDate4 is not null and RR.UserId4 = '" + CurUser.UserID + "')";
			}else if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")){
			  	sRightCondi = " and (RR.FinishDate1 is not null and RR.UserId1 = '" + CurUser.UserID + "')";
			}
	}
	        
	if(sAction.equals("Finished") && sType.equals("Input")){//�Ŵ�Ա
        sSql2 = sSql2 + " and 1=2";
        sSql1 = sSql1 + sRightCondi;
        sSql = sSql1 + sSql2;
    }else if(sAction.equals("UnFinished") && sType.equals("Input"))
    {
    	sSql1 = sSql1 + sRightCondi;
    	sSql = sSql1 + sSql2;
    }else
    {
    	sSql = sSql1 + sRightCondi; 
    }
    System.out.println("--------------------------------"+sSql);
    //sSql = sSql + " order by ObjectNo desc";
	ASDataObject doTemp = new ASDataObject(sSql);
	String sTemp = doTemp.WhereClause;
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record";
    doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
 //   doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
 //	doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_Total");
 	doTemp.generateFilters(Sqlca);
 	doTemp.setFilter(Sqlca,"1","AccountMonth","");
 	doTemp.setFilter(Sqlca,"2","CUstomerName","");
 	doTemp.setFilter(Sqlca,"3","LoanAccount","");
 	doTemp.setFilter(Sqlca,"4","ManageOrgID","");
    //doTemp.setCheckFormat("AccountMonth","6");
    doTemp.setHTMLStyle("LoanAccount","style={width:150px}");
    doTemp.setHTMLStyle("Result1,Result2,Result3,Result4,AResult","style={width:100px}");
    doTemp.setHTMLStyle("AccountMonth,PutoutDate,MaturityDate,MClassifyResultName,AClassifyResultName","style={width:80px}");
	doTemp.setVisible("ManageOrgID,AccountMonth,SerialNo,ObjectNo,MClassifyResult,AClassifyResult,VouchTypeName,StatOrgName,MResult,BusinessSum,AClassifyResultName,AResult",false);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	doTemp.setType("BusinessSum,Balance","Number");
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	if(doTemp.haveReceivedFilterCriteria())
	{
		sSql1 += doTemp.WhereClause.substring(sTemp.length());
	    sSql2 += doTemp.WhereClause.substring(sTemp.length());
	    String sSql3 = "";      
		if(sAction.equals("Finished") && sType.equals("Input")){//�Ŵ�Ա
        	sSql2 = sSql2 + " and 1=2";
        	sSql1 = sSql1 + sRightCondi;
        	sSql3 = sSql1 + sSql2;
    	}else if(sAction.equals("UnFinished") && sType.equals("Input"))
    	{
    		sSql1 = sSql1 + sRightCondi;
    		sSql3 = sSql1 + sSql2;
    	}else
    	{
    		sSql3 = sSql1 + sRightCondi; 
    	} 	
        doTemp = null;
	    dwTemp = null;
        doTemp = new ASDataObject(sSql3);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable="Reserve_Record";
		doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
		//doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_Total");
		doTemp.generateFilters(Sqlca);
 		doTemp.setFilter(Sqlca,"1","AccountMonth","");
 		doTemp.setFilter(Sqlca,"2","CUstomerName","");
 		doTemp.setFilter(Sqlca,"3","LoanAccount","");
 		doTemp.setFilter(Sqlca,"4","ManageOrgID","");
		//doTemp.setCheckFormat("AccountMonth","6");
		doTemp.setHTMLStyle("LoanAccount","style={width:150px}");
		doTemp.setHTMLStyle("Result1,Result2,Result3,Result4,AResult","style={width:100px}");
		doTemp.setHTMLStyle("AccountMonth,PutoutDate,MaturityDate,MClassifyResultName,AClassifyResultName","style={width:80px}");
		doTemp.setVisible("ManageOrgID,AccountMonth,SerialNo,ObjectNo,MClassifyResult,AClassifyResult,VouchTypeName,StatOrgName,MResult,BusinessSum,AClassifyResultName,AResult",false);
		doTemp.setType("BusinessSum,Balance","Number");
		doTemp.parseFilterData(request,iPostChange);
		doTemp.multiSelectionEnabled = false;
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	}
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
			{"true","","Button","��ʧʶ��","��ʧʶ��","DiscernLoss()",sResourcesPath},
			{"true","","Button","Ԥ���ֽ���ά��","Ԥ���ֽ���ά��","my_Input()",sResourcesPath},
			{"true","","Button","�����ύ","�����ύ","my_Singlefinish()",sResourcesPath},
			{"true","","Button","�����ύ","�����ύ","my_Finish()",sResourcesPath},
			{"true","","Button","���ʳ���","���ʳ���","my_SingleCancel()",sResourcesPath},
			{"false","","Button","��������","��������","my_Cancel()",sResourcesPath},
			{"true","","Button","ҵ������","ҵ������","viewAndEdit()",sResourcesPath},
			{"true","","Button","����Excel","����Excel","exportAll()",sResourcesPath}
	};
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
	{
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
	}
	if(sAction.equals("Finished"))
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
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
	
	function DiscernLoss()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sMClassifyResult = getItemValue(0,getRow(),"MClassifyResult");
		sBalance = getItemValue(0,getRow(),"Balance");
		sPutoutDate = getItemValue(0,getRow(),"PutoutDate");
		sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
		if(typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert("��ѡ��һ����Ϣ");
			return;
		}
		sReturnValue = "";
 		if(sSerialNo == "unInput"){//�����δԤ��ļ�¼����Ԥ����в���ü�¼
 		   sReturnValue = PopPage("/BusinessManage/ReserveManage/InsertRecordAction.jsp?LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth,"","resizable=yes;dialogWidth=0;dialogHeight=0;status:no;center:yes;status:yes;statusbar:no");
 		   if(sReturnValue == "01"){
 		      alert("���ݿ����ʧ�ܣ��������Ա��ϵ");
 		      return;
 		   }
 		}
		PopComp("ReserveLossView","/BusinessManage/ReserveManage/ReserveLossView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&CustomerName="+sCustomerName+"&MClassifyResult="+sMClassifyResult+"&Balance="+sBalance+"&PutoutDate="+sPutoutDate+"&MaturityDate="+sMaturityDate,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
 		reloadSelf();
	}
	
	
	function my_Input(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sMClassifyResult = getItemValue(0,getRow(),"MClassifyResult");
		sAClassifyResult = getItemValue(0,getRow(),"AClassifyResult");
		if(typeof(sLoanAccount) == "undefined" || sLoanAccount==""){
			 alert("��ѡ��һ����Ϣ");
		     return;
		}
		
		var sMfiveClassify = RunMethod("�»��׼��","checkFiveClassify",sLoanAccount+","+sAccountMonth);
		if(sMfiveClassify == "0")
		{
			alert("�ñʽ��"+ sAccountMonth +"û���弶����!\n �벹¼���ڴε��弶����");
			PopComp("addFiveClassify","/BusinessManage/ReserveManage/addFiveClassify.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount,"resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			reloadNewSelf();
			return;
		}
 		PopComp("CashPredictView","/BusinessManage/ReserveManage/CashPredictView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&Grade=<%=sGrade%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
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
				}else if("<%=CurUser.hasRole("480")%>"=="true" || "<%=CurUser.hasRole("280")%>"=="true" || "<%=CurUser.hasRole("080")%>"=="true")
				{
					sReturn="ȷ������ѡ��¼�ύ��";				
			    }
				if(sSerialNo == "unInput"){
					alert("û��Ԥ���ֽ����������ύ");
					return;
				}else if(confirm(sReturn))
				{
					var sCondition="<%=sCondition1%>";
		 			sReturnValue = PopComp("CheckInfoAction","/BusinessManage/ReserveManage/CheckInfoAction.jsp","SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"dialogWidth=42;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		 			//modify by ycsun 2008/11/13 ģ̬���ڲ������Ի���
		 		/*	sReturn1 = PopPage("/BusinessManage/ReserveManage/CheckAttachAction.jsp?ObjectNo="+sSerialNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			 		if(sReturnValue== "99" || sReturn1=="01"){
			 			alert("û��ͨ�������걸�Լ�飬�����ύ��");
						return;
					}*/
					reloadSelf();
					sReturn=PopPage("/BusinessManage/ReserveManage/singleFinishCashPredictAction.jsp?SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
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
		var sReturn="";
		if (iCount>0)
		{			
			if (confirm("ȷ���ύ��"))
			{
				var sCondition="<%=sCondition1%>";
			 	sReturn=PopComp("FinishCashPredictAction","/BusinessManage/ReserveManage/FinishCashPredictAction.jsp","Type=<%=sType%>"+"&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
	
	//���ʳ���ҵ��
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
				
				sReturn=PopPage("/BusinessManage/ReserveManage/singleCanclePredictAction.jsp?SerialNo="+sSerialNo+"&rand="+randomNumber(),"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
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
			 	sReturn=PopComp("CancelCashPredictAction","/BusinessManage/ReserveManage/CancelCashPredictAction.jsp","Type=<%=sType%>&BusinessFlag=1&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataEntInfo","/BusinessManage/ReserveDataPrepare/ReserveDataEntInfo.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	// add by ycsun 2008/12/01 ��ֹ��ˢ�µĹ����в�����Ա�������İ�ť
	function reloadNewSelf(){
		ShowDivMessage("ϵͳ���ڴ����У����Ե�...........",true,false);
		rememberPageRow();
		if(document.forms("DOFilter")==null){
			self.location.reload();
		} else if(typeof(document.forms("DOFilter"))=="undefined"){
			self.location.reload();
		}else{
			document.forms("DOFilter").submit();
		}
	}
	
	function hideDivMessage(){
		try{
			msgDiv.removeChild(msgTxt);
			msgDiv.removeChild(msgTitle);
			document.body.removeChild(msgDiv);
			document.all.msgIfm.removeNode();
			document.body.removeChild(bgDiv);
		}catch(e)
		{	
			;
		}
	}

	function ShowDivMessage(str,showGb,clickHide){
		
		//����ͨ�����������жϴ����Ƿ��Ѵ�
		//��ȡ�滻����ȡ���Ĳ����������ظ���
		//��ʾ���־����𳬹�2��,��Ϊ����iframe��̬�߶Ȳ�֪����ôŪ��
		
	 	if(typeof msgDiv=="object")
			return ;	 	
	
		var msgw=300;//��Ϣ��ʾ���ڵĿ��
		var msgh=125;//��Ϣ��ʾ���ڵĸ߶�
		var bordercolor="#336699";//��ʾ���ڵı߿���ɫ
	
		var scrollTop = document.body.scrollTop+document.body.clientHeight*0.4+"px";
		
		//**������Ϣ��ĵͲ�iframe**/
		var ifmObj=document.createElement("iframe")
		ifmObj.setAttribute('id','msgIfm');
		ifmObj.setAttribute('align','center');
		ifmObj.style.background="white";
		ifmObj.style.border="0px none " + bordercolor;
		ifmObj.style.position = "absolute";
		ifmObj.style.left = "55%";
		ifmObj.style.top = scrollTop; //"40%";
		ifmObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
		ifmObj.style.marginLeft = "-225px" ;//����λ��
		ifmObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
		ifmObj.style.width = msgw + "px";
		ifmObj.style.height =msgh + "px";
		ifmObj.style.textAlign = "center";
		ifmObj.style.lineHeight ="25px";
	
		ifmObj.style.zIndex = "9999";
		document.body.appendChild(ifmObj);
		
		//**���Ʊ�����**/	
		var bgObj=document.createElement("div");
		bgObj.setAttribute('id','bgDiv');
		bgObj.style.position="absolute";
		
		bgObj.style.top="0";//��ʾλ��top
		bgObj.style.left="0";//��ʾλ��left
		bgObj.style.background="#777";
		bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";//����ɫЧ�� 
		bgObj.style.opacity="50%";//Ӧ����͸����?
	
		//���ñ����� ��,��
		var sWidth,sHeight;
		sWidth=document.body.offsetWidth;
		
		sHeight=screen.height;
		bgObj.style.width="100%" ;//sWidth + "px";//��Ϊ100%����,��������
		bgObj.style.height="100%" ;//sHeight + "px";
		
		bgObj.style.zIndex = "10000";//��ʾ���
	
		//�����㶯�� ����ر�
		if(clickHide)
			bgObj.onclick=hideMessage;
		if(showGb)
			document.body.appendChild(bgObj);
		
		//**������Ϣ��**/
		var msgObj=document.createElement("div")
		msgObj.setAttribute("id","msgDiv");
		msgObj.setAttribute("align","center");
		msgObj.style.background="white";
		msgObj.style.border="1px solid " + bordercolor;
		msgObj.style.position = "absolute";
		msgObj.style.left = "55%";
		msgObj.style.top= scrollTop; //"40%";
		msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
		msgObj.style.marginLeft = "-225px" ;//����λ��
		msgObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
		msgObj.style.width = msgw + "px";
		msgObj.style.height =msgh + "px";
		msgObj.style.textAlign = "center";
		msgObj.style.lineHeight ="25px";
		msgObj.style.zIndex = "10001";
		
		document.body.appendChild(msgObj);
		
		//**���Ʊ����**/ ����ر�
		var title=document.createElement("h4");
		title.setAttribute("id","msgTitle");
		title.setAttribute("align","left");
		title.style.margin="0";
		title.style.padding="3px";
		title.style.background=bordercolor;
		title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
		title.style.opacity="0.75";
		title.style.border="1px solid " + bordercolor;
		title.style.height="18px";
		//title.style.width = msgw + "px";	
		title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";
		title.style.color="white";
		
		title.innerHTML="ϵͳ������...";
		if(clickHide){
			title.innerHTML="�ر�";
			title.style.cursor="pointer";			
			title.onclick = hideDivMessage;
		}	
		
		document.getElementById("msgDiv").appendChild(title);
		
		//**�����ʾ��Ϣ**/
		str = "<br>"+str.replace(/\n/g,"<br>");
		var txt=document.createElement("p");
		txt.style.margin="1em 0"
		txt.setAttribute("id","msgTxt");
		txt.innerHTML=str;
		document.getElementById("msgDiv").appendChild(txt);
			
	}
	
	function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.all(sObjectID);
		oMyObj2 = document.all(sObjectID2);
		if(sFilterID=="1"){
		
		}else if(sFilterID=="4"){
			//����ģ̬����ѡ��򣬲�������ֵ����sReturn
			sReturn = selectObjectInfo("Code","CodeNo=OrgInfo^��ѡ��ܻ�����^","");
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_"){
				return;
			}else if(sReturn=="_CLEAR_"){
				oMyObj.value="";
				oMyObj2.value="";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				oMyObj2.value=sReturns[1];
			}
		}
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