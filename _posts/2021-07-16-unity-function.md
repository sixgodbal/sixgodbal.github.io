---
layout: post
title:  "Unity_function"
date:   2021-07-15 12:10:54
categories: Unity
tags: 编程
excerpt: true
---


* content
{:toc}


# 功能相关

### 1.Scale With Screen Size模式下，图片保持比例占满全屏

```
local screenWidth = CS.UnityEngine.Screen.width
	local screenHeight = CS.UnityEngine.Screen.height
	local screenAspectRatio = screenWidth / screenHeight
	UIVirtualAds.rawImage:SetNativeSize()
	local cameraWidth = 1920
	local cameraHeight = 1080
	local cameraAspectRatio = cameraWidth / cameraHeight
	local imageAspectRatio = UIVirtualAds.rawImageRect.sizeDelta.x / UIVirtualAds.rawImageRect.sizeDelta.y
	
	local W = cameraWidth
	local H = cameraHeight
	local mRate = cameraWidth / screenWidth
	if cameraAspectRatio >= screenAspectRatio then
		mRate = cameraWidth / screenWidth
		W = cameraWidth
		H = screenHeight * mRate
	else
		mRate = cameraHeight / screenHeight
		W = screenWidth * mRate
		H = cameraHeight
	end

	if imageAspectRatio >= screenAspectRatio then
		--以高对齐
		UIVirtualAds.rawImageRect.sizeDelta = LuaUtils.GetVector2(W * imageAspectRatio * mRate, H)
	else
		--以宽对齐
		UIVirtualAds.rawImageRect.sizeDelta = LuaUtils.GetVector2(W, W / imageAspectRatio * mRate)
	end
```

