# tools · 인덱스

> 요약: 스킬이 Drive에서 직접 실행하는 도구와 PDF 캐시 사용법. **파일은 `[Drive]/tools/`, `[Drive]/_pdf_cache/`에 있고 옮기지 않는다**(pdf-drive-analyzer가 이 경로를 쓴다). | 갱신: 2026-11-20

| 파일 | 쓰는 곳 | 내용 |
| --- | --- | --- |
| `[Drive]/tools/pdf_ingest.py` | pdf-drive-analyzer | PDF → `_pdf_cache/<sha16>/` (full.md, pages/, index.md, meta.json) 변환. 의존성 `pymupdf` |

## _pdf_cache 읽는 법

1. `[Drive]/_pdf_cache/catalog.tsv`에서 원본 이름으로 `sha16` 폴더를 찾는다.
2. 그 폴더의 `notes.md`(핵심 쪽 지도) → `index.md`(목차) 순으로 본다.
3. 필요한 `pages/pNNN.md`만 연다. `full.md`는 검색(grep)용으로만 쓴다.
