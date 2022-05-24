package com.yy.service;

import com.yy.entity.Group;

/**
* @author 陈籽伟
* @version 创建时间：2020年10月27日 下午3:18:38
* 类说明
*/
public interface GroupService {

	Object selGroup(Group group,Integer page, Integer limit);

	Object addGroup(Group group);
	
	Object editGroup(Group group);
}
