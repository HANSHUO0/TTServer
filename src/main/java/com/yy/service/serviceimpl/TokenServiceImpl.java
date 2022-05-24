package com.yy.service.serviceimpl;

import org.springframework.stereotype.Service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.yy.entity.User;
import com.yy.service.TokenService;


@Service
public class TokenServiceImpl implements TokenService{
	@Override
	public String getToken(User user) {
        String token="";
        token= JWT.create().withAudience(user.getEmail()) // 将 phone 保存到 token 里面
                .sign(Algorithm.HMAC256(user.getPasswordMD5())); // 以 password 作为 token 的密钥
        return token;
    }

	@Override
	public String getCemail(String token) {
		
		DecodedJWT jwt = JWT.decode(token);
		return jwt.getAudience().get(0);
	}
	
}
