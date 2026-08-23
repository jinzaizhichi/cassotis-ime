# Third-Party Notices

This file lists third-party software/data used by Cassotis IME and the related license terms.

## 1) SQLite

- Component: SQLite runtime library (`sqlite3.dll`)
- Used for: dictionary storage and query
- Source:
  - https://www.sqlite.org/download.html
  - local artifacts: `third_party/sqlite/`
- License: Public Domain
- Notes:
  - SQLite is in the public domain.
  - Reference: https://www.sqlite.org/copyright.html

## 2) Unicode Unihan Data (UCD)

- Component: Unicode Unihan data files
- Used for: generating base single-character Chinese dictionary data
- Source:
  - https://www.unicode.org/Public/UCD/latest/ucd/Unihan.zip
- License/terms:
  - Unicode Terms of Use: https://www.unicode.org/terms_of_use.html
- Compliance notes:
  - Keep Unicode copyright/trademark/license notices when redistributing original Unicode data files.
  - Keep attribution for derived dictionary artifacts generated from Unicode data.

## 3) ONNX Runtime

- Component: Microsoft ONNX Runtime 1.20.1 (`onnxruntime.dll`)
- Used for: CPU inference for the optional host-side pinyin Transformer reranker
- Source: https://github.com/microsoft/onnxruntime/tree/v1.20.1
- Local artifacts: `third_party/onnxruntime/`
- License: MIT
- Compliance notes:
  - Redistributions retain `third_party/onnxruntime/LICENSE` and
    `third_party/onnxruntime/ThirdPartyNotices.txt`.
  - The model is loaded only by `cassotis_ime_host.exe`; it is not linked into
    the TSF DLL.

## 4) Cassotis Pinyin Transformer Model

- Component: quantized pinyin-aligned candidate reranker
- Used for: confidence-gated reranking of existing long-sentence candidates
- Local artifact: `data/models/pinyin_transformer/`
- Notes:
  - The model was trained and distilled by this project from separately
    licensed corpora; it does not contain or redistribute training documents.
  - Its runtime input and output remain local to the IME host process.

## 5) Proprietary Build Toolchain (Not Redistributed)

- Embarcadero Delphi 10.4 is required to build this project.
- Delphi itself is not bundled in this repository and is licensed separately by Embarcadero.

## GPL-3.0 Notice

This project is licensed under GPL-3.0. The redistributed third-party items listed above are generally GPL-compatible:
- SQLite (public domain)
- Unicode data used under Unicode terms with required notices
- ONNX Runtime (MIT)

This file is engineering documentation and not legal advice.
