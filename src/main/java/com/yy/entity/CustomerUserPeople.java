package com.yy.entity;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * @Auther: 韩烁
 * @Data: 2022/5/6 0006 15:54
 * @Description:
 */
@Data
public class CustomerUserPeople {
    private String id;
    private String cusPeoId;
    private String userId;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private String bindTime;
    private String createUser;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private String createTime;
}
