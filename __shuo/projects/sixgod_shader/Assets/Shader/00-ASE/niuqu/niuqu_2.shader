// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "niuqu_2"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Distort("Distort", 2D) = "bump" {}
		_Circle01("Circle01", 2D) = "white" {}
		_Distrotstrength("Distrotstrength", Range( -1 , 1)) = 0.1025516
		_DistortRotateSpeed("DistortRotateSpeed", Float) = 3
		_MaskSizeBlur("MaskSizeBlur", Vector) = (1,0.3,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}


	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend One One
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				
				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
				#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_instancing
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_FRAG_COLOR


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					
				};
				
				
				#if UNITY_VERSION >= 560
				UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
				#else
				uniform sampler2D_float _CameraDepthTexture;
				#endif

				//Don't delete this comment
				// uniform sampler2D_float _CameraDepthTexture;

				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform float _InvFade;
				uniform float2 _MaskSizeBlur;
				uniform sampler2D _Circle01;
				uniform sampler2D _Distort;
				uniform float4 _Distort_ST;
				uniform float _Distrotstrength;
				uniform float _DistortRotateSpeed;


				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( i );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );

					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float2 appendResult19 = (float2(0.0 , _MaskSizeBlur.y));
					float2 break22_g1 = appendResult19;
					float2 uv02_g1 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float2 temp_cast_0 = (_MaskSizeBlur.x).xx;
					float smoothstepResult10_g1 = smoothstep( break22_g1.x , break22_g1.y , ( 1.0 - ( length( ( ( ( uv02_g1 - float2( 0.5,0.5 ) ) - float2( 0,0 ) ) / temp_cast_0 ) ) * 2.0 ) ));
					float2 uv08 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float2 uv_Distort = i.texcoord.xy * _Distort_ST.xy + _Distort_ST.zw;
					float3 tex2DNode2 = UnpackNormal( tex2D( _Distort, uv_Distort ) );
					float4 appendResult5 = (float4(tex2DNode2.r , tex2DNode2.g , 0.0 , 0.0));
					float cos10 = cos( ( _Time.y * _DistortRotateSpeed ) );
					float sin10 = sin( ( _Time.y * _DistortRotateSpeed ) );
					float2 rotator10 = mul( ( float4( uv08, 0.0 , 0.0 ) + ( appendResult5 * _Distrotstrength ) ).xy - float2( 0.5,0.5 ) , float2x2( cos10 , -sin10 , sin10 , cos10 )) + float2( 0.5,0.5 );
					

					fixed4 col = ( i.color * ( ( smoothstepResult10_g1 + 0.0 ) * tex2D( _Circle01, rotator10 ) ) );
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17800
298;207;1218;683;156.2755;168.1043;1.043462;True;False
Node;AmplifyShaderEditor.SamplerNode;2;-370.0893,53.2253;Inherit;True;Property;_Distort;Distort;0;0;Create;True;0;0;False;0;-1;6433ad4692b7d114f95eaccf8dfb9627;6433ad4692b7d114f95eaccf8dfb9627;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;5;-68.01843,72.7077;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-261.9016,316.4867;Inherit;False;Property;_Distrotstrength;Distrotstrength;2;0;Create;True;0;0;False;0;0.1025516;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;150.6439,-41.34081;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;172.4616,543.9474;Inherit;False;Property;_DistortRotateSpeed;DistortRotateSpeed;3;0;Create;True;0;0;False;0;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;12;72.11789,379.9806;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;140.9512,168.2571;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;18;347.7807,-281.756;Inherit;False;Property;_MaskSizeBlur;MaskSizeBlur;4;0;Create;True;0;0;False;0;1,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;9;378.0542,41.63289;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;400.6669,413.898;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;576.1693,-140.6924;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;15;624.6832,-334.7118;Inherit;False;DrawCycle;-1;;1;da3e28910c85df048a80c702465201ae;0;4;1;FLOAT2;0,0;False;19;FLOAT2;0,0;False;20;FLOAT2;1,1;False;21;FLOAT2;0,0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;10;580.218,180.0806;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;2.39;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;830.2512,99.1695;Inherit;True;Property;_Circle01;Circle01;1;0;Create;True;0;0;False;0;-1;a7ba4ab3dacca1f41b92de92749d7342;a7ba4ab3dacca1f41b92de92749d7342;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;16;897.5093,-163.7993;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1;1117.622,-221.3762;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1139.661,27.04766;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;1362.313,-89.69879;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1589.91,-83.9155;Float;False;True;-1;2;ASEMaterialInspector;0;7;niuqu_2;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;True;True;True;True;False;0;False;-1;False;True;2;False;-1;True;3;False;-1;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;0;False;False;False;False;False;False;False;False;False;False;True;0;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;5;0;2;1
WireConnection;5;1;2;2
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;9;0;8;0
WireConnection;9;1;6;0
WireConnection;13;0;12;2
WireConnection;13;1;14;0
WireConnection;19;1;18;2
WireConnection;15;20;18;1
WireConnection;15;21;19;0
WireConnection;10;0;9;0
WireConnection;10;2;13;0
WireConnection;3;1;10;0
WireConnection;16;0;15;0
WireConnection;17;0;16;0
WireConnection;17;1;3;0
WireConnection;4;0;1;0
WireConnection;4;1;17;0
WireConnection;0;0;4;0
ASEEND*/
//CHKSM=B2B29A4FA4CC9DCBEC5BA53E790E0FE817ABDC4B