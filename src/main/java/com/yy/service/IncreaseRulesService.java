package com.yy.service;

import com.yy.entity.IncreaseRules;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月11日 上午10:19:41
* 类说明
*/
public interface IncreaseRulesService {

	public Object selIncreaseRules(IncreaseRules increaseRules,String groupName);
	public Object addIncreaseRules(IncreaseRules increaseRules,String groupName);
	public Object editIncreaseRules(IncreaseRules increaseRules,String groupName);
	
}
