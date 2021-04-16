// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/SkyReflection Per Pixel"
{
    Properties {
        // 材质上的法线贴图纹理，
        // 默认为虚拟的 "平面表面" 法线贴图
        _BumpMap("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                float3 worldPos : TEXCOORD0;
                // 这三个矢量将保持一个 3x3 旋转矩阵，
                // 此矩阵进行从切线到世界空间的转换
                half3 tspace0 : TEXCOORD1; // tangent.x, bitangent.x, normal.x
                half3 tspace1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
                half3 tspace2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
                // 法线贴图的纹理坐标
                float2 uv : TEXCOORD4;
                float4 pos : SV_POSITION;
            };

            // 顶点着色器现在还需要每顶点切线矢量。
            // 在 Unity 中，切线为 4D 矢量，其中使用 .w 分量
            // 指示双切线矢量的方向。
            // 我们还需要纹理坐标。
            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL, float4 tangent : TANGENT, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                half3 wNormal = UnityObjectToWorldNormal(normal);
                half3 wTangent = UnityObjectToWorldDir(tangent.xyz);
                // 从法线和切线的交叉积计算双切线
                half tangentSign = tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
                // 输出切线空间矩阵
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                o.uv = uv;
                return o;
            }

            // 来自着色器属性的法线贴图纹理
            sampler2D _BumpMap;
        
            fixed4 frag (v2f i) : SV_Target
            {
                // 对法线贴图进行采样，并根据 Unity 编码进行解码
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));
                // 将法线从切线变换到世界空间
                half3 worldNormal;
                worldNormal.x = dot(i.tspace0, tnormal);
                worldNormal.y = dot(i.tspace1, tnormal);
                worldNormal.z = dot(i.tspace2, tnormal);

                // 与在先前的着色器中处于相同的位置
                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                half3 worldRefl = reflect(-worldViewDir, worldNormal);
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                fixed4 c = 0;
                c.rgb = skyColor;
                return c;
            }
            ENDCG
        }
    }
}