<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:hldu
		Tester:
		Describe: ����������
		Input Param:
	              --sComponentName:�������
		Output Param:
		
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));

	if(sSerialNo == null||"undefined".equals(sSerialNo)) sSerialNo = "";
	//�������
	String sSql="";//--���sql���
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = { 
		                    	{"RelativeName","����������"},	
			                    {"Attribute3","ӵ�б��йɷ�ռ��(%)"},					      
						        {"Sum2","ӵ�б��йɷ���"},
							    {"Sum1","ʵ���ʱ�(Ԫ)"},			
						        {"UpdateOrgName","���»���"},
						        {"UpdateUser","������"},
						        {"UpdateDate","��������"}    		        
						  };   		   		
	
	//sSql = " select RelativeName,Attribute3,Sum2,Sum1,getOrgName(UpdateOrg) as UpdateOrgName,getUserName(UpdateUser) as UpdateUser,UpdateDate "+
	//	   " from RELATIVE_SPECIALLOG  where SerialNo ='"+sSerialNo+"' order by UpdateDate ";
	 if(sSerialNo=="" )
	 {
		sSql = " select RelativeName,Attribute3,Sum2,Sum1,getOrgName(UpdateOrg) as UpdateOrgName,getUserName(UpdateUser) as UpdateUser,UpdateDate "+
		  	   " from RELATIVE_SPECIALLOG order by UpdateDate ";
     }else
     {
		sSql = " select RelativeName,Attribute3,Sum2,Sum1,getOrgName(UpdateOrg) as UpdateOrgName,getUserName(UpdateUser) as UpdateUser,UpdateDate "+
	  		   " from RELATIVE_SPECIALLOG  where SerialNo ='"+sSerialNo+"' order by UpdateDate ";    
     }
  	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "RELATIVE_SPECIALLOG";
	doTemp.setKey("SerialNo",true);		
	//����number��
	doTemp.setCheckFormat("Sum1","2");
	doTemp.setCheckFormat("Sum2","5");
	doTemp.setAlign("Sum1,Sum2","3");
	doTemp.setType("Attribute3","Number");
	//���ɲ�ѯ����
	//���ӹ�����
	doTemp.setColumnAttribute(" ","IsFilter","1");
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
			{"false","","Button","����","�鿴��׼�������","viewAndEdit()",sResourcesPath},
			{"false","","Button","��ʷ��¼��ѯ","�鿴��׼�������","viewHistory()",sResourcesPath},
			{"false","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
			OpenPage("/SystemManage/SynthesisManage/RateInfo.jsp?RateID="+sRateID, "_self","");
		}
	}
	
	function viewHistory()
	{
		sRateID   = getItemValue(0,getRow(),"RateID");//--��ˮ��
		if (typeof(sRateID)=="undefined" || sRateID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/SystemManage/SynthesisManage/RateInfo.jsp?RateID="+sRateID, "_self","");
		}
	}
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/RelativeList.jsp","_self","");
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
