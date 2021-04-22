Shader "SixGodSdf/0002 line" {
   Properties {
       _Point1_X("Point1_X", Range(0,1)) = 0.2
       _Point1_Y("Point1_Y", Range(0,1)) = 0.5
       _Point2_X("Point2_X", Range(0,1)) = 0.7
       _Point2_Y("Point2_Y", Range(0,1)) = 0.5
   }
   SubShader
   {
        Tags {
            "Queue"="AlphaTest" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent"
        }
      pass
      {
         Zwrite Off

         CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
     
         float _Point1_X;
         float _Point1_Y;
         float _Point2_X;
         float _Point2_Y;

         struct a2v {
            float4 vertex : POSITION;
            float4 uv : TEXCOORD0;
         };
         struct v2f {
            float4  pos : SV_POSITION;
            float2  uv : TEXCOORD0;
         };

         v2f vert (a2v v)
         {
            v2f f;
            f.pos = UnityObjectToClipPos(v.vertex);
            f.uv = v.uv;
            return f;
         }
         
         fixed4 frag (v2f f) : SV_TARGET
         {
            fixed2 ap = f.uv.xy - fixed2(_Point1_X, _Point1_Y); //A->P向量
            fixed2 ab = fixed2(_Point2_X, _Point2_Y) - fixed2(_Point1_X, _Point1_Y);//A->B向量
            float h = clamp(dot(ap, ab) / dot(ab, ab), 0, 1); //系数h A点为向量起始 A左侧、B右侧区域系数为0 AB间区域系数为AP投影比例
            fixed len = (1 - min(length(ap - ab * h), 1));
            fixed4 c = fixed4(len, len, len, 1);
            return c;
         }

         ENDCG
      }
   }
}