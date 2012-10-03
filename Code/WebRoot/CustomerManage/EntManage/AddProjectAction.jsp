<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/%>
<%
/* 
  Tester:
  Content:  新增项目动作
  Input Param:
			ObjectType  ：对象类型
			ObjectNo:   : 对象编号
			ProjectType : 项目类型
			ProjectName : 项目名称
  Output param:
 			sProjectNo  :项目编号
 
  History Log:     
      DATE	  CHANGER		CONTENT
      2005-7-25 fbkang     增加注释
       2005/09/13 zywei 增加事务处理         
 */
 %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>

<%     	
    //定义变量
   	String sSql = "";
    //获得页面参数
	String sObjectType     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo       =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sProjectType    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectType"));
	String sProjectName    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectName"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sProjectType == null) sProjectType = "";
	if(sProjectName == null) sProjectName = "";
   //获得组件参数

	//初始化项目编号
    String sProjectNo  = DBFunction.getSerialNo("PROJECT_INFO","ProjectNo",Sqlca);
 %>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=执行sql命令*/%>    
<%
   	boolean bOld = Sqlca.conn.getAutoCommit(); 
	try {
			if(!bOld) Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(false);
			
		   	//插入项目资料库
		    sSql = " insert into PROJECT_INFO(ProjectNo,InputUserID,InputOrgID,InputDate,UpdateDate,ProjectType,ProjectName) " +
		    	   " values('"+sProjectNo+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"','"+sProjectType+"','"+sProjectName+"')" ;
		    Sqlca.executeSQL(sSql);    
    
		   	//插入项目关联对象库
		    sSql = " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) " +
		    	   " values('"+sProjectNo+"','"+sObjectType+"','"+sObjectNo+"')";
		    Sqlca.executeSQL(sSql);
			//事物提交
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bOld);
		}catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("事务处理失败！"+e.getMessage());
		}
%>
<%/*~END~*/%>	

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main04;Describe=返回参数*/%>  
<html>
<head> 
<title>新增项目资料</title>
</head>   	
<body>
<script language=javascript>
	
	self.returnValue="<%=sProjectNo%>";	
	self.close();
		
</script>
</body>
</html>
<%/*~END~*/%>	
<%@ include file="/IncludeEnd.jsp"%>