package com.yy.service;

import com.yy.entity.Person;
import com.yy.entity.Table;

/**
* @author 陈籽伟
* @version 创建时间：2020年11月10日 下午1:41:57
* 类说明
*/
public interface PersonService {
	public Object selPserson(Person person);
	
	public Object addPerson(Person person);
	
	public Object editPerson(Person person,String pCode);
	
	public Object addPersonTable(Table table,String groupName);
	
	public Object selPersonTable(Table table,String groupName);
	
	public Object editPersonTable(Table table,String groupName,String phone);
}
