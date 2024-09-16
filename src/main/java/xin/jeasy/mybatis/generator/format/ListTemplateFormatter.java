package xin.jeasy.mybatis.generator.format;

import java.util.Properties;
import java.util.Set;

import xin.jeasy.mybatis.generator.model.TableClass;

/**
 *
 */
public interface ListTemplateFormatter {

    /**
     * 获取根据模板生成的数据
     *
     * @param tableClassSet
     * @param properties
     * @param targetPackage
     * @param templateContent
     * @return
     */
    String getFormattedContent(Set<TableClass> tableClassSet, Properties properties, String targetPackage,
                               String templateContent);
}
