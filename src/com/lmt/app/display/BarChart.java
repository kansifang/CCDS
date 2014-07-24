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
	 * �������
	 */
	public static void main(String[] args) {
		// ������״ͼ����
		//JFreeChart ��״ͼ = ChartFactory.createBarChart3D("ˮ������ͳ��", "ˮ��", "����", �õ�����(), PlotOrientation.VERTICAL, true, true, true);
		// ����״ͼ����������ʽ
		//setStyle(��״ͼ);
		// ����״ͼ��������ͼƬ
		//����ͼƬ("D:\\��״ͼ.jpg",��״ͼ,800,600);
	}
	/*
	 * �õ�����
	 */
	public static CategoryDataset getDataSet(String sSql,Transaction Sqlca) throws Exception{
		// ������״���ݶ���
		DefaultCategoryDataset PD = new DefaultCategoryDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// �������
		while(rs.next()){
			PD.setValue(rs.getDouble(1), rs.getString(2),rs.getString(3));
		}
		// ��������
		return PD;
		// �����������ݶ���
	}
	public static JFreeChart getJfreeChart(String sSql,Transaction Sqlca) throws Exception{
    	//��ȡ����
    	HashSet<String> bars=new HashSet<String>();
		// ������״���ݶ���
		DefaultCategoryDataset PD = new DefaultCategoryDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// �������
		while(rs.next()){
			String barlable=rs.getString(2);
			PD.setValue(rs.getDouble(1), barlable,rs.getString(3));
			bars.add(barlable);			
		}
		rs.getStatement().close();
		JFreeChart jf = ChartFactory.createBarChart3D("", "", "", PD, PlotOrientation.VERTICAL, true, true, false);
		// ����״ͼ����������ʽ
		BarChart.setStyle(jf,bars.size());
		return jf;
    }
	/*
	 * ��ͼ�����������ʽ
	 */
	public static void setStyle(JFreeChart chart,int bars){
		TextTitle textTitle = chart.getTitle(); 
		// �õ�ͼ����⣬��������������
		//���ñ�������� 
		String fontA = "����ϸ��"; 
		String fontB = "����"; 
		textTitle.setFont(new Font(fontA,Font.PLAIN,13)); 
		textTitle.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 
		textTitle.setExpandToFitSpace(true); 
		chart.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 

		// �õ�ͼ��ײ���𣬲�������������
		chart.getLegend().setItemFont(new Font("����",0,12));
		// �õ���״ͼ��ʽ����ʽ
		CategoryPlot plot = (CategoryPlot) chart.getCategoryPlot(); 
        plot.setDomainGridlinePaint(Color.white); 
        plot.setDomainGridlinesVisible(true); 
        plot.setRangeGridlinePaint(Color.black); 
        plot.setBackgroundPaint(Color.decode("#F9E9D2")); 
        // �����Ƿ��к��� 
        plot.setRangeGridlinesVisible(false); 
        NumberAxis numberaxis = (NumberAxis) plot.getRangeAxis(); 
        numberaxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits()); 
        //�������������Ƶ����� 
        numberaxis.setLabelFont(new Font(fontA,Font.PLAIN,16)); 
        //��������������ʾ���������� 
        numberaxis.setTickLabelFont(new Font("Fixedsys",Font.PLAIN,13)); 
        //���ú��������Ƶ����� 
        CategoryAxis categoryaxis = plot.getDomainAxis(); 
        categoryaxis.setLabelFont(new Font(fontA,Font.PLAIN,16)); 
        //���ú���������ʾ����ҵ����������� 
        categoryaxis.setTickLabelFont(new Font(fontA,Font.PLAIN,12)); 
        categoryaxis.setMaximumCategoryLabelLines(100); 
        categoryaxis.setMaximumCategoryLabelWidthRatio(100); 
        //������������б45�� 
        categoryaxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45); 
        // �������� 
        numberaxis.setUpperMargin(0.14999999999999999D); 
        // ������ɫ 
        
        BarRenderer3D customBarRenderer = (BarRenderer3D) plot.getRenderer(); 
        //customBarRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());//��ʾÿ��������ֵ 
        //customBarRenderer.setBaseItemLabelsVisible(true); 
        //ע�⣺�˾�ܹؼ������޴˾䣬�����ֵ���ʾ�ᱻ���ǣ���������û����ʾ���������� 
        //customBarRenderer.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER)); 
        customBarRenderer.setBaseOutlinePaint(Color.BLACK);//�߿�Ϊ��ɫ
        customBarRenderer.setItemLabelAnchorOffset(30D);// ��������ͼ�ϵ�����ƫ��ֵ 
        //�趨�����������ɫ 
        // �Զ����߶εĻ�����ɫ
 		Color color[] = new Color[7]; 
 		color[0] = Color.decode("#24F4DB"); 
 		color[1] = Color.decode("#7979FF"); 
 		color[2] = Color.decode("#FF5555"); 
 		color[3] = Color.decode("#F8D661");  
 		color[4] = Color.decode("#F284DC"); 
 		color[5] = Color.decode("#00BF00"); 
 		color[6] = new Color(33,255, 66); 
 		// �Զ����߶εĻ��Ʒ�� 
 		for (int i = 0; i < bars; i++)  { 
 			int colorN=i%2;
 			Color co=color[colorN];
 			//���ö���
 			if(colorN == 1){   
 				customBarRenderer.setSeriesItemLabelGenerator(i, new StandardCategoryItemLabelGenerator());
 				customBarRenderer.setSeriesItemLabelsVisible(i, true);
 				customBarRenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.OUTSIDE1, TextAnchor.BOTTOM_CENTER)); 
 				customBarRenderer.setSeriesItemLabelFont(i, new Font("����", Font.BOLD,12));
 			}else{   
 				customBarRenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.TOP_CENTER)); 
 				customBarRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
 				customBarRenderer.setSeriesItemLabelsVisible(i, true);
 				customBarRenderer.setSeriesItemLabelFont(i, new Font("����", Font.ITALIC,12));
 			}
 		}  
        //�������ӵ������ 
        customBarRenderer.setMaximumBarWidth(0.04); 
        customBarRenderer.setItemMargin(0.000000005); 
        plot.setRenderer(customBarRenderer); 
	}
	/*
	 * ����ͼƬ
	 */
	public static void ����ͼƬ(String �ļ���ַ,JFreeChart ͼ��,int ���,int �߶�){
		try {
			// ʹ��ͼ���߱����ļ�
			ChartUtilities.saveChartAsJPEG(new File(�ļ���ַ),ͼ��,��� ,�߶�);
		}catch (IOException e) {
			e.printStackTrace();
		}
	}
}
