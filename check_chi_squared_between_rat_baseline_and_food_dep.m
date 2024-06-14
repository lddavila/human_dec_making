table_1_normal = readtable("C:\Users\ldd77\OneDrive\Desktop\human_dec_making\cluster_tables_for_rat_created_04_16_2024\rat_reward_choice.xlsx");
table_2_food_dep = readtable("C:\Users\ldd77\OneDrive\Desktop\human_dec_making\cluster_tables_for_rat_food_deprivation_created_04_28_2024\food_deprivation_rat_reward_choice.xlsx");

cluster_count_normal=get_cluster_counts(table_1_normal,unique(table_1_normal.cluster_number));
cluster_count_food_dep = get_cluster_counts(table_2_food_dep,unique(table_1_normal.cluster_number));

[p,q] = chi2test([cluster_count_normal;cluster_count_food_dep]);
disp(p)
disp(q)
disp(cluster_count_normal)
disp(cluster_count_food_dep)
