<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.08      
		Tester:	
		Content: �»��׼�򡪡���˾ҵ��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��˾ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//��� sql���
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID==null) sCustomerID="";
	String sCondition = DataConvert.toRealString(iPostChange,(String)request.getParameter("Condition"));
	String sAction = DataConvert.toRealString(iPostChange,(String)request.getParameter("Action"));
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("Type"));
	String sCondition1 = "";
	String sRightCondi = "";
	String sEqualRightCondi = "";//����Ȩ�������Ĳ�������
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ�����ͻ���Ϣ������	
	String sHeaders[][] = {
	             {"AccountMonth","����·�"},
				 {"StatOrgName","֧������"},
				 {"LoanAccount","�����˺�"},
				 {"ObjectNo","��ݱ��"},
				 {"CustomerName","�ͻ�����"},
				 {"BusinessSum","�����Ԫ��"},
				 {"Balance","������Ԫ��"},
				 {"MClassifyResultName","�����弶����"},
				 {"AClassifyResultName","����弶����"},
				 {"PutoutDate","������"},
				 {"MaturityDate","������"},
				 {"VouchTypeName","��Ҫ������ʽ"},
				 {"Result1","�ܻ�Ա������"},
				 {"Result2","֧���϶����"},
				 {"Result3","�����϶����"},
				 {"Result4","�����϶����"},
				 {"MResult","�����϶����"},
				 {"AResult","��ƽ��"}
			};
    sSql = "select  SerialNo, LoanAccount, AccountMonth, getorgname(Statorgid) as StatOrgName, ObjectNo, CustomerName,BusinessSum, Balance," + 
	       " getItemName('ReserveFCResult', MClassifyResult) as MClassifyResultName,MClassifyResult, "+
	       " getItemName('ReserveFCResult', AClassifyResult) as AClassifyResultName,AClassifyResult, "+
	       " PutoutDate,MaturityDate,getItemName('MainVouchType', RR.VouchType) as VouchTypeName, "+
	       " Result1, Result2, Result3, Result4, MResult, AResult " +
	       " from Reserve_Record RR where 1=1 ";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record";
    doTemp.setKey("SerialNo,AccountMonth,ObjectNo",true);
    doTemp.setColumnAttribute("AccountMonth,CustomerName,ObjectNo","IsFilter","1");
	//doTemp.setFilter(Sqlca,"1","CustomerID","Operators=EqualsNumber,BeginsWith");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(20); //add by hxd in 2005/02/20 for �ӿ��ٶ�
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("ObjectNo");
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
			{"true","","Button","��ʧʶ��","��ʧʶ��","lossManage()",sResourcesPath},
			{"true","","Button","Ԥ���ֽ���ά��","Ԥ���ֽ���ά��","viewCurrence()",sResourcesPath},
			{"true","","Button","�����ύ","�����ύ","my_Singlefinish()",sResourcesPath},
			{"true","","Button","�����ύ","�����ύ","my_Finish()",sResourcesPath},
			{"true","","Button","���ʳ���","���ʳ���","my_Singlecancel()",sResourcesPath},
			{"true","","Button","��������","��������","my_Cancel()",sResourcesPath},
			{"true","","Button","ҵ������","ҵ������","viewAndEdit()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	
	function my_Singlefinish(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ�������Ϣ��");
		}else
		{
					sReturn = "";
					if (<%=CurUser.hasRight("725")%>)
					{
					   sReturn="ȷ������ѡ��¼�ύ�������϶���";
					}
					else if(<%=CurUser.hasRight("735")%>)
					{
						 sReturn="ȷ������ѡ��¼�ύ�����������϶���";
					}else if  (<%=CurUser.hasRight("020")%>)
					{
						 sReturn="ȷ������ѡ��¼�ύ��";				
					}
					
					if (confirm(sReturn))
					{
					    if(sSerialNo == "unInput"){
					       alert("û��Ԥ���ֽ����������ύ");
					       return;
					    }
						var sCondition="<%=sCondition1%>";
		 		        sReturnValue = self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ReserveManage/CheckInfoAction.jsp?SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=40;dialogHeight=20;center:yes;status:no;statusbar:no");
			 	        if(sReturnValue== "99"){
			 		      alert("û��ͨ�������걸�Լ�飬�����ύ��");
					      return;
				        }

						sReturn=self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ReserveManage/singleFinishCashPredictAction.jsp?SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
						if (sReturn=="00")
						{
							alert("�����ύ�ɹ�");
							window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/InputList.jsp?Action=<%=sAction%>&Type=<%=sType%>&Condition="+sCondition+"&rand="+randomNumber(),"_self","");
						}else
						{
							alert("�����ύʧ��");
						}
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
		 		sReturnValue = self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ReserveManage/CheckInfoAction.jsp?Condition="+sCondition+"&RightCondi=<%=sRightCondi%>&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=40;dialogHeight=20;center:yes;status:no;statusbar:no");
			 	if(sReturnValue== "99"){
			 	     alert("û��ͨ�������걸�Լ�飬�����ύ��");
				     return;
				}
				if(sReturnValue == "01"){
				    alert("���ݿ������ݳ����������Ա��ϵ");
				    return;
				}
			 	sReturn=self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ReserveManage/FinishCashPredictAction.jsp?Condition="+sCondition+"&RightCondi=<%=sEqualRightCondi%>&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("�����ύ�ɹ�");
					window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/InputList.jsp?Condition="+sCondition+"&Action=<%=sAction%>&Type=<%=sType%>&rand="+randomNumber(),"_self","");
				}else	
				{
					alert("�����ύʧ��");
				}
			}
		}else 
		{
		 	alert("û����Ҫ�ύ�ļ�¼");
		}
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		//var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		
		var sReturn = PopComp("ReserveDataIndInfo","/BusinessManage/ReserveDataPrepare/ReserveDataIndInfo.jsp","","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }
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