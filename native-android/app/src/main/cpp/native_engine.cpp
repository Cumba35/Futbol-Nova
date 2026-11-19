#include <jni.h>
#include <GLES3/gl3.h>
#include <android/log.h>
#include <cmath>
#include <vector>
#include <array>
#include <algorithm>
#include <time.h>

#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR,"FutbolNova",__VA_ARGS__)
namespace {
struct V3 { float x,y,z; };
struct Vertex { float x,y,z; };
struct Mesh { GLuint vao=0,vbo=0; GLsizei count=0; GLenum mode=GL_TRIANGLES; };
GLuint program=0; GLint mvpLoc=-1,colorLoc=-1;
int screenW=1,screenH=1; bool paused=false;
float stickX=0,stickY=0; bool shoot=false,pass=false,skill=false,pressure=false;
float ballX=0,ballZ=0,ballY=.22f,ballVX=0,ballVY=0,ballVZ=0;
float playerX=0,playerZ=7.0f,playerYaw=0,matchTime=0;
Mesh fieldMesh{},lineMesh{},sphereMesh{},standMesh{},goalMesh{};
std::array<V3,22> players{};
std::array<float,22> playerHeight{};
std::array<float,22> playerPace{};
std::array<float,22> playerDribbling{};
std::array<float,22> playerDefending{};
std::array<int,22> playerOverall{};

const char* VS="#version 300 es\nlayout(location=0) in vec3 aPos; uniform mat4 uMVP; void main(){gl_Position=uMVP*vec4(aPos,1.0);}";
const char* FS="#version 300 es\nprecision mediump float; uniform vec4 uColor; out vec4 frag; void main(){frag=uColor;}";

std::array<float,16> identity(){return {1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1};}
std::array<float,16> mul(const std::array<float,16>&a,const std::array<float,16>&b){
 std::array<float,16> r{}; for(int c=0;c<4;c++)for(int row=0;row<4;row++)for(int k=0;k<4;k++)r[c*4+row]+=a[k*4+row]*b[c*4+k]; return r;
}
std::array<float,16> perspective(float f,float aspect,float n,float z){
 float q=1.0f/std::tan(f*.5f); std::array<float,16> m{};m[0]=q/aspect;m[5]=q;m[10]=(z+n)/(n-z);m[11]=-1;m[14]=(2*z*n)/(n-z);return m;
}
V3 norm(V3 v){float l=std::sqrt(v.x*v.x+v.y*v.y+v.z*v.z);if(l<.0001f)return {0,0,0};return {v.x/l,v.y/l,v.z/l};}
V3 sub(V3 a,V3 b){return {a.x-b.x,a.y-b.y,a.z-b.z};}
V3 cross(V3 a,V3 b){return {a.y*b.z-a.z*b.y,a.z*b.x-a.x*b.z,a.x*b.y-a.y*b.x};}
std::array<float,16> lookAt(V3 eye,V3 center,V3 up){
 V3 f=norm(sub(center,eye)),s=norm(cross(f,up)),u=cross(s,f);auto m=identity();
 m[0]=s.x;m[4]=s.y;m[8]=s.z;m[1]=u.x;m[5]=u.y;m[9]=u.z;m[2]=-f.x;m[6]=-f.y;m[10]=-f.z;
 m[12]=-(s.x*eye.x+s.y*eye.y+s.z*eye.z);m[13]=-(u.x*eye.x+u.y*eye.y+u.z*eye.z);m[14]=(f.x*eye.x+f.y*eye.y+f.z*eye.z);return m;
}
std::array<float,16> model(float x,float y,float z,float sx,float sy,float sz,float yaw=0){
 auto m=identity();float c=std::cos(yaw),s=std::sin(yaw);
 m[0]=c*sx;m[2]=-s*sx;m[5]=sy;m[8]=s*sz;m[10]=c*sz;m[12]=x;m[13]=y;m[14]=z;return m;
}
GLuint shader(GLenum type,const char*src){GLuint s=glCreateShader(type);glShaderSource(s,1,&src,nullptr);glCompileShader(s);GLint ok=0;glGetShaderiv(s,GL_COMPILE_STATUS,&ok);if(!ok){char log[1024];glGetShaderInfoLog(s,1024,nullptr,log);LOGE("shader: %s",log);}return s;}
void makeProgram(){GLuint v=shader(GL_VERTEX_SHADER,VS),f=shader(GL_FRAGMENT_SHADER,FS);program=glCreateProgram();glAttachShader(program,v);glAttachShader(program,f);glLinkProgram(program);glDeleteShader(v);glDeleteShader(f);mvpLoc=glGetUniformLocation(program,"uMVP");colorLoc=glGetUniformLocation(program,"uColor");}
Mesh mesh(const std::vector<Vertex>&v,GLenum mode=GL_TRIANGLES){Mesh m;m.mode=mode;m.count=(GLsizei)v.size();glGenVertexArrays(1,&m.vao);glGenBuffers(1,&m.vbo);glBindVertexArray(m.vao);glBindBuffer(GL_ARRAY_BUFFER,m.vbo);glBufferData(GL_ARRAY_BUFFER,v.size()*sizeof(Vertex),v.data(),GL_STATIC_DRAW);glEnableVertexAttribArray(0);glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,sizeof(Vertex),(void*)0);glBindVertexArray(0);return m;}
Mesh makeSphere(){std::vector<Vertex>v;const int rings=12,segs=16;for(int i=0;i<rings;i++){float a1=-1.5707963f+3.1415926f*i/rings,a2=-1.5707963f+3.1415926f*(i+1)/rings;for(int j=0;j<segs;j++){float b1=6.2831853f*j/segs,b2=6.2831853f*(j+1)/segs;auto p=[](float a,float b){return Vertex{std::cos(a)*std::cos(b),std::sin(a),std::cos(a)*std::sin(b)};};Vertex p1=p(a1,b1),p2=p(a2,b1),p3=p(a2,b2),p4=p(a1,b2);v.insert(v.end(),{p1,p2,p3,p1,p3,p4});}}return mesh(v);}
void draw(const Mesh&m,const std::array<float,16>&vp,const std::array<float,16>&mod,float r,float g,float b,float a=1){auto mvp=mul(vp,mod);glUniformMatrix4fv(mvpLoc,1,GL_FALSE,mvp.data());glUniform4f(colorLoc,r,g,b,a);glBindVertexArray(m.vao);glDrawArrays(m.mode,0,m.count);}
void line(std::vector<Vertex>&v,float x1,float z1,float x2,float z2){v.push_back({x1,.025f,z1});v.push_back({x2,.025f,z2});}
void initField(){
 std::vector<Vertex>f={ {-34,0,-52},{34,0,-52},{34,0,52},{-34,0,-52},{34,0,52},{-34,0,52} };fieldMesh=mesh(f);
 std::vector<Vertex>l;line(l,-34,-52,34,-52);line(l,34,-52,34,52);line(l,34,52,-34,52);line(l,-34,52,-34,-52);line(l,-34,0,34,0);
 for(int i=0;i<48;i++){float a=6.2831853f*i/48;line(l,9*std::cos(a),9*std::sin(a),9*std::cos(a+6.2831853f/48),9*std::sin(a+6.2831853f/48));}
 line(l,-34,-20,-18,-20);line(l,-18,-20,-18,20);line(l,-18,20,-34,20);
 line(l,34,-20,18,-20);line(l,18,-20,18,20);line(l,18,20,34,20);
 lineMesh=mesh(l,GL_LINES);sphereMesh=makeSphere();
 std::vector<Vertex> stands={
 {-42,0,-58},{-36,0,-58},{-36,7,-58},{-42,7,-58},{-42,0,58},{-36,0,58},{-36,7,58},{-42,7,58},
 {36,0,-58},{42,0,-58},{42,7,-58},{36,7,-58},{36,0,58},{42,0,58},{42,7,58},{36,7,58},
 {-42,0,-58},{42,0,-58},{42,7,-58},{-42,7,-58},{-42,0,58},{42,0,58},{42,7,58},{-42,7,58}};
 const int boxIdx[]={0,1,2,0,2,3,4,5,6,4,6,7,8,9,10,8,10,11,12,13,14,12,14,15,16,17,18,16,18,19,20,21,22,20,22,23};
 std::vector<Vertex> sv;for(int idx:boxIdx)sv.push_back(stands[(size_t)idx]);standMesh=mesh(sv);
 std::vector<Vertex> g;
 auto seg=[&](float x1,float y1,float z1,float x2,float y2,float z2){g.push_back({x1,y1,z1});g.push_back({x2,y2,z2});};
 for(float z:{-53.0f,53.0f}){float sign=z<0?-1.0f:1.0f;seg(-3.66f,.1f,z, -3.66f,2.44f,z);seg(3.66f,.1f,z,3.66f,2.44f,z);seg(-3.66f,2.44f,z,3.66f,2.44f,z);seg(-3.66f,.1f,z,-3.66f,.1f,z+sign*2.0f);seg(3.66f,.1f,z,3.66f,.1f,z+sign*2.0f);seg(-3.66f,2.44f,z,-3.66f,2.44f,z+sign*2.0f);seg(3.66f,2.44f,z,3.66f,2.44f,z+sign*2.0f);}
 goalMesh=mesh(g,GL_LINES);
}
void setupTeams(){
 const V3 formation[11]={{0,0,-45},{22,0,-30},{8,0,-32},{-8,0,-32},{-22,0,-30},{0,0,-10},{15,0,-8},{-15,0,-8},{22,0,18},{0,0,24},{-22,0,18}};
 for(int i=0;i<22;i++){playerHeight[i]=175.0f;playerPace[i]=72.0f;playerDribbling[i]=70.0f;playerDefending[i]=70.0f;playerOverall[i]=70;}
 for(int i=0;i<11;i++){players[i]=formation[i];players[11+i]={formation[i].x,0,-formation[i].z};}
}
void drawPlayer(const std::array<float,16>&vp,V3 p,bool home,float yaw,int slot){
 float r=home?.12f:.88f,g=home?.72f:.14f,b=home?.22f:.18f;
 float h=std::clamp(playerHeight[slot]/175.0f,.92f,1.08f);
 float athletic=std::clamp(.96f+playerOverall[slot]/1750.0f,.98f,1.06f);
 draw(sphereMesh,vp,model(p.x,p.y+.82f*h,p.z,.34f*athletic,.62f*h,.25f,yaw),r,g,b);
 draw(sphereMesh,vp,model(p.x,p.y+1.52f*h,p.z,.19f*h,.19f*h,.19f*h),.88f,.72f,.56f);
 draw(sphereMesh,vp,model(p.x-.13f*athletic,p.y+.24f*h,p.z,.11f,.30f*h,.12f,yaw),.08f,.08f,.10f);
 draw(sphereMesh,vp,model(p.x+.13f*athletic,p.y+.24f*h,p.z,.11f,.30f*h,.12f,yaw),.08f,.08f,.10f);
}
void update(float dt){
 matchTime+=dt;
 float controlledPace=std::clamp(playerPace[10]/75.0f,.75f,1.30f);
 playerX=std::clamp(playerX+stickX*dt*8.0f*controlledPace,-32.0f,32.0f);
 playerZ=std::clamp(playerZ-stickY*dt*8.0f*controlledPace,-50.0f,50.0f);
 if(std::abs(stickX)+std::abs(stickY)>.08f)playerYaw=std::atan2(stickX,-stickY);
 players[10]={playerX,0,playerZ};
 const V3 formation[11]={{0,0,-45},{22,0,-30},{8,0,-32},{-8,0,-32},{-22,0,-30},{0,0,-10},{15,0,-8},{-15,0,-8},{22,0,18},{0,0,24},{-22,0,18}};
 for(int i=0;i<22;i++){if(i==10)continue;int local=i%11;float dir=i<11?1.0f:-1.0f;V3 base=formation[local];float support=std::clamp((ballZ*dir)/70.0f,-.22f,.22f);float tx=base.x+std::clamp(ballX*.18f,-7.0f,7.0f);float tz=(i<11?base.z:-base.z)+support*12.0f;
 float dx=tx-players[i].x,dz=tz-players[i].z;float d=std::sqrt(dx*dx+dz*dz);float speed=2.0f+playerPace[i]*.025f;
 if(d>.08f){float step=std::min(d,speed*dt);players[i].x+=dx/d*step;players[i].z+=dz/d*step;}
 }
 if(pass||shoot){float dx=shoot?std::sin(playerYaw):std::sin(playerYaw);float dz=-std::cos(playerYaw);float power=shoot?25.0f:15.0f;ballVX=dx*power;ballVZ=dz*power;ballVY=shoot?7.0f:2.0f;ballX=playerX+dx*.65f;ballZ=playerZ+dz*.65f;ballY=.35f;shoot=false;pass=false;}
 ballX+=ballVX*dt;ballY+=ballVY*dt;ballZ+=ballVZ*dt;ballVY-=9.81f*dt;
 ballVX*=std::pow(.985f,dt*60);ballVZ*=std::pow(.985f,dt*60);
 if(ballY<.22f){ballY=.22f;ballVY=std::abs(ballVY)*.38f;if(std::abs(ballVY)<.7f)ballVY=0;}
 for(int i=0;i<22;i++){float dx=ballX-players[i].x,dz=ballZ-players[i].z;float d2=dx*dx+dz*dz;if(d2<.42f&&ballY<1.05f&&std::abs(ballVX)+std::abs(ballVZ)<3.0f){float inv=1.0f/std::max(.01f,std::sqrt(d2));ballVX=dx*inv*2.0f;ballVZ=dz*inv*2.0f;}}
 if(std::abs(ballX)>34){ballX=std::copysign(34.0f,ballX);ballVX*=-.55f;}
 if(std::abs(ballZ)>52){ballZ=std::copysign(52.0f,ballZ);ballVZ*=-.55f;}
}
}
extern "C" JNIEXPORT void JNICALL Java_com_nova_futbolnova_MainActivity_nativeInit(JNIEnv*,jobject){makeProgram();initField();setupTeams();glEnable(GL_DEPTH_TEST);glClearColor(.015f,.045f,.075f,1);}
extern "C" JNIEXPORT void JNICALL Java_com_nova_futbolnova_MainActivity_nativeResize(JNIEnv*,jobject,jint w,jint h){screenW=std::max(1,(int)w);screenH=std::max(1,(int)h);glViewport(0,0,screenW,screenH);}
extern "C" JNIEXPORT void JNICALL Java_com_nova_futbolnova_MainActivity_nativeFrame(JNIEnv*,jobject){
 static double last=0; timespec ts{};clock_gettime(CLOCK_MONOTONIC,&ts);double now=ts.tv_sec+ts.tv_nsec*1e-9;float dt=last==0?0.016f:(float)std::clamp(now-last,0.001,0.04);last=now;
 if(!paused)update(dt);glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);glUseProgram(program);
 float aspect=(float)screenW/(float)screenH;auto proj=perspective(.92f,aspect,.1f,180.0f);
 V3 eye{playerX+0.0f,30.0f,playerZ+58.0f},center{ballX*.35f+playerX*.65f,0,ballZ*.35f+playerZ*.65f};auto vp=mul(proj,lookAt(eye,center,{0,1,0}));
 draw(standMesh,vp,model(0,0,0,1,1,1),.055f,.085f,.12f);
 draw(fieldMesh,vp,identity(),.035f,.34f,.13f);
 draw(lineMesh,vp,identity(),.88f,.94f,.85f);
 draw(goalMesh,vp,identity(),.92f,.95f,.96f);
 for(int i=0;i<22;i++)drawPlayer(vp,players[i],i<11,i==10?playerYaw:0,i);
 draw(sphereMesh,vp,model(ballX,ballY,ballZ,.22f,.22f,.22f),.96f,.96f,.92f);
}
extern "C" JNIEXPORT void JNICALL Java_com_nova_futbolnova_MainActivity_nativeTouch(JNIEnv*,jclass,jfloat x,jfloat y,jint action,jint w,jint h){
 float nx=x/(float)std::max(1,w),ny=y/(float)std::max(1,h);
 if(action==0||action==2){if(nx<.38f&&ny>.55f){stickX=std::clamp((nx-.17f)*6.0f,-1.0f,1.0f);stickY=std::clamp((ny-.79f)*6.0f,-1.0f,1.0f);}else if(action==0&&nx>.78f&&ny>.64f){shoot=true;}else if(action==0&&nx>.65f&&ny>.48f){pass=true;}else if(action==0&&nx>.78f&&ny<.65f){skill=true;}}
 if(action==1||action==3){stickX=0;stickY=0;}
}

extern "C" JNIEXPORT void JNICALL Java_com_nova_futbolnova_MainActivity_nativeSetPlayerProfile(
    JNIEnv*,jclass,jint slot,jfloat heightCm,jint overall,jfloat pace,jfloat dribbling,jfloat defending){
 if(slot<0||slot>=22)return;
 playerHeight[(size_t)slot]=std::clamp((float)heightCm,150.0f,205.0f);
 playerOverall[(size_t)slot]=std::clamp((int)overall,1,99);
 playerPace[(size_t)slot]=std::clamp((float)pace,1.0f,99.0f);
 playerDribbling[(size_t)slot]=std::clamp((float)dribbling,1.0f,99.0f);
 playerDefending[(size_t)slot]=std::clamp((float)defending,1.0f,99.0f);
}

extern "C" JNIEXPORT void JNICALL Java_com_nova_futbolnova_MainActivity_nativePause(JNIEnv*,jclass,jboolean value){paused=value;}
