package com.lmt.app.display;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashSet;
import java.util.TimeZone;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.StandardChartTheme;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.NumberTickUnit;
import org.jfree.chart.axis.PeriodAxis;
import org.jfree.chart.axis.PeriodAxisLabelInfo;
import org.jfree.chart.labels.ItemLabelAnchor;
import org.jfree.chart.labels.ItemLabelPosition;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.labels.StandardXYItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.chart.renderer.xy.XYItemRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.time.Month;
import org.jfree.data.time.RegularTimePeriod;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;
import org.jfree.data.time.Year;
import org.jfree.data.xy.XYDataset;
import org.jfree.ui.RectangleInsets;
import org.jfree.ui.TextAnchor;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class LineChart {
	/*
	 * 程序入口
	 */
	public static void main(String[] args) {
		// 创建折线图对象
		//JFreeChart 折线图 = ChartFactory.createLineChart("水果销量统计", "时间", "销量", 得到数据(), PlotOrientation.VERTICAL, true, true, true);
		// 给折线图对象设置样式
		//setStyle(折线图);
		// 对折线图对象生成图片
		//生成图片("E:\\折线图.jpg",折线图,800,600);
	}
	public static XYDataset createDataset(String sSql,Transaction Sqlca) throws Exception {
		// 生成数据序列  
		TimeSeries series = new TimeSeries("序列线"); 
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// 添加数据
		while(rs.next()){
			String date=rs.getString(3);
			int year=Integer.valueOf(date.substring(0, 4));
			int month=Integer.valueOf(date.substring(5, 7));
			RegularTimePeriod YM=new Month(month,year);
			series.add(YM, rs.getDouble(1));  
		}
         // 将数据序列放在一个数据集合中  
         TimeSeriesCollection dataset = new TimeSeriesCollection();  
         dataset.addSeries(series);   
         return dataset;  
     }
	 /** 
     * 随机生成数据,自动定位到时间序列上的下一个时间点，将新数据点加入到数据序列中 
     * 
     * @param series    数据序列对象 
     * @param baseData  生成的随机数据的基准值 
     * @param regularTime   定长的时间间隔(年、月、日、时、分、秒等) 
     * @param sampleNum  生成的数据点个数 
     */  
    public static void setSeriesData(TimeSeries series, double baseData, RegularTimePeriod regularTime, int sampleNum) {  
        // 生成随机模拟数据  
        double value = baseData;  
        for (int i = 0; i < sampleNum; i++) {  
            series.add(regularTime, value);       
            regularTime = regularTime.next();   //自动定位到下一个时间点  
            value *= (1.0D + (Math.random() - 0.495D) / 4.0D);  
        }  
    }  
    public static JFreeChart getJfreeChart(String sSql,Transaction Sqlca) throws Exception{
    	//获取数据
    	HashSet<String> lines=new HashSet<String>();
		// 创建柱状数据对象
		DefaultCategoryDataset PD = new DefaultCategoryDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// 添加数据
		while(rs.next()){
			String linelable=rs.getString(2);
			PD.setValue(rs.getDouble(1), linelable,rs.getString(3));
			lines.add(linelable);			
		}
		rs.getStatement().close();
    	JFreeChart jf =ChartFactory.createLineChart("", "", "", PD, PlotOrientation.VERTICAL, true, true, false);
		// 给折线图对象设置样式
		LineChart.setStyle(jf,lines.size());
		return jf;
    }
	/*
	 * 对图表对象设置样式
	 */
	public static void setStyle(JFreeChart chart,int lines){
		// 得到图表标题，并给其设置字体
		chart.getTitle().setFont(new Font("黑体",0,20));
		// 得到图表底部类别，并给其设置字体
		chart.getLegend().setItemFont(new Font("宋体",0,12));
		// 得到折线图样式的样式，用于设置更多的自定义绘制属性        
		CategoryPlot plot = (CategoryPlot)chart.getPlot();
		// 得到Y坐标轴，并且设置说明字体
		plot.getRangeAxis().setLabelFont(new Font("宋体",0,12));
		// 得到Y坐标轴，并且设置坐标字体
		plot.getRangeAxis().setTickLabelFont(new Font("宋体",0,12));
		// 得到X坐标轴，并且设置说明字体
		plot.getDomainAxis().setLabelFont(new Font("宋体",0,12));
		// 得到X坐标轴，并且设置坐标字体
		plot.getDomainAxis().setTickLabelFont(new Font("宋体",0,12));
		
		GradientPaint bg = new GradientPaint(0, 50, new Color(248, 253, 255),0, 250, new Color(205, 237, 252));  
		plot.setBackgroundPaint(bg); 
		plot.setDomainGridlinePaint(Color.BLACK);  
		plot.setDomainGridlinesVisible(true);   
		plot.setRangeGridlinePaint(Color.RED); 
		//设置网格背景颜色
        plot.setBackgroundPaint(Color.white);
        //设置网格竖线颜色
        plot.setDomainGridlinePaint(Color.pink);
        //设置网格横线颜色
        plot.setRangeGridlinePaint(Color.pink);
        //设置曲线图与xy轴的距离
        plot.setAxisOffset(new RectangleInsets(5D, 0D, 0D, 10D));
		// 设置横轴标题的字体 
		CategoryAxis domainAxis = plot.getDomainAxis(); 
		domainAxis.setLabelFont(new Font("黑体", Font.BOLD, 15)); 
		domainAxis.setMinorTickMarksVisible(true);
		domainAxis.setMinorTickMarkInsideLength(50);//每10个刻度显示一个刻度值
		//domainAxis.setCategoryLabelPositionOffset(10);
		domainAxis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_45);//横轴值的旋转
		// 设置纵轴标题文字的字体及其旋转方向  
		NumberAxis rangeAxis = (NumberAxis)plot.getRangeAxis(); 
		rangeAxis.setLabelFont(new Font("黑体", Font.BOLD, 15)); 
		rangeAxis.setLabelAngle(Math.PI/2);   
		//rangeAxis.setAutoTickUnitSelection(false);
		//double unit=5d;//刻度的长度
		//NumberTickUnit ntu= new NumberTickUnit(unit);
		//rangeAxis.setTickUnit(ntu);
		//rangeAxis.setLowerBound(10);
		//rangeAxis.setAutoRangeMinimumSize(100);//纵轴展示的值得范围
		//rangeAxis.setTickMarksVisible(true);
		//rangeAxis.setTickMarkOutsideLength(30);
		// 获取渲染对象        线和线上标签
		LineAndShapeRenderer lineandshaperenderer = (LineAndShapeRenderer) plot.getRenderer(); 
        //设置曲线是否显示数据点
        lineandshaperenderer.setBaseShapesVisible(true);
        lineandshaperenderer.setItemLabelAnchorOffset(1D);//时间点和数据标签的距离
        //设置数据显示位置
        /**/
		// 自定义线段的绘制颜色
		Color color[] = new Color[5]; 
		color[0] = new Color(99,99,0); 
		color[1] = new Color(33,0,255); 
		color[2] = new Color(255,169,66); 
		color[3] = new Color(255,0,66);  
		color[4] = new Color(33,255, 66); 
		// 自定义线段的绘制风格 
		for (int i = 0; i < lines; i++)  { 
			//设置断线
			if (i % 3 == 0){   
				lineandshaperenderer.setSeriesStroke(i,new BasicStroke(2.0f)); //
				lineandshaperenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE1, TextAnchor.TOP_LEFT)); 
				lineandshaperenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
				lineandshaperenderer.setSeriesItemLabelsVisible(i, true);
				lineandshaperenderer.setSeriesItemLabelFont(i, new Font("黑体", Font.BOLD,12));
			}else if (i % 3 == 1){   
				lineandshaperenderer.setSeriesStroke(i,new BasicStroke(2.0f)); //
				lineandshaperenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE1, TextAnchor.BOTTOM_LEFT)); 
				lineandshaperenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
				lineandshaperenderer.setSeriesItemLabelsVisible(i, true);
				lineandshaperenderer.setSeriesItemLabelFont(i, new Font("黑体", Font.ITALIC,12));
			}else{   
				lineandshaperenderer.setSeriesStroke(i, new BasicStroke(2.0f,BasicStroke.CAP_ROUND,BasicStroke.JOIN_ROUND,10.f,new float[]{20F, 6F},0.0f));  //虚线  线长度：20F, 缺口长度6F,线长度：20F, 缺口长度6F...
				lineandshaperenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE1, TextAnchor.BOTTOM_RIGHT)); 
				lineandshaperenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
				lineandshaperenderer.setSeriesItemLabelsVisible(i, true);
				lineandshaperenderer.setSeriesItemLabelFont(i, new Font("楷体", Font.CENTER_BASELINE,12));
			}
		}        
		// 结束自定义图表绘制的相关属性    
		//ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());  
		// 设置图片生成格式       
		//String fileName =      ServletUtilities.saveChartAsPNG(chart, width, height, info, session);        
		// 设置图片生成路径  
		//String graphURL =      request.getContextPath() + "/servlet/DisplayChart?filename=" + fileName; 
	}
	 /** 
     * 创建jfreechart图表 
     * */  
    public static JFreeChart createChart(String sSql,Transaction Sqlca) {  
        // 生成图表数据集合  
        XYDataset xyDataset=null;
		try {
			//xyDataset = (XYDataset) getDataSet(sSql,Sqlca);
			xyDataset = createDataset(sSql,Sqlca);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}   
        // 增加汉字支持  
        StandardChartTheme standardChartTheme=new StandardChartTheme("CN");     //创建主题样式            
        standardChartTheme.setExtraLargeFont(new Font("隶书",Font.BOLD,20));    //设置标题字体         
        standardChartTheme.setRegularFont(new Font("SimSun",Font.PLAIN,15));    //设置图例的字体      
        standardChartTheme.setLargeFont(new Font("宋体",Font.PLAIN,15));      //设置轴向的字体     
        //设置网格背景颜色    
        //standardChartTheme.setBaselinePaint(Color.WHITE); 
        //设置网格竖线颜色   
        //standardChartTheme.setDomainGridlinePaint(Color.blue);
        //设置网格横线颜色   
        standardChartTheme.setRangeGridlinePaint(Color.green);
        standardChartTheme.setAxisOffset(new RectangleInsets(0D, 1D, 0D, 30D));
        ChartFactory.setChartTheme(standardChartTheme); //应用主题样式      
          
        // 创建一个时间序列图表的JFreeChart  
        JFreeChart jFreeChart = ChartFactory.createTimeSeriesChart(  
                "折线图展示",   // 图表名  
                "时间",               // 横轴标签文字  
                "数值",               // 纵轴标签文字  
                xyDataset,          // 图表的数据集合  
                true,               // 是否显示图表中每条数据序列的说明  
                false,              // 是否显示工具提示  
                false);             // 是否显示图表中设置的url网络连接  
      
        // XYPlot图表区域的设置对象,用来设置图表的一些显示属性  
        XYPlot xyPlot = (XYPlot) jFreeChart.getPlot();    
 	 		
     // 获取渲染对象    
        // 设置数据点和序列线的显示格式  
        XYItemRenderer item = xyPlot.getRenderer();
        if (item instanceof XYLineAndShapeRenderer) {  
            XYLineAndShapeRenderer renderer = (XYLineAndShapeRenderer) item;  
            renderer.setBaseShapesVisible(true);    // 数据点显示外框  
            renderer.setBaseShapesFilled(true); // 数据点外框内填充  
            
        }  
         //设置曲线显示各数据点的值
         //设置曲线是否显示数据点
         //item.setBaseSeriesVisible(true);
         //设置数据显示位置
         item.setBaseItemLabelsVisible(true);
         item.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_LEFT));
         //item.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER));
         //下面三句是对设置折线图数据标示的关键代码
         item.setBaseItemLabelGenerator(new StandardXYItemLabelGenerator());
         item.setBaseItemLabelFont(new Font("Dialog", 1, 14));
         xyPlot.setRenderer(item);
          
         ///////////////////////////////  新功能点 /////////////////////////////////////////    
        // 自定义新的时间轴，用于显示多重时间标签  
        PeriodAxis periodAxis = new PeriodAxis("时间");   // 自定义X时间轴  
        periodAxis.setTimeZone(TimeZone.getDefault());  // 使用默认时区  
        periodAxis.setAutoRangeTimePeriodClass(Month.class); // 设置该时间轴默认自动增长时间单位为月 天 Day.class
        // 设置不同重的时间显示格式  
        PeriodAxisLabelInfo[] arrayOfPeriodAxisLabelInfo = new PeriodAxisLabelInfo[2];  
        //arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Day.class, new SimpleDateFormat("dd")); // 第一行显示天  
        arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Month.class, new SimpleDateFormat("MM"), new RectangleInsets(2.0D,2.0D,2.0D,2.0D), new Font("SansSerif", 1, 10), Color.blue, false, new BasicStroke(5.0F), Color.lightGray); // 第二行显示月  
       // arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Month.class, new SimpleDateFormat("MM"));
        arrayOfPeriodAxisLabelInfo[1] = new PeriodAxisLabelInfo(Year.class, new SimpleDateFormat("yyyy")); // 第三行显示年  
        periodAxis.setLabelInfo(arrayOfPeriodAxisLabelInfo); // 设置时间轴上的时间显示格式  
        xyPlot.setDomainAxis(periodAxis);   // 设置X时间轴  
        
        ChartUtilities.applyCurrentTheme(jFreeChart); // 使用当前主题  
          
        //setStyle(jFreeChart);
        return jFreeChart;  
    }  
	/*
	 * 生成图片
	 */
	public static void 生成图片(String 文件地址,JFreeChart 图表,int 宽度,int 高度){
		try {
			// 使用图表工具保存文件
			ChartUtilities.saveChartAsJPEG(new File(文件地址),图表,宽度 ,高度);
		}catch (IOException e) {
			e.printStackTrace();
		}
	}
}
