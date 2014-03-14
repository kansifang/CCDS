/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web;

public final class SHA1 {

	public SHA1() {
		buffer = new byte[64];
		hash = new int[5];
		W = new int[80];
		reset();
	}

	private SHA1(SHA1 sha1) {
		buffer = new byte[64];
		hash = new int[5];
		W = new int[80];
		System.arraycopy(sha1.hash, 0, hash, 0, 5);
		System.arraycopy(sha1.buffer, 0, buffer, 0, 64);
		count = sha1.count;
		rest = sha1.rest;
	}

	private static int F00_19(int i, int j, int k) {
		return ((j ^ k) & i ^ k) + 1518500249;
	}

	private static int F20_39(int i, int j, int k) {
		return (i ^ j ^ k) + 1859775393;
	}

	private static int F40_59(int i, int j, int k) {
		return (i & j | (i | j) & k) + -1894007588;
	}

	private static int F60_79(int i, int j, int k) {
		return (i ^ j ^ k) + -899497514;
	}

	public int blockSize() {
		return 64;
	}

	public Object clone() {
		return new SHA1(this);
	}

	public byte[] digest() {
		byte abyte0[] = new byte[20];
		digestInto(abyte0, 0);
		return abyte0;
	}

	public int digestInto(byte abyte0[], int i) {
		int j = rest < 56 ? 56 - rest : 120 - rest;
		count *= 8L;
		byte abyte1[] = { (byte) (int) (count >> 56),
				(byte) (int) (count >> 58), (byte) (int) (count >> 40),
				(byte) (int) (count >> 32), (byte) (int) (count >> 24),
				(byte) (int) (count >> 16), (byte) (int) (count >> 8),
				(byte) (int) count };
		update(padding, 0, j);
		update(abyte1, 0, 8);
		for (int k = 0; k < 5; k++) {
			abyte0[i++] = (byte) (hash[k] >>> 24 & 255);
			abyte0[i++] = (byte) (hash[k] >>> 16 & 255);
			abyte0[i++] = (byte) (hash[k] >>> 8 & 255);
			abyte0[i++] = (byte) (hash[k] & 255);
		}

		reset();
		return 20;
	}

	public String getName() {
		return "SHA1";
	}

	public int hashSize() {
		return 20;
	}

	public void reset() {
		hash[0] = 1732584193;
		hash[1] = -271733879;
		hash[2] = -1732584194;
		hash[3] = 271733878;
		hash[4] = -1009589776;
		count = 0L;
		rest = 0;
	}

	private static int rotateLeft(int i, int j) {
		return i << j | i >>> 32 - j;
	}

	private void transform(byte abyte0[], int i) {
		int j = hash[0];
		int k = hash[1];
		int l = hash[2];
		int i1 = hash[3];
		int j1 = hash[4];
		for (int k1 = 0; k1 < 16; k1++)
			W[k1] = (abyte0[i++] & 255) << 24 | (abyte0[i++] & 255) << 16
					| (abyte0[i++] & 255) << 8 | abyte0[i++] & 255;

		for (int l1 = 16; l1 < 80; l1++) {
			int i3 = W[l1 - 3] ^ W[l1 - 8] ^ W[l1 - 14] ^ W[l1 - 16];
			W[l1] = rotateLeft(i3, 1);
		}

		for (int i2 = 0; i2 < 20; i2++) {
			int j3 = rotateLeft(j, 5) + F00_19(k, l, i1) + j1 + W[i2];
			j1 = i1;
			i1 = l;
			l = rotateLeft(k, 30);
			k = j;
			j = j3;
		}

		for (int j2 = 20; j2 < 40; j2++) {
			int k3 = rotateLeft(j, 5) + F20_39(k, l, i1) + j1 + W[j2];
			j1 = i1;
			i1 = l;
			l = rotateLeft(k, 30);
			k = j;
			j = k3;
		}

		for (int k2 = 40; k2 < 60; k2++) {
			int l3 = rotateLeft(j, 5) + F40_59(k, l, i1) + j1 + W[k2];
			j1 = i1;
			i1 = l;
			l = rotateLeft(k, 30);
			k = j;
			j = l3;
		}

		for (int l2 = 60; l2 < 80; l2++) {
			int i4 = rotateLeft(j, 5) + F60_79(k, l, i1) + j1 + W[l2];
			j1 = i1;
			i1 = l;
			l = rotateLeft(k, 30);
			k = j;
			j = i4;
		}

		hash[0] += j;
		hash[1] += k;
		hash[2] += l;
		hash[3] += i1;
		hash[4] += j1;
	}

	public void update(byte abyte0[], int i, int j) {
		int k = 64 - rest;
		count += j;
		if (rest > 0 && j >= k) {
			System.arraycopy(abyte0, i, buffer, rest, k);
			transform(buffer, 0);
			i += k;
			j -= k;
			rest = 0;
		}
		for (; j > 63; j -= 64) {
			transform(abyte0, i);
			i += 64;
		}

		if (j > 0) {
			System.arraycopy(abyte0, i, buffer, rest, j);
			rest += j;
		}
	}

	private int hash[];
	private int W[];
	private long count;
	private int rest;
	private byte buffer[];
	static byte padding[] = { -128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0 };

}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 187 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/