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
		JFreeChart jf = ChartFactory.createBarChart3D("", "", "", PD, PlotOrientation.VERTICAL, true, true, false);//PlotOrientation.HORIZONTAL ��ʾ������ͺ����껥��
		// ����״ͼ����������ʽ
		BarChart.setStyle(jf,bars.size());
		return jf;
    }
	/*
	 * ��ͼ�����������ʽ
	 */
	public static void setStyle(JFreeChart chart,int bars){
		chart.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 
		// �õ�ͼ����⣬��������������
		//1�����ñ�������� 
		TextTitle textTitle = chart.getTitle(); 
		String fontA = "����"; 
		textTitle.setFont(new Font(fontA,Font.PLAIN,13)); 
		textTitle.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 
		textTitle.setExpandToFitSpace(true); 
		//�õ�ͼ��ײ���𣬲�������������
		chart.getLegend().setItemFont(new Font("����",0,12));
		chart.getLegend().setVisible(true);//ÿ����Ŀ��˵���Ƿ�չʾ���������Ǹ���
		//��jfreechart��RenderingHints��������Ⱦ�������޸�
				//VALUE_TEXT_ANTIALIAS_OFF��ʾ�����ֵĿ���ݹر�.
				//ʹ�õĹرտ���ݺ����御��ѡ��12��14�ŵ������֡�
				//���������������ÿ� 
		chart.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_OFF);

		//�õ���״ͼ��ʽ����ʽ
		CategoryPlot plot = (CategoryPlot) chart.getCategoryPlot(); 
        plot.setBackgroundPaint(new Color(255, 255, 204));    
        //��������͸����
        plot.setForegroundAlpha(0.7f);
        //������ʾλ��
        //2������������
        //plot.setRangeAxisLocation(AxisLocation.BOTTOM_OR_RIGHT);
        plot.setRangeGridlinePaint(Color.black); 
        // �����Ƿ��к��� 
        plot.setRangeGridlinesVisible(true); 
        
        NumberAxis rangenumberaxis = (NumberAxis) plot.getRangeAxis(); 
        rangenumberaxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits()); 
        //�������������Ƶ����� 
        rangenumberaxis.setLabelFont(new Font(fontA,Font.PLAIN,14)); 
        //��������������ʾ���������� 
        rangenumberaxis.setTickLabelFont(new Font(fontA,Font.PLAIN,10)); 
        // �������� 
        rangenumberaxis.setUpperMargin(0.51D); 
        ////2�����ú����� 
        //plot.setDomainAxisLocation(AxisLocation.TOP_OR_RIGHT);
        plot.setDomainGridlinePaint(Color.white); 
        plot.setDomainGridlinesVisible(true); 
        //���ú��������Ƶ����� 
        CategoryAxis domainaxis = plot.getDomainAxis(); 
        domainaxis.setLabelFont(new Font(fontA,Font.PLAIN,14)); 
        //���ú���������ʾ����ҵ����������� 
        domainaxis.setTickLabelFont(new Font(fontA,Font.HANGING_BASELINE,13)); 
        domainaxis.setMaximumCategoryLabelLines(100); 
        domainaxis.setMaximumCategoryLabelWidthRatio(100); 
        //������������б45�� 
        domainaxis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_45); 
        
        //3������ͼ�����ݸ������� 
        BarRenderer3D customBarRenderer = (BarRenderer3D) plot.getRenderer(); 
        customBarRenderer.setBaseItemLabelFont(new Font(fontA, Font.PLAIN, 11));
        customBarRenderer.setBaseItemLabelsVisible(true);

        // ������Ϊ��ֵ��С����ʾ�����ԣ����򿴲���
        customBarRenderer.setMinimumBarLength(10);

        
        customBarRenderer.setBaseOutlinePaint(Color.BLACK);//�߿�Ϊ��ɫ
        customBarRenderer.setItemLabelAnchorOffset(0D);// ��ǩ��ʾ���趨λ�õľ���
        //�������ӵ������ 
        customBarRenderer.setMaximumBarWidth(0.04); 
        //���������ϱ�����ֵ����ʾ���������Ĭ�Ϸ�ʽ��ʾ����ֵΪ����������ʾ    
        //������������ʾ��������ת90��,���һ������Ϊ��ת�ĽǶ�ֵ/3.14    
        ItemLabelPosition itemLabelPosition= new ItemLabelPosition(ItemLabelAnchor.INSIDE12,TextAnchor.CENTER_RIGHT,TextAnchor.CENTER_RIGHT,-1.57D);    
        //����������ʾ������label��position    
         customBarRenderer.setPositiveItemLabelPosition(itemLabelPosition);   
         customBarRenderer.setNegativeItemLabelPosition(itemLabelPosition);  
       //�����������Ϊ�˽���������ӵı�����С�������±�ʾ�����ӱ�������ֵ�޷���ʾ������    
         //���ò�����������������ʾ����Щ��ֵ����ʾ��ʽ������Щ��ֵ��ʾ����������    
         ItemLabelPosition itemLabelPositionFallback=new ItemLabelPosition(ItemLabelAnchor.INSIDE12,TextAnchor.BASELINE_LEFT,TextAnchor.HALF_ASCENT_LEFT,-1.57D);    
       //���ò���������ʾ������label��position   
         customBarRenderer.setPositiveItemLabelPositionFallback(itemLabelPositionFallback);   
         customBarRenderer.setNegativeItemLabelPositionFallback(itemLabelPositionFallback);   
        // ��ʾÿ��������ֵ�����޸ĸ���ֵ����������    
         customBarRenderer.setIncludeBaseInRange(true);    
         // ����ÿ��ƽ����֮�����    
         customBarRenderer.setItemMargin(0.1);  
 		// �Զ����߶εĻ��Ʒ�� 
 		for (int i = 0; i < bars; i++)  { 
 			int colorN=i%2;
 			//���ö���
 			if(colorN == 1){   
 				customBarRenderer.setSeriesItemLabelGenerator(i, new StandardCategoryItemLabelGenerator());
 				//�������ã�������ָ����ʽ���ƶ�������ʾÿ��������ֵ��������ʾ�����ƣ���ռ�ٷֱ�    
 				//customBarRenderer.setSeriesItemLabelGenerator(i,new StandardCategoryItemLabelGenerator("{2}",java.text.NumberFormat.getPercentInstance()));
 				customBarRenderer.setSeriesItemLabelsVisible(i, true);
 				customBarRenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE12, TextAnchor.BOTTOM_CENTER)); 
 				customBarRenderer.setSeriesItemLabelFont(i, new Font("����", Font.TRUETYPE_FONT,15));
 			}else{   
 				customBarRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
 				//customBarRenderer.setSeriesItemLabelGenerator(i,new StandardCategoryItemLabelGenerator("{2}",java.text.NumberFormat.getPercentInstance()));
 				customBarRenderer.setSeriesItemLabelsVisible(i, true);
 				customBarRenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE12, TextAnchor.TOP_CENTER)); 
 				customBarRenderer.setSeriesItemLabelFont(i, new Font("����", Font.TRUETYPE_FONT,15));
 			}
 		}  
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
