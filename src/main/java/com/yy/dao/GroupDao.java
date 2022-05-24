package com.yy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import com.yy.entity.Group;
import com.yy.entity.UserGroup;


/**
* @author 陈籽伟
* @version 创建时间：2020年10月27日 下午2:56:54
* 类说明
*/
public interface GroupDao {

	/**
	 * 查询组织信息
	 * @param 
	 * @return
	 */
	public List<Group> selGroup(Group group);
	/**
	 * 添加组织
	 * @param role
	 * @return
	 */
	public Integer addGroup(Group group);
	/**
	 * 删除用户组织关系
	 * @param userGroup
	 */
	public void deleteUserGroup(UserGroup userGroup);
	/**
	 * 添加用户组织关系
	 * @param userGroup
	 * @return
	 */
	public Integer addUserGroup(UserGroup userGroup);
	public void addUserGroup2(UserGroup userGroup);
	/**
	 * 查询发布的页面信息
	 * @param UserID
	 * @param cGroupName
	 * @param menuId
	 * @return
	 */
	@Select("select im_user_group.AddData FROM im_user_group where UserID = #{UserID} AND GroupID = #{GroupID} AND MenuID = #{menuId}")
	public String selMenuAddData(String UserID,String GroupID,Integer menuId);
	/**
	 * 修改组织
	 * @param group
	 * @return
	 */
	public Integer editGroup(Group group);

}
