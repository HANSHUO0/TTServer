package com.yy.service;

import com.yy.entity.BaseDesign;
import com.yy.entity.CreateMySQL;

/**
* @author 陈籽伟
* @version 创建时间：2020年8月25日 上午11:10:37
* 类说明
*/
public interface BaseDesignService {

	public Object selDesign(BaseDesign baseDesign);
	
	public Object selDesign2(BaseDesign baseDesign);
	
	public Object selDesign3(BaseDesign baseDesign);
	
	public Object addDesign(BaseDesign baseDesign);
	
	public Object editDesign(BaseDesign baseDesign);
	
	public Object deleteDesign(String ID);
	
	public Object createMySQL(CreateMySQL createMySQL);
	
}
