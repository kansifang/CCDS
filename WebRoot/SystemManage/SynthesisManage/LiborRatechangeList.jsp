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
		                        {"Currency","����"},
			            {"InputDate","��Ч����"},  
			            {"RateType","��������"},
			            {"RateTypeName","��������"},
			            {"Rate","��׼����"}					        
				  };   		   		
	
	sSql = " select InputDate,Currency,getItemName('Currency',Currency) as CurrencyName,RateType,getItemName('GJRateType',RateType) as RateTypeName,Rate "+
           " from LIBOR_INFO where 1=1 "+
           " order by Currency,RateType asc ";
             
  	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "LIBOR_INFO";
	doTemp.setVisible("Currency,RateType",false);
	//���ֶ��Ƿ�ɸ��£���Ҫ���ⲿ���������ģ�����UserName\OrgName	    
	doTemp.setType("Rate","number");
	doTemp.setCheckFormat("Rate","6");
	doTemp.setCheckFormat("InputDate","3");
	doTemp.setDDDWCode("Currency","Currency");
	//���ɲ�ѯ����
	//���ӹ�����
	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","Currency","");
	doTemp.setFilter(Sqlca,"2","InputDate","");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(30);
	
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
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
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
		OpenPage("/SystemManage/SynthesisManage/LiborRateChangeInfo.jsp", "_self","");
	}
	
	function viewAndEdit()
	{
		sCurrency   = getItemValue(0,getRow(),"Currency");
		sInputDate   = getItemValue(0,getRow(),"InputDate");
		sRateType   = getItemValue(0,getRow(),"RateType");
		
		if (typeof(sCurrency)=="undefined" || sCurrency.length==0)		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{      
			
			OpenPage("/SystemManage/SynthesisManage/LiborRateChangeInfo.jsp?Type=Read&Currency="+sCurrency+"&InputDate="+sInputDate+"&RateType="+sRateType, "_self","");
		
		}
	}
	
	function deleteRecord()
	{
		sCurrency   = getItemValue(0,getRow(),"Currency");
		sInputDate  = getItemValue(0,getRow(),"InputDate");
		sRateType   = getItemValue(0,getRow(),"RateType");
		if ((typeof(sCurrency)=="undefined" || sCurrency.length==0)||(typeof(sInputDate)=="undefined" || sInputDate.length==0)
			||(typeof(sRateType)=="undefined" || sRateType.length==0))		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			sReturn = RunMethod("BusinessManage","DeleteLibor",sCurrency+","+sInputDate+","+sRateType);
			if(sReturn == "1.0"){
				alert("ɾ���ɹ���");
				reloadSelf();
			}else{
				alert("ɾ��ʧ�ܣ�");
				return;
			}
		}
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
