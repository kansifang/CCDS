<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	 /*
		Author: pliu 2011-12-02
		Tester:
		Describe: ��ҵ��ģ�϶�����
		Input Param:
		Output Param:
		HistoryLog:  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ҵ��ģ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//���������sql���
	String sSql = "";			 
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
								{"CustomerID","�ͻ����"},
								{"EnterpriseName","�ͻ�����"},
								{"CertTypeName","֤������"},
								{"CertID","֤������"},
								{"IndustryName","��ҵ��ģ������ҵ����"},
								{"EmployeeNumber","��ҵ��Ա(��)"},
								{"SellSum","Ӫҵ����(��Ԫ)"},
								{"TotalAssets","�ʲ��ܶ�(��Ԫ)"},
								{"Scope","��ҵ��ģ"},	
								{"LockEntScale","������ʶ"}
				      		};

    sSql = 	" select EI.CustomerID,EI.EnterpriseName,getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID,getItemName('IndustryName',IndustryName) as IndustryName,EI.EmployeeNumber,EI.SellSum,EI.TotalAssets,getItemName('Scope',EI.scope) as Scope,getItemName('EntScale',EI.LockEntScale) as LockEntScale"+
            " from ENT_INFO EI,CUSTOMER_INFO CI " +
            " where CI.CustomerType like '01%'  and CI.CustomerType<>'0107' " +
            " and CI.CustomerID = EI.CustomerID and lockentscale = '01' ";

    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	//doTemp.UpdateTable = "ENT_INFO";
	//��������
	doTemp.setKey("CustomerID",true);	
	
	//���ֶ��Ƿ�ɸ��£���Ҫ���ⲿ���������ģ�����UserName\OrgName	    
	//doTemp.setUpdateable("CertTypeName,CustomerTypeName,UserName",false);
	//����html��ʽ
	doTemp.setHTMLStyle("CustomerID"," style={width:100px} ");
	doTemp.setHTMLStyle("EnterpriseName"," style={width:200px} ");
		
	//���ӹ�����
	doTemp.setColumnAttribute("CustomerID,EnterpriseName,CertID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//������datawindows����ʾ������
	dwTemp.setPageSize(20);
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","�鿴�ͻ�����","�鿴�ͻ�����","CustomerInfo()",sResourcesPath},
			{"true","","Button","ȡ����ҵ��ģ����","ȡ������","Cancel()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function CustomerInfo()
	{
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sReturn = PopPage("/InfoManage/DataInput/CustomerQueryAction.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("Ҫ��ѯ�Ŀͻ���Ϣ�����ڣ�");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("Ҫ��ѯ�Ŀͻ�����Ϊ�գ���ѡ��ͻ����ͣ�");
			}
			
			////openObject("ReinforceCustomer",sCustomerID,"002");
			openObject("Customer",sCustomerID,"001");
		}
	}		
	function Cancel()
	{
	    sEntSignal = "02";
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		//sReturn =	RunMethod("CustomerManage","CheckLockEntScale",sCustomerID);		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{   
		    //if(confirm(getHtmlMessage('73')))
		    //{	   
			   RunMethod("CustomerManage","RelativeEntScale",sCustomerID+","+sEntSignal);
               reloadSelf();
            //}
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
