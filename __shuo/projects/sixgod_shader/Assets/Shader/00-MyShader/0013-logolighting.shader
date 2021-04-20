Shader "SixGodShader/0013 logolighting" {
   Properties {
      _MainTex("Texture", 2D) = "white" {}
      _Color("Color", Color) = (0,0,0,0)
      _Angle("Angle", Range(0, 180)) = 92
      _Interval("Interval", Range(1, 20)) = 4
      _Weight("Weight", Range(0.01, 0.5)) = 0.15
      _CycleTime("Cycle Time", Range(0.1, 3)) = 2
      _Offset("Offset", Range(0,1)) = 0.15
   }
   SubShader
   {
      Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
      Blend SrcAlpha OneMinusSrcAlpha 
      AlphaTest Greater 0.1
      pass
      {
         CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
     
         sampler2D _MainTex;
         fixed4 _Color;
         float4 _MainTex_ST;
         float _Angle;
         float _Interval;
         float _Weight;
         float _CycleTime;
         float _Offset;
         
         struct a2v {
            float4 vertex : POSITION;
            float4 texcoord : TEXCOORD0;
         };
         struct v2f {
            float4  pos : SV_POSITION;
            float2  uv : TEXCOORD0;
         };
      
         //顶点函数没什么特别的，和常规一样
         v2f vert (a2v v)
         {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
            return o;
         }
         
         //必须放在使用其的 frag函数之前，否则无法识别。
         //核心：计算函数，角度，uv,光带的x长度，间隔，开始时间，偏移，单次循环时间
         float inFlash(float angle,float2 uv,float xLength,int interval,int beginTime, float offX, float loopTime )
         {
             
            float brightness = 0; //亮度值  越靠中心越亮
            float angleInRad = 0.0174444 * angle; //倾斜角
            
            float currentTime = _Time.y; //当前时间
         
            //本周期  光照起始时间  采用取整方式
            int currentTimeInt = currentTime/interval;
            currentTimeInt *= interval;
            
            //本周期  光照所在时间
            float currentTimePassed = currentTime - currentTimeInt;
            if(currentTimePassed > beginTime)
            {
               //底部左边界和右边界
               float xBottomLeftBound;
               float xBottomRightBound;

               //此点边界
               float xPointLeftBound;
               float xPointRightBound;
               
               float x0 = currentTimePassed - beginTime;
               x0 /= loopTime;
         
               //设置右，左边界
               xBottomRightBound = x0;
               xBottomLeftBound = x0 - xLength;
               
               //投影至x的长度 = y / tan(angle)
               float xProjL;
               xProjL= uv.y / tan(angleInRad);

               //此点的左边界 = 底部左边界 - 投影至x的长度
               xPointLeftBound = xBottomLeftBound - xProjL;
               //此点的右边界 = 底部右边界 - 投影至x的长度
               xPointRightBound = xBottomRightBound - xProjL;
               
               //边界加上一个偏移
               xPointLeftBound += offX;
               xPointRightBound += offX;
               
               //如果该点在区域内
               if(uv.x > xPointLeftBound && uv.x < xPointRightBound)
               {
                  //得到发光区域的中心点
                  float midness = (xPointLeftBound + xPointRightBound) / 2;
                   
                  //趋近中心点的程度，0表示位于边缘，1表示位于中心点
                  float rate = (xLength - 2*abs(uv.x - midness)) / (xLength);
                  brightness = rate;
               }
            }
            brightness = max(brightness,0);
            
            return brightness;
         }
         
         float4 frag (v2f i) : COLOR
         {
            float4 outp;
             
            //根据uv取得纹理颜色，和常规一样
            float4 texCol = tex2D(_MainTex, i.uv);
     
            //传进i.uv等参数，得到亮度值
            float tmpBrightness;
            tmpBrightness = inFlash(_Angle, i.uv, _Weight, _Interval + _CycleTime, 0, _Offset, _CycleTime);
            outp = texCol + _Color * tmpBrightness;
            
            return outp;
         }

         ENDCG
      }
   }
}