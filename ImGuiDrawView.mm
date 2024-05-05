
#import "Esp/ImGuiDrawView.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#include "IMGUI/imgui.h"
#include "IMGUI/imgui_impl_metal.h"
#import <Foundation/Foundation.h>
#import "Esp/CaptainHook.h"
#import "5Toubun/NakanoIchika.h"
#import "5Toubun/NakanoNino.h"
#import "5Toubun/NakanoMiku.h"
#import "5Toubun/NakanoYotsuba.h"
#import "5Toubun/NakanoItsuki.h"
#import "Honkai.h"
#import "Macros.h"
#import "pthread.h"
#include <cmath>

#include <map>
#import "Vector3.h"
#import "Vector2.h"
#import "Quaternion.h"
#import "Monostring.h"
#import "icons.h"
#import "Roboto-Regular.h"
#import "user_interface.cpp"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale
#define kTest   0 
#define g 0.86602540378444 

@interface ImGuiDrawView () <MTKViewDelegate>
//@property (nonatomic, strong) IBOutlet MTKView *mtkView;
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

@implementation ImGuiDrawView


static bool MenDeal = true;
int glHeight, glWidth;

ImDrawList* getDrawList(){
    ImDrawList *drawList;
    drawList = ImGui::GetForegroundDrawList();
    return drawList;
};

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    ImGui::StyleColorsDark();
    ImGuiStyle &style = ImGui::GetStyle();
    auto& Style = ImGui::GetStyle();

    Style.Colors[ImGuiCol_WindowBg] = ImVec4(0.098f, 0.086f, 0.161f, 0.941f);
    Style.Colors[ImGuiCol_CheckMark] = ImVec4(0.455f, 0.392f, 0.878f, 1.000f);
    Style.Colors[ImGuiCol_FrameBg] = ImVec4(0.455f, 0.392f, 0.878f, 0.541f);
    Style.Colors[ImGuiCol_FrameBgActive] = ImVec4(0.334f, 0.291f, 0.628f, 0.541f);
    Style.Colors[ImGuiCol_FrameBgHovered] = ImVec4(0.334f, 0.291f, 0.628f, 0.541f);
    Style.Colors[ImGuiCol_Header] = ImVec4(0.455f, 0.392f, 0.878f, 0.541f);
    Style.Colors[ImGuiCol_HeaderActive] = ImVec4(0.334f, 0.291f, 0.628f, 0.541f);
    Style.Colors[ImGuiCol_HeaderHovered] = ImVec4(0.334f, 0.291f, 0.628f, 0.541f);
    Style.Colors[ImGuiCol_SliderGrab] = ImVec4(1.000f, 1.000f, 1.000f, 1.000f);
    Style.Colors[ImGuiCol_SliderGrabActive] = ImVec4(1.000f, 1.000f, 1.000f, 1.000f);
    
    io.Fonts->ClearFonts();
    ImFontConfig font_cfg;
    font_cfg.SizePixels = 20.0f;
    font_cfg.GlyphRanges = io.Fonts->GetGlyphRangesCyrillic();
    //buttonsmenu = io.Fonts->AddFontFromMemoryTTF(Roboto_Regular, sizeof Roboto_Regular, 20.0f, &font_cfg);
    io.Fonts->AddFontFromMemoryTTF(Roboto_Regular, sizeof Roboto_Regular, 15.0f, &font_cfg);
    tabs = io.Fonts->AddFontFromMemoryTTF(Roboto_Regular, sizeof Roboto_Regular, 15.0f, &font_cfg);

      
    ImFontConfig font_cfg2;
    font_cfg2.MergeMode = true;
    static const ImWchar icon_ranges[] = {ICON_MIN_FA, ICON_MAX_FA, 0x0};
    icfont = io.Fonts->AddFontFromMemoryCompressedBase85TTF(FontAwesome6_compressed_data_base85, 15.0f, &font_cfg2, icon_ranges);
    
    ImGui_ImplMetal_Init(_device);

    return self;
}



+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView
{

 

    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view. Выполните любую дополнительную настройку после загрузки view
    
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:YES];
}

void ColorPicker(const char* name, ImVec4 &color) {
    static ImVec4 backup_color;

    bool open_popup = ImGui::ColorButton((std::string(name) + std::string("##3b")).c_str(), color);
    //open_popup |= ImGui::Button("Palette");
    if (open_popup) {
        ImGui::OpenPopup(name);
        backup_color = color;
    }
    if (ImGui::BeginPopup(name)) {
        ImGui::Spacing();
        ImGui::Text("Select Color");
        ImGui::Separator();
        ImGui::ColorPicker4("##picker", (float *) &color,ImGuiColorEditFlags_NoSidePreview |
                                                         ImGuiColorEditFlags_NoSmallPreview);
        ImGui::SameLine();

        ImGui::BeginGroup(); // Lock X position
        ImGui::Text("Current");
        ImGui::ColorButton("##current", color,
                           ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_AlphaPreviewHalf,
                           ImVec2(60, 40));
        ImGui::Text("Previous");
        if (ImGui::ColorButton("##previous", backup_color, ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_AlphaPreviewHalf, ImVec2(60, 40))) {
            color = backup_color;
        }
        ImGui::EndGroup();
        ImGui::EndPopup();
    }
}

void AddColorPicker(const char* name, ImVec4 &color, bool prd = false, bool* rainbow = nullptr, bool* pulse = nullptr, bool* dark = nullptr) {
    ImGuiColorEditFlags misc_flags = ImGuiColorEditFlags_AlphaPreview;
    static ImVec4 backup_color;
    bool open_popup = ImGui::ColorButton((std::string(name) + std::string(("##3b"))).c_str(), color, misc_flags);
    if (open_popup) {
        ImGui::OpenPopup(name);
        backup_color = color;
    }
    if (ImGui::BeginPopup(name)) {
        ImGui::Spacing();
        ImGui::Text(("%s"), std::string(name).c_str());
        ImGui::Separator();
        ImGui::ColorPicker4(("##picker"), (float *) &color,misc_flags | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_NoSmallPreview | ImGuiColorEditFlags_AlphaBar);
        ImGui::SameLine();
        ImGui::BeginGroup();
        ImGui::Text(("%s"),std::string(("Current")).c_str());
        ImGui::ColorButton(("##current"), color,ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_AlphaPreviewHalf,ImVec2(60, 40));
        ImGui::Text(("%s"),std::string(("Previous")).c_str());
        if (ImGui::ColorButton(("##previous"), backup_color,ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_AlphaPreviewHalf,ImVec2(60, 40)))color = backup_color;
        ImGui::EndGroup();
        if (prd) {
            if (rainbow) ImGui::Checkbox(("rainbow"), rainbow);
            if (pulse) ImGui::Checkbox(("pulse"), pulse);
            if (dark) ImGui::Checkbox(("dark"), dark);
        }
        ImGui::Spacing();
        ImGui::EndPopup();
    }
}

#import "Hooks.h"

void DrawOtherElements(){
    if (silentfov) { ImGui::GetBackgroundDrawList()->AddCircle(ImVec2(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2), silentaimfov, ImGui::ColorConvertFloat4ToU32(fovcolor), 100,1); }
    if (fovaimbot) { ImGui::GetBackgroundDrawList()->AddCircle(ImVec2(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2), aimbotfov, ImGui::ColorConvertFloat4ToU32(fovaimbotcolor), 100,1); }
}


void DrawWatermark() {
    if (watermark) {
        ImGuiIO& io = ImGui::GetIO();
        std::string watertext = std::string(ENCRYPT("FlexHack"));;
        watertext += std::string(ENCRYPT(" | "));
        watertext += namestring;

        auto textsize = 15;
        auto height = 0;
        auto textSizeX = ((ImGui::CalcTextSize(watertext.c_str()).x) / ImGui::GetFontSize()) * textsize;

        ImVec2 rectMin(20, 30 + height);
        ImVec2 rectMax(-40 + 80 + textSizeX, 65 - 10);

        ImGui::GetForegroundDrawList()->AddRectFilled(rectMin, rectMax, bgcolor, 0, 0);
        ImGui::GetForegroundDrawList()->AddLine(ImVec2(rectMin.x, rectMax.y), ImVec2(rectMax.x, rectMax.y), bordercolor, 2);
        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), textsize, ImVec2(30, (25 + 20 - (((ImGui::CalcTextSize(watertext.c_str()).y / 2) / ImGui::GetFontSize()) * textsize) + height) - 3), ImColor(255, 255, 255), watertext.c_str());
    }
}

void features(int type)
{   

    if(type == 0){
        ImGui::Checkbox(ENCRYPT("Enable"), &espen);
        ImGui::SameLine();
        ColorPicker(ENCRYPT("VisColor"), visibleCol);
        ImGui::SameLine();
        ColorPicker(ENCRYPT("InisColor"), invisibleCol);
        /*ImGui::SliderInt(ENCRYPT("b1"), &posbox1, -5, 5);
        ImGui::SliderInt(ENCRYPT("b2"), &posbox2, -5, 5);
        ImGui::SliderInt(ENCRYPT("b3"), &posbox3, -500, 500 );
        ImGui::SliderInt(ENCRYPT("b4"), &posbox4, -500, 500 );
        ImGui::SliderInt(ENCRYPT("h1"), &poshp1, -500, 500 );
        ImGui::SliderInt(ENCRYPT("h2"), &poshp2, -500, 500 );
        ImGui::SliderInt(ENCRYPT("h3"), &poshp3, -500, 500 );
        ImGui::SliderInt(ENCRYPT("h4"), &poshp4, -500, 500 );*/
        ImGui::Checkbox(ENCRYPT("Box"), &espbox);
            if(espbox){
                ImGui::Spacing();
                ImGui::SliderFloat(ENCRYPT("Stroke"), &espstroke,0.0f, 5.0f );
                ImGui::SliderFloat(ENCRYPT("Round"), &espround,0.0f, 10.0f );
                ImGui::Checkbox(ENCRYPT("Filled##box"), &espfill);
                if (espfill) {
                    ImGui::Spacing();
                    ImGui::SliderFloat(ENCRYPT("Fill value##box"), &espfillp, 20, 80);
                    ImGui::Checkbox(ENCRYPT("Fill gradient##box"), &espgradient);
                }
            }
        ImGui::Checkbox(ENCRYPT("Health"), &esphealth);
            if(esphealth){
                ImGui::SliderFloat(ENCRYPT("Stroke##hp"), &esphpsize ,0.0f, 10.0f );
            }
        ImGui::Checkbox(ENCRYPT("Armor"), &esparm);
        ImGui::Checkbox(ENCRYPT("Skeleton"), &espskeleton);
        ImGui::Checkbox(ENCRYPT("NickName"), &espname);
        ImGui::Checkbox(ENCRYPT("Weapon"), &espweapon);
    }

    if (type == 2){            
        ImGui::Checkbox(ENCRYPT("Third Person"), &thirdperson);
            if(thirdperson){
                ImGui::Spacing();
                ImGui::SliderFloat(ENCRYPT("Dist"), &thirdfloat, 0.f, 10.f);
            }

        ImGui::Checkbox(ENCRYPT("Hands Position"), &handspos);
            if(handspos){
                ImGui::Spacing();
                ImGui::SliderInt(ENCRYPT("X"), &handsX, -60, 60);
                ImGui::SliderInt(ENCRYPT("Y"), &handsY, -60, 60);
                ImGui::SliderInt(ENCRYPT("Z"), &handsZ, -60, 60);
            }
        ImGui::Checkbox(ENCRYPT("Ragdoll"), &ragdoll);
        ImGui::Checkbox(ENCRYPT("Watermark"), &watermark);
    }

    if(type == 3){
        ImGui::Checkbox(ENCRYPT("Enable Silent"), &silent);
        ImGui::Checkbox(ENCRYPT("AutoShoot"), &autoshoot);
        ImGui::Spacing();
        ImGui::SliderInt(ENCRYPT("Head"), &HeadPercent, 0, 100);
        ImGui::SliderInt(ENCRYPT("Neck"), &NeckPercent, 0, 100);
        ImGui::SliderInt(ENCRYPT("Hip"), &BodyPercent, 0, 100);
        ImGui::Spacing();
        ImGui::SliderInt(ENCRYPT("Fov"), &silentaimfov, 0, 720);
        ImGui::Checkbox(ENCRYPT("Draw"), &silentfov);
        ImGui::SameLine();
        ColorPicker(ENCRYPT("FovColor"), fovcolor);
    }

    if(type == 4){
        ImGui::Checkbox(ENCRYPT("Enable AimBot"), &defaim);
        ImGui::Checkbox(ENCRYPT("Only when Shooting"), &aimonshoot);
        ImGui::Spacing();
        ImGui::Combo(ENCRYPT("Bone"), &currbno, bnnes, IM_ARRAYSIZE(bnnes));
        ImGui::Spacing();
        ImGui::SliderFloat(ENCRYPT("Fov"), &aimbotfov, 0, 720);
        ImGui::Checkbox(ENCRYPT("Draw"), &fovaimbot);
        ImGui::SameLine();
        ColorPicker(ENCRYPT("FovColor"), fovaimbotcolor);
    }

    if (type == 6){
        ImGui::Checkbox(ENCRYPT("Enable AA"), &antiaims);
        if (antiaims) {
            ImGui::Spacing();
            ImGui::SliderFloat(ENCRYPT("x1"), &aax, 0.0f, 80.0f);
            ImGui::SliderFloat(ENCRYPT("y1"), &aay, 0.0f, 80.0f);
            ImGui::SliderFloat(ENCRYPT("z1"), &aaz, 0.0f, 80.0f);
            ImGui::SliderFloat(ENCRYPT("x2"), &asx, 0.0f, 80.0f);
            ImGui::SliderFloat(ENCRYPT("y2"), &asy, 0.0f, 80.0f);
            ImGui::SliderFloat(ENCRYPT("z2"), &asz, 0.0f, 80.0f);
            ImGui::SliderFloat(ENCRYPT("delta"), &aadelta, 0.0f, 1.0f);
        }
    }

    if (type == 7){
        ImGui::Checkbox(ENCRYPT("Wallshot"), &wallshoot);
        ImGui::Checkbox(ENCRYPT("Infinite ammo"), &ammo);
            if(ammo) {
                hexPatches.infinity.Modify();
            } else {
                hexPatches.infinity.Restore();
            }
    }

    if (type == 8){
        ImGui::Checkbox(ENCRYPT("Telekill"), &telekill);
        ImGui::Checkbox(ENCRYPT("Masskill"), &masskill);
    }

    if (type == 9){
        ImGui::Checkbox(ENCRYPT("FastGame [Host]"), &fastgame); 
            if(fastgame){
                hexPatches.fastwin.Modify();
            } else {
                hexPatches.fastwin.Restore();
            }
        ImGui::Checkbox(ENCRYPT("No Recoil"), &norec); 
            if (norec) {
                hexPatches.norecoil.Modify();
            } else {
                hexPatches.norecoil.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Money Hack"), &mhb); 
            if (mhb) {
                hexPatches.money.Modify();
            } else {
                hexPatches.money.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Anti-Flash"), &antiflbool);
            if (antiflbool) {
                hexPatches.antiflash.Modify();
            } else {
                hexPatches.antiflash.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Anti-HE"), &antihebool);
            if (antihebool) {
                hexPatches.antihae.Modify();
            } else {
                hexPatches.antihae.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Don't Return Spawn"), &dontretbool);
            if (dontretbool) {
                hexPatches.dontreturn.Modify();
            } else {
                hexPatches.dontreturn.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Respawn"), &respawnbool);
            if (respawnbool) {
                hexPatches.respawn.Modify();
            } else {
                hexPatches.respawn.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Air Jump"), &airjump);
        ImGui::Checkbox(ENCRYPT("Invisible"), &invis);
            if (invis) {
                hexPatches.invisible.Modify();
            } else {
                hexPatches.invisible.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Move Before Timer"), &movebef);
            if (movebef) {
                hexPatches.movebefore.Modify();
            } else {
                hexPatches.movebefore.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Plant Anywhere"), &plantanybool);
            if (plantanybool) {
                hexPatches.plantanywhere1.Modify(); 
                hexPatches.plantanywhere2.Modify(); 
                hexPatches.plantanywhere3.Modify(); 
                hexPatches.plantanywhere4.Modify(); 
            } else {
                hexPatches.plantanywhere1.Restore(); 
                hexPatches.plantanywhere2.Restore(); 
                hexPatches.plantanywhere3.Restore(); 
                hexPatches.plantanywhere4.Restore(); 
            }
        ImGui::Checkbox(ENCRYPT("Fast Bomb"), &fastbbool);
            if (fastbbool) {
                hexPatches.fastbomb.Modify();
            } else {
                hexPatches.fastbomb.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Bomb Immunity"), &bombimunbool);
            if (bombimunbool) {
                hexPatches.bombimmunity.Modify();
            } else {
                hexPatches.bombimmunity.Restore();
            }
        ImGui::Checkbox(ENCRYPT("Rare Anims"), &rareAnim);
    }

    if (type == 10) {
        ImGui::Checkbox(ENCRYPT("Add Score Me"), &addscorebool);
        ImGui::Checkbox(ENCRYPT("Add Score Team"), &addscoreboolteam);
        ImGui::Checkbox(ENCRYPT("Add Score Enemy"), &addscoreboolenemy);
    }

    if(type == 12){
        // weapons
        ImGui::Combo(ENCRYPT("AKR"), &akrrn, akrtype, IM_ARRAYSIZE(akrtype));
        ImGui::Combo(ENCRYPT("AKR12"), &akr12rn, akr12type, IM_ARRAYSIZE(akr12type));
        ImGui::Combo(ENCRYPT("M16"), &m16rn, m16type, IM_ARRAYSIZE(m16type));
        ImGui::Combo(ENCRYPT("M4"), &m4rn, m4type, IM_ARRAYSIZE(m4type));
        ImGui::Combo(ENCRYPT("M4A1"), &m41rn, m41type, IM_ARRAYSIZE(m41type));
        ImGui::Combo(ENCRYPT("Famas"), &famasrn, famastype, IM_ARRAYSIZE(famastype));
        ImGui::Combo(ENCRYPT("FnFal"), &fnfalrn, fnfaltype, IM_ARRAYSIZE(fnfaltype));
        ImGui::Combo(ENCRYPT("AWM"), &awmrn, awmtype, IM_ARRAYSIZE(awmtype));
        ImGui::Combo(ENCRYPT("M40"), &m40rn, m40type, IM_ARRAYSIZE(m40type));
        ImGui::Combo(ENCRYPT("M110"), &m110rn, m110type, IM_ARRAYSIZE(m110type));
        ImGui::Combo(ENCRYPT("USP"), &usprn, usptype, IM_ARRAYSIZE(usptype));
        ImGui::Combo(ENCRYPT("Deagle"), &deaglern, deagletype, IM_ARRAYSIZE(deagletype));
        ImGui::Combo(ENCRYPT("G22"), &g22rn, g22type, IM_ARRAYSIZE(g22type));
        ImGui::Combo(ENCRYPT("P350"), &p350rn, p350type, IM_ARRAYSIZE(p350type));
        ImGui::Combo(ENCRYPT("Tec-9"), &tec9rn, tec9type, IM_ARRAYSIZE(tec9type));
        ImGui::Combo(ENCRYPT("F/S"), &fsrn, fstype, IM_ARRAYSIZE(fstype));
        ImGui::Combo(ENCRYPT("Berettas"), &berettasrn, berettastype, IM_ARRAYSIZE(berettastype));
        ImGui::Combo(ENCRYPT("SM1014"), &sm1014rn, sm1014type, IM_ARRAYSIZE(sm1014type));
        ImGui::Combo(ENCRYPT("FaBM"), &fabmrn, fabmtype, IM_ARRAYSIZE(fabmtype));
        ImGui::Combo(ENCRYPT("SPAS"), &spasrn, spastype, IM_ARRAYSIZE(spastype));
        ImGui::Combo(ENCRYPT("M60"), &m60rn, m60type, IM_ARRAYSIZE(m60type));
        ImGui::Combo(ENCRYPT("UMP45"), &umprn, umptype, IM_ARRAYSIZE(umptype));
        ImGui::Combo(ENCRYPT("P90"), &p90rn, p90type, IM_ARRAYSIZE(p90type));
        ImGui::Combo(ENCRYPT("MP5"), &mp5rn, mp5type, IM_ARRAYSIZE(mp5type));
        ImGui::Combo(ENCRYPT("MP7"), &mp7rn, mp7type, IM_ARRAYSIZE(mp7type));
        ImGui::Combo(ENCRYPT("MAC-10"), &mac10rn, mac10type, IM_ARRAYSIZE(mac10type));
    }

    if(type == 13){
        // gloves
        ImGui::Combo(ENCRYPT("Glove Skin"), &gloven, glovestype,IM_ARRAYSIZE(glovestype));
    }

    if(type == 14){
        // knifes
        ImGui::Combo(ENCRYPT("Knife type"), &knifern, knifetypes, IM_ARRAYSIZE(knifetypes));
        if (knifern == 0) {
            weaponId = 0;
        }
        if (knifern == 1) {
            weaponId = 72;
            ImGui::Combo(ENCRYPT("Karambit skin"), &karambitrn, karambittype, IM_ARRAYSIZE(karambittype));
        }
        if (knifern == 2) {
            weaponId = 71;
            ImGui::Combo(ENCRYPT("M9 Bayonet skin"), &m9rn, m9type, IM_ARRAYSIZE(m9type));
        }
        if (knifern == 3) {
            weaponId = 75;
            ImGui::Combo(ENCRYPT("Butterfly skin"), &butterflyrn, butterflytype, IM_ARRAYSIZE(butterflytype));
        }
        if (knifern == 4) {
            weaponId = 73;
            ImGui::Combo(ENCRYPT("Jkommando skin"), &jkrn, jktype, IM_ARRAYSIZE(jktype));
        }
        if (knifern == 5) {
            weaponId = 79;
            ImGui::Combo(ENCRYPT("Scorpion skin"), &scorpionrn, scorpiontype, IM_ARRAYSIZE(scorpiontype));
        }
        if (knifern == 6) {
            weaponId = 78;
            ImGui::Combo(ENCRYPT("Kunai skin"), &kunairn, kunaitype, IM_ARRAYSIZE(kunaitype));
        }
        if (knifern == 7) {
            weaponId = 77;
            ImGui::Combo(ENCRYPT("FlipKnife skin"), &fliprn, fliptype, IM_ARRAYSIZE(fliptype));
        }
        if (knifern == 8) {
            weaponId = 80;
            ImGui::Combo(ENCRYPT("Tanto skin"), &tantorn, tantotype, IM_ARRAYSIZE(tantotype));
        }
        if (knifern == 9) {
            weaponId = 81;
            ImGui::Combo(ENCRYPT("Dual daggers skin"), &daggerrn, daggertype, IM_ARRAYSIZE(daggertype));
        }
        if (knifern == 10) {
            weaponId = 82;
            ImGui::Combo(ENCRYPT("Kukri skin"), &kukrirn, kukritype, IM_ARRAYSIZE(kukritype));
        }
        if (knifern == 11) {
            weaponId = 83;
            ImGui::Combo(ENCRYPT("Stilet skin"), &stiletn, stilettype, IM_ARRAYSIZE(stilettype));
        }
    }

    if (type == 15){
        ImGui::Checkbox(ENCRYPT("Enable"), &setcharmbool);
        ImGui::Spacing();
        if (setcharmbool){
            ImGui::Combo(ENCRYPT("Weapon"), &weaponcharm, weaponcharmtype, IM_ARRAYSIZE(weaponcharmtype));
            switch (weaponcharm){
                case 0:
                    akrcharmbool = true;
                    break;
                case 1:
                    akr12charmbool = true;
                    break;
                case 2:
                    m4charmbool = true;
                    break;
                case 3:
                    m4a1charmbool = true;
                    break;
                case 4:
                    m16charmbool = true;
                    break;
                case 5:
                    g22charmbool = true;
                    break;
                case 6:
                    uspcharmbool = true;
                    break;
            }
            if (weaponcharm == 0){
                ImGui::Combo(ENCRYPT("Charm"), &charmakrn, charmakrtype, IM_ARRAYSIZE(charmakrtype));
            }   
            if (weaponcharm == 1){
                ImGui::Combo(ENCRYPT("Charm"), &charmakr1n, charmakr1type, IM_ARRAYSIZE(charmakr1type));
            }
            if (weaponcharm == 2){
                ImGui::Combo(ENCRYPT("Charm"), &charmm4n, charmm4type, IM_ARRAYSIZE(charmm4type));
            }
            if (weaponcharm == 3){
                ImGui::Combo(ENCRYPT("Charm"), &charmm4a1n, charmm4a1type, IM_ARRAYSIZE(charmm4a1type));
            }
            if (weaponcharm == 4){
                ImGui::Combo(ENCRYPT("Charm"), &charmm16n, charmm16type, IM_ARRAYSIZE(charmm16type));
            }
            if (weaponcharm == 5){
                ImGui::Combo(ENCRYPT("Charm"), &charmg22n, charmg22type, IM_ARRAYSIZE(charmg22type));
            }
            if (weaponcharm == 6){
                ImGui::Combo(ENCRYPT("Charm"), &charmuspn, charmusptype, IM_ARRAYSIZE(charmusptype));
            }
        }
    }

    // stickers
    if(type == 16){
        ImGui::Checkbox(ENCRYPT("Enable"), &setstickbool);
        ImGui::Spacing();
        if (setstickbool){
            ImGui::Combo(ENCRYPT("Weapon"), &weaponstick, weapsticktype, IM_ARRAYSIZE(weapsticktype));
            switch (weaponstick){
                case 0:
                    akrstickbool = true;
                    break;
                case 1:
                    akr12stickbool = true;
                    break;
                case 2:
                    m4stickbool = true;
                    break;
                case 3:
                    m4a1stickbool = true;
                    break;
                case 4:
                    m16stickbool = true;
                    break;
                case 5:
                    g22stickbool = true;
                    break;
                case 6:
                    uspstickbool = true;
                    break;
            }
            if (weaponstick == 0){
                ImGui::Combo(ENCRYPT("pos 1"), &stickakrn, stickakrtype, IM_ARRAYSIZE(stickakrtype));
                ImGui::Combo(ENCRYPT("pos 2"), &stickakrn2, stickakrtype2, IM_ARRAYSIZE(stickakrtype2));
                ImGui::Combo(ENCRYPT("pos 3"), &stickakrn3, stickakrtype3, IM_ARRAYSIZE(stickakrtype3));
                ImGui::Combo(ENCRYPT("pos 4"), &stickakrn4, stickakrtype4, IM_ARRAYSIZE(stickakrtype4));
            }   
            if (weaponstick == 1){
                ImGui::Combo(ENCRYPT("pos 1"), &stickakr1n, stickakr1type, IM_ARRAYSIZE(stickakr1type));
                ImGui::Combo(ENCRYPT("pos 2"), &stickakr1n2, stickakr1type2, IM_ARRAYSIZE(stickakr1type2));
                ImGui::Combo(ENCRYPT("pos 3"), &stickakr1n3, stickakr1type3, IM_ARRAYSIZE(stickakr1type3));
                ImGui::Combo(ENCRYPT("pos 4"), &stickakr1n4, stickakr1type4, IM_ARRAYSIZE(stickakr1type4));
            }
            if (weaponstick == 2){
                ImGui::Combo(ENCRYPT("pos 1"), &stickm4n, stickm4type, IM_ARRAYSIZE(stickm4type));
                ImGui::Combo(ENCRYPT("pos 2"), &stickm4n2, stickm4type2, IM_ARRAYSIZE(stickm4type2));
                ImGui::Combo(ENCRYPT("pos 3"), &stickm4n3, stickm4type3, IM_ARRAYSIZE(stickm4type3));
                ImGui::Combo(ENCRYPT("pos 4"), &stickm4n4, stickm4type4, IM_ARRAYSIZE(stickm4type4));
            }
            if (weaponstick == 3){
                ImGui::Combo(ENCRYPT("pos 1"), &stickm4a1n, stickm4a1type, IM_ARRAYSIZE(stickm4a1type));
                ImGui::Combo(ENCRYPT("pos 2"), &stickm4a1n2, stickm4a1type2, IM_ARRAYSIZE(stickm4a1type2));
                ImGui::Combo(ENCRYPT("pos 3"), &stickm4a1n3, stickm4a1type3, IM_ARRAYSIZE(stickm4a1type3));
                ImGui::Combo(ENCRYPT("pos 4"), &stickm4a1n4, stickm4a1type4, IM_ARRAYSIZE(stickm4a1type4));
            }
            if (weaponstick == 4){
                ImGui::Combo(ENCRYPT("pos 1"), &stickm16n, stickm16type, IM_ARRAYSIZE(stickm16type));
                ImGui::Combo(ENCRYPT("pos 2"), &stickm16n2, stickm16type2, IM_ARRAYSIZE(stickm16type2));
                ImGui::Combo(ENCRYPT("pos 3"), &stickm16n3, stickm16type3, IM_ARRAYSIZE(stickm16type3));
                ImGui::Combo(ENCRYPT("pos 4"), &stickm16n4, stickm16type4, IM_ARRAYSIZE(stickm16type4));
            }
            if (weaponstick == 5){
                ImGui::Combo(ENCRYPT("pos 1"), &stickg22n, stickg22type, IM_ARRAYSIZE(stickg22type));
                ImGui::Combo(ENCRYPT("pos 2"), &stickg22n2, stickg22type2, IM_ARRAYSIZE(stickg22type2));
                ImGui::Combo(ENCRYPT("pos 3"), &stickg22n3, stickg22type3, IM_ARRAYSIZE(stickg22type3));
                ImGui::Combo(ENCRYPT("pos 4"), &stickg22n4, stickg22type4, IM_ARRAYSIZE(stickg22type4));
            }
            if (weaponstick == 6){
                ImGui::Combo(ENCRYPT("pos 1"), &stickuspn, stickusptype, IM_ARRAYSIZE(stickusptype));
                ImGui::Combo(ENCRYPT("pos 2"), &stickuspn2, stickusptype2, IM_ARRAYSIZE(stickusptype2));
                ImGui::Combo(ENCRYPT("pos 3"), &stickuspn3, stickusptype3, IM_ARRAYSIZE(stickusptype3));
                ImGui::Combo(ENCRYPT("pos 4"), &stickuspn4, stickusptype4, IM_ARRAYSIZE(stickusptype4));
            }
        }
    }
}


#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}
#pragma mark - MTKViewDelegate

- (void)drawInMTKView:(MTKView*)view
{
   
    
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 120);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    

//Define active function
    static bool show_s0_active = false;
    
        

        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor != nil)
        {
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:@"ImGui Jane"];

            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();
            
            if (MenDeal == true) {
            [self.view setUserInteractionEnabled:YES];
        } else if (MenDeal == false) {
            [self.view setUserInteractionEnabled:NO];
        }
            
            
            CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 360) / 2;
            CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 300) / 2;
            
            ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
            ImGui::SetNextWindowSize(ImVec2(444, 355), ImGuiCond_FirstUseEver);

            static int selected = 0;
            static int sub_selected = 0;

                

            
            if (MenDeal == true)
            {
             
                             
                ImGui::Begin("AquaCheats | Test build", nullptr, ImGuiWindowFlags_NoDecoration);

                auto draw = ImGui::GetWindowDrawList();

                ImGui::GetStyle().WindowPadding = ImVec2(0,0);
                ImVec2 pos = ImGui::GetWindowPos();
                ImVec2 size = ImGui::GetWindowSize();
                draw->AddRectFilled(ImVec2(pos.x - 100, pos.y), ImVec2(pos.x + 65, pos.y + size.y), ImColor(13, 10, 27, 255));

                ImGui::SetCursorPos(ImVec2(20, 30));
                ImGui::Text("FLEX");
                
                ImGui::SetCursorPos(ImVec2(25, 70));
                ImGui::BeginGroup();
                if (custom_interface::tab(ICON_FA_EYE, ENCRYPT("VISUALS"), 1 == selected, 0, 0, -15, 25)) {
                    selected = 1;
                }
                
                if (custom_interface::tab(ICON_FA_HOUSE_CHIMNEY, ENCRYPT("MAIN"), 2 == selected, 0, 0, -8, 25)) {
                    selected = 2;
                }
                
                if (custom_interface::tab(ICON_FA_GEAR, ENCRYPT("OTHER"), 3 == selected, 1, 0, -12, 25)) {
                    selected = 3;
                }
                
                if (custom_interface::tab(ICON_FA_PAINTBRUSH, ENCRYPT("SKINS"), 4 == selected, 0, 0, -10, 25)) {
                    selected = 4;
                }
                ImGui::EndGroup();

                if (selected == 1){

                    ImGui::SetCursorPos(ImVec2(80,12));
                    ImGui::BeginGroup();
                    if(custom_interface::subtab(ENCRYPT("Esp"), 1 == sub_selected)){
                        sub_selected = 1;
                    }

                    ImGui::SameLine();
                    if(custom_interface::subtab(ENCRYPT("Other"), 2 == sub_selected)){
                        sub_selected = 2;
                    }

                    ImGui::EndGroup();

                        if(sub_selected == 1){
                            ImGui::SetCursorPos(ImVec2(80, 60));
                            ImGui::BeginChild(ENCRYPT("Esp"), ImVec2(160,290));
                            { 
                                if(ImGui::Button("Close menu")) MenDeal = !MenDeal;
                                features(0);
                            }
                            ImGui::EndChild();

                            ImGui::SetCursorPos(ImVec2(255, 60));
                            ImGui::BeginChild(ENCRYPT("Preview"), ImVec2(160,290));
                            {
                                if (espbox) {
                                    ImGui::SetCursorPos(ImVec2(140, 200));
                                    ImVec2 pos1 = ImGui::GetCursorScreenPos();
                                    draw->AddRect(ImVec2(pos1.x - 110, pos1.y - 155), ImVec2(pos1.x - 10, pos1.y + 35), ImColor(invisibleCol.x, invisibleCol.y, invisibleCol.z, 0.8f), espround,0,espstroke);
                                }
                                if (espfill) {
                                    ImGui::SetCursorPos(ImVec2(140, 200));
                                    ImVec2 pos1 = ImGui::GetCursorScreenPos();
                                    draw->AddRectFilledMultiColor(ImVec2(pos1.x - 110, pos1.y - 155), ImVec2(pos1.x - 10, pos1.y + 35), 
                                        ImColor((int) (invisibleCol.x * 255),
                                                (int) (invisibleCol.y * 255),
                                                (int) (invisibleCol.z * 255),
                                                (int) ((float) (espgradient ? 10
                                                                            : 80) *
                                                       (float) espfillp / 100.0f)),
                                        ImColor((int) (invisibleCol.x * 255),
                                                (int) (invisibleCol.y * 255),
                                                (int) (invisibleCol.z * 255),
                                                (int) ((float) (espgradient ? 10
                                                                            : 80) *
                                                       (float) espfillp / 100.0f)),
                                        ImColor((int) (invisibleCol.x * 255),
                                                (int) (invisibleCol.y * 255),
                                                (int) (invisibleCol.z * 255),
                                                (int) (80.0f * (float) espfillp /
                                                       100.0f)),
                                        ImColor((int) (invisibleCol.x * 255),
                                                (int) (invisibleCol.y * 255),
                                                (int) (invisibleCol.z * 255),
                                                (int) (80.0f * (float) espfillp /
                                                       100.0f)));           }
                                if (esphealth) {
                                    ImGui::SetCursorPos(ImVec2(140, 200));
                                    ImVec2 pos1 = ImGui::GetCursorScreenPos();
                                    draw->AddRectFilled(ImVec2(pos1.x - 125, pos1.y - 155), ImVec2(pos1.x - 120, pos1.y + 35),
                                        ImColor(150, 255, 100, 255));
                                        
                                }
                                if (esparm) {
                                    ImGui::SetCursorPos(ImVec2(140, 140));
                                    ImVec2 pos1 = ImGui::GetCursorScreenPos();
                                    draw->AddText(
                                    ImGui::GetFont(),
                                    ImGui::GetFontSize() + esphptextsize,
                                    ImVec2(pos1.x - 10, pos1.y - 80),
                                    ImColor(66, 188, 245, 255),
                                    "100a");                
                                }
                                if (espname) {
                                    ImGui::SetCursorPos(ImVec2(140, 140));
                                    ImVec2 pos1 = ImGui::GetCursorScreenPos();
                                    draw->AddText(ImVec2(pos1.x - 95, pos1.y - 115), ImColor(Esp_NC.x, Esp_NC.y, Esp_NC.z), "propaganda");
                                }
                                if (espweapon) {
                                    ImGui::SetCursorPos(ImVec2(135, 140));
                                    ImVec2 pos1 = ImGui::GetCursorScreenPos();
                                    draw->AddText(ImVec2(pos1.x - 65, pos1.y + 105), ImColor(Esp_NC.x, Esp_NC.y, Esp_NC.z), "akr");
                                }             
                            }
                            ImGui::EndChild();
                        }

                        if(sub_selected == 2){
                            ImGui::SetCursorPos(ImVec2(80, 60));
                            ImGui::BeginChild(ENCRYPT("Other"), ImVec2(345,290));
                            {
                                features(2);
                            }
                            ImGui::EndChild();
                        }
                }

                if (selected == 2){

                    ImGui::SetCursorPos(ImVec2(80,12));
                    ImGui::BeginGroup();
                    if(custom_interface::subtab(ENCRYPT("Legit"), 1 == sub_selected)){
                        sub_selected = 1;
                    }
                    ImGui::SameLine();
                    if(custom_interface::subtab(ENCRYPT("Rage"), 2 == sub_selected)){
                        sub_selected = 2;
                    }
                    ImGui::EndGroup();

                        if(sub_selected == 1){
                            ImGui::SetCursorPos(ImVec2(80,60));
                            ImGui::BeginChild(ENCRYPT("Silent"), ImVec2(160,290));
                            {
                                features(3);
                            }
                            ImGui::EndChild();

                            ImGui::SetCursorPos(ImVec2(255, 60));
                            ImGui::BeginChild(ENCRYPT("Aimbot"), ImVec2(160,290));
                            {
                                features(4);
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();
                        }

                        if(sub_selected == 2){
                            ImGui::SetCursorPos(ImVec2(80,60));
                            ImGui::BeginChild(ENCRYPT("Anti-Aim"), ImVec2(160,290));
                            {
                                features(6);
                            }
                            ImGui::EndChild();

                            ImGui::SetCursorPos(ImVec2(255, 60));
                            ImGui::BeginChild(ENCRYPT("Weapon"), ImVec2(160,130));
                            {
                                features(7);
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();


                            ImGui::SetCursorPos(ImVec2(255, 210));
                            ImGui::BeginChild(ENCRYPT("Me and Enemy"), ImVec2(160,140));
                            {
                                features(8);
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();
                        }
                } 

                if (selected == 3){

                    ImGui::SetCursorPos(ImVec2(80,12));
                    ImGui::BeginGroup();
                    if(custom_interface::subtab(ENCRYPT("Other"), 1 == sub_selected)){
                        sub_selected = 1;
                    }
                    ImGui::EndGroup();

                        if(sub_selected == 1){
                            ImGui::SetCursorPos(ImVec2(80, 60));
                            ImGui::BeginChild(ENCRYPT("Main"), ImVec2(160,290));
                            {
                                features(9);
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();

                            ImGui::SetCursorPos(ImVec2(255, 60));
                            ImGui::BeginChild(ENCRYPT("Stats"), ImVec2(160,100));
                            {
                                features(10);
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();

                            ImGui::SetCursorPos(ImVec2(255, 175));
                            ImGui::BeginChild(ENCRYPT("Profile"), ImVec2(160,175));
                            {
                                ImGui::Text("Soon");
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();
                        }
                }

                if (selected == 4){
                
                    ImGui::SetCursorPos(ImVec2(80,12));
                    ImGui::BeginGroup();
                    if(custom_interface::subtab(ENCRYPT("Skins"), 1 == sub_selected)){
                        sub_selected = 1;
                    }

                    ImGui::SameLine();
                    if(custom_interface::subtab(ENCRYPT("Stickers"), 2 == sub_selected)){
                        sub_selected = 2;
                    }
                    ImGui::EndGroup();


                        if(sub_selected == 1){
                            ImGui::SetCursorPos(ImVec2(80, 60));
                            ImGui::BeginChild(ENCRYPT("Weapons"), ImVec2(160, 290));
                            {
                                features(12);
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();
                            
                            ImGui::SetCursorPos(ImVec2(255, 60));
                            ImGui::BeginChild(ENCRYPT("Gloves"), ImVec2(160,65));
                            {
                                features(13);
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();
                            
                            ImGui::SetCursorPos(ImVec2(255, 155));
                            ImGui::BeginChild(ENCRYPT("Knifes"), ImVec2(160,65));
                            {
                                features(14);
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();
                            
                            ImGui::SetCursorPos(ImVec2(255, 250));
                            ImGui::BeginChild(ENCRYPT("Charms"), ImVec2(160,100));
                            {
                                features(15);
                                ImGui::Spacing();
                            }
                            ImGui::EndChild();
                        }

                        if(sub_selected == 2){
                            ImGui::SetCursorPos(ImVec2(80,60));
                            ImGui::BeginChild(ENCRYPT("Stickers"), ImVec2(345,290));
                            {
                                features(16);
                            }
                            ImGui::EndChild();
                        }
                }

                ImGui::End();
               


                
                
            }
            ImDrawList* draw_list = ImGui::GetBackgroundDrawList();

            DrawOtherElements();
            DrawEsp();
            DrawWatermark();


            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
          
            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];
            
            [commandBuffer presentDrawable:view.currentDrawable];
        }

        [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}

void hooking(){
    
    HOOK(ENCRYPTOFFSET("0x1B00528"), Player_Update, old_Player_Update);
    HOOK(ENCRYPTOFFSET("0x1CF6A20"), EquipedKnife, old_EquipedKnife);
    HOOK(ENCRYPTOFFSET("0x1CF49A0"), EquipedSkin, old_EquipedSkin);
    HOOK(ENCRYPTOFFSET("0x1C3162C"), SetSticker, old_SetSticker);
    HOOK(ENCRYPTOFFSET("0x1CA1A78"), Charm, old_Charm);
    HOOK(ENCRYPTOFFSET("0x1D3F388"), setGloves, old_setGloves);
    HOOK(ENCRYPTOFFSET("0x1AFF2FC"), becameinvisible, old_becameinvisible);
    HOOK(ENCRYPTOFFSET("0x1AFF374"), becamevisible, old_becamevisible);
    HOOK(ENCRYPTOFFSET("0x1D1BFE8"), CastBullet, old_CastBullet);
    HOOK(ENCRYPTOFFSET("0x1B00594"), PlayerControllerLateUpdate, old_PlayerControllerLateUpdate);
    HOOK(ENCRYPTOFFSET("0x1B3A524"), RagdollController_Simulate, old_RagdollController_Simulate);
    HOOK(ENCRYPTOFFSET("0x1D1BB30"), wall, old_wall);
    HOOK(ENCRYPTOFFSET("0x34D7D50"), air_jump_system, old_air_jump_system_general);
    HOOK(ENCRYPTOFFSET("0x3484354"), Random_Range, old_Random_Range);
    HOOK(ENCRYPTOFFSET("0x1D20C00"), FireUpdate, old_FireUpdate);
    HOOK(ENCRYPTOFFSET("0x1D20AC4"), FireCtor, old_FireCtor);

    IsLocal = (bool (*)(void *))getRealOffset(ENCRYPTOFFSET("0x1AFDF7C"));
    AddScore = (void (*)(void *, int))getRealOffset(ENCRYPTOFFSET("0x1D77A78"));
    GetPlayerTeam = (int (*)(void *))getRealOffset(ENCRYPTOFFSET("0x1B01690"));
    GetPlayerArmor = (int (*)(void *))getRealOffset(ENCRYPTOFFSET("0x1AFB374"));
    GetPlayerHealth = (int (*)(void *))getRealOffset(ENCRYPTOFFSET("0x1AFB260"));
    get_position = (Vector3 (*)(void *))getRealOffset(ENCRYPTOFFSET("0x348F87C"));
    WorldToScreenPoint = (Vector3 (*)(void *, Vector3 ))getRealOffset(ENCRYPTOFFSET("0x3465068"));
    get_camera = (void* (*)())getRealOffset(ENCRYPTOFFSET("0x346541C"));
    get_transform = (void *(*)(void*))getRealOffset(ENCRYPTOFFSET("0x3485CE4"));
    get_BipedMap = (void *(*)(void*))getRealOffset(ENCRYPTOFFSET("0x1AFCB0C"));
    GetNickName = (monoString* (*)(void *))getRealOffset(ENCRYPTOFFSET("0x1ACD87C"));
    set_position = (void (*)(void*, Vector3))getRealOffset(ENCRYPTOFFSET("0x348F92C"));
    set_TpsView = (void (*)(void*))getRealOffset(ENCRYPTOFFSET("0x1AFD6D8"));
    set_FpsView = (void (*)(void*))getRealOffset(ENCRYPTOFFSET("0x1AFDF9C"));
    get_forward = (Vector3 (*)(void*))getRealOffset(ENCRYPTOFFSET("0x348FE64"));
    Linecast228 = (bool (*)(Vector3, Vector3, int))getRealOffset(ENCRYPTOFFSET("0x34D4CE8"));
    Fire = (void (*)(void *, bool))getRealOffset(ENCRYPTOFFSET("0x1D20C00"));

    hexPatches.fastwin = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1E65214"), ENCRYPTHEX("0xE003271EC0035FD6"));
    hexPatches.norecoil = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D21300"), ENCRYPTHEX("0xC0035FD6")); 
    hexPatches.infinity = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1E65448"), ENCRYPTHEX("0x20008052C0035FD6")); 
    hexPatches.money = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D63484"), ENCRYPTHEX("0x00008052C0035FD6"));
    hexPatches.antiflash = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D2E75C"), ENCRYPTHEX("0xC0035FD6"));
    hexPatches.antihae = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D353C8"), ENCRYPTHEX("0xC0035FD6"));
    hexPatches.dontreturn = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D606D8"), ENCRYPTHEX("0x00008052C0035FD6"));
    hexPatches.respawn = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1DE938C"), ENCRYPTHEX("0x20008052C0035FD6"));
    hexPatches.invisible = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1AF9E80"), ENCRYPTHEX("0xC0035FD6"));
    hexPatches.movebefore = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1E57544"), ENCRYPTHEX("0xC0035FD6"));
    hexPatches.plantanywhere1 = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D4E6E0"), ENCRYPTHEX("0x20008052C0035FD6"));
    hexPatches.plantanywhere2 = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D4E708"), ENCRYPTHEX("0x20008052C0035FD6"));
    hexPatches.plantanywhere3 = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D4E730"), ENCRYPTHEX("0x20008052C0035FD6"));
    hexPatches.plantanywhere4 = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D4E758"), ENCRYPTHEX("0x20008052C0035FD6"));
    hexPatches.fastbomb = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D4D98C"), ENCRYPTHEX("0x20008052C0035FD6"));
    hexPatches.bombimmunity = MemoryPatch::createWithHex(ENCRYPT("UnityFramework"), ENCRYPTOFFSET("0x1D4DC90"), ENCRYPTHEX("0x20008052C0035FD6"));

    patchOffset(ENCRYPTOFFSET("0x1EB78CC"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB77D4"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB51B4"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB4EE0"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB371C"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB412C"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB25C8"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB2A38"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB306C"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB2E08"), ENCRYPTHEX("0xC0035FD6"));
    patchOffset(ENCRYPTOFFSET("0x1EB3954"), ENCRYPTHEX("0xC0035FD6"));

}

void *hack_thread(void *) {
    sleep(5);
    hooking();
    pthread_exit(nullptr);
    return nullptr;
}

void __attribute__((constructor)) initialize() {
    pthread_t hacks;
    pthread_create(&hacks, NULL, hack_thread, NULL); 
}


@end



