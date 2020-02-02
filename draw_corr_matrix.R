# 全項目の組み合わせパターン毎の相関係数を算出
# df.data: 対象データ(数値項目以外が含まれる場合は自動的に除外される)
# ordered_cols: 項目の並び順を指定(未指定の場合は df.data の並び順が適用される)
# as.data.frame: (デフォルト=F) True の場合は DataFrame が返される
# f.corr: 相関係数を算出する関数を指定(デフォルトは Pearson の積率相関係数)
draw_corr_matrix <- function(df.data, ordered_cols = NULL, as.data.frame = F, f.corr = stats::cor) {
  library(tidyverse)

  # 数値項目のみに制限
  df.numerics <- df.data %>%
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
    tibble::as_tibble(rownames = NA) %>%
    tibble::rownames_to_column(var = "val1") %>%

    # => wide-form
    tidyr::gather(key = "val2", value = "corr", -val1) %>%

    # 変数の並び順を指定
    dplyr::mutate(
      val1 = forcats::fct_relevel(val1, ordered_cols),
      val2 = forcats::fct_relevel(val2, ordered_cols)
    )

  if(as.data.frame) {
    df.corr_matrix
  } else {
    df.corr_matrix %>%

      # 可視化
      ggplot(aes(val1, val2)) +
        geom_tile(aes(fill = corr), colour = "black") +
        scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0, breaks = seq(-1, 1, 0.5)) +
        labs(
          x = NULL,
          y = NULL
        ) +
        theme(axis.text.x = element_text(angle = -90, hjust = 1))
  }
}
