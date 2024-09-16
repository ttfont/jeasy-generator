package xin.jeasy.mybatis.generator.comment;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.mybatis.generator.api.IntrospectedColumn;
import org.mybatis.generator.api.IntrospectedTable;
import org.mybatis.generator.api.dom.java.Field;
import org.mybatis.generator.api.dom.java.TopLevelClass;
import org.mybatis.generator.internal.DefaultCommentGenerator;
import org.mybatis.generator.internal.util.StringUtility;

public class RemarksCommentGenerator extends DefaultCommentGenerator {

    @Override
    public void addModelClassComment(TopLevelClass topLevelClass, IntrospectedTable introspectedTable) {
        topLevelClass.addJavaDocLine("/**");
        topLevelClass.addJavaDocLine(" * @表名 " + introspectedTable.getFullyQualifiedTable());
        topLevelClass.addJavaDocLine(" * @日期 " + new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
        topLevelClass.addJavaDocLine(" * @作者 generator ");
        topLevelClass.addJavaDocLine(" * @修改人  ");
        topLevelClass.addJavaDocLine(" */");
    }

    @Override
    public void addFieldComment(Field field, IntrospectedTable introspectedTable,
                                IntrospectedColumn introspectedColumn) {
        String remark = introspectedColumn.getRemarks();
        String columnName = introspectedColumn.getActualColumnName();
        List<IntrospectedColumn> primaryKey = introspectedTable.getPrimaryKeyColumns();
        for (IntrospectedColumn pk : primaryKey) {
            if (columnName.equals(pk.getActualColumnName())) {
                remark += " (主健ID)";
                continue; // 主健属性上无需生明可选项跟必填项介绍
            }
            if (StringUtility.stringHasValue(remark)) {
                remark += introspectedColumn.isNullable() ? "(可选项)" : "(必填项)";
            }
        }
        String defaultValue = introspectedColumn.getDefaultValue();
        remark += null != defaultValue ? "  (默认值为: " + defaultValue + ")" : " (无默认值)";
        field.addJavaDocLine("/** " + remark + " */");
    }
}
