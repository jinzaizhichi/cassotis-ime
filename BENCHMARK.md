# Cassotis Corpus Benchmarks

Cassotis publishes six fixed corpus benchmarks for tracking decoding quality and engine performance across releases: the Long Sentence Benchmark-16300, the Short-word Context Benchmark-65000, the One-key Completion Context Benchmark-12831, the Medium-input One-key Completion Benchmark-10840, the Long-sentence One-key Completion Benchmark-16300, and the Document-copy Completion Replay Benchmark-386. They turn release quality into reproducible measurements instead of relying only on hand-picked examples.

## Shared Corpus Source

All six benchmarks are derived from the developer's own novel, [**Elegance in Timelessness**](https://www.qidian.com/book/1037259117/) (Chinese title: [**永恒的舞动**](https://www.qidian.com/book/1037259117/)).

Benchmark-16300 fixes 16,300 eligible sentences, while Benchmark-65000 fixes 65,000 short-word occurrences. The short-word completion benchmark derives 12,831 incremental completion opportunities from the same short-word cases. The medium-input and long-sentence completion benchmarks reuse the long-sentence corpus to derive 10,840 mid-composition opportunities and 16,300 near-tail opportunities respectively. The document-copy replay benchmark fixes 386 chronological opportunities whose target continuation has already appeared earlier in the same document. Benchmark cases are kept separate from the corresponding model-training data.

## Shared Accuracy Equivalence Rule

The following rule applies to visible-candidate accuracy metrics in the long-sentence and short-word context suites, including `Top1`, `Top2`, other reported `TopN` values, and the short-word `Contested` metrics:

- `他` and `她` are treated as equivalent only when they occur at the same character positions, because the benchmark Pinyin query cannot distinguish them.
- `它`, all other homophones, missing or additional characters, and every other textual difference remain distinct.
- The rule changes only offline pass/fail scoring. It does not rewrite candidate text or alter candidate generation, ranking, latency, or user-dictionary behavior.
- Raw-pool and Oracle recall scoring retains strict character equality so that the target label cannot influence search behavior. It is therefore not directly comparable with equivalence-aware visible `TopN` metrics.

This equivalence rule applies to benchmark results starting with `v1.11.0`. Results for `v1.10.0` and earlier releases used strict character equality and should be rescored before direct comparison with `v1.11.0` or later results.

## Long Sentence Benchmark-16300

### Corpus Scale and Case Construction

Benchmark-16300 contains 16,300 eligible sentences extracted from the novel in a fixed order. Its cases are constructed as follows:

- Split the novel text by punctuation and line breaks.
- Ignore sentences containing English letters.
- Ignore sentences shorter than the configured minimum CJK length.
- Convert each complete sentence to Pinyin with the benchmark reverse-Pinyin builder.
- Feed the complete Pinyin query to the engine and dictionary version under test.

### Accuracy Scoring

- A case is a `Top1` pass when the first complete candidate matches the original sentence under the shared scoring rule above.
- A case is a `Top2` pass when either of the first two complete candidates matches the original sentence under the shared scoring rule above.

### Accuracy and Latency Modes

- Accuracy runs use deterministic-work mode: normal search paths do not stop on wall-clock time and remain bounded by fixed beam, state, edge, candidate, and work limits. Changes in machine load therefore do not change normal candidate generation.
- Latency runs use production mode: fixed work limits are the primary boundary, with wider emergency wall-clock ceilings retained to prevent unacceptable stalls on malformed long Pinyin or slower machines.
- Both modes load the same deployed long-sentence Transformer reranker as the Host. A missing or incomplete runtime is an error rather than a silent fallback; disabling it is reserved for explicitly labelled diagnostic runs.
- The two measurements are run separately. The eight-slice runner accelerates accuracy evaluation and is not used for latency measurement.

### Latency Protocol

Long-sentence latency values measure engine-only full-query decoding:

- Process the fixed 16,300 cases serially in one runner process and in corpus order.
- Use a snapshot of the simplified base dictionary selected for the tested release and disable the user dictionary by default.
- Reset the engine composition state before each case while retaining the same dictionary connection and runtime caches for the complete run.
- Assign the complete Pinyin query in one operation, then generate and read the candidate list.
- Measure from immediately before query assignment until candidate retrieval finishes.
- Exclude process startup, dictionary opening, reverse-Pinyin conversion, report writing, TSF integration, candidate-window rendering, real keystrokes, and inter-key timing.

## Short-word Context Benchmark-65000

### Corpus Scale and Case Construction

Benchmark-65000 measures word-by-word input with preceding text and uses the same novel text as the long-sentence benchmark as its source:

- Deterministically segment each sentence and normalize the result into two- to four-character units that represent ordinary short-word input habits.
- Admit only manually reviewed lexical units and exclude novel-specific proper nouns, so the benchmark measures general input behavior rather than memorization of story-specific names.
- Treat each eligible occurrence as one case and preserve the sentence prefix that a user would already have committed before typing that unit.
- Convert the target unit to Pinyin independently, with reviewed overrides for ambiguous readings.
- Keep cases in source-text order and freeze the first 65,000 eligible occurrences as Benchmark-65000.
- Evaluate with a snapshot of the selected simplified dictionary; user-dictionary ranking is disabled by default.

The frozen set contains 55,712 cases with usable left context and 9,288 sentence-initial cases without left context.

### Accuracy and Contested Scoring

- A case is a `Top1` pass when the first exact candidate matches the target unit under the shared scoring rule above.
- A case is a `Top2` pass when either of the first two exact candidates matches the target unit under the shared scoring rule above.
- `Contested` is the 11,728-case subset in which the same Pinyin query maps to at least two target words in the corpus. `Contested Top1` and `Contested Top2` isolate the cases where left context is most useful for disambiguation.
- Short-word results use the context-enabled benchmark.

### Latency Protocol

Short-word latency values measure engine-only candidate retrieval for the context-enabled track:

- Process all 65,000 cases serially in one runner process and in fixed corpus order.
- Reset the engine before each query while retaining the same dictionary connection and runtime caches.
- Install the already committed sentence prefix before timing, assign the complete target Pinyin query, and stop timing after candidate retrieval.
- Exclude corpus segmentation, Pinyin generation, process startup, dictionary opening, report writing, TSF integration, candidate-window rendering, real keystrokes, and inter-key timing.

## One-key Completion Context Benchmark-12831

### Case Construction and Scoring

The completion benchmark reuses the frozen Benchmark-65000 cases and their left context to measure one-key continuation before the target word has been fully typed:

- Evaluate only targets containing at least three complete Pinyin syllables.
- Starting after two syllables, advance one syllable at a time and stop before the complete Pinyin. Each intermediate state is one completion opportunity.
- For example, the target `往常一样` is queried at both `wangchang` and `wangchangyi`.
- The complete 65,000-source corpus deterministically produces 12,831 opportunities, hence the name One-key Completion Context Benchmark-12831.
- Use the simplified base-dictionary snapshot for the tested release, disable the user dictionary, and enable left context.
- Read only the single completion that the UI would display. It is a hit only when it strictly equals the corpus target; the `他`/`她` equivalence rule is not applied.

The benchmark records four metrics that are straightforward to interpret across releases:

- `Completion Hit`: correct completions divided by all 12,831 opportunities; this is the primary quality metric.
- `Avg Keys Saved`: average net keystrokes saved by each correct completion, after charging one keystroke for accepting it.
- `Stability`: when the previous completion remains compatible after another syllable is typed, the proportion for which the displayed completion remains unchanged.
- `P95`: 95% of completion queries finish within this many milliseconds.

Because each corpus position has only one reference target, a different but linguistically valid completion is still scored as a miss.

### Latency Protocol

Latency covers dictionary lookup, context/language-model scoring, completion selection, and hysteresis only. It excludes process and dictionary cold start, TSF/host communication, candidate-window rendering, real inter-key timing, and learning writes after acceptance. The engine is reset before each source case; adjacent prefixes of the same target are processed consecutively, while the dictionary connection and runtime caches remain open for the complete run.

## Medium-input One-key Completion Benchmark-10840

### Case Construction and Scoring

This benchmark covers the gap between short-word completion and near-tail long-sentence completion. It reuses the fixed 16,300 long sentences and their complete Pinyin queries:

- Leave the final two complete Pinyin syllables untyped and evaluate only states containing 5 to 12 complete typed syllables.
- Eligible sentences deterministically produce 10,840 completion opportunities.
- Use the same static completion layers and constrained local-continuation model as the Host, but read only the single settled completion that the UI would display.
- Count a hit when the prompt strictly extends the intended typed prefix and the displayed text remains a prefix of the reference sentence.
- Use deterministic benchmark mode, a snapshot of the simplified base dictionary, and an empty user dictionary. Benchmark cases remain isolated from model-training data.

The public report records five metrics:

- `Completion Hit`: correct local continuations divided by all 10,840 opportunities.
- `Prompt Precision`: correct local continuations divided by opportunities where a prompt was displayed.
- `Avg Keys Saved`: average net keys saved by each correct hit after charging one key for acceptance.
- `Stability`: when the previous prompt remains compatible after further typing, the proportion for which the displayed completion remains unchanged.
- `P95`: 95% of visible completion queries finish within this many milliseconds.

The corpus provides only one reference continuation, so another natural continuation with different wording is still scored as a miss. Detailed diagnostics additionally retain the Top-32 candidates and Oracle ranks from lexical, transition, suffix-index, and local-model sources to separate recall errors from ranking errors.

### Latency Protocol

The dictionary and models are loaded and warmed before scored cases begin. Latency includes medium-length Pinyin decoding, completion-source lookup, unified selection, and local-model refinement when that result is actually applied. It excludes process and model cold start, report output, TSF/Host IPC, candidate-window rendering, real inter-key timing, and learning writes. Diagnostic candidate-pool construction runs after the visible-latency sample and is not included.

## Long-sentence One-key Completion Benchmark-16300

### Case Construction and Scoring

This benchmark measures whether one-key completion can extend a partially decoded long sentence, instead of inferring completion quality from the unrelated long-sentence candidate-ranking score:

- Reuse all 16,300 fixed long-sentence cases and their reviewed full Pinyin queries.
- Leave the final four complete Pinyin syllables untyped while retaining at least the first four syllables as the visible composition prefix.
- Decode that prefix in deterministic-work mode with the same long-sentence Transformer reranker used by the Host.
- Run the same constrained local-completion model when the static layer requests asynchronous refinement, apply the same confidence, timeout, and exact-path validation, then read only the single settled completion that the UI would display.
- Count a local-continuation hit when the displayed result strictly extends the intended typed prefix and the whole displayed text remains a prefix of the reference sentence. The completion may stop after the next one to three local words; it does not have to reproduce the rest of the sentence in one step.
- Disable the user dictionary and external document context, and use a snapshot of the simplified base dictionary selected for the tested release.
- Query the immediately preceding syllable boundary before the scored query to measure whether a compatible completion remains stable as typing continues.

The public report uses four metrics suited to direct cross-version comparison under the current protocol:

- `Local Completion Hit`: correct local continuations divided by all 16,300 opportunities.
- `Prompt Coverage`: opportunities where any completion was displayed, divided by all opportunities.
- `Total Keys Saved`: net keys saved across all correct local-continuation hits after charging one key for each acceptance.
- `P95`: 95% of visible completion queries finish within this many milliseconds.

The detailed report additionally retains average keys saved per hit, incremental stability, wrong-prompt counts, strict whole-sentence hits, and internal-pool Oracle ranks for attribution. Incremental stability is not published as a primary comparison because its eligible denominator depends on the prompts produced by each version and can be very small. Because the corpus supplies one reference, a plausible continuation with different wording still counts as a miss.

### Latency Protocol

The dictionary and both runtime models are loaded and warmed before scored cases begin. Latency starts immediately before assigning the scored Pinyin prefix and includes long-sentence decoding, exact/transition lookup, language-model scoring, hysteresis, and accepted local-model refinement. Model work that abstains or times out is asynchronous and does not delay the visible static result, so it is not added to visible latency. The measurement excludes process and model cold start, the preceding stability probe, report output, TSF-to-Host IPC, rendering, real inter-key timing, and learning writes. The engine is reset before every source sentence while dictionary connections, model sessions, and runtime caches remain open for the complete run.

## Document-copy Completion Replay Benchmark-386

### Case Construction and Scoring

This benchmark measures document-local copy completion without leaking future text:

- Replay the fixed novel corpus in its original order. Each case may read only the text that appeared before the tested sentence.
- Retain at most the preceding 1,024 characters as the document snapshot, matching the production snapshot limit.
- Select 386 fixed opportunities where the same local anchor and continuation have already occurred in the available history.
- Require the reference continuation to consist of one to three exact base-dictionary words. User words and text that appears only later in the document cannot create a case or a prompt.
- Feed the historical snapshot, document identity, current Pinyin prefix, and ordinary engine candidates through the same document-copy selection path used by the Host.
- Disable the asynchronous local-completion runtime for this dedicated layer benchmark. Existing static completion remains the fallback when document-copy evidence abstains.

The public report records four metrics:

- `Document-copy Hit`: strict reference-matching document-copy prompts divided by all 386 opportunities.
- `Prompt Precision`: strict reference-matching prompts divided by every prompt actually displayed, including fallback prompts.
- `Total Keys Saved`: net keys saved by all strict hits after charging one key for acceptance.
- `P95`: 95% of replay queries finish within this many milliseconds.

The corpus supplies one reference continuation. A different but natural continuation is therefore counted as a miss. This strict rule keeps cross-version comparisons deterministic, while the detailed TSV retains prompt source, anchor, exact suffix path, score, and occurrence count for manual attribution.

### Latency Protocol

Latency includes ordinary candidate generation, document-suffix lookup, exact-path validation, scoring, and synchronous static fallback. It excludes case preparation, process and dictionary cold start, TSF-to-Host IPC, candidate-window rendering, real inter-key timing, asynchronous neural fallback, and feedback writes. Every opportunity starts from its frozen historical snapshot, so no preceding benchmark decision can alter a later case.

## Latency Statistics

Latency columns are reported in milliseconds:

- `Mean`: arithmetic mean of all per-query decode times.
- `P50`: nearest-rank median; 50% of measured queries complete at or below this value.
- `P95`: nearest-rank 95th percentile; 95% of measured queries complete at or below this value.
- `Max`: largest per-query decode time in the run.

These values quantify complete-query engine performance and long-tail cost. They are not incremental keystroke-to-display latency and must not be presented as end-to-end typing latency. Comparisons are meaningful only when the machine, operating system, power profile, release build settings, corpus order, and dictionary snapshot are controlled.

## Result Publication

Version-specific results are published in `README.md`. The short-word completion benchmark begins with `v1.15.0`. Long-sentence completion results through `v1.17.0` used the legacy whole-sentence exact criterion; the local-continuation criterion starts with the next formally evaluated release and is not backfilled. This document defines their shared source, case construction, accuracy scoring, and latency protocols.

## Notes

The benchmarks are expected to evolve with the IME. Future benchmark variants may use larger or differently distributed corpora, but their names should include the case count or another clear suffix. Every published result should record the engine and dictionary versions, runner behavior, latency mode, and scoring method so comparisons remain interpretable.
