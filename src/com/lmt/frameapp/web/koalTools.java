/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web;

public class koalTools {

	public koalTools() {
	}

	public int B64Decode(String s, byte abyte0[]) {
		int i = s.length();
		byte abyte1[] = new byte[i];
		for (int j = 0; j < i; j++)
			abyte1[j] = (byte) s.charAt(j);

		return B64Decode(abyte1, abyte0);
	}

	public int B64Decode(byte abyte0[], byte abyte1[]) {
		int i = 0;
		int j = 0;
		int k = abyte0.length;
		int l = k / 4;
		for (int i1 = 0; i1 < l; i1++) {
			j = Decode4Char(abyte0, abyte1, j, i1);
			i += j;
		}

		k -= l * 4;
		if (k > 0) {
			byte abyte2[] = new byte[4];
			int j1;
			for (j1 = 0; j1 < k; j1++)
				abyte2[j1] = abyte0[j1];

			for (; j1 < 4; j1++)
				abyte2[j1] = 61;

			j = Decode4Char(abyte2, abyte1, j, 0);
			i += j;
		}
		return i;
	}

	private int Decode4Char(byte abyte0[], byte abyte1[], int i, int j) {
		byte abyte2[] = new byte[4];
		int k = j * 4;
		int l = j * 3;
		for (int i1 = 0; i1 < 4; i1++)
			abyte2[i1] = abyte0[k + i1];

		i = map4char(abyte2);
		abyte1[l] = (byte) (abyte2[0] << 2 | abyte2[1] >> 4);
		abyte1[l + 1] = (byte) (abyte2[1] << 4 | abyte2[2] >> 2);
		abyte1[l + 2] = (byte) (abyte2[2] << 6 | abyte2[3]);
		for (int j1 = i; j1 < 3; j1++)
			abyte1[l + j1] = 0;

		return i;
	}

	private int map4char(byte abyte0[]) {
		int i;
		for (i = 0; i < 4; i++) {
			if (abyte0[i] >= 97 && abyte0[i] <= 122) {
				abyte0[i] = (byte) ((abyte0[i] - 97) + 26);
				continue;
			}
			if (abyte0[i] >= 65 && abyte0[i] <= 90) {
				abyte0[i] -= 65;
				continue;
			}
			if (abyte0[i] >= 48 && abyte0[i] <= 57) {
				abyte0[i] = (byte) ((abyte0[i] - 48) + 52);
				continue;
			}
			if (abyte0[i] == 43) {
				abyte0[i] = 62;
				continue;
			}
			if (abyte0[i] == 47) {
				abyte0[i] = 63;
				continue;
			}
			if (abyte0[i] == 61)
				break;
		}

		if (i <= 1)
			i = 1;
		return i - 1;
	}

	public byte[] splitCertificate(String s) {
		int i = s.length();
		byte abyte0[] = new byte[i];
		for (int j = 0; j < i; j++)
			abyte0[j] = (byte) s.charAt(j);

		return splitCertificate(abyte0);
	}

	public byte[] splitCertificate(byte abyte0[]) {
		String s = new String("-----BEGIN CERTIFICATE-----\n");
		String s1 = new String("-----END CERTIFICATE-----\n");
		int i = abyte0.length;
		int j = i / 64;
		if (i % 64 != 0)
			j++;
		byte abyte1[] = new byte[i + j + s.length() + s1.length()];
		int k = 0;
		for (int l = 0; l < s.length();) {
			abyte1[k] = (byte) s.charAt(l);
			l++;
			k++;
		}

		int i1;
		for (i1 = 0; i1 < j - 1; i1++) {
			System.arraycopy(abyte0, i1 * 64, abyte1, k, 64);
			k += 64;
			abyte1[k] = 10;
			k++;
		}

		boolean flag = false;
		for (i1 *= 64; i1 < i; i1++) {
			byte byte0 = abyte0[i1];
			if (!flag
					&& (byte0 >= 97 && byte0 <= 122 || byte0 >= 65
							&& byte0 <= 90 || byte0 >= 48 && byte0 <= 57
							|| byte0 == 43 || byte0 == 47)) {
				abyte1[k] = byte0;
				k++;
				continue;
			}
			if (byte0 != 61)
				break;
			flag = true;
			abyte1[k] = byte0;
			k++;
		}

		abyte1[k] = 10;
		k++;
		for (int j1 = 0; j1 < s1.length();) {
			abyte1[k] = (byte) s1.charAt(j1);
			j1++;
			k++;
		}

		byte abyte2[] = new byte[k];
		System.arraycopy(abyte1, 0, abyte2, 0, k);
		return abyte2;
	}
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 192 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/