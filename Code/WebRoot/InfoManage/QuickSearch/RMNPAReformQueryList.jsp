<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
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
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ����鷽�����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql="";	

	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//������ʾ����
	String sHeaders[][] = { 							
								{"SerialNo","���鷽����ˮ��"},
								{"Type1","�����������"},
								{"ApplyType","���鷽������"},
								{"ApplyTypeName","���鷽������"},
								{"ReformTypeName","������ʽ"},
								{"FirstReformFlag","�Ƿ��״�����"},
								{"DRTimes","�ۼ��������"},
								{"FirstBusinessSum","�״����������"},
								{"des1","���޽���˵����˶�������"},
								{"des2","�����ӷ�����ծȨ"},
								{"des3","�Ƿ���볷�����رա��Ʋ�������������"},
								{"des4","�Ƿ�Ӧ���߻��ȡ���ɴ�ʩ"},
								{"des5","���޷��ɷ����ֹ���Ŵ������"},
								{"ChangeFlag1","��������Ƿ���"},
								{"ChangeFlag2","������ʽ�Ƿ����"},
								{"ChangeFlag3","�����Ƿ���"},
								{"ChangeFlag4","�����Ƿ����"},
								{"ChangeFlag5","�Ƿ����ṩ��������"},
								{"NewBusinessSum","�������Ž��"},
								{"ChangeFlag6","����Ѻ���Ƿ���ֵ"},
								{"OperateUserName","������"},
								{"OperateOrgName","�������"}
							}; 
							
	//��������Ϣ��BUSINESS_APPLY��ѡ�����鷽���б�(�������Ϊ��ǰ�û���Ͻ������ҵ��Ʒ��Ϊ6010)
	sSql =  " select SerialNo,'' as type1,ApplyType,"+
			" getItemName('ReformType',ApplyType) as ApplyTypeName," +	
			" getItemName('ReformType1',ReformType) as ReformTypeName,"+
			" getItemName('YesNo',FirstReformFlag) as FirstReformFlag,"+
			" DRTimes,'' as FirstBusinessSum, " +	
			" '' as des1,'' as des2,'' as des3,'' as des4,'' as des5,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag1,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag2,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag3,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag4,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag5,"+
			" NewBusinessSum,getItemName('YesNo',ChangeFlag1) as ChangeFlag6,"+
			" getUserName(OperateUserID) as OperateUserName,getOrgName(OperateOrgID) as OperateOrgName " +	
			" from REFORM_INFO  " +
			" where  OperateOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
			
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "REFORM_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("ApplyType,SerialNo",false);	

	doTemp.setCheckFormat("FirstBusinessSum,NewBusinessSum","2");
	
	//���ö��뷽ʽ	
	doTemp.setAlign("FirstBusinessSum,NewBusinessSum","3");
	
	//�����ֶ���ʾ���
	doTemp.setHTMLStyle("ApplyTypeName,ProjectName,BusinessSum,PaymentDate"," style={width:100px} ");
	doTemp.setHTMLStyle("OperateTypeName,"," style={width:180px} ");
	doTemp.setUpdateable("ApplyTypeName",false); 
	doTemp.setType("TotalSum","number");
	
	//���ɲ�ѯ��
	doTemp.setDDDWCode("ApplyType","ReformType");
	//doTemp.setDDDWCode("OperateType","ReformShape");
	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","OperateUserName","");
	doTemp.setFilter(Sqlca,"2","OperateOrgName","");
	doTemp.setFilter(Sqlca,"3","ApplyType","Operators=EqualsString;");
	//doTemp.setFilter(Sqlca,"4","OperateType","Operators=EqualsString;");
	
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
	
		//���Ϊ�����鲻���ʲ������б���ʾ���°�ť
		
		String sButtons[][] = {
					{"true","","Button","������ԭ����","�鿴�����鲻���ʲ�","viewAndEdit()",sResourcesPath},
					{"true","","Button","���鷽������","�鿴���鷽������","viewReform()",sResourcesPath},
					{"true","","Button","������´���","�鿴���������Ϣ","ReformCredit()",sResourcesPath},
					{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath}						
				};		
%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
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
	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}		
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
