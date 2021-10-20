## Flutter Aop Demo
该项目是在阿里开源项目aspectd基础上进行更改

其中全埋点是参考大佬文章实现的
[Flutter之全埋点思考与实现](https://juejin.cn/post/6892371163859976199#heading-3)

目前已适配的版本是1.22.5和2.2.3

## 运行项目
熟悉阿里开源项目aspectd如何运行可略过

1. 确保Flutter SDK是1.22.5或2.2.3
2. 找到Flutter SDK，执行以下命令

```
git apply --3way xxx/xxx/aspectd/0001-aspectd.patch
```
0001-aspectd.patch该文件在当前项目下

3. 删除原有flutter sdk目录下的缓存文件

```
rm bin/cache/flutter_tools.stamp
```

4. 重新构建新的flutter编译工具

```
flutter doctor -v
```

5. 下载Dart SDK源码，并切到1.22.5或2.2.3分支，并在项目中进行指定：

```
dependency_overrides:
  kernel:
    path: /Users/wenxuemao/custom/flutter/xianyuDartSdk/sdk/pkg/kernel
```
下载不下来的可以参考文章：https://www.jianshu.com/p/420fcfeecbb4

6. 在aspectd项目下执行pub get
7. 切到aspectd_impl目录下执行pub get
8. 切到example目录下执行pub get
9. 在example目录下运行项目

```
flutter run --debug --verbose
```



## 全埋点
在flutter页面点击的时候获取到我们点击的内容

效果如下：
![image](111.png)

## 全局生命周期
当我们在做性能收集时，需要全局的知道哪个页面目前在展示，哪个页面关闭了，从而做一些收集工作，在Android中我们可以通过registerActivityLifecycleCallbacks来得到任何一个正在展示页面的生命周期

而在Flutter中并没有提供类似方式，当然我们可以通过一个一个页面的监听，但这样侵入性太强了，我们可以使用aspectd来hook具体执行方法实现生命周期监听。

效果如下：
![image](flutter_lifecycle.gif)
