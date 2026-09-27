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
                        int64_t si_18 = v_r;
                        if (VYNE_UNLIKELY(si_18 < 0 || si_18 >= 1024)) {
                            fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 39\n", (long long)si_18);
                            exit(1);
                        }
                        int64_t si_19 = v_c;
                        if (VYNE_UNLIKELY(si_19 < 0 || si_19 >= 1024)) {
                            fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 39\n", (long long)si_19);
                            exit(1);
                        }
                        VyneValue un_21 = vyne_unary(vyne_float(1), 30);
                        VyneValue n_ret_20 = vmath_random_float(un_21, vyne_float(1));
                        v_A[(si_18) * 1024 + (si_19)] = ((n_ret_20).type == V_FLOAT64) ? (n_ret_20).as.f64 : (double)(n_ret_20).as.i64;
                        int64_t si_22 = v_r;
                        if (VYNE_UNLIKELY(si_22 < 0 || si_22 >= 1024)) {
                            fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 40\n", (long long)si_22);
                            exit(1);
                        }
                        int64_t si_23 = v_c;
                        if (VYNE_UNLIKELY(si_23 < 0 || si_23 >= 1024)) {
                            fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 40\n", (long long)si_23);
                            exit(1);
                        }
                        VyneValue un_25 = vyne_unary(vyne_float(1), 30);
                        VyneValue n_ret_24 = vmath_random_float(un_25, vyne_float(1));
                        v_B[(si_22) * 1024 + (si_23)] = ((n_ret_24).type == V_FLOAT64) ? (n_ret_24).as.f64 : (double)(n_ret_24).as.i64;
                    }
                }
            }
        }
        int64_t bin_26 = v_N - 1;
        int64_t lo_i_27 = 0;
        int64_t hi_i_28 = bin_26;
        for (int64_t i_29 = lo_i_27; i_29 <= hi_i_28; ++i_29) {
            int64_t v_r = i_29;
            {
                int64_t bin_30 = v_N - 1;
                int64_t lo_i_31 = 0;
                int64_t hi_i_32 = bin_30;
                for (int64_t i_33 = lo_i_31; i_33 <= hi_i_32; ++i_33) {
                    int64_t v_c = i_33;
                    {
                        int64_t si_34 = v_c;
                        if (VYNE_UNLIKELY(si_34 < 0 || si_34 >= 1024)) {
                            fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 47\n", (long long)si_34);
                            exit(1);
                        }
                        int64_t si_35 = v_r;
                        if (VYNE_UNLIKELY(si_35 < 0 || si_35 >= 1024)) {
                            fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 47\n", (long long)si_35);
                            exit(1);
                        }
                        int64_t si_36 = v_r;
                        if (VYNE_UNLIKELY(si_36 < 0 || si_36 >= 1024)) {
                            fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 47\n", (long long)si_36);
                            exit(1);
                        }
                        int64_t si_37 = v_c;
                        if (VYNE_UNLIKELY(si_37 < 0 || si_37 >= 1024)) {
                            fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 47\n", (long long)si_37);
                            exit(1);
                        }
                        double sid_38 = v_B[(si_36) * 1024 + (si_37)];
                        v_B_T[(si_34) * 1024 + (si_35)] = sid_38;
                    }
                }
            }
        }
        VyneValue bin_39 = vyne_bool(v_CONFIG == 0);
        if (vyne_is_truthy(bin_39)) {
            {
                int64_t lo_i_40 = 1;
                int64_t hi_i_41 = v_ITERS;
                for (int64_t i_42 = lo_i_40; i_42 <= hi_i_41; ++i_42) {
                    int64_t v_iter = i_42;
                    {
                        VyneValue arr_43 = vyne_array_create(0);
                        VyneValue v_C = arr_43;
                        int64_t bin_44 = v_N - 1;
                        int64_t lo_i_45 = 0;
                        int64_t hi_i_46 = bin_44;
                        for (int64_t i_47 = lo_i_45; i_47 <= hi_i_46; ++i_47) {
                            int64_t v_r = i_47;
                            {
                                int64_t bin_48 = v_N - 1;
                                int64_t lo_i_49 = 0;
                                int64_t hi_i_50 = bin_48;
                                for (int64_t i_51 = lo_i_49; i_51 <= hi_i_50; ++i_51) {
                                    int64_t v_c = i_51;
                                    {
                                        double v_acc0 = 0;
                                        double v_acc1 = 0;
                                        double v_acc2 = 0;
                                        double v_acc3 = 0;
                                        if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                        int64_t bin_52 = v_N / 4;
                                        int64_t bin_53 = bin_52 - 1;
                                        int64_t lo_i_54 = 0;
                                        int64_t hi_i_55 = bin_53;
                                        for (int64_t i_56 = lo_i_54; i_56 <= hi_i_55; ++i_56) {
                                            int64_t v_k4 = i_56;
                                            {
                                                int64_t bin_57 = v_k4 * 4;
                                                int64_t v_k0 = bin_57;
                                                int64_t si_58 = v_r;
                                                if (VYNE_UNLIKELY(si_58 < 0 || si_58 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 62\n", (long long)si_58);
                                                    exit(1);
                                                }
                                                int64_t bin_59 = v_k0 + 0;
                                                int64_t si_60 = bin_59;
                                                if (VYNE_UNLIKELY(si_60 < 0 || si_60 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_60);
                                                    exit(1);
                                                }
                                                double sid_61 = v_A[(si_58) * 1024 + (si_60)];
                                                int64_t si_62 = v_c;
                                                if (VYNE_UNLIKELY(si_62 < 0 || si_62 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 62\n", (long long)si_62);
                                                    exit(1);
                                                }
                                                int64_t bin_63 = v_k0 + 0;
                                                int64_t si_64 = bin_63;
                                                if (VYNE_UNLIKELY(si_64 < 0 || si_64 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_64);
                                                    exit(1);
                                                }
                                                double sid_65 = v_B_T[(si_62) * 1024 + (si_64)];
                                                double bin_66 = sid_61 * sid_65;
                                                double bin_67 = v_acc0 + bin_66;
                                                v_acc0 = bin_67;
                                                int64_t si_68 = v_r;
                                                if (VYNE_UNLIKELY(si_68 < 0 || si_68 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 63\n", (long long)si_68);
                                                    exit(1);
                                                }
                                                int64_t bin_69 = v_k0 + 1;
                                                int64_t si_70 = bin_69;
                                                if (VYNE_UNLIKELY(si_70 < 0 || si_70 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_70);
                                                    exit(1);
                                                }
                                                double sid_71 = v_A[(si_68) * 1024 + (si_70)];
                                                int64_t si_72 = v_c;
                                                if (VYNE_UNLIKELY(si_72 < 0 || si_72 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 63\n", (long long)si_72);
                                                    exit(1);
                                                }
                                                int64_t bin_73 = v_k0 + 1;
                                                int64_t si_74 = bin_73;
                                                if (VYNE_UNLIKELY(si_74 < 0 || si_74 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_74);
                                                    exit(1);
                                                }
                                                double sid_75 = v_B_T[(si_72) * 1024 + (si_74)];
                                                double bin_76 = sid_71 * sid_75;
                                                double bin_77 = v_acc1 + bin_76;
                                                v_acc1 = bin_77;
                                                int64_t si_78 = v_r;
                                                if (VYNE_UNLIKELY(si_78 < 0 || si_78 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 64\n", (long long)si_78);
                                                    exit(1);
                                                }
                                                int64_t bin_79 = v_k0 + 2;
                                                int64_t si_80 = bin_79;
                                                if (VYNE_UNLIKELY(si_80 < 0 || si_80 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_80);
                                                    exit(1);
                                                }
                                                double sid_81 = v_A[(si_78) * 1024 + (si_80)];
                                                int64_t si_82 = v_c;
                                                if (VYNE_UNLIKELY(si_82 < 0 || si_82 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 64\n", (long long)si_82);
                                                    exit(1);
                                                }
                                                int64_t bin_83 = v_k0 + 2;
                                                int64_t si_84 = bin_83;
                                                if (VYNE_UNLIKELY(si_84 < 0 || si_84 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_84);
                                                    exit(1);
                                                }
                                                double sid_85 = v_B_T[(si_82) * 1024 + (si_84)];
                                                double bin_86 = sid_81 * sid_85;
                                                double bin_87 = v_acc2 + bin_86;
                                                v_acc2 = bin_87;
                                                int64_t si_88 = v_r;
                                                if (VYNE_UNLIKELY(si_88 < 0 || si_88 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 65\n", (long long)si_88);
                                                    exit(1);
                                                }
                                                int64_t bin_89 = v_k0 + 3;
                                                int64_t si_90 = bin_89;
                                                if (VYNE_UNLIKELY(si_90 < 0 || si_90 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_90);
                                                    exit(1);
                                                }
                                                double sid_91 = v_A[(si_88) * 1024 + (si_90)];
                                                int64_t si_92 = v_c;
                                                if (VYNE_UNLIKELY(si_92 < 0 || si_92 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 65\n", (long long)si_92);
                                                    exit(1);
                                                }
                                                int64_t bin_93 = v_k0 + 3;
                                                int64_t si_94 = bin_93;
                                                if (VYNE_UNLIKELY(si_94 < 0 || si_94 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_94);
                                                    exit(1);
                                                }
                                                double sid_95 = v_B_T[(si_92) * 1024 + (si_94)];
                                                double bin_96 = sid_91 * sid_95;
                                                double bin_97 = v_acc3 + bin_96;
                                                v_acc3 = bin_97;
                                            }
                                        }
                                        VyneValue m_recv_98 = v_C;
                                        double bin_99 = v_acc0 + v_acc1;
                                        double bin_100 = v_acc2 + v_acc3;
                                        double bin_101 = bin_99 + bin_100;
                                        vyne_array_push(m_recv_98, vyne_float(bin_101));
                                    }
                                }
                            }
                        }
                        VyneValue bin_102 = vyne_bool(v_iter == v_ITERS);
                        if (vyne_is_truthy(bin_102)) {
                            {
                                VyneValue idx_104 = vyne_index_get(v_C, vyne_int(0));
                                VyneValue str_103 = vyne_to_string(idx_104);
                                VyneValue bin_105 = vyne_binop(vyne_string_static("checksum: "), str_103, 29);
                                vyne_out(bin_105);
                            }
                        }
                    }
                }
            }
        }
        VyneValue bin_106 = vyne_bool(v_CONFIG == 1);
        if (vyne_is_truthy(bin_106)) {
            {
                int64_t lo_i_107 = 1;
                int64_t hi_i_108 = v_ITERS;
                for (int64_t i_109 = lo_i_107; i_109 <= hi_i_108; ++i_109) {
                    int64_t v_iter = i_109;
                    {
                        // --- region: inner ---
                        VyneValue vmem_cp_110 = vmem_runtime_checkpoint();
                        {
                            VyneValue arr_111 = vyne_array_create(0);
                            VyneValue v_C = arr_111;
                            int64_t bin_112 = v_N - 1;
                            int64_t lo_i_113 = 0;
                            int64_t hi_i_114 = bin_112;
                            for (int64_t i_115 = lo_i_113; i_115 <= hi_i_114; ++i_115) {
                                int64_t v_r = i_115;
                                {
                                    int64_t bin_116 = v_N - 1;
                                    int64_t lo_i_117 = 0;
                                    int64_t hi_i_118 = bin_116;
                                    for (int64_t i_119 = lo_i_117; i_119 <= hi_i_118; ++i_119) {
                                        int64_t v_c = i_119;
                                        {
                                            double v_acc0 = 0;
                                            double v_acc1 = 0;
                                            double v_acc2 = 0;
                                            double v_acc3 = 0;
                                            if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                            int64_t bin_120 = v_N / 4;
                                            int64_t bin_121 = bin_120 - 1;
                                            int64_t lo_i_122 = 0;
                                            int64_t hi_i_123 = bin_121;
                                            for (int64_t i_124 = lo_i_122; i_124 <= hi_i_123; ++i_124) {
                                                int64_t v_k4 = i_124;
                                                {
                                                    int64_t bin_125 = v_k4 * 4;
                                                    int64_t v_k0 = bin_125;
                                                    int64_t si_126 = v_r;
                                                    if (VYNE_UNLIKELY(si_126 < 0 || si_126 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 86\n", (long long)si_126);
                                                        exit(1);
                                                    }
                                                    int64_t bin_127 = v_k0 + 0;
                                                    int64_t si_128 = bin_127;
                                                    if (VYNE_UNLIKELY(si_128 < 0 || si_128 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_128);
                                                        exit(1);
                                                    }
                                                    double sid_129 = v_A[(si_126) * 1024 + (si_128)];
                                                    int64_t si_130 = v_c;
                                                    if (VYNE_UNLIKELY(si_130 < 0 || si_130 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 86\n", (long long)si_130);
                                                        exit(1);
                                                    }
                                                    int64_t bin_131 = v_k0 + 0;
                                                    int64_t si_132 = bin_131;
                                                    if (VYNE_UNLIKELY(si_132 < 0 || si_132 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_132);
                                                        exit(1);
                                                    }
                                                    double sid_133 = v_B_T[(si_130) * 1024 + (si_132)];
                                                    double bin_134 = sid_129 * sid_133;
                                                    double bin_135 = v_acc0 + bin_134;
                                                    v_acc0 = bin_135;
                                                    int64_t si_136 = v_r;
                                                    if (VYNE_UNLIKELY(si_136 < 0 || si_136 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 87\n", (long long)si_136);
                                                        exit(1);
                                                    }
                                                    int64_t bin_137 = v_k0 + 1;
                                                    int64_t si_138 = bin_137;
                                                    if (VYNE_UNLIKELY(si_138 < 0 || si_138 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_138);
                                                        exit(1);
                                                    }
                                                    double sid_139 = v_A[(si_136) * 1024 + (si_138)];
                                                    int64_t si_140 = v_c;
                                                    if (VYNE_UNLIKELY(si_140 < 0 || si_140 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 87\n", (long long)si_140);
                                                        exit(1);
                                                    }
                                                    int64_t bin_141 = v_k0 + 1;
                                                    int64_t si_142 = bin_141;
                                                    if (VYNE_UNLIKELY(si_142 < 0 || si_142 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_142);
                                                        exit(1);
                                                    }
                                                    double sid_143 = v_B_T[(si_140) * 1024 + (si_142)];
                                                    double bin_144 = sid_139 * sid_143;
                                                    double bin_145 = v_acc1 + bin_144;
                                                    v_acc1 = bin_145;
                                                    int64_t si_146 = v_r;
                                                    if (VYNE_UNLIKELY(si_146 < 0 || si_146 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 88\n", (long long)si_146);
                                                        exit(1);
                                                    }
                                                    int64_t bin_147 = v_k0 + 2;
                                                    int64_t si_148 = bin_147;
                                                    if (VYNE_UNLIKELY(si_148 < 0 || si_148 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_148);
                                                        exit(1);
                                                    }
                                                    double sid_149 = v_A[(si_146) * 1024 + (si_148)];
                                                    int64_t si_150 = v_c;
                                                    if (VYNE_UNLIKELY(si_150 < 0 || si_150 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 88\n", (long long)si_150);
                                                        exit(1);
                                                    }
                                                    int64_t bin_151 = v_k0 + 2;
                                                    int64_t si_152 = bin_151;
                                                    if (VYNE_UNLIKELY(si_152 < 0 || si_152 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_152);
                                                        exit(1);
                                                    }
                                                    double sid_153 = v_B_T[(si_150) * 1024 + (si_152)];
                                                    double bin_154 = sid_149 * sid_153;
                                                    double bin_155 = v_acc2 + bin_154;
                                                    v_acc2 = bin_155;
                                                    int64_t si_156 = v_r;
                                                    if (VYNE_UNLIKELY(si_156 < 0 || si_156 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 89\n", (long long)si_156);
                                                        exit(1);
                                                    }
                                                    int64_t bin_157 = v_k0 + 3;
                                                    int64_t si_158 = bin_157;
                                                    if (VYNE_UNLIKELY(si_158 < 0 || si_158 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_158);
                                                        exit(1);
                                                    }
                                                    double sid_159 = v_A[(si_156) * 1024 + (si_158)];
                                                    int64_t si_160 = v_c;
                                                    if (VYNE_UNLIKELY(si_160 < 0 || si_160 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 89\n", (long long)si_160);
                                                        exit(1);
                                                    }
                                                    int64_t bin_161 = v_k0 + 3;
                                                    int64_t si_162 = bin_161;
                                                    if (VYNE_UNLIKELY(si_162 < 0 || si_162 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_162);
                                                        exit(1);
                                                    }
                                                    double sid_163 = v_B_T[(si_160) * 1024 + (si_162)];
                                                    double bin_164 = sid_159 * sid_163;
                                                    double bin_165 = v_acc3 + bin_164;
                                                    v_acc3 = bin_165;
                                                }
                                            }
                                            VyneValue m_recv_166 = v_C;
                                            double bin_167 = v_acc0 + v_acc1;
                                            double bin_168 = v_acc2 + v_acc3;
                                            double bin_169 = bin_167 + bin_168;
                                            vyne_array_push(m_recv_166, vyne_float(bin_169));
                                        }
                                    }
                                }
                            }
                            VyneValue bin_170 = vyne_bool(v_iter == v_ITERS);
                            if (vyne_is_truthy(bin_170)) {
                                {
                                    VyneValue idx_172 = vyne_index_get(v_C, vyne_int(0));
                                    VyneValue str_171 = vyne_to_string(idx_172);
                                    VyneValue bin_173 = vyne_binop(vyne_string_static("checksum: "), str_171, 29);
                                    vyne_out(bin_173);
                                }
                            }
                        }
                        vmem_runtime_rewind(vmem_cp_110);
                    }
                }
            }
        }
        VyneValue bin_174 = vyne_bool(v_CONFIG == 2);
        if (vyne_is_truthy(bin_174)) {
            {
                int64_t lo_i_175 = 1;
                int64_t hi_i_176 = v_ITERS;
                for (int64_t i_177 = lo_i_175; i_177 <= hi_i_176; ++i_177) {
                    int64_t v_iter = i_177;
                    {
                        // --- region: inner ---
                        VyneValue vmem_cp_178 = vmem_runtime_checkpoint();
                        {
                            double v_C[1048576];
                            int64_t bin_179 = v_N - 1;
                            int64_t lo_i_180 = 0;
                            int64_t hi_i_181 = bin_179;
                            for (int64_t i_182 = lo_i_180; i_182 <= hi_i_181; ++i_182) {
                                int64_t v_r = i_182;
                                {
                                    int64_t bin_183 = v_N - 1;
                                    int64_t lo_i_184 = 0;
                                    int64_t hi_i_185 = bin_183;
                                    for (int64_t i_186 = lo_i_184; i_186 <= hi_i_185; ++i_186) {
                                        int64_t v_c = i_186;
                                        {
                                            double v_acc0 = 0;
                                            double v_acc1 = 0;
                                            double v_acc2 = 0;
                                            double v_acc3 = 0;
                                            if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                            int64_t bin_187 = v_N / 4;
                                            int64_t bin_188 = bin_187 - 1;
                                            int64_t lo_i_189 = 0;
                                            int64_t hi_i_190 = bin_188;
                                            for (int64_t i_191 = lo_i_189; i_191 <= hi_i_190; ++i_191) {
                                                int64_t v_k4 = i_191;
                                                {
                                                    int64_t bin_192 = v_k4 * 4;
                                                    int64_t v_k0 = bin_192;
                                                    int64_t si_193 = v_r;
                                                    if (VYNE_UNLIKELY(si_193 < 0 || si_193 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 111\n", (long long)si_193);
                                                        exit(1);
                                                    }
                                                    int64_t bin_194 = v_k0 + 0;
                                                    int64_t si_195 = bin_194;
                                                    if (VYNE_UNLIKELY(si_195 < 0 || si_195 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_195);
                                                        exit(1);
                                                    }
                                                    double sid_196 = v_A[(si_193) * 1024 + (si_195)];
                                                    int64_t si_197 = v_c;
                                                    if (VYNE_UNLIKELY(si_197 < 0 || si_197 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 111\n", (long long)si_197);
                                                        exit(1);
                                                    }
                                                    int64_t bin_198 = v_k0 + 0;
                                                    int64_t si_199 = bin_198;
                                                    if (VYNE_UNLIKELY(si_199 < 0 || si_199 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_199);
                                                        exit(1);
                                                    }
                                                    double sid_200 = v_B_T[(si_197) * 1024 + (si_199)];
                                                    double bin_201 = sid_196 * sid_200;
                                                    double bin_202 = v_acc0 + bin_201;
                                                    v_acc0 = bin_202;
                                                    int64_t si_203 = v_r;
                                                    if (VYNE_UNLIKELY(si_203 < 0 || si_203 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 112\n", (long long)si_203);
                                                        exit(1);
                                                    }
                                                    int64_t bin_204 = v_k0 + 1;
                                                    int64_t si_205 = bin_204;
                                                    if (VYNE_UNLIKELY(si_205 < 0 || si_205 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_205);
                                                        exit(1);
                                                    }
                                                    double sid_206 = v_A[(si_203) * 1024 + (si_205)];
                                                    int64_t si_207 = v_c;
                                                    if (VYNE_UNLIKELY(si_207 < 0 || si_207 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 112\n", (long long)si_207);
                                                        exit(1);
                                                    }
                                                    int64_t bin_208 = v_k0 + 1;
                                                    int64_t si_209 = bin_208;
                                                    if (VYNE_UNLIKELY(si_209 < 0 || si_209 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_209);
                                                        exit(1);
                                                    }
                                                    double sid_210 = v_B_T[(si_207) * 1024 + (si_209)];
                                                    double bin_211 = sid_206 * sid_210;
                                                    double bin_212 = v_acc1 + bin_211;
                                                    v_acc1 = bin_212;
                                                    int64_t si_213 = v_r;
                                                    if (VYNE_UNLIKELY(si_213 < 0 || si_213 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 113\n", (long long)si_213);
                                                        exit(1);
                                                    }
                                                    int64_t bin_214 = v_k0 + 2;
                                                    int64_t si_215 = bin_214;
                                                    if (VYNE_UNLIKELY(si_215 < 0 || si_215 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_215);
                                                        exit(1);
                                                    }
                                                    double sid_216 = v_A[(si_213) * 1024 + (si_215)];
                                                    int64_t si_217 = v_c;
                                                    if (VYNE_UNLIKELY(si_217 < 0 || si_217 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 113\n", (long long)si_217);
                                                        exit(1);
                                                    }
                                                    int64_t bin_218 = v_k0 + 2;
                                                    int64_t si_219 = bin_218;
                                                    if (VYNE_UNLIKELY(si_219 < 0 || si_219 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_219);
                                                        exit(1);
                                                    }
                                                    double sid_220 = v_B_T[(si_217) * 1024 + (si_219)];
                                                    double bin_221 = sid_216 * sid_220;
                                                    double bin_222 = v_acc2 + bin_221;
                                                    v_acc2 = bin_222;
                                                    int64_t si_223 = v_r;
                                                    if (VYNE_UNLIKELY(si_223 < 0 || si_223 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 114\n", (long long)si_223);
                                                        exit(1);
                                                    }
                                                    int64_t bin_224 = v_k0 + 3;
                                                    int64_t si_225 = bin_224;
                                                    if (VYNE_UNLIKELY(si_225 < 0 || si_225 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_225);
                                                        exit(1);
                                                    }
                                                    double sid_226 = v_A[(si_223) * 1024 + (si_225)];
                                                    int64_t si_227 = v_c;
                                                    if (VYNE_UNLIKELY(si_227 < 0 || si_227 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 114\n", (long long)si_227);
                                                        exit(1);
                                                    }
                                                    int64_t bin_228 = v_k0 + 3;
                                                    int64_t si_229 = bin_228;
                                                    if (VYNE_UNLIKELY(si_229 < 0 || si_229 >= 1024)) {
                                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_229);
                                                        exit(1);
                                                    }
                                                    double sid_230 = v_B_T[(si_227) * 1024 + (si_229)];
                                                    double bin_231 = sid_226 * sid_230;
                                                    double bin_232 = v_acc3 + bin_231;
                                                    v_acc3 = bin_232;
                                                }
                                            }
                                            int64_t si_233 = v_r;
                                            if (VYNE_UNLIKELY(si_233 < 0 || si_233 >= 1024)) {
                                                fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 116\n", (long long)si_233);
                                                exit(1);
                                            }
                                            int64_t si_234 = v_c;
                                            if (VYNE_UNLIKELY(si_234 < 0 || si_234 >= 1024)) {
                                                fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 116\n", (long long)si_234);
                                                exit(1);
                                            }
                                            double bin_235 = v_acc0 + v_acc1;
                                            double bin_236 = v_acc2 + v_acc3;
                                            double bin_237 = bin_235 + bin_236;
                                            v_C[(si_233) * 1024 + (si_234)] = bin_237;
                                        }
                                    }
                                }
                            }
                            VyneValue bin_238 = vyne_bool(v_iter == v_ITERS);
                            if (vyne_is_truthy(bin_238)) {
                                {
                                    int64_t si_240 = 0;
                                    if (VYNE_UNLIKELY(si_240 < 0 || si_240 >= 1024)) {
                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 119\n", (long long)si_240);
                                        exit(1);
                                    }
                                    int64_t si_241 = 0;
                                    if (VYNE_UNLIKELY(si_241 < 0 || si_241 >= 1024)) {
                                        fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 119\n", (long long)si_241);
                                        exit(1);
                                    }
                                    double sid_242 = v_C[(si_240) * 1024 + (si_241)];
                                    VyneValue str_239 = vyne_to_string(vyne_float(sid_242));
                                    VyneValue bin_243 = vyne_binop(vyne_string_static("checksum: "), str_239, 29);
                                    vyne_out(bin_243);
                                }
                            }
                        }
                        vmem_runtime_rewind(vmem_cp_178);
                    }
                }
            }
        }
        VyneValue bin_244 = vyne_bool(v_CONFIG == 3);
        if (vyne_is_truthy(bin_244)) {
            {
                VyneValue arr_245 = vyne_array_create(0);
                VyneValue v_C = arr_245;
                int64_t bin_246 = v_N * v_N;
                int64_t bin_247 = bin_246 - 1;
                int64_t lo_i_248 = 0;
                int64_t hi_i_249 = bin_247;
                for (int64_t i_250 = lo_i_248; i_250 <= hi_i_249; ++i_250) {
                    int64_t v_i = i_250;
                    {
                        VyneValue m_recv_251 = v_C;
                        vyne_array_push(m_recv_251, vyne_float(0));
                    }
                }
                int64_t lo_i_252 = 1;
                int64_t hi_i_253 = v_ITERS;
                for (int64_t i_254 = lo_i_252; i_254 <= hi_i_253; ++i_254) {
                    int64_t v_iter = i_254;
                    {
                        int64_t bin_255 = v_N - 1;
                        int64_t lo_i_256 = 0;
                        int64_t hi_i_257 = bin_255;
                        for (int64_t i_258 = lo_i_256; i_258 <= hi_i_257; ++i_258) {
                            int64_t v_r = i_258;
                            {
                                int64_t bin_259 = v_N - 1;
                                int64_t lo_i_260 = 0;
                                int64_t hi_i_261 = bin_259;
                                for (int64_t i_262 = lo_i_260; i_262 <= hi_i_261; ++i_262) {
                                    int64_t v_c = i_262;
                                    {
                                        double v_acc0 = 0;
                                        double v_acc1 = 0;
                                        double v_acc2 = 0;
                                        double v_acc3 = 0;
                                        if (4 == 0) { fprintf(stderr, "Runtime error: Division by zero!\n"); exit(1); }
                                        int64_t bin_263 = v_N / 4;
                                        int64_t bin_264 = bin_263 - 1;
                                        int64_t lo_i_265 = 0;
                                        int64_t hi_i_266 = bin_264;
                                        for (int64_t i_267 = lo_i_265; i_267 <= hi_i_266; ++i_267) {
                                            int64_t v_k4 = i_267;
                                            {
                                                int64_t bin_268 = v_k4 * 4;
                                                int64_t v_k0 = bin_268;
                                                int64_t si_269 = v_r;
                                                if (VYNE_UNLIKELY(si_269 < 0 || si_269 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 142\n", (long long)si_269);
                                                    exit(1);
                                                }
                                                int64_t bin_270 = v_k0 + 0;
                                                int64_t si_271 = bin_270;
                                                if (VYNE_UNLIKELY(si_271 < 0 || si_271 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_271);
                                                    exit(1);
                                                }
                                                double sid_272 = v_A[(si_269) * 1024 + (si_271)];
                                                int64_t si_273 = v_c;
                                                if (VYNE_UNLIKELY(si_273 < 0 || si_273 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 142\n", (long long)si_273);
                                                    exit(1);
                                                }
                                                int64_t bin_274 = v_k0 + 0;
                                                int64_t si_275 = bin_274;
                                                if (VYNE_UNLIKELY(si_275 < 0 || si_275 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_275);
                                                    exit(1);
                                                }
                                                double sid_276 = v_B_T[(si_273) * 1024 + (si_275)];
                                                double bin_277 = sid_272 * sid_276;
                                                double bin_278 = v_acc0 + bin_277;
                                                v_acc0 = bin_278;
                                                int64_t si_279 = v_r;
                                                if (VYNE_UNLIKELY(si_279 < 0 || si_279 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 143\n", (long long)si_279);
                                                    exit(1);
                                                }
                                                int64_t bin_280 = v_k0 + 1;
                                                int64_t si_281 = bin_280;
                                                if (VYNE_UNLIKELY(si_281 < 0 || si_281 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_281);
                                                    exit(1);
                                                }
                                                double sid_282 = v_A[(si_279) * 1024 + (si_281)];
                                                int64_t si_283 = v_c;
                                                if (VYNE_UNLIKELY(si_283 < 0 || si_283 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 143\n", (long long)si_283);
                                                    exit(1);
                                                }
                                                int64_t bin_284 = v_k0 + 1;
                                                int64_t si_285 = bin_284;
                                                if (VYNE_UNLIKELY(si_285 < 0 || si_285 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_285);
                                                    exit(1);
                                                }
                                                double sid_286 = v_B_T[(si_283) * 1024 + (si_285)];
                                                double bin_287 = sid_282 * sid_286;
                                                double bin_288 = v_acc1 + bin_287;
                                                v_acc1 = bin_288;
                                                int64_t si_289 = v_r;
                                                if (VYNE_UNLIKELY(si_289 < 0 || si_289 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 144\n", (long long)si_289);
                                                    exit(1);
                                                }
                                                int64_t bin_290 = v_k0 + 2;
                                                int64_t si_291 = bin_290;
                                                if (VYNE_UNLIKELY(si_291 < 0 || si_291 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_291);
                                                    exit(1);
                                                }
                                                double sid_292 = v_A[(si_289) * 1024 + (si_291)];
                                                int64_t si_293 = v_c;
                                                if (VYNE_UNLIKELY(si_293 < 0 || si_293 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 144\n", (long long)si_293);
                                                    exit(1);
                                                }
                                                int64_t bin_294 = v_k0 + 2;
                                                int64_t si_295 = bin_294;
                                                if (VYNE_UNLIKELY(si_295 < 0 || si_295 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_295);
                                                    exit(1);
                                                }
                                                double sid_296 = v_B_T[(si_293) * 1024 + (si_295)];
                                                double bin_297 = sid_292 * sid_296;
                                                double bin_298 = v_acc2 + bin_297;
                                                v_acc2 = bin_298;
                                                int64_t si_299 = v_r;
                                                if (VYNE_UNLIKELY(si_299 < 0 || si_299 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 145\n", (long long)si_299);
                                                    exit(1);
                                                }
                                                int64_t bin_300 = v_k0 + 3;
                                                int64_t si_301 = bin_300;
                                                if (VYNE_UNLIKELY(si_301 < 0 || si_301 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_301);
                                                    exit(1);
                                                }
                                                double sid_302 = v_A[(si_299) * 1024 + (si_301)];
                                                int64_t si_303 = v_c;
                                                if (VYNE_UNLIKELY(si_303 < 0 || si_303 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 0 of shape [1024, 1024] got %lld at line 145\n", (long long)si_303);
                                                    exit(1);
                                                }
                                                int64_t bin_304 = v_k0 + 3;
                                                int64_t si_305 = bin_304;
                                                if (VYNE_UNLIKELY(si_305 < 0 || si_305 >= 1024)) {
                                                    fprintf(stderr, "Runtime error (VNE-072): scratch index out of bounds: dim 1 of shape [1024, 1024] got %lld at line 0\n", (long long)si_305);
                                                    exit(1);
                                                }
                                                double sid_306 = v_B_T[(si_303) * 1024 + (si_305)];
                                                double bin_307 = sid_302 * sid_306;
                                                double bin_308 = v_acc3 + bin_307;
                                                v_acc3 = bin_308;
                                            }
                                        }
                                        int64_t bin_309 = v_r * v_N;
                                        int64_t bin_310 = bin_309 + v_c;
                                        double bin_311 = v_acc0 + v_acc1;
                                        double bin_312 = v_acc2 + v_acc3;
                                        double bin_313 = bin_311 + bin_312;
                                        vyne_index_set(v_C, vyne_int(bin_310), vyne_float(bin_313));
                                    }
                                }
                            }
                        }
                        VyneValue bin_314 = vyne_bool(v_iter == v_ITERS);
                        if (vyne_is_truthy(bin_314)) {
                            {
                                VyneValue idx_316 = vyne_index_get(v_C, vyne_int(0));
                                VyneValue str_315 = vyne_to_string(idx_316);
                                VyneValue bin_317 = vyne_binop(vyne_string_static("checksum: "), str_315, 29);
                                vyne_out(bin_317);
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
