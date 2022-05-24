package com.yy.service.serviceimpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.yy.dao.CustomerDao;
import com.yy.entity.CustomerPeople;
import com.yy.entity.Group;
import org.springframework.stereotype.Service;

import com.yy.dao.UserDao;
import com.yy.entity.User;
import com.yy.service.UserService;
import com.yy.util.Code;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
* @author 陈籽伟
* @version 创建时间：2020年9月8日 下午3:29:34
* 类说明
*/
@Service
public class UserServiceImpl implements UserService {

	@Resource
	private UserDao userDao;

	@Resource
	private CustomerDao customerDao;
	
	/**
	 * 查询用户
	 */
	@Override
	public Object selUser(User user) {
				
		List<User> selSuperAdmin = userDao.selUser(user);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "查询失败");
		if (selSuperAdmin.size()!=0) {
			map.put("data", selSuperAdmin);
			map.put("msg", "查询成功");
		}		
		return map;
	}

	/**
	 * 查询用户关联的组织 同事、客户
	 */
	@Override
	public Object selUserAboutGroup(User user) {

		List<Group> selSuperAdmin = null;
		List<HashMap<String, Object>> customerPeopleList = null;
		List<HashMap<String, Object>> userList = null;
		List<HashMap<String,Object>> customerColleague = null;
		if (user.getID() != null && user.getID() != "") {
			//用户关联的组织
			selSuperAdmin = userDao.selUserAboutGroup(user);
			//客户同事
			customerColleague = userDao.selCustomerColleague(user);
			for (Group group : selSuperAdmin) {
				//查询同事
				user.setID(group.getID());
				userList = userDao.selGroupAndUser(user);

				//查询客户及客户的联系人
				CustomerPeople customerPeople = new CustomerPeople();
				customerPeople.setGroupID(group.getID());
				customerPeople.setCName(user.getPsnName());
				customerPeopleList = customerDao.selCustomerAndPeople(customerPeople);
			}
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "查询失败");
		if (customerPeopleList!=null && customerPeopleList.size()!=0) {
			map.put("customerPeopleList", customerPeopleList);
			map.put("msg", "查询成功");
		}
		if (userList !=null && userList.size() != 0){
			map.put("userList", userList);
			map.put("msg", "查询成功");
		}else {
			userList = userDao.selectCustomerTechnique(user);
			if (userList !=null && userList.size() != 0) {
				map.put("userList", userList);
				map.put("msg", "查询成功");
			}
		}
		if (customerColleague != null && customerColleague.size()!=0){
			map.put("DepartmentPeople",customerColleague);
		}
		return map;
	}


	/**
	 * 添加用户
	 */
	@Override
	public Object addUser(User user) {
		user.setID(Code.getCode());
		user.setIsDel(0);
		user.setEMCode(Code.getRandom());
		Integer adduser = userDao.addUser(user);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "添加失败");
		if(adduser != 0) {
			map.put("msg", "添加成功");
		}
		return map;
	}

	/**
	 * 删除用户
	 */
	@Override
	public Object deleteUser(String ID) {
		
		Integer cont =  userDao.deleteUser(ID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg","删除失败");
		map.put("code", 200);
		map.put("success", false);
		if (cont != 0) {
			map.put("msg", "删除成功");
			map.put("success", true);
			map.put("code",0);
		}			
		return map;	
	}
	/**
	 * 修改用户信息
	 */
	@Override
	public Object editUser(User user) {
		Integer edituser = userDao.editUser(user);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "修改失败");
		if(edituser != 0) {
			map.put("msg", "修改成功");
		}
		return map;		
	}
	
	
	/**
	 * 登录检测
	 * @param user
	 * @return
	 */
	public Object login(User user) {
		 Map<String, String> map = new HashMap<String, String>();
	        User userForBase = userDao.Login(user);
	        if(userForBase==null){
	            map.put("msg","登录失败");
	            return map;
	        }else {
	        	map.put("ID", userForBase.getID());
                map.put("msg","登录成功");              
                return map;
            }
	       
	}

	/**
	 * 修改密码
	 */
	@Override
	public Object ChangePassword(User user) {
		Map<String, String> map = new HashMap<String, String>();
		Integer editUser = userDao.ChangePassword(user);
		if (editUser==null) {
			 map.put("msg","修改失败");
	            
	        }else {
             map.put("msg","修改成功");
             
         }
		return map;
	}



}
