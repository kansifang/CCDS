<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   	��ҵ� 2005-08-18
		Tester:
		Content:  	���պ��б�
		Input Param:												
				ObjectType	��������
				ObjectNo	������        
		Output param:
		                	
		History Log: 
		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���պ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%		
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));	
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = {
								{"SerialNo","���պ���ˮ��"},
								{"OverdueDate","����ʱ��"},
								{"DunLetterNo","���պ����"},
								{"DunDate","��������"},
								{"DunObjectTypeName","���ն�������"},
								{"DunObjectName","���ն�������"},
								{"DunCurrency","���ձ���"},
								{"DunSum","���ս��"},	
								{"Corpus","����"},	
								{"InterestInSheet","����ǷϢ"},	
								{"InterestOutSheet","����ǷϢ"},
								{"DunForm","������ʽ"},
								{"ServiceMode","�ʹ﷽ʽ"},
								{"FeedbackValitityName","������ʽ"},
								{"OperateUserName","������"},
								{"OperateOrgName","�������"},
								{"Signature","ծ����ǩ��"}
						   };  
	
	String sSql =  " select SerialNo,"+
					" OverdueDate,DunLetterNo,"+
					" DunDate,"+
					" getItemName('DunObjectType',DunObjectType) as DunObjectTypeName,"+
					" DunObjectName,"+
					" getItemName('Currency',DunCurrency) as DunCurrency, " +	
					" DunSum,"+			
					" Corpus,"+			
					" InterestInSheet,"+			
					" InterestOutSheet,"+
					" getItemName('DunForm',DunForm) as DunForm, " +	
					" getItemName('DunMode',ServiceMode) as ServiceMode, " +	
					" getItemName('DunAcknowledge',FeedbackValitity) as FeedbackValitityName, " +	
					" getUserName(OperateUserID) as OperateUserName,getOrgName(OperateOrgID) as OperateOrgName,"+
					" '' as Signature "+			
					" from DUN_INFO" +
					" where ObjectType='"+sObjectType+"' "+
					" and ObjectNo='"+sObjectNo+"' "+
					" order by DunDate desc ";		       			       

    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "DUN_INFO";
	doTemp.setKey("SerialNo",true);	 
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,DunForm",false);	    
	//������ʾ�ı���ĳ���
	doTemp.setHTMLStyle("DunObjectName"," style={width:200px} ");
	doTemp.setHTMLStyle("DunLetterNo,DunDate,DunForm,ServiceMode,DunDate,DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee"," style={width:80px} ");
	//����С����ʾ״̬,
	doTemp.setAlign("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","3");
	doTemp.setType("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","Number");
	doTemp.setAlign("ServiceMode,DunCurrency","2");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","2");
	
	//ָ��˫���¼�
	//���ɲ�ѯ��
	//doTemp.setColumnAttribute("DunObjectName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(16);  //��������ҳ
	
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
			{"true","","Button","����","�������պ�","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ǰ���պ�","deleteRecord()",sResourcesPath},
			{"false","","Button","��ӡ","��ӡ","my_Print()",sResourcesPath},
			{"true","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath}
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
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/DunManage/DunInfo.jsp?SerialNo="+sSerialNo,"_self","");
		}
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

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/	
	function newRecord()
	{
		OpenPage("/RecoveryManage/DunManage/DunInfo.jsp","_self","");
	}	
	
	/*~[Describe=����Excel;InputParam=��;OutPutParam=��;]~*/
	function export_Excel()
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