<#assign dateTime = .now>
package ${package};

import ${tableClass.fullClassName};
import ${projectPackage}.mapper.${tableClass.shortClassName}Mapper;
import ${projectPackage}.pojo.${tableClass.shortClassName}Example;
<#if tableClass.baseFields?? && (tableClass.baseFields?size > 1) >
import ${projectPackage}.pojo.${tableClass.shortClassName}Example.Criteria;
</#if>

import com.your.commons.service.DBService;
import com.your.commons.beans.page.PagingQuery;
import com.your.commons.beans.page.Pagenation;
import com.your.commons.beans.page.PageListResult;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

/**
 * ${tableClass.shortClassName}${mapperSuffix}
 *
 * @mybatis.generated
 * @author 
 * @since ${dateTime?date}
 */
@Service("${tableClass.variableName}Service")
@Transactional(readOnly = true)
public class ${tableClass.shortClassName}${mapperSuffix} extends DBService<${tableClass.shortClassName}Mapper, ${tableClass.shortClassName}, ${tableClass.shortClassName}Example> {
	
	public ${tableClass.shortClassName} selectEntityByBusID(String busID) {
		${tableClass.shortClassName}Example example = new ${tableClass.shortClassName}Example();
		example.createCriteria().andBusIdEqualTo(busID);
		return super.selectEntityByBusID(example);
	}

	public PageListResult<${tableClass.shortClassName}> selectByExampleWithLimit(PagingQuery<${tableClass.shortClassName}> record) {
		${tableClass.shortClassName}Example example = new ${tableClass.shortClassName}Example();
		example.setLimit(record.getPageNo());
		example.setOffset(record.getPageSize());
		
		<#if tableClass.baseFields?? && (tableClass.baseFields?size > 1) >
		Criteria cri = example.createCriteria();
		</#if>
	    <#list tableClass.baseFields as fieldNames>
			<#if fieldNames.fieldName!="id">
		cri.and${fieldNames.fieldName?cap_first}EqualTo(record.getQuery().get${fieldNames.fieldName?cap_first}());
			</#if>
		</#list>	

		PageListResult<${tableClass.shortClassName}> pageList = new PageListResult<>();
		int itemCount = (int) super.countByExample(example);
		record.setItemCount(itemCount);

		if (itemCount == 0) {
			pageList.setValues(null);
		} else {
			pageList.setValues(super.selectByExampleWithLimit(example));
		}
		pageList.setPagenation(new Pagenation(record.getPageNo(), record.getPageSize(), record.getItemCount()));
		return pageList;
	}

	public int selectCountByExample(String busID) {
		${tableClass.shortClassName}Example example = new ${tableClass.shortClassName}Example();
		Criteria cri = example.createCriteria();
		cri.andBusIdEqualTo(busID);
		return (int) super.countByExample(example);
	}

	@Transactional(readOnly = false)
	public int insertSelective(${tableClass.shortClassName} record) {
		return super.insertSelective(record);
	}

    @Transactional(readOnly = false)
	public int updateByExampleSelective(${tableClass.shortClassName} record) {
		${tableClass.shortClassName}Example example = new ${tableClass.shortClassName}Example();
		Criteria cri = example.createCriteria();
		cri.andBusIdEqualTo(record.getBusId());
		return super.updateByExampleSelective(record, example);
	}

	@Transactional(readOnly = false)
	public int deleteByExample(String busID) {
		${tableClass.shortClassName}Example example = new ${tableClass.shortClassName}Example();
		example.createCriteria().andBusIdEqualTo(busID);
		return super.deleteByExample(example);
	}
	
}