package com.lmt.app.crawler.dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.htmlparser.Node;
import org.htmlparser.NodeFilter;
import org.htmlparser.Parser;
import org.htmlparser.beans.StringBean;
import org.htmlparser.filters.AndFilter;
import org.htmlparser.filters.HasAttributeFilter;
import org.htmlparser.filters.TagNameFilter;
import org.htmlparser.tags.Div;
import org.htmlparser.tags.HeadingTag;
import org.htmlparser.util.NodeList;
import org.htmlparser.util.ParserException;

import com.lmt.baseapp.util.DBFunction;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.ConnectionManager;
import com.lmt.frameapp.sql.Transaction;

/**
 * 用于对搜狐网站上的新闻进行抓取
 * @author guanminglin <guanminglin@gmail.com>
 */
public class HtmlDao {
    private HtmlBean bean = new HtmlBean();
    private Transaction Sqlca = null;    //数据库连接管理器。
    private PreparedStatement pstmt = null;
    int n=0;//插入数据库条数计数器
    public HtmlDao(){
        	ASConfigure asconfigure = ASConfigure.getASConfigure();
        	String sDataSource=null;
        	 String sql = "insert into Batch_Html(SerialNo,newstitle,newsauthor,newscontent,newsurl,newsdate,updateDate) values(?,?,?,?,?,?,?)";
        	try {
        		sDataSource = asconfigure.getConfigure("DataSource");
        		Sqlca = ConnectionManager.getTransaction(sDataSource);
        		pstmt = Sqlca.conn.prepareStatement(sql);
        	} catch (Exception e) {
        		e.printStackTrace();
    			System.out.println("连接数据库失败！连接参数：<br>DataSource:"+ sDataSource);
    		}
    }
    /**
     *  设置新闻对象，让新闻对象里有新闻数据
     * @param newsTitle 新闻标题
     * @param newsauthor  新闻作者
     * @param newsContent 新闻内容
     * @param newsDate  新闻日期
     * @param url  新闻链接
     */
    public void setNews(String newsTitle, String newsauthor, String newsContent, String newsDate, String url) {
        bean.setTitle(newsTitle);
        bean.setAuthor(newsauthor);
        bean.setContent(newsContent);
        bean.setLastUpdateTime(newsDate);
        bean.setURL(url);
    }
    /**
     * 查询新闻。
     * @param pageindex 页数，从0开始 newsBean
     * @return
     */
    public ArrayList<HtmlBean> getNewsList(String columns,String sfromwhere,int pageindex,int pageSize) {
    	ArrayList<HtmlBean> list = new ArrayList<HtmlBean>();
        String sSql="select num,"+columns+" from "+
        				"(select row_number()over(order by NewsDate desc,SerialNo desc) as num,"+columns+" "+sfromwhere+")tab "+
		        	" where num>"+(pageindex*pageSize)+
		        	" and num<="+(pageindex*pageSize+pageSize);
        try {
			ASResultSet rs=Sqlca.getASResultSet(sSql);
			while(rs.next()){
				HtmlBean newsBean=new HtmlBean();
				newsBean.setNum(rs.getInt("num"));
				newsBean.setSerialNo(rs.getString("SerialNo"));
				newsBean.setTitle(rs.getString("NewsTitle"));
				newsBean.setAuthor(rs.getString("NewsAuthor"));
				newsBean.setContent(rs.getString("NewsContent"));
				newsBean.setURL(rs.getString("NewsURL"));
				newsBean.setLastUpdateTime(rs.getString("NewsDate"));
		        list.add(newsBean);
			}
			rs.getStatement().close();
		    return list;
		} catch (Exception e) {
			System.out.println("查询数据库异常！");
			e.printStackTrace();
		}
        return list;
    }
    /**
     * 查询新闻。
     * @param pageindex 页数，从0开始 newsBean
     * @return
     */
    public HtmlBean getNews(String columns,String sfromwhere) {
        String sSql="select "+columns+" "+sfromwhere;
        try {
			ASResultSet rs=Sqlca.getASResultSet(sSql);
			if(rs.next()){
				HtmlBean newsBean=new HtmlBean();
				newsBean.setSerialNo(rs.getString("SerialNo"));
				newsBean.setTitle(rs.getString("NewsTitle"));
				newsBean.setAuthor(rs.getString("NewsAuthor"));
				newsBean.setContent(rs.getString("NewsContent"));
				newsBean.setURL(rs.getString("NewsURL"));
				newsBean.setLastUpdateTime(rs.getString("NewsDate"));
				return newsBean;
			}
			rs.getStatement().close();
		    
		} catch (Exception e) {
			System.out.println("查询数据库异常！");
			e.printStackTrace();
		}
        return null;
    }
    /**
     * 将新闻插入到数据库中
     * @param bean
     * @return
     */
    public void saveToDB(HtmlBean bean) {
        try {
			String sSerialNo=DBFunction.getSerialNo("Batch_Html","SerialNo", Sqlca);
			pstmt.setString(1, sSerialNo);
            pstmt.setString(2, bean.getTitle());
            pstmt.setString(3, bean.getAuthor());
            pstmt.setString(4, bean.getContent());
            pstmt.setString(5, bean.getURL());
            pstmt.setString(6, bean.getLastUpdateTime());
            pstmt.setString(7, StringFunction.getTodayNow());
            pstmt.addBatch();
            n++;
            if(n>=100){
            	pstmt.executeBatch();
            	Sqlca.conn.commit();
            	n=0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(HtmlDao.class.getName()).log(Level.SEVERE, null, ex);
        }catch (Exception ex) {
            Logger.getLogger(HtmlDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public void close(){
    	try{
    		Sqlca.executeSQL("delete from Batch_Html BPT1" +
				" where BPT1.SerialNo<(select max(BPT2.SerialNo) from Batch_Html BPT2 " +
				"					where BPT1.NewsTitle=BPT2.NewsTitle " +
				"                   and BPT1.Newsdate=BPT2.Newsdate)");
    		if(pstmt!=null){
				pstmt.executeBatch();
				pstmt.close();
			}
			if(Sqlca != null) {
				Sqlca.conn.commit();
				Sqlca.disConnect();
				Sqlca = null;
			}
		} catch (SQLException ex) {
            Logger.getLogger(HtmlDao.class.getName()).log(Level.SEVERE, null, ex);
        }catch (Exception exception3) {
			ARE.getLog().error("Crawler close SQL Error2:", exception3);
		}
    }
    //单个文件测试网页
    public static void main(String[] args) {
      //  SohuNews news = new SohuNews();
      //  news.parser("http://news.sohu.com/20090518/n264012864.shtml");   
    }
}