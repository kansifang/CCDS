<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: hxli 2005-8-2
				
*	Tester:
*	Describe: �����ʲ���Ϣ�����б�;
*		  �Ӻ�ͬ��BUSINESS_CONTRACT �л�ȡ���ݣ����У���ȫ�����ˣ�CurUser and �峥����FinishDateΪ�� and ҵ��Ʒ��BusinessType Like ���Ŵ����Ʒ���е����ݡ�
*		  ҵ��Ʒ��ҵ��Ʒ��BusinessType ��80��Ϊ�����಻���ʲ�������Ϊ�Ŵ��಻���ʲ�
*	Input Param:
*		ItemMenuNo :�˵����
*		      01010��δ�峥���Ŵ��಻���ʲ�		      
*		      01030���Ѻ������Ŵ��಻���ʲ�
*		      01040�����峥���Ŵ��಻���ʲ�		    
*	Output Param:     
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ���Ϣ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSerialNo = "" ; //��ͬ���
	String sWhereCondition = "";
		
	//����������
	String sItemMenuNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo")); //CodeLibrary �ж���describe���
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sItemMenuNo.equals("01010"))	//δ�ս���Ŵ��಻���ʲ�
		sWhereCondition = " And (FinishDate is null or FinishDate='') And BusinessType Not Like '8%' order by SerialNo desc ";           //δ�峥�ı�־���峥����Ϊ��	
	else if(sItemMenuNo.equals("01040")) //���ս���Ŵ��಻���ʲ�
	{
		if(sDBName.startsWith("INFORMIX"))			  
			sWhereCondition = " And (FinishDate is not null and  FinishDate <> '') And ((FinishType not like '060%' ) or FinishType is null) order by SerialNo desc ";   //FinishType=060�Ѻ���
		else if(sDBName.startsWith("ORACLE"))
			sWhereCondition = " And (FinishDate is not null and  FinishDate <> ' ') And ((FinishType not like '060%' ) or FinishType is null) order by SerialNo desc ";   //FinishType=060�Ѻ���	
		else if(sDBName.startsWith("DB2"))
			sWhereCondition = " And (FinishDate is not null and  FinishDate <> '') And ((FinishType not like '060%' ) or FinishType is null) order by SerialNo desc ";   //FinishType=060�Ѻ���	 
	}
	else if(sItemMenuNo.equals("01030")) //�Ѻ������Ŵ��಻���ʲ�
	{	  
		if(sDBName.startsWith("INFORMIX"))
			sWhereCondition = " And (FinishDate is not null  and  FinishDate <> '') And FinishType like '060%' order by SerialNo desc ";   //FinishType=060�Ѻ���
		else if(sDBName.startsWith("ORACLE"))
			sWhereCondition = " And (FinishDate is not null  and  FinishDate <> ' ') And FinishType like '060%' order by SerialNo desc ";   //FinishType=060�Ѻ���
		else if(sDBName.startsWith("DB2"))
			sWhereCondition = " And (FinishDate is not null  and  FinishDate <> '') And FinishType like '060%' order by SerialNo desc ";   //FinishType=060�Ѻ���		
	}
%>                    
<%/*~END~*/%>         

                      
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"BusinessSum","���"},
							{"Maturity","��������"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
							{"BusinessCurrencyName","����"},
							{"ActualPutOutSum","��ʵ�ʳ��ʽ��"},
							{"Balance","��ǰ���"},
							{"ShiftBalance","�ƽ����"},
							{"FinishType","�峥����"},
							{"FinishDate","�峥����"},
							{"ClassifyResultName","�弶����"},
							{"ManageUserName","ԭ�ܻ���"},
							{"ManageOrgName","ԭ�ܻ�����"}
						}; 

 	String sSql = "select SerialNo," + 
 				" CustomerName," +	
				 " BusinessSum," + 
				 " Maturity," +  
				 " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
				 " getItemName('OccurType',OccurType) as OccurTypeName," + 
                 " BusinessCurrency,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
				 " ActualPutOutSum,ShiftBalance,nvl(Balance,0) as Balance," + 
				 " nvl(InterestBalance1,0) as InterestBalance1, "+
				 " nvl(InterestBalance2,0) as InterestBalance2, " + 
				 " getItemName('FinishType',FinishType) as FinishType," + 
				 " FinishDate," +  
				 " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
				 " getUserName(ManageUserID) as ManageUserName," + 
				 " getOrgName(ManageOrgID) as ManageOrgName" + 
				 " from BUSINESS_CONTRACT" +
				 " Where RecoveryUserID = '" +CurUser.UserID+"'" + 
				 " And ShiftType ='02' " + sWhereCondition;     //�ƽ�����Ϊ02-�ʻ��ƽ�

	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	//doTemp.setKey("RecoveryUserID",true);	 //���ùؼ���
	//���ù��ø�ʽ
	if (sItemMenuNo.equals("01010")||sItemMenuNo.equals("01030")||sItemMenuNo.equals("01040")) 
	{
		doTemp.setVisible("BusinessType,ActualPutOutSum,InterestBalance1,InterestBalance2,FinishType,FinishDate,ClassifyResult,BusinessCurrency",false);
	}else 
	{
		doTemp.setVisible("BusinessType,BusinessSum,ActualPutOutSum,InterestBalance1,InterestBalance2,ClassifyResult,BusinessCurrency",false);
	}
	
	//����ѡ��˫�����п�
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:180px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("Balance,ShiftBalance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,Balance,ShiftBalance,ActualPutOutSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ShiftBalance,ActualPutOutSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,Balance,ShiftBalance,ActualPutOutSum,OperateUserName,OperateOrgName","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName,ClassifyResultName","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo,CustomerName","IsFilter","1");
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
				{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
				{"true","","Button","�ճ�����","�ճ�������Ϣ","my_ManageView()",sResourcesPath},
				{"true","","Button","�ս�","��ͬ�鵵�ս����","my_FinishPigeonhole()",sResourcesPath},
				{"true","","Button","תδ�ս�","��ͬתδ�ս����","my_ExitPigeonhole()",sResourcesPath},
				{"true","","Button","���ʽ����","���ʽ����","my_ReturnWay()",sResourcesPath},
		};

	if (sItemMenuNo.equals("01010")) 
	{
		sButtons[3][0] = "false";	
	}	
		
	if (sItemMenuNo.equals("01030")) 
	{
		sButtons[2][0] = "false";
		sButtons[4][0] = "false";
	}
	
	if (sItemMenuNo.equals("01040")) 
	{
		sButtons[2][0] = "false";
		sButtons[4][0] = "false";
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
	/*~[Describe=��̨ͬ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_ManageView()
	{ 
		//��ͬ��ˮ�š���ͬ��š��ͻ�����,����
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sItemMenuNo = "<%=sItemMenuNo%>";
		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
			return;
		}
		else
		{
			sObjectType = "NPABook";
			sObjectNo = sSerialNo;
			
			if(sItemMenuNo == "01030" || sItemMenuNo == "01040" ) 
				sViewID = "002";
			else
				sViewID = "001";
			
			openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
    /*~[Describe=�峥�鵵;InputParam=��;OutPutParam=��;]~*/
	function my_FinishPigeonhole()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{
			//��ȡ��ͬ������ǷϢ������ǷϢ
			sBalance = getItemValue(0,getRow(),"Balance");
			sInterestBalance1 = getItemValue(0,getRow(),"InterestBalance1");
			sInterestBalance2 = getItemValue(0,getRow(),"InterestBalance2");
			if((parseFloat(sBalance)+parseFloat(sInterestBalance1)+parseFloat(sInterestBalance2)) > 0)
			{
				alert(getBusinessMessage('649'));//�ú�ͬ��������ǷϢ������ǷϢ���>0�����ܽ����ս������
				return;
			}else
			{			
				//�����Ի�ѡ���
				sReturn = PopPage("/RecoveryManage/NPAManage/NPADailyManage/NPAFinishedTypeDialog.jsp","","dialogWidth:22;dialogHeight:10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
				if(typeof(sReturn) != "undefined" && sReturn.length != 0)
				{
					ss = sReturn.split('@');
					sFinishedType = ss[0];
					sFinishedDate = ss[1];
					//�ս����
					sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishType@"+sFinishedType+"@String@FinishDate@"+sFinishedDate+",BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
					if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
						alert(getHtmlMessage('62'));//�ս�ʧ�ܣ�
						return;			
					}else
					{
						reloadSelf();	
						alert(getHtmlMessage('43'));//�ս�ɹ���
					}	
				}
			}
		}
	}
	
    /*~[Describe=ת��δ�峥;InputParam=��;OutPutParam=��;]~*/
	function my_ExitPigeonhole()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			if(confirm(getHtmlMessage('63'))) //������뽫����Ϣ�ս�ȡ����
		    {
				//ȡ���鵵����
				sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishType@None@String@FinishDate@None,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
					alert(getHtmlMessage('65'));//ȡ���ս�ʧ�ܣ�
					return;
				}else
				{
					reloadSelf();
					alert(getHtmlMessage('64'));//ȡ���ս�ɹ���
				}				
		   	}
		}
	}
	
	/*~[Describe=�����ʲ����ʽ����;InputParam=��;OutPutParam=��;]~*/
	function my_ReturnWay()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenComp("NPAReturnWayMain","/RecoveryManage/NPAManage/NPADailyManage/NPAReturnWayMain.jsp","ComponentName=�����ʲ����ʽ&ComponentType=MainWindow&DefaultTVItemName=�����ǹ���&SerialNo="+sSerialNo,"_blank",OpenStyle)
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@include file="/IncludeEnd.jsp"%>
