package xin.jeasy.mybatis.generator.format;

import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import xin.jeasy.mybatis.generator.model.TableClass;

import freemarker.cache.StringTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;

/**
 * 基于 freemarker 的实现
 *
 */
public class FreemarkerTemplateFormatter implements TemplateFormatter, ListTemplateFormatter {
	private final Configuration configuration = new Configuration(Configuration.VERSION_2_3_23);
	private final StringTemplateLoader templateLoader = new StringTemplateLoader();

	public FreemarkerTemplateFormatter() {
		configuration.setLocale(Locale.CHINA);
		configuration.setDefaultEncoding("UTF-8");
		configuration.setTemplateLoader(templateLoader);
		configuration.setObjectWrapper(new DefaultObjectWrapper(Configuration.VERSION_2_3_23));
	}

	/**
	 * 根据模板处理
	 *
	 * @param templateName
	 * @param templateSource
	 * @param params
	 * @return
	 */
	public String process(String templateName, String templateSource, Map<String, Object> params) {
		try {
			Template template = new Template(templateName, templateSource, configuration);
			Writer writer = new StringWriter();
			template.process(params, writer);
			return writer.toString();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	public String getFormattedContent(TableClass tableClass, Properties properties, String targetPackage,
			String templateContent) {
		Map<String, Object> params = new HashMap<String, Object>();
		for (Object o : properties.keySet()) {
			params.put(String.valueOf(o), properties.get(o));
		}
		params.put("props", properties);
		params.put("package", targetPackage);
		params.put("tableClass", tableClass);

		// zhuxiaoyu added 20180322 begin
		/*
		 * List<String> uFieldNames = new ArrayList<>(); List<String> fieldNames = new
		 * ArrayList<>(); tableClass.getBaseFields().forEach((columnField) -> { String
		 * str = columnField.getFieldName(); fieldNames.add(str);
		 * str.replace(str.substring(0, 1), str.substring(0, 1).toUpperCase());
		 * uFieldNames.add(str); }); params.put("uFieldNames", uFieldNames);
		 * params.put("fieldNames", fieldNames);
		 */
		// end
		return process(properties.getProperty("templatePath"), templateContent, params);
	}

	@Override
	public String getFormattedContent(Set<TableClass> tableClassSet, Properties properties, String targetPackage,
			String templateContent) {
		Map<String, Object> params = new HashMap<String, Object>();
		for (Object o : properties.keySet()) {
			params.put(String.valueOf(o), properties.get(o));
		}
		params.put("props", properties);
		params.put("package", targetPackage);
		params.put("tableClassSet", tableClassSet);
		return process(properties.getProperty("templatePath"), templateContent, params);
	}
}
