Shader "SixGodShader/0002 wanggefaxian"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
// 包含 UnityObjectToWorldNormal helper 函数的 include 文件
#include "UnityCG.cginc"

            struct v2f
            {
                half3 worldNormal:TEXCOORD0;
                float4 pos:SV_POSITION;
            };//结构体分号！！！
            v2f vert(float4 vertex:POSITION, float3 normal:NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.worldNormal = UnityObjectToWorldNormal(normal); //UnityCG.cginc 法线从对象 变换到 世界空间
                return o;
            }
            fixed4 frag(v2f i):SV_Target
            {
                fixed4 c = 0;
                c.rgb = i.worldNormal*0.5+0.5;
                return c;
            }
            ENDCG
        }
    }
}