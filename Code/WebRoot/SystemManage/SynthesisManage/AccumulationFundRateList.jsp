<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:xhyong 2011/08/12
		Tester:
		Describe: �������׼���ʹ���
		Input Param:
	              --sComponentName:�������
		Output Param:
		
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������׼���ʹ�����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//--���sql���
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = { 
		                    {"Currency","����"},
							{"EfficientDate","��Ч����"},
		                    {"RateID","���ʴ���"},
		                    {"RateName","��������"},
                            {"Rate","����(%)"}     		        
						  };   		   		
	
	sSql = " select getItemName('Currency',Currency) as Currency,EfficientDate,RateID,RateName,Rate "+
	              " from AFRATE_INFO where 1=1 ";
             
  	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "AFRATE_INFO";
	doTemp.setKey("Currency",true);		
	//���ñ�������������
	//doTemp.setDDDWCode("Currency","Currency");
	//������ʾ����Ϊ������
	doTemp.setType("Rate","Number");//by jgao1 2008-10-20
	//���ɲ�ѯ����
	//���ӹ�����
	doTemp.setColumnAttribute("Currency","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
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
			{"true","","Button","����","�鿴��׼�������","viewAndEdit()",sResourcesPath},
			{"true","","Button","��ʷ��¼��ѯ","�鿴��׼�������","viewHistory()",sResourcesPath}
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
	    sRateID   = getItemValue(0,getRow(),"RateID");//--��ˮ��
		if (typeof(sRateID)=="undefined" || sRateID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/SystemManage/SynthesisManage/AccumulationFundRateInfo.jsp?RateID="+sRateID, "_self","");
		}
	}
	/*OpenPage("/SystemManage/SynthesisManage/AccumulationFundRateHistoryList.jsp?RateID="+sRateID, "_self",""); */
	function viewHistory()
	{
		sRateID   = getItemValue(0,getRow(),"RateID");//--��ˮ��
		if (typeof(sRateID)=="undefined" || sRateID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			popComp("AccumulationFundRateHistoryList","/SystemManage/SynthesisManage/AccumulationFundRateHistoryList.jsp","RateID="+sRateID,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}
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
