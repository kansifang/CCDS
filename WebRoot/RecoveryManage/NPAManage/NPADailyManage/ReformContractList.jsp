<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/12/08
*	Tester:
*	Describe: ��������ͬ��Ϣ�б�
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������ͬ��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//�������	    
	String sSql = "";
	//���������SQL���,��ѯ�����,����ֱ�������ر�־
	String sSql1 = "";
	ASResultSet rs1 = null;
	String sOrgFlag = "",sReportType = "";
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	//���ҳ�����
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�������
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
							{"CustomerName","�ͻ�����"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"BusinessSum","��ͬ���"},
							{"ReformBusinessSum","������"},
							{"ClassifyResultName","���շ���"},
							{"ReformType","��������"},
							{"ReformTypeName","���鷽ʽ"},
							{"PutOutDate","����ʱ��"},
							{"NewBusinessSum","�������Ž��"},
							{"BadBizProjectFlagName","��Ŀ����"}
						}; 

 	sSql = " select BC.SerialNo as SerialNo," + 
 	 	   " BC.RelativeSerialNo as RelativeSerialNo,"+
		   " getBusinessName(BC.BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
		   " BC.CustomerID as CustomerID,BC.CustomerName as CustomerName," + 
		   " getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
		   " BC.BusinessSum as BusinessSum,RI.BusinessSum as ReformBusinessSum, "+
		   " getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
		   " getItemName('ReformType',RI.ApplyType) as ReformType,"+
		   " getItemName('ReformType',RI.ApplyType) as ReformTypeName,"+
		   " BC.PutOutDate as PutOutDate,"+
		   " getItemName('BadBizProjectFlag',BC.BadBizProjectFlag) as BadBizProjectFlagName,"+
		   " RI.NewBusinessSum as NewBusinessSum "+
		   " from BUSINESS_CONTRACT BC,CONTRACT_RELATIVE CR,REFORM_INFO RI "+
		   " where BC.SerialNo=CR.SerialNo and CR.ObjectNo=RI.SerialNo "+
		   " and CR.ObjectType='CapitalReform' "+
		   " and BC.RecoveryUserID='"+CurUser.UserID+"'"+
		   " and BC.RecoveryOrgID ='"+CurOrg.OrgID+"'";
		   
	//������ͼȡ��ͬ�����	 
	if(sDealType.equals("020030050010"))//�۲�����������ع���δ���
	{
		sSql+=" and (BC.ClassifyResult is null or BC.ClassifyResult='') "+
			" and days(replace(BC.PutOutDate,'/','-'))<=days(current date)-90 "+
			" and BC.OccurType='030' and (BC.FinishDate is  null or BC.FinishDate ='') "+
			" and not exists(select 1 from MONITOR_REPORT where ObjectNo=BC.SerialNo"+
			" and ReportType='030' and FinishDate is not null and FinishDate !=''  )";
	}else if(sDealType.equals("020030050020"))//�۲�����������ع����Ѽ��
	{
		sSql+=" and BC.OccurType='030' and (BC.FinishDate is  null or BC.FinishDate ='')"+
			" and exists(select 1 from MONITOR_REPORT where ObjectNo=BC.SerialNo"+
			" and ReportType='030' and FinishDate is not null and FinishDate !=''  )";
	}else if(sDealType.equals("020030050030"))//�۲�����������ع���δ�ύ�����϶�
	{
		sSql+=" and days(replace(BC.PutOutDate,'/','-'))<=days(current date)-180 and "+
			" (BC.ClassifyResult is null or BC.ClassifyResult='') and BC.OccurType='030' "+
			" and (BC.FinishDate is  null or BC.FinishDate ='') ";
	}else if(sDealType.equals("020030050040"))//�۲�����������ع������ύ�����϶�
	{
		sSql+=" and BC.ClassifyResult is not null and BC.ClassifyResult !='' "+
			" and BC.OccurType='030' and (BC.FinishDate is  null or BC.FinishDate ='') ";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	//���ù��ø�ʽ
	doTemp.setVisible("RelativeSerialNo,CustomerID,NewBusinessSum,VouchTypeName",false);
	//doTemp.setKeyFilter("SerialNo");		
    
	//�����п�
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessSum,ReformBusinessSum,NewBusinessSum"," style={width:95px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,ReformBusinessSum,NewBusinessSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,ReformBusinessSum,NewBusinessSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,ReformBusinessSum,NewBusinessSum","3");
	doTemp.setAlign("OccurTypeName","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,SerialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(20); 	//��������ҳ
	
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
		{"false","","Button","���������ر���","���������ر���","Reform_Report()",sResourcesPath},
		{"false","","Button","�����ر�������","�����ر�������","Reform_Report()",sResourcesPath},
		{"true","","Button","̨����Ϣ����","̨����Ϣ����","account_Vindicate()",sResourcesPath},
		{"true","","Button","�ͻ�����","�ͻ�����","customer_Info()",sResourcesPath},
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		{"true","","Button","�����������","�����������","view_Opinions()",sResourcesPath},
		{"false","","Button","�����϶�����","�����϶�����","classify_Info()",sResourcesPath},
		{"false","","Button","��ɼ��","��ɼ��","monitor_Complete()",sResourcesPath},
		{"false","","Button","�ύ�����϶�","�ύ�����϶�","classify_Refer()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath}
		};
	//���ݲ�ͬ��ͼ��ʾ��ť
	if(sDealType.equals("020030050010"))//�۲�����������ع���δ���
	{
		sButtons[getBtnIdxByName(sButtons,"���������ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
	}else if(sDealType.equals("020030050020"))
	{
		sButtons[getBtnIdxByName(sButtons,"�����ر�������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
	}else if(sDealType.equals("020030050030"))//�۲�����������ع���δ�ύ�����϶�
	{
		sButtons[getBtnIdxByName(sButtons,"�ύ�����϶�")][0]="true";
	}else if(sDealType.equals("020030050040"))//�۲�����������ع���δ�ύ�����϶�
	{
		sButtons[getBtnIdxByName(sButtons,"�����϶�����")][0]="true";
	}
	
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�����ر���;InputParam=��;OutPutParam=��;]~*/    
	function Reform_Report()
	{
		//��û�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			popComp("ReformReportList","/RecoveryManage/NPAManage/NPADailyManage/ReformReportList.jsp","ComponentName=�����ر����б�&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=̨����Ϣά��;InputParam=��;OutPutParam=��;]~*/
	function account_Vindicate()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/AccountVindicateInfo.jsp?SerialNo="+sSerialNo+"&DealType=<%=sDealType%>&ViewType=ReformContract","_self",""); 
		}
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function view_Opinions()
	{
		sObjectNo = getItemValue(0,getRow(),"RelativeSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	    popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","ObjectType=CreditApply&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=��ɼ��;InputParam=��;OutPutParam=��;]~*/   
	function monitor_Complete()
	{
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			sReturn=RunMethod("PublicMethod","GetColValue","count(SerialNo),MONITOR_REPORT,String@ObjectNo@"+sSerialNo+"@String@ReportType@030");
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null" || sReturnInfo[1]=="0") 
			{	
				alert("����������غ��ٵ��!");
				return;
			}else
			{
				//��ɼ��
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@<%=StringFunction.getToday()%>,MONITOR_REPORT,String@ObjectNo@"+sSerialNo+"@String@ReportType@030");
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('71'));//�����ɹ�
					self.location.reload();
				}else
				{
					alert(getHtmlMessage('72'));//����ʧ��
				}
			}
		}
	}
	
	/*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function customer_Info()
	{
		//��ÿͻ����
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
		}

	}
	
	/*~[Describe=���շ�������;InputParam=��;OutPutParam=��;]~*/
	function classify_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			sCompID = "ClassifyHistoryList";
			sCompURL = "/CreditManage/CreditPutOut/ClassifyHistoryList.jsp";
			sParamString = "ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=�ύ�����϶�;InputParam=��;OutPutParam=��;]~*/
	function classify_Refer()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenComp("ClassifyApplyMain","/Common/WorkFlow/ApplyMain.jsp","ComponentName=���շ���&ComponentType=MainWindow&ApplyType=ClassifyApply","","")
		}
	}
	
	/*~[Describe=����Excel;InputParam=��;OutPutParam=��;]~*/
	function export_Excel()
	{
		amarExport("myiframe0");
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