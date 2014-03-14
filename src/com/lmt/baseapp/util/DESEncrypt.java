/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.util;

import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

import com.lmt.frameapp.ARE;

public class DESEncrypt
{

    public DESEncrypt()
    {
    }

    public static byte[] encrypt(byte abyte0[])
    {
        return encrypt(abyte0, 1);
    }

    public static byte[] decrypt(byte abyte0[])
    {
        return encrypt(abyte0, 2);
    }

    public static String encrypt(String s)
    {
        StringBuffer stringbuffer = new StringBuffer(1024);
        byte abyte0[] = encrypt(s.getBytes(), 1);
        if(abyte0 == null || abyte0.length < 1)
            return null;
        Random random = new Random(s.length());
        for(int i = 0; i < abyte0.length; i++)
        {
            char c = (char)(random.nextInt(10) + 71);
            stringbuffer.append(c);
            if(abyte0[i] < 0)
            {
                char c1 = (char)(random.nextInt(10) + 81);
                abyte0[i] = (byte)(-abyte0[i]);
                stringbuffer.append(c1);
            }
            stringbuffer.append(Integer.toString(abyte0[i], 16).toUpperCase());
        }

        stringbuffer.deleteCharAt(0);
        return stringbuffer.toString();
    }

    public static String decrypt(String s)
    {
        if(s.length() < 1)
            return null;
        String as[] = s.split("[G-Pg-p]");
        byte abyte0[] = new byte[as.length];
        for(int i = 0; i < abyte0.length; i++)
        {
            char c = as[i].charAt(0);
            if(c >= 'Q' && c <= 'Z' || c >= 'q' && c <= 'z')
                abyte0[i] = (byte)(-Byte.parseByte(as[i].substring(1), 16));
            else
                abyte0[i] = Byte.parseByte(as[i], 16);
        }

        byte abyte1[] = encrypt(abyte0, 2);
        if(abyte1 == null || abyte1.length < 1)
            return null;
        else
            return new String(abyte1);
    }

    private static byte[] encrypt(byte abyte0[], int i)
    {
        byte abyte2[] = {
            -57, 115, 33, -116, 126, -56, -18, -103
        };
        byte abyte1[];
        try
        {
            SecretKeyFactory secretkeyfactory = SecretKeyFactory.getInstance("DES");
            DESKeySpec deskeyspec = new DESKeySpec(abyte2);
            javax.crypto.SecretKey secretkey = secretkeyfactory.generateSecret(deskeyspec);
            Cipher cipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
            cipher.init(i, secretkey);
            abyte1 = cipher.doFinal(abyte0);
        }
        catch(Exception exception)
        {
            ARE.getLog().debug("DES Ecrypt error", exception);
            abyte1 = null;
        }
        return abyte1;
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 193 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/