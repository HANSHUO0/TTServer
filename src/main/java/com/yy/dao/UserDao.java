package com.yy.dao;

import java.util.HashMap;
import java.util.List;

import com.yy.entity.Group;
import com.yy.entity.User;

/**
* @author 陈籽伟
* @version 创建时间：2020年9月8日 下午3:02:10
* 类说明
*/

public interface UserDao {

	/**
	 * 查询user信息
	 * @param user
	 * @return
	 */
	List<User> selUser(User user);
	/**
	 * 添加user
	 * @param user
	 * @return
	 */
	Integer addUser(User user);
	/**
	 * 删除user
	 * @param ids 要删除的id数组
	 * @return
	 */
	Integer deleteUser(String ID);
	/**
	 * 修改user
	 * @param user
	 * @return
	 */
	Integer editUser(User user);
	/**
	 * 登录
	 * @param user
	 * @return
	 */
	User Login(User user);
	/**
	 * 修改密码
	 * @param phone
	 * @return
	 */
	Integer ChangePassword(User user);

	/**
	 * 查询user管理的组织信息
	 * @param user
	 * @return
	 */
	List<Group> selUserAboutGroup(User user);

	/**
	 * 查询同事
	 * @param id
	 * @return
	 */
	List<HashMap<String,Object>> selGroupAndUser(User user);

	/**
	 * 查询客户的同事
	 */
	List<HashMap<String,Object>> selCustomerColleague(User user);

	/**
	 * 查询客户的技术
	 * @param user
	 * @return
	 */
	List<HashMap<String, Object>> selectCustomerTechnique(User user);
}
