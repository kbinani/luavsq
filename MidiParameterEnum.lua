--[[
  MidiParameterEnum.lua
  Copyright © 2011 kbinani

  This file is part of luavsq.

  luavsq is free software; you can redistribute it and/or
  modify it under the terms of the BSD License.

  luavsq is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]

if( nil == luavsq )then
    luavsq = {};
end

if( nil == luavsq.MidiParameterEnum )then

    luavsq.MidiParameterEnum = {};
    ---
    -- (0x5000) Version number(MSB) &amp;, Device number(LSB)
    luavsq.MidiParameterEnum.CVM_NM_VERSION_AND_DEVICE = 0x5000;
    ---
    -- (0x5001) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CVM_NM_DELAY = 0x5001;
    ---
    -- (0x5002) Note number(MSB)
    luavsq.MidiParameterEnum.CVM_NM_NOTE_NUMBER = 0x5002;
    ---
    -- (0x5003) Velocity(MSB)
    luavsq.MidiParameterEnum.CVM_NM_VELOCITY = 0x5003;
    ---
    -- (0x5004) Note Duration in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CVM_NM_NOTE_DURATION = 0x5004;
    ---
    -- (0x5005) Note Location(MSB)
    luavsq.MidiParameterEnum.CVM_NM_NOTE_LOCATION = 0x5005;
    ---
    -- (0x5006) Attack Type(MSB, LSB)
    luavsq.MidiParameterEnum.CVM_NM_ATTACK_TYPE = 0x5006;
    ---
    -- (0x5007) Attack Duration in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CVM_NM_ATTACK_DURATION = 0x5007;
    ---
    -- (0x5008) Attack Depth(MSB)
    luavsq.MidiParameterEnum.CVM_NM_ATTACK_DEPTH = 0x5008;
    ---
    -- (0x500c) Index of Vibrato DB(MSB: ID_H00, LSB:ID_L00)
    luavsq.MidiParameterEnum.CVM_NM_INDEX_OF_VIBRATO_DB = 0x500c;
    ---
    -- (0x500d) Vibrato configuration(MSB: Index of Vibrato Type, LSB: Duration &amp;, Configuration parameter of vibrato)
    luavsq.MidiParameterEnum.CVM_NM_VIBRATO_CONFIG = 0x500d;
    ---
    -- (0x500e) Vibrato Delay(MSB)
    luavsq.MidiParameterEnum.CVM_NM_VIBRATO_DELAY = 0x500e;
    ---
    -- (0x5011) Unknonw(MSB), only used in VOCALOID1
    luavsq.MidiParameterEnum.CVM_NM_UNKNOWN1 = 0x5011;
    ---
    -- (0x5012) Number of phonetic symbols in bytes(MSB)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL_BYTES = 0x5012;
    ---
    -- (0x5013) Phonetic symbol 1(MSB:Phonetic symbol 1, LSB: Consonant adjustment 1)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL1 = 0x5013;
    ---
    -- (0x5014) Phonetic symbol 2(MSB:Phonetic symbol 2, LSB: Consonant adjustment 2)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL2 = 0x5014;
    ---
    -- (0x5015) Phonetic symbol 3(MSB:Phonetic symbol 3, LSB: Consonant adjustment 3)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL3 = 0x5015;
    ---
    -- (0x5016) Phonetic symbol 4(MSB:Phonetic symbol 4, LSB: Consonant adjustment 4)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL4 = 0x5016;
    ---
    -- (0x5017) Phonetic symbol 5(MSB:Phonetic symbol 5, LSB: Consonant adjustment 5)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL5 = 0x5017;
    ---
    -- (0x5018) Phonetic symbol 6(MSB:Phonetic symbol 6, LSB: Consonant adjustment 6)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL6 = 0x5018;
    ---
    -- (0x5019) Phonetic symbol 7(MSB:Phonetic symbol 7, LSB: Consonant adjustment 7)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL7 = 0x5019;
    ---
    -- (0x501a) Phonetic symbol 8(MSB:Phonetic symbol 8, LSB: Consonant adjustment 8)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL8 = 0x501a;
    ---
    -- (0x501b) Phonetic symbol 9(MSB:Phonetic symbol 9, LSB: Consonant adjustment 9)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL9 = 0x501b;
    ---
    -- (0x501c) Phonetic symbol 10(MSB:Phonetic symbol 10, LSB: Consonant adjustment 10)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL10 = 0x501c;
    ---
    -- (0x501d) Phonetic symbol 11(MSB:Phonetic symbol 11, LSB: Consonant adjustment 11)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL11 = 0x501d;
    ---
    -- (0x501e) Phonetic symbol 12(MSB:Phonetic symbol 12, LSB: Consonant adjustment 12)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL12 = 0x501e;
    ---
    -- (0x501f) Phonetic symbol 13(MSB:Phonetic symbol 13, LSB: Consonant adjustment 13)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL13 = 0x501f;
    ---
    -- (0x5020) Phonetic symbol 14(MSB:Phonetic symbol 14, LSB: Consonant adjustment 14)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL14 = 0x5020;
    ---
    -- (0x5021) Phonetic symbol 15(MSB:Phonetic symbol 15, LSB: Consonant adjustment 15)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL15 = 0x5021;
    ---
    -- (0x5022) Phonetic symbol 16(MSB:Phonetic symbol 16, LSB: Consonant adjustment 16)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL16 = 0x5022;
    ---
    -- (0x5023) Phonetic symbol 17(MSB:Phonetic symbol 17, LSB: Consonant adjustment 17)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL17 = 0x5023;
    ---
    -- (0x5024) Phonetic symbol 18(MSB:Phonetic symbol 18, LSB: Consonant adjustment 18)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL18 = 0x5024;
    ---
    -- (0x5025) Phonetic symbol 19(MSB:Phonetic symbol 19, LSB: Consonant adjustment 19)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL19 = 0x5025;
    ---
    -- (0x5026) Phonetic symbol 20(MSB:Phonetic symbol 20, LSB: Consonant adjustment 20)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL20 = 0x5026;
    ---
    -- (0x5027) Phonetic symbol 21(MSB:Phonetic symbol 21, LSB: Consonant adjustment 21)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL21 = 0x5027;
    ---
    -- (0x5028) Phonetic symbol 22(MSB:Phonetic symbol 22, LSB: Consonant adjustment 22)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL22 = 0x5028;
    ---
    -- (0x5029) Phonetic symbol 23(MSB:Phonetic symbol 23, LSB: Consonant adjustment 23)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL23 = 0x5029;
    ---
    -- (0x502a) Phonetic symbol 24(MSB:Phonetic symbol 24, LSB: Consonant adjustment 24)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL24 = 0x502a;
    ---
    -- (0x502b) Phonetic symbol 25(MSB:Phonetic symbol 25, LSB: Consonant adjustment 25)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL25 = 0x502b;
    ---
    -- (0x502c) Phonetic symbol 26(MSB:Phonetic symbol 26, LSB: Consonant adjustment 26)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL26 = 0x502c;
    ---
    -- (0x502d) Phonetic symbol 27(MSB:Phonetic symbol 27, LSB: Consonant adjustment 27)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL27 = 0x502d;
    ---
    -- (0x502e) Phonetic symbol 28(MSB:Phonetic symbol 28, LSB: Consonant adjustment 28)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL28 = 0x502e;
    ---
    -- (0x502f) Phonetic symbol 29(MSB:Phonetic symbol 29, LSB: Consonant adjustment 29)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL29 = 0x502f;
    ---
    -- (0x5030) Phonetic symbol 30(MSB:Phonetic symbol 30, LSB: Consonant adjustment 30)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL30 = 0x5030;
    ---
    -- (0x5031) Phonetic symbol 31(MSB:Phonetic symbol 31, LSB: Consonant adjustment 31)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL31 = 0x5031;
    ---
    -- (0x5032) Phonetic symbol 32(MSB:Phonetic symbol 32, LSB: Consonant adjustment 32)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL32 = 0x5032;
    ---
    -- (0x5033) Phonetic symbol 33(MSB:Phonetic symbol 33, LSB: Consonant adjustment 33)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL33 = 0x5033;
    ---
    -- (0x5034) Phonetic symbol 34(MSB:Phonetic symbol 34, LSB: Consonant adjustment 34)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL34 = 0x5034;
    ---
    -- (0x5035) Phonetic symbol 35(MSB:Phonetic symbol 35, LSB: Consonant adjustment 35)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL35 = 0x5035;
    ---
    -- (0x5036) Phonetic symbol 36(MSB:Phonetic symbol 36, LSB: Consonant adjustment 36)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL36 = 0x5036;
    ---
    -- (0x5037) Phonetic symbol 37(MSB:Phonetic symbol 37, LSB: Consonant adjustment 37)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL37 = 0x5037;
    ---
    -- (0x5038) Phonetic symbol 38(MSB:Phonetic symbol 38, LSB: Consonant adjustment 38)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL38 = 0x5038;
    ---
    -- (0x5039) Phonetic symbol 39(MSB:Phonetic symbol 39, LSB: Consonant adjustment 39)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL39 = 0x5039;
    ---
    -- (0x503a) Phonetic symbol 40(MSB:Phonetic symbol 40, LSB: Consonant adjustment 40)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL40 = 0x503a;
    ---
    -- (0x503b) Phonetic symbol 41(MSB:Phonetic symbol 41, LSB: Consonant adjustment 41)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL41 = 0x503b;
    ---
    -- (0x503c) Phonetic symbol 42(MSB:Phonetic symbol 42, LSB: Consonant adjustment 42)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL42 = 0x503c;
    ---
    -- (0x503d) Phonetic symbol 43(MSB:Phonetic symbol 43, LSB: Consonant adjustment 43)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL43 = 0x503d;
    ---
    -- (0x503e) Phonetic symbol 44(MSB:Phonetic symbol 44, LSB: Consonant adjustment 44)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL44 = 0x503e;
    ---
    -- (0x503f) Phonetic symbol 45(MSB:Phonetic symbol 45, LSB: Consonant adjustment 45)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL45 = 0x503f;
    ---
    -- (0x5040) Phonetic symbol 46(MSB:Phonetic symbol 46, LSB: Consonant adjustment 46)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL46 = 0x5040;
    ---
    -- (0x5041) Phonetic symbol 47(MSB:Phonetic symbol 47, LSB: Consonant adjustment 47)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL47 = 0x5041;
    ---
    -- (0x5042) Phonetic symbol 48(MSB:Phonetic symbol 48, LSB: Consonant adjustment 48)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL48 = 0x5042;
    ---
    -- (0x5043) Phonetic symbol 49(MSB:Phonetic symbol 49, LSB: Consonant adjustment 49)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL49 = 0x5043;
    ---
    -- (0x5044) Phonetic symbol 50(MSB:Phonetic symbol 50, LSB: Consonant adjustment 50)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL50 = 0x5044;
    ---
    -- (0x5045) Phonetic symbol 51(MSB:Phonetic symbol 51, LSB: Consonant adjustment 51)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL51 = 0x5045;
    ---
    -- (0x5046) Phonetic symbol 52(MSB:Phonetic symbol 52, LSB: Consonant adjustment 52)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL52 = 0x5046;
    ---
    -- (0x5047) Phonetic symbol 53(MSB:Phonetic symbol 53, LSB: Consonant adjustment 53)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL53 = 0x5047;
    ---
    -- (0x5048) Phonetic symbol 54(MSB:Phonetic symbol 54, LSB: Consonant adjustment 54)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL54 = 0x5048;
    ---
    -- (0x5049) Phonetic symbol 55(MSB:Phonetic symbol 55, LSB: Consonant adjustment 55)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL55 = 0x5049;
    ---
    -- (0x504a) Phonetic symbol 56(MSB:Phonetic symbol 56, LSB: Consonant adjustment 56)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL56 = 0x504a;
    ---
    -- (0x504b) Phonetic symbol 57(MSB:Phonetic symbol 57, LSB: Consonant adjustment 57)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL57 = 0x504b;
    ---
    -- (0x504c) Phonetic symbol 58(MSB:Phonetic symbol 58, LSB: Consonant adjustment 58)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL58 = 0x504c;
    ---
    -- (0x504d) Phonetic symbol 59(MSB:Phonetic symbol 59, LSB: Consonant adjustment 59)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL59 = 0x504d;
    ---
    -- (0x504e) Phonetic symbol 60(MSB:Phonetic symbol 60, LSB: Consonant adjustment 60)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL60 = 0x504e;
    ---
    -- (0x504f) Phonetic symbol continuation(MSB, 0x7f=end, 0x00=continue)
    luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL_CONTINUATION = 0x504f;
    ---
    -- (0x5050) v1mean in Cent/5(MSB)
    luavsq.MidiParameterEnum.CVM_NM_V1MEAN = 0x5050;
    ---
    -- (0x5051) d1mean in millisec/5(MSB)
    luavsq.MidiParameterEnum.CVM_NM_D1MEAN = 0x5051;
    ---
    -- (0x5052) d1meanFirstNote in millisec/5(MSB)
    luavsq.MidiParameterEnum.CVM_NM_D1MEAN_FIRST_NOTE = 0x5052;
    ---
    -- (0x5053) d2mean in millisec/5(MSB)
    luavsq.MidiParameterEnum.CVM_NM_D2MEAN = 0x5053;
    ---
    -- (0x5054) d4mean in millisec/5(MSB)
    luavsq.MidiParameterEnum.CVM_NM_D4MEAN = 0x5054;
    ---
    -- (0x5055) pMeanOnsetFirstNote in Cent/5(MSB)
    luavsq.MidiParameterEnum.CVM_NM_PMEAN_ONSET_FIRST_NOTE = 0x5055;
    ---
    -- (0x5056) vMeanNoteTransition in Cent/5(MSB)
    luavsq.MidiParameterEnum.CVM_NM_VMEAN_NOTE_TRNSITION = 0x5056;
    ---
    -- (0x5057) pMeanEndingNote in Cent/5(MSB)
    luavsq.MidiParameterEnum.CVM_NM_PMEAN_ENDING_NOTE = 0x5057;
    ---
    -- (0x5058) AddScooptoUpIntervals &amp;, AddPortamentoToDownIntervals(MSB)
    luavsq.MidiParameterEnum.CVM_NM_ADD_PORTAMENTO = 0x5058;
    ---
    -- (0x5059) changAfterPeak(MSB)
    luavsq.MidiParameterEnum.CVM_NM_CHANGE_AFTER_PEAK = 0x5059;
    ---
    -- (0x505a) Accent(MSB)
    luavsq.MidiParameterEnum.CVM_NM_ACCENT = 0x505a;
    ---
    -- (0x507f) Note message continuation(MSB)
    luavsq.MidiParameterEnum.CVM_NM_NOTE_MESSAGE_CONTINUATION = 0x507f;

    ---
    -- (0x5075) Extended Note message; Voice Overlap(MSB, LSB)(VoiceOverlap = ((MSB &amp; 0x7f) &lt;&lt; 7) | (LSB &amp; 0x7f) - 8192)
    luavsq.MidiParameterEnum.CVM_EXNM_VOICE_OVERLAP = 0x5075;
    ---
    -- (0x5076) Extended Note message; Flags length in bytes(MSB, LSB)
    luavsq.MidiParameterEnum.CVM_EXNM_FLAGS_BYTES = 0x5076;
    ---
    -- (0x5077) Extended Note message; Flag(MSB)
    luavsq.MidiParameterEnum.CVM_EXNM_FLAGS = 0x5077;
    ---
    -- (0x5078) Extended Note message; Flag continuation(MSB)(MSB, 0x7f=end, 0x00=continue)
    luavsq.MidiParameterEnum.CVM_EXNM_FLAGS_CONINUATION = 0x5078;
    ---
    -- (0x5079) Extended Note message; Moduration(MSB, LSB)(Moduration = ((MSB &amp; 0x7f) &lt;&lt; 7) | (LSB &amp; 0x7f) - 100)
    luavsq.MidiParameterEnum.CVM_EXNM_MODURATION = 0x5079;
    ---
    -- (0x507a) Extended Note message; PreUtterance(MSB, LSB)(PreUtterance = ((MSB &amp; 0x7f) &lt;&lt; 7) | (LSB &amp; 0x7f) - 8192)
    luavsq.MidiParameterEnum.CVM_EXNM_PRE_UTTERANCE = 0x507a;
    ---
    -- (0x507e) Extended Note message; Envelope: value1(MSB, LSB) actual value = (value3.msb &amp; 0xf) &lt;&lt; 28 | (value2.msb &amp; 0x7f) &lt;&lt; 21 | (value2.lsb &amp; 0x7f) &lt;&lt; 14 | (value1.msb &amp; 0x7f) &lt;&lt; 7 | (value1.lsb &amp; 0x7f)
    luavsq.MidiParameterEnum.CVM_EXNM_ENV_DATA1 = 0x507e;
    ---
    -- (0x507d) Extended Note message; Envelope: value2(MSB, LSB)
    luavsq.MidiParameterEnum.CVM_EXNM_ENV_DATA2 = 0x507d;
    ---
    -- (0x507c) Extended Note message; Envelope: value3(MSB)
    luavsq.MidiParameterEnum.CVM_EXNM_ENV_DATA3 = 0x507c;
    ---
    -- (0x507b) Extended Note message; Envelope: data point continuation(MSB)(MSB, 0x7f=end, 0x00=continue)
    luavsq.MidiParameterEnum.CVM_EXNM_ENV_DATA_CONTINUATION = 0x507b;

    ---
    -- (0x6000) Version number &amp;, Device number(MSB, LSB)
    luavsq.MidiParameterEnum.CC_BS_VERSION_AND_DEVICE = 0x6000;
    ---
    -- (0x6001) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CC_BS_DELAY = 0x6001;
    ---
    -- (0x6002) Laugnage type(MSB, optional LSB)
    luavsq.MidiParameterEnum.CC_BS_LANGUAGE_TYPE = 0x6002;

    ---
    -- (0x6100) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.CC_CV_VERSION_AND_DEVICE = 0x6100;
    ---
    -- (0x6101) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CC_CV_DELAY = 0x6101;
    ---
    -- (0x6102) Volume value(MSB)
    luavsq.MidiParameterEnum.CC_CV_VOLUME = 0x6102;

    ---
    -- (0x6200) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.CC_P_VERSION_AND_DEVICE = 0x6200;
    ---
    -- (0x6201) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CC_P_DELAY = 0x6201;
    ---
    -- (0x6202) Pan value(MSB)
    luavsq.MidiParameterEnum.CC_PAN = 0x6202;

    ---
    -- (0x6300) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.CC_E_VESION_AND_DEVICE = 0x6300;
    ---
    -- (0x6301) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CC_E_DELAY = 0x6301;
    ---
    -- (0x6302) Expression vlaue(MSB)
    luavsq.MidiParameterEnum.CC_E_EXPRESSION = 0x6302;

    ---
    -- (0x6400) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.CC_VR_VERSION_AND_DEVICE = 0x6400;
    ---
    -- (0x6401) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CC_VR_DELAY = 0x6401;
    ---
    -- (0x6402) Vibrato Rate value(MSB)
    luavsq.MidiParameterEnum.CC_VR_VIBRATO_RATE = 0x6402;

    ---
    -- (0x6500) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.CC_VD_VERSION_AND_DEVICE = 0x6500;
    ---
    -- (0x6501) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CC_VD_DELAY = 0x6501;
    ---
    -- (0x6502) Vibrato Depth value(MSB)
    luavsq.MidiParameterEnum.CC_VD_VIBRATO_DEPTH = 0x6502;

    ---
    -- (0x6600) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.CC_FX2_VERSION_AND_DEVICE = 0x6600;
    ---
    -- (0x6601) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CC_FX2_DELAY = 0x6601;
    ---
    -- (0x6602) Effect2 Depth(MSB)
    luavsq.MidiParameterEnum.CC_FX2_EFFECT2_DEPTH = 0x6602;

    ---
    -- (0x6700) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.CC_PBS_VERSION_AND_DEVICE = 0x6700;
    ---
    -- (0x6701) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.CC_PBS_DELAY = 0x6701;
    ---
    -- (0x6702) Pitch Bend Sensitivity(MSB, LSB)
    luavsq.MidiParameterEnum.CC_PBS_PITCH_BEND_SENSITIVITY = 0x6702;

    ---
    -- (0x5300) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.PC_VERSION_AND_DEVICE = 0x5300;
    ---
    -- (0x5301) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.PC_DELAY = 0x5301;
    ---
    -- (0x5302) Voice Type(MSB)
    luavsq.MidiParameterEnum.PC_VOICE_TYPE = 0x5302;

    ---
    -- (0x5400) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.PB_VERSION_AND_DEVICE = 0x5400;
    ---
    -- (0x5401) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.PB_DELAY = 0x5401;
    ---
    -- (0x5402) Pitch Bend value(MSB, LSB)
    luavsq.MidiParameterEnum.PB_PITCH_BEND = 0x5402;

    ---
    -- (0x5500) Version number &amp;, device number(MSB, LSB)
    luavsq.MidiParameterEnum.VCP_VERSION_AND_DEVICE = 0x5500;
    ---
    -- (0x5501) Delay in millisec(MSB, LSB)
    luavsq.MidiParameterEnum.VCP_DELAY = 0x5501;
    ---
    -- (0x5502) Voice Change Parameter ID(MSB)
    luavsq.MidiParameterEnum.VCP_VOICE_CHANGE_PARAMETER_ID = 0x5502;
    ---
    -- (0x5503) Voice Change Parameter value(MSB)
    luavsq.MidiParameterEnum.VCP_VOICE_CHANGE_PARAMETER = 0x5503;

    --[[TODO:
    public static Iterator<ValuePair<String, Integer>> iterator() {
        return new NrpnIterator();
    }

    public static String getName( int nrpn ) {
        for ( Iterator<ValuePair<String, Integer>> itr = iterator(); itr.hasNext(); ) {
            ValuePair<String, Integer> v = itr.next();
            if ( v.getValue() == nrpn ) {
                return v.getKey();
            }
        }
        return "";
    }]]

    ---
    -- 指定したコントロールに対応するVoice Change Parameter IDの値を調べます
    -- @param curve_name [string]
    -- @return [byte]
    function luavsq.MidiParameterEnum.getVoiceChangeParameterId( curveName )
        local lsb = 0x31;
        if( nil == curveName )then
            return nil;
        end
        curveName = curveName:lower();
        if( curveName == "harmonics" )then
            lsb = 0x30;
        elseif( curveName == "bre" )then
            lsb = 0x31;
        elseif( curveName == "bri" )then
            lsb = 0x32;
        elseif( curveName == "cle" )then
            lsb = 0x33;
        elseif( curveName == "por" )then
            lsb = 0x34;
        elseif( curveName == "ope" )then
            lsb = 0x35;
        elseif( curveName == "reso1freq" )then
            lsb = 0x40;
        elseif( curveName == "reso2freq" )then
            lsb = 0x41;
        elseif( curveName == "reso3freq" )then
            lsb = 0x42;
        elseif( curveName == "reso4freq" )then
            lsb = 0x43;
        elseif( curveName == "reso1bw" )then
            lsb = 0x50;
        elseif( curveName == "reso2bw" )then
            lsb = 0x51;
        elseif( curveName == "reso3bw" )then
            lsb = 0x52;
        elseif( curveName == "reso4bw" )then
            lsb = 0x53;
        elseif( curveName == "reso1amp" )then
            lsb = 0x60;
        elseif( curveName == "reso2amp" )then
            lsb = 0x61;
        elseif( curveName == "reso3amp" )then
            lsb = 0x62;
        elseif( curveName == "reso4amp" )then
            lsb = 0x63;
        elseif( curveName == "gen" )then
            lsb = 0x70;
        end
        return lsb;
    end

    ---
    -- @param nrpn [int]
    -- @return [bool]
    function luavsq.MidiParameterEnum.isDataLsbRequire( nrpn )
        if( nrpn == luavsq.MidiParameterEnum.CVM_NM_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_DELAY or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_NOTE_DURATION or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_INDEX_OF_VIBRATO_DB or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_VIBRATO_CONFIG or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL1 or
            nrpn == luavsq.MidiParameterEnum.CC_BS_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.CC_BS_DELAY or
            nrpn == luavsq.MidiParameterEnum.CC_BS_LANGUAGE_TYPE or
            nrpn == luavsq.MidiParameterEnum.CC_CV_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.CC_CV_DELAY or
            nrpn == luavsq.MidiParameterEnum.CC_P_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.CC_P_DELAY or
            nrpn == luavsq.MidiParameterEnum.CC_E_VESION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.CC_E_DELAY or
            nrpn == luavsq.MidiParameterEnum.CC_VR_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.CC_VR_DELAY or
            nrpn == luavsq.MidiParameterEnum.CC_VD_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.CC_VD_DELAY or
            nrpn == luavsq.MidiParameterEnum.CC_FX2_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.CC_FX2_DELAY or
            nrpn == luavsq.MidiParameterEnum.CC_PBS_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.CC_PBS_DELAY or
            nrpn == luavsq.MidiParameterEnum.CC_PBS_PITCH_BEND_SENSITIVITY or
            nrpn == luavsq.MidiParameterEnum.PC_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.PC_DELAY or
            nrpn == luavsq.MidiParameterEnum.PB_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.PB_DELAY or
            nrpn == luavsq.MidiParameterEnum.PB_PITCH_BEND or
            nrpn == luavsq.MidiParameterEnum.VCP_VERSION_AND_DEVICE or
            nrpn == luavsq.MidiParameterEnum.VCP_DELAY or
            nrpn == luavsq.MidiParameterEnum.CVM_EXNM_ENV_DATA1 or
            nrpn == luavsq.MidiParameterEnum.CVM_EXNM_ENV_DATA2 )then
            return true;
        elseif( nrpn == luavsq.MidiParameterEnum.CVM_NM_NOTE_NUMBER or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_VELOCITY or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_NOTE_LOCATION or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_VIBRATO_DELAY or
        --case luavsq.MidiParameterEnum.CVM_NM_UNKNOWN1 or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL_BYTES or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_PHONETIC_SYMBOL_CONTINUATION or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_V1MEAN or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_D1MEAN or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_D1MEAN_FIRST_NOTE or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_D2MEAN or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_D4MEAN or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_PMEAN_ONSET_FIRST_NOTE or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_VMEAN_NOTE_TRNSITION or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_PMEAN_ENDING_NOTE or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_ADD_PORTAMENTO or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_CHANGE_AFTER_PEAK or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_ACCENT or
            nrpn == luavsq.MidiParameterEnum.CVM_NM_NOTE_MESSAGE_CONTINUATION or
            nrpn == luavsq.MidiParameterEnum.CC_CV_VOLUME or
            nrpn == luavsq.MidiParameterEnum.CC_PAN or
            nrpn == luavsq.MidiParameterEnum.CC_E_EXPRESSION or
            nrpn == luavsq.MidiParameterEnum.CC_VR_VIBRATO_RATE or
            nrpn == luavsq.MidiParameterEnum.CC_VD_VIBRATO_DEPTH or
            nrpn == luavsq.MidiParameterEnum.CC_FX2_EFFECT2_DEPTH or
            nrpn == luavsq.MidiParameterEnum.PC_VOICE_TYPE or
            nrpn == luavsq.MidiParameterEnum.VCP_VOICE_CHANGE_PARAMETER_ID or
            nrpn == luavsq.MidiParameterEnum.VCP_VOICE_CHANGE_PARAMETER or
            nrpn == luavsq.MidiParameterEnum.CVM_EXNM_ENV_DATA3 or
            nrpn == luavsq.MidiParameterEnum.CVM_EXNM_ENV_DATA_CONTINUATION )then
            return false;
        end
        return false;
    end

end
