<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    
		Tester:	
		Content: �ͻ��б�
		Input Param:
              ObjectType:  ��������
              ObjectNo  :  ������
              ModelType :  ����ģ������ 010--���õȼ�����   030--���ն�����  080--�����޶� 018--���ô�������  ������'EvaluateModelType'����˵��
              CustomerID��  �ͻ�����        ��        
		Output param:
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005.7.22 fbkang    ҳ������
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
	String sSql = "";//--���sql���
	String sObjectType = "";//--��������
	String sObjectNo = "";//--������
	String sModelType = "";//--ģ������
	String sFag = "";//--��־
	String sCustomerType = "";//--�ͻ�����
	String sModelTypeAttributes="";//--ģ����������
	String sCustomerID = "";//--�ͻ�����
    String sDisplayFinalResult="";//--��ʾ���
    //�������������������͡������š�ģ�����͡��ͻ�����
	sObjectType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	sModelType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelType"));
	sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if (sModelType==null) 
		sModelType = "010"; //ȱʡģ������Ϊ"���õȼ�����"
	ASResultSet rs = null;
%>	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	sSql = "select * from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo='"+sModelType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sModelTypeAttributes = rs.getString("RelativeCode");
	}else{
		throw new Exception("ģ������ ["+sModelType+"] û�ж��塣��鿴CODE_LIBRARY:EvaluateModelType");
	}
	rs.getStatement().close();
	
	sDisplayFinalResult = StringFunction.getProfileString(sModelTypeAttributes,"DisplayFinalResult");
	
	//���ñ���
	String sHeaders[][] =  { {"EvaluateDate","��������"},
	                         {"AccountMonth","����·�"},
				             {"ModelTypeName","����ģ��"},
				             {"ModelName","����ģ��"},
				             {"CognDate","�����϶�����"},
				             {"EvaluateScore","ϵͳ�����÷�"},
				             {"EvaluateResult","ϵͳ�������"},
				             {"OrgName","������λ"},
				             {"UserName","�����ͻ�����"},
				             {"CognScore","�˹��϶��÷�"},
				             {"CognResult","�˹��϶����"},
				             {"CognOrgName","�����϶���λ"},
				             {"CognUserName","�����϶���"}
						   }; 
	String sHeaders1[][] = { {"EvaluateDate","��������"},
	                         {"AccountMonth","����·�"},
				             {"ModelTypeName","����ģ��"},
				             {"ModelName","����ģ��"},
				             {"CognDate","�����϶�����"},
				             {"EvaluateScore","��������޶�ο�ֵ(��Ԫ)"},
				             {"OrgName","������λ"},
				             {"UserName","�����ͻ�����"},
				             {"CognScore","�����϶���������޶�(��Ԫ)"},
				             {"CognResult","�����϶����"},
				             {"CognOrgName","�����϶���λ"},
				             {"CognUserName","�����϶���"}
							}; 
	sSql = " select AccountMonth,C.ModelName,EvaluateScore,EvaluateResult,CognScore,CognResult,"+
	       " ObjectType,ObjectNo,SerialNo,CognDate,R.ModelNo,OrgID,getOrgName(OrgID) as OrgName,"+
	       " UserID,getUserName(UserID) as UserName,CognOrgID,getOrgName(CognOrgID) as CognOrgName,"+
	       " CognUserID,getUserName(CognUserID) as CognUserName,R.FinishDate "+
	       " from EVALUATE_RECORD R,EVALUATE_CATALOG C" + 
	       " where ObjectType = '"+sObjectType+"' "+
	       " and ObjectNo = '"+sObjectNo+"' "+
	       " and R.ModelNo = C.ModelNo ";
	       
	if (sModelType.equals("030"))//  �����ҵ����������������б����
	{		
		String sModelTypeName="���ն�������";
		//���ն�����ֻ���������������ǰ����Ϊ��ͬ��֪ͨ�飬��ʾ����������ķ��ն�����
		if(sObjectType.equals("CreditApply"))//����
		{	sSql = " select ObjectType,ObjectNo,SerialNo,EvaluateDate,R.ModelNo,AccountMonth, "+
				   " '���ն�������' as ModelTypeName,EvaluateScore,OrgID,getOrgName(OrgID) as OrgName, "+
				   " UserID,getUserName(UserID) as UserName,R.FinishDate "+
			       " from EVALUATE_RECORD R " + 
			       " where ObjectType='"+sObjectType + "' and ObjectNo='"+ sObjectNo + "' ";
		 }
		else if(sObjectType.equals("ApproveApply"))//֪ͨ��
		{
			sSql = " select ObjectType,ObjectNo,R.SerialNo,EvaluateDate,R.ModelNo,AccountMonth, "+
				   " '���ն�������' as ModelTypeName,EvaluateScore,OrgID,getOrgName(OrgID) as OrgName, "+
				   " UserID,getUserName(UserID) as UserName,R.FinishDate "+
				   " from EVALUATE_RECORD R, BUSINESS_APPROVE P "+
				   " where ObjectType='BusinessApply' "+
				   " and R.ObjectNo=P.RelativeSerialNo "+ 
				   " and P.SerialNo='"+sObjectNo+"' "; 
		}
		else if(sObjectType.equals("BusinessContract"))//��ͬ
		{
			sSql = " select ObjectType,ObjectNo,R.SerialNo,EvaluateDate,R.ModelNo,AccountMonth, "+
				   " '���ն�������' as ModelTypeName,EvaluateScore,OrgID,getOrgName(OrgID) as OrgName, "+
				   " UserID,getUserName(UserID) as UserName,R.FinishDate "+
				   " from EVALUATE_RECORD R, BUSINESS_CONTRACT P "+
				   " where ObjectType='BusinessApply' "+
				   " and R.ObjectNo=P.RelativeSerialNo "+ 
				   " and P.SerialNo='"+sObjectNo+"' "; 
		}		
	}else//�����׶ε�����
	{
		sSql += " and C.ModelType='"+sModelType+"'";
	}

	sSql += " order by AccountMonth DESC,SerialNo desc ";
	ASDataObject doTemp = new ASDataObject(sSql);
	if (sModelType.equals("080"))
	{
		doTemp.setHeader(sHeaders1);
		//���ò��ɼ���
		doTemp.setVisible("EvaluateResult,CognScore,CognResult,CognOrgName,CognUserName,CognDate",false);
		  
	}
	else
	{
		doTemp.setHeader(sHeaders);
		doTemp.setVisible("CognScore,CognResult",false);
	}
	//�費�ɼ�
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,ModelNo,UserID,OrgID,CognUserID,CognOrgID,FinishDate",false);
	if(sDisplayFinalResult==null || !sDisplayFinalResult.equalsIgnoreCase("Y"))
	{
		doTemp.setVisible("EvaluateScore,EvaluateResult,CognScore,CognResult",false);
	}
	doTemp.setVisible("CognDate,CognOrgName,CognUserName",false);
	//���ÿ��
	doTemp.setHTMLStyle("ModelName","style={width:200px} ");
	doTemp.setHTMLStyle("AccountMonth,CognDate,EvaluateScore,EvaluateResult,UserName,CognScore,CognResult","  style={width:80px}  ");
	//����EvaluateScore�ļ���ʽ(1 String 2 Number 3 Date(yyyy/mm/dd) 4 DateTime(yyyy/mm/dd hh:mm:ss))
	doTemp.setCheckFormat("BusinessSum,EvaluateScore,CognScore","2");
	//����EvaluateScore���ֶ�����("String","Number")
	doTemp.setType("EvaluateScore,CognScore","Number");
	
	if (sModelType.equals("080"))
	{
		doTemp.setHTMLStyle("EvaluateScore,CognScore","style={width:160px} ");	  
	}
	doTemp.setCheckFormat("EvaluateDate","3");
    doTemp.setHTMLStyle("OrgName","style={width:200px}"); 	
	doTemp.setAlign("EvaluateResult,CognResult","2");
	//���ɹ�����
	doTemp.setColumnAttribute("AccountMonth","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//ȡ�Ƿ�ͣ�ò��пͻ����õȼ�����
	String sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
    if (sIsInuse== null) sIsInuse="" ;
%> 

<%/*END*/%>


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
			  {"true","","Button","����","����������Ϣ","my_add()",sResourcesPath},
			  {"true","","Button","ɾ��","ɾ����ѡ�е���Ϣ","my_del()",sResourcesPath},
			  {"true","","Button","����","�鿴��������","my_detail()",sResourcesPath},
			  {"true","","Button","��ӡ","��ӡ��������","my_print()",sResourcesPath},
			  {"false","","Button","�˹��϶�","�����϶�ԭ��˵��","Reason()",sResourcesPath},
			  {"false","","Button","ɾ��","ɾ�����õȼ���������","cancelApply()",sResourcesPath},
			  {"false","","Button","ǩ�����","��ӡ��������","signOpinion()",sResourcesPath},
			  {"false","","Button","�ύ","��ӡ��������","doSubmit()",sResourcesPath},
		     };
	if (sModelType.equals("030") || sModelType.equals("018") || sModelType.equals("080"))
	{
	    sButtons[3][0] = "false";
	}
	if (sModelType.equals("010") ||sModelType.equals("018")) {
		sButtons[4][0] = "false";
	}
	if(sModelType.equals("015"))
	{
		sButtons[1][0] = "false";
		sButtons[5][0] = "true";
		sButtons[6][0] = "false";
		sButtons[7][0] = "false";
		
	}
	//��ͣ�ò�����������ʱ���Ρ����пͻ����õȼ��������µ�����ɾ����ť
	if(sObjectType.equals("NewEvaluate") && !sIsInuse.equals("2"))
	{
		sButtons[1][0] = "false";
		sButtons[0][0] = "false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script>
	//---------------------���尴ť�¼�---------------------//
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function my_add()
	{
		var stmp = CheckRole();
		if("true"==stmp)
		{    		
    		sReturn = PopPage("/Common/Evaluate/AddEvaluateMessage.jsp?Action=display&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ModelType=<%=sModelType%>&EditRight=100","","dialogWidth:350px;dialogHeight:350px;resizable:yes;scrollbars:no");
    		if(sReturn==null || sReturn=="" || sReturn=="undefined") return;
    		sReturns = sReturn.split("@");
    		sObjectType = sReturns[0];
    		sObjectNo = sReturns[1];
    		sModelType = sReturns[2];
    		sModelNo = sReturns[3];
    		sAccountMonth = sReturns[4];
    		
    		sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=add&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelType="+sModelType+"&ModelNo="+sModelNo+"&AccountMonth="+sAccountMonth,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
    		if (typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn == "EXIST")
    		{
    			alert(getBusinessMessage('189'));//�������õȼ�������¼�Ѵ��ڣ���ѡ�������·ݣ�
    			return;
    		}
    		
    		if(typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn != "failed")
    		{
    			var sEditable="true";
				OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID=<%=sCustomerID%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sReturn+"&Editable="+sEditable,"_blank",OpenStyle);
    		}
    	    reloadSelf();
	    }else
	    {
	        alert(getBusinessMessage('190'));//�Բ�����û�����õȼ�������Ȩ�ޣ�
	    }
	}
	
	/*~[Describe=�鿴��ϸ;InputParam=��;OutPutParam=��;]~*/
	function my_detail()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sUserID       = getItemValue(0,getRow(),"UserID");
		var sOrgID        = getItemValue(0,getRow(),"OrgID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sEditable="true";
			if(sUserID!="<%=CurUser.UserID%>")
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID=<%=sCustomerID%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&Editable="+sEditable,"_blank",OpenStyle);
		    reloadSelf();
		}		
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function my_del()
	{
		var stmp = CheckRole();
		if("true"==stmp)
		{
    		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    		var sUserID       = getItemValue(0,getRow(),"UserID");
    		var sOrgID        = getItemValue(0,getRow(),"OrgID");
    		
    		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    		{
    			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		}else if(sUserID=='<%=CurUser.UserID%>')
    		{
	          	if(confirm(getHtmlMessage('2')))
	          	{
	          	  	sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=delete&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
		    		if(sReturn=="success")
		    		{
		    			alert(getHtmlMessage('7'));//��Ϣɾ���ɹ���
		    			reloadSelf();
		    		}else
		    		{
		    			alert(getHtmlMessage('8'));//�Բ���ɾ����Ϣʧ�ܣ�
		    		}		    	           
    		    } 
    		}else alert(getHtmlMessage('3'));
		}else
	    {
	       alert(getBusinessMessage('190'));//�Բ�����û�����õȼ�������Ȩ�ޣ�
	    }
	}
	
	/*~[Describe=�˹��϶�;InputParam=��;OutPutParam=��;]~*/
	function Reason()
	{
	    var stmp = CheckRole();
		if("true"==stmp)
		{
    		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    		var sUserID = getItemValue(0,getRow(),"UserID");
    		var sOrgID = getItemValue(0,getRow(),"OrgID");
    		var sModelNo = getItemValue(0,getRow(),"ModelNo");
    		var sFinishDate	= getItemValue(0,getRow(),"FinishDate");
    		
    		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    		{    		
    			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��  			
    		}else
    		{
    			OpenComp("EvaluateReason","/Common/Evaluate/Reason.jsp","FinishDate="+sFinishDate+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&ModelNo="+sModelNo,"_blank","height=600, width=800, left=0,top=0,toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
    		    reloadSelf();
    		}
    	}
	    else
	    {
	        alert(getBusinessMessage('190'));//�Բ�����û�����õȼ�������Ȩ�ޣ�
	    }
	}
	/*~[Describe=��ӡ;InputParam=��;OutPutParam=��;]~*/
	function my_print()
	{

		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sModelNo      = getItemValue(0,getRow(),"ModelNo");
		sSerialNo     = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��  	
		}else
		{
			PopPage("/Common/Evaluate/EvaluatePrint.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&rand="+randomNumber(),"_blank","");
 		}
	}
	/*~[Describe=����У��;InputParam=��;OutPutParam=��;]~*/
	function CheckRole()
	{
	    var sCustomerID="<%=sCustomerID%>";
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
  
        if (typeof(sReturn)=="undefined" || sReturn.length==0){
        	return n;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];        //�ͻ�����Ȩ
        sReturnValue2 = sReturnValue[1];        //��Ϣ�鿴Ȩ
        sReturnValue3 = sReturnValue[2];        //��Ϣά��Ȩ
        sReturnValue4 = sReturnValue[3];        //ҵ�����Ȩ

        if(sReturnValue3 =="Y2")
            return "true";
        else
            return "n";
	}
	//add by xhyong ���������ύ����
	//ǩ�����
	function signOpinion()
	{
     	//������͡���ˮ�š����̱�š��׶α��
		var sObjectType = "Customer";
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = "EvaluateFlow";
		var sPhaseNo = "0010";
		sEvaluateScore = getItemValue(0,getRow(),"EvaluateScore");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (typeof(sEvaluateScore)=="undefined" || sEvaluateScore.length==0){
			alert("���Ƚ���ģ��������");//���Ƚ���ģ������
			return;
		}
		//�ж��Ƿ��ύ
		var sColName = "PhaseNo"+"~";
		var sTableName = "FLOW_OBJECT"+"~";
		var sWhereClause = "String@ObjectNo@"+sSerialNo+"@String@ObjectType@Customer"+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('@');
			if(sReturn[1] != "0010")
			{
				alert("�Ѿ��ύ,����ǩ�����!");
				return;
			}
			
		}
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		
		PopComp("SignEvaluateOpinionInfo","/Common/WorkFlow/SignEvaluateOpinionInfo.jsp","TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function cancelApply()
	{
		//������͡���ˮ��
		var ObjectType = "Customer";
		var SerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(SerialNo)=="undefined" || SerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			var sReturn = RunMethod("WorkFlowEngine","DeleteCreditCognTask",ObjectType+","+SerialNo+",DeleteTask");
			if (typeof(sReturn) != "undefined" && sReturn.length>=0)
			{
				alert("ɾ���ɹ���");
			}	
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}
	
	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()
	{
		//������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = "Customer";
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = "EvaluateFlow";
		var sPhaseNo = "0010";
		sEvaluateScore = getItemValue(0,getRow(),"EvaluateScore");
	    sFinishDate = "<%=StringFunction.getToday()%>";
		sUserId="<%=CurUser.UserID%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if (typeof(sEvaluateScore)=="undefined" || sEvaluateScore.length==0){
			alert("���Ƚ���ģ��������");//���Ƚ���ģ������
			return;
		}
		
		//�ж��Ƿ��ύ
		var sColName = "PhaseNo"+"~";
		var sTableName = "FLOW_OBJECT"+"~";
		var sWhereClause = "String@ObjectNo@"+sSerialNo+"@String@ObjectType@Customer"+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('@');
			if(sReturn[1] != "0010")
			{
				alert("�Ѿ��ύ,�����ظ��ύ!");
				return;
			}
			
		}
		
		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
	
		//����Ƿ�ǩ�����
		var sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("����ǩ���϶������Ȼ�����ύ��");//��ǩ���϶����
			return;
		}

		//���������ύѡ�񴰿�		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined"){
			 return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				reloadSelf();
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}		
	} 
	//add end
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
	
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
