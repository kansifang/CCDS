<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: ɾ����Ч�ͻ�
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
	String sHeaders[][] = {
						{"CustomerID","�ͻ�����"},
						{"CustomerName","�ͻ�����"},
						{"CustomerTypeName","�ͻ�����"},
						{"CertTypeName","֤������"},
						{"CertID","֤������"}				
		      		};

	sSql = 	" select distinct CI.CustomerID,CI.CustomerName,getItemName('CustomerType',CI.CustomerType) as CustomerTypeName, "+
	" CI.CustomerType,getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID " +
	" from CUSTOMER_BELONG CB,CUSTOMER_INFO CI " +
	" where CB.CustomerID = CI.CustomerID "+			
	" and CB.OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	              
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "CUSTOMER_BELONG";
	//��������
	doTemp.setKey("CustomerID,OrgID,UserID",true);	
	
	//���ò��ɼ���
	doTemp.setVisible("CustomerType",false);
	//���ֶ��Ƿ�ɸ��£���Ҫ���ⲿ���������ģ�����UserName\OrgName	    
	doTemp.setUpdateable("CertTypeName,CustomerTypeName,UserName",false);
	//����html��ʽ
	doTemp.setHTMLStyle("CustomerID,UserName,CustomerTypeName,CertTypeName"," style={width:100px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
		
	//���ӹ�����
	doTemp.setColumnAttribute("CustomerName,CertID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
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
			   {"true","","Button","����","������Ч�ͻ���Ϣ","clearCustomer()",sResourcesPath}
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
	/*~[Describe=������Ч�ͻ�;InputParam=��;OutPutParam=��;]~*/
	function clearCustomer()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sCustomerType = getItemValue(0,getRow(),"CustomerType"); 		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{			
			sReturn = PopPage("/SystemManage/SynthesisManage/DeleteCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType, "_self","");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
				return;  
			}else
			{
				alert(getBusinessMessage('947'));//��Ч�ͻ����ɹ�����
				reloadSelf();
			}
		}
	}	
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>

	
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
