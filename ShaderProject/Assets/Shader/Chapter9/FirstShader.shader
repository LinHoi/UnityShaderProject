Shader "Unlit/FirstShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				float4 LightColor=_LightColor0;
				float3 LightColor3=_LightColor0.xyz;
				float4 worldLightPos=_WorldSpaceLightPos0;
				float3 lightDir= WorldSpaceLightDir(float4(0,0,1,1));
				float3 lightDir2=UnityWorldSpaceLightDir(float4(1,1,1,1));
				float3 object2Light=ObjSpaceLightDir(float4(1,1,1,1));
				float3 object2Light2=ObjSpaceLightDir(float4(1,2,3,4));
				float3 object2Light3= ObjSpaceLightDir(float4(0,1,1,1));

				return col;
			}
			ENDCG
		}
	}
}
