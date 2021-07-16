# 全項目の組み合わせパターン毎の相関係数を算出
# data: 対象データ(数値項目以外が含まれる場合は自動的に除外される)
# ordered_cols: 項目の並び順を指定(未指定の場合は data の並び順が適用される)
# as_data_frame: (デフォルト=F) True の場合は DataFrame が返される
# f.corr: 相関係数を算出する関数を指定(デフォルトは Pearson の積率相関係数)
draw_corr_matrix <- function(data, ordered_cols = NULL, as_data_frame = F, f.corr = stats::cor) {

  # 数値項目のみに制限
  df.numerics <- data %>%
    dplyr::select_if(is.numeric)

  # 項目の並び順を設定
  # 引数で ordered_cols が指定されていない場合は DataFrame から取得される自然な並び順を指定
  if(is.null(ordered_cols)) {
    ordered_cols <- colnames(df.numerics)
  }

  # 全変数ごとの相関係数を算出
  df.corr_matrix <- df.numerics %>%

    # 相関行列の生成
    f.corr() %>%

    # 相関行列(mtrix)を DataFrame に変換
    tibble::as_tibble(rownames = "val1") %>%

    # => long-form
    tidyr::pivot_longer(cols = -val1, names_to = "val2", values_to = "corr") %>%

    # 変数の並び順を指定
    dplyr::mutate(
      val1 = factor(val1, levels = ordered_cols),
      val2 = factor(val2, levels = ordered_cols)
    )

  if(as_data_frame) {
    df.corr_matrix
  } else {
    df.corr_matrix %>%

      # 重複を排除
      dplyr::filter(
        as.integer(val1) <= as.integer(val2)
      ) %>%

      # 可視化
      ggplot(aes(val1, val2)) +
        geom_tile(aes(fill = corr), colour = "black") +
        geom_text(aes(label = formattable::comma(corr)), alpha = 2/3) +
        scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0, breaks = seq(-1, 1, 0.5)) +
        labs(
          fill = "Cor",
          x = NULL,
          y = NULL
        ) +
        coord_cartesian(expand = F) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
  }
}
