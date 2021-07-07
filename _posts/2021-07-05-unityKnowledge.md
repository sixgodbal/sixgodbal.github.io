---
layout: post
title:  "unityKnowedge"
date:   2021-07-05 14:27:54
categories: UnityShader
tags: 编程
excerpt: true
---


* content
{:toc}
#### 1.检测Raycast脚本（[雨松Mono](https://www.xuanyusong.com/archives/4291) ）

```
#if UNITY_EDITOR
using UnityEngine;
using UnityEngine.UI;
public class DebugUILine : MonoBehaviour
{
    static Vector3[] fourCorners = new Vector3[4];
    void OnDrawGizmos() {
        foreach (MaskableGraphic g in GameObject.FindObjectsOfType<MaskableGraphic>()){
            if (g.raycastTarget) {
                RectTransform rectTransform = g.transform as RectTransform;
                rectTransform.GetWorldCorners(fourCorners);
                Gizmos.color = Color.blue;
                for (int i = 0; i < 4; i++)
                    Gizmos.DrawLine(fourCorners[i], fourCorners[(i + 1) % 4]);
            }
        }
    }
}
#endif
```

#### 2.关闭Editor（[雨松Mono](https://www.xuanyusong.com/archives/4578) ）

    using UnityEditor;
    public class Test {
        [InitializeOnLoadMethod]
        static void InitializeOnLoadMethod() {
            EditorApplication.wantsToQuit -= Quit;
            EditorApplication.wantsToQuit += Quit;
        }
        static bool Quit() {
            EditorUtility.DisplayDialog("我就是不让你关", "就是不让你关", "不让关");
            return false; //return true表示可以关闭unity编辑器
        }
    }
