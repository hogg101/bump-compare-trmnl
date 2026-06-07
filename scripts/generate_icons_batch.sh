#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_GEN="${IMAGE_GEN:-/Users/james/Github/agent-skills/imagegen/scripts/image_gen.py}"
TMP_DIR="$ROOT/tmp/imagegen"
PROMPTS="$TMP_DIR/bump-icons.jsonl"
OUT_DIR="${OUT_DIR:-$ROOT/output/imagegen/bump-icons}"
CONCURRENCY="${CONCURRENCY:-5}"
DRY_RUN="${DRY_RUN:-0}"

if [[ ! -f "$IMAGE_GEN" ]]; then
  echo "Cannot find image generation CLI at $IMAGE_GEN" >&2
  echo "Set IMAGE_GEN=/path/to/scripts/image_gen.py and retry." >&2
  exit 1
fi

if [[ "$DRY_RUN" != "1" && -z "${OPENAI_API_KEY:-}" ]]; then
  echo "OPENAI_API_KEY is not set. Set it locally or run DRY_RUN=1 $0 to preview requests." >&2
  exit 1
fi

mkdir -p "$TMP_DIR" "$OUT_DIR"

cleanup() {
  rm -f "$PROMPTS"
}
trap cleanup EXIT

cat > "$PROMPTS" <<'JSONL'
{"out":"microscope.png","prompt":"microscopic early pregnancy cell cluster, tiny circular speck under a simple microscope motif"}
{"out":"poppyseed.png","prompt":"single poppy seed"}
{"out":"sesameseed.png","prompt":"single sesame seed"}
{"out":"pea.png","prompt":"single pea"}
{"out":"blueberry.png","prompt":"single blueberry"}
{"out":"raspberry.png","prompt":"single raspberry"}
{"out":"grape.png","prompt":"single grape"}
{"out":"olive.png","prompt":"single olive"}
{"out":"fig.png","prompt":"single fig"}
{"out":"lime.png","prompt":"single lime"}
{"out":"lemon.png","prompt":"single lemon"}
{"out":"nectarine.png","prompt":"single nectarine"}
{"out":"apple.png","prompt":"single apple"}
{"out":"avocado.png","prompt":"single avocado"}
{"out":"pomegranate.png","prompt":"single pomegranate"}
{"out":"artichoke.png","prompt":"single artichoke"}
{"out":"mango.png","prompt":"single mango"}
{"out":"grapefruit.png","prompt":"single grapefruit"}
{"out":"swede.png","prompt":"single swede rutabaga"}
{"out":"papaya.png","prompt":"single papaya"}
{"out":"aubergine.png","prompt":"single aubergine eggplant"}
{"out":"courgette.png","prompt":"single courgette zucchini"}
{"out":"pointedcabbage.png","prompt":"single pointed cabbage"}
{"out":"roundlettuce.png","prompt":"single round lettuce"}
{"out":"redcabbage.png","prompt":"single red cabbage"}
{"out":"cauliflower.png","prompt":"single cauliflower"}
{"out":"savoycabbage.png","prompt":"single savoy cabbage"}
{"out":"butternutsquash.png","prompt":"single butternut squash"}
{"out":"coconut.png","prompt":"single coconut"}
{"out":"pineapple.png","prompt":"single pineapple"}
{"out":"cantaloupemelon.png","prompt":"single cantaloupe melon"}
{"out":"galiamelon.png","prompt":"single galia melon"}
{"out":"honeydewmelon.png","prompt":"single honeydew melon"}
{"out":"spaghettisquash.png","prompt":"single spaghetti squash"}
{"out":"crownprincesquash.png","prompt":"single crown prince squash"}
{"out":"marrow.png","prompt":"single marrow summer squash"}
{"out":"watermelon.png","prompt":"single watermelon"}
{"out":"pumpkin.png","prompt":"single pumpkin"}
JSONL

runner=(python3 "$IMAGE_GEN")
if command -v uv >/dev/null 2>&1; then
  runner=(uv run --with openai --with pillow python "$IMAGE_GEN")
fi

args=(
  generate-batch
  --input "$PROMPTS"
  --out-dir "$OUT_DIR"
  --concurrency "$CONCURRENCY"
  --size 1024x1024
  --quality high
  --background transparent
  --output-format png
  --use-case "stylized-concept"
  --style "lo-fi 1-bit fruit/veg icon that looks good on a low-resolution e-ink screen"
  --composition "single centered object, full silhouette visible, consistent scale across the set, isolated on transparent background"
  --palette "black and white only, no colour"
  --constraints "no text, no labels, no watermark, no border, no scene, no shadows outside the object; thick readable silhouette; modest detail suitable for 800x480 e-ink"
  --negative "photorealistic detail, colour, dense texture, decorative background, multiple objects, face, character"
)

if [[ "$DRY_RUN" == "1" ]]; then
  args+=(--dry-run)
fi

"${runner[@]}" "${args[@]}"
