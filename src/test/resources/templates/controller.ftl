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
import com.your.commons.utils2.collection.ListUtil;
import com.your.commons.beans.page.PageListResult;
import com.your.commons.beans.page.Pagenation;
import com.your.commons.beans.page.PageView;
import com.your.commons.beans.page.PagingQuery;
import com.your.commons.beans.vo.ResponseVo;
import com.your.commons.beans.controller.BaseController;


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
	
	private static final String BASE_PATH = "/${tableClass.variableName?lower_case}/";
	private static final String HTML_PATH = "/html" + BASE_PATH;
	private static final String JSP_PATH = "/table" + BASE_PATH;
	
	@Autowired
	private ${tableClass.shortClassName}Service ${tableClass.variableName}Service;

	/** 页面跳转 */
	@RequestMapping(value = "/forward")
	public String forward(String path) {
		LOG.info("forward:path={}", path);
		if (StringUtils.isBlank(path)) {
			return null;
		}

		if (path.endsWith(".html")) {
			return "redirect:" + HTML_PATH + path;
		} else {
			return JSP_PATH + path;
		}
	}

	@RequestMapping(value = "/")
	public String index() {
		return "redirect:" + HTML_PATH + "list.html";
	}

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
	
    @RequestMapping(value = "/view")
	@ResponseBody
	public ResponseVo<${tableClass.shortClassName}> view(String busID) {
		LOG.info("view?busID={}", busID);
		${tableClass.shortClassName} ${tableClass.variableName} = ${tableClass.variableName}Service.selectEntityByBusID(busID);
		return this.success(smsTest);
	}
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public ResponseVo<?> add(${tableClass.shortClassName} ${tableClass.variableName}) {
		LOG.info("add={}", ${tableClass.variableName}.toString());
		int i = ${tableClass.variableName}Service.insertSelective(${tableClass.variableName});
		if (i == 0) {
			return this.failure();
		}
		return this.success();
	}	

	@RequestMapping(value = "/edit")
	@ResponseBody
	public ResponseVo<?> edit(${tableClass.shortClassName} ${tableClass.variableName}) {
		LOG.info("edit={}", ${tableClass.variableName}.toString());
		if (StringUtils.isBlank(${tableClass.variableName}.getBusId())) {
			return this.failure("业务ID不为空");
		}
		int i = ${tableClass.variableName}Service.selectCountByExample(${tableClass.variableName}.getBusId());
		if (i == 0) {
			return this.failure("未查询到要更新的数据!");
		}
		if (i != 1) {
			return this.failure("不支持多条更新!");
		}
		int u = ${tableClass.variableName}Service.updateByExampleSelective(${tableClass.variableName});
		if (u != 1) {
			return this.failure();
		}
		return this.success();
	}

	@RequestMapping(value = "/delete")
	@ResponseBody
	public ResponseVo<?> delete(String busID) {
		LOG.info("delete?busID={}", busID);
		int i = ${tableClass.variableName}Service.deleteByExample(busID);
		if (i != 1) {
			return this.failure();
		}
		return this.success();
	}

}