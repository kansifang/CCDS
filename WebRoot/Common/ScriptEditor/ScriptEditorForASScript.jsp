<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
String sScriptText = DataConvert.toRealString(iPostChange,CurPage.getParameter("ScriptText",10));
if (sScriptText==null) sScriptText="";
sScriptText = StringFunction.replace(sScriptText,"$[wave]","~");

//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"δ����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	//tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

int i=0;
int j=0;
String sFolder = "";
String sSql2="";
ASResultSet rs2=null;
String sSql="select ClassName from CLASS_CATALOG ";
ASResultSet rs=Sqlca.getASResultSet(sSql);
while(rs.next()) 
{
    j=0;
    sFolder = tviTemp.insertFolder("root",rs.getString(1),"",i++);
    sSql2 = "select distinct MethodName,'<font color=red>'||ReturnType ||'</font>&nbsp;&nbsp;!'||ClassName ||'.'||MethodName||'('|| MethodArgs ||')',MethodDescribe,MethodCode from CLASS_METHOD "+
            "where ClassName='"+rs.getString(1)+"' order by MethodName";
    rs2 = Sqlca.getASResultSet(sSql2);
    while (rs2.next()) 
    {
        tviTemp.insertPage(sFolder,rs2.getString(1),"javascript:parent.mySelection(\""+rs.getString(1)+"\",\""+rs2.getString(1)+"\",\""+rs2.getString(2)+"\",\""+rs2.getString(3)+"\",\""+rs2.getString(4)+"\")",j++);
    }
    rs2.getStatement().close();
}
rs.getStatement().close();


%>
<HTML>
<html>
<head>
<title></title>
</head>

<body leftmargin="0" topmargin="0" class="windowbackground" onload="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr height=1>
	    <td>
            <table>
                <tr>
                    <td >
                        <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȷ��","ȷ��","translateScriptText()",sResourcesPath)%>
                    </td>
                    <td>
                        <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȡ��","ȡ��","cancel()",sResourcesPath)%>
                    </td>
                    <td id="showTreeButtonTD">
                        <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ʾ������","��ʾ������","showTree()",sResourcesPath)%>
                    </td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
		<td valign="top">

			<table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="content_table"  id="content_table">
				<tr> 
					<td id="myleft_left_top_corner" class="myleft_left_top_corner"></td>
					<td id="myleft_top" class="myleft_top"></td>
					<td id="myleft_right_top_corner" class="myleft_right_top_corner"></td>
					<td id="mycenter_top" class="mycenter_top"></td>
					<td id="myright_left_top_corner" class="myright_left_top_corner"></td>
					<td id="myright_top" class="myright_top"></td>
					<td id="myright_right_top_corner" class="myright_right_top_corner"></td>
				</tr>
				<tr> 
					<td id="myleft_leftMargin" class="myleft_leftMargin"></td>
					<td id="myleft" width=20%> 
						<iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe>
					</td>
					<td id="myleft_rightMargin" class="myleft_rightMargin"> </td>
					<td id="mycenter" class="mycenter">
						<div id=divDrag title='����ק�ı䴰�ڴ�С Drag to resize' style="z-index:0; CURSOR: url('<%=sResourcesPath%>/ve_split.cur') "	ondrag="if(event.x>16 && event.x<400) {myleft_top.style.display='block';myleft.style.display='block';myleft_bottom.style.display='block';myleft.width=event.x-6;}if(event.x<=16 && event.y>=4) {myleft_top.style.display='none';myleft.style.display='none';myleft_bottom.style.display='none';}if(event.x<4) window.event.returnValue = false;">
							<!--img name=imgDrag title='������' height=100% width=3 src="<%=sResourcesPath%>/line.gif"-->
							<img class=imgDrag src=<%=sResourcesPath%>/1x1.gif width="1" height="1">
						</div>
					</td>
					<td id="myright_leftMargin" class="myright_leftMargin"></td>
					<td id="myright" class="myright">
						<div  class="RightContentDiv" id="RightContentDiv"> 
							<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
								<tr> 
									<td colspan=2 id="myHelpText" height=10 class='Help_TextArea'> Script ����
									</td>
								</tr>
                                <tr> 
									<td colspan=2 > 
										<div name="tt" class="groupboxmaxcontent" style="position:absolute; width: 100%;height:100%" id="window1"> 
                                        <iframe name="right" style="display:none"></iframe>
                                        <TEXTAREA name="myTextArea" ROWS="35" COLS="100" ONSELECT="storeCaret(this);" onCLICK="storeCaret(this);" onKEYUP="storeCaret(this);" WRAP=soft class="Script_TextArea"></TEXTAREA>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
					<td id="myright_rightMargin" class="myright_rightMargin"></td>
				</tr>
				<tr>
					<td id="myleft_left_bottom_corner" class="myleft_left_bottom_corner"></td>
					<td id="myleft_bottom" class="myleft_bottom"></td>
					<td id="myleft_right_bottom_corner" class="myleft_right_bottom_corner"></td>
					<td id="mycenter_bottom" class="mycenter_bottom"></td>
					<td id="myright_left_bottom_corner" class="myright_left_bottom_corner"></td>
					<td id="myright_bottom" class="myright_bottom"></td>
					<td id="myright_right_bottom_corner" class="myright_right_bottom_corner"></td>
				</tr>
			</table>

		</td>
	</tr>
</table>
</body>
</html>

<script language="javascript">
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
    
    function translateScriptText(){
        top.returnValue = amarsoft2Real(document.all("myTextArea").value);
		top.close();
    }
	
    function cancel(){
		self.close();
	}
    
    //ѡ���������͡�������
    function clickMyColOption(sPara1,sPara2)
    {
        sCurOptValue=sPara1;
        sCurOptName=sPara2;
    }

    function mySelection(sClassName,sMethodName,sMethod,sMethodDescribe,sMethodCode){
        var sReturnValue="!"+sClassName+"."+sMethodName+"()";
        var sHelpText=sMethod+"<br>"+sMethodDescribe+"<br>"+sMethodCode;
        sHelpText = sHelpText+"<br><br><a href=\"javascript:insertHelp('"+sReturnValue+"')\"><font color=red>����÷���</font></a>";
//        alert(sHelpText);
        document.all("myHelpText").innerHTML=sHelpText;
    }
    
    function insertHelp(tmp)
    {
        insertAtCaret(document.all("myTextArea"),tmp);
    }

    //ȷ��ѡ���λ��
    function storeCaret (textEl) { 
    if (textEl.createTextRange) 
        textEl.caretPos = document.selection.createRange().duplicate(); 
        
    } 
    
    //��������
    function insertAtCaret (textEl, text) { 
    if (textEl.createTextRange && textEl.caretPos) { 
        var caretPos = textEl.caretPos; 
        caretPos.text =text; 
    }else 
        textEl.value = textEl.value+text; 
    } 
    
    //����String.replace���������ַ����������ߵĿո��滻�ɿ��ַ���
    function Trim (sTmp)
    {
        return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
    
	function showTree(){
		myleft.width=200;
		startMenu();
		expandNode('root');
		showTreeButtonTD.style.display="none";
	}
</script>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Tree06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script language="JavaScript">
	myleft.width=1;
    //����ʱȥ��ֵ���ߵĿո�
    document.all("myTextArea").value = amarsoft2Real("<%=sScriptText.trim()%>");
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>