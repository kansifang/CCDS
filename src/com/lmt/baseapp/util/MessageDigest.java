/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.util;

import java.security.NoSuchAlgorithmException;

import com.lmt.frameapp.lang.StringX;

public class MessageDigest
{

    public MessageDigest()
    {
    }

    public static byte[] getDigest(String algorithm, byte srcData[])
        throws NoSuchAlgorithmException
    {
        byte dgt[] = null;
        if(srcData == null)
            return dgt;
        if(algorithm == null)
            algorithm = "MD5";
        java.security.MessageDigest md = java.security.MessageDigest.getInstance(algorithm.toUpperCase());
        md.reset();
        md.update(srcData);
        dgt = md.digest();
        return dgt;
    }

    public static byte[] getDigest(String algorithm, String srcData)
        throws NoSuchAlgorithmException
    {
        if(srcData == null)
            return null;
        else
            return getDigest(algorithm, srcData.getBytes());
    }

    public static String getDigestAsLowerHexString(String algorithm, String srcData)
        throws NoSuchAlgorithmException
    {
        if(srcData == null)
            return null;
        else
            return StringX.bytesToHexString(getDigest(algorithm, srcData.getBytes()), false);
    }

    public static String getDigestAsUpperHexString(String algorithm, String srcData)
        throws NoSuchAlgorithmException
    {
        if(srcData == null)
            return null;
        else
            return StringX.bytesToHexString(getDigest(algorithm, srcData.getBytes()), true);
    }

    public static String getDigestAsLowerHexString(String algorithm, byte srcData[])
        throws NoSuchAlgorithmException
    {
        return StringX.bytesToHexString(getDigest(algorithm, srcData), false);
    }

    public static String getDigestAsUpperHexString(String algorithm, byte srcData[])
        throws NoSuchAlgorithmException
    {
        return StringX.bytesToHexString(getDigest(algorithm, srcData), true);
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS_PRODUCT\WebRoot\WEB-INF\lib\are-1.0b88-m1_g.jar
	Total time: 251 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/