<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: �������Ϣ����
			Input Param:
	                    CodeNo��    �������
	                    ItemNo��    ��Ŀ��ţ������ǲ����룩
			Output param:         
			History Log: zywei 2005/07/28 ���һ�������ֶ�ColIndex
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
	String sColIndex =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ColIndex"));

	if(sDoNo==null) sDoNo="";
	if(sColIndex==null) sColIndex="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders={
	{"DoNo","DO���"},
	{"ColIndex","�к�"},
	{"ColAttribute","����"},
	{"ColTableName","���ݱ���"},
	{"ColActualName","���ݿ�Դ��"},
	{"ColName","ʹ����"},
	{"ColType","ֵ����"},
	{"ColDefaultValue","ȱʡֵ"},
	{"ColHeader","��������"},
	{"ColUnit","��ʾ��׺"},
	{"ColColumnType","�Ƿ�Sum"},
	{"ColCheckFormat","����ʽ"},
	{"ColAlign","����"},
	{"ColEditStyle","�༭��ʽ"},
	{"ColEditSourceType","��������Դ"},
	{"ColEditSource","��Դ����"},
	{"ColHtmlStyle","HTML��ʽ"},
	{"ColLimit","����"},
	{"ColKey","�ؼ���"},
	{"ColUpdateable","�ɸ���"},
	{"ColVisible","�ɼ�"},
	{"ColReadOnly","ֻ��"},
	{"ColRequired","����"},
	{"ColSortable","����"},
	{"ColCheckItem","���"},
	{"ColTransferBack","�ش�"},
	{"IsForeignKey","�Ƿ����"},
	{"SortNo","�ֶ���"},
	{"IsInUse","�Ƿ���Ч"},
	{"DataPrecision","��Чλ"},
	{"DataScale","С��λ"},
	{"Attribute1","������1"},
	{"Attribute2","������2"},
	{"Attribute3","������3"},
	{"IsFilter","�Ƿ���ɼ�������"}
		};

	sSql =  " select DoNo,ColIndex,ColAttribute,ColTableName,ColActualName,ColName,ColType, "+
	" ColDefaultValue,ColHeader,ColUnit,ColColumnType,ColCheckFormat,ColAlign,ColEditStyle, "+
	" ColEditSourceType,ColEditSource,ColHtmlStyle,ColLimit,ColKey,ColUpdateable,ColVisible, "+
	" ColReadOnly,ColRequired,ColSortable,ColCheckItem,ColTransferBack,IsForeignKey,SortNo, "+
	" IsInUse,DataPrecision,DataScale,Attribute1,Attribute2,Attribute3,IsFilter "+
	" from DATAOBJECT_LIBRARY "+
	" where DoNo = '"+sDoNo+"' "+
	" and ColIndex = '"+sColIndex+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="DataObject_Library";
	doTemp.setKey("DoNo,ColIndex",true);
	doTemp.setHeader(sHeaders);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
 	doTemp.setRequired("DoNo,ColIndex",true); 	
	if (!sDoNo.equals("")) 
	{
 	  	doTemp.setRequired("DoNo",false);
		doTemp.setReadOnly("DoNo",true);
	}

	doTemp.setDDDWCode("ColType","DataType");	
	doTemp.setDDDWCode("ColColumnType","ColumnType");
	doTemp.setDDDWCode("ColCheckFormat","CheckFormat");
	doTemp.setDDDWCode("ColAlign","ColAlign");
	doTemp.setDDDWCode("ColEditStyle","ColEditStyle");
	doTemp.setDDDWCode("ColEditSourceType","ColEditSourceType");
	doTemp.setDDDWCode("ColKey","TrueFalse");
	doTemp.setDDDWCode("ColUpdateable","TrueFalse");
	doTemp.setDDDWCode("ColVisible","TrueFalse");
	doTemp.setDDDWCode("ColReadOnly","TrueFalse");
	doTemp.setDDDWCode("ColRequired","TrueFalse");
	doTemp.setDDDWCode("ColSortable","TrueFalse");
	doTemp.setDDDWCode("ColCheckItem","TrueFalse");
	doTemp.setDDDWCode("ColTransferBack","TrueFalse");
	doTemp.setDDDWCode("IsForeignKey","TrueFalse");
	doTemp.setDDDWCode("IsFilter","TrueFalse");
	doTemp.setDDDWCode("IsInUse","IsInUse");
	//�����п��
	doTemp.setHTMLStyle("ColAttribute"," style={width:400px} ");	
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateDOUpdateTime("+StringFunction.getTodayNow()+","+CurUser.UserID+","+sDoNo+")");
	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo+","+sColIndex);
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
			{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
			{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
			// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
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
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
	    as_save("myiframe0");        
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
	    as_save("myiframe0","doReturn('Y');");
        
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"DoNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
           setItemValue(0,0,"DoNo","<%=sDoNo%>");            
            setItemValue(0,0,"ColKey","0");
            setItemValue(0,0,"ColVisible","1");
            setItemValue(0,0,"ColReadOnly","0");
            setItemValue(0,0,"ColRequired","0");
            setItemValue(0,0,"ColSortable","1");
            setItemValue(0,0,"ColCheckItem","0");
            setItemValue(0,0,"ColTransferBack","0");
            setItemValue(0,0,"IsForeignKey","0");
            setItemValue(0,0,"IsInUse","1");
            setItemValue(0,0,"ColColumnType","1");
            setItemValue(0,0,"ColCheckFormat","1");
            setItemValue(0,0,"ColAlign","1");
            setItemValue(0,0,"ColEditStyle","1");            
            setItemValue(0,0,"ColType","String");
            setItemValue(0,0,"ColUpdateable","1");
            setItemValue(0,0,"ColLimit","0");
            setItemValue(0,0,"IsFilter","0");
            bIsInsert = true;
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
