package com.yy.service.serviceimpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yy.dao.GroupDao;
import com.yy.dao.IncreaseRulesDao;
import com.yy.entity.Group;
import com.yy.entity.IncreaseRules;
import com.yy.service.IncreaseRulesService;
import com.yy.util.Code;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月11日 上午10:21:55
* 类说明
*/
@Service
public class IncreaseRulesServiceImpl implements IncreaseRulesService {
	@Resource
	private GroupDao groupDao;
	@Resource 
	private IncreaseRulesDao increaseRulesDao;

	@Override
	public Object selIncreaseRules(IncreaseRules increaseRole,String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		increaseRole.setGroupID(groupDao.selGroup(group).get(0).getID());
		List<IncreaseRules> selIncreaseRole = increaseRulesDao.selIncreaseRules(increaseRole);
		Map<String, Object> map = new HashMap<String, Object>();
		if (selIncreaseRole.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
           map.put("msg","查询成功"); 
           map.put("data",selIncreaseRole);
       }
		return map;
	}

	@Override
	public Object addIncreaseRules(IncreaseRules increaseRole,String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		increaseRole.setGroupID(groupDao.selGroup(group).get(0).getID());
		increaseRole.setID(Code.getCode());
		Integer addPerson = increaseRulesDao.addIncreaseRules(increaseRole);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "添加失败");
		if (addPerson!=0) {
			map.put("msg", "添加成功");
		}		
		return map;
	}

	@Override
	public Object editIncreaseRules(IncreaseRules increaseRole,String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		increaseRole.setGroupID(groupDao.selGroup(group).get(0).getID());
		Integer editDepartment = increaseRulesDao.editIncreaseRules(increaseRole);
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (editDepartment==null) {
			 map.put("msg","修改失败");   
	        }else {
            map.put("msg","修改成功"); 
        }
		return map;
	}
	
	
}
