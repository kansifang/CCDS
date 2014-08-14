package com.lmt.app.cms.dbh;

import java.io.ByteArrayInputStream;
import java.sql.PreparedStatement;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class HandleBlobContent extends Bizlet{
  public Object run(Transaction Sqlca)throws Exception{
	  	String Msg="";
		String ContentLongColumn = null; 
		String ContentColumn = null; 
		String Content = null; 
		String Table = null; 
		String Where = null;
		String handleType=(String)getAttribute("HandleType");
		ContentLongColumn = (String)getAttribute("ContentLongColumn");
		ContentColumn = (String)getAttribute("ContentColumn");
		Table = (String)getAttribute("Table");
		Where = (String)getAttribute("Where");
		Content = (String)getAttribute("Content");
		if("U".equals(handleType)){
			byte abyte0[] = Content.getBytes("GBK");
			String sUpdate0 = "update "+Table+" set "+ContentColumn+"=?,"+ContentLongColumn+"=? where "+Where;
			PreparedStatement pre0 = Sqlca.conn.prepareStatement(sUpdate0);
			pre0.clearParameters();
			pre0.setBinaryStream(1, new ByteArrayInputStream(abyte0,0,abyte0.length), abyte0.length);
			pre0.setInt(2, abyte0.length);
			pre0.executeUpdate();
			pre0.close();	
		}else{
			//System.out.println("sFileFullPath:");
			StringBuffer sb=new StringBuffer("");
			ASResultSet rs = Sqlca.getResultSet("select "+ContentLongColumn+"" +
												" from "+Table+
												" where "+Where);
			if(rs.next()){	
				int iContentLength=rs.getInt(ContentLongColumn);
				if (iContentLength>0){
					byte bb[] = new byte[iContentLength];
					int iByte = 0;		
					java.io.InputStream inStream = null;
					ASResultSet rsrs = Sqlca.getResultSet2("select "+ContentColumn+
									" from "+Table+
									" where "+Where);//×¢ÒâÊÇgetResultSet2
					if(rsrs.next()){
						inStream = rsrs.getBinaryStream(ContentColumn);
						while(true){
							iByte = inStream.read(bb);
							if(iByte<=0)
								break;
							sb.append(new String(bb,"GBK"));
						}
					}
					rsrs.getStatement().close();
				}
			}
			rs.getStatement().close();
			Msg=sb.toString();
		}
		return Msg;
  }
}