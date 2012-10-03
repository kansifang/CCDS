<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:lpzhang 2009-8-9
		Tester:
		Content: ������¥���Э��
		Input Param:
			
		Output param:
		History Log: 
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���̻�е���Ҷ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";

	//�������
	String sSql = "";
	String sWhere = "";
	//������Ϣ���µĵ�Ѻ��	
	PG_TITLE = "������¥���Э���б�";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����				
	String[][] sHeaders = {		
							{"SerialNo","Э����ˮ��"},              	
							{"CustomerName","����������"},              
							{"ProjectName","������Ŀ����"},            
							{"Currency","����"},                    
							{"LoanSum","�����ܶ�Ƚ��"},           	
							{"PutOutDate","Э��ǩ������"},            	
							{"Maturity","Э�鵽������"}, 
							{"FreezeFlag","�����־"},   
							{"InputUserName","�Ǽ���"},                  
							{"InputOrgName","�Ǽǻ���"},                
							{"InputDate","�Ǽ�����"},                
							{"UpdateDate","��������"},    
						 };
	

	sSql =  " select SerialNo,CustomerName,ProjectName,LoanSum,"+
			" getItemName('Currency',Currency) as Currency,getItemName('FreezeFlag',FreezeFlag) as FreezeFlag,PutOutDate,Maturity, "+
			" getUserName(InputUserID) as InputUserName,UpdateDate "+
			" from Ent_Agreement where AgreementType = 'BuildAgreement' and FreezeFlag <> '' and FreezeFlag is not null  ";
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//��ӻ�������
	sWhere += OrgCondition.getOrgCondition("InputOrgID",CurOrg.OrgID,Sqlca); 
	doTemp.WhereClause+=sWhere;
	
	doTemp.UpdateTable="Ent_Agreement";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("Currency","2");
	
	doTemp.setType("LoanSum","Number");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	
	//����Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	if(!"".equals(sObjectNo))
	{
		dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteApplyRelative(#AgreementType,#SerialNo)");
	}	
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
		{"true","","Button","����","�����Э��","FreezeAgreement()",sResourcesPath},
		{"true","","Button","�ⶳ","�ⶳ��Э��","CancelFreeze()",sResourcesPath},
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
		OpenComp("BuildAgreementInfo","/CreditManage/CreditLine/BuildAgreementInfo.jsp","","_blank",OpenStyle)
		reloadSelf();
	}
	
	/*~[Describe=����Э��;InputParam=��;OutPutParam=��;]~*/
	function FreezeAgreement()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sReturn = RunMethod("CreditLine","CheckFreeze",sSerialNo);
		if(sReturn == "2")
		{
			alert("�ö���Ѿ������ᣬ���ܽ��д˲�����");
			return;
		}
		
		if(confirm("��ȷ��Ҫ����˶����"))
		{
	        RunMethod("CreditLine","FreezeAgreement",sSerialNo);
	        reloadSelf();
		}
	}
	
	
	/*~[Describe=�ⶳЭ��;InputParam=��;OutPutParam=��;]~*/
	function CancelFreeze()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sReturn = RunMethod("CreditLine","CheckFreeze",sSerialNo);
		if(sReturn != "2")
		{
			alert("�ö��δ�����ᣬ���ܽ��д˲�����");
			return;
		}
		
		if(confirm("��ȷ��Ҫ����˶�ȶ�����"))
		{
	        RunMethod("CreditLine","CancelFreeze",sSerialNo);
	        reloadSelf();
		}
	}
	
	/*~[Describe=Э������ҵ��;InputParam=��;OutPutParam=��;]~*/
	function AgreementBusiness()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sAgreementType   = "BuildAgreement";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("AgreementBusiness","/CreditManage/CreditLine/AgreementBusiness.jsp","SerialNo="+sSerialNo+"&AgreementType="+sAgreementType,"_blank",OpenStyle);
		}
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
			OpenComp("BuildAgreementInfo","/CreditManage/CreditLine/BuildAgreementInfo.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=Э���ѯ;InputParam=��;OutPutParam=��;]~*/
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
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>