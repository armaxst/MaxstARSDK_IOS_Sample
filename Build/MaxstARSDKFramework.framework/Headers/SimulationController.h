#pragma once
#include <string>
#include <thread>
#include "../include/Types.h"
#include <vector>

namespace maxstAR
{
	struct SimulateData { std::string image; std::string txt; };
	class SimulationController {
	public: 
		ResultCode start();
		void stop();
		void setDataFolder(std::string folderPath);
		int getTrackingState();
		float* getFusionCameraIntrinsic();
		void setVPSCameraIntrinsic(float* intrinsic);
		void pauseSimulate();
        void updateFrame(bool isTexture);
		static SimulationController * getInstance();

	private:
		static void * captureWorker(void * param);

		void make_struct(std::vector<std::string>& files, std::vector<SimulateData>& sortedData);
		void read_directory(const std::string& name, std::vector<std::string>& v);
		std::wstring string_to_ws(const std::string& s);
        static bool getIntriniscAndPose(std::string textPath, std::vector<float>& intrinsic, float *pose, float &latitude, float &longitude, int &fps);
//        void createTextureCache(uintptr_t* textureCache);
//        void createTexture(unsigned char* pixelBufferRawArray, int width, int height,  int pixelFormat, int planeIndex, uintptr_t* textureCache);

		float intrinsic[4];
		float viewMatrix[16];
		std::vector<SimulateData> sortedData;
		std::string folderPath;
		std::thread imageCaptureThread;
		bool keepAlive;
		bool initializeCalibrationData;

		bool pauseStep = false;
        bool updateBuffer = false;
		int dataCounter = 0;
        
        uintptr_t capturedImageTextureRGBACache;
        uintptr_t capturedImageTextureRGBA;
        uintptr_t pixelBuffer;
        
		int textureInt[2];
        uintptr_t textureIds[2];
        
        clock_t savedUpdateTime;
	};
}
