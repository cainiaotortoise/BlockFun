﻿Shader "Custom/shader_flowlight_step03" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FlowTex ("Light Texture(A)", 2D) = "black" {} //流光贴图
		_uvaddspeed   ("",float) = 2//流光uv改变速度

	}
	SubShader {
		Tags {"RenderType"="Transparent" "Queue"="Transparent" }//改为透明
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha //指定alphaBlend
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _FlowTex;//属性
		float _uvaddspeed;//属性
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			float2 uv =IN.uv_MainTex;//计算流光uv
			uv.x/=2;//取一半
			uv.x+=_Time.y*_uvaddspeed;//横向加上
			

			float flow = tex2D (_FlowTex, uv).a;//取流光亮度
			
			o.Albedo = c.rgb +  float3(flow,flow,flow);//加上流光亮度颜色
			o.Alpha = c.a;
		}
		ENDCG
	} 
	//FallBack "Diffuse" 去掉fallback，也就不投影了
}
