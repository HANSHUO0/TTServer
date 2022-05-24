package com.yy.dao;
/**
* @author 陈籽伟
* @version 创建时间：2020年11月10日 上午11:00:17
* 类说明
*/

import java.util.List;

import com.yy.entity.Person;
import com.yy.entity.Table;

public interface PersonDao {

	public List<Person> selPerson(Person person);
	
	public Integer editPerson(Person person);
	
	public Integer addPerson(Person person);
	
	public Integer addPersonTable(Table table);
	
	public List<Table> selPersonTable(Table table);
	
	public Integer editPersonTable(Table table);
	
	public Integer deletePersonTable(String userId);
}
