void *get_boneget(void *player, uint64_t premit) {
	return *(void **)((uint64_t) get_BipedMap(player) + premit);
}

template <typename T>
inline T clamp(const T& n, const T& lower, const T& upper) {
    return std::max(lower, std::min(n, upper));
}

inline float lerp(float a, float b, float f) {
		return clamp<float>(a + f * (b - a),a > b ? b : a,a > b ? a : b);
}

inline void arc(float x, float y, float radius, float min_angle, float max_angle, ImColor col, float thickness) {
		getDrawList() ->PathArcTo(ImVec2 (x, y), radius, Deg2Rad * min_angle, Deg2Rad * max_angle, 32);
		getDrawList() ->PathStroke(col, false, thickness);
}

void DrawSkeleton(void* player, ImColor color) {
	if (GetPlayerTeam(player) != GetPlayerTeam(me)) {
		void *aimedPlayerHead = *(void **) ((uint64_t) get_BipedMap(player) + 0x18);
		Vector3 HeadPos = Vector3(get_position(aimedPlayerHead).x, get_position(aimedPlayerHead).y,
								  get_position(aimedPlayerHead).z);
		bool HeadChecker;
		ImVec2 HeadPosFixed = world2screen_s(HeadPos, HeadChecker);
		
		Vector3 HeadUpPos = Vector3(get_position(aimedPlayerHead).x, get_position(aimedPlayerHead).y + 0.3f,
								  get_position(aimedPlayerHead).z);
		bool HeadUpChecker;
		ImVec2 HeadUpPosFixed = world2screen_s(HeadUpPos, HeadUpChecker);
		
		Vector3 NeckPos = Vector3(get_position(get_boneget(player, 0x20)).x, 
								  get_position(get_boneget(player, 0x20)).y,
								  get_position(get_boneget(player, 0x20)).z);
		bool NeckChecker;
		ImVec2 NeckPosFixed = world2screen_s(NeckPos, NeckChecker);
		Vector3 Spine2Pos = Vector3(get_position(get_boneget(player, 0x30)).x,
									get_position(get_boneget(player, 0x30)).y,
									get_position(get_boneget(player, 0x30)).z);
		bool Spine2Checker;
		ImVec2 Spine2PosFixed = world2screen_s(Spine2Pos, Spine2Checker);
		Vector3 Spine1Pos = Vector3(get_position(get_boneget(player, 0x28)).x,
									get_position(get_boneget(player, 0x28)).y,
									get_position(get_boneget(player, 0x28)).z);
		bool Spine1Checker;
		ImVec2 Spine1PosFixed = world2screen_s(Spine1Pos, Spine1Checker);
		Vector3 HipPos = Vector3(get_position(get_boneget(player, 0x78)).x, 
								 get_position(get_boneget(player, 0x78)).y,
								 get_position(get_boneget(player, 0x78)).z);
		bool HipChecker;
		ImVec2 HipPosFixed = world2screen_s(HipPos, HipChecker);
		Vector3 LeftShouldPos = Vector3(get_position(get_boneget(player, 0x38)).x,
										get_position(get_boneget(player, 0x38)).y,
										get_position(get_boneget(player, 0x38)).z);
		bool LeftShouldChecker;
		ImVec2 LeftShouldPosFixed = world2screen_s(LeftShouldPos, LeftShouldChecker);
		Vector3 RightShouldPos = Vector3(get_position(get_boneget(player, 0x58)).x,
										 get_position(get_boneget(player, 0x58)).y,
										 get_position(get_boneget(player, 0x58)).z);
		bool RightShouldChecker;
		ImVec2 RightShouldPosFixed = world2screen_s(RightShouldPos, RightShouldChecker);
		Vector3 LeftUpperPos = Vector3(get_position(get_boneget(player, 0x40)).x,
									   get_position(get_boneget(player, 0x40)).y,
									   get_position(get_boneget(player, 0x40)).z);
		bool LeftUpperChecker;
		ImVec2 LeftUpperPosFixed = world2screen_s(LeftUpperPos, LeftUpperChecker);
		Vector3 RightUpperPos = Vector3(get_position(get_boneget(player, 0x60)).x,
										get_position(get_boneget(player, 0x60)).y,
										get_position(get_boneget(player, 0x60)).z);
		bool RightUpperChecker;
		ImVec2 RightUpperPosFixed = world2screen_s(RightUpperPos, RightUpperChecker);
		Vector3 LeftForePos = Vector3(get_position(get_boneget(player, 0x48)).x,
									  get_position(get_boneget(player, 0x48)).y,
									  get_position(get_boneget(player, 0x48)).z);
		bool LeftForeChecker;
		ImVec2 LeftForePosFixed = world2screen_s(LeftForePos, LeftForeChecker);
		Vector3 RightForePos = Vector3(get_position(get_boneget(player, 0x68)).x,
									   get_position(get_boneget(player, 0x68)).y,
									   get_position(get_boneget(player, 0x68)).z);
		bool RightForeChecker;
		ImVec2 RightForePosFixed = world2screen_s(RightForePos, RightForeChecker);
		Vector3 LeftHandPos = Vector3(get_position(get_boneget(player, 0x50)).x,
									  get_position(get_boneget(player, 0x50)).y,
									  get_position(get_boneget(player, 0x50)).z);
		bool LeftHandChecker;
		ImVec2 LeftHandPosFixed = world2screen_s(LeftHandPos, LeftHandChecker);
		Vector3 RightHandPos = Vector3(get_position(get_boneget(player, 0x70)).x,
									   get_position(get_boneget(player, 0x70)).y,
									   get_position(get_boneget(player, 0x70)).z);
		bool RightHandChecker;
		ImVec2 RightHandPosFixed = world2screen_s(RightHandPos, RightHandChecker);
		Vector3 LeftThiPos = Vector3(get_position(get_boneget(player, 0x80)).x,
									 get_position(get_boneget(player, 0x80)).y,
									 get_position(get_boneget(player, 0x80)).z);
		bool LeftThiChecker;
		ImVec2 LeftThiPosFixed = world2screen_s(LeftThiPos, LeftThiChecker);
		Vector3 RightThiPos = Vector3(get_position(get_boneget(player, 0x98)).x,
									  get_position(get_boneget(player, 0x98)).y,
									  get_position(get_boneget(player, 0x98)).z);
		bool RightThiChecker;
		ImVec2 RightThiPosFixed = world2screen_s(RightThiPos, RightThiChecker);
		Vector3 LeftCalfPos = Vector3(get_position(get_boneget(player, 0x88)).x,
									  get_position(get_boneget(player, 0x88)).y,
									  get_position(get_boneget(player, 0x88)).z);
		bool LeftCalfChecker;
		ImVec2 LeftCalfPosFixed = world2screen_s(LeftCalfPos, LeftCalfChecker);
		Vector3 RightCalfPos = Vector3(get_position(get_boneget(player, 0xA0)).x,
									   get_position(get_boneget(player, 0xA0)).y,
									   get_position(get_boneget(player, 0xA0)).z);
		bool RightCalfChecker;
		ImVec2 RightCalfPosFixed = world2screen_s(RightCalfPos, RightCalfChecker);
		Vector3 LeftFootPos = Vector3(get_position(get_boneget(player, 0x90)).x,
									  get_position(get_boneget(player, 0x90)).y,
									  get_position(get_boneget(player, 0x90)).z);
		bool LeftFootChecker;
		ImVec2 LeftFootPosFixed = world2screen_s(LeftFootPos, LeftFootChecker);
		Vector3 RightFootPos = Vector3(get_position(get_boneget(player, 0xA8)).x,
									   get_position(get_boneget(player, 0xA8)).y,
									   get_position(get_boneget(player, 0xA8)).z);
		bool RightFootChecker;
		ImVec2 RightFootPosFixed = world2screen_s(RightFootPos, RightFootChecker);
		if (RightFootChecker && LeftFootChecker && RightCalfChecker && LeftCalfChecker &&
			RightThiChecker && LeftThiChecker && RightHandChecker && LeftHandChecker &&
			RightForeChecker && LeftForeChecker && RightUpperChecker && LeftUpperChecker &&
			RightShouldChecker && LeftShouldChecker && HipChecker && Spine1Checker &&
			Spine2Checker && NeckChecker && HeadChecker && HeadUpChecker) {

			getDrawList() ->AddLine(HeadPosFixed,NeckPosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(NeckPosFixed, HipPosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(NeckPosFixed, LeftUpperPosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(LeftUpperPosFixed, LeftForePosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(LeftForePosFixed, LeftHandPosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(NeckPosFixed, RightUpperPosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(RightUpperPosFixed, RightForePosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(RightForePosFixed, RightHandPosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(HipPosFixed, LeftCalfPosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(LeftCalfPosFixed, LeftFootPosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(HipPosFixed, RightCalfPosFixed,
																			ImColor(color), 1);
									getDrawList() ->AddLine(RightCalfPosFixed, RightFootPosFixed,
																			ImColor(color), 1);
																			
									getDrawList()->AddCircle(ImVec2(HeadPosFixed.x, HeadPosFixed.y - ((HeadPosFixed.y - HeadUpPosFixed.y) * 0.8) / 2), ((HeadPosFixed.y - HeadUpPosFixed.y) * 0.8) / 2,
																			ImColor(color), 30, 1);
		}
	}
}


void DrawEsp() {
		if (espen) {
				clearPlayers();
				for (int i = 0; i < players.size(); i++) {
						if (players[i]) {
								void *player = players[i];

								auto health = GetPlayerHealth(get_photon(player));

								auto pname = GetNickName(get_photon(player));
								std::string names = "null";
								if (pname) names = pname->toCPPString();
								std::transform(names.begin(), names.end(), names.begin(), ::tolower);
								auto playername = names;
								std::string name = names;

								auto weap = GetPlayerWeapon(player);
								std::string weaps = "null";
								if (weap) weaps = weap->toCPPString();
								std::transform(weaps.begin(), weaps.end(), weaps.begin(), ::tolower);
								std::string wpn = weaps;

								bool ray = IsPlayerVisible(player);

								auto pos = get_position(get_transform(player));

								Vector3 viewpos = get_position(get_transform(get_camera()));

								auto checker = false;

								auto w2sC = world2screen_c(pos + Vector3(0, 1, 0), checker);

								auto w2sTop = world2screen_i(pos + Vector3(0, 2, 0));
								auto w2sBottom = world2screen_i(pos + Vector3(0, 0, 0));

								auto pmtXtop = w2sTop.x;
								auto pmtXbottom = w2sBottom.x;

								if (w2sTop.x > w2sBottom.x) {
										pmtXtop = w2sBottom.x;
										pmtXbottom = w2sTop.x;
								}

								auto color = ray ? visibleCol : invisibleCol;

								auto armor = GetPlayerArmor(get_photon(player));

								auto armorL = (float) armor;

								auto healthL = (float) health;
								const auto hayasaka =
												(clamp<float>(healthL, 25, 75) - 25.f) / 50.f;
								auto hpcolor = ImColor(int(120 + 135 * (1 - hayasaka)),
																			 int(50.f + 175.f * hayasaka), int(80));

								auto minhpcolor = ImColor(int(120 + 135 * (1 - 0)),
																					int(50.f + 175.f * 0), int(80));

								NSString *healthString = [NSString stringWithFormat:@"%d", health];
								const char *healthCString = [healthString UTF8String];


								if (healthL > 100) {
										hpcolor = ImColor(100, 150, 255);
										minhpcolor = ImColor(100, 150, 255);
								}
								healthL = clamp<float>(healthL, 0, 100);

                         armorL = clamp<float>(armorL, 0, 100);
                auto armorcolor = ImColor(100, 150, 255);
                NSString *armorString = [NSString stringWithFormat:@"%d", armor];
                const char *armorCString = [armorString UTF8String];

								if (checker && (ray || !visible)) {

										if (espskeleton) {
											DrawSkeleton(player, color);
										}
									
										if (espbox) {
											if (espfill) {
												getDrawList() ->AddRectFilled(
																ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4), ImGui::GetIO().DisplaySize.y - w2sTop.y / 2), 
																ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4), ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 + espround),
																ImColor((int) (color.x * 255),
																				(int) (color.y * 255),
																				(int) (color.z * 255),
																				(int) ((float) (espgradient ? 10 : 80) * (float) espfillp / 100.0f)),
																espround, ImDrawFlags_RoundCornersTop);

												getDrawList() ->AddRectFilledMultiColor(
																ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4), ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 + espround),
																ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4), ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 - espround),
																ImColor((int) (color.x * 255),
																				(int) (color.y * 255),
																				(int) (color.z * 255),
																				(int) ((float) (espgradient ? 10 : 80) * (float) espfillp / 100.0f)),
																ImColor((int) (color.x * 255),
																				(int) (color.y * 255),
																				(int) (color.z * 255),
																				(int) ((float) (espgradient ? 10 : 80) * (float) espfillp / 100.0f)),
																ImColor((int) (color.x * 255),
																				(int) (color.y * 255),
																				(int) (color.z * 255),
																				(int) (80.0f * (float) espfillp / 100.0f)),
																ImColor((int) (color.x * 255),
																				(int) (color.y * 255),
																				(int) (color.z * 255),
																				(int) (80.0f * (float) espfillp / 100.0f)));
												getDrawList() ->AddRectFilled(
																ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4), ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 - espround),
																ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4), ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2),
																ImColor((int) (color.x * 255),
																				(int) (color.y * 255),
																				(int) (color.z * 255),
																				(int) (80.0f * (float) espfillp / 100.0f)),
																espround, ImDrawFlags_RoundCornersBottom);
											}

											if (esphpoutline) {

					                          getDrawList() ->AddRect(
					                                  ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - 1 - espstroke / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 - 1 - espstroke / 2),
					                                  ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + 1 + espstroke / 2, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 + 1 + espstroke / 2),
					                                  ImColor(0, 0, 0, 200), espround, 0, 1);
					                          getDrawList() ->AddRect(
					                                  ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + 1 + espstroke / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 + 1 + espstroke / 2),
					                                  ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - 1 - espstroke / 2, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 - 1 - espstroke / 2),
					                                  ImColor(0, 0, 0, 200), espround, 0, 1);
                      						}

											getDrawList() ->AddRect(
 												ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4), ImGui::GetIO().DisplaySize.y - w2sTop.y / 2), 
                                				ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4), ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2), 
												ImColor(color.x, color.y,color.z, 0.8f), espround, 0, espstroke);
										}

										if (esparm) {
                      

                      getDrawList()->AddLine(
                          ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + (esphpsize / 2) + 6 - 1, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2),
                          ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + (esphpsize / 2) + 6 - 1, lerp(ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, armorL / 100.0f)),
                          armorcolor, esphpsize);

                      if (esphpoutline) {
                        getDrawList() ->AddRect(
                                ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + esphpsize + 6, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 - 1),
                                ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + 6 - 1, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 + 2),
                                ImColor(0, 0, 0, 200), 0, 0, 1);
                      }

                      if (armor < 100 || armor > 100) {
                          if (esphpoutline) {
                            getDrawList() ->AddText(
                                    ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + esphpsize / 2 + ImGui::CalcTextSize(armorCString).x /2 - 1,
                                    lerp(ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, armorL / 100.0f) - ImGui::CalcTextSize(armorCString).y / 2 - 1),
                                    ImColor(0, 0, 0, 100), armorCString);
                            getDrawList() ->AddText(
                                    ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + esphpsize / 2 + ImGui::CalcTextSize(armorCString).x / 2 + 1,
                                    lerp(ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, armorL / 100.0f) - ImGui::CalcTextSize(armorCString).y / 2 - 1),
                                    ImColor(0, 0, 0, 100), armorCString);
                            getDrawList() ->AddText(
                                    ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + esphpsize / 2 + ImGui::CalcTextSize(armorCString).x / 2 - 1,
                                    lerp(ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, armorL / 100.0f) - ImGui::CalcTextSize(armorCString).y / 2 + 1),
                                    ImColor(0, 0, 0, 100), armorCString);
                            getDrawList() ->AddText(
                                    ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + esphpsize / 2 + ImGui::CalcTextSize(armorCString).x / 2 + 1,
                                    lerp(ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, armorL / 100.0f) - ImGui::CalcTextSize(armorCString).y / 2 + 1),
                                    ImColor(0, 0, 0, 100), armorCString);
                          }
                          getDrawList() ->AddText(
                                  ImVec2(pmtXbottom / 2 + fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) + esphpsize / 2 + ImGui::CalcTextSize(armorCString).x / 2,
                                  lerp(ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, armorL / 100.0f) - ImGui::CalcTextSize(armorCString).y / 2),
                                  ImColor(255, 255, 255), armorCString);
                      }

                    }

										if (esphealth) {
											getDrawList() ->AddLine(
															ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - (esphpsize / 2) - 6, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 ),
															ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - (esphpsize / 2) - 6, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2),
															ImColor(0, 0, 0, 120), esphpsize);

											if (esphpoutline) {
												getDrawList() ->AddRect(
																ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - esphpsize - 6 - 1, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 - 1),
																ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - 6 + 2, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 + 2),
																ImColor(0, 0, 0, 200), 0, 0, 1);
											}

											if (!esphpgradient) {
												getDrawList() ->AddLine(
																ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - (esphpsize / 2) - 6, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2),
																ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - (esphpsize / 2) - 6, 
																lerp( ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, healthL / 100.0f)),hpcolor, esphpsize);
											} else {
												getDrawList() ->AddRectFilledMultiColor(
																ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - (esphpsize / 2) - 6 - esphpsize / 2, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2),
																ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - (esphpsize / 2) - 6 + esphpsize / 2,
																lerp( ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, healthL / 100.0f)), minhpcolor, minhpcolor, hpcolor, hpcolor);
											}

											if (health < 100 || health > 100) {
													if (esphpoutline) {
														getDrawList() ->AddText(
																		ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - esphpsize / 2 - 6 - 2 - ImGui::CalcTextSize(healthCString).x /2 - 1,
																		lerp( ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, healthL / 100.0f) - ImGui::CalcTextSize(healthCString).y / 2 - 1),
																		ImColor(0, 0, 0, 100), healthCString);
														getDrawList() ->AddText(
																		ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - esphpsize / 2 - 6 - 2 - ImGui::CalcTextSize( healthCString).x / 2 + 1,
																		lerp( ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, healthL / 100.0f) - ImGui::CalcTextSize(healthCString).y / 2 - 1),
																		ImColor(0, 0, 0, 100), healthCString);
														getDrawList() ->AddText(
																		ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - esphpsize / 2 - 6 - 2 - ImGui::CalcTextSize( healthCString).x / 2 - 1,
																		lerp( ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, healthL / 100.0f) - ImGui::CalcTextSize(healthCString).y / 2 + 1),
																		ImColor(0, 0, 0, 100), healthCString);
														getDrawList() ->AddText(
																		ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - esphpsize / 2 - 6 - 2 - ImGui::CalcTextSize( healthCString).x / 2 + 1,
																		lerp( ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, healthL / 100.0f) - ImGui::CalcTextSize(healthCString).y / 2 + 1),
																		ImColor(0, 0, 0, 100), healthCString);
													}
													getDrawList() ->AddText(
																	ImVec2(pmtXtop / 2 - fabs((w2sTop.y - w2sBottom.y) * (0.0092f / 0.019f) / 4) - esphpsize / 2 - 6 - 2 - ImGui::CalcTextSize(healthCString).x / 2,
																	lerp( ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2, healthL / 100.0f) - ImGui::CalcTextSize(healthCString).y / 2),
																	ImColor(255, 255, 255), healthCString);
											}
										}
										if (espname) {
											if (esphpoutline) {
												getDrawList() ->AddText(
																ImGui::GetFont(),
																ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom / 2 - pmtXtop / 2) / 2) - 
																((ImGui::CalcTextSize(name.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2 - 1, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 -
																((ImGui::CalcTextSize(name.c_str()).y / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) - 1 - 3),
																ImColor(0, 0, 0, 100), name.c_str());
												getDrawList() ->AddText(
																ImGui::GetFont(),
																ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom / 2 - pmtXtop / 2) / 2) -
																((ImGui::CalcTextSize(name.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2 + 1, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 - 
																((ImGui::CalcTextSize(name.c_str()).y / ImGui::GetFontSize()) * 
																(ImGui::GetFontSize() + esphptextsize)) - 1 - 3),
																ImColor(0, 0, 0, 100), name.c_str());
												getDrawList() ->AddText(
																ImGui::GetFont(),
																ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom / 2 - pmtXtop / 2) / 2) - 
																((ImGui::CalcTextSize(name.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2 - 1, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 -
																((ImGui::CalcTextSize(name.c_str()).y / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) + 1 - 3),
																ImColor(0, 0, 0, 100), name.c_str());
												getDrawList() ->AddText(
																ImGui::GetFont(), ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom / 2 - pmtXtop / 2) / 2) -
																((ImGui::CalcTextSize(name.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2 + 1, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 -
																((ImGui::CalcTextSize(name.c_str()).y / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) + 1 - 3),
																ImColor(0, 0, 0, 100), name.c_str());
											}

												getDrawList() ->AddText(
																ImGui::GetFont(), 
																ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom / 2 - pmtXtop / 2) / 2) -
																((ImGui::CalcTextSize(name.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2, ImGui::GetIO().DisplaySize.y - w2sTop.y / 2 -
																((ImGui::CalcTextSize(name.c_str()).y / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) - 3),
																ImColor(255, 255, 255), name.c_str());
										}
										if (espweapon) {
											if (esphpoutline) {
												getDrawList() ->AddText(
																ImGui::GetFont(),
																ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom - pmtXtop) * (0.0092f / 0.019f) / 2) -
																((ImGui::CalcTextSize(wpn.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2 - 1, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 + 2 - 1),
																ImColor(0, 0, 0, 100), wpn.c_str());
												getDrawList() ->AddText(
																ImGui::GetFont(),
																ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom - pmtXtop) * (0.0092f / 0.019f) / 2) -
																((ImGui::CalcTextSize(wpn.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2 + 1, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 + 2 - 1),
																ImColor(0, 0, 0, 100), wpn.c_str());
												getDrawList() ->AddText(
																ImGui::GetFont(),
																ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom - pmtXtop) * (0.0092f / 0.019f) / 2) -
																((ImGui::CalcTextSize(wpn.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2 - 1, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 + 2 + 1),
																ImColor(0, 0, 0, 100), wpn.c_str());
												getDrawList() ->AddText(
																ImGui::GetFont(),
																ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom - pmtXtop) * (0.0092f / 0.019f) / 2) -
																((ImGui::CalcTextSize(wpn.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2 + 1, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 + 2 + 1),
																ImColor(0, 0, 0, 100), wpn.c_str());
												}

												getDrawList() ->AddText(
																ImGui::GetFont(),
																ImGui::GetFontSize() + esphptextsize,
																ImVec2((pmtXtop / 2 + (pmtXbottom - pmtXtop) * (0.0092f / 0.019f) / 2) -
																((ImGui::CalcTextSize(wpn.c_str()).x / ImGui::GetFontSize()) *
																(ImGui::GetFontSize() + esphptextsize)) / 2, ImGui::GetIO().DisplaySize.y - w2sBottom.y / 2 + 2),
																ImColor(255, 255, 255), wpn.c_str());
										}

								}
						}		
				}
		}
}
