<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   slliu 2004.11.22
			Change by FSGong  2005.01.25
			Tester:
			Content: ���ٵĲ����ʲ����ٲ�ѯ
			Input Param:
		       
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "���ٵĲ����ʲ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�����ͷ
	String sHeaders[][] = {
								{"SerialNo","��ͬ��ˮ��"},
								{"ArtificialNo","��ͬ���"},
								{"BusinessType","ҵ��Ʒ��"},
								{"BusinessTypeName","ҵ��Ʒ��"},
								{"OccurType","��������"},
								{"OccurTypeName","��������"},
								{"CustomerName","�ͻ�����"},
								{"BusinessCurrencyName","����"},
								{"BusinessSum","���(Ԫ)"},
								{"ShiftBalance","�ƽ����(Ԫ)"},
								{"Balance","��ǰ���(Ԫ)"},
								{"Maturity","��������"},
								{"Flag5","�Ƿ��ϲ���"},
								{"Flag5Name","�Ƿ��ϲ���"},
								{"ClassifyResult","�弶����"},
								{"ClassifyResultName","�弶����"},
								{"ShiftType","�ƽ�����"},				
								{"ShiftTypeName","�ƽ�����"},				
								{"RecoveryUserID","�����ܻ���"},
								{"RecoveryUserName","�����ܻ���"},
								{"RecoveryOrgID","�����ܻ�����"},
								{"RecoveryOrgName","�����ܻ�����"},
								{"ManageUserName","ԭ�ܻ���"},
								{"ManageOrgName","ԭ�ܻ�����"}
							}; 
	

 	//�Ӻ�ͬ����ѡ�������ʲ��ܻ�����Ϊ��¼�û����ڻ����Ĳ����ʲ�
 	String sSql = "select BC.SerialNo as SerialNo, BC.ArtificialNo as ArtificialNo," + 	
				 " BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName," + 
				 " BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
				 " BC.CustomerName as CustomerName," + 
				 " getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
				 " BC.BusinessSum as BusinessSum,BC.ShiftBalance as ShiftBalance,BC.Balance as Balance,"+
				 " BC.Maturity as Maturity,BC.Flag5, getItemName('Flag5',BC.Flag5) as Flag5Name," + 
				 " BC.ClassifyResult as ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName," +  
				 " BC.ShiftType as ShiftType,getItemName('ShiftType',BC.ShiftType) as ShiftTypeName," + 
				 
				 " BC.RecoveryUserID as RecoveryUserID," + 
				 " BC.RecoveryOrgID as RecoveryOrgID," + 
				 " getUserName(BC.RecoveryUserID) as RecoveryUserName," + 
				 " getOrgName(BC.RecoveryOrgID) as RecoveryOrgName," + 
				 
				 " getUserName(BC.ManageUserID) as ManageUserName," + 
				 " getOrgName(BC.ManageOrgID) as ManageOrgName" + 
				 " from BUSINESS_CONTRACT BC,TRACE_INFO TI" +
				 " Where BC.SerialNo = TI.ContractNo "+
				 " and TI.TraceUserid is not null"+	//�����˲�Ϊ��
				 " and (TI.CancelFlag='' or TI.CancelFlag is null) ";
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("BC.SerialNo");	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,ShiftType,BusinessType,ShiftType,FinishType,FinishDate,ClassifyResult,RecoveryOrgID,RecoveryUserID,OccurType,Flag5,ClassifyResult",false);
    
	
	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,Balance,ActualPutOutSum","3");
	
	//����ѡ��˫�����п�
	doTemp.setHTMLStyle("ArtificialNo"," style={width:100px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("OccurTypeName,Flag5Name"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName,RecoveryOrgName"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:80px} ");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,OccurType,Flag5,ShiftType,ClassifyResult,RecoveryOrgName,RecoveryUserName","IsFilter","1");
	doTemp.setDDDWCode("OccurType","OccurType");
	doTemp.setDDDWCode("Flag5","Flag5");
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult");
	doTemp.setDDDWCode("ShiftType","ShiftType");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(16); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
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
		{"true","","Button","��ͬ����","�鿴�����ʲ�����","viewAndEdit()",sResourcesPath}		
	};
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
    	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ú�ͬ��ˮ��
		var sContractNo=getItemValue(0,getRow(),"SerialNo");  
		
		//���ҵ��Ʒ��
		var sBusinessType=getItemValue(0,getRow(),"BusinessType"); 
		if (typeof(sContractNo)=="undefined" || sContractNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		else
		{
			
			if(sBusinessType=="8010" || sBusinessType=="8020" || sBusinessType=="8030")
			{
				OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=�б�?&ComponentType=MainWindow&SerialNo="+sContractNo+"&Flag=Y&CurItemDescribe3="+sBusinessType+"","_blank",OpenStyle);
			}
			else
			{
			  	sObjectType = "AfterLoan";
				sObjectNo = sContractNo;
				sViewID = "001";
				
				openObject(sObjectType,sObjectNo,sViewID);
			}
		}
	}

</script>
<%
	/*~END~*/
%>	

<%
		/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
	%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>

<%@include file="/IncludeEnd.jsp"%>