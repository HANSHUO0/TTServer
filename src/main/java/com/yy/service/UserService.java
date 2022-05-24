package com.yy.service;


import com.yy.entity.User;



/**
* @author 陈籽伟
* @version 创建时间：2020年9月8日 下午3:16:42
* 类说明
*/
public interface UserService {

	/**
	 * 查询用户
	 * @param user
	 * @return
	 */
	public Object selUser(User user);

	/**
	 * 查询用户管联的组织
	 * @param user
	 */
	public Object selUserAboutGroup(User user);

	/**
	 * 添加用户
	 * @param user
	 * @return
	 */
	public Object addUser(User user);
	/**
	 * 删除用户
	 * @param ids
	 * @return
	 */
	public Object deleteUser(String ID);
	/**
	 * 修改用户信息
	 * @param user
	 * @return
	 */
	public Object editUser(User user);
	/**
	 * 登录检测
	 * @param user
	 * @return
	 */
	public Object login(User user);
	/**
	 * 修改密码
	 * @param user
	 * @return
	 */
	public Object ChangePassword(User user);

}
