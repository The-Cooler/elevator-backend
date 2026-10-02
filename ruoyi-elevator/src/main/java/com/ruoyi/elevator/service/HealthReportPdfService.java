package com.ruoyi.elevator.service;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.ruoyi.elevator.domain.ElevatorHealth;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.awt.Color;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * 电梯健康评分报告 PDF 导出服务
 * 使用 OpenPDF 生成中文 PDF，字体从系统字体目录加载，避免中文乱码
 *
 * @author 董泽晟
 */
@Service
public class HealthReportPdfService
{
    private static final Logger log = LoggerFactory.getLogger(HealthReportPdfService.class);

    /** 中文字体候选路径，按顺序尝试 */
    private static final String[] FONT_PATHS = {
            "C:/Windows/Fonts/simsun.ttc,0",
            "C:/Windows/Fonts/simhei.ttf",
            "C:/Windows/Fonts/msyh.ttc,0",
            "/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc,0",
            "/usr/share/fonts/truetype/arphic/uming.ttc,0"
    };

    private static final Color HEAD_BG = new Color(11, 61, 145);

    private static final Color LIGHT_BG = new Color(245, 247, 250);

    /**
     * 导出健康评分报告为 PDF
     *
     * @param health 健康评分数据
     * @param response 响应对象
     * @param fileName 下载文件名，不含扩展名
     */
    public void export(ElevatorHealth health, HttpServletResponse response, String fileName)
    {
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        try
        {
            setupResponse(response, fileName);
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(document, out);
            document.open();

            BaseFont baseFont = loadChineseFont();
            Font titleFont = new Font(baseFont, 18, Font.BOLD, HEAD_BG);
            Font headFont = new Font(baseFont, 12, Font.BOLD, Color.WHITE);
            Font labelFont = new Font(baseFont, 11, Font.BOLD, Color.DARK_GRAY);
            Font bodyFont = new Font(baseFont, 11, Font.NORMAL, Color.BLACK);

            // 标题
            Paragraph title = new Paragraph("电梯健康评分报告", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // 基本信息
            document.add(sectionTitle("一、电梯基本信息", baseFont));
            PdfPTable infoTable = new PdfPTable(new float[] { 1, 2, 1, 2 });
            infoTable.setWidthPercentage(100);
            addRow(infoTable, "电梯编号", nullToDash(health.getElevatorCode()), "品牌", nullToDash(health.getBrand()), labelFont, bodyFont);
            addRow(infoTable, "所在小区", nullToDash(health.getCommunityName()), "楼栋单元",
                    nullToDash(health.getBuildingNo()) + " " + nullToDash(health.getUnitNo()), labelFont, bodyFont);
            addRow(infoTable, "统计周期", nullToDash(health.getStatPeriod()), "计算时间", nullToDash(health.getCalcTime()), labelFont, bodyFont);
            document.add(infoTable);
            document.add(spacer());

            // 评分总览
            document.add(sectionTitle("二、健康评分总览", baseFont));
            PdfPTable scoreTable = new PdfPTable(new float[] { 1, 1 });
            scoreTable.setWidthPercentage(100);
            addRow(scoreTable, "健康评分", nullToDash(health.getHealthScore()), "健康等级",
                    nullToDash(health.getHealthLevelName()), labelFont, bodyFont);
            document.add(scoreTable);
            document.add(spacer());

            // 指标构成明细
            document.add(sectionTitle("三、指标构成明细", baseFont));
            PdfPTable detailTable = new PdfPTable(new float[] { 1.2f, 2.6f, 1, 1, 1 });
            detailTable.setWidthPercentage(100);
            addHeaderCell(detailTable, "指标", headFont);
            addHeaderCell(detailTable, "原始数据", headFont);
            addHeaderCell(detailTable, "折算得分", headFont);
            addHeaderCell(detailTable, "权重", headFont);
            addHeaderCell(detailTable, "加权得分", headFont);

            addBodyRow(detailTable,
                    new String[] { "故障率",
                            "统计周期内故障 " + nullToZero(health.getFaultCount()) + " 次",
                            nullToDash(health.getFaultScore()), "40%",
                            weighted(health.getFaultScore(), 0.4) },
                    bodyFont);
            addBodyRow(detailTable,
                    new String[] { "维保完成率",
                            "应执行 " + nullToZero(health.getMaintainDone()) + " 次，实际执行 " + nullToZero(health.getMaintainFinish()) + " 次",
                            nullToDash(health.getMaintainRate()) + "%", "30%",
                            weighted(health.getMaintainRate(), 0.3) },
                    bodyFont);
            addBodyRow(detailTable,
                    new String[] { "巡检合格率",
                            "检查项 " + nullToZero(health.getInspectTotal()) + " 项，正常 " + nullToZero(health.getInspectNormal()) + " 项",
                            nullToDash(health.getInspectRate()) + "%", "30%",
                            weighted(health.getInspectRate(), 0.3) },
                    bodyFont);
            document.add(detailTable);
            document.add(spacer());

            // 维护建议
            document.add(sectionTitle("四、维护建议", baseFont));
            Paragraph suggestion = new Paragraph(nullToDash(health.getSuggestion()), bodyFont);
            suggestion.setLeading(20);
            document.add(suggestion);
            document.add(spacer());

            // 评分模型说明
            document.add(sectionTitle("五、评分模型说明", baseFont));
            Paragraph model = new Paragraph(
                    "健康评分 = 故障率得分 × 40% + 维保完成率得分 × 30% + 巡检合格率得分 × 30%。\n"
                            + "故障率得分：统计周期内无故障得 100 分，每发生 1 次故障扣 10 分，紧急故障额外扣 5 分，下限 0 分。\n"
                            + "健康等级：90 分及以上优秀，80-89 良好，70-79 一般，60-69 较差，60 分以下危险。",
                    bodyFont);
            model.setLeading(20);
            document.add(model);

            document.close();
            log.info("健康评分报告 PDF 导出完成，电梯ID={}", health.getElevatorId());
        }
        catch (Exception e)
        {
            log.error("健康评分报告 PDF 导出失败", e);
            throw new com.ruoyi.elevator.exception.ElevatorException("PDF 报告生成失败：" + e.getMessage());
        }
    }

    /**
     * 设置下载响应头
     */
    private void setupResponse(HttpServletResponse response, String fileName) throws Exception
    {
        response.reset();
        response.setContentType("application/pdf");
        response.setCharacterEncoding("UTF-8");
        String encoded = URLEncoder.encode(fileName + ".pdf", StandardCharsets.UTF_8.name())
                .replaceAll("\\+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);
    }

    /**
     * 加载中文字体，确保 PDF 中文正常显示
     */
    private BaseFont loadChineseFont()
    {
        for (String path : FONT_PATHS)
        {
            try
            {
                return BaseFont.createFont(path, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            }
            catch (Exception ignored)
            {
                // 该字体不存在或无权限，继续尝试下一个
            }
        }
        log.warn("未找到可用中文字体，PDF 中文可能显示为方块，请确认系统字体目录");
        try
        {
            return BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, BaseFont.NOT_EMBEDDED);
        }
        catch (Exception e)
        {
            throw new com.ruoyi.elevator.exception.ElevatorException("PDF 字体初始化失败");
        }
    }

    private Paragraph sectionTitle(String text, BaseFont baseFont)
    {
        Paragraph p = new Paragraph(text, new Font(baseFont, 13, Font.BOLD, HEAD_BG));
        p.setSpacingBefore(6);
        p.setSpacingAfter(10);
        return p;
    }

    private Paragraph spacer()
    {
        Paragraph p = new Paragraph(" ");
        p.setSpacingAfter(4);
        return p;
    }

    private void addRow(PdfPTable table, String label1, String value1, String label2, String value2,
                        Font labelFont, Font bodyFont)
    {
        table.addCell(labelCell(label1, labelFont));
        table.addCell(bodyCell(value1, bodyFont));
        table.addCell(labelCell(label2, labelFont));
        table.addCell(bodyCell(value2, bodyFont));
    }

    private PdfPCell labelCell(String text, Font font)
    {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBackgroundColor(LIGHT_BG);
        cell.setPadding(8);
        cell.setBorderColor(Color.LIGHT_GRAY);
        return cell;
    }

    private PdfPCell bodyCell(String text, Font font)
    {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setPadding(8);
        cell.setBorderColor(Color.LIGHT_GRAY);
        return cell;
    }

    private void addHeaderCell(PdfPTable table, String text, Font font)
    {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBackgroundColor(HEAD_BG);
        cell.setPadding(8);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setBorderColor(Color.LIGHT_GRAY);
        table.addCell(cell);
    }

    private void addBodyRow(PdfPTable table, String[] values, Font font)
    {
        for (String value : values)
        {
            PdfPCell cell = new PdfPCell(new Phrase(value, font));
            cell.setPadding(8);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setBorderColor(Color.LIGHT_GRAY);
            table.addCell(cell);
        }
    }

    /** 计算加权得分，保留两位小数 */
    private String weighted(java.math.BigDecimal score, double weight)
    {
        if (score == null)
        {
            return "0.00";
        }
        return score.multiply(java.math.BigDecimal.valueOf(weight))
                .setScale(2, java.math.RoundingMode.HALF_UP).toPlainString();
    }

    private String nullToDash(Object value)
    {
        return value == null ? "—" : String.valueOf(value);
    }

    private String nullToZero(Object value)
    {
        return value == null ? "0" : String.valueOf(value);
    }
}
