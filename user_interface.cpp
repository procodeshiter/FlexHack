#include "user_interface.h"
ImFont* icfont;
ImFont* tabs;

int poss1;
int poss2;

struct tab_anim
{
    int hovered_anim;
    int active_anim;
};

bool custom_interface::tab(const char* label, const char* nametext, bool selected, int int1, int int2,int int3,int int4)
{
    ImGuiWindow* window = ImGui::GetCurrentWindow();
    if (window->SkipItems)
        return false;

    ImGuiContext& g = *GImGui;
    const ImGuiStyle& style = g.Style;
    const ImGuiID id = window->GetID(label);
    const ImVec2 label_size = ImGui::CalcTextSize(label, NULL, true);
    ImVec2 pos = window->DC.CursorPos;

    const ImRect rect(pos, ImVec2(pos.x + 50, pos.y + 50));
    ImGui::ItemSize(ImVec4(rect.Min.x, rect.Min.y, rect.Max.x, rect.Max.y + 5), style.FramePadding.y);
    if (!ImGui::ItemAdd(rect, id))
        return false;

    bool hovered, held;
    bool pressed = ImGui::ButtonBehavior(rect, id, &hovered, &held, ImGuiButtonFlags_None);

    static std::map <ImGuiID, tab_anim> anim;
    auto it_anim = anim.find(id);
    if (it_anim == anim.end())
    {
        anim.insert({ id, {0, 0} });
        it_anim = anim.find(id);
    }

    if (hovered)
        it_anim->second.hovered_anim += 8 * (1.f - ImGui::GetIO().DeltaTime);
    else
        it_anim->second.hovered_anim -= 8 * (1.f - ImGui::GetIO().DeltaTime);

    if (it_anim->second.hovered_anim > 50)
        it_anim->second.hovered_anim = 50;
    else if (it_anim->second.hovered_anim < 0)
        it_anim->second.hovered_anim = 0;

    if (selected)
        it_anim->second.active_anim += 16 * (1.f - ImGui::GetIO().DeltaTime);
    else
        it_anim->second.active_anim -= 16 * (1.f - ImGui::GetIO().DeltaTime);

    if (it_anim->second.active_anim > 155)
        it_anim->second.active_anim = 155;
    else if (it_anim->second.active_anim < 0)
        it_anim->second.active_anim = 0;
    //41 50
	ImGui::PushFont(icfont);
    window->DrawList->AddText(ImVec2(rect.Min.x + int1, rect.Min.y + int2), ImColor(255, 255, 255, 100 + it_anim->second.hovered_anim + it_anim->second.active_anim), label);
	ImGui::PopFont();
	ImGui::PushFont(tabs);
	window->DrawList->AddText(ImVec2(rect.Min.x + int3, rect.Min.y + int4), ImColor(255, 255, 255, 100 + it_anim->second.hovered_anim + it_anim->second.active_anim), nametext);
	ImGui::PopFont();
	
    return pressed;
}

struct subtab_anim
{
    int active_text_anim;
    int active_rect_alpha;
};

bool custom_interface::subtab(const char* label, bool selected)
{
    ImGuiWindow* window = ImGui::GetCurrentWindow();
    if (window->SkipItems)
        return false;

    ImGuiContext& g = *GImGui;
    const ImGuiStyle& style = g.Style;
    const ImGuiID id = window->GetID(label);
    const ImVec2 label_size = ImGui::CalcTextSize(label, NULL, true);
    ImVec2 pos = window->DC.CursorPos;

    const ImRect rect(pos, ImVec2(pos.x + label_size.x, pos.y + 40));
    ImGui::ItemSize(ImVec4(rect.Min.x, rect.Min.y, rect.Max.x + 2.f, rect.Max.y), style.FramePadding.y);
    if (!ImGui::ItemAdd(rect, id))
        return false;

    bool hovered, held;
    bool pressed = ImGui::ButtonBehavior(rect, id, &hovered, &held, ImGuiButtonFlags_None);

    static std::map <ImGuiID, subtab_anim> anim;
    auto it_anim = anim.find(id);
    if (it_anim == anim.end())
    {
        anim.insert({ id, {0, 0} });
        it_anim = anim.find(id);
    }

    if (selected)
        it_anim->second.active_text_anim += 16 * (1.f - ImGui::GetIO().DeltaTime);
    else
        it_anim->second.active_text_anim -= 16 * (1.f - ImGui::GetIO().DeltaTime);

    if (it_anim->second.active_text_anim > 155)
        it_anim->second.active_text_anim = 155;
    else if (it_anim->second.active_text_anim < 0)
        it_anim->second.active_text_anim = 0;

    if (selected)
        it_anim->second.active_rect_alpha += 20 * (1.f - ImGui::GetIO().DeltaTime);
    else
        it_anim->second.active_rect_alpha -= 20 * (1.f - ImGui::GetIO().DeltaTime);

    if (it_anim->second.active_rect_alpha > 255)
        it_anim->second.active_rect_alpha = 255;
    else if (it_anim->second.active_rect_alpha < 0)
        it_anim->second.active_rect_alpha = 0;

    window->DrawList->AddRectFilled(ImVec2(rect.Min.x, rect.Min.y + 26), ImVec2(rect.Max.x, rect.Max.y - 16), ImColor(129, 137, 183, it_anim->second.active_rect_alpha));
    window->DrawList->AddText(ImVec2((rect.Min.x + rect.Max.x) / 2.f - (label_size.x / 2.f), (rect.Min.y + rect.Max.y) / 2.f - (label_size.y / 2.f) - 5), ImColor(255, 255, 255, (100 + it_anim->second.active_text_anim)), label);

    return pressed;
}
