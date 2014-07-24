package com.lmt.app.display;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.Paint;
import java.io.File;
import java.io.IOException;
import java.util.HashSet;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.labels.ItemLabelAnchor;
import org.jfree.chart.labels.ItemLabelPosition;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.BarRenderer3D;
import org.jfree.chart.title.TextTitle;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.ui.TextAnchor;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class BarChart {
	/*
	 * 程序入口
	 */
	public static void main(String[] args) {
		// 创建柱状图对象
		//JFreeChart 柱状图 = ChartFactory.createBarChart3D("水果产量统计", "水果", "产量", 得到数据(), PlotOrientation.VERTICAL, true, true, true);
		// 给柱状图对象设置样式
		//setStyle(柱状图);
		// 对柱状图对象生成图片
		//生成图片("D:\\柱状图.jpg",柱状图,800,600);
	}
	/*
	 * 得到数据
	 */
	public static CategoryDataset getDataSet(String sSql,Transaction Sqlca) throws Exception{
		// 创建柱状数据对象
		DefaultCategoryDataset PD = new DefaultCategoryDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// 添加数据
		while(rs.next()){
			PD.setValue(rs.getDouble(1), rs.getString(2),rs.getString(3));
		}
		// 返回数据
		return PD;
		// 创建折线数据对象
	}
	public static JFreeChart getJfreeChart(String sSql,Transaction Sqlca) throws Exception{
    	//获取数据
    	HashSet<String> bars=new HashSet<String>();
		// 创建柱状数据对象
		DefaultCategoryDataset PD = new DefaultCategoryDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// 添加数据
		while(rs.next()){
			String barlable=rs.getString(2);
			PD.setValue(rs.getDouble(1), barlable,rs.getString(3));
			bars.add(barlable);			
		}
		rs.getStatement().close();
		JFreeChart jf = ChartFactory.createBarChart3D("", "", "", PD, PlotOrientation.VERTICAL, true, true, false);
		// 给柱状图对象设置样式
		BarChart.setStyle(jf,bars.size());
		return jf;
    }
	/*
	 * 对图表对象设置样式
	 */
	public static void setStyle(JFreeChart chart,int bars){
		TextTitle textTitle = chart.getTitle(); 
		// 得到图表标题，并给其设置字体
		//设置标题的字体 
		String fontA = "华文细黑"; 
		String fontB = "黑体"; 
		textTitle.setFont(new Font(fontA,Font.PLAIN,13)); 
		textTitle.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 
		textTitle.setExpandToFitSpace(true); 
		chart.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 

		// 得到图表底部类别，并给其设置字体
		chart.getLegend().setItemFont(new Font("宋体",0,12));
		// 得到柱状图样式的样式
		CategoryPlot plot = (CategoryPlot) chart.getCategoryPlot(); 
        plot.setDomainGridlinePaint(Color.white); 
        plot.setDomainGridlinesVisible(true); 
        plot.setRangeGridlinePaint(Color.black); 
        plot.setBackgroundPaint(Color.decode("#F9E9D2")); 
        // 设置是否有横线 
        plot.setRangeGridlinesVisible(false); 
        NumberAxis numberaxis = (NumberAxis) plot.getRangeAxis(); 
        numberaxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits()); 
        //设置纵坐标名称的字体 
        numberaxis.setLabelFont(new Font(fontA,Font.PLAIN,16)); 
        //设置纵坐标上显示的数字字体 
        numberaxis.setTickLabelFont(new Font("Fixedsys",Font.PLAIN,13)); 
        //设置横坐标名称的字体 
        CategoryAxis categoryaxis = plot.getDomainAxis(); 
        categoryaxis.setLabelFont(new Font(fontA,Font.PLAIN,16)); 
        //设置横坐标上显示各个业务子项的字体 
        categoryaxis.setTickLabelFont(new Font(fontA,Font.PLAIN,12)); 
        categoryaxis.setMaximumCategoryLabelLines(100); 
        categoryaxis.setMaximumCategoryLabelWidthRatio(100); 
        //横坐标数据倾斜45度 
        categoryaxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45); 
        // 顶端设置 
        numberaxis.setUpperMargin(0.14999999999999999D); 
        // 设置颜色 
        
        BarRenderer3D customBarRenderer = (BarRenderer3D) plot.getRenderer(); 
        //customBarRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());//显示每个柱的数值 
        //customBarRenderer.setBaseItemLabelsVisible(true); 
        //注意：此句很关键，若无此句，那数字的显示会被覆盖，给人数字没有显示出来的问题 
        //customBarRenderer.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER)); 
        customBarRenderer.setBaseOutlinePaint(Color.BLACK);//边框为黑色
        customBarRenderer.setItemLabelAnchorOffset(30D);// 设置柱形图上的文字偏离值 
        //设定柱子上面的颜色 
        // 自定义线段的绘制颜色
 		Color color[] = new Color[7]; 
 		color[0] = Color.decode("#24F4DB"); 
 		color[1] = Color.decode("#7979FF"); 
 		color[2] = Color.decode("#FF5555"); 
 		color[3] = Color.decode("#F8D661");  
 		color[4] = Color.decode("#F284DC"); 
 		color[5] = Color.decode("#00BF00"); 
 		color[6] = new Color(33,255, 66); 
 		// 自定义线段的绘制风格 
 		for (int i = 0; i < bars; i++)  { 
 			int colorN=i%2;
 			Color co=color[colorN];
 			//设置断线
 			if(colorN == 1){   
 				customBarRenderer.setSeriesItemLabelGenerator(i, new StandardCategoryItemLabelGenerator());
 				customBarRenderer.setSeriesItemLabelsVisible(i, true);
 				customBarRenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.OUTSIDE1, TextAnchor.BOTTOM_CENTER)); 
 				customBarRenderer.setSeriesItemLabelFont(i, new Font("黑体", Font.BOLD,12));
 			}else{   
 				customBarRenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.TOP_CENTER)); 
 				customBarRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
 				customBarRenderer.setSeriesItemLabelsVisible(i, true);
 				customBarRenderer.setSeriesItemLabelFont(i, new Font("楷体", Font.ITALIC,12));
 			}
 		}  
        //设置柱子的最大宽度 
        customBarRenderer.setMaximumBarWidth(0.04); 
        customBarRenderer.setItemMargin(0.000000005); 
        plot.setRenderer(customBarRenderer); 
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
