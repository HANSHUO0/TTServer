package com.yy.service;

import com.yy.entity.User;

public interface TokenService {

	public String getToken(User user);
	
	public String getCemail(String token);
}
