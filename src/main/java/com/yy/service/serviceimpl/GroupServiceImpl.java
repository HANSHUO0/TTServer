package com.yy.service.serviceimpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.yy.dao.DepartmentDao;
import com.yy.dao.GroupDao;
import com.yy.dao.PersonDao;
import com.yy.entity.Department;
import com.yy.entity.Group;
import com.yy.entity.Person;
import com.yy.entity.Table;
import com.yy.service.GroupService;
import com.yy.util.Code;

/**
* @author 陈籽伟
* @version 创建时间：2020年10月27日 下午3:19:38
* 类说明
*/
@Service
public class GroupServiceImpl implements GroupService {
	@Resource
	private GroupDao groupDao;
	@Resource
	private DepartmentDao departmentDao;
	@Resource
	private PersonDao personDao;



	/**
	 * 查询组织
	 */
	@Override
	public Object selGroup(Group group,Integer page, Integer limit) {

		if (page !=null) {
			PageHelper.startPage(page, limit);
		}
		List<Group> selRoList = groupDao.selGroup(group);
		PageInfo<Group> pageInfo= new PageInfo<Group>(selRoList);
		long total = pageInfo.getTotal();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "查询失败");
		map.put("code", 0);
		map.put("count", total);
		map.put("data",selRoList);
		if (selRoList.size()!=0) {	
			map.put("msg", "查询成功");
		}		
		return map;
	}
	/**
	 * 申请组织
	 */
	@Override
	public Object addGroup(Group group) {
		String ID = Code.getCode();
		group.setID(ID);
		group.setIsDel(1);		
		
		Integer addGroup = groupDao.addGroup(group);
	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "申请失败");
		if (addGroup != 0) {			
			map.put("msg", "申请成功");
		}		
		return map;
	}

	/**
	 * 申请组织通过
	 */
	@Override
	public Object editGroup(Group group) {
		Integer editGroup = 0;
		if (group.getIsDel() == 0) {
			Department department = new Department();
			department.setGroupID(group.getID());
			department.setId(Code.getCode());
			departmentDao.addDepartment(department);
			editGroup = groupDao.editGroup(group);
			Group group2 = new Group();
			group2.setCGroupCode(group.getCGroupCode());
			group2.setIsDel(group.getIsDel());
			List<Group> groups = groupDao.selGroup(group2);
			Person person = new Person();
			person.setId(Code.getCode());
			person.setUserId(groups.get(0).getCreateUserID());
			person.setRoleName("盟主");
			person.setDepID("1");
			person.setGroupId(groups.get(0).getID());
			person.setWorkState("在职");
			personDao.addPerson(person);
			Table table = new Table();
			table.setId(Code.getCode());
			table.setGroupId(groups.get(0).getID());
			table.setUserId(groups.get(0).getCreateUserID());
			table.setData(null);
			personDao.addPersonTable(table);
		}else if (group.getIsDel() == 2) {
			editGroup = groupDao.editGroup(group);
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "修改失败");
		if (editGroup != 0 ) {			
			map.put("msg", "修改成功");
		}		
		return map;
	}

}
