# ReadBubble

A mobile-first app (Expo / React Native Web) that turns any text, document or URL into audio using TTS.

## Architecture

- **Framework**: Expo SDK 55, React Native, expo-router (file-based routing)
- **Language**: TypeScript
- **Navigation**: expo-router tabs + stack
- **State**: React Context (TTSContext, AuthContext, ThemeContext) + AsyncStorage
- **TTS**: expo-speech (web: SpeechSynthesis API)
- **Fonts**: @expo-google-fonts/inter (Inter 400/500/600/700)
- **Auth**: Email + password, bcryptjs hashing, JWT sessions (30d)
- **Database**: PostgreSQL via `pg` driver when `DATABASE_URL` is set (production/Railway); falls back to JSON file for local dev without DB
- **API**: Shared via `server/db.js` module — Metro middleware (port 5000, web dev) + Express server (port 3001, native/production)

## Key Features

1. **Auth** — Email + password (register/login), guest mode, 30-day JWT sessions
2. **Onboarding** — 4-slide animated intro (shown once)
3. **Player** — paste text / upload PDF/DOCX/TXT / extract URL, real-time word highlighting, WPM badge, speed/font/paragraph controls, sleep timer
4. **History** — grouped by date, search, sort, per-item delete, cloud sync
5. **Settings** — language, speed, dark/light mode, cloud sync, change display name, logout
6. **Floating Bubble** — draggable overlay with play/pause/stop/speed controls

## Project Structure

```
app/
  _layout.tsx          # Root layout: ThemeProvider > AuthProvider > TTSProvider
  index.tsx            # Auth gate → login | onboarding | (tabs)
  login.tsx            # Email + password login/register screen
  onboarding.tsx       # 4-slide onboarding
  (tabs)/
    _layout.tsx        # Tab bar + FloatingBubble
    index.tsx          # Tab redirect
    player.tsx         # Main player/reader screen
    history.tsx        # Reading history
    settings.tsx       # Settings + account
contexts/
  AuthContext.tsx      # Auth state: register, login, logout, guest, sync
  TTSContext.tsx       # TTS state, history, settings
  ThemeContext.tsx     # Dark/light palette
lib/
  api.ts               # apiRequest() helper — relative URL on web, localhost:3001 on native
server/
  server.js            # Express API (port 3001) — native app + Railway production
  db.js                # Unified DB layer: PostgreSQL (DATABASE_URL set) or JSON file fallback
  data/users.json      # JSON user DB fallback (auto-created, local dev only)
metro.config.js        # Metro config + embedded API middleware (uses same server/db.js)
railway.json           # Railway build + deploy config
```

## Workflows (Replit)

- **Start application**: `EXPO_NO_DOTSLASH=1 REACT_NATIVE_DEVTOOLS_OPEN_AUTOMATICALLY=0 node_modules/.bin/expo start --web --port 5000 --localhost`
  - Runs on port 5000 (webview output); also serves API at `/api/*` via Metro middleware
  - Note: React Native DevTools installer may log a non-fatal error (missing native libs) — app still runs normally
- **API Server**: `node server/server.js` on port 3001 (console output)

## System Dependencies (Nix)

- `espeak-ng`: eSpeak NG TTS engine for server-side speech synthesis
- `glib`: Required by React Native DevTools binary (libglib-2.0.so.0)

## Auth Flow

- `POST /api/auth/register` → `{ email, password }` → `{ token, user }`
- `POST /api/auth/login` → `{ email, password }` → `{ token, user }`
- `POST /api/auth/change-password` → requires Bearer token
- `GET /api/user/data` → requires Bearer token → `{ user, history, settings }`
- `PUT /api/user/data` → sync history + settings to server
- `PATCH /api/user/profile` → update display name

## Color Palette (dark)

- bg: `#07050F`, card: `#0D0B1E`, cardInner: `#110E26`, border: `#1C1850`
- accent: `#22D3EE`, accentViolet: `#8B5CF6`, orange: `#FF8C42`, red: `#EF4444`
- textPrimary: `#FFFFFF`, textSecondary: `#C2BFE8`, textMuted: `#4A4898`, textDim: `#2D2A60`

## Color Palette (light)

- bg: `#F2F0FF`, card: `#FFFFFF`, accent: `#0891B2`, accentViolet: `#7C3AED`
- textPrimary: `#0D0B28`, textSecondary: `#2E2B5F`

## Patterns

- `const { colors } = useTheme(); const styles = makeStyles(colors);` — never hardcode colors
- `useNativeDriver: false` on ALL Animated (web incompatibility with color/layout props)
- Relative `/api/...` URLs on web; `http://localhost:3001` on native

## Format Support Architecture

Entry point: `lib/documentExtractor.web.ts::extractFromFile` → delegates to `lib/parsers/ExtractionPipeline.ts`

```
lib/parsers/
  types.ts              — ParseResult, FileFormat, MAX_FILE_SIZE
  loaders.ts            — CDN lazy-loading (JSZip, SheetJS, PDF.js, Mammoth)
  FormatDetector.ts     — extension + MIME → FileFormat
  TextParser.ts         — txt, md, rtf, fb2, ipynb (pure JS)
  CsvParser.ts          — csv, tsv (pure JS, auto-detects separator)
  SubtitleParser.ts     — srt, vtt, ass, sub (pure JS)
  StructuredParser.ts   — json, xml, html, mhtml (DOMParser)
  ZipParser.ts          — epub, odt, pptx, odp, zip (JSZip CDN)
  SpreadsheetParser.ts  — xlsx, xls, ods (SheetJS CDN)
  ImageOCRParser.ts     — jpg, png, webp, tiff (Tesseract.js v4 CDN)
  ExtractionPipeline.ts — dispatcher, fallback, security, size limit (50MB)
```

### Supported formats
**Fully supported:** PDF, DOCX, DOC, ODT, RTF, TXT, MD, EPUB, FB2, PPTX, ODP, XLSX, XLS, ODS, CSV, TSV, HTML, XML, JSON, MHTML, SRT, VTT, ASS, SUB, IPYNB, ZIP, JPG, PNG, WEBP, TIFF

**Not supported:** MOBI, AZW, RAR, 7Z, HEIC, PPT (old binary), MP3/WAV/M4A/OGG (audio transcription)

### Adding a new parser
1. Create `lib/parsers/YourParser.ts` → export `parseYour(file: File): Promise<ParseResult>`
2. Add to `FileFormat` union in `types.ts`
3. Add extension/MIME mapping in `FormatDetector.ts`
4. Add `case 'yourformat': return await parseYour(file);` in `ExtractionPipeline.ts`
5. Optionally add button in `FILE_TYPES` array in `app/(tabs)/index.tsx`
