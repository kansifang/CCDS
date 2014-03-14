/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.render;

public class ASConv {

	public ASConv() {
	}

	public static String decode(String s, String encoding) throws Exception {
		if (s == null)
			return s;
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);
			switch (c) {
			case 43: // '+'
				sb.append(' ');
				break;

			case 37: // '%'
				try {
					sb.append((char) Integer.parseInt(
							s.substring(i + 1, i + 3), 16));
				} catch (NumberFormatException e) {
					throw new IllegalArgumentException();
				}
				i += 2;
				break;

			default:
				sb.append(c);
				break;
			}
		}

		String result = sb.toString();
		byte inputBytes[] = result.getBytes("8859_1");
		return new String(inputBytes, encoding);
	}
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 156 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/