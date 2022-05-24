package com.yy.service.serviceimpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.yy.dao.DepartmentDao;
import com.yy.dao.PersonDao;
import com.yy.dao.RoleDao;
import com.yy.entity.Department;
import com.yy.entity.Person;
import com.yy.entity.Role;
import com.yy.service.RoleService;

/**
* @author 陈籽伟
* @version 创建时间：2021年1月20日 下午3:17:43
* 类说明
*/
@Service
public class RoleServiceImpl implements RoleService {

	@Resource 
	private RoleDao roleDao;
	@Resource
	private PersonDao personDao;
	
	
	@Override
	public Object selRole(Role role) {
	
		List<Role> selRole = roleDao.selRole(role);
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(selRole.size() != 0 ) {
			map.put("msg", "查询成功");
			map.put("data", selRole);
		}
		return map;
	}




	@Override
	public Object editRole(Role role) {
		Integer delete = roleDao.deleteRole(role);
		if (role.getIds()!=""&&role.getIds()!=null) {
			roleDao.addRole(role);
		}
		Map<String, Object> map = new HashMap<String, Object>();
		if(delete != 0 ) {
			map.put("msg", "保存成功");
		}else {
			map.put("msg", "保存失败");
		}
		return map;
	}


	@Override
	public Object addRole(Role role) {
		
		Integer add = roleDao.addRole(role);
		Map<String, Object> map = new HashMap<String, Object>();
		if(add != 0 ) {
			map.put("msg", "查询成功");
		}else {
			map.put("msg", "查询失败");
		}
		return map;
	}




	@Override
	public Object selRole(Person person) {
		List<Person> selPerson = personDao.selPerson(person);
		Role role = new Role();
		role.setDepID(selPerson.get(0).getDepID());
		role.setGroupID(selPerson.get(0).getGroupId());
		List<Role> selRole = roleDao.selRole(role);
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(selRole.size() != 0 ) {
			map.put("msg", "查询成功");
			map.put("data", selRole);
		}
		return map;
	}

}
