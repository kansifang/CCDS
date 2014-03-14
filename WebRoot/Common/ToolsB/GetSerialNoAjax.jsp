<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window.open
	//获取表名、列名和格式
		String	sTableName		 = DataConvert.toRealString(iPostChange,(String)request.getParameter("TableName"));
		String	sColumnName 	 = DataConvert.toRealString(iPostChange,(String)request.getParameter("ColumnName"));
		String	sSerialNoFormate = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNoFormate"));
		String  sPrefix			 = DataConvert.toRealString(iPostChange,(String)request.getParameter("Prefix"));
		
		if (sSerialNoFormate == null) sSerialNoFormate="";
		if (sPrefix == null) sPrefix = "";
	
		String	sSerialNo = ""; //流水号
	
		if(sSerialNoFormate.equals(""))
		{
			if (sPrefix.equals(""))	sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,Sqlca);
			else sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,sPrefix,Sqlca);
	
		}else
		{
			sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,sSerialNoFormate,Sqlca);
		}
		out.print(sSerialNo);
    }
    catch(Exception e)
    {
        ARE.getLog().error(e.getMessage(),e);
        throw e;
    }
    finally
    {
    }%>  