package xin.jeasy.mybatis.generator.format;

import java.util.Properties;

import xin.jeasy.mybatis.generator.model.TableClass;

/**
 *
 */
public interface TemplateFormatter {

    /**
     * 获取根据模板生成的数据
     *
     * @param tableClass
     * @param properties
     * @param targetPackage
     * @param templateContent
     * @return
     */
    String getFormattedContent(TableClass tableClass, Properties properties, String targetPackage,
                               String templateContent);
}
