<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/09/16
*	Tester:
*	Describe: �����ʲ���ˮ��Ϣ�б�
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ���ˮ��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sOrgFlag = "";
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
							{"SerialNo","������ˮ��"},
							{"RelativeContractNo","��ͬ��ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
							{"BusinessCurrencyName","����"},
							{"VouchTypeName","������ʽ"},
							{"BusinessSum","��ͬ���"},
							{"Balance","��ǰ���"},
							{"ClassifyResultName","���շ���"},
							{"BadLoanCaliberName","��������ھ�"},
							{"InterestBalance1","����ǷϢ"},
							{"InterestBalance2","����ǷϢ"},
							{"OccurDate","��������"},
							{"TransactionFlag","���ױ�־"},
							{"OccurDirection","��������"},
							{"OccurType","��������"},
							{"OccurSubject","����ժҪ"},
							{"BusinessDesc","��������"},
							{"ActualSum","������"},
							{"MendDate","��������"}
						}; 
 	sSql = " select BW.SerialNo as SerialNo," + 	
		   " BW.RelativeContractNo as RelativeContractNo,"+
		   " BC.RelativeSerialNo as RelativeSerialNo,"+
		   " BC.CustomerName as CustomerName," + 
		   " getBusinessName(BC.BusinessType) as BusinessTypeName,"+
		   " getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
		   " getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
		   " getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
		   " BC.BusinessSum as BusinessSum,BC.Balance as Balance,"+
		   " getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
		   " getItemName('BadLoanCaliber',BC.BadLoanCaliber) as BadLoanCaliberName," + 
		   " BC.InterestBalance1 as InterestBalance1,BC.InterestBalance2 as InterestBalance2,"+
		   " BW.OccurDate as OccurDate,BW.TransactionFlag as TransactionFlag,"+
		   " BW.OccurDirection as OccurDirection,BW.OccurType as OccurType,"+
		   " BW.OccurSubject as OccurSubject,BC.BusinessType as BusinessType," + 
		   " BW.BusinessDesc as BusinessDesc,BW.ActualSum as ActualSum, " + 
		   " BW.MendDate as MendDate "+
		   " from BUSINESS_WASTEBOOK BW,BUSINESS_CONTRACT BC "+
		   " where BW.RelativeContractNo=BC.SerialNo and BC.RecoveryUserID='"+CurUser.UserID+"'"+
		   " and BC.RecoveryOrgID ='"+CurOrg.OrgID+"'"+
		   " and substr(BC.ClassifyResult,1,2)>'02' "+
		   " and (BC.FinishDate is  null or BC.FinishDate ='')";
		   
	//������ͼȡ��ͬ�����	   
	if(sDealType.equals("020020010"))//���ʽ����δ����
	{
		sSql+=" and (BW.ManageFlag1 is  null or BW.ManageFlag1 ='') ";
	}else if(sDealType.equals("020020020"))//���ʽ�����Ѳ���
	{
		sSql+=" and BW.ManageFlag1 ='010' ";
	}else
	{
		sSql+=" and 1=2";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	//��������
	doTemp.setVisible("RelativeSerialNo,BusinessType,OccurDate,TransactionFlag,OccurDirection,OccurType,OccurSubject,BusinessDesc",false);	
    
	//�����п�
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("ActualSum"," style={width:95px} ");


	//���ý��Ϊ��λһ������
	doTemp.setType("ActualSum,BusinessSum,Balance,InterestBalance1,InterestBalance2,ActualSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("ActualSum,BusinessSum,Balance,InterestBalance1,InterestBalance2,ActualSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("ActualSum,BusinessSum,Balance,InterestBalance1,InterestBalance2,ActualSum","3");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,RelativeContractNo","IsFilter","1");
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
		{"false","","Button","���ʽ����","���ʽ����","account_Vindicate()",sResourcesPath},
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		{"true","","Button","̨������","̨������","account_Info()",sResourcesPath},
		{"true","","Button","�����������","�����������","view_Opinions()",sResourcesPath},
		{"false","","Button","���ʽ��������","���ʽ��������","account_Vindicate()",sResourcesPath},
		{"false","","Button","�������","�������","mend_Complete()",sResourcesPath}
		};
	
	if(sDealType.equals("020020010"))//���ʽ�����Ѳ���
	{
		sButtons[getBtnIdxByName(sButtons,"���ʽ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�������")][0]="true";
	}else if(sDealType.equals("020020020"))//���ʽ�����Ѳ���
	{
		sButtons[getBtnIdxByName(sButtons,"���ʽ��������")][0]="true";
	}

%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=���ǻ��ʽ�б�;InputParam=��;OutPutParam=��;]~*/    
	function account_Vindicate()
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
			popComp("WasteBookMendList","/RecoveryManage/NPAManage/NPADailyManage/WasteBookMendList.jsp","ComponentName=���ǽ����б�&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
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
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/  	
	function mend_Complete()
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
			//��֤������Ϣ�Ƿ���д
			sReturn=RunMethod("PublicMethod","GetColValue","count(SerialNo),BUSINESS_WASTEBOOK_MEND,String@RelativeWasteBookNo@"+sSerialNo);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "0") 
			{	
				alert("����л��ʽ���Ǻ��ٵ��!");
				return;
			}else
			{
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageFlag1@010@String@MendDate@<%=StringFunction.getToday()%>,BUSINESS_WASTEBOOK,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('71'));//�����ɹ�
					self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=�鿴���޸ĺ�ͬ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ú�ͬ��ˮ��
		var sContractNo=getItemValue(0,getRow(),"RelativeContractNo");  		
		//���ҵ��Ʒ��
		var sBusinessType=getItemValue(0,getRow(),"BusinessType"); 
		if (typeof(sContractNo)=="undefined" || sContractNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			
			if(sBusinessType=="8010" || sBusinessType=="8020" || sBusinessType=="8030")
			{
				OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=�б�&ComponentType=MainWindow&SerialNo="+sContractNo+"&Flag=Y&CurItemDescribe3="+sBusinessType+"","_blank",OpenStyle);
			}else
			{
			  sObjectType = "AfterLoan";
				sObjectNo = sContractNo;
				sViewID = "002";
				sCompID = "CreditTab";
				sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
				sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
		}
	}
	
	/*~[Describe=̨������;InputParam=��;OutPutParam=��;]~*/
	function account_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"RelativeContractNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/AccountVindicateInfo.jsp?SerialNo="+sSerialNo+"&ViewType=BusinessWasteBook","_self",""); 
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

<%@include file="/IncludeEnd.jsp"%>