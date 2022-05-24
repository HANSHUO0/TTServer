package com.yy.dao;

import java.util.List;

import com.yy.entity.IncreaseRules;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月11日 上午10:12:39
* 类说明
*/
public interface IncreaseRulesDao {

	public List<IncreaseRules> selIncreaseRules(IncreaseRules increaseRules);
	public Integer addIncreaseRules(IncreaseRules increaseRules);
	public Integer editIncreaseRules(IncreaseRules increaseRules);
}
