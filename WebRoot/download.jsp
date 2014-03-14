<%@page contentType="text/html; charset=GBK"%>
<%@page import="java.io.File"%>
<html>
	<head>
		<title>统计数据下载</title>
	</head>
	
	<body>
	<%
		String webRoot = request.getContextPath();
		File file = new File(application.getRealPath("data"));
		
		File[] files1 = file.listFiles();
		for(int i1 = 0 ; i1 < files1.length ; i1 ++){
			String filesName1 = files1[i1].getName();
			if(files1[i1].isDirectory()){
				System.out.println(filesName1);
				out.print(filesName1);
				out.println("</br>");
				File[] files2 = files1[i1].listFiles();
				for(int i2 = 0 ; i2 < files2.length ; i2 ++){
					String filesName2 = files2[i2].getName();
					if(files2[i2].isDirectory()){
						out.print("|----"+filesName2);
						out.println("</br>");
						File[] files3 = files2[i2].listFiles();
						for(int i3 = 0 ; i3 < files3.length ; i3 ++){
							String filesName3 = files3[i3].getName();
							out.println("|--------"+"<a href='"+webRoot+"/data/"+filesName1+"/"+filesName2+"/"+filesName3+"'>"+filesName3+"</a>");
							out.println("</br>");
						}
					}else{
						out.println("|----"+"<a href='"+webRoot+"/data/"+filesName1+"/"+filesName2+"'>"+filesName2+"</a>");
						out.println("</br>");
					}

				}
			}else{
				out.println("<a href='"+webRoot+"/data/"+filesName1+"'>"+filesName1+"</a>");
				out.println("</br>");
			}
				
		}
		
	%>
	</body>
</html>
