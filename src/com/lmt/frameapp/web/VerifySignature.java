/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web;

import java.io.ByteArrayInputStream;
import java.math.BigInteger;
import java.security.DigestInputStream;
import java.security.MessageDigest;

public class VerifySignature {

	public VerifySignature() {
	}

	public static boolean Verify(String s, String s1, String s2) {
		try {
			koalTools koaltools = new koalTools();
			byte abyte0[] = new byte[s2.length()];
			int i = koaltools.B64Decode(s2, abyte0);
			byte abyte1[] = new byte[i];
			System.arraycopy(abyte0, 0, abyte1, 0, i);
			byte abyte2[] = new byte[s1.length()];
			int j = koaltools.B64Decode(s1, abyte2);
			byte abyte3[] = new byte[j];
			System.arraycopy(abyte2, 0, abyte3, 0, j);
			byte abyte4[] = new byte[j];
			for (int k = 0; k < j; k++)
				abyte4[k] = abyte3[j - k - 1];

			BigInteger biginteger = new BigInteger(1, abyte3);
			byte abyte5[] = new byte[3];
			abyte5[0] = 1;
			abyte5[1] = 0;
			abyte5[2] = 1;
			BigInteger biginteger1 = new BigInteger(1, abyte5);
			BigInteger biginteger2 = new BigInteger(1, abyte1);
			BigInteger biginteger3 = biginteger2
					.modPow(biginteger1, biginteger);
			byte abyte6[] = biginteger3.toByteArray();
			byte abyte7[] = new byte[16];
			boolean flag = false;
			int l = 0;
			int i1 = 0;
			for (i1 = 0; i1 < abyte6.length; i1++) {
				if (abyte6[i1] == 0)
					flag = true;
				if (!flag)
					continue;
				abyte7[l] = abyte6[i1];
				l++;
				if (abyte6[i1] == 20)
					break;
			}

			byte abyte8[] = s.getBytes();
			byte abyte9[] = { 0, 48, 33, 48, 9, 6, 5, 43, 14, 3, 2, 26, 5, 0,
					4, 20 };
			String s3 = new String(abyte7);
			String s4 = new String(abyte9);
			String s5 = new String();
			String s6 = new String();
			if (s3.equals(s4)) {
				byte abyte10[] = new byte[20];
				int j1 = 0;
				for (i1++; i1 < abyte6.length; i1++) {
					abyte10[j1] = abyte6[i1];
					System.out.print(abyte6[i1] + "\t");
					j1++;
				}

				SHA1 sha1 = new SHA1();
				sha1.update(abyte8, 0, abyte8.length);
				byte abyte12[] = sha1.digest();
				String s7 = new String(abyte12);
				s5 = s7.toString();
				String s8 = new String(abyte10);
				s6 = s8.toString();
			} else {
				byte abyte11[] = new byte[16];
				for (int k1 = abyte6.length - 16; k1 < abyte6.length; k1++)
					abyte11[k1] = abyte6[k1];

				ByteArrayInputStream bytearrayinputstream = new ByteArrayInputStream(
						abyte8);
				MessageDigest messagedigest = MessageDigest.getInstance("MD5");
				DigestInputStream digestinputstream = new DigestInputStream(
						bytearrayinputstream, messagedigest);
				MessageDigest messagedigest1 = digestinputstream
						.getMessageDigest();
				byte abyte13[] = messagedigest1.digest();
				String s9 = new String(abyte13);
				s5 = s9.toString();
				String s10 = new String(abyte11);
				s6 = s10.toString();
			}
			return s5.equals(s6);
		} catch (Exception _ex) {
			return false;
		}
	}
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDS\WebRoot\WEB-INF\lib\ade-1.1beta_g.jar
	Total time: 180 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/