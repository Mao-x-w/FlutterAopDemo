import 'package:aspectd/aspectd.dart';
import 'package:aspectd_impl/hook_impl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

@Aspect()
@pragma("vm:entry-point")
class ClickAopHook {
  @pragma("vm:entry-point")
  ClickAopHook();

  @Execute("package:flutter/src/gestures/binding.dart", "GestureBinding",
      "-dispatchEvent")
  @pragma("vm:entry-point")
  dynamic hookHitTest(PointCut pointCut) {
    PointerEvent pointEvent = pointCut.positionalParams[0];
    HitTestResult hitTestResult = pointCut.positionalParams[1];
    if (pointEvent is PointerUpEvent) {
      for(HitTestEntry hitTestEntry in hitTestResult.path){
        if(hitTestEntry.target is RenderObject){
          HookImpl.getInstance().hookHitTest(hitTestEntry, pointEvent);
          break;
        }
      }
    }
    return pointCut.proceed();
  }

  @Execute("package:flutter/src/gestures/recognizer.dart", "GestureRecognizer",
      "-invokeCallback")
  @pragma("vm:entry-point")
  dynamic hookInvokeCallback(PointCut pointCut) {
    dynamic result = pointCut.proceed();
    dynamic eventName = pointCut.positionalParams[0];
    print("GestureRecognizer：：：：：invokeCallback");
    HookImpl.getInstance().hookClick(eventName);
    return result;
  }

  @Execute("package:flutter/src/widgets/framework.dart", "RenderObjectElement",
      "-mount")
  @pragma('vm:entry-point')
  void hookElementMount(PointCut pointCut) {
    pointCut.proceed();
    Element element = pointCut.target;
    //release和profile模式创建这个属性
    if (kReleaseMode || kProfileMode) {
      element.renderObject.debugCreator = DebugCreator(element);
    }
  }

  @Execute('package:flutter/src/widgets/framework.dart', 'RenderObjectElement',
      '-update')
  @pragma('vm:entry-point')
  void hookElementUpdate(PointCut pointCut) {
    pointCut.proceed();
    Element element = pointCut.target;
    //release和profile模式创建这个属性
    if (kReleaseMode || kProfileMode) {
      element.renderObject.debugCreator = DebugCreator(element);
    }
  }
}
