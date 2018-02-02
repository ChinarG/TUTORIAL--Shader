Shader"Tutorial/Shader02"
{
	SubShader
	{
        Pass
		{
		    CGPROGRAM
			//顶点函数 （#pragma vertex）—— 标注，固定格式：函数名vert
			//最基本作用：把模型空间中的 顶点坐标 转换到 剪裁空间 的转换处理（也就是从游戏环境，到屏幕相机视野上）
			#pragma vertex vert

			//片元函数
			//最基本作用：返回模型相对应 屏幕上每个像素颜色的值
			#pragma fragment frag

			// v:POSITION —— 告诉系统，需要顶点坐标传递给V
			//SV_POSITION —— 是给方法返回值做说明，返回值是剪裁空间下的顶点坐标

			/*
			float4 vert(float4 v:POSITION):SV_POSITION
			{
			    return mul(UNITY_MATRIX_MVP,v);//利用矩阵，来完成坐标的空间转换
			}
			fixed4 frag():SV_Target
			{
			    return fixed4(.5,1,1,1);
			}
			*/


			/*
			  从应用程序传递到顶点函数的语义有哪些：
			  POSITION —— 顶点坐标（模型空间下）
			  NORMAL —— 法线（模型空间）
			  TANGENT —— 切线（模型空间）
			  TEXCOORD（0 ~ N） —— 纹理坐标
			  COLOR (0 ~ N) —— 顶点颜色


			  从 顶点函数 传递给 片元函数 可以使用的语义有哪些：
			  SV_POSITION (剪裁空间中的顶点坐标，一般不会用，都是系统自动处理)
			  COLOR0 可以传递一组值 4个值
			  COLOR1 可以传递一组值 4个值
			  TEXCOORD（0 ~ 7) 传递纹理坐标

			  片元函数 传递给 系统：是一个颜色值（姑且理解为显示到屏幕上的颜色）
			*/ 


			
			//结构体
			struct a2v
			{
				float4 vertex:POSITION;   //告诉Unity把模型空间下的 顶点坐标填充给vertex
				float3 normal:NORMAL;     //告诉Unity把模型空间下的 法线方向填充给normal
				float4 texcoord:TEXCOORD0;//告诉Unity把第一套纹理 坐标填充给texcoord
			};

			struct v2f
			{
				float4 position:SV_POSITION;
				float3 temp:COLOR0;//这个语义：可以自定义，一般来存储颜色 temp可自定义，COLOR0固定
			};

			v2f vert(a2v v)
			{
				v2f newf;
				newf.position=mul(UNITY_MATRIX_MVP,v.vertex);
				newf.temp=v.normal;
				return newf;
			}

			fixed4 frag(v2f newf):SV_Target
			{
			    return fixed4(newf.temp,1);
			}

			ENDCG
		}	    
	}
    Fallback"VertexLit"
}