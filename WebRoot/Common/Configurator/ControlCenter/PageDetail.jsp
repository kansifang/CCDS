<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%
 	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
 %>
	<%
		/*
			Author:   
			Tester:
			Content: ��ҳ��
			Input Param:
		          
			Output param:
		      
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>

<%
	String sToShowCompClientID = DataConvert.toRealString(iPostChange,CurPage.getParameter("ToShowCompClientID"));
String sToShowPageClientID = DataConvert.toRealString(iPostChange,CurPage.getParameter("ToShowPageClientID"));
ASComponent compToShow = CurCompSession.lookUp(sToShowCompClientID);
if(compToShow==null) throw new Exception("������ѱ����ٻ�ͻ��˺Ŵ����޷���CurCompSession���ҵ�������ͻ��˺ţ�"+sToShowCompClientID);
ASPage pageToShow = compToShow.lookUpPage(sToShowPageClientID);
if(pageToShow==null) throw new Exception("��ҳ���ѱ����ٻ�ͻ��˺Ŵ����޷���CurCompSession���ҵ�������ͻ��˺ţ�"+sToShowCompClientID+",ҳ��ͻ��˺ţ�"+sToShowPageClientID);
%>

<html>
<head>
<title></title> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div style="position:absolute;width:100%;height:100%;overflow:auto;">
<table width="100%" border="1" cellspacing="0" cellpadding="4" bodercolorlight="#666666" bodercolordark="#FFFFFF">
  <tr bgcolor="#000066"> 
    <td colspan="2" ><strong><font color="#FFFFFF">ҳ��ʵ������</font></strong></td>
  </tr>

  <ul>

  <tr bgcolor="#C8D2DF"> 
    <td>
    <li>����(Name)</li>
    </td>
    <td><%=pageToShow.Name%></td>
  </tr>
  <tr bgcolor="#C8D2DF"> 
    <td>
    <li>��ַ(CompURL)</li>
    </td>
    <td ><%=pageToShow.PageURL%></td>
  </tr>
  <tr bgcolor="#C8D2DF"> 
    <td>
    <li>����APP</li>
    </td>
    <td><%=pageToShow.appID%></td>
  </tr>

  <tr bgcolor="#000066"> 
    <td colspan="2" ><strong><font color="#FFFFFF">ҳ�������</font></strong></td>
  </tr>

  <ul>
<%
	for(int i=0;i<pageToShow.parameterList.size();i++){
%>
  <tr bgcolor="#C8D2DF"> 
    <td>
    <li><%
    	out.println(((ASParameter)pageToShow.parameterList.get(i)).paraName);
        Object oTmp=null;
        String sObjType=null;
        oTmp = ((ASParameter)pageToShow.parameterList.get(i)).paraValue;
        if(oTmp!=null)
        {
        	sObjType = oTmp.getClass().getName();
        	out.println("["+sObjType+"]");
        }
    %></li>
    </td>
    <td><textarea style="width:100%;height:100%"><%
    	try{
        	if(sObjType==null){
        		out.print("null");
        	}else if(sObjType.equals("java.lang.String")){
    	    	out.print(StringFunction.replace(DataConvert.toRealString(iPostChange,oTmp.toString()),"<","&#60;"));
    	    }else if(sObjType.equals("com.amarsoft.web.dw.ASDataWindow")){
    	    	out.print(((com.amarsoft.web.dw.ASDataWindow)oTmp).Name);
    	    }else{
    	    	out.print("[toString]: "+oTmp.toString());
    	    }
        }catch(Exception ex){
        	out.print(ex.toString());
        }
    %></textarea>
    </td>
  </tr>
<%
	}
%>


  </ul>
  

</table>

</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>