<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:hysun 2006.10.23
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
		                        {"CurrencyName","����"},
			            {"EfficientDate","��Ч����"},  
			            {"RateName","��������"},
			            {"RateIDTypeName","������������"},
			            {"RateApplyType","��������"},
			            {"RangeFrom","��ʼ������(����)"},
			            {"RangeTo","��ֹ������(��)"},
			            {"ExchangeValue","����"},
			            {"Rate","������"}					        
				  };   		   		
	
	sSql = " select AreaNo,Currency,getItemName('Currency',Currency) as CurrencyName,RateName,RateType,getItemName('SystemRateType',RateType) as RateApplyType, "+
           " RateIDType,getItemName('RateType',RateIDType) as RateIDTypeName,RangeFrom,RangeTo,Rate,EfficientDate" +
           " from RATE_INFO where 1=1 "+
           " order by Currency,RateType,RangeFrom ";
             
  	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "RATE_INFO";
	doTemp.setKey("AreaNo",true);
	doTemp.setVisible("AreaNo,Currency,RateIDType,RateType",false);
	//���ֶ��Ƿ�ɸ��£���Ҫ���ⲿ���������ģ�����UserName\OrgName	    
	doTemp.setUpdateable("CurrencyName",false);
	doTemp.setHTMLStyle("RateName"," style={width:200px}");
	doTemp.setHTMLStyle("RateIDTypeName"," style={width:60px}");
	doTemp.setHTMLStyle("Rate"," style={width:60px}");
	doTemp.setType("Rate","number");
	doTemp.setCheckFormat("Rate","6");
	//���ɲ�ѯ����
	//���ӹ�����
	doTemp.setColumnAttribute("CurrencyName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.setType("Price","Number"); 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//boolean sFlag1 = CurUser.hasRole("097");
	//out.println("sFlag1 = " + sFlag1);
	
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
		//update "ɾ��"��ŦΪ���ɼ� by yfliu 2007.8.28
		String sButtons[][] = {
		    {"true","","Button","����","����","newRecord()",sResourcesPath},
			{"true","","Button","�޸�/����","�޸�/����","viewAndEdit()",sResourcesPath},
			{"false","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
			{"false","","Button","�����޸Ĳ�ѯ","�����޸Ĳ�ѯ","rateRecord()",sResourcesPath}
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
	function newRecord()
	{
		OpenPage("/SystemManage/SynthesisManage/RateChangeInfo.jsp", "_self","");
	}
	
	function viewAndEdit()
	{
		sAreaNo      = getItemValue(0,getRow(),"AreaNo");
		
		if (typeof(sAreaNo)=="undefined" || sAreaNo.length==0)		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{      
			
			OpenPage("/SystemManage/SynthesisManage/RateChangeInfo.jsp?Type=Read&AreaNo="+sAreaNo, "_self","");
		
		}
	}
	
	function deleteRecord()
	{
		sCurrency   = getItemValue(0,getRow(),"Currency");
		if (typeof(sCurrency)=="undefined" || sCurrency.length==0)		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	function rateRecord()
	{
		popComp("RateChangeRecord","/SystemManage/SynthesisManage/RateChangeRecord.jsp","","","");
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
