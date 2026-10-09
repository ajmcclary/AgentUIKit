import Foundation
import CoreGraphics

public struct AgentTranscriptScrollRuntimeState: Sendable {
	public let armingState: AgentTranscriptAutoFollowArmingState
	public let isPinnedToLiveBottom: Bool
	public let isDetachedFromLiveBottom: Bool
	public let isUserInteractingWithScroll: Bool
	public let isInteractionBlocked: Bool
	public let isRehydrateRestoreActive: Bool
	public let isProgrammaticScrollInFlight: Bool
	public let canScrollTowardHistory: Bool
	public let canScrollTowardLiveBottom: Bool
	public let distanceToBottom: CGFloat

	public init(
		armingState: AgentTranscriptAutoFollowArmingState,
		isPinnedToLiveBottom: Bool,
		isDetachedFromLiveBottom: Bool,
		isUserInteractingWithScroll: Bool,
		isInteractionBlocked: Bool,
		isRehydrateRestoreActive: Bool,
		isProgrammaticScrollInFlight: Bool,
		canScrollTowardHistory: Bool,
		canScrollTowardLiveBottom: Bool,
		distanceToBottom: CGFloat
	) {
		self.armingState = armingState
		self.isPinnedToLiveBottom = isPinnedToLiveBottom
		self.isDetachedFromLiveBottom = isDetachedFromLiveBottom
		self.isUserInteractingWithScroll = isUserInteractingWithScroll
		self.isInteractionBlocked = isInteractionBlocked
		self.isRehydrateRestoreActive = isRehydrateRestoreActive
		self.isProgrammaticScrollInFlight = isProgrammaticScrollInFlight
		self.canScrollTowardHistory = canScrollTowardHistory
		self.canScrollTowardLiveBottom = canScrollTowardLiveBottom
		self.distanceToBottom = distanceToBottom
	}

}

public struct AgentTranscriptViewportProgress: Sendable {
	public let baselineDistanceToBottom: CGFloat
	public let currentDistanceToBottom: CGFloat
	public let baselineVisibleMinY: CGFloat
	public let currentVisibleMinY: CGFloat

	public init(
		baselineDistanceToBottom: CGFloat,
		currentDistanceToBottom: CGFloat,
		baselineVisibleMinY: CGFloat,
		currentVisibleMinY: CGFloat
	) {
		self.baselineDistanceToBottom = baselineDistanceToBottom
		self.currentDistanceToBottom = currentDistanceToBottom
		self.baselineVisibleMinY = baselineVisibleMinY
		self.currentVisibleMinY = currentVisibleMinY
	}

}

public enum AgentTranscriptAutoFollowArmingState: String, Codable, Sendable, Equatable {
    case armed
    case disarmedAfterManualDetach
}

public struct AgentTranscriptScrollMetrics: Equatable, Sendable {
    public var distanceToBottom: CGFloat
    public var visibleMinY: CGFloat
    public var contentHeight: CGFloat
    public var viewportHeight: CGFloat
    public init(distanceToBottom: CGFloat = 0, visibleMinY: CGFloat = 0,
                contentHeight: CGFloat = 0, viewportHeight: CGFloat = 0) {
        self.distanceToBottom = distanceToBottom; self.visibleMinY = visibleMinY
        self.contentHeight = contentHeight; self.viewportHeight = viewportHeight
    }
}

public enum DetachedManualScrollDirection: String, Equatable, Sendable {
    case towardHistory
    case towardLiveBottom
    case unknown
    public var debugLabel: String { rawValue }
}
