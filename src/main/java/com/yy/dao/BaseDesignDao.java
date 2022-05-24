package com.yy.dao;

import java.util.List;

import com.yy.entity.BaseDesign;

/**
* @author 陈籽伟
* @version 创建时间：2020年8月25日 上午11:04:31
* 类说明
*/
public interface BaseDesignDao {
	/**
	 * 查询全部数据
	 * @param baseDesign
	 * @return
	 */
	public List<BaseDesign> selDesign(BaseDesign baseDesign);
	/**
	 * 需要导出的数据
	 * @param ids
	 * @return
	 */
	public List<BaseDesign> selDesignOut(Integer[] ids);
	/**
	 * 添加数据
	 * @param baseDesign
	 * @return
	 */
	public Integer addDesign(BaseDesign baseDesign);
	/**
	 * 编辑数据
	 * @param baseDesign
	 * @return
	 */
	public Integer editDesign(BaseDesign baseDesign); 
	/**
	 * 删除数据
	 * @param ID
	 * @return
	 */
	public Integer deleteDesign(String ID);
}
