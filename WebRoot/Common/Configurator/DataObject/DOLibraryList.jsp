<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   --cwzhan 2004-12-15
			Tester:
			Content: ������б�
			Input Param:
	                    DoNo��    --��ʾģ����
	                    sEditRight:--�༭Ȩ��
			Output param:
			                
			History Log: 
	            
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
	String sSql = "";

	//���ҳ�����	��������š��༭Ȩ��
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DoNo"));
	String sEditRight =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	//����������
    if(sDoNo == null) sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
    if (sDoNo == null) sDoNo = "";
    if (sEditRight == null) sEditRight = "";
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
	{"ColHeader","��������"},			
	{"ColType","ֵ����"},			
	{"ColAttribute","����"},
	{"ColTableName","���ݱ���"},
	{"ColActualName","���ݿ�Դ��"},
	{"ColName","ʹ����"},	
	{"ColDefaultValue","ȱʡֵ"},			
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
		};

	sSql =  " select DoNo,ColIndex,ColHeader,getItemName('DataType',ColType) as ColType,ColAttribute, "+
	" ColTableName,ColActualName,ColName,ColDefaultValue,ColUnit,ColColumnType, "+
	" ColCheckFormat,ColAlign,ColEditStyle,ColEditSourceType,ColEditSource,ColHtmlStyle, "+
	" ColLimit,ColKey,ColUpdateable,ColVisible,ColReadOnly,ColRequired,ColSortable, "+
	" ColCheckItem,ColTransferBack,IsForeignKey,SortNo,getItemName('IsInUse',IsInUse) as IsInUse, "+
	" DataPrecision,DataScale,Attribute1,Attribute2,Attribute3 "+
	" from DATAOBJECT_LIBRARY ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "DATAOBJECT_LIBRARY";
	doTemp.setKey("DoNo,ColIndex",true);
	doTemp.setHeader(sHeaders);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.setAlign("ColType,IsInUse","2");
	//���ò��ɼ���
	doTemp.setVisible("ColColumnType,ColCheckFormat,ColAlign,ColEditStyle,ColEditSourceType,ColLimit,ColKey,ColUpdateable,ColVisible,ColReadOnly,ColRequired,ColSortable,ColCheckItem,ColTransferBack,IsForeignKey,SortNo,Attribute1,Attribute2,Attribute3",false);    	
   	//��ѯ
 	doTemp.setColumnAttribute("DoNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!sDoNo.equals("")) 
	{
		doTemp.WhereClause += " where DoNo = '"+sDoNo+"' ";
	}
	
	//�����п��
	doTemp.setHTMLStyle("ColIndex"," style={width:60px} ");
	doTemp.setHTMLStyle("ColAttribute"," style={width:400px} ");
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(22);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo);
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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
			};
	   //add by fbkang 2005.7.28
	   //��Ʒ�������ӹ����ľ�������Щ����
	   if (sEditRight.equals("01"))
	    {
	      sButtons[0][0]="False";
	      sButtons[1][0]="false";
	      sButtons[2][0]="false";
	    }
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

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("DOLibraryInfo","/Common/Configurator/DataObject/DOLibraryInfo.jsp","DoNo=<%=sDoNo%>","");
        reloadSelf();
        //�������ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
         {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/DataObject/DOLibraryList.jsp?DoNo="+sReturnValues[0],"_self","");    
            }
         }
        
	}
	
     /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sDoNo = getItemValue(0,getRow(),"DoNo");
        sColIndex = getItemValue(0,getRow(),"ColIndex");
        if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        
        sReturn=popComp("DOLibraryInfo","/Common/Configurator/DataObject/DOLibraryInfo.jsp","DoNo="+sDoNo+"~ColIndex="+sColIndex,"");
        reloadSelf();
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/DataObject/DOLibraryList.jsp?DoNo="+sReturnValues[0],"_self","");    
            }
        }
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sDoNo = getItemValue(0,getRow(),"DoNo");
        if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>

	
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
