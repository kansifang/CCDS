package com.lmt.app.edoc;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Properties;

import org.jdom.JDOMException;

import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
public class EDocumentText{
    private String templateFName;
    private String dataDefFName;
	public EDocumentText(String templateFName, String dataDefineName){
        this.templateFName = templateFName;
        this.dataDefFName = dataDefineName;
    }
	public void saveDoc(String FileOutPath,HashMap map,Transaction Sqlca) {
		String sKey="";
		Properties props = new Properties();
		//Begin! 开始批量导出-----------------------------------------------------------------------------------------------------
		try {
			//获取必要值
			ASResultSet rs=Sqlca.getASResultSet("select OneKey from Batch_Report where SerialNo='"+map.get("SerialNo")+"'");
			if(rs.next()){
				sKey=rs.getString(1);
			}
			rs.getStatement().close();
			//准备好写类
			PrintWriter writer = new PrintWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream(FileOutPath), "gbk")));
			//讀取數據定義文件
		    BufferedReader Dreader = new BufferedReader(new InputStreamReader(new FileInputStream(this.dataDefFName), "gbk"));
			props.load(Dreader);
		    StringBuffer sb=new StringBuffer("");
		    //讀取格式文件
		    BufferedReader Freader = new BufferedReader(new InputStreamReader(new FileInputStream(this.templateFName), "gbk"));
			String line;
			String[] displayContents;
		    if((line = Freader.readLine()) != null) {
				displayContents = line.split("~");
				for(int i=0;i<displayContents.length;i++){
					String displayContent=displayContents[i];
					sb.append("~s贴现漏报明细@");
					sb.append(displayContent);
					sb.append("e~,");
				}
				if(sb.length()>0){
					sb.deleteCharAt(sb.length()-1);
				}
				String sSql="select "+sb.toString()+
							" from Batch_Import_Interim "+
							" where ConfigName='贴现漏报明细' and OneKey='"+sKey+"'";
				sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
				rs=Sqlca.getASResultSet(sSql);
				while(rs.next()){
					StringBuffer sbb=new StringBuffer("");
					for(int i=0;i<displayContents.length;i++){
						String value=rs.getString(i+1).trim();
						int index=value.indexOf(".");
						if(index>0){
							value=value.substring(0,index+3);
						}
						value=value.replaceAll("/", "");
						int length=Integer.valueOf(props.getProperty(displayContents[i]));
						sbb.append(DataConvert.complementSpace(value,length,"gbk"));
					}
					writer.println(sbb.toString());
				}
				rs.getStatement().close();
				writer.flush();
				writer.close();
				Freader.close();
				Dreader.close();
			}
		} catch (Exception e) {
			System.out.println(e);
		}
	}
}