---
title: 基于TCP的局域网文件复制
date: 2018-04-17 21:53:52
reward: true
toc: true
tags: 
    - Java
---
依稀记得以前有个软件叫做“茄子快传”，是一款基于局域网进行文件传输的工具，但是APP开发商使劲儿往自己的应用里塞进了一堆累赘的功能，让我逐渐失去了对它的爱。借着Java的东风，俺自己也来实现一个局域网文件传输工具。
<!--more-->
由于我想实现的是自己电脑和手机之间的文件传输（手机端用Java N-IDE运行接收程序），于是采用更为可靠的TCP来实现。又由于传输的文件可能是多媒体文件，所以不采用字符流传输，而采用字节流。根据上一篇博文《Java IO-文件及其操作》的测试结果，采用最快的BufferedI/OStream with byte[]，


发送端代码如下：

```java
import java.util.Scanner;

public class Send {
    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);

        //计算机名、局域网中IP都可以
        System.out.print("请输入对方的计算机名：");
        String des = scanner.nextLine();

        //要传输的文件路径，如果是win段要用\\分隔，android端用/分隔
        System.out.print("请输入文件路径：");
        String file = scanner.nextLine();

        new Thread(new FileSender(des, file)).start();
    }
}
```

```java
import java.io.*;
import java.net.Inet4Address;
import java.net.Socket;
import java.net.UnknownHostException;

public class FileSender implements Runnable{

    String des;
    String file;

    public FileSender(String des, String file){
        this.des = des;
        this.file = file;
    }

    @Override
    public void run() {
        try (Socket socket = new Socket(Inet4Address.getByName(des), 4399)) {

            System.out.println("TCP连接成功....");
            BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));

            OutputStream outputStream = socket.getOutputStream();
            BufferedOutputStream out = new BufferedOutputStream(outputStream);

            byte[] buff = new byte[2048];

            int len;
			int mBytes = 0;
			int bytes = 0;
            while((len = in.read(buff)) != -1){
                out.write(buff, 0, len);
                bytes = bytes + len;
				mBytes = bytes / 1048576;
				if (bytes % 1048576 == 0)
					System.out.println("已发送" + mBytes + "MB");
            }

			out.close();
            in.close();
			System.out.println("发送完成....");

        } catch (UnknownHostException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

接收端代码如下：

```java
import java.util.Scanner;

public class Receive {
    public static void main(String[] args) {

        System.out.print("请输入文件保存路径：");
        Scanner scanner = new Scanner(System.in);

        String file = scanner.nextLine();

        new Thread(new FileReceiver(file)).start();
    }
}
```


```java
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class FileReceiver implements Runnable{

    String file;

    public FileReceiver(String file) {
        this.file = file;
    }

    @Override
    public void run() {
        try (ServerSocket serverSocket = new ServerSocket(4399)) {

            System.out.println("TCP正在连接....");
            Socket socket = serverSocket.accept();
            System.out.println("TCP连接成功....");

            InputStream inputStream = socket.getInputStream();
            BufferedInputStream in = new BufferedInputStream(inputStream);

            BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(file));

            byte[] buff = new byte[8192];
            int len = -1;
			int mBytes = 0;
			int bytes = 0;

            while((len = in.read(buff)) != -1) {
                out.write(buff, 0, len);

				bytes = bytes + len;
				mBytes = bytes / 1048576;
				if (bytes % 1048576 == 0)
					System.out.println("已接收" + mBytes + "MB");
            }

			out.close();
			in.close();
            socket.close();

			System.out.println("文件接收完成");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

```