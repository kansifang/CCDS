<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: ���ʹ���
			Input Param:
		              --sComponentName:�������
			Output Param:
			
		

			HistoryLog:
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "���ʹ�����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql="";//--���sql���
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = { 
		                        {"Currency","����"},
		                        {"CurrencyName","����"},
			            {"EfficientDate","��Ч����"},  
			            {"EfficientTime","��Чʱ��"},  
			            {"Price","�м��"},
			            {"Unit","��λ"}					        
				  };   		   		
	
	sSql = " select Currency,getItemName('Currency',Currency) as CurrencyName,"+
           " Unit,Price,EfficientDate,EfficientTime"+
           " from ERATE_INFO "+
           " where 1=1 "+
           " Order by EfficientDate desc";
             
  	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "ERATE_INFO";
	doTemp.setKey("Currency",true);		
	//���ñ�������������
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setVisible("Currency",false);
	//���ɲ�ѯ��
	doTemp.setCheckFormat("EfficientDate","3");
	//���ӹ�����
	doTemp.setColumnAttribute("Currency,EfficientDate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
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
			{"true","","Button","����","����������Ϣ","newRecord()",sResourcesPath},
			{"true","","Button","����","���ʲ鿴����","editRecord()",sResourcesPath}
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
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/SystemManage/SynthesisManage/ExchangeInfo.jsp","_self","");
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function editRecord()
	{
		var sCurrency = getItemValue(0,getRow(),"Currency");
		var sEfficientDate = getItemValue(0,getRow(),"EfficientDate");
		var sEfficientTime = getItemValue(0,getRow(),"EfficientTime");
		OpenPage("/SystemManage/SynthesisManage/ExchangeInfo.jsp?Currency="+sCurrency+"&EfficientDate="+sEfficientDate+"&EfficientTime="+sEfficientTime,"_self","");
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
