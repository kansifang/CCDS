<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: ����ģ���б�
		Input Param:
             sFlowNo�����̱��     
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
    //���ҳ�����	
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
    if (sFlowNo == null) sFlowNo = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"FlowNo","���̱��"},
			{"PhaseNo","�׶κ�"},
			{"PhaseType","�׶�����"},
			{"PhaseName","�׶�����"},
			{"PhaseDescribe","�׶�����"},
			{"PhaseAttribute","�׶�����"},
			{"PreScript","ǰ��ִ��Script1"},
			{"InitScript","��سа���Script"},
			{"ChoiceDescribe","�������"},
			{"ChoiceScript","�������Script"},
			{"ActionDescribe","��������"},
			{"ActionScript","��������Script"},
			{"PostScript","�����׶�Scripit"},
			{"Attribute1","��ǰ�������ܰ�ť"},
			{"Attribute2","����ɹ������ܰ�ť"},
			{"Attribute3","����鿴Ȩ�޷�ʽ"},
			{"Attribute4","���Ȩ�޽׶�"},
			{"Attribute5","�鿴��Ȩ��ɫ"},
			{"Attribute6","���鿴�Լ�ǩ���������Ӧ�Ľ׶�"},
			{"Attribute7","��ͼ"},
			{"Attribute8","ǩ��������ID"},
			{"Attribute9","����9"},
			{"Attribute10","����10"},
			{"AAEnabled","�Ƿ�������Ȩ"},
			{"AApointInitScript","������Ȩ��ʼ��"},
			{"AApointComp","������Ȩ���ID"},
			{"AApointCompUrl","������Ȩ���URL"}
			
		};

	sSql = "Select "+
			"F.FlowNo,"+
			"F.PhaseNo,"+
			"F.PhaseType,"+
			"C.ItemName as PhaseName,"+
			"F.PhaseDescribe,"+
			"F.PhaseAttribute,"+
			"F.PreScript,"+
			"F.InitScript,"+
			"F.ChoiceDescribe,"+
			"F.ChoiceScript,"+
			"F.ActionDescribe,"+
			"F.ActionScript,"+
			"F.PostScript,"+
			"F.Attribute1,"+
			"F.Attribute2,"+
			"getItemName('OpinionViwRightType',F.Attribute3) as Attribute3,"+
			"F.Attribute4,"+
			"F.Attribute5,"+
			"F.Attribute6, "+
			"F.Attribute7, "+
			"F.Attribute8, "+
			"F.Attribute9, "+
			"F.Attribute10, "+
			"getItemName('YesNo',F.AAEnabled) as AAEnabled, "+
			"F.AApointInitScript, "+
			"F.AApointComp, "+
			"F.AApointCompUrl "+
			" From FLOW_MODEL F,CODE_LIBRARY C"+
			" where F.PhaseType=C.ItemNo and C.isInUse='1'"+
			" and  C.CodeNo in ("+
								"select trim(ItemDescribe) from CODE_LIBRARY where CodeNo='ApplyType' and trim(ItemNo) in ("+
										"select FlowType from FLOW_CATALOG where FlowNo='"+sFlowNo+"'"+
										")"+
								")";	
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_MODEL";
	doTemp.setKey("FlowNo,PhaseNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("PhaseNo"," style={width:60px} ");
	doTemp.setHTMLStyle("PhaseName"," style={width:100px} ");

	//�����������Ͷ���
	//sSql = "select ItemNo,ItemName from CODE_LIBRARY where IsInUse='1' and CodeNo in (select trim(ItemDescribe) from CODE_LIBRARY where CodeNo='ApplyType' and trim(ItemNo) in (select FlowType from FLOW_CATALOG where FlowNo='"+sFlowNo+"')) ";
	//doTemp.setDDDWSql("PhaseType",sSql);

	doTemp.setRequired("PhaseNo",true);   //������
	//���ù��ø�ʽ
	doTemp.setVisible("FlowNo,PhaseDescribe,PhaseAttribute",false);

	//doTemp.setEditStyle("PreScript,InitScript,ChoiceDescribe,ChoiceScript,ActionDescribe,ActionScript,PostScript,Attribute1,Attribute3,Attribute4,Attribute5,Attribute6","3");
	//doTemp.setHTMLStyle("PreScript,InitScript,ChoiceDescribe,ChoiceScript,ActionDescribe,ActionScript,PostScript,Attribute1,Attribute3,Attribute4,Attribute5,Attribute6"," style={width:100px;height:22px;overflow:auto} ");

	//��ѯ
 	doTemp.setColumnAttribute("PhaseNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(sFlowNo!=null && !sFlowNo.equals("")) 
	{
		doTemp.WhereClause+=" and FlowNo='"+sFlowNo+"'";
	}
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
    
	//��������¼�

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo);
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		//{"true","","Button","����","����","save()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
    %> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurFlowNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo=<%=sFlowNo%>","");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/FlowManage/FlowModelList.jsp?FlowNo="+sReturnValues[0],"_self","");           
            }
        }
        
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        sReturn=popComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+sFlowNo+"~PhaseNo="+sPhaseNo,"");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/FlowManage/FlowModelList.jsp?FlowNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	function save(){
		as_save("myiframe0","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FlowNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
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