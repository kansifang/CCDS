<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:lpzhang 2009-8-5
		Tester:
		Content: ���̻�е���Ҷ��
		Input Param:
			
		Output param:
		History Log: 
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���̻�е���Ҷ��"; // ��������ڱ��� <title> PG_TITLE </title>
	//CurPage.setAttribute("ShowDetailArea","true");
	//CurPage.setAttribute("DetailAreaHeight","200");
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));//������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));//������
	String ESerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ESerialNo"));//��Э����
	String sModel = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Model"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sModel == null) sModel = "";
	if(ESerialNo == null) ESerialNo = "";
	if(sObjectType == null) sObjectType = "";
	//������Ϣ���µĵ�Ѻ��	
	//PG_TITLE = "<font color='blue'>���Ҷ����Э��["+sObjectNo+"]���µĴ�Э��</font>@PageTitle";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	String sMainTable="";
	
	if("Credit".equals(sModel)){
		if(sObjectType.equals("BusinessContract"))
			sMainTable = "Contract_Relative";
		else
			sMainTable = "Apply_Relative";
			
		ESerialNo = Sqlca.getString("select ObjectNo from "+sMainTable+" where SerialNo ='"+sObjectNo+"' and ObjectType ='ProjectAgreement'");
	}
	//��ʾ����				
	String[][] sHeaders = {		
							{"SerialNo","��Э����ˮ��"},              	
							{"DealerName","����������"},              
							{"LoanTypeName","���̻�е����"},            
							{"Currency","����"},                    
							{"BailRatio","�ɴ汣֤�����(%)"}, 
							{"CompanyBailRatio","���������̱���(%)"},    	
							{"DealerBailRatio","���о����̱���(%)"},   	
							{"CreditSum","��Э���Ƚ��"},           	
							{"TermMonth","����(��)"},            	
							{"LimitSum","��ߴ�����"},           	
							{"LimitLoanTerm","��ߴ�������(��)"},    	
							{"LimitLoanRatio","��ߴ������(%)"},      	
							{"Remark","��ע"},                    
							{"InputUserName","�Ǽ���"},                  
							{"InputOrgName","�Ǽǻ���"},                
							{"InputDate","�Ǽ�����"},                
							{"UpdateDate","��������"},    
						 };
	

	sSql =  " select SerialNo,DealerName,LoanType,getItemName('AgreementLoanType',LoanType) as LoanTypeName,CreditSum,"+
			" getItemName('Currency',Currency) as Currency,LimitSum,LimitLoanTerm,LimitLoanRatio, "+
			" getUserName(InputUserID) as InputUserName,UpdateDate "+
			" from Dealer_Agreement DA where ObjectNo = '"+ESerialNo+"'  order by SerialNo desc";
	
			
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="Dealer_Agreement";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	
	doTemp.setAlign("Currency","2");
	doTemp.setVisible("LoanType",false);
	doTemp.setType("CreditSum,LimitSum,LimitLoanTerm,LimitLoanRatio","Number");
	doTemp.setHTMLStyle("DealerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","��ѯ","��ѯ","payBackCheck()",sResourcesPath},
		{"true","","Button","Э������ҵ��","Э������ҵ��","AgreementBusiness()",sResourcesPath},
	};
		
		
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sInputDate = getItemValue(0,getRow(),"InputDate");
		OpenComp("DealerAgreementInfo","/CreditManage/CreditLine/DealerAgreementInfo.jsp","ESerialNo=<%=ESerialNo%>&ObjectNo=<%=sObjectNo%>","_blank",OpenStyle);
		reloadSelf();
	}
	
	
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
       		as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
			reloadSelf();
   		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("DealerAgreementInfo","/CreditManage/CreditLine/DealerAgreementInfo.jsp","SerialNo="+sSerialNo+"&ESerialNo=<%=ESerialNo%>&ObjectNo=<%=sObjectNo%>","_blank",OpenStyle);
			reloadSelf();
		}
	}
	/*~[Describe=Э������ҵ��;InputParam=��;OutPutParam=��;]~*/
	function AgreementBusiness()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sAgreementType   = "ConstructContractNo";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("AgreementBusiness","/CreditManage/CreditLine/AgreementBusiness.jsp","SerialNo="+sSerialNo+"&AgreementType="+sAgreementType,"_blank",OpenStyle);
		}
	}
	/*~[Describe=,������ʾ��Э������ĵ���Э��;InputParam=��;OutPutParam=��;]~*/
	/*function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����RAGREEMENT
		sInputDate = getItemValue(0,getRow(),"InputDate");
		OpenComp("DealerAgreementInfo","/CreditManage/CreditLine/DealerAgreementInfo.jsp","SerialNo="+sSerialNo+"&ESerialNo=<%=ESerialNo%>&ObjectNo=<%=sObjectNo%>","DetailFrame","");
	}
    */
	
	/*~[Describe=����ѯ;InputParam=��;OutPutParam=��;]~*/
	function payBackCheck()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = sSerialNo;
		sObjectType = "EntAgreement";
		sTradeType = "6003";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}else{
			alert("���͸���ϵͳ�ɹ����ռ仹���ܶ�Ϊ["+parseFloat(sReturn[1])+"]");
			//reloadSelf();
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	//if("<%=sObjectNo%>".length == 0 || typeof("<%=sObjectNo%>") == "undefined")
	//{
	//	alert("���ȱ��湤�̻�е���Ҷ����Э�飡");
	//}
	//var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>