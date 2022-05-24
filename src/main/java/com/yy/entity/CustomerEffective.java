package com.yy.entity;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import com.yy.util.DateFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月15日 下午5:53:02
* 类说明
*/
@Data
public class CustomerEffective {

	private String ID;
	private String groupID;
	private String cid;
	@JsonProperty("cCusCode")
	private String cCusCode;
	@JsonProperty("cProductName")
	private String cProductName;
	@JsonProperty("cStartDate")
	private String cStartDate;
	@JsonProperty("cEffective")
	private String cEffective;
	@JsonProperty("cEndDate")
	private String cEndDate;
	private String note;
	private Date createTime;

	public void setcEndDate(String cEndDate) {
		this.cEndDate = DateFormat.dateToStr(DateFormat.strToDate(cEndDate,"yyyy/MM/dd"),"yyyy-MM-dd");
	}
}
