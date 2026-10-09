# AgentUIKit

Shared Agent Mode presentation infrastructure. The initial extraction owns
transcript auto-follow, manual scroll intent, geometry progress, and detach/repin
policy from RepoPrompt. Policies consume value snapshots, not view models.

Swift 6 with strict concurrency, macOS 27. Build/test with `swift build` and
`swift test`. The characterization suites preserve behavior when streaming
content changes height, users browse history, and interaction blocks repinning.

Composer, session browser, tool cards, approvals, settings, and onboarding are
subsequent extraction slices; this initial release does not claim to provide
those views. Existing app chrome and product navigation stay host-owned.

Source lineage: RepoPrompt (`github.com/ajmcclary/RepoPrompt`), Apache-2.0.
