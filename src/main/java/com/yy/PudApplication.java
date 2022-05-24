package com.yy;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.CrossOrigin;

@SpringBootApplication
@MapperScan(basePackages = "com.yy.dao")
public class PudApplication {

	public static void main(String[] args) {
		SpringApplication.run(PudApplication.class, args);
	}

}
