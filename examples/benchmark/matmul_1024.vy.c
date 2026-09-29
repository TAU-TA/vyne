#include "C:\Users\Admin\Desktop\Tuncay\Coding projects\vyne/vyne/runtime/vyne_runtime.h"
#include "C:\Users\Admin\Desktop\Tuncay\Coding projects\vyne\vyne\runtime\modules\vmem.h"
#include "C:\Users\Admin\Desktop\Tuncay\Coding projects\vyne\vyne\runtime\modules\vmath.h"

// --- Globals ---
int64_t v_CONFIG = 0;
int64_t v_N = 0;
int64_t v_ITERS = 0;

int main(void) {
    VyneValue n_ret_0 = vmath_seed(vyne_int(42));
    v_CONFIG = 2;
    v_N = 1024;
    v_ITERS = 100;
    VyneValue str_1 = vyne_to_string(vyne_int(v_CONFIG));
    VyneValue bin_2 = vyne_binop(vyne_string_static("config="), str_1, 29);
    VyneValue bin_3 = vyne_binop(bin_2, vyne_string_static(" N="), 29);
    VyneValue str_4 = vyne_to_string(vyne_int(v_N));
    VyneValue bin_5 = vyne_binop(bin_3, str_4, 29);
    VyneValue bin_6 = vyne_binop(bin_5, vyne_string_static(" iters="), 29);
    VyneValue str_7 = vyne_to_string(vyne_int(v_ITERS));
    VyneValue bin_8 = vyne_binop(bin_6, str_7, 29);
    vyne_out(bin_8);
    // --- region: outer ---
    VyneValue vmem_cp_9 = vmem_runtime_checkpoint();
    {
        double v_A[1048576];
        double v_B[1048576];
        double v_B_T[1048576];
        int64_t bin_10 = v_N - 1;
        int64_t lo_i_11 = 0;
        int64_t hi_i_12 = bin_10;
        for (int64_t i_13 = lo_i_11; i_13 <= hi_i_12; ++i_13) {
            int64_t v_r = i_13;
            {
                int64_t bin_14 = v_N - 1;
                int64_t lo_i_15 = 0;
                int64_t hi_i_16 = bin_14;
                for (int64_t i_17 = lo_i_15; i_17 <= hi_i_16; ++i_17) {
                    int64_t v_c = i_17;
                    {
                        VyneValue un_19 = vyne_unary(vyne_float(1), 30);
                        VyneValue n_ret_18 = vmath_random_float(un_19, vyne_float(1));
                        v_A[(v_r) * 1024 + (v_c)] = ((n_ret_18).type == V_FLOAT64) ? (n_ret_18).as.f64 : (double)(n_ret_18).as.i64;
                        VyneValue un_21 = vyne_unary(vyne_float(1), 30);
                        VyneValue n_ret_20 = vmath_random_float(un_21, vyne_float(1));
                        v_B[(v_r) * 1024 + (v_c)] = ((n_ret_20).type == V_FLOAT64) ? (n_ret_20).as.f64 : (double)(n_ret_20).as.i64;
                    }
                }
            }
        }
        int64_t bin_22 = v_N - 1;
        int64_t lo_i_23 = 0;
        int64_t hi_i_24 = bin_22;
        for (int64_t i_25 = lo_i_23; i_25 <= hi_i_24; ++i_25) {
            int64_t v_r = i_25;
            {
                int64_t bin_26 = v_N - 1;
                int64_t lo_i_27 = 0;
                int64_t hi_i_28 = bin_26;
                for (int64_t i_29 = lo_i_27; i_29 <= hi_i_28; ++i_29) {
                    int64_t v_c = i_29;
                    {
                        double sid_30 = v_B[(v_r) * 1024 + (v_c)];
                        v_B_T[(v_c) * 1024 + (v_r)] = sid_30;
                    }
                }
            }
        }
        VyneValue bin_31 = vyne_bool(v_CONFIG == 0);
        if (vyne_is_truthy(bin_31)) {
            {
                int64_t lo_i_32 = 1;
                int64_t hi_i_33 = v_ITERS;
                for (int64_t i_34 = lo_i_32; i_34 <= hi_i_33; ++i_34) {
                    int64_t v_iter = i_34;
                    {
                        VyneArray_f64 v_C = vyne_array_f64_create(0);
                        int64_t bin_35 = v_N - 1;
                        int64_t lo_i_36 = 0;
                        int64_t hi_i_37 = bin_35;
                        for (int64_t i_38 = lo_i_36; i_38 <= hi_i_37; ++i_38) {
                            int64_t v_r = i_38;
                            {
                                int64_t bin_39 = v_N - 1;
                                int64_t lo_i_40 = 0;
                                int64_t hi_i_41 = bin_39;
                                for (int64_t i_42 = lo_i_40; i_42 <= hi_i_41; ++i_42) {
                                    int64_t v_c = i_42;
                                    {
                                        double v_acc0 = 0;
                                        double v_acc1 = 0;
                                        double v_acc2 = 0;
                                        double v_acc3 = 0;
                                        if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                        int64_t bin_43 = v_N / 4;
                                        int64_t bin_44 = bin_43 - 1;
                                        int64_t lo_i_45 = 0;
                                        int64_t hi_i_46 = bin_44;
                                        for (int64_t i_47 = lo_i_45; i_47 <= hi_i_46; ++i_47) {
                                            int64_t v_k4 = i_47;
                                            {
                                                int64_t bin_48 = v_k4 * 4;
                                                int64_t v_k0 = bin_48;
                                                int64_t bin_49 = v_k0 + 0;
                                                double sid_50 = v_A[(v_r) * 1024 + (bin_49)];
                                                int64_t bin_51 = v_k0 + 0;
                                                double sid_52 = v_B_T[(v_c) * 1024 + (bin_51)];
                                                double bin_53 = sid_50 * sid_52;
                                                double bin_54 = v_acc0 + bin_53;
                                                v_acc0 = bin_54;
                                                int64_t bin_55 = v_k0 + 1;
                                                double sid_56 = v_A[(v_r) * 1024 + (bin_55)];
                                                int64_t bin_57 = v_k0 + 1;
                                                double sid_58 = v_B_T[(v_c) * 1024 + (bin_57)];
                                                double bin_59 = sid_56 * sid_58;
                                                double bin_60 = v_acc1 + bin_59;
                                                v_acc1 = bin_60;
                                                int64_t bin_61 = v_k0 + 2;
                                                double sid_62 = v_A[(v_r) * 1024 + (bin_61)];
                                                int64_t bin_63 = v_k0 + 2;
                                                double sid_64 = v_B_T[(v_c) * 1024 + (bin_63)];
                                                double bin_65 = sid_62 * sid_64;
                                                double bin_66 = v_acc2 + bin_65;
                                                v_acc2 = bin_66;
                                                int64_t bin_67 = v_k0 + 3;
                                                double sid_68 = v_A[(v_r) * 1024 + (bin_67)];
                                                int64_t bin_69 = v_k0 + 3;
                                                double sid_70 = v_B_T[(v_c) * 1024 + (bin_69)];
                                                double bin_71 = sid_68 * sid_70;
                                                double bin_72 = v_acc3 + bin_71;
                                                v_acc3 = bin_72;
                                            }
                                        }
                                        double bin_73 = v_acc0 + v_acc1;
                                        double bin_74 = v_acc2 + v_acc3;
                                        double bin_75 = bin_73 + bin_74;
                                        vyne_array_f64_push(&v_C, bin_75);
                                    }
                                }
                            }
                        }
                        VyneValue bin_76 = vyne_bool(v_iter == v_ITERS);
                        if (vyne_is_truthy(bin_76)) {
                            {
                                double idx_78 = v_C.data[0];
                                VyneValue str_77 = vyne_to_string(vyne_float(idx_78));
                                VyneValue bin_79 = vyne_binop(vyne_string_static("checksum: "), str_77, 29);
                                vyne_out(bin_79);
                            }
                        }
                    }
                }
            }
        }
        VyneValue bin_80 = vyne_bool(v_CONFIG == 1);
        if (vyne_is_truthy(bin_80)) {
            {
                int64_t lo_i_81 = 1;
                int64_t hi_i_82 = v_ITERS;
                for (int64_t i_83 = lo_i_81; i_83 <= hi_i_82; ++i_83) {
                    int64_t v_iter = i_83;
                    {
                        // --- region: inner ---
                        VyneValue vmem_cp_84 = vmem_runtime_checkpoint();
                        {
                            VyneArray_f64 v_C = vyne_array_f64_create(0);
                            int64_t bin_85 = v_N - 1;
                            int64_t lo_i_86 = 0;
                            int64_t hi_i_87 = bin_85;
                            for (int64_t i_88 = lo_i_86; i_88 <= hi_i_87; ++i_88) {
                                int64_t v_r = i_88;
                                {
                                    int64_t bin_89 = v_N - 1;
                                    int64_t lo_i_90 = 0;
                                    int64_t hi_i_91 = bin_89;
                                    for (int64_t i_92 = lo_i_90; i_92 <= hi_i_91; ++i_92) {
                                        int64_t v_c = i_92;
                                        {
                                            double v_acc0 = 0;
                                            double v_acc1 = 0;
                                            double v_acc2 = 0;
                                            double v_acc3 = 0;
                                            if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                            int64_t bin_93 = v_N / 4;
                                            int64_t bin_94 = bin_93 - 1;
                                            int64_t lo_i_95 = 0;
                                            int64_t hi_i_96 = bin_94;
                                            for (int64_t i_97 = lo_i_95; i_97 <= hi_i_96; ++i_97) {
                                                int64_t v_k4 = i_97;
                                                {
                                                    int64_t bin_98 = v_k4 * 4;
                                                    int64_t v_k0 = bin_98;
                                                    int64_t bin_99 = v_k0 + 0;
                                                    double sid_100 = v_A[(v_r) * 1024 + (bin_99)];
                                                    int64_t bin_101 = v_k0 + 0;
                                                    double sid_102 = v_B_T[(v_c) * 1024 + (bin_101)];
                                                    double bin_103 = sid_100 * sid_102;
                                                    double bin_104 = v_acc0 + bin_103;
                                                    v_acc0 = bin_104;
                                                    int64_t bin_105 = v_k0 + 1;
                                                    double sid_106 = v_A[(v_r) * 1024 + (bin_105)];
                                                    int64_t bin_107 = v_k0 + 1;
                                                    double sid_108 = v_B_T[(v_c) * 1024 + (bin_107)];
                                                    double bin_109 = sid_106 * sid_108;
                                                    double bin_110 = v_acc1 + bin_109;
                                                    v_acc1 = bin_110;
                                                    int64_t bin_111 = v_k0 + 2;
                                                    double sid_112 = v_A[(v_r) * 1024 + (bin_111)];
                                                    int64_t bin_113 = v_k0 + 2;
                                                    double sid_114 = v_B_T[(v_c) * 1024 + (bin_113)];
                                                    double bin_115 = sid_112 * sid_114;
                                                    double bin_116 = v_acc2 + bin_115;
                                                    v_acc2 = bin_116;
                                                    int64_t bin_117 = v_k0 + 3;
                                                    double sid_118 = v_A[(v_r) * 1024 + (bin_117)];
                                                    int64_t bin_119 = v_k0 + 3;
                                                    double sid_120 = v_B_T[(v_c) * 1024 + (bin_119)];
                                                    double bin_121 = sid_118 * sid_120;
                                                    double bin_122 = v_acc3 + bin_121;
                                                    v_acc3 = bin_122;
                                                }
                                            }
                                            double bin_123 = v_acc0 + v_acc1;
                                            double bin_124 = v_acc2 + v_acc3;
                                            double bin_125 = bin_123 + bin_124;
                                            vyne_array_f64_push(&v_C, bin_125);
                                        }
                                    }
                                }
                            }
                            VyneValue bin_126 = vyne_bool(v_iter == v_ITERS);
                            if (vyne_is_truthy(bin_126)) {
                                {
                                    double idx_128 = v_C.data[0];
                                    VyneValue str_127 = vyne_to_string(vyne_float(idx_128));
                                    VyneValue bin_129 = vyne_binop(vyne_string_static("checksum: "), str_127, 29);
                                    vyne_out(bin_129);
                                }
                            }
                        }
                        vmem_runtime_rewind(vmem_cp_84);
                    }
                }
            }
        }
        VyneValue bin_130 = vyne_bool(v_CONFIG == 2);
        if (vyne_is_truthy(bin_130)) {
            {
                int64_t lo_i_131 = 1;
                int64_t hi_i_132 = v_ITERS;
                for (int64_t i_133 = lo_i_131; i_133 <= hi_i_132; ++i_133) {
                    int64_t v_iter = i_133;
                    {
                        // --- region: inner ---
                        VyneValue vmem_cp_134 = vmem_runtime_checkpoint();
                        {
                            double v_C[1048576];
                            int64_t bin_135 = v_N - 1;
                            int64_t lo_i_136 = 0;
                            int64_t hi_i_137 = bin_135;
                            for (int64_t i_138 = lo_i_136; i_138 <= hi_i_137; ++i_138) {
                                int64_t v_r = i_138;
                                {
                                    int64_t bin_139 = v_N - 1;
                                    int64_t lo_i_140 = 0;
                                    int64_t hi_i_141 = bin_139;
                                    for (int64_t i_142 = lo_i_140; i_142 <= hi_i_141; ++i_142) {
                                        int64_t v_c = i_142;
                                        {
                                            double v_acc0 = 0;
                                            double v_acc1 = 0;
                                            double v_acc2 = 0;
                                            double v_acc3 = 0;
                                            if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                            int64_t bin_143 = v_N / 4;
                                            int64_t bin_144 = bin_143 - 1;
                                            int64_t lo_i_145 = 0;
                                            int64_t hi_i_146 = bin_144;
                                            for (int64_t i_147 = lo_i_145; i_147 <= hi_i_146; ++i_147) {
                                                int64_t v_k4 = i_147;
                                                {
                                                    int64_t bin_148 = v_k4 * 4;
                                                    int64_t v_k0 = bin_148;
                                                    int64_t bin_149 = v_k0 + 0;
                                                    double sid_150 = v_A[(v_r) * 1024 + (bin_149)];
                                                    int64_t bin_151 = v_k0 + 0;
                                                    double sid_152 = v_B_T[(v_c) * 1024 + (bin_151)];
                                                    double bin_153 = sid_150 * sid_152;
                                                    double bin_154 = v_acc0 + bin_153;
                                                    v_acc0 = bin_154;
                                                    int64_t bin_155 = v_k0 + 1;
                                                    double sid_156 = v_A[(v_r) * 1024 + (bin_155)];
                                                    int64_t bin_157 = v_k0 + 1;
                                                    double sid_158 = v_B_T[(v_c) * 1024 + (bin_157)];
                                                    double bin_159 = sid_156 * sid_158;
                                                    double bin_160 = v_acc1 + bin_159;
                                                    v_acc1 = bin_160;
                                                    int64_t bin_161 = v_k0 + 2;
                                                    double sid_162 = v_A[(v_r) * 1024 + (bin_161)];
                                                    int64_t bin_163 = v_k0 + 2;
                                                    double sid_164 = v_B_T[(v_c) * 1024 + (bin_163)];
                                                    double bin_165 = sid_162 * sid_164;
                                                    double bin_166 = v_acc2 + bin_165;
                                                    v_acc2 = bin_166;
                                                    int64_t bin_167 = v_k0 + 3;
                                                    double sid_168 = v_A[(v_r) * 1024 + (bin_167)];
                                                    int64_t bin_169 = v_k0 + 3;
                                                    double sid_170 = v_B_T[(v_c) * 1024 + (bin_169)];
                                                    double bin_171 = sid_168 * sid_170;
                                                    double bin_172 = v_acc3 + bin_171;
                                                    v_acc3 = bin_172;
                                                }
                                            }
                                            double bin_173 = v_acc0 + v_acc1;
                                            double bin_174 = v_acc2 + v_acc3;
                                            double bin_175 = bin_173 + bin_174;
                                            v_C[(v_r) * 1024 + (v_c)] = bin_175;
                                        }
                                    }
                                }
                            }
                            VyneValue bin_176 = vyne_bool(v_iter == v_ITERS);
                            if (vyne_is_truthy(bin_176)) {
                                {
                                    double sid_178 = v_C[(0) * 1024 + (0)];
                                    VyneValue str_177 = vyne_to_string(vyne_float(sid_178));
                                    VyneValue bin_179 = vyne_binop(vyne_string_static("checksum: "), str_177, 29);
                                    vyne_out(bin_179);
                                }
                            }
                        }
                        vmem_runtime_rewind(vmem_cp_134);
                    }
                }
            }
        }
        VyneValue bin_180 = vyne_bool(v_CONFIG == 3);
        if (vyne_is_truthy(bin_180)) {
            {
                VyneArray_f64 v_C = vyne_array_f64_create(0);
                int64_t bin_181 = v_N * v_N;
                int64_t bin_182 = bin_181 - 1;
                int64_t lo_i_183 = 0;
                int64_t hi_i_184 = bin_182;
                for (int64_t i_185 = lo_i_183; i_185 <= hi_i_184; ++i_185) {
                    int64_t v_i = i_185;
                    {
                        vyne_array_f64_push(&v_C, 0);
                    }
                }
                int64_t lo_i_186 = 1;
                int64_t hi_i_187 = v_ITERS;
                for (int64_t i_188 = lo_i_186; i_188 <= hi_i_187; ++i_188) {
                    int64_t v_iter = i_188;
                    {
                        int64_t bin_189 = v_N - 1;
                        int64_t lo_i_190 = 0;
                        int64_t hi_i_191 = bin_189;
                        for (int64_t i_192 = lo_i_190; i_192 <= hi_i_191; ++i_192) {
                            int64_t v_r = i_192;
                            {
                                int64_t bin_193 = v_N - 1;
                                int64_t lo_i_194 = 0;
                                int64_t hi_i_195 = bin_193;
                                for (int64_t i_196 = lo_i_194; i_196 <= hi_i_195; ++i_196) {
                                    int64_t v_c = i_196;
                                    {
                                        double v_acc0 = 0;
                                        double v_acc1 = 0;
                                        double v_acc2 = 0;
                                        double v_acc3 = 0;
                                        if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                        int64_t bin_197 = v_N / 4;
                                        int64_t bin_198 = bin_197 - 1;
                                        int64_t lo_i_199 = 0;
                                        int64_t hi_i_200 = bin_198;
                                        for (int64_t i_201 = lo_i_199; i_201 <= hi_i_200; ++i_201) {
                                            int64_t v_k4 = i_201;
                                            {
                                                int64_t bin_202 = v_k4 * 4;
                                                int64_t v_k0 = bin_202;
                                                int64_t bin_203 = v_k0 + 0;
                                                double sid_204 = v_A[(v_r) * 1024 + (bin_203)];
                                                int64_t bin_205 = v_k0 + 0;
                                                double sid_206 = v_B_T[(v_c) * 1024 + (bin_205)];
                                                double bin_207 = sid_204 * sid_206;
                                                double bin_208 = v_acc0 + bin_207;
                                                v_acc0 = bin_208;
                                                int64_t bin_209 = v_k0 + 1;
                                                double sid_210 = v_A[(v_r) * 1024 + (bin_209)];
                                                int64_t bin_211 = v_k0 + 1;
                                                double sid_212 = v_B_T[(v_c) * 1024 + (bin_211)];
                                                double bin_213 = sid_210 * sid_212;
                                                double bin_214 = v_acc1 + bin_213;
                                                v_acc1 = bin_214;
                                                int64_t bin_215 = v_k0 + 2;
                                                double sid_216 = v_A[(v_r) * 1024 + (bin_215)];
                                                int64_t bin_217 = v_k0 + 2;
                                                double sid_218 = v_B_T[(v_c) * 1024 + (bin_217)];
                                                double bin_219 = sid_216 * sid_218;
                                                double bin_220 = v_acc2 + bin_219;
                                                v_acc2 = bin_220;
                                                int64_t bin_221 = v_k0 + 3;
                                                double sid_222 = v_A[(v_r) * 1024 + (bin_221)];
                                                int64_t bin_223 = v_k0 + 3;
                                                double sid_224 = v_B_T[(v_c) * 1024 + (bin_223)];
                                                double bin_225 = sid_222 * sid_224;
                                                double bin_226 = v_acc3 + bin_225;
                                                v_acc3 = bin_226;
                                            }
                                        }
                                        int64_t bin_227 = v_r * v_N;
                                        int64_t bin_228 = bin_227 + v_c;
                                        double bin_229 = v_acc0 + v_acc1;
                                        double bin_230 = v_acc2 + v_acc3;
                                        double bin_231 = bin_229 + bin_230;
                                        v_C.data[bin_228] = bin_231;
                                    }
                                }
                            }
                        }
                        VyneValue bin_232 = vyne_bool(v_iter == v_ITERS);
                        if (vyne_is_truthy(bin_232)) {
                            {
                                double idx_234 = v_C.data[0];
                                VyneValue str_233 = vyne_to_string(vyne_float(idx_234));
                                VyneValue bin_235 = vyne_binop(vyne_string_static("checksum: "), str_233, 29);
                                vyne_out(bin_235);
                            }
                        }
                    }
                }
            }
        }
    }
    vmem_runtime_rewind(vmem_cp_9);
    arena_free_all();
    return 0;
}
