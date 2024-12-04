/*******************************************************************************
* Copyright 2016 ROBOTIS CO., LTD.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

#include <Dynamixel2Arduino.h>
#define DXL_SERIAL Serial1
#define DEBUG_SERIAL Serial
const int DXL_DIR_PIN = -1; 
const float DXL_PROTOCOL_VERSION = 2.0;
String matlabdata = "";

Dynamixel2Arduino dxl(DXL_SERIAL, DXL_DIR_PIN);

// IDs of the motors
const uint8_t DXL_IDS[] = {2, 7};
const int NUM_DXL = sizeof(DXL_IDS) / sizeof(DXL_IDS[0]);

//This namespace is required to use Control table item names
using namespace ControlTableItem;

void setup() {
  // put your setup code here, to run once:

  // Use UART port of DYNAMIXEL Shield to debug.
  Serial.begin(9600);
  while(!DEBUG_SERIAL);

  // Set Port baudrate to 57600bps. This has to match with DYNAMIXEL baudrate.
  dxl.begin(57600);
  // Set Port Protocol Version. This has to match with DYNAMIXEL protocol version.
  dxl.setPortProtocolVersion(DXL_PROTOCOL_VERSION);

  // Initialize each motor
  for (int i = 0; i < NUM_DXL; i++) {
    uint8_t id = DXL_IDS[i];
    dxl.ping(id);
    dxl.torqueOff(id);
    dxl.setOperatingMode(id, OP_POSITION);
    dxl.torqueOn(id);

    // Limit the maximum velocity in Position Control Mode. Use 0 for Max speed
    dxl.writeControlTableItem(PROFILE_VELOCITY, id, 30);
  }
}

void loop() {

  if(Serial.available()>0) // if there is data to read
    {
    matlabdata=Serial.readStringUntil('\n');  // Read until newline
    int val = matlabdata.toInt();
    Serial.print(matlabdata);
    Serial.println(val);
    if(val > 50){
      Serial.print("ok");
    }
    // Goal positions for each motor
    int goal_position = val;
    float goal_position_deg = 5.7;

    int i_present_position;
    float f_present_position;

    // Move all motors to RAW goal position
    for (int i = 0; i < NUM_DXL; i++) {
      uint8_t id = DXL_IDS[i];
      dxl.setGoalPosition(id, goal_position);
    }

    delay(2000);
    Serial.println(val);
    }
    
    delay(1000);
}
