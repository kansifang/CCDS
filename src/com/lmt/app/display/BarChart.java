package com.lmt.app.display;

import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.RenderingHints;
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
		JFreeChart jf = ChartFactory.createBarChart3D("", "", "", PD, PlotOrientation.VERTICAL, true, true, false);//PlotOrientation.HORIZONTAL 表示纵坐标和横坐标互换
		// 给柱状图对象设置样式
		BarChart.setStyle(jf,bars.size());
		return jf;
    }
	/*
	 * 对图表对象设置样式
	 */
	public static void setStyle(JFreeChart chart,int bars){
		chart.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 
		// 得到图表标题，并给其设置字体
		//1、设置标题的字体 
		TextTitle textTitle = chart.getTitle(); 
		String fontA = "宋体"; 
		textTitle.setFont(new Font(fontA,Font.PLAIN,13)); 
		textTitle.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 
		textTitle.setExpandToFitSpace(true); 
		//得到图表底部类别，并给其设置字体
		chart.getLegend().setItemFont(new Font("黑体",0,12));
		chart.getLegend().setVisible(true);//每个条目的说明是否展示（最下面那个）
		//将jfreechart里RenderingHints做文字渲染参数的修改
				//VALUE_TEXT_ANTIALIAS_OFF表示将文字的抗锯齿关闭.
				//使用的关闭抗锯齿后，字体尽量选择12到14号的宋体字。
				//这样文字最清晰好看 
		chart.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_OFF);

		//得到柱状图样式的样式
		CategoryPlot plot = (CategoryPlot) chart.getCategoryPlot(); 
        plot.setBackgroundPaint(new Color(255, 255, 204));    
        //设置柱的透明度
        plot.setForegroundAlpha(0.7f);
        //设置显示位置
        //2、设置纵坐标
        //plot.setRangeAxisLocation(AxisLocation.BOTTOM_OR_RIGHT);
        plot.setRangeGridlinePaint(Color.black); 
        // 设置是否有横线 
        plot.setRangeGridlinesVisible(true); 
        
        NumberAxis rangenumberaxis = (NumberAxis) plot.getRangeAxis(); 
        rangenumberaxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits()); 
        //设置纵坐标名称的字体 
        rangenumberaxis.setLabelFont(new Font(fontA,Font.PLAIN,14)); 
        //设置纵坐标上显示的数字字体 
        rangenumberaxis.setTickLabelFont(new Font(fontA,Font.PLAIN,10)); 
        // 顶端设置 
        rangenumberaxis.setUpperMargin(0.51D); 
        ////2、设置横坐标 
        //plot.setDomainAxisLocation(AxisLocation.TOP_OR_RIGHT);
        plot.setDomainGridlinePaint(Color.white); 
        plot.setDomainGridlinesVisible(true); 
        //设置横坐标名称的字体 
        CategoryAxis domainaxis = plot.getDomainAxis(); 
        domainaxis.setLabelFont(new Font(fontA,Font.PLAIN,14)); 
        //设置横坐标上显示各个业务子项的字体 
        domainaxis.setTickLabelFont(new Font(fontA,Font.HANGING_BASELINE,13)); 
        domainaxis.setMaximumCategoryLabelLines(100); 
        domainaxis.setMaximumCategoryLabelWidthRatio(100); 
        //横坐标数据倾斜45度 
        domainaxis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_45); 
        
        //3、设置图表内容各种属性 
        BarRenderer3D customBarRenderer = (BarRenderer3D) plot.getRenderer(); 
        customBarRenderer.setBaseItemLabelFont(new Font(fontA, Font.PLAIN, 11));
        customBarRenderer.setBaseItemLabelsVisible(true);

        // 避免因为数值过小，显示不明显，或则看不到
        customBarRenderer.setMinimumBarLength(10);

        
        customBarRenderer.setBaseOutlinePaint(Color.BLACK);//边框为黑色
        customBarRenderer.setItemLabelAnchorOffset(0D);// 标签显示与设定位置的距离
        //设置柱子的最大宽度 
        customBarRenderer.setMaximumBarWidth(0.04); 
        //设置柱子上比例数值的显示，如果按照默认方式显示，数值为方向正常显示    
        //设置柱子上显示的数据旋转90度,最后一个参数为旋转的角度值/3.14    
        ItemLabelPosition itemLabelPosition= new ItemLabelPosition(ItemLabelAnchor.INSIDE12,TextAnchor.CENTER_RIGHT,TextAnchor.CENTER_RIGHT,-1.57D);    
        //设置正常显示的柱子label的position    
         customBarRenderer.setPositiveItemLabelPosition(itemLabelPosition);   
         customBarRenderer.setNegativeItemLabelPosition(itemLabelPosition);  
       //下面的设置是为了解决，当柱子的比例过小，而导致表示该柱子比例的数值无法显示的问题    
         //设置不能在柱子上正常显示的那些数值的显示方式，将这些数值显示在柱子外面    
         ItemLabelPosition itemLabelPositionFallback=new ItemLabelPosition(ItemLabelAnchor.INSIDE12,TextAnchor.BASELINE_LEFT,TextAnchor.HALF_ASCENT_LEFT,-1.57D);    
       //设置不能正常显示的柱子label的position   
         customBarRenderer.setPositiveItemLabelPositionFallback(itemLabelPositionFallback);   
         customBarRenderer.setNegativeItemLabelPositionFallback(itemLabelPositionFallback);   
        // 显示每个柱的数值，并修改该数值的字体属性    
         customBarRenderer.setIncludeBaseInRange(true);    
         // 设置每个平行柱之间距离    
         customBarRenderer.setItemMargin(0.1);  
 		// 自定义线段的绘制风格 
 		for (int i = 0; i < bars; i++)  { 
 			int colorN=i%2;
 			//设置断线
 			if(colorN == 1){   
 				customBarRenderer.setSeriesItemLabelGenerator(i, new StandardCategoryItemLabelGenerator());
 				//以下设置，将按照指定格式，制定内容显示每个柱的数值。可以显示柱名称，所占百分比    
 				//customBarRenderer.setSeriesItemLabelGenerator(i,new StandardCategoryItemLabelGenerator("{2}",java.text.NumberFormat.getPercentInstance()));
 				customBarRenderer.setSeriesItemLabelsVisible(i, true);
 				customBarRenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE12, TextAnchor.BOTTOM_CENTER)); 
 				customBarRenderer.setSeriesItemLabelFont(i, new Font("黑体", Font.TRUETYPE_FONT,15));
 			}else{   
 				customBarRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
 				//customBarRenderer.setSeriesItemLabelGenerator(i,new StandardCategoryItemLabelGenerator("{2}",java.text.NumberFormat.getPercentInstance()));
 				customBarRenderer.setSeriesItemLabelsVisible(i, true);
 				customBarRenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE12, TextAnchor.TOP_CENTER)); 
 				customBarRenderer.setSeriesItemLabelFont(i, new Font("黑体", Font.TRUETYPE_FONT,15));
 			}
 		}  
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
