<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: ������б�
			Input Param:
	                    CodeNo��    �������
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
	String sDiaLogTitle = "";
	String sCodeNo = ""; //�������
	String sCodeName = ""; //���������
	
	//����������	
	sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));   
	if(sCodeNo==null) sCodeNo="";
	sCodeName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeName"));   
	if(sCodeName==null) sCodeName="";
	sDiaLogTitle = "��"+sCodeName+"�����룺��"+sCodeNo+"������";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders={
		{"CodeNo","�����"},
		{"ItemNo","��Ŀ��"},
		{"ItemName","��Ŀ����"},
		{"SortNo","�����"},
		{"IsInUse","��Ч״̬"},
		{"ItemDescribe","��Ŀ����"},
		{"ItemAttribute","��Ŀ����"},
		{"RelativeCode","��������"},
		{"Attribute1","����1"},
		{"Attribute2","����2"},
		{"Attribute3","����3"},
		{"Attribute4","����4"},
		{"Attribute5","����5"},
		{"Attribute6","����6"},
		{"Attribute7","����7"},
		{"Attribute8","����8"},
		{"Remark","��ע"},
		{"HelpText","����"},
		{"InputUserName","�Ǽ���"},
		{"InputUser","�Ǽ���"},
		{"InputOrgName","�Ǽǻ���"},
		{"InputOrg","�Ǽǻ���"},
		{"InputTime","�Ǽ�ʱ��"},
		{"UpdateUserName","������"},
		{"UpdateUser","������"},
		{"UpdateTime","����ʱ��"},
		};

	sSql = "select "+
	"CodeNo,"+
	"ItemNo,"+
	"ItemName,"+
	"SortNo,"+
	"getItemName('IsInUse',IsInUse) as IsInUse,"+
	"ItemDescribe,"+
	"ItemAttribute,"+
	"RelativeCode,"+
	"Attribute1,"+
	"Attribute2,"+
	"Attribute3,"+
	"Attribute4,"+
	"Attribute5,"+
	"Attribute6,"+
	"Attribute7,"+
	"Attribute8,"+
	"Remark,"+
	"HelpText,"+
	"getUserName(InputUser) as InputUserName,"+
	"InputUser,"+
	"getOrgName(InputOrg) as InputOrgName,"+
	"InputOrg,"+
	"InputTime,"+
	"getUserName(UpdateUser) as UpdateUserName,"+
	"UpdateUser,"+
	"UpdateTime "+
	"from CODE_LIBRARY Where 1 = 1 ";

	ASDataObject doTemp = new ASDataObject(sSql);

	doTemp.UpdateTable="CODE_LIBRARY";
	doTemp.setKey("CodeNo,ItemNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("ItemNo"," style={width:100px} ");
	doTemp.setHTMLStyle("SortNo"," style={width:56px} ");
	doTemp.setHTMLStyle("IsInUse"," style={width:56px} ");
	
	//��ѯ
	doTemp.setColumnAttribute("CodeNo,ItemName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(sCodeNo!=null && !sCodeNo.equals("")) 
	{
		doTemp.WhereClause+=" And CodeNo='"+sCodeNo+"'";
	}
	/*
	else
	{
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause  += " And 1=2";
	}
	*/
	//by zhou 2005-08-31
	doTemp.OrderClause += " Order by  CodeNo,SortNo ";
	
	doTemp.setHTMLStyle("InputUserName,UpdateUserName,InputOrgName"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:90px} ");
	//���ж�Ϊ����ʾ
	doTemp.setVisible("Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8,InputUserName,InputOrgName,UpdateUserName,InputUser,InputOrg,UpdateUser,InputTime,UpdateTime",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
	//ֻ����
	doTemp.setReadOnly("CodeNo,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	
	doTemp.setEditStyle("Remark,HelpText,ItemDescribe,ItemAttribute,RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8","3");
	doTemp.setHTMLStyle("Remark,HelpText,ItemDescribe,ItemAttribute,RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8"," style={width:200px;height:22px;overflow:auto} onDBLClick=\"parent.editObjectValueWithScriptEditorForASScript(this)\"");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateCodeCatalogUpdateTime("+StringFunction.getTodayNow()+","+CurUser.UserID+",#CodeNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql);
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
	        sReturn=popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","");
	        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	        {
	            //�������ݺ�ˢ���б�
	            sReturnValues = sReturn.split("@");
	            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
	            {
	                reloadSelf();
	            }
	        }
	        
	}
	
     /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
	        sCodeNo = getItemValue(0,getRow(),"CodeNo");
	        sItemNo = getItemValue(0,getRow(),"ItemNo");
	        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
			}
        
        sReturn=popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeName=<%=sCodeName%>&CodeNo="+sCodeNo+"&ItemNo="+sItemNo+"&rand="+amarRand(),"");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCodeNo = getItemValue(0,getRow(),"CodeNo");
        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
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
	ssCodeNo = "<%=sCodeNo%>"
        if(typeof(ssCodeNo)=="undefined" || ssCodeNo.length==0)	
        {
        //��sCodeNo ��ʱ��ҳ��δ����ģ̬���� Remark by wuxiong 2005-02-23
        }
        else
        {
         	setDialogTitle("<%=sDiaLogTitle%>");
        }
//add by byhu Ĭ����ʾfilter������ѯ����ʾ
<%if(!doTemp.haveReceivedFilterCriteria()) {%>
	showFilterArea();
<%}%>
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
