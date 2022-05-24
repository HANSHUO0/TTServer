package com.yy.service.serviceimpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yy.dao.GroupDao;
import com.yy.dao.PersonDao;
import com.yy.dao.UserDao;
import com.yy.entity.Group;
import com.yy.entity.Person;
import com.yy.entity.Table;
import com.yy.entity.User;
import com.yy.service.PersonService;
import com.yy.util.Code;

/**
* @author 陈籽伟
* @version 创建时间：2020年11月10日 下午1:44:08
* 类说明
*/
@Service
public class PersonServiceImpl implements PersonService {
	@Resource
	private PersonDao personDao;
	@Resource
	private GroupDao groupDao;
	@Resource
	private UserDao userDao;
	/**
	 * 查询组织人员
	 * @param person
	 * @return
	 */
	@Override
	public Object selPserson(Person person) {
		if (person.getGroupName()!=""&&person.getGroupName()!=null) {
			Group group = new Group();
			group.setCGroupName(person.getGroupName());
			person.setGroupId(groupDao.selGroup(group).get(0).getID());
		}
		
		List<Person> selPerson = personDao.selPerson(person);
		Map<String, Object> map = new HashMap<>();
		map.put("msg", "查询失败");
		if (selPerson.size()!=0) {
			map.put("data", selPerson);

			map.put("msg", "查询成功");
		}		
		
		return map;
	}
	
	/**
	 * 添加人员
	 * @param person
	 * @return
	 */
	@Override
	public Object addPerson(Person person) {
		Integer addPerson = personDao.addPerson(person);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "添加失败");
		if (addPerson!=0) {
			map.put("msg", "添加成功");
		}		
		return map;

	}

	/**
	 * 修改部门人员
	 * @param person
	 * @return
	 */
	@Override
	public Object editPerson(Person person,String mobilePhone) {
		User user = new User();
		user.setMobilePhone(mobilePhone);
		user.setIsDel(0);
		person.setUserId(userDao.selUser(user).get(0).getID());
		Group group = new Group();
		group.setCGroupName(person.getGroupName());
		person.setGroupId(groupDao.selGroup(group).get(0).getID());
		Integer editPerson = personDao.editPerson(person);		
		Map<String, Object> map = new HashMap<String, Object>();
 		map.put("msg", "修改失败");
		if (editPerson!=0) {
			map.put("msg", "修改成功");
		}		
		return map;
	}
	
	/**
	 * 添加部门表格
	 */
	@Override
	public Object addPersonTable(Table table,String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		table.setGroupId(groupDao.selGroup(group).get(0).getID());
		table.setId(Code.getCode());
		
		Integer addPersonTable = personDao.addPersonTable(table);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "添加失败");
		if (addPersonTable!=0) {
			map.put("msg", "添加成功");
		}		
		return map;
	}

	/**
	 * 查询部门表格
	 */
	@Override
	public Object selPersonTable(Table table,String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		table.setGroupId(groupDao.selGroup(group).get(0).getID());
		List<Table> selTable = personDao.selPersonTable(table);	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "查询失败");
		if (selTable.size()!=0) {
			map.put("msg", "查询成功");
			map.put("data", selTable.get(0));
		}		
		return map;
	}

	/**
	 * 修改部门表格
	 */
	@Override
	public Object editPersonTable(Table table, String groupName,String phone) {
		Integer editPersonTable = 0,addPersonTable=0;
		Group group = new Group();
		group.setCGroupName(groupName);
		table.setGroupId(groupDao.selGroup(group).get(0).getID());
		if (phone!=null&phone!="") {
			User user = new User();
			user.setMobilePhone(phone);
			String id = userDao.selUser(user).get(0).getID();
			table.setUserId(id);
			table.setId(Code.getCode());
			personDao.deletePersonTable(id);
			addPersonTable = personDao.addPersonTable(table);
		}else {
			editPersonTable = personDao.editPersonTable(table);
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "修改失败");
		if (editPersonTable!=0||addPersonTable!=0) {
			map.put("msg", "修改成功");
		}		
		return map;
	}

}
