# XYQPlayer
## 音视屏播放框架XYQPlayer，支持播放、暂停、缓存

## 一、前缀

     一直都想好好学学音视频这方面的知识，抽了几个周末参考一些资料，尝试着写了一个简易的音视频播放框架，支持音视频播放、视频截图、音乐缓存，其实吧，也就 是尽可能的封装罢了，方便以后自己使用。目前只是开始，可能有些不足，后续会继续优化。可以在github上下载，地址是https://github.com/xiayuanquan/XYQPlayer ，当然也请多多关注本博主夏远全：http://www.cnblogs.com/XYQ-208910/p/6685412.html。 
     
     概念参考我的这篇博文：http://www.cnblogs.com/XYQ-208910/p/5662655.html 
     
     我的简书地址：http://www.jianshu.com/p/1f8f434cfcba

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

3、依赖

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/framework1.png)

## 三、音乐播放和缓存逻辑

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/music4.png)

## 四、视频播放方式

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/movie.png)

## 五、音频播放test

    #import "PlayMusicViewController.h"
    #import "XYQAllHeader.h"
    @interface PlayMusicViewController ()
    @property (strong,nonatomic)XYQAudioToolView *audioPlayerView;
    @end
    
    @implementation PlayMusicViewController

    - (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
        //1、网络音乐(此处需要给出准确的url，我的这个不可以用，只是给个参考的样式)
        //[self testPlay_Local_URL_Music:@[@"http://120.25.226.186:32812/xxx/minion_02.mp3"]];
    
        //2、本地音乐
        [self testPlay_Bundle_Music:[self musicArray]];
    }

    //测试创建音乐播放器(播放沙盒本地音乐包括从网络音乐下载缓存)
    - (void)testPlay_Local_URL_Music:(NSArray *)musicFileLinkArray{
    
        self.audioPlayerView = [XYQAudioToolView openAudioPlayerView:musicFileLinkArray  audioPlayerViewController:self];
        self.audioPlayerView.diskIsHide = YES;
    }

    //测试创建音乐播放器(播放bundle根目录下的音乐)
    - (void)testPlay_Bundle_Music:(NSArray *)musicNameArray{
    
        self.audioPlayerView = [XYQAudioToolView openAudioPlayerView:musicNameArray  audioPlayerViewController:self];
        self.audioPlayerView.diskIsHide = YES;
    }

    //Bundle根目录子下所有的音乐文件名
    - (NSArray *)musicArray{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Musics" ofType:@"plist"];
        NSArray *musicNameArr = [NSArray arrayWithContentsOfFile:path];
        return musicNameArr;
    }

    //关闭播放器
    -(void)viewWillDisappear:(BOOL)animated{
        [super viewWillDisappear:animated];
        [self.audioPlayerView dismissAudioPlayerView];
    }

## 六、视频播放test

    #import "PlayMovieViewController.h"
    #import "XYQAllHeader.h"

    @implementation PlayMovieViewController

    - (void)viewDidLoad {
       [super viewDidLoad];
       self.view.backgroundColor = [UIColor whiteColor];
    
       //1、push视频
       [XYQMovieTool pushPlayMovieWithNetURL:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" viewController:self];
    }

    -(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
       //2、present视频
       //[XYQMovieTool presentPlayMovieWithNetURL:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" viewController:self];
    }

    //关闭播放器
    -(void)viewWillDisappear:(BOOL)animated{
        [super viewWillDisappear:animated];
         [XYQMovieTool cancelPlay];
    }
    @end
    
    
## 七、cocoaPods支持

    pod  'XYQPlayer', '~> 1.0.0'

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/pod.png)


## 八、演示截图

### 1、音乐

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/muisc2.png)

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/music.png)

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/muisc1.png)

### 2、视频

#### push

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/push.png)

#### present

![image](https://github.com/xiayuanquan/XYQPlayer/blob/master/XYQPlayerExample/XYQPlayer/screenshot/present.png)
