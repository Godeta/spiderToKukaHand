#include <Dynamixel2Arduino.h>
#include <Arduino.h>

// When using OpenRB-150
//OpenRB does not require the DIR control pin.
#define DXL_SERIAL Serial1
#define DEBUG_SERIAL Serial
const int DXL_DIR_PIN = -1;

const float DXL_PROTOCOL_VERSION = 2.0;
Dynamixel2Arduino dxl(DXL_SERIAL, DXL_DIR_PIN);

// IDs of the motors
const uint8_t DXL_IDS[] = {1,7,2,8,3,9,4,10,5,11,6,12};
const int NUM_DXL = sizeof(DXL_IDS) / sizeof(DXL_IDS[0]);
 
//This namespace is required to use Control table item names
using namespace ControlTableItem;

//Constante________________________________________________
const float L1 = 2.5;
const float L2 = 16.5;
const int tolerance = 10;
const int limit_angle_O1 = 45;
const int limit_angle_O2 = 20;



//Traj Avance
const float Hauteur_robot = -8.5;
const float A = -1/16;
const float B = 0;
const float C = Hauteur_robot + 1;

//Traj Avance Tracte
const float a = 8/5;
const float b = -4;

//Variable global_________________________________________
float x1,z1;
float x2,z2;
float x3,z3;
float x4,z4;
float x5,z5;
float x6,z6;


int step = 1;
bool next_step = false;
bool first_step = true;
String command;


void setup() {
  // Use UART port of DYNAMIXEL Shield to debug.
  DEBUG_SERIAL.begin(115200);
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
    dxl.writeControlTableItem(PROFILE_VELOCITY, id, 50);
    dxl.writeControlTableItem(GOAL_TORQUE, id, 1023);
    dxl.setGoalPosition(id, 180, UNIT_DEGREE);
    
  }
  delay(5000);
  DEBUG_SERIAL.println("START");
}



void loop() {
  float goal_position_deg[NUM_DXL];  
  float ANGLE[NUM_DXL];
  float POS[NUM_DXL];

  while(DEBUG_SERIAL.available()){
    command = DEBUG_SERIAL.readString();
    command.trim();
  }

  if(command.equals("a")){
    if (next_step || first_step){
    traj(POS);
    MGI(POS, ANGLE);

    first_step = false;
    }
  }

  if(command.equals("p")){
    ANGLE[0] = {180};
    ANGLE[1] = {305};
    ANGLE[2] = {180};
    ANGLE[3] = {305};
    ANGLE[4] = {180};
    ANGLE[5] = {305};
    ANGLE[6] = {180};
    ANGLE[7] = {305};
    ANGLE[8] = {180};
    ANGLE[9] = {305};
    ANGLE[10] = {180};
    ANGLE[11] = {305};
  }

  if(command.equals("l")){
    ANGLE[0] = {180};
    ANGLE[1] = {180};
    ANGLE[2] = {180};
    ANGLE[3] = {180};
    ANGLE[4] = {180};
    ANGLE[5] = {180};
    ANGLE[6] = {180};
    ANGLE[7] = {180};
    ANGLE[8] = {180};
    ANGLE[9] = {180};
    ANGLE[10] = {180};
    ANGLE[11] = {180};
  }
  
  
  for (int i = 0; i < NUM_DXL; i++) {
    uint8_t id = DXL_IDS[i];
    goal_position_deg[i] = ANGLE[i];
    bool moveIsOk = moveIsValid(id,goal_position_deg[i]);
    if (moveIsOk){
      dxl.setGoalPosition(id, goal_position_deg[i], UNIT_DEGREE);
    }else{
      DEBUG_SERIAL.print("Motor ID: ");
      DEBUG_SERIAL.print(id);
      DEBUG_SERIAL.print("  ERROR : ANGLE INTERDIT !!! : ");
      DEBUG_SERIAL.println(goal_position_deg[i]);
    }
  }

  for(int i = 0; i < NUM_DXL; i++){
    uint8_t id = DXL_IDS[i];
    float act_position_deg = dxl.getPresentPosition(id, UNIT_DEGREE);
    float angle_tol_max = ANGLE[i] + tolerance;
    float angle_tol_min = ANGLE[i] - tolerance;

    if ((angle_tol_min < act_position_deg) && (act_position_deg < angle_tol_max)){
      next_step = true;
    }else{
      next_step = false;
      break;
    }
  }

  if (next_step){
    step ++;
    if (step > 7){
      step = 1;
    }
  }
}

void traj(float *POS){
  DEBUG_SERIAL.println(command.equals("a"));
  if(command.equals("a")){
    /*
    switch (step) {
     case 1:
        x1 = 0;
        z1 = -7;

        x3 = 0;
        z3 = -11;
        break; 

      case 2:
        x1 = 4;
        z1 = -7;

        x3 = 0;
        z3 = -11;
        break;

      case 3:
        x1 = 4;
        z1 = -11;

        x3 = 0;
        z3 = -11;
        break;

      case 4:
        x1 = 4;
        z1 = -11;

        x3 = 0;
        z3 = -7;
        break;

      case 5:
        x1 = 4;
        z1 = -11;

        x3 = 4;
        z3 = -7;
        break;  

      case 6:
        x1 = 4;
        z1 = -11;

        x3 = 4;
        z3 = -11;
        break;  

      case 7:
        x1 = 0;
        z1 = -11;

        x3 = 0;
        z3 = -11;
        break; 
    }
    */
    
    switch (step) {
      case 1:
        x1 = 3;
        z1 = -7;

        x3 = -3;
        z3 = -11;
        break;
  
      case 2:
        x1 = 3;
        z1 = -11;

        x3 = -3;
        z3 = -11;
        break;

      case 3:
        x1 = 3;
        z1 = -11;

        x3 = -3;
        z3 = -7;
        break;

      case 4:
        x1 = -3;
        z1 = -11;

        x3 = 3;
        z3 = -7;
        break;

      case 5:
        x1 = -3;
        z1 = -11;

        x3 = 3;
        z3 = -11;
        break;

      case 6:
        x1 = -3;
        z1 = -7;

        x3 = 3;
        z3 = -11;
        break;  
    }
    
  }else{
    x1 = 0;
    z1 = -11;

    x3 = 0;
    z3 = -11;
  }

  x2 = x3*(-1);
  z2 = z3;
  x6 = x3*(-1);
  z6 = z2;

  x4 = x1*(-1);
  z4 = z1;
  x5 = x1;
  z5 = z1;
  
  POS[0] = x1;
  POS[1] = z1;

  POS[2] = x2;
  POS[3] = z2;

  POS[4] = x3;
  POS[5] = z3;

  POS[6] = x4;
  POS[7] = z4;

  POS[8] = x5;
  POS[9] = z5;

  POS[10] = x6;
  POS[11] = z6;
}

void MGI(float *POS, float *ANGLE){
  //Patte 1
  x1 = POS[0];
  z1 = POS[1];

  x2 = POS[2];
  z2 = POS[3];

  x3 = POS[4];
  z3 = POS[5];

  x4 = POS[6];
  z4 = POS[7];

  x5 = POS[8];
  z5 = POS[9];

  x6 = POS[10];
  z6 = POS[11];
  
  float O2_1 = sin(-z1/L2)-(31*PI/180);
  float O1_1 = asin(x1/(L1+L2*cos(O2_1+(31*PI/180))));

  float O2_2 = sin(-z2/L2)-(31*PI/180);
  float O1_2 = asin(x2/(L1+L2*cos(O2_2+(31*PI/180))));

  float O2_3 = sin(-z3/L2)-(31*PI/180);
  float O1_3 = asin(x3/(L1+L2*cos(O2_3+(31*PI/180))));

  float O2_4 = sin(-z4/L2)-(31*PI/180);
  float O1_4 = asin(x4/(L1+L2*cos(O2_4+(31*PI/180))));

  float O2_5 = (sin(-z5/L2)-(31*PI/180));
  float O1_5 = asin(x5/(L1+L2*cos(O2_5+(31*PI/180))));

  float O2_6 = sin(-z6/L2)-(31*PI/180);
  float O1_6 = asin(x6/(L1+L2*cos(O2_6+(31*PI/180))));

  ANGLE[0] = O1_1 ;
  ANGLE[1] = O2_1 ;

  ANGLE[2] = O1_2 ;
  ANGLE[3] = O2_2 ;

  ANGLE[4] = O1_3 ;
  ANGLE[5] = O2_3 ;

  ANGLE[6] = O1_4 ;
  ANGLE[7] = O2_4 ;

  ANGLE[8] = O1_5 ;
  ANGLE[9] = O2_5 ;

  ANGLE[10] = O1_6 ;
  ANGLE[11] = O2_6 ;

  for (int i = 0; i < NUM_DXL; i++){
    ANGLE[i] = ANGLE[i]*(180/PI) + 180;
  }
}

bool moveIsValid(uint8_t id, float angle){
  if(command.equals("p")){
      return true;
  }else{
    switch (id){
      //Moteur O1
      case 1 :
      if(180-limit_angle_O1 < angle &&  angle < 180 + limit_angle_O1){
        return true;
      }else{
        return false;
      }
      case 2 :
      if(180-limit_angle_O1 < angle &&  angle < 180 + limit_angle_O1){
        return true;
      }else{
        return false;
      }
      case 3 :
      if(180-limit_angle_O1 < angle &&  angle < 180 + limit_angle_O1){
        return true;
      }else{
        return false;
      }
      case 4 :
      if(180-limit_angle_O1 < angle &&  angle < 180 + limit_angle_O1){
        return true;
      }else{
        return false;
      }
      case 5 :
      if(180-limit_angle_O1 < angle &&  angle < 180 + limit_angle_O1){
        return true;
      }else{
        return false;
      }
      case 6 :
      if(180-limit_angle_O1 < angle &&  angle < 180 + limit_angle_O1){
        return true;
      }else{
        return false;
      }

      //Moteur O2
      case 7 :
      if(180-limit_angle_O2 < angle &&  angle < 180 + limit_angle_O2){
        return true;
      }else{
        return false;
      }
      case 8 :
      if(180-limit_angle_O2 < angle &&  angle < 180 + limit_angle_O2){
        return true;
      }else{
        return false;
      }
      case 9 :
      if(180-limit_angle_O2 < angle &&  angle < 180 + limit_angle_O2){
        return true;
      }else{
        return false;
      }
      case 10 :
      if(180-limit_angle_O2 < angle &&  angle < 180 + limit_angle_O2){
        return true;
      }else{
        return false;
      }
      case 11 :
      if(180-limit_angle_O2 < angle &&  angle < 180 + limit_angle_O2){
        return true;
      }else{
        return false;
      }
      case 12 :
      if(180-limit_angle_O2 < angle &&  angle < 180 + limit_angle_O2){
        return true;
      }else{
        return false;
      }
    }
  }
}

