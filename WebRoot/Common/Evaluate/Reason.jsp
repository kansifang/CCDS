<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/* 
		Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
  		This software is the proprietary information of Amarsoft, Inc.  
 		Use is subject to license terms.
 		Author:FXie 2004.02.12
 		Tester:
 			
 		Content: 	���õȼ���������
 		Input Param:
 			ObjectType����������
 		    ObjectNo��������
 			SerialNo����ˮ�� 
 			ModelNo��ģ�ͱ�� 
 			FinishDate������϶�����		
 		Output param:
 					
 		History Log:  zbdeng 2004.02.09  
 	    			  Fxie   2004.02.20  ���������϶�
 	*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���õȼ��˹��϶�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "",sObjectType = "",sObjectNo = "",sModelType = "";
	String sSerialNo = "",sFinishDate = "",sModelNo = "";
	String sRole = "",sResult = "",sLevel = "";
	
	//��ȡ�������	
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	sModelNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
    sFinishDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishDate"));
    //����ֵת��Ϊ���ַ���
    if(sObjectType == null) sObjectType = "";
    if(sObjectNo == null) sObjectNo = "";
    if(sSerialNo == null) sSerialNo = "";    
    if(sModelNo == null) sModelNo = "";
    if(sFinishDate == null) sFinishDate = "";
    
    if(CurUser.hasRole("480"))
    {
        sRole = "3";
    }
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 
							{"AccountMonth","����·�"},
	                        {"ModelName","����ģ��"},
	                        {"EvaluateDate","ϵͳ��������"},
	                        {"EvaluateScore","ϵͳ�����÷�"},
	                        {"EvaluateResult","ϵͳ�������"},
				            {"CognScore","�˹������÷�"},
							{"CognResult","�˹��������"},
							{"FinishDate","�˹������������"},
							{"CognOrgName","������λ"},
							{"CognUserName","������"},
	                        {"Evaluatelevel","��������"},
	                        {"Remark","����˵��"}
			              };   				   		
	
	sSql = " select R.SerialNo,R.AccountMonth,C.ModelName,C.ModelNo,R.EvaluateDate,R.EvaluateScore,R.EvaluateResult,R.CognScore,R.CognResult,R.FinishDate,R.Remark,"+
	       " R.CognOrgID,getOrgName(CognOrgID) as CognOrgName,R.CognUserID,getUserName(CognUserID) as CognUserName,Evaluatelevel"+
	       " from EVALUATE_RECORD R,EVALUATE_CATALOG C" + 
	       " where ObjectType = '"+sObjectType + "' "+
	       " and SerialNo = '"+sSerialNo+"' "+
	       " and ObjectNo = '"+sObjectNo+"' "+
	       " and C.ModelNo = '"+sModelNo+"' "+
	       " order by AccountMonth DESC ";
	//out.print(sSql);
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//�費�ɼ�
	doTemp.setVisible("SerialNo,ModelNo,CognUserID,CognOrgID,Evaluatelevel,FinishDate",false);
	//Ϊ��ɾ��
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setUpdateable("ModelName,CognOrgName,CognUserName",false);
	//���ÿ���
	doTemp.setHTMLStyle("CognOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("ModelName","style={width:300px} ");
	doTemp.setHTMLStyle("AccountMonth,EvaluateDate","  style={width:70px}  ");
	doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
	doTemp.setCheckFormat("EvaluateScore,CognScore","2");
	doTemp.setType("EvaluateScore,CognScore","Number");
	doTemp.setAlign("FinishDate", "2");
	doTemp.setCheckFormat("FinishDate","3");
	
	doTemp.setDDDWSql("CognResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' order by SortNo ");
	doTemp.setReadOnly("AccountMonth,ModelName,EvaluateDate,EvaluateScore,EvaluateResult,CognOrgName,CognUserName",true);
	
	//style={color:#848284;width:70px}
	doTemp.setHTMLStyle("Remark","style={width:300px;height:70px}");
	doTemp.setHTMLStyle("FinishDate","style={width:80px");
	doTemp.setRequired("R.Remark",true);
	doTemp.setLimit("Remark",250);
	doTemp.setEditStyle("Remark","3");
	
	//�����˹������÷ַ�Χ
	doTemp.appendHTMLStyle("CognScore"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�˹������÷ֱ�����ڵ���0��\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);		
	dwTemp.Style="0";      //����Ϊfree���
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));		
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{(sFinishDate.equals("")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{(sFinishDate.equals("")?"true":"false"),"","Button","�ύ","�ύ���õȼ��϶�","Finished()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
		
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;	
		//������������Ϊ��ǰ�û�
		setItemValue(0,0,"CognUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"CognOrgID","<%=CurOrg.OrgID%>");
		
		CheckEvaluate();
		as_save('myiframe0');
	}
	 
	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function Finished()
	{
	   sFinishDate  = getItemValue(0,getRow(),"FinishDate");
	   if(typeof(sFinishDate) != "undefined" && sFinishDate.length != 0)	   
	   {
	        alert(getBusinessMessage('196'));//�ñ����õȼ�������¼���϶���ɣ������ٽ����϶���
	        return;
	   }
	   if(confirm(getHtmlMessage('40')))//�ύ�󽫲��ܽ����޸Ĳ�����ȷ���ύ��
		 {
    	   setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
    	   saveRecord(); 
	   }
	}
	
	/*~[Describe=�ر�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{		
		self.close();
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{				
		return true;
	}
		
</script>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	/*~[Describe=���ݷ�ֵ�����������;InputParam=��;OutPutParam=��;]~*/
	function setResult(){		
		//������ֵ�������
		//��Ҫ���ݾ���������е���
		var CognScore = getItemValue(0,getRow(),"CognScore");
		if(CognScore<0 || CognScore>100){
			alert("����������0��100֮�䣡");
			setItemValue(0,getRow(),"CognScore","");
			setItemValue(0,getRow(),"CognResult","");
			setItemFocus(0,getRow(),"CognScore");
			return;
		}
		if (CognScore<45)
			result = "D";		
		else if (CognScore<58)
			result = "C";
		else if (CognScore<64)
			result = "CC";
		else if (CognScore<70)
			result = "CCC";
		else if (CognScore<75)
			result = "B";
		else if (CognScore<80)
			result = "BB";
		else if (CognScore<85)
			result = "BBB";
		else if (CognScore<90)
			result = "A";
		else if (CognScore<96)
			result = "AA";
		else
			result = "AAA";			
		setItemValue(0,getRow(),"CognResult",result);
	}
	
	/*~[Describe=�����������;InputParam=��;OutPutParam=��;]~*/
	function CheckEvaluate()
	{
        var sCognResult = getItemValue(0,getRow(),"CognResult");
        var sCognLevel = "<%=sRole%>";
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        var sReturnValue=PopPage("/Common/Evaluate/CheckEvaluateAction.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&CognLevel="+sCognLevel+"&CognResult="+sCognResult+"&AccountMonth="+sAccountMonth,"","resizable=yes;dialogWidth=21;dialogHeight=19;center:yes;status:no;statusbar:no");        
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/	
	function initRow(){
		oldScore = getItemValue(0,getRow(),"CognScore");
	    oldResult = getItemValue(0,getRow(),"CognResult");	    
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
