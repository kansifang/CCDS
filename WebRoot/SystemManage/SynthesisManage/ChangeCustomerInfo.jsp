<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: ����ͻ���Ϣ
			Input Param:
			Output Param:
			HistoryLog: fbkang on 2005/08/14 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "����ͻ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//��ñ������ͻ����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//���������sql���
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//���ݿͻ���Ż�ȡ�ͻ�����
	String sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
	if(sCustomerType == null) sCustomerType = "";
	
	String sHeaders[][] = {
						{"CustomerID","�ͻ�����"},
						{"CustomerName","�ͻ�����"},	
						{"NewCustomerName","�ͻ����ƣ��£�"},								
						{"CustomerTypeName","�ͻ�����"},
						{"CertType","֤������"},
						{"NewCertType","֤�����ͣ��£�"},
						{"CertID","֤������"},
						{"NewCertID","֤�����루�£�"}	,
						{"LoanCardNo","������"},
						{"NewLoanCardNo","�����ţ��£�"}				
		      		};

	sSql = 	" select CI.CustomerID,CI.CustomerName,'' as NewCustomerName, "+
	" getItemName('CustomerType',CI.CustomerType) as CustomerTypeName, "+
	" CI.CertType,'' as NewCertType,CI.CertID,'' as NewCertID, " +
	" CI.LoanCardNo,'' as NewLoanCardNo "+
	" from CUSTOMER_INFO CI " +
	" where CI.CustomerID = '"+sCustomerID+"' ";
	              
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "CUSTOMER_INFO";
	//��������
	doTemp.setKey("CustomerID",true);	
	//����������
	doTemp.setDDDWCode("CertType","CertType");	
	doTemp.setDDDWCode("NewCertType","CertType");
	//���ñ༭����
	doTemp.setReadOnly("CustomerID,CustomerTypeName,CustomerName,CertType,CertID,LoanCardNo",true);
	//���ñ�����Ϳɼ���
	if(sCustomerType.equals("03")) //����
	{
		doTemp.setRequired("NewCustomerName,NewCertType,NewCertID",true);
		doTemp.setVisible("LoanCardNo,NewLoanCardNo",false);
	}
	else
		doTemp.setRequired("NewCustomerName,NewCertType,NewCertID",true);
		
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����ΪGrid���
		
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
			   {"true","","Button","����","�������ͻ���Ϣ","saveRecord()",sResourcesPath},
			   {"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		sCustomerType = "<%=sCustomerType%>";
		//��ȡ�����Ŀͻ����ơ�֤�����͡�֤����š�������
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sOldCertType = getItemValue(0,getRow(),"CertType");
		sOldCertID = getItemValue(0,getRow(),"CertID");
		sNewCustomerName = getItemValue(0,getRow(),"NewCustomerName");
		sNewCertType = getItemValue(0,getRow(),"NewCertType");
		sNewCertID = getItemValue(0,getRow(),"NewCertID");
		sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");
		if(sCustomerType == '03') //����
		{		
			if (typeof(sNewCustomerName) == "undefined" || sNewCustomerName == "" 
			|| typeof(sNewCertType) == "undefined" || sNewCertType == "" 
			|| typeof(sNewCertID) == "undefined" || sNewCertID == "")
			{
				alert(getBusinessMessage('923'));//�����������Ŀͻ���Ϣ��
				return;
			}
		}else
		{
			if (typeof(sNewCustomerName) == "undefined" || sNewCustomerName == ""
			|| typeof(sNewCertType) == "undefined" || sNewCertType == ""
			|| typeof(sNewCertID) == "undefined" || sNewCertID == ""
			|| typeof(sNewLoanCardNo) == "undefined" || sNewLoanCardNo == "")
			{
				alert(getBusinessMessage('923'));//�����������Ŀͻ���Ϣ��
				return;
			}
		}
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
							
		//����ͻ���Ϣ
		sReturnValue = RunMethod("CustomerManage","UpdateCustomerInfo",sCustomerID+","+sOldCertType+","+sOldCertID+","+sNewCustomerName+","+sNewCertType+","+sNewCertID+","+sNewLoanCardNo);
	    if(typeof(sReturnValue) == "undefined" && sReturnValue == "") 
		{
			alert(getBusinessMessage('925'));//����ͻ���Ϣʧ��!
			return;
		}else if(sReturnValue == "AlreadyExist")
		{
			alert("��֤ͬ�����ͺ�֤������Ŀͻ��Ѵ��ڣ����飡");
			return;
		}else if(sReturnValue == "Success")
		{
			alert(getBusinessMessage('924'));//����ͻ���Ϣ�ɹ�!
			return;
		}else
		{
			alert(getBusinessMessage('925'));//����ͻ���Ϣʧ��!
			return;
		}
					
	}	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/ChangeCustomerList.jsp","_self","");
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		if(sCustomerType == '01') //��˾�ͻ�
		{		
			//�����֯��������֤����Ч��	
			sNewCertType = getItemValue(0,getRow(),"NewCertType");
			sNewCertID = getItemValue(0,getRow(),"NewCertID");
			//�ж���֯��������Ϸ���
			if(sNewCertType =='Ent01')
			{			
				if(!CheckORG(sNewCertID))
				{
					alert(getBusinessMessage('102'));//��֯������������					
					return;
				}			
			}
			
			//������ŵ���Ч��
			sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");			
			if(typeof(sNewLoanCardNo) != "undefined" && sNewLoanCardNo != "" && sNewLoanCardNo != "000000000000000000")
			{
				if(!CheckLoanCardID(sNewLoanCardNo))
				{
					alert(getBusinessMessage('101'));//����������							
					return false;
				}
				
				//���������Ψһ��
				sCustomerID = getItemValue(0,getRow(),"CustomerID");
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoChangeCustomer",sCustomerID+","+sNewLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('227'));//�ô������ѱ������ͻ�ռ�ã�							
					return false;
				}						
			}						
		}
				
		if(sCustomerType == '03') //���˿ͻ�
		{
			//1:У��֤������Ϊ���֤����ʱ���֤ʱ�����������Ƿ�֤ͬ������е�����һ��
			sNewCertType = getItemValue(0,getRow(),"NewCertType");
			sNewCertID = getItemValue(0,getRow(),"NewCertID");			
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sNewCertType == 'Ind01' || sNewCertType =='Ind08')
			{
				if (!CheckLisince(sNewCertID))
				{
					alert(getBusinessMessage('156'));//���֤��������					
					return;
				}
			}								
		}
		return true;	
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
