#LifeSchedule


[TOC]


##1.项目准备

###1.1 Pod安装第三方框架(Use pod-SDWebImage、AFNetworking以及MBProgressHUD)
**Pod**现在已经成为主流的第三方框架的管理工具，其具体的详细流程我是follow这个[分享](https://www.cnblogs.com/chuancheng/p/8443677.html)来的。安装完成后，需要在每个工程目录下面都去touch一个Podfile，然后再Podfile里去编辑所需要用到的第三方框架的name，当然第三方框架的name要先通过pod serach '第三方框架name' 以保证第三方框架确实是在pod的库里面的。


###1.2 Xcode插件管理工具Alcatraz的安装
**Alcatraz(/'ælkə,træz/)**又称为**Package Manager**，这是xcode的一个插件管理库，但是遗憾的是，当前最新的Alcatraz并不能直接在xocde中使用，我按照简书论坛分享的一篇[博文](https://www.jianshu.com/p/802313c4199e)操作，最终成功安装。主要分为以下几部分
1> 复制一个xocde应用程序，并重新命名，对复制过来的xcode需要重新申请一个codeSign，用这个自己申请的codesign去绑定xocde，可能是为了突破一个限制吧
2> 然后再根据提示在Terminal里安装Alcatraz即可
3> 安装之后需要在Terminal里输入这段代码，才可以正常work，虽然我也不明白具体怎么回事
4> 打开xocde->Windows->Package Manager可以正常使用了
```
find ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins -name Info.plist -maxdepth 3 | xargs -I{} defaults write {} DVTPlugInCompatibilityUUIDs -array-add `defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID`
```


###1.3 搭建基本框架(UINavigationController + UITabBarController)




##2.问题
### 2.1 sourceTree该如何隐藏掉一些不需要上传的文件?
这个通常用来忽略掉一些类库文件，不需要进行特殊的处理，比如说pod install的一些framework，这些都不需要放入到git进行版本控制的可以参照下面[git忽略必要的文件](https://www.jianshu.com/p/e61111f69a8f)



##3.设计思路分析

###3.1 设置界面
我选择从最大众化的一个界面开始入手，主要是因为考虑到这个界面比较通用，这款app即然作为准备上线的项目，最重要的是能够提高代码的质量，包括重构技巧的运用，应该去探索该如何使用这种技巧，其实里面也涉及到了蛮多的知识点。

###3.2 具体设计过程
1. 因为这是一个UITableViewController，我们知道在创建UITableViewController这个阶段的时候，是可以在阶段去确定TableView的style ，其实talbeVIew的style从目前来看，可以分为两种类型，一种类型是plain，另一种类型时候group. **区别从最新的view上来看，group是默认将一个TableView按照section的设定进行划分的，并且ios系统已经给每个section都设定了相应的间距，而plain则是用户需要手动实现heightForFooterInSection、heightForHeaderInSection、viewForFooterInSection、viewForHeaderInSection这些方法，才能够实现不同的section之间能够有一定的间距。**

首先需要改变当前TableView的一个style，在SettingViewController.m方法中重写init方法，改变之后的图像如下图Default group style所示
```objectivec
- (instancetype)init{
    if (self = [super init]) {
        self = [self initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}
```
当我们发现Default group style的section的间距明显过大时，我们应该想办法去减小这个secton的间距。
```objectivec
/*设置Section Header高度为20.0f*/
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0f;
}

/*设置section Header的View以及该view的背景颜色*/
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20.0)];
    footerView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.8];
    return footerView;
}

/*很遗憾的是，我们必须加上下面这两段看上去没有任何作用的代码，他们的height是0，如果不写的话，会调用系统默认设定的sectionHeader以及viewForHeaderInSection*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    headerSectionView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.8];
    return headerSectionView;
}
```

![Alt text](./compareChanges.png)

2. 定义一个PCH file 


##4.具体设计


###4.1 设置界面


###4.2 番茄计时界面
**番茄计时**是指一个倒计时的界面，每次开始任务时，点击一下开始进入倒计时的场景，一般是25分钟，在这25分钟内应该专心致志完成需要完成的任务。时间到后，需要完成一个5分钟的休息时间，同样采用倒计时的场景。

####4.2.1 功能分析
1. 首先得有一个倒计时的界面，可以是那种一个圆，并且在里面自动转圈功能的
2. 重点考虑一下时间到达后，手机会发出怎么样的声音用来提示用户，比如说屏幕突然变亮，并且伴随着提示音，并且还有比较明显的震动。因为用户在专心致志的工作，不会一直看手机，因此语言提示+震动就显得至关重要。
3. 同理，休息的5分钟时间到达后，又该如何提醒用户

####4.2.2 更深入的功能分析
1. 第一次进入用户界面，不应该立即进行倒计时，需要得到客户的应允
2. 再进入到倒计时界面时，那个button应该是点击退出
3. 那个休息的界面，是只有当25分钟完成后会自动显示，同样，需要得到的客户的应允，才能进行下一步操作

####4.2.3 实现背景view颜色的渐变



####4.2.4 UIAlertViewController and  


####4.2.5 IOS响铃设置
####4.2.6 系统自带的响铃
这个其实是蛮简单的，每个系统的铃声都有一个唯一标识ID，一般只要以下几行代码就可实现
```objectivec
    SystemSoundID soundId = 1005;
    AudioServicesPlaySystemSound(soundId);//播放声音
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//静音模式下震动
```

####4.2.7 自定义系统铃声
1. 绑定微信小程序，关注讯飞快读，自定义文字朗读并保存，可以发送到自己的邮箱里。
2. 在Mac上将mac转化为caf格式
```
afconvert /Users/Mina/Desktop/1.mp3 /Users/Mina/Desktop/2.caf -d ima4 -f caff -v
```

####4.2.8 如何让timer在程序挂起时(或者说在锁屏状态下)下定时器继续运行？



###4.3 收件箱(最主要的界面)
遇到的问题：侧滑返回在返回时需要保存相应的数据，但是现在还不支持。


###4.4 日历界面(日历主界面)
 1. 最重要的是要能够研究如何做一个日历控件出来


##5. 设置界面

###5.1 About screen
唯一的有疑惑的地方是在这个title上面，需要进行字体的切换。可以参考简书上的一篇文章
[iOS App导入自定义字体](https://www.jianshu.com/p/b7f04f2a09d4)

###5.2 IOS AutoLayout学习
做好AutoLayout可以让app能够在不同的尺寸的手机上手机上进行很好的适配，所以autolayout还是相对比较重要的。

###5.3 反馈与建议
由于没有真正的server在后台作支撑，只能通过发送这些文件到指定的邮箱

