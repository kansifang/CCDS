/*
 * 创建日期 2005-7-1
 *


 */
package com.amarsoft.app.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.sql.ResultSet;

import org.dbunit.database.DatabaseConnection;
import org.dbunit.database.QueryDataSet;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.stream.IDataSetProducer;
import org.dbunit.dataset.stream.StreamingDataSet;
import org.dbunit.dataset.xml.XmlDataSet;
import org.dbunit.dataset.xml.XmlProducer;
import org.dbunit.operation.DatabaseOperation;
import org.xml.sax.InputSource;

import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;

public class ObjectExim {
	private String sObjectType;
	private String sDefaultPath;
	private String sDefaultSchema;
	
	private String[][] ssResList = null;
	
	public ObjectExim(Transaction transSql,String ObjectType,String sPath) throws Exception
	{
		sObjectType = ObjectType;
		sDefaultPath = sPath;
		init(transSql);
	}

	private void init(Transaction transSql) throws Exception
	{
		String sSql="select TableID,ExportSql,BeforeImpSql from OBJECT_RES_LIST where ObjectType='"+sObjectType
					+"' and EffStatus = '1' order by SortNo" ;
	
		ssResList = transSql.getStringMatrix(sSql);
		if( ssResList.length == 0 )
		{
			throw new Exception("找不到["+sObjectType+"]对应的对象导出资源清单！");
		}
	
		//构造当前链接默认的Schema	     
		ResultSet rsSchema = transSql.conn.getMetaData().getSchemas();
		if( rsSchema.next() )
			sDefaultSchema = rsSchema.getString(1);
		else
			sDefaultSchema = "";
		if( sDefaultPath == null || sDefaultPath.equals("") )
		{
			sDefaultPath = File.listRoots()[0].getPath();
		}
		System.out.println("Current Using Schema:"+sDefaultSchema);
		System.out.println("Current Using SavePath:"+sDefaultPath);
	}

	public void importFromXml(Transaction transSql,String sXmlFile) throws Exception
	{
		importFromXml(transSql,sXmlFile,sDefaultSchema,sDefaultPath);
	}
	
	public void importFromXml(Transaction transSql,String sXmlFile,String sSchema) throws Exception
	{
		importFromXml(transSql,sXmlFile,sSchema,sDefaultPath);
	}

	public void importFromXml(Transaction transSql,String sXmlFile,String sSchema,String sRealPath) throws Exception
	{
		String sBeforeImpSql;
	    DatabaseOperation _operation;
		
		//截取ObjectNo
		int iBgnPos = sXmlFile.indexOf("_");
		String sObjectNo;
		if( iBgnPos >= 0 )
		{
			//有下划线，则有ObjectNo，则执行BeforeImpSql
			int iEndPos = sXmlFile.indexOf(".xml",iBgnPos);
			if( iEndPos < 0 )
				sObjectNo = sXmlFile.substring(iBgnPos+1);
			else
				sObjectNo = sXmlFile.substring(iBgnPos+1,iEndPos);
			for( int i=ssResList.length-1 ; i>=0 ; i-- )
			{
				sBeforeImpSql = ssResList[i][2];
				if( sBeforeImpSql == null || sBeforeImpSql.equals("") ) continue;
				sBeforeImpSql = StringFunction.replace(sBeforeImpSql,"#ObjectNo",sObjectNo);
				transSql.executeSQL(sBeforeImpSql);
			}
		}
        
        //建立DBUnit数据库连接
        DatabaseConnection dbCon = new DatabaseConnection(transSql.conn,sSchema);
		
        try {
			//把Documenth转换为DBUnit的DataSet并解决中文编码问题
			String sSrc = sRealPath+sXmlFile;
			IDataSet dataSet = genInDataSet(sSrc);
			_operation = DatabaseOperation.REFRESH;
			_operation.execute(dbCon, dataSet);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("数据导入失败："+e.toString());
		}
        finally
        {
//            if (dbCon != null)
//            {
//				dbCon.close();
//            }
        }
		
	}
	
	public void exportToXml(Transaction transSql,String ObjectNo) throws Exception
	{
		exportToXml(transSql,ObjectNo,sDefaultSchema,sDefaultPath);
	}

	public void exportToXml(Transaction transSql,String ObjectNo,String sSchema) throws Exception
	{
		exportToXml(transSql,ObjectNo,sSchema,sDefaultPath);
	}

	public void exportToXml(Transaction transSql,String ObjectNo,String sSchema,String sRealPath) throws Exception 
    {
		String sSqlString;
		
        //建立DBUnit数据库连接
        DatabaseConnection dbCon = new DatabaseConnection(transSql.conn,sSchema);
        try {
			//把DataSet导出成Document
			QueryDataSet dataset = new QueryDataSet(dbCon);
			//从对象定义中抽取更新范围
			for( int i=0; i < ssResList.length; i++ )
			{
				sSqlString = StringFunction.replace(ssResList[i][1],"#ObjectNo",ObjectNo);
				dataset.addTable(ssResList[i][0],sSqlString);
			}
			//生成数据库表的更新文件
			String sDest = sRealPath+sObjectType+"_"+ObjectNo+".xml";
			genOutFile(sDest,dataset);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("数据导出失败："+e.toString());
		}
        finally
        {
//            if (dbCon != null)
//            {
//				dbCon.close();
//            }
        }
        
    }
	
    private static void genOutFile(String sDest,IDataSet dataset) throws Exception {
        if( sDest == null || sDest.length() == 0 )
            throw new Exception("未指定输出文件名");
        java.io.File fDest = new java.io.File(sDest);
        
        OutputStream out = new FileOutputStream(fDest);
        //OutputStreamWriter outwr = new OutputStreamWriter(out,config.getProperty("xmlencoding"));
        try
        {
                XmlDataSet.write(dataset, out);
        }
        finally
        {
            //outwr.close();
            out.close();
        }
        
    }
    
    //  把Documenth转换为DBUnit的DataSet
    private static IDataSet genInDataSet(String sSrc) throws Exception {
        java.io.File fSrc = new java.io.File(sSrc);
        IDataSetProducer producer = null;

        producer = new XmlProducer(new InputSource(fSrc.toURL().toString()));

        return new StreamingDataSet(producer);
    }

	/**
	 * @return 返回 sDefaultPath。
	 */
	public String getSDefaultPath() {
		return sDefaultPath;
	}

	/**
	 * @param defaultPath 要设置的 sDefaultPath。
	 */
	public void setSDefaultPath(String defaultPath) {
		sDefaultPath = defaultPath;
	}

	/**
	 * @return 返回 sDefaultSchema。
	 */
	public String getSDefaultSchema() {
		return sDefaultSchema;
	}

	/**
	 * @param defaultSchema 要设置的 sDefaultSchema。
	 */
	public void setSDefaultSchema(String defaultSchema) {
		sDefaultSchema = defaultSchema;
	}

    public static void main(String[] argv) 
	{
    	Transaction Sqlca=null;

    	try {
			
			 Sqlca = getSqlca();
			 
			 System.out.println("环境构建完毕，开始测试！");
			 //testing ................
			ObjectExim oei = new ObjectExim(Sqlca,"CODE","D:/workdir/");
			oei.exportToXml(Sqlca,"YesOrNo");
		} catch (Exception e) {
			e.printStackTrace();
		} 
		finally
		{
            try
            {
	        	if(Sqlca!=null)
	        	{
		            Sqlca.disConnect();
		            Sqlca = null;
		        }
		    }
		    catch(Exception e1)
		    {
				e1.printStackTrace();
			}
		}
	}
	
    private static Transaction getSqlca()
    {
		String sDBChange ="0";
    	String sContextFactory = "org.jnp.interfaces.NamingContextFactory";
    	String sProviderUrl = "corbaloc:iiop:localhost:2809";
    	String sDataSource = "java:jdbc/loan_dev";
		
        javax.sql.DataSource ds = null;
        try
        {    	
	        Transaction Sqlca;
	        Transaction.iChange = Integer.valueOf(sDBChange).intValue();
	        ds = ConnectionManager.getDataSource(sContextFactory, sProviderUrl, sDataSource);
	        Sqlca = ConnectionManager.getTransaction(ds);
	        return Sqlca;
        }
        catch(Exception e)
        {
            System.out.println("SessionListener:getSqlca():"+e.getMessage());
        }
        return null;
    }
}
