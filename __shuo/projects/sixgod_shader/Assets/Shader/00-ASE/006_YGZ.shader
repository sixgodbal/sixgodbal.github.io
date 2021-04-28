// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Progress("Progress", Range( 0 , 1)) = 0

	}


	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
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
				uniform float _Progress;


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

					float2 break22_g1 = float2( 0,0.05 );
					float2 uv05 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float smoothstepResult10_g1 = smoothstep( break22_g1.x , break22_g1.y , ( 1.0 - ( length( ( ( ( uv05 - float2( 0.5,0.5 ) ) - float2( 0,0 ) ) / float2( 1,1 ) ) ) * 2.0 ) ));
					float2 break22_g2 = float2( 0,0.05 );
					float2 uv047 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float3 uv030 = i.texcoord.xyz;
					uv030.xy = i.texcoord.xyz.xy * float2( 1,1 ) + float2( 0,0 );
					float2 appendResult25 = (float2((-1.0 + (( uv030.z + _Progress ) - 0.0) * (0.0 - -1.0) / (1.0 - 0.0)) , 0.0));
					float smoothstepResult10_g2 = smoothstep( break22_g2.x , break22_g2.y , ( 1.0 - ( length( ( ( ( uv047 - float2( 0.5,0.5 ) ) - appendResult25 ) / float2( 1,1 ) ) ) * 2.0 ) ));
					float4 color41 = IsGammaSpace() ? float4(0.2891153,0.8396226,0.7246692,1) : float4(0.06796474,0.673178,0.4839261,1);
					float4 color42 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
					float2 break22_g3 = float2( 0,0.5 );
					float2 uv049 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float smoothstepResult10_g3 = smoothstep( break22_g3.x , break22_g3.y , ( 1.0 - ( length( ( ( ( uv049 - float2( 0.5,0.5 ) ) - float2( 0,0 ) ) / float2( 1,1 ) ) ) * 2.0 ) ));
					float4 lerpResult43 = lerp( color41 , color42 , smoothstepResult10_g3);
					

					fixed4 col = ( i.color * _TintColor * 1.75 * ( saturate( ( smoothstepResult10_g1 - smoothstepResult10_g2 ) ) * lerpResult43 ) );
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
305;113;1169;719;995.6076;-348.8944;1.252039;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-635.2185,782.827;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-635.1424,943.9232;Inherit;False;Property;_Progress;Progress;1;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-337.5417,841.4406;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;26;-180.888,821.1093;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;12;-64.88177,404.9384;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-110.2429,140.2271;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;25;21.34139,825.7626;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-44.34103,560.9404;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;549.8704,892;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;46;218.3694,311.0447;Inherit;False;DrawCycle;-1;;1;da3e28910c85df048a80c702465201ae;0;4;1;FLOAT2;0,0;False;19;FLOAT2;0,0;False;20;FLOAT2;1,1;False;21;FLOAT2;0,0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;48;245.2855,680.6033;Inherit;False;DrawCycle;-1;;2;da3e28910c85df048a80c702465201ae;0;4;1;FLOAT2;0,0;False;19;FLOAT2;0,0;False;20;FLOAT2;1,1;False;21;FLOAT2;0,0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;825.7096,729.0867;Inherit;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;50;816.4553,912.4688;Inherit;True;DrawCycle;-1;;3;da3e28910c85df048a80c702465201ae;0;4;1;FLOAT2;0,0;False;19;FLOAT2;0,0;False;20;FLOAT2;1,1;False;21;FLOAT2;0,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;798.2008,556.1113;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;0.2891153,0.8396226,0.7246692,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;509.6207,433.435;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;1155.26,718.4667;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;29;925.7475,194.223;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1;710.9003,-269.3062;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;1295.623,162.2498;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;810.7745,96.87479;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;1.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;549.2513,-72.89171;Inherit;False;0;0;_TintColor;Shader;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;1582.771,-35.74263;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1173.144,1194.98;Inherit;False;Property;_Float1;Float 1;0;0;Create;True;0;0;False;0;0;0.7359762;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1901.292,18.86206;Float;False;True;-1;2;ASEMaterialInspector;0;7;New Amplify Shader;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;True;True;True;True;False;0;False;-1;False;True;2;False;-1;True;3;False;-1;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;0;False;False;False;False;False;False;False;False;False;False;True;0;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;52;0;30;3
WireConnection;52;1;53;0
WireConnection;26;0;52;0
WireConnection;25;0;26;0
WireConnection;46;1;5;0
WireConnection;46;19;12;0
WireConnection;48;1;47;0
WireConnection;48;19;25;0
WireConnection;50;1;49;0
WireConnection;23;0;46;0
WireConnection;23;1;48;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;43;2;50;0
WireConnection;29;0;23;0
WireConnection;45;0;29;0
WireConnection;45;1;43;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;3;2;4;0
WireConnection;3;3;45;0
WireConnection;0;0;3;0
ASEEND*/
//CHKSM=3DCAB06B48AB521DCB35A35006F9AD478C24A1E2