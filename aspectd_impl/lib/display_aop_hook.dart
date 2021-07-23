import 'package:aspectd/aspectd.dart';
import 'package:aspectd_impl/hook_impl.dart';
import 'package:flutter/material.dart';

@Aspect()
@pragma("vm:entry-point")
class DisplayAopHook {
  @pragma("vm:entry-point")
  DisplayAopHook();

  @Execute(
      "package:flutter/src/widgets/navigator.dart", "_RouteEntry", "-handleAdd")
  @pragma("vm:entry-point")
  void _handleAdd(PointCut pointCut) {
    print("++++_handleAdd++++");
    dynamic target = pointCut.target;
    dynamic previousRoute = pointCut.namedParams["previousPresent"];
    pointCut.proceed();
    HookImpl.getInstance().handlePush(target.route,previousRoute);
  }

  @Execute(
      "package:flutter/src/widgets/navigator.dart", "_RouteEntry", "-handlePush")
  @pragma("vm:entry-point")
  void _handlePush(PointCut pointCut) {
    print("++++_handlePush++++");
    pointCut.proceed();
    dynamic target = pointCut.target;
    dynamic previousRoute= pointCut.namedParams["previousPresent"];
    HookImpl.getInstance().handlePush(target.route,previousRoute);
  }

  @Execute("package:flutter/src/scheduler/binding.dart", "SchedulerBinding",
      "-handleDrawFrame")
  @pragma("vm:entry-point")
  void _handleDrawFrame(PointCut pointCut) {
    print("++++_handleDrawFrame++++");
    pointCut.proceed();
    HookImpl.getInstance().handleDrawFrame();
  }

  @Execute("package:flutter/src/material/page.dart",
      "MaterialRouteTransitionMixin", "-buildPage")
  @pragma("vm:entry-point")
  dynamic _buildPage(PointCut pointCut) {
    print("++++_buildPage++++");
    Route target = pointCut.target;
    Semantics widgetResult = pointCut.proceed();
    HookImpl.getInstance().buildPage(
        target, widgetResult.child, pointCut.positionalParams[0]);
    return widgetResult;
  }

  @Execute("package:flutter/src/cupertino/route.dart",
      "CupertinoRouteTransitionMixin", "-buildPage")
  @pragma("vm:entry-point")
  dynamic _cupertinoBuildPage(PointCut pointCut) {
    print("++++_cupertinoBuildPage++++");
    Route target = pointCut.target;
    Semantics widgetResult = pointCut.proceed();
    HookImpl.getInstance().buildPage(
        target, widgetResult.child, pointCut.positionalParams[0]);
    return widgetResult;
  }

  @Execute(
      "package:flutter/src/widgets/navigator.dart", "_RouteEntry", "-handlePop")
  @pragma("vm:entry-point")
  void _handlePop(PointCut pointCut) {
    print("++++handlePop++++");
    dynamic target = pointCut.target;
    dynamic previousPresent = pointCut.namedParams["previousPresent"];
    pointCut.proceed();
    HookImpl.getInstance().handlePop(target.route, previousPresent);
  }

  @Execute(
      "package:lifecycle_detect/lifecycle_detect.dart", "LifecycleDetect", "-onActivityResumed")
  @pragma("vm:entry-point")
  void _onActivityResumed(PointCut pointCut) {
    print("++++onActivityResumed++++");
    pointCut.proceed();
    HookImpl.getInstance().onActivityResumed();
  }

  @Execute(
      "package:lifecycle_detect/lifecycle_detect.dart", "LifecycleDetect", "-onActivityPaused")
  @pragma("vm:entry-point")
  void _onActivityPaused(PointCut pointCut) {
    print("++++onActivityPaused++++");
    pointCut.proceed();
    HookImpl.getInstance().onActivityPaused();
  }
}
