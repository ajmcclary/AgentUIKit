# AgentUIKit

Scroll-follow policies for a streaming agent transcript: when to stay pinned to the live bottom,
when the user has scrolled away, and when to re-pin.

A chat-style agent transcript grows while the model streams. The view should follow new output
while the user is at the bottom, stop following as soon as they scroll back into history, and
resume once they return — without mistaking content relayout (a tool card expanding, a code block
re-highlighting) for a user gesture. AgentUIKit holds those decisions as pure functions over value
snapshots of scroll geometry and runtime flags. It takes no view model and no view; the host reads
its scroll view's geometry, builds the snapshots, and acts on the answers.

The scope is deliberately small today: transcript scroll policy only. It does not provide a
composer, session browser, tool-call cards, approval prompts, settings, onboarding, or any SwiftUI
or AppKit views. App chrome and navigation stay with the host.

## What's inside

- `AgentTranscriptScrollMetrics` — one geometry sample: distance to bottom, visible min-y, content
  height, viewport height.
- `AgentTranscriptViewportProgress` — baseline versus current geometry for one scroll session.
- `AgentTranscriptScrollRuntimeState` — the host's flags: pinned / detached, user interacting,
  interaction blocked, restore or programmatic scroll in flight, and which directions can scroll.
- `AgentTranscriptAutoFollowArmingState`, `DetachedManualScrollDirection` — small enums used by the
  policies (`towardHistory`, `towardLiveBottom`, `unknown`).
- `AgentTranscriptUserScrollIntentResolver` — turns geometry deltas or scroll velocity into a
  manual scroll direction, ignoring distance changes caused by relayout.
- `AgentTranscriptScrollProgressPolicy` — separates real manual movement from layout mutation and
  decides whether the viewport has escaped toward history.
- `AgentTranscriptAutoFollowRearmPolicy` — the detach / re-pin decisions: detach during a user
  scroll, detach when a run goes idle, and force a re-pin when a detached view sits at the
  actual bottom.

## When to use it

- You render an agent or chat transcript that streams and want follow-the-bottom behavior that
  survives height changes, history browsing, and blocked interaction.
- You want that behavior unit-testable without a window or scroll view.

## When not to use it

- You need ready-made transcript, composer, or tool-card views — none exist here yet.
- You need the agent runtime vocabulary (sessions, turns, events): that is AgentRuntimeKit.
- You need shared visual components or theme tokens: that is DesignKit.

Out of scope: views, view models, persistence, agent execution, and app navigation.

## Installation

```swift
dependencies: [
    // 0.1.0-beta.1 is a prerelease identifier — SwiftPM only resolves
    // prerelease tags when the lower bound itself names one.
    .package(url: "https://github.com/ajmcclary/AgentUIKit.git", .upToNextMinor(from: "0.1.0-beta.1"))
]
```

```swift
.target(
    name: "MyAgentUI",
    dependencies: [.product(name: "AgentUIKit", package: "AgentUIKit")]
)
```

## Usage

Decide, from two geometry samples taken during a user scroll, whether to stop following the live
bottom:

```swift
import CoreGraphics
import AgentUIKit

func shouldStopFollowing(
    old: AgentTranscriptScrollMetrics,
    new: AgentTranscriptScrollMetrics,
    sessionStart: AgentTranscriptScrollMetrics
) -> Bool {
    // Zero out distance changes that come from content or viewport relayout.
    let distanceDelta = AgentTranscriptScrollProgressPolicy.effectiveDistanceDeltaForManualScroll(
        oldMetrics: old, newMetrics: new, layoutMutationThreshold: 1)
    let intent = AgentTranscriptUserScrollIntentResolver.resolvePinnedLiveBottomFollowIntent(
        distanceDelta: distanceDelta,
        visibleMinYDelta: new.visibleMinY - old.visibleMinY,
        distanceThreshold: 4,
        visibleMinYThreshold: 4)

    let runtime = AgentTranscriptScrollRuntimeState(
        armingState: .armed,
        isPinnedToLiveBottom: true, isDetachedFromLiveBottom: false,
        isUserInteractingWithScroll: true, isInteractionBlocked: false,
        isRehydrateRestoreActive: false, isProgrammaticScrollInFlight: false,
        canScrollTowardHistory: true, canScrollTowardLiveBottom: false,
        distanceToBottom: new.distanceToBottom)
    let progress = AgentTranscriptViewportProgress(
        baselineDistanceToBottom: sessionStart.distanceToBottom,
        currentDistanceToBottom: new.distanceToBottom,
        baselineVisibleMinY: sessionStart.visibleMinY,
        currentVisibleMinY: new.visibleMinY)

    return AgentTranscriptAutoFollowRearmPolicy.shouldDetachFromLiveBottom(
        runtime: runtime, latestManualIntent: intent, progress: progress,
        minimumViewportEscapeDistance: 24,
        suppressGeometryDetach: false, suppressRepinGraceDetach: false)
}
```

Thresholds are in points and are the host's choice; the values above are illustrative.

## Requirements

- Swift tools 6.0, Swift 6 language mode with strict concurrency.
- macOS 27. Foundation and CoreGraphics only.
- Dependencies: none.

## Stability

Pre-1.0 (`0.x` beta): the public API may change between minor versions; pin `.upToNextMinor`.

## Development

`swift build` / `swift test` — fast; the characterization suites pin behavior when streaming
content changes height, the user browses history, and interaction blocks re-pinning.

## Origin

Extracted from the RepoPrompt app.

## License

Apache License 2.0 — see [LICENSE](LICENSE).
