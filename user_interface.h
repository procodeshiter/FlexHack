#pragma once

#include <stdint.h>
#include <algorithm>
#include <iostream>
#include <iomanip>
#include <map>

#include "IMGUI/imgui.h"
#include "IMGUI/imgui_internal.h"

namespace custom_interface {
    bool tab(const char* label, const char* nametext, bool selected, int int1, int int2, int int3, int int4);
    bool subtab(const char* label, bool selected);
}
