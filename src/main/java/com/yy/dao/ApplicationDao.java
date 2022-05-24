package com.yy.dao;
/**
* @author 陈籽伟
* @version 创建时间：2021年2月24日 下午4:05:15
* 类说明
*/

import java.util.HashMap;
import java.util.List;

import com.yy.entity.CustomerPeople;
import com.yy.entity.CustomerUserPeople;
import com.yy.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.yy.entity.Application;



public interface ApplicationDao {
	
	//@Select("select * from im_application where groupID=#{groupID} order by createTime desc")
	@Select("<script>select * from im_application <where>groupID=#{groupID}" + 	
			"<if test=\"id !=null and id != ''\"> AND id= #{id} </if>" + 
			"<if test=\"applicationPhone !=null and applicationPhone != ''\"> AND applicationPhone = #{applicationPhone} </if>" + 
			"<if test=\"state !=null and state != ''\"> AND state = #{state} </if>" +
			"order by createTime desc </where></script>")
	public List<Application> selApplication(Application application);
	
	@Insert("insert into im_application (id,groupID,applicationName,applicationPhone,state,createTime) values (uuid(),#{groupID},#{applicationName},#{applicationPhone},0,now())")
	public Integer addApplication(Application application);
	
	@Update("update im_application set state = #{state} where id = #{id}")
	public Integer editApplication(Application application);

	@Select("SELECT bcp.*,bc.cCusName,bc.* FROM ba_customer bc inner join ba_customer_people bcp on bc.id = bcp.cCusCode where bc.groupID = #{groupID} HAVING bcp.ID not in (select cus_peo_id from ba_customer_user_people)")
	List<HashMap> selectCustomerApplication(Application application);

	@Insert("insert into ba_customer_user_people(id,cus_peo_id,user_id,bind_time,create_user,create_time) VALUES(uuid(),#{cusPeoId},#{userId},now(),#{createUser},now())")
	Integer addCustomerUserPeople(CustomerUserPeople customerUserPeople);

	@Select("select iu.*\n" +
			"from im_application ia\n" +
			"inner join im_user iu\n" +
			"on ia.applicationPhone=iu.mobilePhone\n" +
			"where ia.id=#{id}")
	User selectUserID(Application application);
}
