package xin.jeasy.mybatis.generator.tests;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.Configuration;
import org.mybatis.generator.config.xml.ConfigurationParser;
import org.mybatis.generator.internal.DefaultShellCallback;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.io.Resources;

import ch.qos.logback.classic.LoggerContext;
import ch.qos.logback.classic.joran.JoranConfigurator;
import ch.qos.logback.core.joran.spi.JoranException;

/**
 * @author generator
 *
 */
public class MySQLLimitPluginTests {

	static {
		// String logbackXml = "/Users/your/Documents/openSource/jeasy-generator/src/test/resources";
		LoggerContext lc = (LoggerContext) LoggerFactory.getILoggerFactory();
		JoranConfigurator configurator = new JoranConfigurator();
		configurator.setContext(lc);
		lc.reset();
//		try {
//			configurator.doConfigure(logbackXml);// 加载logback配置文件
//		} catch (JoranException e) {
//			e.printStackTrace();
//		}
		// PropertyConfigurator.configure("/home/lhy/Workspaces/MyEclipse_data/gooddeep/src/main/java/config/log4j.properties");//加载logj配置文件
	}
	private static final Logger LOG = LoggerFactory.getLogger(MySQLLimitPluginTests.class);

	@Test
	public void test01() {
		LOG.info("测试 test01");
		try {
			System.out.println("start generator ...");
			List<String> warnings = new ArrayList<>();
			boolean overwrite = true;
			ConfigurationParser cp = new ConfigurationParser(warnings);
			Configuration config = cp.parseConfiguration(Resources.getResource("generatorConfig.xml").openStream());
			DefaultShellCallback callback = new DefaultShellCallback(overwrite);
			MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
			myBatisGenerator.generate(null);
			System.out.println("end generator!");
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}