---
title: An Odessey of Push Notification to Untiy Mobile App
date: 2023-03-30 22:40:11
tags: [Unity, Android, iOS, Push Notification]
---

Push notification is a killer feature for engaging users and keeping them informed. In recent development of a mobile app, we integrate APNS(Apple Push Notification service) and FCM(Firebase Cloud Messaging) to our iOS/Android app based on Untiy after overcoming several obstacles which I want to share with you here.

<!--more-->

## 1 Choose the Right Package

Apparently, there are two packages in Unity world related to push notification with similar naming:

- [Push Notifications](https://docs.unity.com/push-notifications/en/manual/WhatArePushNotifications)
- [Mobile Notifications](https://docs.unity3d.com/Packages/com.unity.mobile.notifications@2.1/manual/index.html)

The **Push Notification** seems to be more uniformed and mordernised but built closely with [Unity Gaming Services](https://dashboard.unity3d.com/gaming/login?redirectTo=Lw==), which we do not want to connect with our app. So we choose the **Mobile Notification** package. But as mentioned in this Unity Forum question (which is followed by more than 150 developers but without a answer that satisfies them)

- [Is there a unified solution for push notifications on both iOS and Android?](https://answers.unity.com/questions/1690049/is-there-a-unified-solution-for-push-notifications.html)

The **mobile notification** package can handle local and remote notification for iOS. But for Android it just works in local notification, What a mess!

As we indeed need remote notification, we have to integerate the [FCM Unity Package](https://firebase.google.com/docs/cloud-messaging/unity/client) by ourselves (there are many tricky things like you must replace your main activity as one resides in FCM arr file and the AndroidManifest.xml has to be modified as described in FCM's docs). I strongly suspect that the Unity Team make the **Mobile Notification** difficult to use in order to make their **Mobile Notification** related **UGS** a better market share!

Until now, we can make the push notification (or more precisely, remote notification) work with the following steps:

- get device token
  - in iOS that is to ask for notification permission with **Mobile Notification** and get token from the result if granted, [here](https://docs.unity3d.com/Packages/com.unity.mobile.notifications@2.1/manual/iOS.html) is demo code
  - in Android that is to use **FCM** to get the device token (which can be done without permission grant, god knows why android has a differenct opinion about this permission with iOS)
- register device token to your notification service provider
  - the notification service provider is the proxy for APNS and FCM server, which unifies the calls to different plateforms
  - usually they hold a mapping of user id to device tokens, and messages will be routed to user device by this mapping
  - some choices like [leanplum](https://docs.leanplum.com/reference/unity-push-notifications)/[OneSignal](https://documentation.onesignal.com/docs/unity-sdk-setup)
- send message to the notification provider
  - and it will be routed to you users' devices as push notifications via APNS and FCM 

## 2 Extract the Customize Payload

One cool things in push notificaiton is that we can store whatever data we want in the notification, and thus different contents can be displayed to users corresponding to different push notification purposes when the app is opened by clicking notificaitons.

To achieve this, the first thing is to get the customize data in the notification when app gets back to foreground by clicking notification. In iOS this is quite straightforward as displayed in the [code](https://docs.unity3d.com/Packages/com.unity.mobile.notifications@1.4/manual/iOS.html):

```Csharp
var notification = iOSNotificationCenter.GetLastRespondedNotification();
if (notification != null)
{
    var msg = "Last Received Notification: " + notification.Identifier;
    msg += "\n - Notification received: ";
    msg += "\n - .Title: " + notification.Title;
    msg += "\n - .Badge: " + notification.Badge;
    msg += "\n - .Body: " + notification.Body;
    msg += "\n - .CategoryIdentifier: " + notification.CategoryIdentifier;
    msg += "\n - .Subtitle: " + notification.Subtitle;
    msg += "\n - .Data: " + notification.Data;
    Debug.Log(msg);
}
```

One tricky thing is that you need to know the exact field your notificaiton service provider used to store the customize data. For example, if it's stored in field `foo`, the data can be fetched by:

```Csharp
    n.UserInfo.TryGetValue("foo", out ext);
```

In android, things are more complicated as the **Mobile Notificaiton** doesn't support remote notification and there is a concept called `Intent` in android. We cannot get the notification and data as the demo code in **Mobile Notificaiton** [doc](https://docs.unity3d.com/Packages/com.unity.mobile.notifications@1.4/manual/Android.html):

```Csharp
var notificationIntentData = AndroidNotificationCenter.GetLastNotificationIntent();
if (notificationIntentData != null)
{
    var id = notificationIntentData.Id;
    var channel = notificationIntentData.Channel;
    var notification = notificationIntentData.Notification;
}
```

The code can only get data when user click notification triggered by local notification (it's a pitty). And for remote notificaiton in our case, we have to depends the `Intent` that passed to the Android main activity to get the data:

```Csharp
        AndroidJavaClass UnityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        AndroidJavaObject curActivity = UnityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
        AndroidJavaObject curIntent = curActivity.Call<AndroidJavaObject>("getIntent");
```

and the same as iOS to extract the `foo` data:

```Csharp
        ext = curIntent.Call<string>("getStringExtra", "ext");
```

## 3 Idempotent the Notification

Timing is important. It will be a good choice for us to check for the clicked notification when the app is back to foreground, this can be easily achieved via:

```Csharp
    private void OnApplicationFocus(bool hasFocus)
    {
        Debug.Log("OnApplicationFocus");
        if (!hasFocus)
        {
            // enter background
        }
        else
        {
            // back to foreground and check notifiaiton here
        }
    }
```

In my test, this is not called in app cold start on iOS, I have to add another hook

```Csharp
    [RuntimeInitializeOnLoadMethod]
    static void OnRuntimeMethodLoad()
    {
        // check notification here when app starts
    }
```

But in android, it's bad news to do so as one clicked notificaiton data will lead the code fetching it to be executed twice as well as the following logic code.

There are also other scenarios in which we can get repeate clicked notification data. For example, in Android, every time we put app background and foreground it again, we can get the `Intent` data that opened it at the very begining. It's obvious that we want to display content led by one clicked notificaiton only once.

I tried to find an unique identifier for every notification but it's difficult to do so. For example, I read the [Android Intent](https://developer.android.com/reference/android/content/Intent#getIdentifier()) doc and it said there is a api called `getIdentifier` (I'm happy), but was added after API level 29 (I'm sad).

In order to get ride of such historical nonscense, I chose to add an unique identifier in the notificaiton payload by myself and to make the clicked notificaiton consume process idempotently.

## 4 Make it Work in Android 13 

I test the above code in my iphone 14 and old LG android phone in the office and it worked perfectly. But when I was back home and test it with my Pixel with Android 13, the push notificaiton cannot be received and from the settings of the app I can see that the push notificaion permission is closed, which is weird as it is granted as default in Android.

Finally, I found the following descriptions from the **Mobile Notification** doc:

> Since Android 13.0 it is required to ask user permission to show notifications. When application targets SDK that is less than 33, operating system will ask for permission automatically when application is launched. When targetting SDK 33 or greater, it is up to application itself to ask for permission, otherwise notifications will not show up in the tray. 

Thanks for Android's attention to permission control after somany years, I have to add the following code to ask for notification on Android now:

```Csharp
IEnumerator RequestNotificationPermission()
{
    var request = new PermissionRequest();
    while (request.Status == PermissionStatus.RequestPending)
        yield return null;
    // here use request.Status to determine users response
}
```

## 5 Rock the Unity Bug

This part exists only because the permission dialog still doesn't appear yet. What I get in Android Studio Logcat is just a infinite loop saying that my app is switching between foreground and backgroud.

I searched the Internet and luckily to find the solution soon in the following post (which is still active in recent days):

- [Unity Forum - Unable to request notification permission in android 13](https://forum.unity.com/threads/unable-to-request-notification-permission-in-android-13.1346324/#post-8914318)

It turns out to be an unity bug (this is hinted by a guy in the post labeled as staff in Untiy Technologies). And the only thing I can do is to set the Android Target API level to 33. I tried, and it works now!
