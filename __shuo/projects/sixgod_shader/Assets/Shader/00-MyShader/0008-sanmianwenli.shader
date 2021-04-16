Shader "SixGodShader/0008 sanmianwenli"
{
    //对于复杂网格或程序化网格，不使用常规 UV 坐标对它们进行纹理化，有时只需在三个主方向将纹理“投影”到对象上即可。
    //这称为“三面”纹理。这个想法是使用表面法线来加权三个纹理方向。
    Properties
    {
        _MainTex("Texture",2D)="white"{}
        _Tiling("Tiling",Float)=1.0
        _OcclusionMap("Occlusion",2D)="white"{}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

            struct v2f
            {
                half3 objNormal:TEXCOORD0;
                float3 coords:TEXCOORD1;
                float2 uv:TEXCOORD2;
                float4 pos:SV_POSITION;
            };
            float _Tiling;
            v2f vert(float4 pos:POSITION, float3 normal:NORMAL, float2 uv:TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(pos);
                o.coords = pos.xyz * _Tiling;
                o.objNormal = normal;
                o.uv = uv;
                return o;
            }
            sampler2D _MainTex;
            sampler2D _OcclusionMap;
            fixed4 frag(v2f i):SV_TARGET
            {
                half3 blend = abs(i.objNormal); //使用法线的绝对值作为纹理权重
                blend /= dot(blend, 1.0); //确保权重之和为 1（除以 x+y+z 之和）
                //针对 x、y、z 轴读取三个纹理投影
                fixed4 cx = tex2D(_MainTex, i.coords.yz);
                fixed4 cy = tex2D(_MainTex, i.coords.xz);
                fixed4 cz = tex2D(_MainTex, i.coords.xy);
                fixed4 c = cx * blend.x + cy * blend.y + cz * blend.z; //根据权重混合纹理
                c *= tex2D(_OcclusionMap, i.uv); //根据常规遮挡贴图进行调制
                return c;
            }

            ENDCG
        }
    }
}