# 探索 Jeasy-Generator：自定义代码生成的强大插件

 Jeasy-Generator 是基于 Mybatis Generator 的扩展插件，旨在提高开发效率并优化代码结构。该插件增加了分页和模板功能，允许用户通过配置文件和模板自定义生成的代码，满足特定的项目需求。使用 Jeasy-Generator，开发者可以快速生成整洁、可维护的代码框架，包括控制器、服务层和数据访问层等。此外，它支持自定义 SQL 分页查询，使得数据处理更为高效。源码已开源于 GitHub，供广大开发者学习和改进。此工具不仅提升了开发效率，也确保了项目的可扩展性和可维护性。

### 一 代码生成插件简介

 Jeasy-Generator 以 Mybatis Generator 为基础扩展插件，目前扩展了分页插件和模板插件，源码地址：[GitHub](https://github.com/ttfont/jeasy-generator)

### 二 生成测试包的代码结构

生成的代码可以直接运行测试，生成测试包的代码结构如下

![代码结构](https://github.com/ttfont/jeasy-generator/blob/master/test%E5%8C%85%E4%B8%AD%E7%9A%84%E4%BB%A3%E7%A0%81%E7%BB%93%E6%9E%84.png)

### 三 自定义分页插件使用
在 `mybatisGenerator.xml` 中引入以下扩展
```xml
<plugin type="xin.jeasy.mybatis.generator.plugin.LimitForMysqlPagePlugin"/>
```
在 `xml` 文件中生成的 `sql` 呈现形式如下
```sql
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
### 四 自定义模板插件使用
模板插件是使用 FreeMarker 模板引擎和 Mybatis-Generator-Core 代码生成工具实现。配置信息如下

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
可在 mybatisGenerator.xml 文件中查看，示例模板 controller.ftl 如下
```nginx
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
运行 Jeasy-Generator 会生成对应的 Controller，Controller 中名称为数据库表名 和 Controller 的拼接组合，比如表名为 test，则类名为 TestController
```java
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

import xin.jeasy.mybatis.generator.tests.service.yourTestMemberMergeLogService;
import xin.jeasy.mybatis.generator.tests.pojo.yourTestMemberMergeLog;
import xin.jeasy.commons.utils2.collection.ListUtil;
import xin.jeasy.commons.beans.page.PageListResult;
import xin.jeasy.commons.beans.page.Pagenation;
import xin.jeasy.commons.beans.page.PageView;
import xin.jeasy.commons.beans.page.PagingQuery;
import xin.jeasy.commons.beans.vo.ResponseVo;
import xin.jeasy.commons.beans.controller.BaseController;


/**
 * yourTestMemberMergeLogController
 *
 * @mbg.generated
 * @author 
 * @since 2018-9-29
 */
@Controller
@RequestMapping("/yourtestmembermergelog")
public class yourTestMemberMergeLogController extends BaseController {
	private static final Logger LOG = LoggerFactory.getLogger(yourTestMemberMergeLogController.class);

	@Autowired
	private yourTestMemberMergeLogService yourTestMemberMergeLogService;

	@RequestMapping(value = "/list")
	@ResponseBody
	public PageView<yourTestMemberMergeLog> list(PagingQuery<yourTestMemberMergeLog> record, Integer page, Integer rows) {
		LOG.info("list?record={}", record.toString());
		PageView<yourTestMemberMergeLog> pageView = null;
		record.setPageNo(page == null ? 1 : page);
		record.setPageSize(rows == null ? 10 : rows);
		PageListResult<yourTestMemberMergeLog> rs = yourTestMemberMergeLogService.selectByExampleWithLimit(record);
		Pagenation pg = rs.getPagenation();
		List<yourTestMemberMergeLog> list = null;
		if (ListUtil.isNotEmpty(rs.getValues())) {
			list = rs.getValues();
		} else {
			list = new ArrayList<>();
		}
		pageView = new PageView<yourTestMemberMergeLog>(list, pg);
		return pageView;
	}

}

```

### 五 源码地址

源码地址：[GitHub](https://github.com/ttfont/jeasy-generator)
