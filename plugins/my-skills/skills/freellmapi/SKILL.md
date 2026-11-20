---
name: "freellmapi"
description: "FreeLLMAPI(무료 LLM 통합 API) 설치·실행·업데이트, 프로바이더 키 추가/동기화를 어느 PC에서든 할 때 사용. '프리LLM 설치', 'freellmapi 켜줘', '키 추가', '키 동기화' 등."
---

# FreeLLMAPI 멀티 PC 운영

FreeLLMAPI(github.com/tashfeenahmed/freellmapi)를 PC마다 Docker로 실행하고, 설정은 Google Drive 한 곳에서 관리한다.

## 진실의 원천 (Google Drive)
- 폴더 `FreeLLMAPI-Sync`
  - `freellmapi-sync.json` — 비밀값 포함. 구조:
    `{version, port, encryptionKey(hex64), unifiedApiKey("freellmapi-..."), config:{admin:{email,password}, keys:[{platform,key,label?,enabled?}], routing:{strategy}, ...}}`
    `config`는 FreeLLMAPI 선언적 설정(FREEAPI_CONFIG_PATH) 스키마 그대로다 (customProviders, models, fallback 도 가능).
  - `freellmapi-kit.zip` — docker-compose.yml, start.cmd/start.ps1(Windows), start.sh(mac/linux), stop.cmd, export-keys.cmd/.sh, export-keys.js, set-unified-key.js, README.txt
- 파일은 `search_files`로 `title = 'freellmapi-sync.json'` / `title = 'freellmapi-kit.zip'` 검색해서 찾는다 (ID 하드코딩 금지).
- Drive 커넥터는 파일 내용 덮어쓰기가 안 되므로, sync.json을 바꿀 땐 같은 폴더에 새로 `create_file`(contentMimeType application/json, disableConversionToGoogleType true) 후 옛 파일을 `trash_file`.
- 비밀값(키, 비번)은 사용자 본인에게만 보여주고, 외부로 보내지 않는다.

## A. 이 PC에 설치 / 업데이트 / 설정 반영
1. 두 파일을 `download_file_content`로 받아 base64 디코드 → 작업공간 `/home/claude/fl/`에 저장.
2. 키트 생성:
```bash
mkdir -p /tmp/out/freellmapi && cd /tmp/out/freellmapi && unzip -oq /home/claude/fl/freellmapi-kit.zip
python3 - /home/claude/fl/freellmapi-sync.json . <<'EOF'
import json,sys,os
s=json.load(open(sys.argv[1])); o=sys.argv[2]
open(os.path.join(o,'.env'),'w',newline='\n').write(f"ENCRYPTION_KEY={s['encryptionKey']}\nUNIFIED_KEY={s['unifiedApiKey']}\nPORT={s.get('port',3001)}\n")
json.dump(s['config'],open(os.path.join(o,'freellmapi.config.json'),'w'),indent=2)
EOF
```
3. 전달:
   - PC 폴더가 연결돼 있으면(get_device_info.connectedFolders) device_bash로 `<연결폴더>/freellmapi/`에 파일들을 쓴다 (기존 폴더면 덮어쓰기 — 데이터는 Docker 볼륨에 있어 안전).
   - 아니면 `cd /tmp/out && zip -qr /mnt/user-data/outputs/freellmapi-ready.zip freellmapi` 후 SendUserFile.
4. 사용자 안내 (짧게): Docker Desktop 필요(없으면 start.cmd가 설치 페이지를 연다) → 압축 풀고 `start.cmd` 더블클릭(mac/linux는 `./start.sh`). 이미 설치된 PC는 새 폴더로 덮어쓴 뒤 start.cmd를 다시 실행하면 최신 이미지+새 설정이 반영된다.
5. 접속 정보: 대시보드 http://localhost:{port} (로그인 = config.admin), Base URL `http://localhost:{port}/v1`, API Key = unifiedApiKey. 모든 PC가 같은 API 키를 쓴다 (start 스크립트가 컨테이너 DB에 고정).

## B. 프로바이더 키 추가 / 수정
1. sync.json을 받아 `config.keys`에 추가/교체 (platform+label 이 같으면 교체). platform 값은 FreeLLMAPI 대시보드 Keys 페이지의 이름 소문자(예: groq, google, cerebras, openrouter, mistral 등). 확실치 않으면 repo의 server/src/providers 를 확인.
2. 새 sync.json 업로드 → 옛 파일 휴지통.
3. A 절차로 이 PC 키트를 다시 만들어 전달. 다른 PC는 그 PC에서 "프리LLM 업데이트" 하면 된다고 안내.

## C. 대시보드에서 직접 추가한 키를 Drive로 동기화
1. 해당 PC에서 `export-keys.cmd`(mac/linux: `./export-keys.sh`) 실행 → `keys-export.json` 생성 (`{keys:[...]}`, 평문).
2. 그 파일을 연결 폴더에서 읽거나 사용자가 첨부하게 한다.
3. sync.json의 `config.keys`에 병합(platform+label 기준 중복 제거) → B-2, B-3.

## D. 처음부터 새로 만들기 (Drive에 파일이 없을 때)
- encryptionKey=`secrets.token_hex(32)`, unifiedApiKey=`"freellmapi-"+secrets.token_hex(24)`, admin={사용자 이메일, 랜덤 비번}, keys=[], routing balanced 로 sync.json 생성.
- 키트는 repo를 clone해서 이 스킬의 구조대로 다시 만든다(compose는 ghcr.io/tashfeenahmed/freellmapi:latest, 127.0.0.1 바인딩, `./freellmapi.config.json:/config/freellmapi.config.json:ro`, FREEAPI_CONFIG_PATH=/config/freellmapi.config.json; set-unified-key.js는 컨테이너 안에서 better-sqlite3로 `UPDATE settings SET value=? WHERE key='unified_api_key'`).

## 주의
- 서버는 localhost에만 바인딩한다 (FreeLLMAPI는 단일 사용자용, 인터넷 노출 금지).
- 작업공간에서는 ghcr.io가 막혀 있어 Docker 이미지 테스트가 안 된다. 실제 실행은 사용자 PC에서.
- device_bash는 사용자 PC의 Linux VM이라 Windows Docker를 직접 켤 수 없다 → start.cmd 실행은 사용자에게 맡기거나 computer use로.