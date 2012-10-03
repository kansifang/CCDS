
<%@page import="com.amarsoft.are.util.DataConvert"%><%!
	/*
	����������ͨ����Ӧ�Ĳ���������������չ����ʽ
	����˵����
		String sStyle         �ı������� 0��Input 1��textarea
        String sMethodInput   ����Method��ֵ 1:display;2:save;3:preview;4:export
        String sControlName   �ı�������ƺ���ʽ
        String sContent       �ı�����
    */
	public String myOutPut(String sStyle,String sMethodInput,String sControlName,String sContent)
	{
		if(sMethodInput.equals("1")||sMethodInput.equals("2")) 	//1:display;2:save
		{
			if(sStyle.equals("1")) 	//need htmledit(textarea)
				return "<textarea "+sControlName+">"+sContent+"</textarea>";
			else 					//else input
				return "<input type=text "+sControlName+" value='"+sContent+"' >";
		}
		else													//3:preview;4:export
			return sContent;
	}
	
	//�����鱨���н����toMoney() add by zwhu 2010/01/15
	public String myOutPut1(String sStyle,String sMethodInput,String sControlName,String sContent)
	{
		if(sMethodInput.equals("1")||sMethodInput.equals("2")) 	//1:display;2:save
		{
			if(sStyle.equals("1")) 	//need htmledit(textarea)
				return "<textarea "+sControlName+">"+sContent+"</textarea>";
			else 					//else input
				return "<input type=text "+sControlName+" value='"+DataConvert.toMoney(sContent.replaceAll(",",""))+"' >";
		}
		else													//3:preview;4:export
			return sContent;
	}
		public String myOutPutCheck(String sStyle,String sMethodInput,String sControlName,String sContent,String sText)
	{
		String sType="",isChecked="",sOutPut="";
		int i=0;
		if(sMethodInput.equals("0")||sMethodInput.equals("1")) 	//1:display;2:save
		{
			//radio or select
			if (sStyle.equals("3")){
				String arrText[] = sText.split("@");
				for (i=0;i<arrText.length;i++){
					if ( sContent.equals(arrText[i])){
						isChecked = " checked ";
					}else{
						isChecked = "";
					}	
					sOutPut= sOutPut + " <input type='radio' " +sControlName+isChecked+" value='"+arrText[i]+"'>"+arrText[i];
				}
				return (sOutPut);
			}else if (sStyle.equals("4")){
	
				if (sText.equals(sContent)){
					isChecked = " checked ";
				}
				return "<input type='checkbox' " +sControlName+isChecked+" value='"+sText+"'>"+sText+"<br>";
			}else if (sStyle.equals("5")){
				sOutPut = "<select "+sControlName+">";
				String arrSelect[] = sText.split("@");
				for (i=0;i<arrSelect.length;i++){
					if (sContent.equals(arrSelect[i])){
						isChecked = " selected ";
					}else{
						isChecked = "";
					}
					sOutPut= sOutPut + " <option value="+arrSelect[i]+isChecked+">"+arrSelect[i]+"</option> ";
				}
				sOutPut = sOutPut + "</select>";
				return sOutPut;
			}else{
				return sContent;
			}
		}else{													//3:preview;4:export
			if (sContent!=null && !sContent.equals("") && sStyle.equals("4")){
				sContent = sContent+"<br>";
			}
			return sContent;
		}
	}
	public String getUnitData(String unitname,String[][] data)
	{
		for(int i=0;i<data.length;i++){
			if(data[i][0].equals(unitname)){
				return data[i][1];
			}
		}
		return "";
	}
	public String myShowTips(String sMethodInput)
	{
		
		if(sMethodInput.equals("1")) 	//1:display
			return " style='display:block' ";
		else													
			return " style='display:none' ";
	}		
%>

<%   
	//����Ĳ���	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sDocID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")); 
	
	//��ѡ�Ĳ���
	String sMethod = DataConvert.toRealString(iPostChange,(String)request.getParameter("Method")); //1:display;2:save;3:preview;4:export
	String sFirstSection = DataConvert.toRealString(iPostChange,(String)request.getParameter("FirstSection")); //�ж��Ƿ�Ϊ����ĵ�һҳ,1:��ʾ�ļ��ĵ�һ�Σ�0:��
	if(sMethod==null) sMethod = "1";
	if(sFirstSection==null || !sFirstSection.equals("1"))  sFirstSection = "0";

	String sReportData="";
	String sDelim = "��";
	//out.println(" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ");
	//�����������

	String sDescribeCount = "";
	String sUpdate0 = "";
	if(sMethod.equals("2")||sMethod.equals("5"))  //save,autosave
	{
		sReportData="";
		for(Enumeration enumeration = request.getParameterNames(); enumeration.hasMoreElements();)
		{
			String sParaName = (String)enumeration.nextElement();
			if(sParaName.startsWith("describe"))
			{	
				String sParaValue = DataConvert.toRealString(iPostChange,(String)request.getParameter(sParaName));
				if(sParaValue==null) sParaValue="";
				if(sParaValue.trim().equals("")) {
					sParaValue = "none";
				}
				else{
					sReportData += sParaName+"@"+sParaValue+sDelim;
				}
			}	
		}
			
		byte abyte0[] = sReportData.getBytes("GBK");
		
		sUpdate0 = " update INSPECT_INFO set HtmlData=?,ContentLength=?,UPDATEDATE='"+StringFunction.getToday()+"' "+
							" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ";
		out.println(sUpdate0);
	
		PreparedStatement pre0 = Sqlca.conn.prepareStatement(sUpdate0);
		pre0.clearParameters();
		pre0.setBinaryStream(1, new ByteArrayInputStream(abyte0,0,abyte0.length), abyte0.length);
		pre0.setInt(2, abyte0.length);
		pre0.executeUpdate();
		pre0.close();	   				
	}
	else					//1:display,or 3:preview,or 4:export
	{
		ASResultSet rs1 = Sqlca.getResultSet("select ContentLength from INSPECT_INFO "
							+ " where SerialNo='"+sSerialNo+"' and ObjectNO='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ");
		if(rs1.next())	
		{
			int iContentLength=rs1.getInt("ContentLength");
			if (iContentLength>0)
			{
				byte bb[] = new byte[iContentLength];
				int iByte = 0;		
				sReportData = "";
				java.io.InputStream inStream = null;
				
				ASResultSet rs2 = Sqlca.getResultSet2("select HtmlData from INSPECT_INFO "
							+ " where SerialNo='"+sSerialNo+"' and ObjectNO='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ");
				if(rs2.next())
					inStream = rs2.getBinaryStream("HtmlData");
				while(true)
				{
					iByte = inStream.read(bb);
					if(iByte<=0)
						break;
					sReportData = sReportData + new String(bb, "GBK");
				}	
				rs2.getStatement().close();
			}
		}
		rs1.getStatement().close();	
		//System.out.println(sReportData);
	}
	
	
	//�ֽ����ݿ��б�������ݵ������������
	String[][] sData = new String[iDescribeCount][2];
	for (int ii=0;ii<iDescribeCount;ii++) {
		sData[ii][0] = "";
		sData[ii][1] = "";
	}
	StringTokenizer st = new StringTokenizer(sReportData,sDelim);
	for (int ii=0;st.hasMoreTokens()&&ii<iDescribeCount;ii++) {
		String stemp=st.nextToken(sDelim);if(stemp==null) stemp="";
		if(stemp.indexOf("@")>=0){
			sData[ii][0]=stemp.substring(0,stemp.indexOf("@"));
			sData[ii][1]=stemp.substring(stemp.indexOf("@")+1);
			if (sData[ii][1].equals("none")) sData[ii][1]="";
		}
	}

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
			{"true","","Button","����","����","my_save()",sResourcesPath},
			{"true","","Button","Ԥ��","Ԥ��","my_preview()",sResourcesPath},
			{"false","","Button","���","���","my_finish()",sResourcesPath},
			{"false","","Button","���㣨���ȱ��棩","���","my_cal()",sResourcesPath},//����΢С��ҵ�����鱨��
			//{"false","","Button","��ӡ","��ӡ","my_export()",sResourcesPath},  
		};

	%> 
<%/*~END~*/%>		

