<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu
		Tester:
		Content: --�����ύ���շ���
		Input Param:
                  
		Output param:
		       DoNo:--ģ�����
		       EditRight: --�༭Ȩ��
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ύ���շ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//--���sql���
	String sSortNo=""; //--������
	//���ҳ�����	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders = {
								{"MultiSelectionFlag","˫����ѡ"},
								{"ObjectNo","������ˮ��"},
								{"BCObjectNo","��ͬ��ˮ��"},
								{"CustomerName","�ͻ�����"},
								{"BusinessTypeName","ҵ��Ʒ��"},
								{"BusinessSum","��ͬ���"},
								{"Balance","��ͬ���"},	
								{"Result2Name","�ͻ�������շ�����"},	
				             };
	sSql =  " select '' as MultiSelectionFlag,FT.ObjectNo as ObjectNo,CR.ObjectNo as BCObjectNo,"+
			" BC.CustomerName as CustomerName,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.BusinessSum as BusinessSum,BC.Balance as Balance,"+
			" getItemName('ClassifyResult',CR.ClassifyLevel) as Result2Name, "+
			" FT.ObjectType as ObjectType,FT.FlowNo as FlowNo,FT.PhaseNo as PhaseNo "+
			" from FLOW_TASK FT,CLASSIFY_RECORD CR,BUSINESS_CONTRACT BC "+
			" where BC.SerialNo = CR.ObjectNo and FT.ObjectType =  'ClassifyApply' "+
			" and  FT.ObjectNo = CR.SerialNo and FT.FlowNo='ClassifyFlow'  "+
			" and FT.PhaseNo='0040' and FT.UserID='"+CurUser.UserID+"'"+
			" and CR.ObjectType='BusinessContract' and (FT.EndTime is  null  or  FT.EndTime = '')"+
			" order by FT.SerialNo desc ";
			
	//����ASDataObject����doTemp		
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//�����޸ı���
	doTemp.UpdateTable = "BUSINESS_TYPE";
	//��������
	doTemp.setKey("TypeNo",true);
	//���ò�������
	doTemp.setVisible("PhaseNo,FlowNo,ObjectType",false);
	
	
	doTemp.setAlign("MultiSelectionFlag","2");
	doTemp.setHTMLStyle("MultiSelectionFlag","style={width:60px} ondblclick=\"javascript:parent.onClickStatus()\"");
	
	doTemp.setType("BusinessSum,Balance","Number");
	
	//���˲�ѯ
 	doTemp.setFilter(Sqlca,"1","BCObjectNo","");
 	doTemp.setFilter(Sqlca,"2","BusinessTypeName","");
 	doTemp.setFilter(Sqlca,"3","Result2Name","");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����ҳ����ʾ������
	dwTemp.setPageSize(100);
  	

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
	String sButtons[][] = {
			{"true","","Button","ȫѡ","ȫѡ","selectAll()",sResourcesPath},
			{"true","","Button","ȫ��ѡ","ȫ��ѡ","cancelSelect()",sResourcesPath},
			{"true","","Button","��ѡ","��ѡ","inverseSelect()",sResourcesPath},
			{"true","","Button","�����ύ","�����ύ","batchSubmit()",sResourcesPath}				
		   };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    
	//---------------------���尴ť�¼�------------------------------------
	
	//-----ȫѡ���begin
	aIndex="";

	//˫��ѡ��
	function onClickStatus()
	{
		sMultiSelectionFlag = getItemValue(0,getRow(),"MultiSelectionFlag");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(aIndex.indexOf(sObjectNo+"@")<0)
		{
			setItemValue(0,getRow(),"MultiSelectionFlag","��");
			aIndex=aIndex+sObjectNo+"@";
		}
		else
		{
			setItemValue(0,getRow(),"MultiSelectionFlag","");
			aIndex=aIndex.replace(sObjectNo+"@","");
		}
	}

	//��ѡ
	function inverseSelect()
	{
		var b = getRowCount(0);
		for(var iMSR = 0 ; iMSR < b ; iMSR++)
		{
			sObjectNo = getItemValue(0,iMSR,"ObjectNo");
			if(aIndex.indexOf(sObjectNo+"@")<0){
				setItemValue(0,iMSR,"MultiSelectionFlag","��");
				aIndex=aIndex+sObjectNo+"@";
			}else{
				setItemValue(0,iMSR,"MultiSelectionFlag","");
				aIndex=aIndex.replace(sObjectNo+"@","");
			}
		}
	}

	function selectAll()
	{
		var totalRowcount = getRowCount(0);
		//alert(curpage+"@"+pagesize) ;
	    var iterator=curpage*pagesize;                        //��ҳ��ĵ��Ӳ���
	    var currentRowCount = 0;                                //��ǰҳ����������
	    if(curpage==(pagenum-1)){        //�����ǰҳΪĩҳ���������ҳ����������
	            currentRowCount = parseInt(totalRowcount)-parseInt(iterator);
	    }else{
	            currentRowCount = pagesize;
	    }
	    //--------------���Ӻ��ѭ���ڵ��յ�
	    var iteratorRowCount = parseInt(currentRowCount)+parseInt(iterator);
	    //alert("curpage="+curpage+" |pagenum"+pagenum+" |totalRowcount="+totalRowcount+" |iterator="+iterator+" |currentRowCount="+currentRowCount+" |iteratorRowCount="+(iteratorRowCount));
	    for(var i=iterator; i<iteratorRowCount; i++){
	    	sObjectNo = getItemValue(0,i,"ObjectNo");
            setItemValue(0,i,"MultiSelectionFlag","��");
            aIndex=aIndex+sObjectNo+"@";
	    }
	}
	
	//�ͻ��˷�ҳ
	function cancelSelect()
	{
		var totalRowcount = getRowCount(0);
        var iterator=curpage*pagesize;                        //��ҳ��ĵ��Ӳ���
        var currentRowCount = 0;                                //��ǰҳ����������
        if(curpage==(pagenum-1)){        //�����ǰҳΪĩҳ���������ҳ����������
                currentRowCount = parseInt(totalRowcount)-parseInt(iterator);
        }else{
                currentRowCount = pagesize;
        }
        //--------------���Ӻ��ѭ���ڵ��յ�
        var iteratorRowCount = parseInt(currentRowCount)+parseInt(iterator);
        for(var i=iterator; i<iteratorRowCount; i++){
        	sObjectNo = getItemValue(0,i,"ObjectNo");
            setItemValue(0,i,"MultiSelectionFlag","");
            aIndex=aIndex.replace(sObjectNo+"@","");
        }
	}
	
	function batchSubmit(){
		if(typeof(aIndex)=="undefined" || aIndex.length==0){
			alert("����ѡ��һ����¼�����ύ��");
			return;
		} 
		else{
			var sObjectType = getItemValue(0,getRow(),"ObjectType");
			var sSerialNo = aIndex.split("@")[0];
			var sFlowNo = getItemValue(0,getRow(),"FlowNo");
			var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
			var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
			var sPhaseInfo = PopPage("/Common/WorkFlow/BatchSubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo.length==0){
				return;
			}
			var sPhaseOpinion1 = sPhaseInfo.split("@")[0];
			var sPhaseAction = sPhaseInfo.split("@")[1];
			var sRetuern = RunMethod("WorkFlowEngine","ClassifyBatchSubmit",sPhaseOpinion1+","+sPhaseAction+","+aIndex+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
			alert(sRetuern);
			reloadSelf();
		}
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
