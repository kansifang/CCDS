<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/10/20
*	Tester:
*	Describe: ���ʽ������ʾ��Ϣ
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ʽ������ʾ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//����������
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
							{"OccurDate","��������"},
							{"TransactionFlag","���ױ�־"},
							{"OccurDirection","��������"},
							{"OccurType","��������"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"BusinessCurrencyName","����"},
							{"BusinessSum","���"},
							{"Balance","���"},
							{"PutOutDate","��ʼ��"},
							{"Maturity","������"},
							{"OccurSubject","����ժҪ"},
							{"BusinessDesc","��������"},
							{"ActualSum","ʵ�ʷ�����"}
						}; 

 	sSql = " select BW.SerialNo as SerialNo," + 	
		   " BW.RelativeContractNo as RelativeContractNo,BW.CustomerName as CustomerName," + 
		   " getBusinessName(BC.BusinessType) as BusinessTypeName,"+
		   " BW.OccurDate as OccurDate,BW.TransactionFlag as TransactionFlag,"+
		   " BW.OccurDirection as OccurDirection,getItemName('OccurType',BC.OccurType) as OccurType,"+
		   " getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
		   " getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
		   " BC.BusinessSum as BusinessSum,BC.Balance as Balance,"+
		   " BC.PutOutDate as PutOutDate,BC.Maturity as Maturity,"+
		   " BW.OccurSubject as OccurSubject,BC.BusinessType as BusinessType," + 
		   " BW.BusinessDesc as BusinessDesc,BW.ActualSum as ActualSum " +  
		   " from BUSINESS_WASTEBOOK BW,BUSINESS_CONTRACT BC "+
		   " where BW.RelativeContractNo=BC.SerialNo and BC.RecoveryUserID='"+CurUser.UserID+"'"+
		   " and BC.RecoveryOrgID ='"+CurOrg.OrgID+"'"+
		   " and substr(BC.ClassifyResult,1,2)>'02'"+
		   " and (BW.ManageFlag1 is  null or BW.ManageFlag1 ='')";
		   
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	//��������
	doTemp.setVisible("ActualSum,BusinessDesc,OccurSubject,OccurDirection,TransactionFlag,OccurDate,BusinessType",false);	
    
	//�����п�
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("ActualSum"," style={width:95px} ");;


	//���ý��Ϊ��λһ������
	doTemp.setType("ActualSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("ActualSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("ActualSum","3");
	
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
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		};

%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	
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