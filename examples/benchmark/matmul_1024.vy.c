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
                        VyneValue arr_35 = vyne_array_create(0);
                        VyneValue v_C = arr_35;
                        int64_t bin_36 = v_N - 1;
                        int64_t lo_i_37 = 0;
                        int64_t hi_i_38 = bin_36;
                        for (int64_t i_39 = lo_i_37; i_39 <= hi_i_38; ++i_39) {
                            int64_t v_r = i_39;
                            {
                                int64_t bin_40 = v_N - 1;
                                int64_t lo_i_41 = 0;
                                int64_t hi_i_42 = bin_40;
                                for (int64_t i_43 = lo_i_41; i_43 <= hi_i_42; ++i_43) {
                                    int64_t v_c = i_43;
                                    {
                                        double v_acc0 = 0;
                                        double v_acc1 = 0;
                                        double v_acc2 = 0;
                                        double v_acc3 = 0;
                                        if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                        int64_t bin_44 = v_N / 4;
                                        int64_t bin_45 = bin_44 - 1;
                                        int64_t lo_i_46 = 0;
                                        int64_t hi_i_47 = bin_45;
                                        for (int64_t i_48 = lo_i_46; i_48 <= hi_i_47; ++i_48) {
                                            int64_t v_k4 = i_48;
                                            {
                                                int64_t bin_49 = v_k4 * 4;
                                                int64_t v_k0 = bin_49;
                                                int64_t bin_50 = v_k0 + 0;
                                                double sid_51 = v_A[(v_r) * 1024 + (bin_50)];
                                                int64_t bin_52 = v_k0 + 0;
                                                double sid_53 = v_B_T[(v_c) * 1024 + (bin_52)];
                                                double bin_54 = sid_51 * sid_53;
                                                double bin_55 = v_acc0 + bin_54;
                                                v_acc0 = bin_55;
                                                int64_t bin_56 = v_k0 + 1;
                                                double sid_57 = v_A[(v_r) * 1024 + (bin_56)];
                                                int64_t bin_58 = v_k0 + 1;
                                                double sid_59 = v_B_T[(v_c) * 1024 + (bin_58)];
                                                double bin_60 = sid_57 * sid_59;
                                                double bin_61 = v_acc1 + bin_60;
                                                v_acc1 = bin_61;
                                                int64_t bin_62 = v_k0 + 2;
                                                double sid_63 = v_A[(v_r) * 1024 + (bin_62)];
                                                int64_t bin_64 = v_k0 + 2;
                                                double sid_65 = v_B_T[(v_c) * 1024 + (bin_64)];
                                                double bin_66 = sid_63 * sid_65;
                                                double bin_67 = v_acc2 + bin_66;
                                                v_acc2 = bin_67;
                                                int64_t bin_68 = v_k0 + 3;
                                                double sid_69 = v_A[(v_r) * 1024 + (bin_68)];
                                                int64_t bin_70 = v_k0 + 3;
                                                double sid_71 = v_B_T[(v_c) * 1024 + (bin_70)];
                                                double bin_72 = sid_69 * sid_71;
                                                double bin_73 = v_acc3 + bin_72;
                                                v_acc3 = bin_73;
                                            }
                                        }
                                        VyneValue m_recv_74 = v_C;
                                        double bin_75 = v_acc0 + v_acc1;
                                        double bin_76 = v_acc2 + v_acc3;
                                        double bin_77 = bin_75 + bin_76;
                                        vyne_array_push(m_recv_74, vyne_float(bin_77));
                                    }
                                }
                            }
                        }
                        VyneValue bin_78 = vyne_bool(v_iter == v_ITERS);
                        if (vyne_is_truthy(bin_78)) {
                            {
                                VyneValue idx_80 = vyne_index_get(v_C, vyne_int(0));
                                VyneValue str_79 = vyne_to_string(idx_80);
                                VyneValue bin_81 = vyne_binop(vyne_string_static("checksum: "), str_79, 29);
                                vyne_out(bin_81);
                            }
                        }
                    }
                }
            }
        }
        VyneValue bin_82 = vyne_bool(v_CONFIG == 1);
        if (vyne_is_truthy(bin_82)) {
            {
                int64_t lo_i_83 = 1;
                int64_t hi_i_84 = v_ITERS;
                for (int64_t i_85 = lo_i_83; i_85 <= hi_i_84; ++i_85) {
                    int64_t v_iter = i_85;
                    {
                        // --- region: inner ---
                        VyneValue vmem_cp_86 = vmem_runtime_checkpoint();
                        {
                            VyneValue arr_87 = vyne_array_create(0);
                            VyneValue v_C = arr_87;
                            int64_t bin_88 = v_N - 1;
                            int64_t lo_i_89 = 0;
                            int64_t hi_i_90 = bin_88;
                            for (int64_t i_91 = lo_i_89; i_91 <= hi_i_90; ++i_91) {
                                int64_t v_r = i_91;
                                {
                                    int64_t bin_92 = v_N - 1;
                                    int64_t lo_i_93 = 0;
                                    int64_t hi_i_94 = bin_92;
                                    for (int64_t i_95 = lo_i_93; i_95 <= hi_i_94; ++i_95) {
                                        int64_t v_c = i_95;
                                        {
                                            double v_acc0 = 0;
                                            double v_acc1 = 0;
                                            double v_acc2 = 0;
                                            double v_acc3 = 0;
                                            if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                            int64_t bin_96 = v_N / 4;
                                            int64_t bin_97 = bin_96 - 1;
                                            int64_t lo_i_98 = 0;
                                            int64_t hi_i_99 = bin_97;
                                            for (int64_t i_100 = lo_i_98; i_100 <= hi_i_99; ++i_100) {
                                                int64_t v_k4 = i_100;
                                                {
                                                    int64_t bin_101 = v_k4 * 4;
                                                    int64_t v_k0 = bin_101;
                                                    int64_t bin_102 = v_k0 + 0;
                                                    double sid_103 = v_A[(v_r) * 1024 + (bin_102)];
                                                    int64_t bin_104 = v_k0 + 0;
                                                    double sid_105 = v_B_T[(v_c) * 1024 + (bin_104)];
                                                    double bin_106 = sid_103 * sid_105;
                                                    double bin_107 = v_acc0 + bin_106;
                                                    v_acc0 = bin_107;
                                                    int64_t bin_108 = v_k0 + 1;
                                                    double sid_109 = v_A[(v_r) * 1024 + (bin_108)];
                                                    int64_t bin_110 = v_k0 + 1;
                                                    double sid_111 = v_B_T[(v_c) * 1024 + (bin_110)];
                                                    double bin_112 = sid_109 * sid_111;
                                                    double bin_113 = v_acc1 + bin_112;
                                                    v_acc1 = bin_113;
                                                    int64_t bin_114 = v_k0 + 2;
                                                    double sid_115 = v_A[(v_r) * 1024 + (bin_114)];
                                                    int64_t bin_116 = v_k0 + 2;
                                                    double sid_117 = v_B_T[(v_c) * 1024 + (bin_116)];
                                                    double bin_118 = sid_115 * sid_117;
                                                    double bin_119 = v_acc2 + bin_118;
                                                    v_acc2 = bin_119;
                                                    int64_t bin_120 = v_k0 + 3;
                                                    double sid_121 = v_A[(v_r) * 1024 + (bin_120)];
                                                    int64_t bin_122 = v_k0 + 3;
                                                    double sid_123 = v_B_T[(v_c) * 1024 + (bin_122)];
                                                    double bin_124 = sid_121 * sid_123;
                                                    double bin_125 = v_acc3 + bin_124;
                                                    v_acc3 = bin_125;
                                                }
                                            }
                                            VyneValue m_recv_126 = v_C;
                                            double bin_127 = v_acc0 + v_acc1;
                                            double bin_128 = v_acc2 + v_acc3;
                                            double bin_129 = bin_127 + bin_128;
                                            vyne_array_push(m_recv_126, vyne_float(bin_129));
                                        }
                                    }
                                }
                            }
                            VyneValue bin_130 = vyne_bool(v_iter == v_ITERS);
                            if (vyne_is_truthy(bin_130)) {
                                {
                                    VyneValue idx_132 = vyne_index_get(v_C, vyne_int(0));
                                    VyneValue str_131 = vyne_to_string(idx_132);
                                    VyneValue bin_133 = vyne_binop(vyne_string_static("checksum: "), str_131, 29);
                                    vyne_out(bin_133);
                                }
                            }
                        }
                        vmem_runtime_rewind(vmem_cp_86);
                    }
                }
            }
        }
        VyneValue bin_134 = vyne_bool(v_CONFIG == 2);
        if (vyne_is_truthy(bin_134)) {
            {
                int64_t lo_i_135 = 1;
                int64_t hi_i_136 = v_ITERS;
                for (int64_t i_137 = lo_i_135; i_137 <= hi_i_136; ++i_137) {
                    int64_t v_iter = i_137;
                    {
                        // --- region: inner ---
                        VyneValue vmem_cp_138 = vmem_runtime_checkpoint();
                        {
                            double v_C[1048576];
                            int64_t bin_139 = v_N - 1;
                            int64_t lo_i_140 = 0;
                            int64_t hi_i_141 = bin_139;
                            for (int64_t i_142 = lo_i_140; i_142 <= hi_i_141; ++i_142) {
                                int64_t v_r = i_142;
                                {
                                    int64_t bin_143 = v_N - 1;
                                    int64_t lo_i_144 = 0;
                                    int64_t hi_i_145 = bin_143;
                                    for (int64_t i_146 = lo_i_144; i_146 <= hi_i_145; ++i_146) {
                                        int64_t v_c = i_146;
                                        {
                                            double v_acc0 = 0;
                                            double v_acc1 = 0;
                                            double v_acc2 = 0;
                                            double v_acc3 = 0;
                                            if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                            int64_t bin_147 = v_N / 4;
                                            int64_t bin_148 = bin_147 - 1;
                                            int64_t lo_i_149 = 0;
                                            int64_t hi_i_150 = bin_148;
                                            for (int64_t i_151 = lo_i_149; i_151 <= hi_i_150; ++i_151) {
                                                int64_t v_k4 = i_151;
                                                {
                                                    int64_t bin_152 = v_k4 * 4;
                                                    int64_t v_k0 = bin_152;
                                                    int64_t bin_153 = v_k0 + 0;
                                                    double sid_154 = v_A[(v_r) * 1024 + (bin_153)];
                                                    int64_t bin_155 = v_k0 + 0;
                                                    double sid_156 = v_B_T[(v_c) * 1024 + (bin_155)];
                                                    double bin_157 = sid_154 * sid_156;
                                                    double bin_158 = v_acc0 + bin_157;
                                                    v_acc0 = bin_158;
                                                    int64_t bin_159 = v_k0 + 1;
                                                    double sid_160 = v_A[(v_r) * 1024 + (bin_159)];
                                                    int64_t bin_161 = v_k0 + 1;
                                                    double sid_162 = v_B_T[(v_c) * 1024 + (bin_161)];
                                                    double bin_163 = sid_160 * sid_162;
                                                    double bin_164 = v_acc1 + bin_163;
                                                    v_acc1 = bin_164;
                                                    int64_t bin_165 = v_k0 + 2;
                                                    double sid_166 = v_A[(v_r) * 1024 + (bin_165)];
                                                    int64_t bin_167 = v_k0 + 2;
                                                    double sid_168 = v_B_T[(v_c) * 1024 + (bin_167)];
                                                    double bin_169 = sid_166 * sid_168;
                                                    double bin_170 = v_acc2 + bin_169;
                                                    v_acc2 = bin_170;
                                                    int64_t bin_171 = v_k0 + 3;
                                                    double sid_172 = v_A[(v_r) * 1024 + (bin_171)];
                                                    int64_t bin_173 = v_k0 + 3;
                                                    double sid_174 = v_B_T[(v_c) * 1024 + (bin_173)];
                                                    double bin_175 = sid_172 * sid_174;
                                                    double bin_176 = v_acc3 + bin_175;
                                                    v_acc3 = bin_176;
                                                }
                                            }
                                            double bin_177 = v_acc0 + v_acc1;
                                            double bin_178 = v_acc2 + v_acc3;
                                            double bin_179 = bin_177 + bin_178;
                                            v_C[(v_r) * 1024 + (v_c)] = bin_179;
                                        }
                                    }
                                }
                            }
                            VyneValue bin_180 = vyne_bool(v_iter == v_ITERS);
                            if (vyne_is_truthy(bin_180)) {
                                {
                                    double sid_182 = v_C[(0) * 1024 + (0)];
                                    VyneValue str_181 = vyne_to_string(vyne_float(sid_182));
                                    VyneValue bin_183 = vyne_binop(vyne_string_static("checksum: "), str_181, 29);
                                    vyne_out(bin_183);
                                }
                            }
                        }
                        vmem_runtime_rewind(vmem_cp_138);
                    }
                }
            }
        }
    }
    vmem_runtime_rewind(vmem_cp_9);
    arena_free_all();
    return 0;
}
