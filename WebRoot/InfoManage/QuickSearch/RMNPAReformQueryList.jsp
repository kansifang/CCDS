<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   FSGong  2005.01.26
			Tester:
			Content: �����ʲ����鷽�����ٲ�ѯ
			Input Param:
		   ItemID������״̬     
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
		String PG_TITLE = "�����ʲ����鷽�����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql="";
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//������ʾ����
	String sHeaders[][] = { 							
						{"SerialNo","���鷽����ˮ��"},
						{"ApplyType","�����������"},
						{"ApplyTypeName","�����������"},
						{"ProjectName","����������"},
						{"BusinessSum","�����鱾��"},
						{"PaymentDate","����������"},
						{"InputUserName","�Ǽ���"},
						{"InputOrgName","�Ǽǻ���"},
						{"InputDate","�Ǽ�����"}
					}; 
					
	//��������Ϣ��BUSINESS_APPLY��ѡ�����鷽���б�(�������Ϊ��ǰ�û���Ͻ������ҵ��Ʒ��Ϊ6010)
	sSql =  " select SerialNo,ApplyType,"+
	" getItemName('ReformType',ApplyType) as ApplyTypeName,ProjectName," +	
	" BusinessSum,PaymentDate, " +	
	" getUserName(InputUserID) as InputUserName,getOrgName(InputOrgID) as InputOrgName,InputDate" +	
	" from BUSINESS_APPLY  " +
	" where  BusinessType = '6010' " +
	" and  OperateOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_APPLY";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("ApplyType,SerialNo",false);	

	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setCheckFormat("Balance","2");
	
	//���ö��뷽ʽ	
	doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("Balance","3");	
	
	//�����ֶ���ʾ���
	doTemp.setHTMLStyle("ApplyTypeName,ProjectName,BusinessSum,PaymentDate"," style={width:100px} ");
	doTemp.setHTMLStyle("PaymentDate,"," style={width:80px} ");
	doTemp.setHTMLStyle("ProjectName,"," style={width:120px} ");
	doTemp.setUpdateable("ApplyTypeName",false); 
	
	//���ɲ�ѯ��
	doTemp.setDDDWCode("ApplyType","ReformType");
	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","InputUserName","");
	doTemp.setFilter(Sqlca,"2","InputOrgName","");
	doTemp.setFilter(Sqlca,"3","ApplyType","Operators=EqualsString;");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ


	//����HTMLDataWindow
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
	
		//���Ϊ�����鲻���ʲ������б���ʾ���°�ť
		
		String sButtons[][] = {
			{"true","","Button","������ԭ����","�鿴�����鲻���ʲ�","viewAndEdit()",sResourcesPath},
			{"true","","Button","���鷽������","�鿴���鷽������","viewReform()",sResourcesPath},
			{"true","","Button","������´���","�鿴���������Ϣ","ReformCredit()",sResourcesPath}
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
		//������ˮ��		
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");  
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=�����鲻���ʲ������б�&ComponentType=MainWindow&SerialNo="+sSerialNo+"&ItemID=060&QueryFlag=Query","_blank",OpenStyle);

	}
	
	//���鷽��������Ϣ
	function viewReform()
	{
		//���������ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
		}
		else
		{
			sObjectType = "NPAReformApply";
			sObjectNo = sSerialNo;
			sViewID = "002";
			
			openObject(sObjectType,sObjectNo,sViewID);
			
		}
		
		
	}
	
	//���������Ϣ
	function ReformCredit()
	{
		//������鷽����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo"); 
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
			
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=�ʲ������б�?&ComponentType=MainWindow&SerialNo="+sSerialNo+"&Flag=ReformCredit&ItemID=060&QueryFlag=Query","_blank",OpenStyle);

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
