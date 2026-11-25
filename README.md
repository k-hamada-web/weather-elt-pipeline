# 都市別 気温・寒暖差 ELT・可視化パイプライン

Open-Meteo API から複数都市（Sendai / Tokyo / Osaka）の気象データを取得・加工し、
**BigQuery** への格納、**SQL** による集計マート作成、**Looker Studio** での可視化までを一気通貫で実装したパイプラインです。

## ダッシュボード・成果物
- Looker Studio レポート: [レポートURLを貼る]
- 対象都市: Sendai / Tokyo / Osaka（過去14日分の日次最高・最低気温、寒暖差を算出）

## システム構成

```text
[Open-Meteo API]
       │  Python (requests / pandas) で取得・整形・複数都市結合
       ▼
[Google Colab] (`weather_pipeline.ipynb`)
       │  pandas-gbq で BigQuery へロード
       ▼
[BigQuery]
  ├── weather_demo.daily_temp_cities   # 結合・整形済みの日次データ
  ├── weather_demo.mart_city_summary   # 都市別集計マート (sql/mart_city_summary.sql)
  └── weather_demo.mart_diff_summary   # 寒暖差区分マート (sql/mart_diff_summary.sql)
       │
       ▼
[Looker Studio] ──▶ 都市別・区分別の比較ダッシュボード
```

## 使用技術
- **言語・ライブラリ**: Python (`requests`, `pandas`, `pandas-gbq`, `matplotlib`)
- **DWH / SQL**: Google BigQuery (`WITH` CTE, `CASE WHEN`, `GROUP BY`, `CREATE OR REPLACE TABLE`)
- **BI / 可視化**: Looker Studio
- **実行環境**: Google Colab

## 工夫した点
1. **生データと集計マートの分離**: `daily_temp_cities` を保持したまま、SQLの `CREATE OR REPLACE TABLE` でマートテーブルを生成する構成にし、集計ロジック変更時も安全に再生成できるようにしました。
2. **都市追加しやすい構造**: 都市の緯度・経度リストをループ処理して `pd.concat` で統合する形にし、対象都市を増やしやすい設計にしました。
3. **欠損・型・通信エラーの基本対策**: APIレスポンスのステータス確認や欠損行の除外、日付型の整形を組み込みました。

## 今後の改善案
- スケジューラやワークフローツールを用いた日次バッチの自動化
- 増分更新（差分ロード）やデータ品質チェックの追加
