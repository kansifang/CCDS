<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginDW.jsp"%>
<%@page import="com.lmt.frameapp.web.VerifySignature" %>
<html>
<head>
	<title>dw_save</title>
</head>
<body>
���ڱ�������......<br>
<%
	int curSuccess=0; //�������ʧ�ܣ��򷵻�0
	String sMessage="",myIndex="";

	iPostChange = 5;

	String sAfterAction = "";
	sAfterAction = DataConvert.toRealString(iPostChange,(String)request.getParameter("afteraction"));  
	if(sAfterAction==null) 	sAfterAction="";
	
	String bNeedCA = request.getParameter("bNeedCA");  //no need convert
	boolean bresult = false;
	if( bNeedCA!=null && bNeedCA.equals("Yes") )
	{	
		String szSignature = DataConvert.toRealString(iPostChange,(String)request.getParameter("Signature"));	
		String szModulus = DataConvert.toRealString(iPostChange,(String)request.getParameter("Modulus"));  		
		bresult = VerifySignature.Verify("123",szModulus,szSignature);	
	}
	if(bNeedCA!=null && bNeedCA.equals("Yes") && !bresult) //ǩ��δͨ��
	{
		curSuccess = 0;
		sMessage = "ǩ��δͨ��";
	}
	else
	{
		ASDataWindow dwTemp = null;
		if(CurPage!=null)
			dwTemp = (ASDataWindow) CurPage.getAttribute(sSessionID);
		else
			dwTemp = (ASDataWindow) session.getAttribute(sSessionID);

		dwTemp.Sqlca = Sqlca;
		try{
			dwTemp.update(request,Sqlca);
		}catch(Exception ex){
			curSuccess = 0;
			sMessage = ex.getMessage();
		}
		myIndex=DataConvert.toRealString(iPostChange,(String)request.getParameter("myIndex"));
		if (sMessage.equals(""))
			curSuccess=1;
		else{
			curSuccess=0;
			sMessage = sMessage.replace('"','^');
			sMessage = sMessage.replace('(','��');
			sMessage = sMessage.replace(')','��');
			sMessage = sMessage.replace('\n',' ');
			sMessage = sMessage.replace('\r',' ');
			System.out.println(",,,,,,,,,,,,,,,,,,");
			sMessage = StringFunction.replace(sMessage,"<br>","\\\\n");
		}
	}	
%>	
<script language=javascript>
	var my_success=<%=curSuccess%>;
	var obj;
	if(typeof(window.opener)=='undefined')
		obj=window.parent;      
	else
		obj=window.opener.top;  
	
	if(my_success==1) 
	{	
		var myi=<%=myIndex%>;
		var i,j,k;
		var my_a=new Array();
		for(i=0;i<obj.my_index[myi].length;i++) 
			my_a[i] = obj.my_attribute[myi][obj.my_index[myi][i]];
		for(i=0;i<obj.my_index[myi].length;i++) 
		{
			if(obj.my_index[myi][i]==-1) break; 
			obj.my_attribute[myi][i]=0;
			for(j=0;j<obj.my_change[myi][i].length;j++) 
			{
				obj.my_change[myi][i][j]=0;
				obj.my_changedoldvalues[myi][i][j]="";
			}
		}
		var my_newindex=new Array();
		for(i=0,j=0,k=0;i<my_a.length;i++)
		{
			if(my_a[i]==0 || my_a[i]==1 || my_a[i]==2)
				my_newindex[j++]=obj.my_index[myi][i];
			else
				k++;	
		}
		obj.sort_end[myi]=obj.sort_end[myi]-k; 
		
		for(i=0;i<my_newindex.length;i++)
			obj.my_index[myi][i]=my_newindex[i];	
		for(i=my_newindex.length;i<obj.my_index[myi].length;i++)
			obj.my_index[myi][i]=-1;		
			
		obj.rr_c[myi]=my_newindex.length;
		obj.r_c[myi]=my_newindex.length;
		obj.curpage[myi]=0;	
		obj.my_load(2,0,"myiframe"+myi);
		//add by hxd in 2004/11/02 for turn page
		obj.cur_sel_rec[myi]=-1;
		if(obj.iCurRow>=obj.rr_c[myi]) obj.iCurRow--; //for delete 
		if(obj.DZ[myi][0][0]==1) obj.iCurRow=-1; //add 05/01/29 hxd
		
		//move to below in 2008/04/10
		//if(obj.bSavePrompt) 
		//	alert("���ݱ���ɹ���");
		//obj.sSaveReturn = "1@���ݱ���ɹ���"; 
		
		var sAfterAction = "<%=sAfterAction%>";
		if(sAfterAction!="")
		{
			//���������ر�(�ر��ں��������ҳ����ʹ��self.close)
			//obj.OpenPage(sAfterAction,"_self",""); //window.open
			try{
				eval("obj."+sAfterAction);
				//add by hxd in 2008/04/10
				obj.hideMessage(); 	
				if(obj.bSavePrompt) alert("���ݱ���ɹ���"); 
				
			}catch(e){
				//add by hxd in 2008/04/10
				obj.hideMessage(); 	

				alert("����"+e.name+" "+e.number+" :"+e.message+"\n\n���������������\n\nʾ��1��\n\n as_save(\"myiframe0\",\"location.reload();\") \n\nʾ��2��\n\n as_save(\"myiframe0\",\"alert('abc');\")");
			}
		}
		else
		{
			//add by hxd in 2008/04/10
			obj.hideMessage(); 	
			if(obj.bSavePrompt) alert("���ݱ���ɹ���"); 
		}
				
		my_success=2;	
		//self.close();  

	}
	else if(my_success==0)
	{
		//add by hxd in 2008/04/10
		obj.hideMessage(); 	

		if(obj.bSavePrompt) 
			alert("���ݱ���ʧ�ܣ�����ԭ���ǣ�<%=sMessage%>");
		obj.sSaveReturn = "-2@���ݱ���ʧ��@<%=sMessage%>";   //amardw��:-1@�������벻δͨ�����	
		//self.close();  
	}

	//add by hxd in 2008/04/10
	try{
		obj.document.frames("myiframe0").document.body.oncontextmenu='self.event.returnValue=true';
	}catch(e){}

</script>

</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
