package com.lmt.app.display;

import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.Paint;
import java.io.File;
import java.io.IOException;

import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.labels.ItemLabelAnchor;
import org.jfree.chart.labels.ItemLabelPosition;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
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
	/*
	 * �õ�����
	 */
	public static DefaultCategoryDataset getDataSet(){
		// ������״���ݶ���
		DefaultCategoryDataset ��״���� = new DefaultCategoryDataset();
		// �������
		��״����.addValue(200, "����", "ƻ��");
		��״����.addValue(100, "����", "ƻ��");
		��״����.addValue(200, "�½�", "ƻ��");
		��״����.addValue(50, "����", "�㽶");
		��״����.addValue(30, "����", "�㽶");
		��״����.addValue(10, "�½�", "�㽶");
		��״����.addValue(10, "����", "����");
		��״����.addValue(20, "����", "����");
		��״����.addValue(200, "�½�", "����");
		// ��������
		return ��״����;
	}
	/*
	 * ��ͼ�����������ʽ
	 */
	public static void setStyle(JFreeChart chart){
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
        BarRenderer3D customBarRenderer = (BarRenderer3D) plot.getRenderer(); 
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

        customBarRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());//��ʾÿ��������ֵ 
        customBarRenderer.setBaseItemLabelsVisible(true); 
        //ע�⣺�˾�ܹؼ������޴˾䣬�����ֵ���ʾ�ᱻ���ǣ���������û����ʾ���������� 
        customBarRenderer.setBasePositiveItemLabelPosition(new ItemLabelPosition( 
        ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER)); 
        customBarRenderer.setItemLabelAnchorOffset(10D);// ��������ͼ�ϵ�����ƫ��ֵ 
        customBarRenderer.setItemLabelsVisible(true); 

        //�趨�����������ɫ 
        customBarRenderer.setSeriesPaint(0, Color.decode("#24F4DB")); // ��series1 Bar 
        customBarRenderer.setSeriesPaint(1, Color.decode("#7979FF")); // ��series2 Bar 
        customBarRenderer.setSeriesPaint(2, Color.decode("#FF5555")); // ��series3 Bar 
        customBarRenderer.setSeriesPaint(3, Color.decode("#F8D661")); // ��series4 Bar 
        customBarRenderer.setSeriesPaint(4, Color.decode("#F284DC")); // ��series5 Bar 
        customBarRenderer.setSeriesPaint(5, Color.decode("#00BF00")); // ��series6 Bar 
        customBarRenderer.setSeriesOutlinePaint(0,Color.BLACK);//�߿�Ϊ��ɫ 
        customBarRenderer.setSeriesOutlinePaint(1,Color.BLACK);//�߿�Ϊ��ɫ 
        customBarRenderer.setSeriesOutlinePaint(2,Color.BLACK); //�߿�Ϊ��ɫ 
        customBarRenderer.setSeriesOutlinePaint(3,Color.BLACK);//�߿�Ϊ��ɫ 
        customBarRenderer.setSeriesOutlinePaint(4,Color.BLACK);//�߿�Ϊ��ɫ 
        customBarRenderer.setSeriesOutlinePaint(5,Color.BLACK); //�߿�Ϊ��ɫ 
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
