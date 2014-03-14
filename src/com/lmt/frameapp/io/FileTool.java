package com.lmt.frameapp.io;

import com.lmt.frameapp.ARE;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileChannel.MapMode;

public class FileTool
{
  public static int bufferSize = 1024;
  public static boolean useNIO = false;

  public static void copy(String paramString1, String paramString2)
    throws IOException
  {
    copy(new File(paramString1), new File(paramString2), 0);
  }

  public static void copy(String paramString1, String paramString2, int paramInt)
    throws IOException
  {
    copy(new File(paramString1), new File(paramString2), paramInt);
  }

  public static void copy(File paramFile1, File paramFile2)
    throws IOException
  {
    copy(paramFile1, paramFile2, 0);
  }

  public static void copy(File paramFile1, File paramFile2, int paramInt)
    throws IOException
  {
    if (paramInt > 0)
      bufferSize = paramInt;
    paramFile2.createNewFile();
    if (useNIO)
      copyNIO(paramFile1, paramFile2);
    else
      copyIO(paramFile1, paramFile2);
  }

  private static void copyIO(File paramFile1, File paramFile2)
    throws IOException
  {
    FileInputStream localFileInputStream = new FileInputStream(paramFile1);
    FileOutputStream localFileOutputStream = new FileOutputStream(paramFile2);
    byte[] arrayOfByte = new byte[bufferSize];
    int i;
    while ((i = localFileInputStream.read(arrayOfByte)) > 0)
      localFileOutputStream.write(arrayOfByte, 0, i);
    localFileInputStream.close();
    localFileOutputStream.close();
  }

  private static void copyNIO(File paramFile1, File paramFile2)
    throws IOException
  {
    FileInputStream localFileInputStream = new FileInputStream(paramFile1);
    FileChannel localFileChannel1 = localFileInputStream.getChannel();
    FileOutputStream localFileOutputStream = new FileOutputStream(paramFile2);
    FileChannel localFileChannel2 = localFileOutputStream.getChannel();
    MappedByteBuffer localMappedByteBuffer = localFileChannel1.map(FileChannel.MapMode.READ_ONLY, 0L, paramFile1.length());
    localFileChannel2.write(localMappedByteBuffer);
    localFileInputStream.close();
    localFileOutputStream.close();
    localMappedByteBuffer = null;
  }

  public static File findFile(String paramString)
  {
    File localFile = new File(paramString);
    if (!localFile.exists())
    {
      ClassLoader localClassLoader = ARE.class.getClassLoader();
      URL localURL = localClassLoader.getResource(paramString);
      if (localURL != null)
        localFile = new File(localURL.getPath());
    }
    if (!localFile.exists())
      localFile = null;
    return localFile;
  }
}