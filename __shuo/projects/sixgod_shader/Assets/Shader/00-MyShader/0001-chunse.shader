Shader"SixGodShader/0001 chunse"
{
    Properties{
        _Color("Color",Color)=(1,1,1,1)
    }
    SubShader{
        Pass
        {
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
            float4 vert(float4 vertex:POSITION):SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }
            fixed4 _Color;
            fixed4 frag():SV_TARGET
            {
                return _Color;
            }
            ENDCG
        }
    }
}