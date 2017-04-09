# XYQPlayer
## 音视屏播放框架XYQPlayer，支持播放、暂停、缓存

## 一、前缀

     一直都想好好学学音视频这方面的知识，抽了几个周末参考一些资料，尝试着写了一个简易的音视频播放框架，支持音视频播放、视频截图、音乐缓存，其实吧，也就 是尽可能的封装罢了，方便以后自己使用。目前只是开始，可能有些不足，后续会继续优化。可以在github上下载，地址是https://github.com/xiayuanquan/XYQPlayer，当然也请多多关注本博主夏远全。

## 二、框架

1、截图 

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/framework.png)

2、文件

    XYQAllHeader.h：所有的头文件
    
    XYQAudioTool.h/m：音频播放工具类，播放包括短音频和音乐
    
    XYQAudioToolView.h/m：音频播放界面类，显示播放音乐的界面，播放、暂停、光盘旋转
    
    XYQAudioToolLoader.h/m：音频下载类，缓存音乐到本地
    
    XYQMovieTool.h/m：视频播放工具类，直接显示播放界面、还有截屏功能
    
    XYQHUDView.h/m：弹框提示，包括文本提示、下载进度提示
    
    XYQTimeProgress.h/m：音乐播放时间进度条
    
    UIImage+XYQCornerRadius.h/m：对图片进行处理的类
    
    Source.bundle：资源包，存放图片icon
