package com.min.intranet.controller;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by bakas.
 *
 * @author eunsebi
 * @since 2018-01-11
 */
@Controller
public class JasyptCtr {

    @RequestMapping(value = "jasypt.do", method = RequestMethod.GET)
    public String jasypt() {
        StandardPBEStringEncryptor standardPBEStringEncryptor = new StandardPBEStringEncryptor();
        standardPBEStringEncryptor.setAlgorithm("PBEWithMD5AndDES");
        standardPBEStringEncryptor.setPassword("niee.security");
        String url = standardPBEStringEncryptor.encrypt("jdbc:mysql://ekkor.ze.am:3306/myintranet");
        String id = standardPBEStringEncryptor.encrypt("ekkor");
        String encodedPass = standardPBEStringEncryptor.encrypt("ekkor123");
        System.out.println("Encrypted Password for admin is : "+encodedPass);
        System.out.println("url : " + url);
        System.out.println("id : " + id);

        return "etc/jasypt";

		/*StandardPBEStringEncryptor encryptor = new StandardPBEStringEncryptor();
		encryptor.setPassword("niee.security value");
		String password = encryptor.encrypt("test");
		System.out.println(password);
		System.out.println(encryptor.decrypt(password));*/
    }
}
