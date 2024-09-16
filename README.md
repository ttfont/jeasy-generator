# jeasy-generator源码生成插件
jeasy-generator以mybatis-generator为基础扩展插件，目前扩展了分页插件和模板插件
## test包中的代码结构，可以直接运行测试
![test包结构](https://github.com/ttfont/jeasy-generator/blob/master/test%E5%8C%85%E4%B8%AD%E7%9A%84%E4%BB%A3%E7%A0%81%E7%BB%93%E6%9E%84.png)

## 分页插件使用
在mybatisGenerator.xml中引入以下扩展
```
<plugin type="xin.jeasy.mybatis.generator.plugin.LimitForMysqlPagePlugin"/>
```
便可以生成形如如下的SQL，符合SQL规范
```
select
	t.*
from
	(
		select
			id
		from
			member t
		where
			thread_id = 771025
		and deleted = 0
		order by
			gmt_create asc
		limit 0,
		15
	) a,
	t
where
	a.id = t.id
```
## 模板插件使用
它是基于freemarker模板实现，结合mybatis-generator代码生成工具
在mybatisGenerator.xml中配置如下信息
```
      <plugin type="xin.jeasy.mybatis.generator.plugin.TemplateFilePlugin">
            <property name="targetProject" value="src/test/java"/>
            <property name="targetPackage" value="xin.jeasy.mybatis.generator.tests.web.controller"/>
            <property name="templatePath" value="templates/controller.ftl"/>
            <property name="templateFormatter" value="xin.jeasy.mybatis.generator.format.FreemarkerTemplateFormatter"/>
            <property name="mapperSuffix" value="Controller"/>
            <property name="projectPackage" value="xin.jeasy.mybatis.generator.tests"/>
            <property name="fileName" value="${tableClass.shortClassName}${mapperSuffix}.java"/>
        </plugin>
```
比如模板为 controller.ftl
```
<#assign dateTime = .now>
package ${package};

import java.util.List;
import java.util.ArrayList;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import ${projectPackage}.service.${tableClass.shortClassName}Service;
import ${projectPackage}.pojo.${tableClass.shortClassName};
import xin.jeasy.commons.utils2.collection.ListUtil;
import xin.jeasy.commons.beans.page.PageListResult;
import xin.jeasy.commons.beans.page.Pagenation;
import xin.jeasy.commons.beans.page.PageView;
import xin.jeasy.commons.beans.page.PagingQuery;
import xin.jeasy.commons.beans.vo.ResponseVo;
import xin.jeasy.commons.beans.controller.BaseController;


/**
 * ${tableClass.shortClassName}${mapperSuffix}
 *
 * @mbg.generated
 * @author 
 * @since ${dateTime?date}
 */
@Controller
@RequestMapping("/${tableClass.variableName?lower_case}")
public class ${tableClass.shortClassName}${mapperSuffix} extends BaseController {
	private static final Logger LOG = LoggerFactory.getLogger(${tableClass.shortClassName}${mapperSuffix}.class);

	@Autowired
	private ${tableClass.shortClassName}Service ${tableClass.variableName}Service;

	@RequestMapping(value = "/list")
	@ResponseBody
	public PageView<${tableClass.shortClassName}> list(PagingQuery<${tableClass.shortClassName}> record, Integer page, Integer rows) {
		LOG.info("list?record={}", record.toString());
		PageView<${tableClass.shortClassName}> pageView = null;
		record.setPageNo(page == null ? 1 : page);
		record.setPageSize(rows == null ? 10 : rows);
		PageListResult<${tableClass.shortClassName}> rs = ${tableClass.variableName}Service.selectByExampleWithLimit(record);
		Pagenation pg = rs.getPagenation();
		List<${tableClass.shortClassName}> list = null;
		if (ListUtil.isNotEmpty(rs.getValues())) {
			list = rs.getValues();
		} else {
			list = new ArrayList<>();
		}
		pageView = new PageView<${tableClass.shortClassName}>(list, pg);
		return pageView;
	}

}
```
它会生成对应的controller类，controller名称为数据库表名和Controller的组合，比如表名为test，则类名为TestController
```
package xin.jeasy.mybatis.generator.tests.web.controller;

import java.util.List;
import java.util.ArrayList;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import xin.jeasy.mybatis.generator.tests.service.TestMemberMergeLogService;
import xin.jeasy.mybatis.generator.tests.pojo.TestMemberMergeLog;
import xin.jeasy.commons.utils2.collection.ListUtil;
import xin.jeasy.commons.beans.page.PageListResult;
import xin.jeasy.commons.beans.page.Pagenation;
import xin.jeasy.commons.beans.page.PageView;
import xin.jeasy.commons.beans.page.PagingQuery;
import xin.jeasy.commons.beans.vo.ResponseVo;
import xin.jeasy.commons.beans.controller.BaseController;


/**
 * TestMemberMergeLogController
 *
 * @mbg.generated
 * @author 
 * @since 2018-9-29
 */
@Controller
@RequestMapping("/testmembermergelog")
public class TestMemberMergeLogController extends BaseController {
	private static final Logger LOG = LoggerFactory.getLogger(TestMemberMergeLogController.class);

	@Autowired
	private TestMemberMergeLogService TestMemberMergeLogService;

	@RequestMapping(value = "/list")
	@ResponseBody
	public PageView<TestMemberMergeLog> list(PagingQuery<TestMemberMergeLog> record, Integer page, Integer rows) {
		LOG.info("list?record={}", record.toString());
		PageView<TestMemberMergeLog> pageView = null;
		record.setPageNo(page == null ? 1 : page);
		record.setPageSize(rows == null ? 10 : rows);
		PageListResult<TestMemberMergeLog> rs = TestMemberMergeLogService.selectByExampleWithLimit(record);
		Pagenation pg = rs.getPagenation();
		List<TestMemberMergeLog> list = null;
		if (ListUtil.isNotEmpty(rs.getValues())) {
			list = rs.getValues();
		} else {
			list = new ArrayList<>();
		}
		pageView = new PageView<TestMemberMergeLog>(list, pg);
		return pageView;
	}

}

```
