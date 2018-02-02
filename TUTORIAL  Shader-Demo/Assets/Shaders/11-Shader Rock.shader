Shader "Tutorial/Shader11-石头材质"
{
    Properties
	{
		_MainTex("纹理",2D) = "white"{}
		_Color("颜色",Color) = (1,1,1,1)
	}
	SubShader
	{
	    Pass
		{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;//定义图片
			float4 _MainTex_ST;//定义偏移控制 缩放S/偏移T
			fixed4 _Color;

			struct a2v
			{
			    float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 texcoord:TEXCOORD0;

			};

			struct v2f
			{
			    float4 svPos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float4 worldVertex:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};


			v2f vert(a2v v)
			{
			    v2f f;
				f.svPos = mul(UNITY_MATRIX_MVP,v.vertex);//模型空间-世界空间的顶点位置
				f.worldNormal = UnityObjectToWorldNormal(v.normal);//模型空间法线 - 世界空间法线向量
				f.worldVertex = mul(v.vertex,unity_WorldToObject);//从模型空间的顶点坐标 - 世界空间的顶点坐标
				f.uv = v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;//传递顶点 - 片元/  乘以XY，就相当于倍数       加上 偏移 zw
				return f;

			}


			fixed4 frag(v2f f):SV_Target
			{
			    fixed3 normalDir = normalize(f.worldNormal);//取得法线单位向量

				fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldVertex));

				fixed3 texColor = tex2D(_MainTex,f.uv.xy)*_Color.rgb;

			    fixed3 diffuse = _LightColor0.rgb*texColor*max(0,dot(normalDir,lightDir));

				fixed3 tempColor = diffuse + UNITY_LIGHTMODEL_AMBIENT.rgb*texColor;

				return fixed4 (tempColor,1);
			}

			ENDCG
		}
	}
	Fallback"Specular"
}