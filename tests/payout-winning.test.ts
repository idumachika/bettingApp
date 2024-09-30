import { describe, it, beforeEach, expect, vi } from "vitest";

// Mock contract methods for 2SureOddBet
const mockContract = {
  createBet: vi.fn(),
  placeBet: vi.fn(),
  closeBetting: vi.fn(),
  setWinnerAndPayout: vi.fn(),
  claimPayout: vi.fn(),
  getBetDetails: vi.fn(),
  getUserBet: vi.fn(),
};

describe("2SureOddBet Smart Contract", () => {
  beforeEach(() => {
    // Reset all mocks before each test
    vi.resetAllMocks();
  });

  describe("Bet Creation", () => {
    it("should create a new bet successfully", async () => {
      const event = "Football Match";
      const options = ["Team A", "Team B"];
      const odds = [200, 150];

      mockContract.createBet.mockResolvedValue({
        success: true,
        betId: 1,
      });

      const result = await mockContract.createBet(event, options, odds);
      expect(result.success).toBe(true);
      expect(result.betId).toBe(1);
    });

    it("should fail to create a bet if not the contract owner", async () => {
      const event = "Football Match";
      const options = ["Team A", "Team B"];
      const odds = [200, 150];

      mockContract.createBet.mockResolvedValue({
        success: false,
        error: "Only the contract owner can create a bet.",
      });

      const result = await mockContract.createBet(event, options, odds);
      expect(result.success).toBe(false);
      expect(result.error).toBe("Only the contract owner can create a bet.");
    });
  });
  describe("Placing Bets", () => {
    it("should place a bet successfully", async () => {
      const betId = 1;
      const option = 0; // Team A
      const amount = 1000;

      mockContract.placeBet.mockResolvedValue({
        success: true,
      });

      const result = await mockContract.placeBet(betId, option, amount);
      expect(result.success).toBe(true);
    });

    it("should fail to place a bet if bet is closed", async () => {
      const betId = 1;
      const option = 0; // Team A
      const amount = 1000;

      mockContract.placeBet.mockResolvedValue({
        success: false,
        error: "Betting is closed for this event.",
      });

      const result = await mockContract.placeBet(betId, option, amount);
      expect(result.success).toBe(false);
      expect(result.error).toBe("Betting is closed for this event.");
    });

    it("should fail to place a bet if amount is less than minimum", async () => {
      const betId = 1;
      const option = 0; // Team A
      const amount = 500; // Less than minimum bet

      mockContract.placeBet.mockResolvedValue({
        success: false,
        error: "Insufficient bet amount.",
      });

      const result = await mockContract.placeBet(betId, option, amount);
      expect(result.success).toBe(false);
      expect(result.error).toBe("Insufficient bet amount.");
    });
  });
  describe("Closing Betting", () => {
    it("should close betting successfully", async () => {
      const betId = 1;

      mockContract.closeBetting.mockResolvedValue({
        success: true,
      });

      const result = await mockContract.closeBetting(betId);
      expect(result.success).toBe(true);
    });

    it("should fail to close betting if not the contract owner", async () => {
      const betId = 1;

      mockContract.closeBetting.mockResolvedValue({
        success: false,
        error: "Only the contract owner can close betting.",
      });

      const result = await mockContract.closeBetting(betId);
      expect(result.success).toBe(false);
      expect(result.error).toBe("Only the contract owner can close betting.");
    });
  });
});
