package utils;

import java.util.UUID;

public class Utils {

	public static String generateEmail() {
		return "user" + UUID.randomUUID().toString().substring(0, 5) + "@lk1234ios5678.com";
	}

	public static String generatePassword() {
		return "Aa1@" + UUID.randomUUID().toString().substring(0, 5);
	}

}
