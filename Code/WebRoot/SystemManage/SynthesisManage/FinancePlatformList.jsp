<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:wangdw
		Tester:
		Describe: ����ƽ̨����
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ƽ̨����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//���������SQL���
	String sSql = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = { 			                   
			                    {"CustomerName","�ͻ�����"},						      
						        {"UserName","�Ǽ���"},
						        {"OrgName","�Ǽǻ���"},
						        {"CustomerID","�ͻ����"},
						        {"PlatformType","ƽ̨����"},
						        {"DealClassify","���÷���"},
						        {"UpdateDate","��������"}
			               };   				   		
		   		
	
	sSql = " select SerialNo,CustomerName,nvl(CustomerID,'') as CustomerID,InputOrgID,getItemName('FinancePlatformType',PlatformType) as PlatformType,getItemName('DealClassify',DealClassify) as DealClassify, "+
           " getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName,UpdateDate "+
		   " from CUSTOMER_FINANCEPLATFORM where 1=1 order by InputOrgID ";
	              
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "CUSTOMER_FINANCEPLATFORM";
	//��������
	doTemp.setKey("SerialNo",true);
	//�����ֶεĲ��ɼ�
	doTemp.setVisible("SerialNo,InputOrgID,InputUserID",false);
	//���ֶ��Ƿ�ɸ��£���Ҫ���ⲿ���������ģ�����UserName\OrgName	    
	doTemp.setUpdateable("UserName,OrgName,Resouce",false);
	
	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","PlatformType","");
	doTemp.setFilter(Sqlca,"3","DealClassify","");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setEvent("BeforeDelete","!CustomerManage.InsertHistoryInfoLog(#SerialNo,"+CurUser.UserID+",ChangeFinancePlatFormList)");
	dwTemp.setEvent("AfterDelete","!PublicMethod.UpdateColValue(String@FinancePlatformFlag@None@String@FinancePlatformType@None@String@DealClassify@None,ENT_INFO,String@CUSTOMERID@#CustomerID)");
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
		   {((CurUser.hasRole("097"))?"false":"true"),"","Button","����","����","my_add()",sResourcesPath},
		   {"true","","Button","����","�鿴����ƽ̨����","viewAndEdit()",sResourcesPath},
		   {((CurUser.hasRole("097"))?"false":"true"),"","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		   {"true","","Button","��ʷ��¼��ѯ","�鿴�������������","viewHistory()",sResourcesPath}
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
	function my_add()
	{ 	 
	    OpenPage("/SystemManage/SynthesisManage/FinancePlatformInfo.jsp","_self","");
	}	                                                                                                                                                                                                                                                                                                                                                 

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}	

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/SystemManage/SynthesisManage/FinancePlatformInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}
	
	
	function viewHistory()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--��ˮ��
		popComp("FinancePlatFormHistoryList","/SystemManage/SynthesisManage/FinancePlatFormHistoryList.jsp","SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
