# Conditioning

## Time-Based Conditions

- Appears at X seconds after scene open.
- Disappears at Y seconds after scene open.
- Appears or disappears at a video bookmark.
- Ends at media completion.

## Tag-Based Conditions

- Appears after tag X is completed.
- Disappears after tag Y is completed.
- Appears after all required tags are completed.
- Appears after N of M required tags are completed.

## Exercise Logic

- Quiz: instruction appears first, QCM appears after instruction, feedback follows answer.
- Risk hunt: markers appear after instruction; final feedback/door requires all targets or N targets.
- Roleplay: microphone result triggers consequence tags or branches; include else/no-text handling.
- Timer: timer end can hide tags, trigger feedback, or move to next branch.

## Tag Table Fields

Always express conditioning as plain production instructions:

- Appearance condition.
- Disappearance condition.
- Required prior tags.
- All-required or N-required logic.
- Else/failure branch.
- Success criterion.
