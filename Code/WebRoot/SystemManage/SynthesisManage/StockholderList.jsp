<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: �ɶ�����
		Input Param:
	              --sComponentName:�������
	              --SectionType������ͻ����͡�40-Blacklis��������    50-Stockholder���ɶ�
		Output Param:
		
		HistoryLog:
		--fbkang on 2005/08/14 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ɶ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//--���sql���
	String sComponentName;//--�������
	String PG_CONTENT_TITLE;
	//���ҳ�����	
	
	//����������	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = { 			                   
			                    {"CustomerName","�ɶ�����"},	
			                    {"Attribute3","ӵ�б��йɷ�ռ��(%)"},					      
						        {"Sum2","ӵ�б��йɷ���"},
							    {"Sum1","ʵ���ʱ�(Ԫ)"},			
						        {"UserName","�Ǽ���"},
						        {"OrgName","�Ǽǻ���"},
						        {"InputDate","��������"}
			               };   				   		
		   		
	
	sSql = " select SerialNo,CustomerName,Attribute3,Sum2,Sum1,InputOrgID,getOrgName(InputOrgID) as "+
		   " OrgName,InputUserID,getUserName(InputUserID) as UserName,InputDate from CUSTOMER_SPECIAL "+	            
		   " where SectionType='50' order by  InputOrgID ";
	              
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "CUSTOMER_SPECIAL";
	//��������
	doTemp.setKey("SerialNo",true);
	//�����ֶεĲ��ɼ�
	doTemp.setVisible("SerialNo,InputOrgID,InputUserID",false);
	//����number��
	doTemp.setCheckFormat("Sum1","2");
	doTemp.setCheckFormat("Sum2","5");
	doTemp.setAlign("Sum1,Sum2","3");
	doTemp.setType("Attribute3","Number");
	//���ֶ��Ƿ�ɸ��£���Ҫ���ⲿ���������ģ�����UserName\OrgName	    
	doTemp.setUpdateable("UserName,OrgName,Resouce",false);
	//����html��ʽ
	doTemp.setHTMLStyle("CustomerName"," style={width:250px} ondblclick=\"javascript:parent.viewAndEdit()\"");
	doTemp.setHTMLStyle("UserName,OrgName,UpdateDate"," style={width:100px} ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","OrgName","");
	
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setEvent("BeforeDelete","!CustomerManage.InsertHistoryInfoLog(#SerialNo,"+CurUser.UserID+",ChangeStockholderList)");
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
		   {((CurUser.hasRole("097"))?"false":"true"),"","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		   {"true","","Button","�鿴����","�鿴����������","viewAndEdit()",sResourcesPath},
		   {"true","","Button","��ʷ��¼��ѯ","�鿴�ɶ���Ϣ�������","viewHistory()",sResourcesPath}
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
	    OpenPage("/SystemManage/SynthesisManage/StockholderInfo.jsp","_self","");
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
			OpenPage("/SystemManage/SynthesisManage/StockholderInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}	
	/*OpenPage("/SystemManage/SynthesisManage/StockholderHistoryList.jsp?SerialNo="+sSerialNo, "_self","");*/
	function viewHistory()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--��ˮ��
		popComp("StockholderHistoryList","/SystemManage/SynthesisManage/StockholderHistoryList.jsp","SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
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
