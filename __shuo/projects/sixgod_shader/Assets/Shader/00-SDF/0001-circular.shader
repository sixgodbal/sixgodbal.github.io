Shader "SixGodSdf/0001-circular" {
   Properties {
       _CycleX("CycleX", Range(0,1)) = 0.5
       _CycleY("CycleY", Range(0,1)) = 0.5
       _Radius("Radius", Range(-1, 1)) = 0.2
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
     
         float _CycleX;
         float _CycleY;
         float _Radius;

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
            fixed distance = (1 - min(1, length(f.uv.xy - fixed2(_CycleX, _CycleY)) - _Radius));
            clip(1 - distance);
            fixed4 c = fixed4(distance, distance, distance, 0);
            return c;
         }

         ENDCG
      }
   }
}