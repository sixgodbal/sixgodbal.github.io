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
            fixed2 pa = f.uv.xy - fixed2(_Point1_X, _Point1_Y); //A->P的向量
            fixed2 ba = fixed2(_Point2_X, _Point2_Y) - fixed2(_Point1_X, _Point1_Y);
            float h = clamp(dot(pa, ba) / dot(ba, ba), 0, 1); //clamp 值限制在[0,1]之间
            fixed len = (1 - min(length(pa - ba * h), 1)) * 1.2;
            fixed4 c = fixed4(len, len, len, 1);
            //log10fixed4 c = fixed4(1, 1, 1, 1);
            return c;
         }

         ENDCG
      }
   }
}